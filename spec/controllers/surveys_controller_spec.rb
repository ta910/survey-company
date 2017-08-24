require 'rails_helper'

describe SurveysController do
  let(:user) { create(:user, company: company) }
  let(:surveys) { create_list(:survey, 3) }
  let(:survey) { create(:survey) }
  let(:company) { create(:company) }
  before do
    login_user user
  end

  describe 'GET index' do
    before do
      get :index, params: { company_name: company.name }
    end
    it 'returns a 200 OK status'  do
      expect(response.status).to eq 200
    end
    it 'assigns the requested surveys to @surveys' do
      expect(assigns(:surveys)).to eq surveys
    end
    it 'renders the :index template' do
      expect(response).to render_template :index
    end
  end

  describe 'GET show' do
    context 'if requested survey is exist' do
      before do
        create(:survey_progress, user: user, survey: survey)
        get :show, params: { company_name: company.name, id: survey.id }
      end
      it 'returns a 200 OK status' do
        expect(response.status).to eq 200
      end
      it 'assigns the requested survey to @survey' do
        expect(assigns(:survey)).to eq survey
      end
      it 'renders the :show template' do
        expect(response).to render_template :show
      end
    end
    context 'if requested survey is not exist' do
      it 'redirect to top' do
        get :show, params: { company_name: 'hogehoge', id: 1234 }
        expect(response).to redirect_to root_path
      end
    end
  end

  describe 'GET answer_new' do
    before do
      get :answer_new, params: { company_name: company.name, id: survey.id }
    end
    it 'returns a 200 OK status' do
      expect(response.status).to eq 200
    end
    it 'assigns new @answer_choice' do
      expect(assigns(:answer_choice)).to be_a_new(AnswerChoice)
    end
    it 'renders the :answer_new template' do
      expect(response).to render_template :answer_new
    end
  end

  describe 'POST answer_create' do
    let(:question) { create(:question, survey: survey) }
    let(:question_choice) { create(:question_choice, question: question) }
    context 'with valid parameter' do
      let(:answer_choice_params) { { "#{question.id}": { question_choice_id: question_choice.id } } }
      let(:request) { post :answer_create, params: { company_name: company.name, id: survey.id, done: '回答', answer_choice: answer_choice_params } }
      it 'returns a 302 redirect' do
        request
        expect(response.status).to eq 302
      end
      it 'saves the new answer_choice in database' do
        expect{request}.to change(AnswerChoice, :count).by(1)
      end
      it 'redirect to index' do
        request
        expect(response).to redirect_to company_surveys_path(company.name)
      end
    end
    context 'with invalid parameter' do
      let(:request) { post :answer_create, params: { company_name: company.name, id: survey.id, answer_choice: 'hogehoge'} }
      it 'returns a 200 OK status' do
        request
        expect(response.status).to eq 200
      end
      it 'does not save in database' do
        expect{request}.not_to change(AnswerChoice, :count)
      end
      it 'renders the :answer_new template' do
        request
        expect(response).to render_template :answer_new
      end
    end
  end

  describe 'GET answer_edit' do
    before do
      get :answer_edit, params: { company_name: company.name, id: survey.id }
    end
    it 'returns a 200 OK status' do
      expect(response.status).to eq 200
    end
    it 'renders the :answer_edit template' do
      expect(response).to render_template :answer_edit
    end
  end

  describe 'PATCH answer_update' do
    let(:question) { create(:question, survey: survey) }
    let(:question_choice) { create(:question_choice, question: question) }
    context 'with valid parameter' do
      let(:answer_choice_params) { { "#{question.id}": { question_choice_id: @after_question_choice.id } } }
      before do
        @after_question_choice = create(:question_choice, question: question)
        @answer_choice = create(:answer_choice, user: user, question_choice: question_choice)
        patch :answer_update, params: { company_name: company.name, id: survey.id, done: '回答', answer_choice: answer_choice_params }
      end
      it 'returns a 302 redirect' do
        expect(response.status).to eq 302
      end
      it 'update answer_choice' do
        expect(AnswerChoice.all.first.question_choice_id).to eq @after_question_choice.id
      end
      it 'redirect to index' do
        expect(response).to redirect_to company_surveys_path(company.name)
      end
    end
    context 'with invalid parameter' do
      before do
        @answer_choice = create(:answer_choice, user: user, question_choice: question_choice)
        @pre_question_choice_id = @answer_choice.question_choice_id
        patch :answer_update, params: { company_name: company.name, id: survey.id, answer_choice: 'hogehoge'}
      end
      it 'returns a 200 OK status' do
        expect(response.status).to eq 200
      end
      it 'does not update answer_choice' do
        expect(AnswerChoice.all.first.question_choice_id).to eq @pre_question_choice_id
      end
      it 'renders the :answer_edit template' do
        expect(response).to render_template :answer_edit
      end
    end
  end
end
