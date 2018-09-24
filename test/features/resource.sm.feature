# time:1m32.08s
@api @disablecaptcha
# in the resource tests, when it uses "Given resources:" it defines a property called 'datastore created' with either a 'yes' or 'no', which is used in some tests -  should I try to map that when creating the resource in resourceContext? @Frank
Feature: Resource

  Background:
    Given pages:
      | name      | url             |
      | Content   | /admin/content  |
    Given users:
      | name    | mail                | roles                |
      | John    | john@example.com    | site manager         |
      | Katie   | katie@example.com   | content creator      |

  @resource_sm_01
  Scenario: Edit any resource
    Given resources:
      | title       | author   | published | description |
      | Resource 01 | Katie    | Yes       | None        |
    Given I am logged in as "John"
    And I am on "Resource 01" page
    When I click "Edit"
    And I fill in "title" with "Resource 01 edited"
    And I press "Save"
    Then I should see "Resource Resource 01 edited has been updated"
    When I am on "Content" page
    Then I should see "Resource 01 edited"

  @resource_sm_02
  Scenario: Publish any resource
    Given resources:
      | title       | author   | published | description |
      | Resource 02 | Katie    | No        | None        |
    Given I am logged in as "John"
    And I am on "Resource 02" page
    When I click "Edit"
    ## If you use selenium uncomment this
    # When I click "Publishing options"
    And I check "Published"
    And I press "Save"
    Then I should see "Resource Resource 02 has been updated"

  @resource_sm_03
  Scenario: Delete any resource
    Given resources:
      | title       | author   | published | description |
      | Resource 03 | Katie    | No        | None        |
    Given I am logged in as "John"
    And I am on "Resource 03" page
    When I click "Edit"
    And I press "Delete"
    And I press "Delete"
    Then I should see "Resource 03 has been deleted"

  @resource_sm_04
  Scenario: Manage Datastore of any resource
    Given resources:
      | title       | author   | published | description |
      | Resource 04 | Katie    | Yes       | None        |
    Given I am logged in as "John"
    And I am on "Resource 04" page
    When I click "Manage Datastore"
    Then I should see "There is nothing to manage! You need to upload or link to a file in order to use the datastore."

  @resource_sm_05 @datastore @javascript
  Scenario: Import items on datastore of any resource
    Given resources:
      | title       | author   | published | description |
      | Resource 05 | Katie    | Yes       | None        |
    Given I am logged in as "John"
    And I am on "Resource 05" page
    And I click "Edit"
    And I click "Remote file"
    And I fill in "edit-field-link-remote-file-und-0-filefield-dkan-remotefile-url" with "https://s3.amazonaws.com/dkan-default-content-files/files/datastore-simple.csv"
    And I press "Save"
    And I am on "Resource 05" page
    When I click "Manage Datastore"
    And I press "Import"
    And I wait for "Drop Datastore"
    Then "Resource 05" should have datastore records

  @resource_sm_06 @datastore @javascript
  Scenario: Drop datastore of any resource
    Given resources:
      | title       | author   | published | description |
      | Resource 06 | Katie    | Yes       | None        |
    Given I am logged in as "John"
    And I am on "Resource 06" page
    And I click "Edit"
    And I click "Remote file"
    And I fill in "edit-field-link-remote-file-und-0-filefield-dkan-remotefile-url" with "https://s3.amazonaws.com/dkan-default-content-files/files/datastore-simple2.csv"
    And I press "Save"
    And I am on "Resource 06" page
    When I click "Manage Datastore"
    And I press "Import"
    And I wait for "Drop Datastore"
    Then "Resource 06" should have datastore records
    When I click "Drop Datastore"
    And I press "Drop"
    Then I should see "Datastore dropped!"
    And "Resource 06" should have no datastore records

  @resource_sm_07
  Scenario: Add revision to any resource
    Given resources:
      | title       | author   | published | description |
      | Resource 07 | Katie    | Yes       | None        |
    Given I am logged in as "John"
    And I am on "Resource 07" page
    When I click "Edit"
    And I fill in "title" with "Resource 07 edited"
    And I check "Create new revision"
    And I press "Save"
    Then I should see "Resource Resource 07 edited has been updated"
    When I click "Revisions"
    Then I should see "Revisions allow you to track differences between multiple versions of your content"

  @resource_sm_08 @fixme
    #TODO: There is an issue where an admin, when clicking revert, gets a access unauthorized response.
    #     See: https://github.com/GetDKAN/dkan/issues/793
  Scenario: Revert any resource revision
    Given resources:
      | title       | author   | published | description |
      | Resource 08 | Katie    | Yes       | None        |
    Given I am logged in as "John"
    And I am on "Resource 08" page
    When I click "Edit"
    And I fill in "title" with "Resource 08 edited"
    And I press "Save"
    Then I should see "Resource Resource 08 edited has been updated"
    When I click "Revisions"
    And I click "Revert"
    And I press "Revert"
    Then I should see "Resource 08"
    And I should not see "Resource 08 edited"
