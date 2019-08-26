class Comparison < ApplicationRecord
    ## user has many comparisons. Each comparison contains two movies, superior and inferior.
    belongs_to :superior, class_name: "Movie"
    belongs_to :inferior, class_name: "Movie"
    belongs_to :user

    ## only one instance of a comparison allowed.
    validates :user_id, uniqueness: {scope: [:inferior_id, :superior_id] }

end
