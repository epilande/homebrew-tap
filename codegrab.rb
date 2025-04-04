# typed: false
# frozen_string_literal: true

# This file was generated by GoReleaser. DO NOT EDIT.
class Codegrab < Formula
  desc "An interactive CLI tool for selecting and bundling code into a single, LLM-ready output file"
  homepage "https://github.com/epilande/codegrab"
  version "1.0.2"
  license "MIT"

  on_macos do
    if Hardware::CPU.intel?
      url "https://github.com/epilande/codegrab/releases/download/v1.0.2/codegrab_1.0.2_Darwin_x86_64.tar.gz"
      sha256 "9af11dbeec07f44134f52778c48d37ab14527a16c7690c804ec2c8f7a01a39f1"

      def install
        bin.install "grab"
      end
    end
    if Hardware::CPU.arm?
      url "https://github.com/epilande/codegrab/releases/download/v1.0.2/codegrab_1.0.2_Darwin_arm64.tar.gz"
      sha256 "d4c94395ea49a116c0b9c4174f9895226319fae6bb679e1b2552a6e7d14af7fa"

      def install
        bin.install "grab"
      end
    end
  end

  on_linux do
    if Hardware::CPU.intel?
      if Hardware::CPU.is_64_bit?
        url "https://github.com/epilande/codegrab/releases/download/v1.0.2/codegrab_1.0.2_Linux_x86_64.tar.gz"
        sha256 "ffc52a760f455a30709ccf3fab9b2170649d65db48ffed02e06e626e60a2c5b1"

        def install
          bin.install "grab"
        end
      end
    end
    if Hardware::CPU.arm?
      if Hardware::CPU.is_64_bit?
        url "https://github.com/epilande/codegrab/releases/download/v1.0.2/codegrab_1.0.2_Linux_arm64.tar.gz"
        sha256 "cd1915515188f482b527534de730cec6af034a9de9e3c4fb46ad7ba9dac660ff"

        def install
          bin.install "grab"
        end
      end
    end
  end

  test do
    system "#{bin}/grab --version"
  end
end
