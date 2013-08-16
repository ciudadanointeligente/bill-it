class Attachment
  include Mongoid::Document
  include Mongoid::Timestamps
  # The user who uploaded the file owns it
  # belongs_to :user
  belongs_to :bill
  # Attachment is polymorphic because a variety of things (project, team)
  # are "attachable", i.e. accept file uploads
  # belongs_to :attachable, :polymorphic => true
 
  # If you recall attachment_fu, this is kind of like "has_attachment":
  # mount_uploader :upload, UploadUploader
  # before_save :update_upload_attributes
 
  field :file_name, type: String

  # Sunspot indexing configuration
  include Sunspot::Mongoid2
  searchable do
    # Regular fields that I want indexed
    # integer :id
    time :created_at
    time :updated_at
    text :file_name
 
    # For Sunspot Cell. The 'attachment' directive instructs
    # Cell how to get the binary data. My understanding is that
    # this *must* end in _attachment
    attachment :document_attachment
  end
 
  # Goes hand-in-hand with the item above. Now, this is important:
  # the return value from this method is NOT the binary data itself,
  # but rather the full URI to the file. Cell will use this to locate
  # the file and index it.
  def document_attachment
    "#{Rails.root}/public/uploads/ps.doc"
  end
 
  # private
 
  # https://github.com/jnicklas/carrierwave/wiki/How-to%3A-Store-the-uploaded-file-size-and-content-type
  # def update_upload_attributes
  #   if upload.present? && upload_changed?
  #     self.content_type = upload.file.content_type
  #     self.file_size = upload.file.size
  #     self.file_name = File.basename(upload.url)
  #   end
  # end
end