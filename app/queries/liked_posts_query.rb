# frozen_string_literal: true

# Query object to fetch posts liked by a given account.
# Returns an ActiveRecord::Relation so callers can further chain or paginate.
class LikedPostsQuery
  def initialize(account)
    @account = account
  end

  def call
    return Post.none unless @account.present?

    Post.joins(:reactions)
        .where(reactions: { account_id: @account.id })
        .order('reactions.created_at DESC')
  end
end
# frozen_string_literal: true

# Query object to fetch posts liked by a given account.
# Returns an ActiveRecord::Relation of Post ordered by the reaction's created_at (most recent first).
class LikedPostsQuery
  attr_reader :account

  def initialize(account)
    @account = account
  end

  # Execute the query
  # @return [ActiveRecord::Relation<Post>]
  def call
    return Post.none unless account.present?

    Post.joins(:reactions)
        .where(reactions: { account_id: account.id })
        .order('reactions.created_at DESC')
  end
end
