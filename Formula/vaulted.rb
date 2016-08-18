require "language/go"

class Vaulted < Formula
  desc "Allows the secure storage and execution of environments"
  homepage "https://github.com/miquella/vaulted"
  url "https://github.com/miquella/vaulted/archive/v2.0.tar.gz"
  sha256 "7bf3e9dc0ae015f1fadee3520273707ad072a2f6c945c959c993d282301c897e"

  head "https://github.com/miquella/vaulted.git"

  depends_on "go" => :build

  # Install Go dependencies
  go_resource "github.com/aws/aws-sdk-go" do
    url "https://github.com/aws/aws-sdk-go.git",
    :revision => "94673f7d41219ea3e94e4b1edc01315f14268f72"
  end

  go_resource "github.com/fatih/color" do
    url "https://github.com/fatih/color.git",
    :revision => "87d4004f2ab62d0d255e0a38f1680aa534549fe3"
  end

  go_resource "github.com/mattn/go-colorable" do
    url "https://github.com/mattn/go-colorable.git",
    :revision => "ed8eb9e318d7a84ce5915b495b7d35e0cfe7b5a8"
  end

  go_resource "github.com/mattn/go-isatty" do
    url "https://github.com/mattn/go-isatty.git",
    :revision => "3a115632dcd687f9c8cd01679c83a06a0e21c1f3"
  end

  go_resource "github.com/miquella/ask" do
    url "https://github.com/miquella/ask.git",
    :revision => "486a722fa4cdb033d35a501d54116b645e139ef3"
  end

  go_resource "github.com/miquella/xdg" do
    url "https://github.com/miquella/xdg.git",
    :revision => "1ee6df0d556245ee71d26d54f9dbfea1f84d136a"
  end

  go_resource "github.com/spf13/pflag" do
    url "https://github.com/spf13/pflag.git",
    :revision => "4f9190456aed1c2113ca51ea9b89219747458dc1"
  end

  go_resource "golang.org/x/crypto" do
    url "https://go.googlesource.com/crypto.git",
    :revision => "9fbab14f903f89e23047b5971369b86380230e56"
  end

  def install
    ENV["GOPATH"] = buildpath
    mkdir_p buildpath/"src/github.com/miquella"
    ln_s buildpath, "src/github.com/miquella/vaulted"
    Language::Go.stage_deps resources, buildpath/"src"

    # Build
    system "go", "build", "-o", bin/"vaulted", "github.com/miquella/vaulted"

    # Install man pages
    man1.install Dir["man/vaulted*.1"]
  end

  test do
    mkdir_p ".local/share/vaulted"
    touch(".local/share/vaulted/test_vault")
    output = IO.popen(["#{bin}/vaulted", "ls"], &:read)
    output == "test_vault\n"
  end
end
