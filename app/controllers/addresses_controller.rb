class AddressesController < ApplicationController
  before_action :set_address, only: [:show, :edit, :update, :order_progress]

  # # GET /addresses
  # # GET /addresses.json
  # def index
  #   @addresses = Address.all
  # end

  # GET /addresses/1
  # GET /addresses/1.json
  def show
    unless @address.button_code.present?      
      coinbase = Coinbase::Client.new(ENV['COINBASE_API_KEY'])
      button = coinbase.create_button "Your Order ##{ @address.id }", 0.01, "1 pass for your #{ @address.name } address", "A#{ @address.id }"
      @address.update button_code: button.button.code
    end
  end
  
  # GET /addresses/new
  def new
    if params[:address]
      @address = Address.new(address_params)
    else
      @address = Address.new
    end
  end

  # GET /addresses/1/edit
  def edit
  end

  # POST /addresses
  def create
    @address = Address.new(address_params)

    respond_to do |format|
      if @address.save
        format.html { redirect_to @address, notice: 'Address was found.' }
      else
        format.html { render action: 'new' }
      end
    end
  end

  # PATCH/PUT /addresses/1
  # PATCH/PUT /addresses/1.json
  def update
    respond_to do |format|
      if @address.update(address_params)
        format.html { redirect_to @address, notice: 'Address was found.' }
        format.json { head :no_content }
      else
        format.html { render action: 'edit' }
        format.json { render json: @address.errors, status: :unprocessable_entity }
      end
    end
  end
  
  def order_progress
    respond_to do |format|
      format.html {
        render "_order_progress", :layout => nil
      }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_address
      @address = Address.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def address_params
      params.require(:address).permit(:base58, :name)
    end
end