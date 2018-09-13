# frozen_string_literal: true

require "action_view"
require "minitest"

class CopTest < MiniTest::Test
  def cop_class
    raise NotImplementedError
  end

  attr_reader :cop

  def setup
    config = RuboCop::Config.new
    @cop = cop_class.new(config)
  end

  def investigate(cop, src, filename = nil)
    processed_source = RuboCop::ProcessedSource.new(src, RUBY_VERSION.to_f, filename)
    commissioner = RuboCop::Cop::Commissioner.new([cop], [], raise_error: true)
    commissioner.investigate(processed_source)
    commissioner
  end

  def erb_investigate(cop, src, filename = nil)
    engine = ActionView::Template::Handlers::ERB::Erubi.new(src)
    investigate(cop, engine.src.dup, filename)
  end
end
