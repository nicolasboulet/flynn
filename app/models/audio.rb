class Audio < ApplicationRecord
  belongs_to :user
  # has_one_attached :audiofile

  FILE_EXTENSION = 'mp3'.freeze
end
