class Ad < ActiveRecord::Base

  # Constantes
  QTT_PER_PAGE = 6

  # RatyRate Gem
  ratyrate_rateable 'quality'

  # Callbacks
  before_save :md_to_html

  # Associações
  belongs_to :category, counter_cache: true
  belongs_to :member
  has_many :comments

  # Gem money-rails
  monetize :price_cents

  # Gem PaperClip
  has_attached_file :picture, styles: { large: "800x300#", medium: "320x150#", thumb: "100x100>" }, default_url: "/images/:style/missing.png"
  validates_attachment_content_type :picture, content_type: /\Aimage\/.*\z/

  # Scopes
  scope :descending_order, -> (page) {order(created_at: :desc).page(page).per(QTT_PER_PAGE)}
  scope :to_the, -> (member) {where(member: member)}
  scope :by_category, -> (params_id, page) {where(category: params_id).page(page).per(QTT_PER_PAGE)}
  scope :search, -> (search, page) {where('lower(title) LIKE ?', "%#{search.downcase}%").page(page).per(QTT_PER_PAGE)}
  scope :random_with_limit, -> (qantity) {limit(qantity).order("RAND()")}

  # Validates
  validates :title, :description_md, :description_short, :category, :picture, :finish_date,  presence: true
  validates :price, presence: true, numericality: {greater_than: 0}

  private

  def second
    self[1]
  end

  def third
    self[2]
  end

  def md_to_html
    options = {
      filter_html: true,
      link_attributes: {
        rel: 'nofollow',
        target: '_blank'
      }
    }

    extensions = {
      space_after_headers: true,
      autolink: true
    }

    renderer = Redcarpet::Render::HTML.new(options)
    markdown = Redcarpet::Markdown.new(renderer, extensions)

    self.description = markdown.render(self.description_md)
  end

end
