module Api
  module V1
    class LineFoodsController < ApplicationController
      before_action :set_foods, only: %i[ create replace ]

      def index
        line_foods = LineFood.active
        if line_foods.exists?
          render json: {
            #mapメソッドで配列形式にする
            line_food_ids: line_foods.map{|line_food| line_food.id},
            restaurant: line_foods[0].restaurant,
            count: line_foods.sum { |line_food| line_food[:count] },
            amount: line_foods.sum{ |line_food| line_food.total_aomount },
          }, status: :ok
          else
            render json: {},status: :no_content
        end
      end

      def create
        #LineFoodのデータベースにあるactiveがtrueになっているデータの中から、＠ordered_foodと紐づいているレストランのidを引数に取り、存在しているかをif文で判定している
        #trueの処理に例外処理を記述して、return文を返すことでエラーが起きた場合それより先に処理がいかないようにしている
        if LineFood.active.other_restaurant(@ordered_food.restaurant.id).exists?
          return render json: {
            existing_restaurant: LineFood.other_restaurant(@ordered_food.restaurant.id).first.restaurant.name,
            new_restaurant: Food.find(params[:food_id]).restaurant.name,
          }, status: :not_acceptable

          #privateメソッドのset_line_foodを呼び出している
          #ここで@line_foodが作られる
          set_line_food(@ordered_food)


          if @line_food.save!
            render json: {
              line_food: @line_food
            },status: :created #保存したデータを返す
            else
              render json: {},status: : internal_server_error
          end

        end
      end

      def replace
        LineFood.active.other_restaurant(@ordered_food.restaurant.id).each do |line_food|
        line_food.update_attribute(:active, false)
        end

        set_line_food(@ordered_food)

        if @line_food.save
          render json: {
            line_food: @line_food
          }, status: :created
        else
          render json: {}, status: :internal_server_error
        end
      end

      private #このコントローラでしか呼ばれない処理はprivateに記述する
  
      def set_foods
        @ordered_food = Food.find(params[:food_id])
      end

      def set_line_food(ordered_food) #Foodモデルの情報が渡される
        if ordered_food.line_food.present?
          @line_food = ordered_food.line_food

          @line_food.attributes = {
            #attributes = {}で属性（プロパティ）の値を更新している
            count: ordered_food.line_food.count + params[:count],
            active: true
          }
        else
          @line_food = ordered_food.build_line_food(
            count: params[:count],
            restaurant: ordered_food.restaurant,
            active: true
          )
        end
      end
    end
  end
end