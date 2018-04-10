lib = File.expand_path("../lib", __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require "point_and_figure/version"

Gem::Specification.new do |spec|
  spec.name          = "point_and_figure"
  spec.version       = PointAndFigure::VERSION
  spec.authors       = ["Tsutomu Chikuba"]
  spec.email         = ["chikuba.tsutomu@gmail.com"]

  spec.summary       = %q{Create Point And Figure(P&F) Chart.}
  spec.description   = %q{point_and_figure creates Point And Figure Chart from dataset.}
  spec.homepage      = "https://github.com/tchikuba/point_and_figure"

  spec.files         = `git ls-files -z`.split("\x0").reject do |f|
    f.match(%r{^(test|spec|features)/})
  end
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.16"
  spec.add_development_dependency "rake", "~> 10.0"
  spec.add_development_dependency "minitest", "~> 5.0"
end
