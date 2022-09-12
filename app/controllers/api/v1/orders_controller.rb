module Api
  module V1
    class OrdersController < ApplicationController
      
      def create
        # フロントから配列で値が送られてくる。whereで配列を返す
        posted_line_foods = LineFood.where(id: params[:line_food_ids])
        order = Order.new(
          total_price: total_price(posted_line_foods),
        )
        # paramsで渡ってきたidのデータのactiveをfalseにする
        if order.save_with_update_line_foods!(posted_line_foods) # 引数ミスがあった場所
          render json: {}, status: :no_content
        else
          render json: {},status: :internal_server_error
        end
      end

    private

      def total_price(posted_line_foods)
        posted_line_foods.sum {|line_food| line_food.total_amount} + posted_line_foods.first.restaurant.fee
      end
    end
  end
end