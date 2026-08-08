class Ccmux < Formula
  desc "Monitor AI coding agent sessions running in tmux"
  homepage "https://github.com/epilande/ccmux"
  version "1.3.0"
  license "MIT"

  on_macos do
    # Actionable-notification backend: the signed + notarized ccmux-notifier
    # helper app, staged into libexec below. Gives real ccmux identity,
    # Approve/Deny buttons, inline reply, per-session grouping, and retraction
    # (ccmux falls back to osascript without it).
    resource "notifier" do
      url "https://github.com/epilande/ccmux/releases/download/v1.3.0/ccmux-notifier.zip"
      sha256 "ff364997a2c0e52384dbd38e15dc3a0c0b0b43487e6c1cbe6e2c633f2cd59ea8"
    end

    if Hardware::CPU.arm?
      url "https://github.com/epilande/ccmux/releases/download/v1.3.0/ccmux-macos-arm64"
      sha256 "09e43bd50a7479f444bf9139ad094f41ad3d24545414491a35734333d274dc01"
    else
      url "https://github.com/epilande/ccmux/releases/download/v1.3.0/ccmux-macos-x64"
      sha256 "1f7aa90bb8504ea7ce8002d0a40e2a923d2f791fe437e5aa319b24c5557f2b01"
    end
  end

  on_linux do
    url "https://github.com/epilande/ccmux/releases/download/v1.3.0/ccmux-linux-x64"
    sha256 "25d05e40703b579eb83b26427b69e03f4b394ff7276c01d07035481a0f94ed2e"
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
