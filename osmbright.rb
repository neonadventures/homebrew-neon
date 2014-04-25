require "formula"

class Osmbright < Formula
  homepage ""
  url "https://github.com/mapbox/osm-bright/zipball/master"
  sha1 "919006545b65566080bebdb43ab1174c21ad3cb4"
  version "0.1"

  depends_on 'wget'

  def install

    system 'cp configure.py.sample configure.py'
    system 'python make.py'

    system 'wget http://tilemill-data.s3.amazonaws.com/osm/coastline-good.zip'
    system 'wget http://tilemill-data.s3.amazonaws.com/osm/shoreline_300.zip'
    system 'wget http://mapbox-geodata.s3.amazonaws.com/natural-earth-1.3.0/physical/10m-land.zip'

    share.install Dir['*']
  end

  test do
    true
  end
end
