# frozen_string_literal: true

require_relative "./cop_test"
require "minitest/autorun"
require "rubocop/cop/github/rails_image_has_alt"

class TestImageHasAlt < CopTest
  def cop_class
    RuboCop::Cop::GitHub::Accessibility::ImageHasAlt
  end

  def test_image_has_alt_offense
    offenses = erb_investigate cop, <<-ERB, "app/views/products/index.html.erb"
      <%= image_tag "spinners/octocat-spinner-16px.gif", size: "12x12" %>
    ERB

    assert_equal 1, offenses.count
    assert_equal "Images should have an alt prop with meaningful text or an empty string for decorative images", offenses[0].message
  end

  def test_image_has_alt_no_offense
    offenses = erb_investigate cop, <<-ERB, "app/views/products/index.html.erb"
      <%= image_tag "spinners/octocat-spinner-16px.gif", size: "12x12", alt: "GitHub Logo spinner" %>
    ERB

    assert_equal 0, offenses.count
  end
end
