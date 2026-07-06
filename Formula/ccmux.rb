class Ccmux < Formula
  desc "Monitor AI coding agent sessions running in tmux"
  homepage "https://github.com/epilande/ccmux"
  version "1.0.0"
  license "MIT"

  on_macos do
    if Hardware::CPU.arm?
      url "https://github.com/epilande/ccmux/releases/download/v1.0.0/ccmux-macos-arm64"
      sha256 "bed24d6e4bfcab2ca2afa5755c25449fe789877ee35b52f91b32b22f211cdc85"
    else
      url "https://github.com/epilande/ccmux/releases/download/v1.0.0/ccmux-macos-x64"
      sha256 "8ba3117bcf1cf032beb8d2d5a60c046431bf359425c352991e5d760060b0317e"
    end
  end

  on_linux do
    url "https://github.com/epilande/ccmux/releases/download/v1.0.0/ccmux-linux-x64"
    sha256 "49f1a8c00a84839d182cae95dafabb3d6986016b6a29393d8f54b842b87606a9"
  end

  def install
    binary_name = stable.url.split("/").last
    bin.install binary_name => "ccmux"
  end

  test do
    system "#{bin}/ccmux", "--version"
  end
end
