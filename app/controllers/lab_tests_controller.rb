# frozen_string_literal: true

# rubocop:disable Metrics/ClassLength
class LabTestsController < ApplicationController
  before_action :set_lab_test, only: %i[show edit update destroy]
  before_action :set_biomarkers, only: %i[new create]

  # GET /lab_tests or /lab_tests.json
  def index
    @recordables = policy_scope(LabTest)
                   .select(:recordable_id, :created_at)
                   .order(:created_at)
                   .group(:recordable_id, :created_at)
    @biomarkers = policy_scope(Biomarker)
                  .includes(:reference_ranges, :lab_tests)
                  .where(lab_tests: { user_id: current_user.id })
  end

  # GET /lab_tests/1 or /lab_tests/1.json
  def show
    authorize @lab_test
  end

  # GET /lab_tests/new
  def new
    @lab_test = LabTest.new
    authorize @lab_test
    @users = User.all if current_user.full_access_roles_can?
  end

  # GET /lab_tests/1/edit
  def edit
    # authorize @lab_test
  end

  # POST /lab_tests or /lab_tests.json
  def create
    build_lab_test
    authorize @lab_test

    ActiveRecord::Base.transaction do
      @health_record = HealthRecord.new(
        user: determine_user,
        notes: lab_test_params[:notes]
      )

      @lab_test.recordable = @health_record

      if save_health_record_with_lab_test
        handle_success_response
      else
        handle_error_response
      end
    end
  rescue StandardError
    handle_error_response('An error occurred while saving the test.')
  end

  # PATCH/PUT /lab_tests/1 or /lab_tests/1.json
  def update
    authorize @lab_test

    respond_to do |format|
      if @lab_test.update(lab_test_params)
        format.html { redirect_to @lab_test, notice: t('.success') }
        format.json { render :show, status: :ok, location: @lab_test }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @lab_test.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /lab_tests/1 or /lab_tests/1.json
  def destroy
    authorize @lab_test
    @lab_test.destroy!

    respond_to do |format|
      if request.referer == lab_test_url
        format.html { redirect_to lab_tests_path, status: :see_other, notice: t('.success') }
      else
        format.html do
          redirect_back_or_to lab_tests_path, status: :see_other, notice: t('.success')
        end
      end
      format.json { head :no_content }
    end
  end

  private

  def handle_success_response
    flash[:notice] = t('.success')
    redirect_to(@health_record)
  end

  def handle_error_response(message = nil)
    flash.now[:alert] = message if message
    @users = User.all if current_user.full_access_roles_can?
    load_error_dependencies
    render :new, status: :unprocessable_entity
  end

  def determine_redirect_path
    @health_record || @lab_test
  end

  def load_error_dependencies
    return if @lab_test.biomarker_id.blank?

    @selected_biomarker = @biomarkers.find(@lab_test.biomarker_id)
    @reference_ranges = @selected_biomarker.reference_ranges
  end

  def set_biomarkers
    @biomarkers = Biomarker.all
  end

  def set_lab_test
    @lab_test = LabTest.find(params[:id])
  end

  def save_health_record_with_lab_test
    @health_record.save && @lab_test.save
  end

  def lab_test_params
    params.require(:lab_test).permit(
      :biomarker_id,
      :value,
      :unit,
      :reference_range_id,
      :notes
    )
  end

  def determine_user
    if current_user.full_access_roles_can? && params[:user_id].present?
      User.find(params[:user_id])
    else
      current_user
    end
  end

  def build_lab_test
    @lab_test = current_user.lab_tests.build(lab_test_params)
  end
end
# rubocop:enable Metrics/ClassLength
