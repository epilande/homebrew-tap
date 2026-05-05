class Repos < Formula
  desc "A CLI tool for managing multiple git repositories"
  homepage "https://github.com/epilande/repos"
  version "1.0.3"
  license "MIT"

  on_macos do
    if Hardware::CPU.arm?
      url "https://github.com/epilande/repos/releases/download/v1.0.3/repos-macos-arm64"
      sha256 "e05ec4dbb5e8b45f8847b3858877426e40e42753be1e7a8e4a94bde36ad33f09"
    else
      url "https://github.com/epilande/repos/releases/download/v1.0.3/repos-macos-x64"
      sha256 "aae6319938cf818be86166c341d86f28eae0ae5e12a7ad62d492e4d657032f4f"
    end
  end

  on_linux do
    url "https://github.com/epilande/repos/releases/download/v1.0.3/repos-linux-x64"
    sha256 "d8a4d9f76af51113979548229c68b0d612522acd8cf679ac5ad7742261c54935"
  end

  def install
    binary_name = stable.url.split("/").last
    bin.install binary_name => "repos"
  end

  test do
    system "#{bin}/repos", "--version"
  end
end
