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
    processed_source = parse_source(src, filename)
    investigate_processed_source(processed_source)
  end

  def erb_investigate(cop, src, filename = nil)
    engine = ActionView::Template::Handlers::ERB::Erubi.new(src)
    investigate(cop, engine.src.dup, filename)
  end

  # From https://github.com/rubocop-hq/rubocop/blob/841b6fd71c65c3d6692dbdf4f866d1c62249e21d/lib/rubocop/rspec/cop_helper.rb#L40-L48
  def autocorrect_source(source, file = nil)
    cop.instance_variable_get(:@options)[:auto_correct] = true
    processed_source = parse_source(source, file)
    investigate_processed_source(processed_source)
    corrector = RuboCop::Cop::Corrector.new(processed_source.buffer, cop.corrections)
    corrector.rewrite
  end

  private

  def parse_source(src, filename)
    RuboCop::ProcessedSource.new(src, RUBY_VERSION.to_f, filename)
  end

  def investigate_processed_source(processed_source)
    commissioner = RuboCop::Cop::Commissioner.new([cop], [], raise_error: true)
    commissioner.investigate(processed_source)
    commissioner
  end
end
