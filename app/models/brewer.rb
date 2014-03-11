class Brewer < ActiveRecord::Base
	has_many :beers

	validates :name, length: { maximum: 100 }
	validates :location, length: { maximum: 100 }
	validates :account, length: { minimum: 2 }
	
	class <<self

        def search(search, page)
			order('name').where('name LIKE ?', "%#{search}%").paginate(page: page, per_page: 20)
        end

    end

end
