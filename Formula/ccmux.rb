class Ccmux < Formula
  desc "Monitor AI coding agent sessions running in tmux"
  homepage "https://github.com/epilande/ccmux"
  version "1.4.5"
  license "MIT"

  on_macos do
    # Actionable-notification backend: the signed + notarized ccmux-notifier
    # helper app, staged into libexec below. Gives real ccmux identity,
    # Approve/Deny buttons, inline reply, per-session grouping, and retraction
    # (ccmux falls back to osascript without it).
    resource "notifier" do
      url "https://github.com/epilande/ccmux/releases/download/v1.4.5/ccmux-notifier.zip"
      sha256 "a11ea488637a8c43fe113d12e1774ff8dfb9c2a48e717939bac7ed0e97234a45"
    end

    if Hardware::CPU.arm?
      url "https://github.com/epilande/ccmux/releases/download/v1.4.5/ccmux-macos-arm64"
      sha256 "d020ed45d3b1c8c808b9473398e6550dca7886642df4533d64508165764a1db1"
    else
      url "https://github.com/epilande/ccmux/releases/download/v1.4.5/ccmux-macos-x64"
      sha256 "c177cce4fc7700489347a297c02d83bcff0038a5b390664b938537e6506163e7"
    end
  end

  on_linux do
    url "https://github.com/epilande/ccmux/releases/download/v1.4.5/ccmux-linux-x64"
    sha256 "f294d9241b9bbdde2777e1dbdbb8143bbf8607fac9b2bcdede5ce8506331d0b6"
  end

  def install
    binary_name = stable.url.split("/").last
    bin.install binary_name => "ccmux"
    # The release asset is a bare binary, downloaded as 0644. Homebrew only
    # fixes bin/ permissions after  returns, so make it executable
    # here or the completion step below fails with EACCES.
    chmod 0755, bin/"ccmux"

    # `ccmux completion <shell>` only prints a static script: no daemon,
    # tmux, or HOME involved, so it is safe to run in the build sandbox.
    generate_completions_from_executable(bin/"ccmux", "completion")

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
