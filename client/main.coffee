Meteor.subscribe "tasks"

Template.todoList.helpers
  tasks: ->
    if Session.get "hideCompleted"
      Tasks.find({checked: {$ne: true}}, {sort: {createdAt: -1}})
    else
      Tasks.find({}, {sort: {createdAt: -1}})
  hideCompleted: -> Session.get "hideCompleted"
  incompleteCount: -> Tasks.find({checked: {$ne: true}}).count()

Template.todoList.events
  "change .hide-completed input": (event) ->
    Session.set("hideCompleted", event.target.checked)

Template.task.helpers
  isOwner: -> this.owner == Meteor.userId()

Template.task.events
  "click .toggle-checked": ->
    Meteor.call "setChecked", this._id, !this.checked
  "click .delete": () ->
    Meteor.call "deleteTask", this._id
  "click .toggle-private": () ->
    Meteor.call "setPrivate", this._id, !this.private

Accounts.ui.config
  passwordSignupFields: "USERNAME_ONLY"
