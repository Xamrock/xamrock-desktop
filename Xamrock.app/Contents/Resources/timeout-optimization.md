# Timeout Optimization Strategies for Xamrock

## Problem Analysis
The project experiences timeouts when making multiple tool calls due to:
1. Sequential tool execution creating cumulative delays
2. Fixed timeout values not accounting for tool complexity
3. Context management overhead between tool calls
4. Network latency accumulation across multiple API requests

## Recommended Solutions

### 1. Parallel Tool Execution
```swift
// In ChatManager.executeToolCalls
private func executeToolCallsParallel(_ toolCalls: [ToolCall]) async -> [ToolResult] {
    await withTaskGroup(of: (Int, ToolResult).self) { group in
        var results: [ToolResult?] = Array(repeating: nil, count: toolCalls.count)
        
        // Launch all tool calls concurrently
        for (index, toolCall) in toolCalls.enumerated() {
            group.addTask {
                let result = await self.executeSingleTool(toolCall)
                return (index, result)
            }
        }
        
        // Collect results in order
        for await (index, result) in group {
            results[index] = result
        }
        
        return results.compactMap { $0 }
    }
}
```

### 2. Dynamic Timeout Calculation
```swift
private func calculateTimeout(for toolCalls: [ToolCall]) -> TimeInterval {
    let baseTimeout: TimeInterval = 60
    let perToolTimeout: TimeInterval = 30
    let maxTimeout: TimeInterval = 900 // 15 minutes
    
    let toolComplexity = toolCalls.reduce(0) { total, toolCall in
        switch toolCall.name {
        case "shell_execute", "project_analyze": return total + 60
        case "file_read", "file_write": return total + 15
        default: return total + 30
        }
    }
    
    return min(baseTimeout + toolComplexity, maxTimeout)
}
```

### 3. Streaming Progress Updates
```swift
// Enhanced progress reporting during tool execution
private func executeWithProgressReporting(_ toolCalls: [ToolCall]) async -> [ToolResult] {
    let totalSteps = toolCalls.count
    var completedSteps = 0
    
    return await withTaskGroup(of: ToolResult.self) { group in
        for toolCall in toolCalls {
            group.addTask {
                let result = await self.executeSingleToolWithProgress(toolCall) { progress in
                    // Update UI with individual tool progress
                    Task { @MainActor in
                        self.updateToolProgress(
                            completed: completedSteps,
                            total: totalSteps,
                            currentTool: toolCall.name,
                            toolProgress: progress
                        )
                    }
                }
                
                completedSteps += 1
                return result
            }
        }
        
        var results: [ToolResult] = []
        for await result in group {
            results.append(result)
        }
        return results
    }
}
```

### 4. Request Chunking Strategy
```swift
// Break large tool call sets into smaller chunks
private func executeToolCallsInChunks(_ toolCalls: [ToolCall], chunkSize: Int = 3) async -> [ToolResult] {
    var allResults: [ToolResult] = []
    
    for chunk in toolCalls.chunked(into: chunkSize) {
        let chunkResults = await executeToolCallsParallel(chunk)
        allResults.append(contentsOf: chunkResults)
        
        // Brief pause between chunks to prevent overwhelming the system
        try? await Task.sleep(nanoseconds: 100_000_000) // 100ms
    }
    
    return allResults
}
```

### 5. Enhanced Error Recovery
```swift
private func executeToolWithRetry(_ toolCall: ToolCall, maxRetries: Int = 2) async -> ToolResult {
    var lastError: Error?
    
    for attempt in 1...maxRetries {
        do {
            return try await mcpServerManager.executeTool(
                name: toolCall.name,
                arguments: toolCall.arguments
            ).get()
        } catch {
            lastError = error
            
            // Exponential backoff
            let delay = TimeInterval(attempt * attempt) * 0.5
            try? await Task.sleep(nanoseconds: UInt64(delay * 1_000_000_000))
        }
    }
    
    return ToolResult(
        toolCallId: toolCall.id,
        content: "Error after \(maxRetries) attempts: \(lastError?.localizedDescription ?? "Unknown error")",
        isError: true
    )
}
```

### 6. Memory-Efficient Context Management
```swift
// Optimize context updates to reduce overhead
private func batchUpdateContext(toolResults: [ToolResult]) {
    contextManager.beginBatchUpdate()
    
    for result in toolResults {
        contextManager.addToolResponse(
            tool: result.toolName ?? "unknown",
            output: result.content,
            success: !result.isError
        )
    }
    
    contextManager.commitBatchUpdate()
}
```

## Implementation Priority

1. **High Priority**: Implement parallel tool execution
2. **Medium Priority**: Add dynamic timeout calculation
3. **Medium Priority**: Enhance progress reporting
4. **Low Priority**: Add request chunking for very large tool sets

## Configuration Options

Add user-configurable timeout settings:
```swift
@AppStorage("maxToolExecutionTime") var maxToolExecutionTime: TimeInterval = 600
@AppStorage("enableParallelToolExecution") var enableParallelToolExecution: Bool = true
@AppStorage("toolExecutionChunkSize") var toolExecutionChunkSize: Int = 3
```

## Monitoring and Debugging

Add comprehensive logging for timeout analysis:
```swift
private func logToolExecutionMetrics(_ toolCalls: [ToolCall], executionTime: TimeInterval) {
    DebugManager.shared.log(
        .performance,
        title: "Tool Execution Completed",
        content: """
        Tools executed: \(toolCalls.count)
        Total time: \(executionTime)s
        Average per tool: \(executionTime / Double(toolCalls.count))s
        Tool breakdown: \(toolCalls.map { "\($0.name)" }.joined(separator: ", "))
        """,
        metadata: [
            "toolCount": toolCalls.count,
            "executionTime": executionTime,
            "toolNames": toolCalls.map { $0.name }
        ]
    )
}
```