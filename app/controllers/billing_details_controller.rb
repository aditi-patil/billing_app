class BillingDetailsController < ApplicationController
  before_action :set_billing_detail, only: [:show, :edit, :update, :destroy]

  # GET /billing_details
  # GET /billing_details.json
  def index
    @billing_details = BillingDetail.all
  end

  # GET /billing_details/1
  # GET /billing_details/1.json
  def show
  end

  # GET /billing_details/new
  def new
    @billing_detail = BillingDetail.new
  end

  # GET /billing_details/1/edit
  def edit
  end

  # POST /billing_details
  # POST /billing_details.json
  def create
    @billing_detail = BillingDetail.new(billing_detail_params)

    respond_to do |format|
      if @billing_detail.save
        format.html { redirect_to @billing_detail, notice: 'Billing detail was successfully created.' }
        format.json { render :show, status: :created, location: @billing_detail }
      else
        format.html { render :new }
        format.json { render json: @billing_detail.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /billing_details/1
  # PATCH/PUT /billing_details/1.json
  def update
    respond_to do |format|
      if @billing_detail.update(billing_detail_params)
        format.html { redirect_to @billing_detail, notice: 'Billing detail was successfully updated.' }
        format.json { render :show, status: :ok, location: @billing_detail }
      else
        format.html { render :edit }
        format.json { render json: @billing_detail.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /billing_details/1
  # DELETE /billing_details/1.json
  def destroy
    @billing_detail.destroy
    respond_to do |format|
      format.html { redirect_to billing_details_url, notice: 'Billing detail was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  def calculate_total
    @start_date = Date.today.beginning_of_month
    @end_date = Date.today.end_of_month
    @details = BillingDetail.where("paid_date between Date(?) and Date(?)", @start_date, @end_date).group_by(&:total_amount)
    @details_of_amar = BillingDetail.where("paid_date between Date(?) and Date(?) and name = (?)", @start_date, @end_date, 'Amar').group_by(&:total_amount)
    @details_of_akbar = BillingDetail.where("paid_date between Date(?) and Date(?) and name = (?)", @start_date, @end_date, 'Akbar').group_by(&:total_amount)
    @details_of_anthony = BillingDetail.where("paid_date between Date(?) and Date(?) and name = (?)", @start_date, @end_date, 'Anthony').group_by(&:total_amount)
    @amar_total_amt = 0
    @amar_paid_amt = 0
    @akbar_total_amt = 0
    @akbar_paid_amt = 0
    @anthony_total_amt = 0
    @anthony_paid_amt = 0

    @details.each do |data|
      if data[1].length == 3
        @single_amt = data[0]/3
      elsif data[1].length == 2
        @single_amt = data[0]/2
      else
        @single_amt = data[0]
      end
      data[1].each do |d|
        if d.name == 'Amar'
          @amar_paid_amt = @amar_paid_amt + d.amount
          @amar_total_amt = @amar_total_amt + @single_amt 
        elsif d.name == 'Akbar'
          @akbar_paid_amt = @akbar_paid_amt + d.amount
          @akbar_total_amt = @akbar_total_amt + @single_amt
        else
          @anthony_paid_amt = @anthony_paid_amt + d.amount
          @anthony_total_amt = @anthony_total_amt + @single_amt
        end
      end
    end
          
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_billing_detail
      @billing_detail = BillingDetail.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def billing_detail_params
      params.require(:billing_detail).permit(:event, :paid_date, :location,:total_amount, :amount, :name)
    end
end
