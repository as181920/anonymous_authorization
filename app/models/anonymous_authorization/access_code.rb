module AnonymousAuthorization
  class AccessCode < ApplicationRecord
    belongs_to :accessible, polymorphic: true

    validates :code, presence: true

    before_validation :set_initial_code, on: :create

    private

      def set_initial_code
        self.code ||= Random.rand(100000..999999)
      end
  end
end
