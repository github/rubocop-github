# frozen_string_literal: true

require_relative './cop_test'
require 'minitest/autorun'
require 'rubocop/cop/standard/rails_controller_render_literal'

class TestRailsControllerRenderLiteral < CopTest
  def cop_class
    RuboCop::Cop::Standard::RailsControllerRenderLiteral
  end

  def test_render_string_literal_action_name_no_offense
    investigate cop, <<-RUBY, 'app/controllers/products_controller.rb'
      class ProductsController < ActionController::Base
        def index
          render "index"
        end
      end
    RUBY

    assert_equal 0, cop.offenses.count
  end

  def test_render_sym_literal_action_name_no_offense
    investigate cop, <<-RUBY, 'app/controllers/products_controller.rb'
      class ProductsController < ActionController::Base
        def index
          render :index
        end
      end
    RUBY

    assert_equal 0, cop.offenses.count
  end

  def test_render_action_literal_action_name_no_offense
    investigate cop, <<-RUBY, 'app/controllers/products_controller.rb'
      class ProductsController < ActionController::Base
        def index
          render action: :index
        end
      end
    RUBY

    assert_equal 0, cop.offenses.count
  end

  def test_render_string_literal_full_template_name_no_offense
    investigate cop, <<-RUBY, 'app/controllers/products_controller.rb'
      class ProductsController < ActionController::Base
        def index
          render "products/index"
        end
      end
    RUBY

    assert_equal 0, cop.offenses.count
  end

  def test_render_template_literal_full_template_name_no_offense
    investigate cop, <<-RUBY, 'app/controllers/products_controller.rb'
      class ProductsController < ActionController::Base
        def index
          render template: "products/index"
        end
      end
    RUBY

    assert_equal 0, cop.offenses.count
  end

  def test_render_template_and_layout_literal_full_template_name_no_offense
    investigate cop, <<-RUBY, 'app/controllers/products_controller.rb'
      class ProductsController < ActionController::Base
        def index
          render template: "products/index", layout: "layouts/products"
        end
      end
    RUBY

    assert_equal 0, cop.offenses.count
  end

  def test_render_partial_literal_full_template_name_no_offense
    investigate cop, <<-RUBY, 'app/controllers/products_controller.rb'
      class ProductsController < ActionController::Base
        def index
          render partial: "products/index"
        end
      end
    RUBY

    assert_equal 0, cop.offenses.count
  end

  def test_render_partial_literal_full_template_name_and_no_layout_no_offense
    investigate cop, <<-RUBY, 'app/controllers/products_controller.rb'
      class ProductsController < ActionController::Base
        def index
          render partial: "products/index", layout: false
        end
      end
    RUBY

    assert_equal 0, cop.offenses.count
  end

  def test_render_dynamic_file_no_offense
    investigate cop, <<-RUBY, 'app/controllers/products_controller.rb'
      class ProductsController < ActionController::Base
        def index
          render file: "\#{Rails.root}/public/404.html"
          render file: "\#{Rails.root}/public/404.html", layout: false
        end
      end
    RUBY

    assert_equal 0, cop.offenses.count
  end

  def test_render_inline_no_offense
    investigate cop, <<-RUBY, 'app/controllers/products_controller.rb'
      class ProductsController < ActionController::Base
        def index
          render inline: "Hello <%= @name %>"
        end
      end
    RUBY

    assert_equal 0, cop.offenses.count
  end

  def test_render_xml_no_offense
    investigate cop, <<-RUBY, 'app/controllers/products_controller.rb'
      class ProductsController < ActionController::Base
        def index
          render xml: @product
        end
      end
    RUBY

    assert_equal 0, cop.offenses.count
  end

  def test_render_json_no_offense
    investigate cop, <<-RUBY, 'app/controllers/products_controller.rb'
      class ProductsController < ActionController::Base
        def index
          render json: @product
        end
      end
    RUBY

    assert_equal 0, cop.offenses.count
  end

  def test_render_plain_no_offense
    investigate cop, <<-RUBY, 'app/controllers/products_controller.rb'
      class ProductsController < ActionController::Base
        def index
          render plain: "OK"
        end
      end
    RUBY

    assert_equal 0, cop.offenses.count
  end

  def test_render_html_no_offense
    investigate cop, <<-RUBY, 'app/controllers/products_controller.rb'
      class ProductsController < ActionController::Base
        def index
          render html: "<strong>Not Found</strong>".html_safe
        end
      end
    RUBY

    assert_equal 0, cop.offenses.count
  end

  def test_render_body_no_offense
    investigate cop, <<-RUBY, 'app/controllers/products_controller.rb'
      class ProductsController < ActionController::Base
        def index
          render body: "raw"
        end
      end
    RUBY

    assert_equal 0, cop.offenses.count
  end

  def test_render_nothing_no_offense
    investigate cop, <<-RUBY, 'app/controllers/products_controller.rb'
      class ProductsController < ActionController::Base
        def index
          render nothing: true
        end
      end
    RUBY

    assert_equal 0, cop.offenses.count
  end

  def test_render_implicit_offense
    investigate cop, <<-RUBY, 'app/controllers/products_controller.rb'
      class ProductsController < ActionController::Base
        def index
          render
        end
      end
    RUBY

    assert_equal 1, cop.offenses.count
    assert_equal 'render must be used with a string literal', cop.offenses[0].message
  end

  def test_render_implicit_with_layout_offense
    investigate cop, <<-RUBY, 'app/controllers/products_controller.rb'
      class ProductsController < ActionController::Base
        def index
          render layout: "layouts/product"
        end
      end
    RUBY

    assert_equal 1, cop.offenses.count
    assert_equal 'render must be used with a string literal', cop.offenses[0].message
  end

  def test_render_implicit_with_status_offense
    investigate cop, <<-RUBY, 'app/controllers/products_controller.rb'
      class ProductsController < ActionController::Base
        def index
          render status: :ok
        end
      end
    RUBY

    assert_equal 1, cop.offenses.count
    assert_equal 'render must be used with a string literal', cop.offenses[0].message
  end

  def test_render_variable_offense
    investigate cop, <<-RUBY, 'app/controllers/products_controller.rb'
      class ProductsController < ActionController::Base
        def index
          render magic_string
        end
      end
    RUBY

    assert_equal 1, cop.offenses.count
    assert_equal 'render must be used with a string literal', cop.offenses[0].message
  end

  def test_render_action_variable_offense
    investigate cop, <<-RUBY, 'app/controllers/products_controller.rb'
      class ProductsController < ActionController::Base
        def index
          render action: magic_symbol
        end
      end
    RUBY

    assert_equal 1, cop.offenses.count
    assert_equal 'render must be used with a string literal', cop.offenses[0].message
  end

  def test_render_template_variable_offense
    investigate cop, <<-RUBY, 'app/controllers/products_controller.rb'
      class ProductsController < ActionController::Base
        def index
          render template: magic_string
          end
      end
    RUBY

    assert_equal 1, cop.offenses.count
    assert_equal 'render must be used with a string literal', cop.offenses[0].message
  end

  def test_render_partial_variable_offense
    investigate cop, <<-RUBY, 'app/controllers/products_controller.rb'
      class ProductsController < ActionController::Base
        def index
          render partial: magic_string
        end
      end
    RUBY

    assert_equal 1, cop.offenses.count
    assert_equal 'render must be used with a string literal', cop.offenses[0].message
  end

  def test_render_template_with_layout_variable_offense
    investigate cop, <<-RUBY, 'app/controllers/products_controller.rb'
      class ProductsController < ActionController::Base
        def index
          render template: "products/index", layout: magic_string
        end
      end
    RUBY

    assert_equal 1, cop.offenses.count
    assert_equal 'render must be used with a string literal', cop.offenses[0].message
  end

  def test_render_template_variable_with_layout_offense
    investigate cop, <<-RUBY, 'app/controllers/products_controller.rb'
      class ProductsController < ActionController::Base
        def index
          render template: magic_string, layout: "layouts/product"
        end
      end
    RUBY

    assert_equal 1, cop.offenses.count
    assert_equal 'render must be used with a string literal', cop.offenses[0].message
  end
end
