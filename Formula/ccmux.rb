class Ccmux < Formula
  desc "Monitor AI coding agent sessions running in tmux"
  homepage "https://github.com/epilande/ccmux"
  version "1.4.1"
  license "MIT"

  on_macos do
    # Actionable-notification backend: the signed + notarized ccmux-notifier
    # helper app, staged into libexec below. Gives real ccmux identity,
    # Approve/Deny buttons, inline reply, per-session grouping, and retraction
    # (ccmux falls back to osascript without it).
    resource "notifier" do
      url "https://github.com/epilande/ccmux/releases/download/v1.4.1/ccmux-notifier.zip"
      sha256 "ed0e1b2d8d9d0c0908249125ec3f3ed96908eda54d244efcc4c7f3c6bbf73411"
    end

    if Hardware::CPU.arm?
      url "https://github.com/epilande/ccmux/releases/download/v1.4.1/ccmux-macos-arm64"
      sha256 "e02a6f8336c7afac626b602c5ee7deaedef94ef5b87f767f136897c166f0dac3"
    else
      url "https://github.com/epilande/ccmux/releases/download/v1.4.1/ccmux-macos-x64"
      sha256 "44f8b9de0a80ca4805fed878422265593a06dcc39e24cd5eb134416c211b2549"
    end
  end

  on_linux do
    url "https://github.com/epilande/ccmux/releases/download/v1.4.1/ccmux-linux-x64"
    sha256 "fb80f9569ebaed64bb2dd1fa5968507ad5d33c50b88421c07fc6f629bd9dc8d6"
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
