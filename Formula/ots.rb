class Ots < Formula
  desc "🔐 Share end-to-end encrypted secrets with others via a one-time URL"
  homepage "https://www.sniptt.com"

  url "https://github.com/sniptt-official/ots.git",
      tag:      "v0.0.11",
      revision: "66e3c30934bfc867b6451b08f39693fe7d5c05c0"

  license "Apache-2.0"

  depends_on "go" => :build

  def install
    system "go", "build", "-ldflags",
      "-s -w -X github.com/sniptt-official/ots/build.Version=#{version}", *std_go_args
  end

  test do
    output = shell_output("#{bin}/ots --version")
    assert_match "ots version #{version}", output

    error_output = shell_output("#{bin}/ots new -x 900h 2>&1", 1)
    assert_match "Error: expiry must be less than 7 days", error_output
  end
end
