class Ccmux < Formula
  desc "Monitor AI coding agent sessions running in tmux"
  homepage "https://github.com/epilande/ccmux"
  version "1.2.2"
  license "MIT"

  on_macos do
    # Actionable-notification backend: the signed + notarized ccmux-notifier
    # helper app, staged into libexec below. Gives real ccmux identity,
    # Approve/Deny buttons, inline reply, per-session grouping, and retraction
    # (ccmux falls back to osascript without it).
    resource "notifier" do
      url "https://github.com/epilande/ccmux/releases/download/v1.2.2/ccmux-notifier.zip"
      sha256 "f8e457be33419c364cbef4404926466e06577916f8bf79453e02b3bf9455df94"
    end

    if Hardware::CPU.arm?
      url "https://github.com/epilande/ccmux/releases/download/v1.2.2/ccmux-macos-arm64"
      sha256 "5962866369a23f96dcc0f5419a76d860107812ef6036a1b673fb40ccdfb62244"
    else
      url "https://github.com/epilande/ccmux/releases/download/v1.2.2/ccmux-macos-x64"
      sha256 "5ddc812adbfb96e91ebf608fea70ffd70f9aec2b3288604a3644eac0e0881364"
    end
  end

  on_linux do
    url "https://github.com/epilande/ccmux/releases/download/v1.2.2/ccmux-linux-x64"
    sha256 "81e3efd95f2a8c761c575b2351399959485ae2ca25cffc017c1723fba3d0cf81"
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
