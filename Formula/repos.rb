class Repos < Formula
  desc "A CLI tool for managing multiple git repositories"
  homepage "https://github.com/epilande/repos"
  version "1.0.1"
  license "MIT"

  on_macos do
    if Hardware::CPU.arm?
      url "https://github.com/epilande/repos/releases/download/v1.0.1/repos-macos-arm64"
      sha256 "47f4b150a42aaf6ee5bbd92c5beb256183f78784052a738fcc9bf50a012fafc4"
    else
      url "https://github.com/epilande/repos/releases/download/v1.0.1/repos-macos-x64"
      sha256 "bbd6ffd930d3f6ce7695c08a6eb61a26c40efc3e02b54c44169bd9ff65220297"
    end
  end

  on_linux do
    url "https://github.com/epilande/repos/releases/download/v1.0.1/repos-linux-x64"
    sha256 "1e669eac8494131700ab93b9413c167792d051bf3a074dd7b308900527e91b3c"
  end

  def install
    binary_name = stable.url.split("/").last
    bin.install binary_name => "repos"
  end

  test do
    system "#{bin}/repos", "--version"
  end
end
