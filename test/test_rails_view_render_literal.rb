# frozen_string_literal: true

require_relative "./cop_test"
require "minitest/autorun"
require "rubocop/cop/github/rails_view_render_literal"

class TestRailsViewRenderLiteral < CopTest
  def cop_class
    RuboCop::Cop::GitHub::RailsViewRenderLiteral
  end

  def test_render_string_literal_no_offense
    erb_investigate cop, <<-ERB, "app/views/products/index.html.erb"
      <%= render "products/listing" %>
      <%= render partial: "products/listing" %>
    ERB

    assert_equal 0, cop.offenses.count
  end

  def test_render_layout_string_literal_no_offense
    erb_investigate cop, <<-ERB, "app/views/products/index.html.erb"
      <%= render layout: "products/listing" do %>
        Hello
      <% end %>
    ERB

    assert_equal 0, cop.offenses.count
  end

  def test_render_layout_string_literal_with_block_pass_no_offense
    erb_investigate cop, <<-ERB, "app/views/products/index.html.erb"
      <%= render layout: "layouts/head", &head %>
    ERB

    assert_equal 0, cop.offenses.count
  end

  def test_render_variable_offense
    erb_investigate cop, <<-ERB, "app/views/products/index.html.erb"
      <%= render magic_string %>
      <%= render partial: magic_string %>
    ERB

    assert_equal 2, cop.offenses.count
    assert_equal "render must be used with a string literal", cop.offenses[0].message
  end

  def test_render_component_no_offense
    erb_investigate cop, <<-ERB, "app/views/foo/index.html.erb"
      <%= render Module::MyClass, title: "foo", bar: "baz" %>
    ERB

    assert_equal 0, cop.offenses.count
  end

  def test_render_component_root_no_offense
    erb_investigate cop, <<-ERB, "app/views/foo/index.html.erb"
      <%= render MyClass, title: "foo", bar: "baz" %>
    ERB

    assert_equal 0, cop.offenses.count
  end

  def test_render_component_block_no_offense
    erb_investigate cop, <<-ERB, "app/views/foo/index.html.erb"
      <%= render Module::MyClass, title: "foo", bar: "baz" do %>Content<% end %>
    ERB

    assert_equal 0, cop.offenses.count
  end

  def test_render_layout_variable_literal_no_offense
    erb_investigate cop, <<-ERB, "app/views/products/index.html.erb"
      <%= render layout: magic_string do %>
        Hello
      <% end %>
    ERB

    assert_equal 1, cop.offenses.count
    assert_equal "render must be used with a string literal", cop.offenses[0].message
  end

  def test_render_inline_no_offense
    erb_investigate cop, <<-ERB, "app/views/products/index.html.erb"
      <%= render inline: magic_string %>
    ERB

    assert_equal 0, cop.offenses.count
  end

  def test_render_template_literal_no_offense
    erb_investigate cop, <<-ERB, "app/views/products/index.html.erb"
      <%= render template: "products/listing" %>
    ERB

    assert_equal 0, cop.offenses.count
  end
end
