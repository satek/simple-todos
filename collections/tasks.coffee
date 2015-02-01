@Tasks = new Mongo.Collection("tasks")
@Tasks.attachSchema new SimpleSchema
  text:
    type: String
    label: "Text"
    max: 200
  owner:
    type: String
    autoValue: -> Meteor.user()._id
  username:
    type: String
    optional: true
    autoValue: -> Meteor.user().username
  private:
    type: Boolean
    optional: true
  checked:
    type: Boolean
    optional: true
  createdAt:
    type: Date
    autoValue: ->
      if this.isInsert
        new Date()
      else if this.isUpsert
        {$setOnInsert: new Date}
      else
        this.unset()
    denyUpdate: true
    optional: true
  updatedAt:
    type: Date
    autoValue: -> if this.isUpdate then new Date()
    denyInsert: true
    optional: true

Tasks.allow
  insert: (userId, doc) ->
    userId? and doc.owner == userId
  update: (userId, doc, fields, modifier) ->
    userId? and doc.owner == userId
