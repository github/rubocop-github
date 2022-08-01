# frozen_string_literal: true

require_relative "./cop_test"
require "minitest/autorun"
require "rubocop/cop/github/accessibility/link_has_href"

class LinkHasHref < CopTest
  def cop_class
    RuboCop::Cop::GitHub::Accessibility::LinkHasHref
  end

  def test_link_has_href_offense
    offenses = erb_investigate cop, <<-ERB, "app/views/products/index.html.erb"
      <%= link_to 'Go to GitHub' %>
    ERB

    assert_equal 1, offenses.count
    assert_equal "Links should go somewhere, you probably want to use a `<button>` instead.", offenses[0].message

    offenses = erb_investigate cop, <<-ERB, "app/views/products/index.html.erb"
      <%= link_to 'Go to GitHub', '#' %>
    ERB

    assert_equal 1, offenses.count
    assert_equal "Links should go somewhere, you probably want to use a `<button>` instead.", offenses[0].message
  end

  def test_link_has_href_no_offense
    offenses = erb_investigate cop, <<-ERB, "app/views/products/index.html.erb"
      <%= link_to 'Go to GitHub', 'https://github.com/' %>
    ERB

    assert_equal 0, offenses.count
  end
end
