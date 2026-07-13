class Ccmux < Formula
  desc "Monitor AI coding agent sessions running in tmux"
  homepage "https://github.com/epilande/ccmux"
  version "1.1.0"
  license "MIT"

  on_macos do
    if Hardware::CPU.arm?
      url "https://github.com/epilande/ccmux/releases/download/v1.1.0/ccmux-macos-arm64"
      sha256 "852419bfb8904584bf703d4f53f8de6a8980859ca73883b2b5da9274342397ed"
    else
      url "https://github.com/epilande/ccmux/releases/download/v1.1.0/ccmux-macos-x64"
      sha256 "9a3c81c435c1e7c58d94db415c6c42088ab147610a7d5572afc4eadc4afa4ac3"
    end
  end

  on_linux do
    url "https://github.com/epilande/ccmux/releases/download/v1.1.0/ccmux-linux-x64"
    sha256 "78d90440780d602d7ea3c1ab09576446cda8dd187f8898033c7aed81987a6397"
  end

  def install
    binary_name = stable.url.split("/").last
    bin.install binary_name => "ccmux"
  end

  test do
    system "#{bin}/ccmux", "--version"
  end
end
