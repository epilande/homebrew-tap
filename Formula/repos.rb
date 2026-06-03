class Repos < Formula
  desc "A CLI tool for managing multiple git repositories"
  homepage "https://github.com/epilande/repos"
  version "1.1.1"
  license "MIT"

  on_macos do
    if Hardware::CPU.arm?
      url "https://github.com/epilande/repos/releases/download/v1.1.1/repos-macos-arm64"
      sha256 "a15977660a72716171445f467364888c17e76afd4f223b0ec2ab5ba45d5af28c"
    else
      url "https://github.com/epilande/repos/releases/download/v1.1.1/repos-macos-x64"
      sha256 "22547e276fc4838a668c68f156e786506c4e34c44c9419e7099c73da7cba4cc5"
    end
  end

  on_linux do
    url "https://github.com/epilande/repos/releases/download/v1.1.1/repos-linux-x64"
    sha256 "85628f24fc6120bb1895d09131dd3a43fcb55ae9d73cdb869bd8b8d20cd1b96c"
  end

  def install
    binary_name = stable.url.split("/").last
    bin.install binary_name => "repos"
  end

  test do
    system "#{bin}/repos", "--version"
  end
end
