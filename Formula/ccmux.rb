class Ccmux < Formula
  desc "Monitor AI coding agent sessions running in tmux"
  homepage "https://github.com/epilande/ccmux"
  version "1.4.0"
  license "MIT"

  on_macos do
    # Actionable-notification backend: the signed + notarized ccmux-notifier
    # helper app, staged into libexec below. Gives real ccmux identity,
    # Approve/Deny buttons, inline reply, per-session grouping, and retraction
    # (ccmux falls back to osascript without it).
    resource "notifier" do
      url "https://github.com/epilande/ccmux/releases/download/v1.4.0/ccmux-notifier.zip"
      sha256 "c9ef9f2d2962e403be0494e525169ed353dc44602878321def2c633bd1ff4fea"
    end

    if Hardware::CPU.arm?
      url "https://github.com/epilande/ccmux/releases/download/v1.4.0/ccmux-macos-arm64"
      sha256 "95e4f410ee8c71d8693ef42515d26b824a94fd34838b4170f5df2db1f4ba2d0b"
    else
      url "https://github.com/epilande/ccmux/releases/download/v1.4.0/ccmux-macos-x64"
      sha256 "d5742fb13bad2719c28acd7d4290381fc11297a732e28d99f068a3e12a0da188"
    end
  end

  on_linux do
    url "https://github.com/epilande/ccmux/releases/download/v1.4.0/ccmux-linux-x64"
    sha256 "f2b4b527d17fd91388c8b5dfb33c2cd69a489427d84fe7ee096bb48507e436aa"
  end

  def install
    binary_name = stable.url.split("/").last
    bin.install binary_name => "ccmux"

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
