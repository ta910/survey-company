module SurveysHelper
  def done_user(survey, company)
    SurveyProgress.where(user_id: company.users, survey: survey).length
  end
end