# frozen_string_literal: true

require_relative "./cop_test"
require "minitest/autorun"
require "rubocop/cop/github/rails_render_literal"

class TestRailsRenderLiteral < CopTest
  def cop_class
    RuboCop::Cop::GitHub::RailsRenderLiteral
  end

  def test_controller_render_string_literal_no_offense
    investigate cop, <<-RUBY, "app/controllers/products_controller.rb"
      class ProductsController < ActionController::Base
        def index
          render "products/index"
          render action: :index
          render template: "products/index"
          render partial: "products/listing"
          render template: "products/index", layout: "layouts/product"
        end
      end
    RUBY

    assert_equal 0, cop.offenses.count
  end

  def test_view_render_string_literal_no_offense
    erb_investigate cop, <<-ERB, "app/views/products/index.html.erb"
      <%= render "products/listing" %>
      <%= render partial: "products/listing" %>
    ERB

    assert_equal 0, cop.offenses.count
  end

  def test_controller_render_variable_offense
    investigate cop, <<-RUBY, "app/controllers/products_controller.rb"
      class ProductsController < ActionController::Base
        def index
          render
          render layout: "layouts/product"
          render magic_string
          render action: magic_symbol
          render template: magic_string
          render partial: magic_string
          render template: "products/index", layout: magic_string
          render template: magic_string, layout: "layouts/product"
        end
      end
    RUBY

    assert_equal 8, cop.offenses.count
    assert_equal "render must be used with a string literal", cop.offenses[0].message
  end

  def test_view_render_variable_offense
    erb_investigate cop, <<-ERB, "app/views/products/index.html.erb"
      <%= render magic_string %>
      <%= render partial: magic_string %>
    ERB

    assert_equal 2, cop.offenses.count
    assert_equal "render must be used with a string literal", cop.offenses[0].message
  end
end
