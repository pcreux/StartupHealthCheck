@auth0
Feature: Organization's profile
  In order to acquire info about an organization
  As a visitor/person
  I want to see an organization's profile

  Background:
    Given an organization named "Brewhouse"

  Scenario: View public profile
    When I visit the profile page
    Then I should see the organization's profile

  Scenario: View organization's address
    When I visit the profile page
    Then I should see the organization's address

  @javascript
  Scenario: User claims organization's profile
    When I visit the profile page
    And I claim the profile
    And I login with "Twitter"
    And I submit an email address
    Then I should be the organization's admin user
    And I should see the organization on my profile

  @javascript
  Scenario: Admin user adds arbitary links to profile
    Given I am an admin user
    And I edit the profile
    And I add a profile link for "brewhouse.io" with name "Website"
    Then I should see the "Website" link on the profile

  @javascript  
  Scenario: Admin user deletes arbitrary link
    Given I am an admin user
    And I edit the profile
    And I add a profile link for "brewhouse.io" with name "Website"
    When I delete the link
    Then I should not see the "Website" link on the profile

  @javascript
  Scenario: Organization admin turns hiring state on and off
    Given I am an admin user
    When I edit the profile
    And I check the hiring box
    And I visit the profile page
    Then the organization should be hiring
    When I edit the profile
    And I uncheck the hiring box
    Then the organization should not be hiring

  @javascript 
  Scenario: Organization admin edits data
    Given I am an admin user
    When I edit the profile
    And I update the description
    Then I should see my new description

  @javascript
  Scenario: Adding a new organization
    When I login with "Twitter"
    And I submit an email address
    And I add an organization "MyCompany"
    Then I should see the new company info
