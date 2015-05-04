Feature: About Page

  Scenario: User wants to learn about RubyReboot
    Given the site is launched
    When I go to the landing page
    And I click the about link
    Then I should see a product description
    And the about link should be selected
