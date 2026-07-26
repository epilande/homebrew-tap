class Ccmux < Formula
  desc "Monitor AI coding agent sessions running in tmux"
  homepage "https://github.com/epilande/ccmux"
  version "1.2.1"
  license "MIT"

  on_macos do
    # Actionable-notification backend: the signed + notarized ccmux-notifier
    # helper app, staged into libexec below. Gives real ccmux identity,
    # Approve/Deny buttons, inline reply, per-session grouping, and retraction
    # (ccmux falls back to osascript without it).
    resource "notifier" do
      url "https://github.com/epilande/ccmux/releases/download/v1.2.1/ccmux-notifier.zip"
      sha256 "2e12fe456b52d2bf4399ce8a0b910b4baef1a382de1dcf033dc03bcc3d2025b7"
    end

    if Hardware::CPU.arm?
      url "https://github.com/epilande/ccmux/releases/download/v1.2.1/ccmux-macos-arm64"
      sha256 "3f02ef84f2546f491875840e7fbe346661159d921087f8e327b0ff7db71add46"
    else
      url "https://github.com/epilande/ccmux/releases/download/v1.2.1/ccmux-macos-x64"
      sha256 "b89c64495ca1679658cbda3d50cdb188247f17a486ae5fc46245cc5c04b5f90b"
    end
  end

  on_linux do
    url "https://github.com/epilande/ccmux/releases/download/v1.2.1/ccmux-linux-x64"
    sha256 "24cd0e1bad80d221678d9032e00db182cd5f3480064cf401e4930e172cb5e08f"
  end

  def install
    binary_name = stable.url.split("/").last
    bin.install binary_name => "ccmux"

    # Stage the notarized helper app alongside the binary. The ccmux daemon
    # resolves it at ../libexec/ccmux-notifier.app relative to bin/ccmux.
    # Homebrew strips a sole top-level directory when unpacking, so the
    # staged tree is usually the bundle's *contents* (Contents/...) and the
    # bundle must be reconstructed around them; the branch also handles an
    # unstripped archive in case that behavior ever changes.
    if OS.mac?
      resource("notifier").stage do
        if File.directory?("ccmux-notifier.app")
          libexec.install "ccmux-notifier.app"
        else
          (libexec/"ccmux-notifier.app").install Dir["*"]
        end
      end
    end
  end

  test do
    system "#{bin}/ccmux", "--version"
  end
end
