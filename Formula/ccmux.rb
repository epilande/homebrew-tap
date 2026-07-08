class Ccmux < Formula
  desc "Monitor AI coding agent sessions running in tmux"
  homepage "https://github.com/epilande/ccmux"
  version "1.0.2"
  license "MIT"

  on_macos do
    if Hardware::CPU.arm?
      url "https://github.com/epilande/ccmux/releases/download/v1.0.2/ccmux-macos-arm64"
      sha256 "e0f84cfeef264de6d5aacdc9cf96046ee9b476fab80a0afc08c3534603436a56"
    else
      url "https://github.com/epilande/ccmux/releases/download/v1.0.2/ccmux-macos-x64"
      sha256 "d3606702d0b1fda57de35f77ba2e09698d420578a28429c428dfce983e7f8f25"
    end
  end

  on_linux do
    url "https://github.com/epilande/ccmux/releases/download/v1.0.2/ccmux-linux-x64"
    sha256 "9de3c8787d64808ad1764aa914ef27da699c568bacfe4767b666eb7e9d8d66dc"
  end

  def install
    binary_name = stable.url.split("/").last
    bin.install binary_name => "ccmux"
  end

  test do
    system "#{bin}/ccmux", "--version"
  end
end
