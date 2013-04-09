require 'spec_helper'

describe "Projects" do
  before do
    login_as :user
    @project = FactoryGirl.create :project
  end

  describe "GET /projects" do
    before do
      visit projects_path
    end

    it { page.should have_content @project.name }
    it { page.should have_content 'Add Project' }
  end

  describe "GET /projects/:id" do
    before do
      visit project_path(@project)
    end

    it { page.should have_content @project.name }
    it { page.should have_content 'All builds' }
  end

  describe "GET /projects/:id/edit" do
    before do
      visit edit_project_path(@project)
    end

    it { page.should have_content @project.name }
    it { page.should have_content 'Build Schedule' }
  end

  describe "GET /projects/:id/stats" do
    before do
      visit stats_project_path(@project)
    end

    it { page.should have_content @project.name }
    it { page.should have_content 'Some stats related to the project' }
  end

  describe "GET /projects/:id/details" do
    before do
      visit details_project_path(@project)
    end

    it { page.should have_content @project.name }
    it { page.should have_content 'Integration with GitLab and other services' }
  end

  describe "GET /projects/:id/run" do
    before do
      visit run_project_path(@project, ref: 'master')
    end

    it { current_path.should == project_build_path(@project, @project.builds.last) }
    it { page.should have_content @project.builds.last.git_commit_message }
  end
end
