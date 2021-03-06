class ItemsController < ApplicationController
  require "payjp"
  before_action :set_item, only: [:show, :destroy, :buyers, :buy, :edit, :update]
  before_action :set_payjp_api_key, only: [:buyers, :buy]
  before_action :set_credit_card_customer, only: [:buyers, :buy]


  def index
    @items = Item.all.order('id DESC').limit(10)
  end

  def show
    @seller = @item.seller.nickname
  end

  def new
    @item = Item.new
    @category_parents = Category.where(ancestry: nil)
    @item.item_images.new
  end

  def create
    @item = Item.new(item_params)
    brand_name = params[:item][:brand]
    @category_parents = Category.where(ancestry: nil)
    if brand_name 
      if Brand.where(name: brand_name).present?
        brand_id = Brand.find_by(name: brand_name).id
        @item.brand_id = brand_id
      else
        Brand.create(name: brand_name)
        brand_id = Brand.find_by(name: brand_name).id
        @item.brand_id = brand_id
      end
    end
      if @item.save
        redirect_to root_path
      else
        @item.item_images = []
        @item.item_images.new
        render :new
       
      end
  end

  def edit   
    @category_parents = Category.where(ancestry: nil)
    @item.item_images.build
  end

  def update
    @category_parents = Category.where(ancestry: nil)
    brand_name = params[:item][:brand]
    if brand_name 
      if Brand.where(name: brand_name).present?
        brand_id = Brand.find_by(name: brand_name).id
        @item.brand_id = brand_id
      else
        Brand.create(name: brand_name)
        brand_id = Brand.find_by(name: brand_name).id
        @item.brand_id = brand_id
      end 
    end
    if @item.update(item_params)
      redirect_to root_path
    else
      render :edit
    end
  end

  def destroy
    if @item.destroy
      redirect_to  delete_done_items_path
    else
      flash.now[:alert] = '削除できませんでした'
      render :show
    end
  end

  def buyers
    @send = UserAddress.where(user_id: current_user.id).first
  end

  def buy
    price = @item.price

    charge = Payjp::Charge.create(
      :amount => price,
      :customer => @customer.id,
      :currency => 'jpy',
    )

    if charge.to_h.has_key?("error")
      redirect_to buyers_item_path(@item.id), notice: "商品を購入できませんでした"
    else
      if @item.update(buyer_id: current_user.id, deal_done_date: Time.current)
        redirect_to root_path, notice: "商品を購入しました"
      else 
        redirect_to buyers_item_path(@item.id), notice: "商品を購入できませんでした"
      end
    end
  end

  def delete_done
  end

  def credit_card
  end

  private

  def item_params
    params.require(:item).permit(:name, :introduction, :price,  :condition_id, :postage_burden_id, :prefecture_code, 
    :category_id, :postage_days_id, 
     item_images_attributes: [:image, :_destroy, :id]).merge( seller_id: current_user.id)
  end

  def set_item
    @item = Item.find(params[:id])
  end

  def set_payjp_api_key
    Payjp.api_key =  ENV["PAYJP_ACCESS_KEY"]
  end

  def set_credit_card_customer
    @credit_card = CreditCard.find_by(user_id: current_user.id)
    if @credit_card.blank?
      redirect_to credit_card_items_path
    else
      @customer = Payjp::Customer.retrieve(@credit_card.payjp_customer_id)
      @card = @customer.cards.retrieve(@credit_card.payjp_card_id)
    end
  end

end
