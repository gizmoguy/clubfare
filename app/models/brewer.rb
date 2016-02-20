class Brewer < ActiveRecord::Base
	has_many :beers

	validates :name, length: { maximum: 100 }, presence: true
	validates :location, length: { maximum: 100 }, presence: true
	validates :account, length: { minimum: 2 }, presence: true
	
	class <<self

	def search(search, page)
		if search.to_s.empty?
			results = order('name')
		else
			results = order('name').where('name ILIKE ?', "%#{search}%")
		end
		results.paginate(page: page, per_page: 10)
	end

    end

end
