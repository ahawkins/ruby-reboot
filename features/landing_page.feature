Feature: Landing Page

  Scenario: First time visiter
    Given the site is launched
    When I go to the landing page
    Then I should see a big sign up button

  Scenario: Lead is cautious about join
    Given the site is launched
    When I go to the landing page
    Then I should see testimonials to convince me

  Scenario: Lead doesn't know what they're getting
    Given the site is launched
    When I go to the landing page
    Then I should get a preview
    And there should be a link to all screencasts
