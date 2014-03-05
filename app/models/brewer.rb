class Brewer < ActiveRecord::Base
	has_many :beers

	validates :name, length: { maximum: 100 }
	validates :location, length: { maximum: 100 }
	validates :account, length: { minimum: 2 }
	
	class <<self

        def search(search, page)
            paginate :per_page => 15, :page => page,
                :conditions => ['name LIKE ?', "%#{search}%"],
                :order => 'name'
        end

    end

end
