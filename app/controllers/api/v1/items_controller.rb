class Api::V1::ItemsController < ApplicationController
  before_action :find_item, only: [:show, :update]

  def index
    items = if params[:page] && params[:per_page]
                  Item.paginate(page: params[:page], per_page: params[:per_page])
                elsif params[:page].to_i >= 1
                  Item.paginate(page: params[:page], per_page: 20)
                elsif params[:per_page]
                  Item.paginate(page: 1, per_page: params[:per_page])
                else
                  Item.paginate(page: 1, per_page: 20)
                end
    json_response(ItemSerializer.new(items))
  end

  def show
    json_response(ItemSerializer.new(@item))
  end

  def create
    item = Item.create!(item_params)
    json_response(ItemSerializer.new(item), :created)
  end

  def update
    @item.update!(item_params)
    json_response(ItemSerializer.new(@item), :accepted)
  end

  private

  def item_params
    params.require(:item).permit(:name, :description, :unit_price, :merchant_id)
  end

  def find_item
    @item = Item.find(params[:id])
  end
end
