class Ccmux < Formula
  desc "Monitor AI coding agent sessions running in tmux"
  homepage "https://github.com/epilande/ccmux"
  version "1.4.6"
  license "MIT"

  on_macos do
    # Actionable-notification backend: the signed + notarized ccmux-notifier
    # helper app, staged into libexec below. Gives real ccmux identity,
    # Approve/Deny buttons, inline reply, per-session grouping, and retraction
    # (ccmux falls back to osascript without it).
    resource "notifier" do
      url "https://github.com/epilande/ccmux/releases/download/v1.4.6/ccmux-notifier.zip"
      sha256 "9bf5565b0bbb0d59ca90e39a2eb1e3dd7bc55d162f27840430e6b26481b063ac"
    end

    if Hardware::CPU.arm?
      url "https://github.com/epilande/ccmux/releases/download/v1.4.6/ccmux-macos-arm64"
      sha256 "b86e56f6b0d0ef250b71e223a66bad7c4c993201485cf136428678b6e2e4c5c0"
    else
      url "https://github.com/epilande/ccmux/releases/download/v1.4.6/ccmux-macos-x64"
      sha256 "1e7a62bf90777a416ac841b909c26a6878e4ccf605887b3d21ffcfc6679c9ae7"
    end
  end

  on_linux do
    url "https://github.com/epilande/ccmux/releases/download/v1.4.6/ccmux-linux-x64"
    sha256 "a4f0677c7238cdc6794ed637917436af7ca928faa7e7ff341061c496e9ee3ec5"
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
