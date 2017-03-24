# frozen_string_literal: true

require_relative "./cop_test"
require "minitest/autorun"
require "rubocop/cop/github/rails_render_inline"

class TestRailsRenderInline < CopTest
  def cop_class
    RuboCop::Cop::GitHub::RailsRenderInline
  end

  def test_render_string_no_offense
    investigate cop, <<-RUBY, "app/controllers/foo_controller.rb"
      class FooController < ActionController::Base
        def index
          render template: "index"
        end

        def show
          render template: "show.html.erb", locals: { foo: @foo }
        end
      end
    RUBY

    assert_equal 0, cop.offenses.count
  end

  def test_render_inline_offense
    investigate cop, <<-RUBY, "app/controllers/products_controller.rb"
      class ProductsController < ActionController::Base
        def index
          render inline: "<% products.each do |p| %><p><%= p.name %></p><% end %>"
        end
      end
    RUBY

    assert_equal 1, cop.offenses.count
    assert_equal "Avoid `render inline:`", cop.offenses[0].message
  end

  def test_render_status_with_inline_offense
    investigate cop, <<-RUBY, "app/controllers/products_controller.rb"
      class ProductsController < ActionController::Base
        def index
          render status: 200, inline: "<% products.each do |p| %><p><%= p.name %></p><% end %>"
        end
      end
    RUBY

    assert_equal 1, cop.offenses.count
    assert_equal "Avoid `render inline:`", cop.offenses[0].message
  end

  def test_erb_render_inline_offense
    erb_investigate cop, <<-ERB, "app/views/products/index.html.erb"
      <%= render inline: template %>
    ERB

    assert_equal 1, cop.offenses.count
    assert_equal "Avoid `render inline:`", cop.offenses[0].message
  end
end
