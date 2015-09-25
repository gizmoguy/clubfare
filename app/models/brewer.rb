class Brewer < ActiveRecord::Base
	has_many :beers

	validates :name, length: { maximum: 100 }, presence: true
	validates :location, length: { maximum: 100 }, presence: true
	validates :account, length: { minimum: 2 }, presence: true
	
	class <<self

        def search(search, page)
			order('name').where('name ILIKE ?', "%#{search}%").paginate(page: page, per_page: 20)
        end

    end

end
