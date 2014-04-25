require "formula"

# Documentation: https://github.com/Homebrew/homebrew/wiki/Formula-Cookbook
#                /usr/local/Library/Contributions/example-formula.rb
# PLEASE REMOVE ALL GENERATED COMMENTS BEFORE SUBMITTING YOUR PULL REQUEST!

class Libosmscout < Formula
  homepage ""
  url "https://github.com/nkostelnik/libosmscout/tarball/master"
  sha1 "cd788c1c3294d33653a817900bb66b1fca75b420"
  version "0.1"

  depends_on 'autoconf'
  depends_on 'automake'
  depends_on 'libtool'
  depends_on 'pkg-config'
  depends_on 'protobuf'

  depends_on 'neonadventures/neon/marisa'
  depends_on 'neonadventures/neon/osmbright'

  def install
    build_command = <<-eos
      # compile libosmscout
      cd libosmscout
      ./autogen.sh && ./configure --disable-see2-support && make
      export PKG_CONFIG_PATH=$PKG_CONFIG_PATH:$(pwd)
      export LD_LIBRARY_PATH=$LD_LIBRARY_PATH:$(pwd)/src/.libs
      cd ..

      # compile libosmscoutimport
      cd libosmscout-import
      ./autogen.sh && ZLIB_CFLAGS="-I/usr/include" ZLIB_LIBS="-L/usr/lib -lz" ./configure && make
      export PKG_CONFIG_PATH=$PKG_CONFIG_PATH:$(pwd)
      export LD_LIBRARY_PATH=$LD_LIBRARY_PATH:$(pwd)/src/.libs
      cd ..

      # compile the Import tool
      cd Import/
      ./autogen.sh && ./configure && make
      cp src/Import src/osmscout-import
      cd ..
    eos

    system(build_command)

    lib.install Dir['libosmscout/src/.libs/*']
    lib.install Dir['libosmscout-import/src/.libs/*']

    bin.install Dir['Import/src/osmscout-import']
    bin.install Dir['Import/src/.libs']

    share.install Dir['Import/*.oss']
    share.install Dir['Import/*.ost']
  end

  test do
    true
  end
end
