# frozen_string_literal: true

# Interactor to toggle a like (reaction) for a Post.
# Context expects :account and :post.
class TogglePostLike
  include Interactor

  def call
    account = context.account
    post = context.post

    unless account && post
      context.fail!(message: 'Missing account or post')
      return
    end

    reaction = Reaction.find_by(account_id: account.id, post_id: post.id)

    if reaction
      if reaction.destroy
        context.deleted = true
        context.reaction = nil
      else
        context.fail!(message: reaction.errors.full_messages.join(', '))
      end
    else
      new_reaction = Reaction.new(account: account, post: post, target: post)
      if new_reaction.save
        context.reaction = new_reaction
        context.created = true
      else
        context.fail!(message: new_reaction.errors.full_messages.join(', '))
      end
    end
  rescue StandardError => e
    context.fail!(message: e.message)
  end
end
