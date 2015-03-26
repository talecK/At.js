class TextareaController extends Controller
  # Catch query string behind the at char
  #
  # @return [Hash] Info of the query. Look likes this: {'text': "hello", 'headPos': 0, 'endPos': 0}
  catchQuery: ->
    content = @$inputor.val()
    caretPos = @$inputor.caret('pos', {iframe: @app.iframe})
    subtext = content.slice(0, caretPos)
    query = this.callbacks("matcher").call(this, @at, subtext, this.getOpt('startWithSpace'))
    if typeof query is "string" and query.length <= this.getOpt('maxLen', 20)
      start = caretPos - query.length
      end = start + query.length
      @pos = start
      query = {'text': query, 'headPos': start, 'endPos': end}
      this.trigger "matched", [@at, query.text]
    else
      query = null
      @view.hide()

    @query = query

  # Insert value of `data-value` attribute of chosen item into inputor
  #
  # @param content [String] string to insert
  insert: (content, $li) ->
    $inputor = @$inputor
    source = $inputor.val()
    startStr = source.slice 0, Math.max(@query.headPos - @at.length, 0)
    suffix = if (suffix = @getOpt 'suffix') == "" then suffix else suffix or " " 
    content += suffix
    text = "#{startStr}#{content}#{source.slice @query['endPos'] || 0}"
    $inputor.val text
    $inputor.caret('pos', startStr.length + content.length, {iframe: @app.iframe})
    $inputor.focus() unless $inputor.is ':focus'
    $inputor.change()
