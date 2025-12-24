class Repos < Formula
  desc "A CLI tool for managing multiple git repositories"
  homepage "https://github.com/epilande/repos"
  version "1.0.0"
  license "MIT"

  on_macos do
    if Hardware::CPU.arm?
      url "https://github.com/epilande/repos/releases/download/v1.0.0/repos-macos-arm64"
      sha256 "03efd4e3bb980350c9efe439c205ae23b435037ec8498500ad885941226407ab"
    else
      url "https://github.com/epilande/repos/releases/download/v1.0.0/repos-macos-x64"
      sha256 "9ac3d63921386dcc2b86bfaf8a8ab1c9a63dc6568115445e8dc822aa2daeff32"
    end
  end

  on_linux do
    url "https://github.com/epilande/repos/releases/download/v1.0.0/repos-linux-x64"
    sha256 "bf3720a7bfec9301654a2367f9d7b40495f22b33c2a1d45cbef181bffd01c799"
  end

  def install
    binary_name = stable.url.split("/").last
    bin.install binary_name => "repos"
  end

  test do
    system "#{bin}/repos", "--version"
  end
end
