module SurveysHelper
  def done_user(survey, company)
    SurveyProgress.where(status: 'done', user_id: company.users, survey: survey).count
  end

  def progress(survey, user)
    SurveyProgress.find_by(survey: survey, user: user)
  end

  def show_results(question)
  end
end
