class Site::HomeController < SiteController

  def index
    @categories = Category.order_by_description
    @ads = Ad.descending_order(params[:page])
    @carousel = Ad.random_with_limit(3)
  end

end
