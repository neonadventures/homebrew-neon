require "formula"

class Marisa < Formula
  homepage "http://marisa-trie.googlecode.com"
  url "http://marisa-trie.googlecode.com/files/marisa-0.2.4.tar.gz"
  sha1 "fb0ed7d993e84dff32ec456a79bd36a00022629d"

  def install

    ENV.universal_binary
    system "./configure", "--disable-debug",
                          "--disable-dependency-tracking",
                          "--disable-silent-rules",
                          "--prefix=#{prefix}"

    system "make", "install"

    architectures = ["armv7", "armv7s"]
    architectures.each { |arch| compile_for_arch(arch) }    
  end

  def compile_for_arch(arch)
    system "cp #{lib}/libmarisa.a /tmp/libmarisa.sys.a"

    build_command = <<-CMD
      export PATH="/usr/bin:/bin:/usr/sbin:/sbin"
      export SDKROOT=$(xcrun --show-sdk-path --sdk iphoneos)
      export CFLAGS="-arch #{arch}"
      export CPPFLAGS=$CFLAGS
      export CXXFLAGS=$CFLAGS

      ./configure --host=arm-apple-darwin6 --target=arm-apple-darwin6 --build=i386-apple-darwin

      make
    CMD

    system "make", "clean"
    system build_command
    system "cp lib/.libs/libmarisa.a /tmp/libmarisa.#{arch}.a"

    system "lipo", "-info", "/tmp/libmarisa.sys.a"
    system "lipo", "-output", "/tmp/libmarisa.a", "-create", "-arch", arch, "/tmp/libmarisa.#{arch}.a", "/tmp/libmarisa.sys.a"
    system "rm /tmp/libmarisa.#{arch}.a"
    system "rm /tmp/libmarisa.sys.a"

    lib.install("/tmp/libmarisa.a")
  end

  test do
    system "false"
  end
end
