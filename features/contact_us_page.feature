Feature: Contact Us Page

  Scenario: User needs to contact us
    Given the site is launched
    When I go to the landing page
    And I click the contact us link
    Then I should see the contact information
    And the contact us link should be selected
