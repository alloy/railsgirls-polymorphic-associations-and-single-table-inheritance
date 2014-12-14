class Invoice < ActiveRecord::Base
  belongs_to :purchasable, :polymorphic => true
end
