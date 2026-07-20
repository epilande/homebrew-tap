class Ccmux < Formula
  desc "Monitor AI coding agent sessions running in tmux"
  homepage "https://github.com/epilande/ccmux"
  version "1.2.0"
  license "MIT"

  on_macos do
    # Actionable-notification backend: the signed + notarized ccmux-notifier
    # helper app, staged into libexec below. Gives real ccmux identity,
    # Approve/Deny buttons, inline reply, per-session grouping, and retraction
    # (ccmux falls back to osascript without it).
    resource "notifier" do
      url "https://github.com/epilande/ccmux/releases/download/v1.2.0/ccmux-notifier.zip"
      sha256 "789a0430e02d51ddb339ffb8fe2a441894111db20505029171dc9cea7faafbdb"
    end

    if Hardware::CPU.arm?
      url "https://github.com/epilande/ccmux/releases/download/v1.2.0/ccmux-macos-arm64"
      sha256 "c3aaff256f79998e4a05aa44819e21de5c6c0ec77edcc7e2b2caa7bb6092f7d1"
    else
      url "https://github.com/epilande/ccmux/releases/download/v1.2.0/ccmux-macos-x64"
      sha256 "058b3de0388463c7d9201958192b82a123d5c05a39e1c2580a44b6411979292c"
    end
  end

  on_linux do
    url "https://github.com/epilande/ccmux/releases/download/v1.2.0/ccmux-linux-x64"
    sha256 "731406d4355fb522cdbd1600a745f140126c7bfc001632045a130defee17a6f7"
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
