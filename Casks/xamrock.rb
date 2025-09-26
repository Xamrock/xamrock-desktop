cask "xamrock" do
  version "0.1.15"
  sha256 "0aac96b1ed655e3e5370044667674cde0ddcad6aa98d3282fb8abe97b5cf23e4"

  url "https://github.com/xamrock/xamrock-desktop/releases/download/#{version}/Xamrock-#{version}.dmg"
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