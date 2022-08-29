class UserDetailsController < ApplicationController

  def create
    user_detail = params.require(:user_detail).permit(:user_id, :description_a)
    validate_user_id(user_detail[:user_id])

    render :json => UserDetail.create(user_detail)
  end

  def update
    id = params.require(:id)
    validate_user_detail_id(id)

    user_detail = params.require(:user_detail).permit(:description_a)

    render :json => UserDetail.update(id, user_detail)
  end

  def upload_picture_a
    user_detail_id = params.require(:user_detail_id)
    picture_a = params.require(:picture_a)
    validate_user_detail_id(user_detail_id)

    user_detail = UserDetail.find(user_detail_id)
    user_detail.picture_a = picture_a
    user_detail.save!

    render :json => user_detail
  end

  private

  def validate_user_id(user_id)
    unless @user.id == user_id
      raise ApiErrors::OwnerRequiredError
    end
  end

  def validate_user_detail_id(user_detail_id)
    user_detail = UserDetail.find(user_detail_id)
    unless @user.id == user_detail.user_id
      raise ApiErrors::OwnerRequiredError
    end
  end
end
