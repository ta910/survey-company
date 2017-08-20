module SurveysHelper
  def done_user(survey, company)
    SurveyProgress.where(status: 'done', user_id: company.users, survey: survey).count
  end

  def progress(survey, user)
    SurveyProgress.find_by(survey: survey, user: user)
  end

  def t_answer(question, company)
    AnswerText.where(question: question, user_id: company.users.ids)
  end

  def show_results(question, company)
    AnswerChoice.where(user_id: company.users.ids, question_choice_id: question.question_choices.ids).group(:question_choice_id).count
  end
end
