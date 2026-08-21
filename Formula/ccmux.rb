class Ccmux < Formula
  desc "Monitor AI coding agent sessions running in tmux"
  homepage "https://github.com/epilande/ccmux"
  version "1.3.1"
  license "MIT"

  on_macos do
    # Actionable-notification backend: the signed + notarized ccmux-notifier
    # helper app, staged into libexec below. Gives real ccmux identity,
    # Approve/Deny buttons, inline reply, per-session grouping, and retraction
    # (ccmux falls back to osascript without it).
    resource "notifier" do
      url "https://github.com/epilande/ccmux/releases/download/v1.3.1/ccmux-notifier.zip"
      sha256 "4959c3f909b95a20ec9a9f9861bdd971c17fb2319ddb6398926713cafa879d86"
    end

    if Hardware::CPU.arm?
      url "https://github.com/epilande/ccmux/releases/download/v1.3.1/ccmux-macos-arm64"
      sha256 "e7f1957c348c88c6f9450b7afc5074e9685faa1f7ca05ddf5986af03fceadfe9"
    else
      url "https://github.com/epilande/ccmux/releases/download/v1.3.1/ccmux-macos-x64"
      sha256 "3fcb5267dead1b6b67d1b0c2bea3b4c8a33a401a80861d8f003763ba499187fe"
    end
  end

  on_linux do
    url "https://github.com/epilande/ccmux/releases/download/v1.3.1/ccmux-linux-x64"
    sha256 "c8f35112d1e38829b3a7303efb7ad1ed95fbecc74a935cd4dd64ba63f59608dc"
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
