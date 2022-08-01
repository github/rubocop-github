# frozen_string_literal: true

require_relative "./cop_test"
require "minitest/autorun"
require "rubocop/cop/github/accessibility/no_positive_tabindex"

class NoPositiveTabindex < CopTest
  def cop_class
    RuboCop::Cop::GitHub::Accessibility::NoPositiveTabindex
  end

  def test_no_positive_tabindex_alt_offense
    offenses = erb_investigate cop, <<-ERB, "app/views/products/index.html.erb"
      <%= button_tag "Continue", :tabindex => 3 %>
    ERB

    assert_equal 1, offenses.count
    assert_equal "Positive tabindex is error-prone and often inaccessible.", offenses[0].message
  end

  def test_no_positive_tabindex_alt_no_offense
    offenses = erb_investigate cop, <<-ERB, "app/views/products/index.html.erb"
       <%= button_tag "Continue", :tabindex => -1 %>
    ERB

    assert_equal 0, offenses.count
  end
end
