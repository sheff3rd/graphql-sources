# frozen_string_literal: true

require_relative './active_record_base'

module GraphQL
  module Sources
    # A class for loading a count of records.
    #
    #   class Post
    #     has_many :likes
    #   end
    #
    #   class Like
    #     belongs_to :post
    #   end
    #
    #   class PostType < GraphQL::Schema::Object
    #     field :likes, Integer, null: false
    #
    #     def likes
    #       dataloader
    #         .with(GraphQL::Sources::ActiveRecordCount, ::Like, key: :post_id)
    #         .load(object.id)
    #     end
    #   end
    #
    # The resulting SQL query is:
    #
    #     SELECT "likes"."post_id", COUNT(*)
    #     FROM "likes"
    #     WHERE "likes"."post_id" IN (1, 2, 3, ...)
    #     GROUP BY "likes"."post_id"
    class ActiveRecordCount < ActiveRecordBase
      def fetch(keys)
        map = models(keys: keys).group(@key).count
        keys.map { |key| map[key] || 0 }
      end
    end
  end
end