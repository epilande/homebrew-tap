class Ccmux < Formula
  desc "Monitor AI coding agent sessions running in tmux"
  homepage "https://github.com/epilande/ccmux"
  version "1.4.3"
  license "MIT"

  on_macos do
    # Actionable-notification backend: the signed + notarized ccmux-notifier
    # helper app, staged into libexec below. Gives real ccmux identity,
    # Approve/Deny buttons, inline reply, per-session grouping, and retraction
    # (ccmux falls back to osascript without it).
    resource "notifier" do
      url "https://github.com/epilande/ccmux/releases/download/v1.4.3/ccmux-notifier.zip"
      sha256 "58a4f3d0b285b5cb8198e7ff7379be8b7d7502d391cf3c0c8315e15b5ca5d488"
    end

    if Hardware::CPU.arm?
      url "https://github.com/epilande/ccmux/releases/download/v1.4.3/ccmux-macos-arm64"
      sha256 "70503b601816df4b2756f9f7d78de14a18a3b3cb7452fc8fbc2ca96c134d98e4"
    else
      url "https://github.com/epilande/ccmux/releases/download/v1.4.3/ccmux-macos-x64"
      sha256 "1392f1f4f4722fc2d2b6552d4acdde0cdd1d392f6c3e4cca06386691ccccd6ff"
    end
  end

  on_linux do
    url "https://github.com/epilande/ccmux/releases/download/v1.4.3/ccmux-linux-x64"
    sha256 "ff5085a68005ffd3862e2f1d46ba7aca51c2ba67bfc3a9b1da1d1da040f6d916"
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
