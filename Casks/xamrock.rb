cask "xamrock" do
  version "0.1.13"
  sha256 "807c7678ae725f17d2814f11affb1c85ed07db0bb1570c18bd369f89c25b2fe5"

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