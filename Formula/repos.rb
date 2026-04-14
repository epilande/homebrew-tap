class Repos < Formula
  desc "A CLI tool for managing multiple git repositories"
  homepage "https://github.com/epilande/repos"
  version "1.0.2"
  license "MIT"

  on_macos do
    if Hardware::CPU.arm?
      url "https://github.com/epilande/repos/releases/download/v1.0.2/repos-macos-arm64"
      sha256 "f05efa53e2c7b339d6653c04fbf6f952bd56976a394522d3dfd931a9957299f9"
    else
      url "https://github.com/epilande/repos/releases/download/v1.0.2/repos-macos-x64"
      sha256 "df6540ccaa8d57f6d78501d34baa283f14c054a279e1833c55a54afe044b858d"
    end
  end

  on_linux do
    url "https://github.com/epilande/repos/releases/download/v1.0.2/repos-linux-x64"
    sha256 "d5521cde9d97117a0d380b749e456a423bd23abc8f2969ad50c388364227767d"
  end

  def install
    binary_name = stable.url.split("/").last
    bin.install binary_name => "repos"
  end

  test do
    system "#{bin}/repos", "--version"
  end
end
