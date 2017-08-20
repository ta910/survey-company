$(document).on 'turbolinks:load', ->

  questionNum = 0
  choiceNum = 0

  TextFieldHTML = (num) ->
    """<div class="question">
         <h3>質問</h3>
         <input id="delete-question-button" type="button" value="削除"><br>
         <input placeholder="質問内容(回答短)" type="text" name="survey[questions][][name]" id="survey_questions_#{num}_name">
         <input type="hidden" value="text_field" name="survey[questions][][status]" id="survey_questions_#{num}_status">
       </div>"""

  TextAreaHTML = (num) ->
    """<div class="question">
         <h3>質問</h3>
         <input id="delete-question-button" type="button" value="削除"><br>
         <input placeholder="質問内容(回答長)" type="text" name="survey[questions][][name]" id="survey_questions_[#{num}]_name">
         <input type="hidden" value="textarea" name="survey[questions][][status]" id="survey_questions_#{num}_status">
       </div>"""

  RadioButtonHTML = (num) ->
    """<div class="question">
         <h3>質問</h3>
         <input id="delete-question-button" type="button" value="削除"><br>
         <input placeholder="質問内容(ラジオボタン)" type="text" name="survey[questions][][name]" id="survey_questions_[#{num}]_name"><br>
         <ol class="choices"></ol>
         <input id="add-choice-button" type="button" value="選択肢追加">
         <input type="hidden" value="radio_button" name="survey[questions][][status]" id="survey_questions_#{num}_status">
       </div>"""


  CheckBoxHTML = (num) ->
    """<div class="question">
         <h3>質問</h3>
         <input id="delete-question-button" type="button" value="削除"><br>
         <input placeholder="質問内容(チェックボックス)" type="text" name="survey[questions][][name]" id="survey_questions_[#{num}]_name"><br>
         <ol class="choices"></ol>
         <input id="add-choice-button" type="button" value="選択肢追加">
         <input type="hidden" value="check_box" name="survey[questions][][status]" id="survey_questions_#{num}_status">
       </div>"""

  appendQuestionHTML = (num, type) ->
    field = $('#question-field')
    switch type
      when 'text_field'
        field.append(TextFieldHTML(num))
      when 'textarea'
        field.append(TextAreaHTML(num))
      when 'radio_button'
        field.append(RadioButtonHTML(num))
      when 'check_box'
        field.append(CheckBoxHTML(num))

  $('#add-question-button').on 'click', ->
    questionNum += 1
    questionType = $('#survey_question_status').val()
    appendQuestionHTML(questionNum, questionType)

  $('#question-field').on 'click', '#delete-question-button', ->
    $(this).parent('.question').remove()

  $('#question-field').on 'click', '#add-choice-button', ->
    choiceNum += 1
    html = """<li><input placeholder="選択肢" type="text" name="survey[questions][][choices][][name]" id="survey_question_choices_[#{choiceNum}]"></li>"""
    $(this).siblings('.choices').append(html)
