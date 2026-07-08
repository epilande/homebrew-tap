class Ccmux < Formula
  desc "Monitor AI coding agent sessions running in tmux"
  homepage "https://github.com/epilande/ccmux"
  version "1.0.1"
  license "MIT"

  on_macos do
    if Hardware::CPU.arm?
      url "https://github.com/epilande/ccmux/releases/download/v1.0.1/ccmux-macos-arm64"
      sha256 "84b3d49bf80231248af4a999198e5e27eb13c2a1302d9a862ba345f93685209a"
    else
      url "https://github.com/epilande/ccmux/releases/download/v1.0.1/ccmux-macos-x64"
      sha256 "7b6521d285e9fe899e6c3db02660a09826cbfde0e47f8500cffd4f11530bbda4"
    end
  end

  on_linux do
    url "https://github.com/epilande/ccmux/releases/download/v1.0.1/ccmux-linux-x64"
    sha256 "0c6f5ba96192caa3cf326cee6cd73d589012b3f0366ea186c63f83ab801c99f7"
  end

  def install
    binary_name = stable.url.split("/").last
    bin.install binary_name => "ccmux"
  end

  test do
    system "#{bin}/ccmux", "--version"
  end
end
