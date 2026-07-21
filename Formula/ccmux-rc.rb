# Temporary release-candidate formula for testing pre-releases. Installs the
# same layout as the stable `ccmux` formula but from the RC tag; remove this
# file once the RC ships as a stable version. Conflicts with `ccmux` (same
# binary name) — `brew unlink ccmux` before installing.
class CcmuxRc < Formula
  desc "Monitor AI coding agent sessions running in tmux (release candidate)"
  homepage "https://github.com/epilande/ccmux"
  version "1.2.1-rc.1"
  license "MIT"

  conflicts_with "ccmux", because: "both install a `ccmux` binary"

  on_macos do
    # Actionable-notification backend: the signed + notarized ccmux-notifier
    # helper app, staged into libexec below. Gives real ccmux identity,
    # Approve/Deny buttons, inline reply, per-session grouping, and retraction
    # (ccmux falls back to osascript without it).
    resource "notifier" do
      url "https://github.com/epilande/ccmux/releases/download/v1.2.1-rc.1/ccmux-notifier.zip"
      sha256 "4fcfe6f853cbc05e4c75fa69486f6e8100f3079bbd0258fc757b8f8fd315f4f1"
    end

    if Hardware::CPU.arm?
      url "https://github.com/epilande/ccmux/releases/download/v1.2.1-rc.1/ccmux-macos-arm64"
      sha256 "38855152a86c269030d0e2fb87d47f28435c1851d91f97c8548dc1de92f3b0c5"
    else
      url "https://github.com/epilande/ccmux/releases/download/v1.2.1-rc.1/ccmux-macos-x64"
      sha256 "b5d6d798143905a59b721771ac3fef5c12c0a1787a40741ef60b32371c45c361"
    end
  end

  on_linux do
    url "https://github.com/epilande/ccmux/releases/download/v1.2.1-rc.1/ccmux-linux-x64"
    sha256 "a7b4f7674b61fda64cb4ac0c035bbb0d0d94e0c7eadd2743ff9b941fff09abc6"
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
