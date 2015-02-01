Meteor.methods
  addTask: (text) ->
    if (! Meteor.userId())
      throw new Meteor.Error("not-authorized")
    Tasks.insert
      text: text,
      createdAt: new Date(),
      owner: Meteor.userId(),
      username: Meteor.user().username
  deleteTask: (taskId) ->
    task = Tasks.findOne taskId
    if task.private && task.owner != Meteor.userId()
      throw new Meteor.Error("not-authorized")
    Tasks.remove(taskId)
  setChecked: (taskId, setChecked) ->
    task = Tasks.findOne taskId
    if task.private && task.owner != Meteor.userId()
      throw new Meteor.Error("not-authorized")
    Tasks.update(taskId, { $set: { checked: setChecked} })
  setPrivate: (taskId, setToPrivate) ->
    task = Tasks.findOne(taskId)
    if task.owner != Meteor.userId()
      throw new Meteor.Error("not-authorized")
    Tasks.update taskId, { $set: { private: setToPrivate } }
