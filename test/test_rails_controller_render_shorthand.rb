# frozen_string_literal: true

require_relative "cop_test"
require "minitest/autorun"
require "rubocop/cop/github/rails_controller_render_shorthand"

class TestRailsControllerRenderShorthand < CopTest
  def cop_class
    RuboCop::Cop::GitHub::RailsControllerRenderShorthand
  end

  def test_render_string_no_offense
    offenses = investigate cop, <<-RUBY, "app/controllers/foo_controller.rb"
      class FooController < ActionController::Base
        def index
          render "index"
        end

        def show
          render "show.html.erb", locals: { foo: @foo }
        end
      end
    RUBY

    assert_equal 0, offenses.count
  end

  def test_render_partial_no_offense
    offenses = investigate cop, <<-RUBY, "app/controllers/books_controller.rb"
      class BooksController < ActionController::Base
        def show
          render partial: "books/show"
        end
      end
    RUBY

    assert_equal 0, offenses.count
  end

  def test_render_action_offense
    offenses = investigate cop, <<-RUBY, "app/controllers/products_controller.rb"
      class ProductsController < ActionController::Base
        def edit
          render action: :edit
        end

        def new
          render action: "new"
        end

        def confirm
          render action: "confirm.html.erb"
        end
      end
    RUBY

    assert_equal 3, offenses.count
    assert_equal "#{cop.name}: Use `render \"edit\"` instead", offenses[0].message
    assert_equal "#{cop.name}: Use `render \"new\"` instead", offenses[1].message
    assert_equal "#{cop.name}: Use `render \"confirm.html.erb\"` instead", offenses[2].message
  end

  def test_render_template_offense
    offenses = investigate cop, <<-RUBY, "app/controllers/products_controller.rb"
      class ProductsController < ActionController::Base
        def new
          render template: "books/new"
        end

        def show
          render template: "books/show", locals: { book: @book }
        end

        def edit
          render status: :ok, template: "books/edit.html.erb", layout: "application"
        end
      end
    RUBY

    assert_equal 3, offenses.count
    assert_equal "#{cop.name}: Use `render \"books/new\"` instead", offenses[0].message
    assert_equal "#{cop.name}: Use `render \"books/show\", locals: { book: @book }` instead", offenses[1].message
    assert_equal "#{cop.name}: Use `render \"books/edit.html.erb\", status: :ok, layout: \"application\"` instead", offenses[2].message
  end
end
