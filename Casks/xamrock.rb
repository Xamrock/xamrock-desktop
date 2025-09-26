cask "xamrock" do
  version "0.1.14"
  sha256 "0d522a0b79f78c8c309ef0f1151151dea8f3ff035a747feeddd8eaff7a669ece"

  url "https://github.com/xamrock/xamrock-desktop/releases/download/#{version}/Xamrock-#{version}.zip"
  name "Xamrock"
  desc "Context Engineering IDE - AI-powered development environment"
  homepage "https://xamrock.com"

  livecheck do
    url :url
    strategy :github_latest
  end

  depends_on macos: ">= :sonoma"

  app "Xamrock.app"

  zap trash: [
    "~/Library/Application Support/Xamrock",
    "~/Library/Caches/com.kiloloco.xamrock-client",
    "~/Library/Preferences/com.kiloloco.xamrock-client.plist",
    "~/Library/Saved Application State/com.kiloloco.xamrock-client.savedState",
  ]
end