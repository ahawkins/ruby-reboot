Feature: Download Screencasts

  Scenario: User is on the catalog page
    Given there's a "testing" screencast
    When I go to the landing page
    And I click the catalog link
    Then the "testing" screencast should be shown
    And the length should be shown
    And the date should be shown

  Scenario: User goes to detail view
    Given there's a "testing" screencast
    When I go to the landing page
    And I click the catalog link
    And I click on the "testing" screencast
    Then the "testing" screencast should be shown
    And the length should be shown
    And the summary should be printed
    And a download link should be shown
    And the preview should play
