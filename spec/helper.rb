$:.unshift(File.expand_path('../../lib', __FILE__))

require 'pathname'
FlipperRoot = Pathname(__FILE__).dirname.join('..').expand_path

require 'rubygems'
require 'bundler'

Bundler.setup(:default)

require 'flipper'
require 'flipper-ui'

Dir[FlipperRoot.join("spec/support/**/*.rb")].each { |f| require f }

RSpec.configure do |config|
  config.before(:each) do
    Flipper.unregister_groups
  end
end

shared_examples_for 'a percentage' do
  it "initializes with value" do
    percentage = described_class.new(12)
    percentage.should be_instance_of(described_class)
  end

  it "converts string values to integers when initializing" do
    percentage = described_class.new('15')
    percentage.value.should eq(15)
  end

  it "has a value" do
    percentage = described_class.new(19)
    percentage.value.should eq(19)
  end

  it "raises exception for value higher than 100" do
    expect {
      described_class.new(101)
    }.to raise_error(ArgumentError, "value must be a positive number less than or equal to 100, but was 101")
  end

  it "raises exception for negative value" do
    expect {
      described_class.new(-1)
    }.to raise_error(ArgumentError, "value must be a positive number less than or equal to 100, but was -1")
  end
end

shared_examples_for 'a DSL feature' do
  it "returns instance of feature" do
    feature.should be_instance_of(Flipper::Feature)
  end

  it "sets name" do
    feature.name.should eq(:stats)
  end

  it "sets adapter" do
    feature.adapter.name.should eq(dsl.adapter.name)
  end

  it "sets instrumenter" do
    feature.instrumenter.should eq(dsl.instrumenter)
  end

  it "memoizes the feature" do
    dsl.send(method_name, :stats).should equal(feature)
  end

  it "raises argument error if not string or symbol" do
    expect {
      dsl.send(method_name, Object.new)
    }.to raise_error(ArgumentError, /must be a String or Symbol/)
  end
end

shared_examples_for "a DSL boolean method" do
  it "returns boolean with value set" do
    result = subject.send(method_name, true)
    result.should be_instance_of(Flipper::Types::Boolean)
    result.value.should be(true)

    result = subject.send(method_name, false)
    result.should be_instance_of(Flipper::Types::Boolean)
    result.value.should be(false)
  end
end
