# Uberist - Wunderlist3 widget for Übersicht
#
# https://github.com/chagel/uberist
# This project is released under the MIT license. 
# Copyright 2015 Mike Chen

access_token: ''
client_id: ''
list_filter: ['inbox']
slogan: 'Stay Focused'

command: 'echo Loading..'
wundersdk: 'https://raw.githubusercontent.com/wunderlist/wunderlist.js/master/dist/wunderlist.sdk.min.js'
refreshFrequency: 1000*60*10 #10m
 
style: """
  top: 100px
  left: 350px
  width: 50%
  height: 600px
  padding: 20px
  font-family: Monaco, "Helvetica Neue", Arial, sans-serif
  font-size: 12px
       
  .header
    padding: 2px
    background-color: rgba(0, 0, 0, .2)
    text-align: center

  .header h2
    color: #fff
    font-family: Copperplate, sans-serif
    font-size: 25px
    font-weight: 200

  .tasks
    margin: 0
    padding: 0

  .task
    list-style: none
    background-color: rgba(255, 255, 255, .8)
    padding: 5px
    margin-bottom: 2px

"""

render: (output) -> """
  <div>#{ output }</div>
"""

update: (output, domEl) ->
  $.getScript(@wundersdk).done( =>
    content = $(domEl).empty().append("<div class='header'><h2>#{@slogan}</h2></div>")
    WunderlistSDK = window.wunderlist.sdk
    api = new WunderlistSDK({'accessToken': @access_token, 'clientID': @client_id})
    api.initialized.done =>
      api.http.lists.all()
        .done((listsData) =>
          listsData.forEach (list) =>
            if @list_filter.indexOf(list.title) > -1 
              api.http.tasks.forList(list.id).done((tasksData) ->
                content.append "<ul class='tasks'>"
                tasksData.forEach (task) ->
                  content.append "<li class='task'><input type='checkbox'> "+task.title+"</li>"
                content.append "</ul>"
              )
              
        )
  )
