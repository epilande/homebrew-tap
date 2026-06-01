class Repos < Formula
  desc "A CLI tool for managing multiple git repositories"
  homepage "https://github.com/epilande/repos"
  version "1.1.0"
  license "MIT"

  on_macos do
    if Hardware::CPU.arm?
      url "https://github.com/epilande/repos/releases/download/v1.1.0/repos-macos-arm64"
      sha256 "17f173dcca76cdccae691f3cfe2baf6d13652de011906b479081a62e6bd32107"
    else
      url "https://github.com/epilande/repos/releases/download/v1.1.0/repos-macos-x64"
      sha256 "daeb56222953d8f329a1f4bc73a60ba6552a02e4650a0b1cb3a8084df2c781f4"
    end
  end

  on_linux do
    url "https://github.com/epilande/repos/releases/download/v1.1.0/repos-linux-x64"
    sha256 "d15f8ab789b736dc8122dbf2db29cecd20290c4efa31dbc22128dd427bdc45ae"
  end

  def install
    binary_name = stable.url.split("/").last
    bin.install binary_name => "repos"
  end

  test do
    system "#{bin}/repos", "--version"
  end
end
