class Ccmux < Formula
  desc "Monitor AI coding agent sessions running in tmux"
  homepage "https://github.com/epilande/ccmux"
  version "1.4.2"
  license "MIT"

  on_macos do
    # Actionable-notification backend: the signed + notarized ccmux-notifier
    # helper app, staged into libexec below. Gives real ccmux identity,
    # Approve/Deny buttons, inline reply, per-session grouping, and retraction
    # (ccmux falls back to osascript without it).
    resource "notifier" do
      url "https://github.com/epilande/ccmux/releases/download/v1.4.2/ccmux-notifier.zip"
      sha256 "a4ed63b1cc3cdd849ffaeb54ae3b8d4aa90f1d4585b27b0de6a00a61872dba2d"
    end

    if Hardware::CPU.arm?
      url "https://github.com/epilande/ccmux/releases/download/v1.4.2/ccmux-macos-arm64"
      sha256 "f79353fef9af80fc5b2e45e179c700e836ae18d13871ee5ba60ab6df80e1b169"
    else
      url "https://github.com/epilande/ccmux/releases/download/v1.4.2/ccmux-macos-x64"
      sha256 "067ba461dc6c66bb38f7b7a30ca74c01b32b47640659fdf7c94a976174f478e9"
    end
  end

  on_linux do
    url "https://github.com/epilande/ccmux/releases/download/v1.4.2/ccmux-linux-x64"
    sha256 "b4eeef6aac007f7f01699647a65f94fb97260554b82ab012fb1577a38dbd4b5b"
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
