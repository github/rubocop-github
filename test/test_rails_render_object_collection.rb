# frozen_string_literal: true

require_relative "./cop_test"
require "minitest/autorun"
require "rubocop/cop/github/rails_render_object_collection"

class TestRailsRenderObjectCollection < CopTest
  def cop_class
    RuboCop::Cop::GitHub::RailsRenderObjectCollection
  end

  def test_render_partial_with_locals_no_offense
    erb_investigate cop, <<-ERB, "app/views/advertiser/buy.html.erb"
      <%= render partial: "account", locals: { account: @buyer } %>

      <% @advertisements.each do |ad| %>
        <%= render partial: "ad", locals: { ad: ad } %>
      <% end %>
    ERB

    assert_equal 0, cop.offenses.count
  end

  def test_render_partial_with_object_offense
    erb_investigate cop, <<-ERB, "app/views/advertiser/buyer.html.erb"
      <%= render partial: "account", object: @buyer %>
    ERB

    assert_equal 1, cop.offenses.count
    assert_equal "Avoid `render object:`, instead `render partial: \"account\", locals: { account: @buyer }`", cop.offenses[0].message
  end

  def test_render_collection_with_object_offense
    erb_investigate cop, <<-ERB, "app/views/advertiser/ads.html.erb"
      <%= render partial: "ad", collection: @advertisements %>
    ERB

    assert_equal 1, cop.offenses.count
    assert_equal "Avoid `render collection:`", cop.offenses[0].message
  end

  def test_render_spacer_template_with_object_offense
    erb_investigate cop, <<-ERB, "app/views/products/index.html.erb"
      <%= render partial: @products, spacer_template: "product_ruler" %>
    ERB

    assert_equal 1, cop.offenses.count
    assert_equal "Avoid `render collection:`", cop.offenses[0].message
  end
end
