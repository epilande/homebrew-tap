class Ccmux < Formula
  desc "Monitor AI coding agent sessions running in tmux"
  homepage "https://github.com/epilande/ccmux"
  version "1.3.2"
  license "MIT"

  on_macos do
    # Actionable-notification backend: the signed + notarized ccmux-notifier
    # helper app, staged into libexec below. Gives real ccmux identity,
    # Approve/Deny buttons, inline reply, per-session grouping, and retraction
    # (ccmux falls back to osascript without it).
    resource "notifier" do
      url "https://github.com/epilande/ccmux/releases/download/v1.3.2/ccmux-notifier.zip"
      sha256 "08f36c250cfab36ec351b60235f51a85891e8e37b7f139d105bcccfa1dac0890"
    end

    if Hardware::CPU.arm?
      url "https://github.com/epilande/ccmux/releases/download/v1.3.2/ccmux-macos-arm64"
      sha256 "a88a9a95d8f1be48d04e6a192b472d5b5578768c6903c70d2685dc4cbb7e3366"
    else
      url "https://github.com/epilande/ccmux/releases/download/v1.3.2/ccmux-macos-x64"
      sha256 "21b5c19ea80e99b84a9ba05896c08547a9db02d2f270962fad74ef703cf0ff0d"
    end
  end

  on_linux do
    url "https://github.com/epilande/ccmux/releases/download/v1.3.2/ccmux-linux-x64"
    sha256 "2df88e7dc75b0635cbcdc69363904d1c151b5b3482fed7decbc73f03469051f9"
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
