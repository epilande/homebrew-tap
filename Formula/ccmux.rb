class Ccmux < Formula
  desc "Monitor AI coding agent sessions running in tmux"
  homepage "https://github.com/epilande/ccmux"
  version "1.4.4"
  license "MIT"

  on_macos do
    # Actionable-notification backend: the signed + notarized ccmux-notifier
    # helper app, staged into libexec below. Gives real ccmux identity,
    # Approve/Deny buttons, inline reply, per-session grouping, and retraction
    # (ccmux falls back to osascript without it).
    resource "notifier" do
      url "https://github.com/epilande/ccmux/releases/download/v1.4.4/ccmux-notifier.zip"
      sha256 "aefe47da3c547a813273cf886f0b1f4c41f7d8900b97421fa56231556b95da9b"
    end

    if Hardware::CPU.arm?
      url "https://github.com/epilande/ccmux/releases/download/v1.4.4/ccmux-macos-arm64"
      sha256 "d6f0cfeaa8f50fcfc752befc5d0cc2d418ce323e667b714e22fa13ed15385a40"
    else
      url "https://github.com/epilande/ccmux/releases/download/v1.4.4/ccmux-macos-x64"
      sha256 "cb1c45cf009b1355f8e2a4cf92ecbe636e5a1edf5090d61348296399f7837cb2"
    end
  end

  on_linux do
    url "https://github.com/epilande/ccmux/releases/download/v1.4.4/ccmux-linux-x64"
    sha256 "8e7a229b190ac678c44f968f54f4befc0818d0b96bac6673d7cb3483d2fdfbc7"
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
