class VertX < Formula
  desc "Toolkit for building reactive applications on the JVM"
  homepage "https://vertx.io/"
  url "https://search.maven.org/remotecontent?filepath=io/vertx/vertx-stack-manager/4.1.2/vertx-stack-manager-4.1.2-full.tar.gz"
  sha256 "f2c3fdebb5eb3240a9bca68784a4c00e7c09e3f29bc82dd4a98acb6a9180fe66"
  license any_of: ["EPL-2.0", "Apache-2.0"]

  livecheck do
    url "https://search.maven.org/remotecontent?filepath=io/vertx/vertx-stack-manager/"
    regex(%r{href=["']?v?(\d+(?:\.\d+)+)/?["' >]}i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, all: "21496a6c50e9f84697d540b2b070faac062d30a599f97e368cd5a432b1f6f301"
  end

  depends_on "openjdk"

  def install
    rm_f Dir["bin/*.bat"]
    libexec.install %w[bin conf lib]
    (bin/"vertx").write_env_script "#{libexec}/bin/vertx", Language::Java.overridable_java_home_env
  end

  test do
    (testpath/"HelloWorld.java").write <<~EOS
      import io.vertx.core.AbstractVerticle;
      public class HelloWorld extends AbstractVerticle {
        public void start() {
          System.out.println("Hello World!");
          vertx.close();
          System.exit(0);
        }
      }
    EOS
    output = shell_output("#{bin}/vertx run HelloWorld.java")
    assert_equal "Hello World!\n", output
  end
end
