@auth0
Feature: Authentication
  In order to access my account
  As a person (user)
  I want to be able to register for an accout or sign in

  @javascript
  Scenario: Signing into my account
    Given I login with "Twitter"
    And I submit an email address
    Then I should be on the user profile page for "J C"
    And my email address should be present
