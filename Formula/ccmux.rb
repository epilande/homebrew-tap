class Ccmux < Formula
  desc "Monitor AI coding agent sessions running in tmux"
  homepage "https://github.com/epilande/ccmux"
  version "1.4.8"
  license "MIT"

  on_macos do
    # Actionable-notification backend: the signed + notarized ccmux-notifier
    # helper app, staged into libexec below. Gives real ccmux identity,
    # Approve/Deny buttons, inline reply, per-session grouping, and retraction
    # (ccmux falls back to osascript without it).
    resource "notifier" do
      url "https://github.com/epilande/ccmux/releases/download/v1.4.8/ccmux-notifier.zip"
      sha256 "dce85d269b83a515b320a473d45242a844bcefaa1998fe9bd6ecc3995b429b7c"
    end

    if Hardware::CPU.arm?
      url "https://github.com/epilande/ccmux/releases/download/v1.4.8/ccmux-macos-arm64"
      sha256 "e26ac05b2e499796f8d30f95645eb872a1655eeb86c9aee6d55e6aead472020e"
    else
      url "https://github.com/epilande/ccmux/releases/download/v1.4.8/ccmux-macos-x64"
      sha256 "66a142e2b82058561fc72794f49129fa9d8ad9d2d1d23447c270b78f68393bd2"
    end
  end

  on_linux do
    url "https://github.com/epilande/ccmux/releases/download/v1.4.8/ccmux-linux-x64"
    sha256 "fe8c36a94e3476ab2b1c1852e57b86f240eccedb874fb57556bfe70d7e775b68"
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
