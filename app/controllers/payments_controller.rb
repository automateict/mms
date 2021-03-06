class PaymentsController < ApplicationController
  before_action :authenticate_user!
  load_and_authorize_resource
  before_action :set_payment, only: [:show, :edit, :update, :destroy, :confirm]
  before_action :load, only: [:new, :create, :edit, :update]

  def load
    if params[:person]
      @people = [Person.find(params[:person])]
    else
      @people = current_user.organization_unit.sub_people
    end
  end
  # GET /payments
  # GET /payments.json
  def index
    if params['year']
      budget_year = BudgetYear.find(params['year'])
      @payments = budget_year.budget_year_payments
    else
      @payments = Payment.all
    end
  end

  def member_fees
    @unpaid_fees = []
    @type = params[:type]

    if @type == 'Unpaid' || @type == 'All'
      @unpaid_fees = current_user.person.unpaid_fees
    end
    @payments = current_user.person.payments
  end

  def confirm
    @payment.update(status: true)
    flash[:notice] = 'Payment was successfully confirmed.'
    redirect_to action: 'index'
  end

  # GET /payments/1
  # GET /payments/1.json
  def show
  end

  # GET /payments/new
  def new
    @payment = Payment.new
    @payment.person_id = params[:person]
    @payment.budget_year_id = params[:year]
    session[:return_to] = request.referer
  end

  # GET /payments/1/edit
  def edit
    session[:return_to] = request.referer
  end

  # POST /payments
  # POST /payments.json
  def create
    @payment = Payment.new(payment_params)

    respond_to do |format|
      if @payment.save
        format.html { redirect_to session.delete(:return_to), notice: 'Payment was successfully created.' }
        format.json { render :show, status: :created, location: @payment }
      else
        format.html { render :new }
        format.json { render json: @payment.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /payments/1
  # PATCH/PUT /payments/1.json
  def update
    respond_to do |format|
      if @payment.update(payment_params)
        format.html { redirect_to session.delete(:return_to), notice: 'Payment was successfully updated.' }
        format.json { render :show, status: :ok, location: @payment }
      else
        format.html { render :edit }
        format.json { render json: @payment.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /payments/1
  # DELETE /payments/1.json
  def destroy
    @payment.destroy
    respond_to do |format|
      format.html { redirect_to payments_url, notice: 'Payment was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_payment
      @payment = Payment.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def payment_params
      params.require(:payment).permit(:person_id, :attachment, :payment_method, :budget_year_id, :remark, :status)
    end
end
