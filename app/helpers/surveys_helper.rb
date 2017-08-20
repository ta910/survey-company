module SurveysHelper
  def done_user(survey, company)
    SurveyProgress.where(status: 'done', user_id: company.users, survey: survey).count
  end

  def show_results(question)
  end
end
