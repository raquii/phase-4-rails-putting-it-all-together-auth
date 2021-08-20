class RecipesController < ApplicationController
    before_action :authorize
    rescue_from ActiveRecord::RecordNotFound, with: :render_response_not_found
    rescue_from ActiveRecord::RecordInvalid, with: :render_invalid

    def index
        recipes = Recipe.all
        render json: recipes, status: :created
    end

    def create
        user = User.find_by(id: session[:user_id])
        recipe = user.recipes.create!(recipe_params)
        render json: recipe, status: :created
    end 

    private

    def recipe_params
        params.permit(:title, :instructions, :minutes_to_complete)
    end

    def authorize
        return render json: {errors: ["Not Authorized"]}, status: :unauthorized unless session.include? :user_id
    end

    def render_response_not_found
        render json:{error: "Recipe not found"}, status: :not_found
    end

    def render_invalid(invalid)
        render json: {errors: invalid.record.errors.full_messages}, status: :unprocessable_entity
    end 
end
