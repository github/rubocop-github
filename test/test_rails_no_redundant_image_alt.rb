# frozen_string_literal: true

require_relative "./cop_test"
require "minitest/autorun"
require "rubocop/cop/github/rails_no_redundant_image_alt"

class NoRedundantImageAlt < CopTest
  def cop_class
    RuboCop::Cop::GitHub::Accessibility::NoRedundantImageAlt
  end

  def test_no_redundant_image_alt_offense
    offenses = erb_investigate cop, <<-ERB, "app/views/products/index.html.erb"
      <%= image_tag "cat.gif", size: "12x12", alt: "Picture of a cat" %>
    ERB

    assert_equal 1, offenses.count
    assert_equal "Alt prop should not contain `image` or `picture` as screen readers already announce the element as an image", offenses[0].message
  end

  def test_no_redundant_image_alt_no_offense
    offenses = erb_investigate cop, <<-ERB, "app/views/products/index.html.erb"
       <%= image_tag "cat.gif", size: "12x12", alt: "A black cat" %>
    ERB

    assert_equal 0, offenses.count
  end
end
