class Server < ActiveRecord::Base

  has_attached_file :banner, styles: { resized: "480x68"}, default_url: "nobanner", :storage => :s3,
      :s3_credentials => Proc.new{|a| a.instance.s3_credentials }, :s3_region => 'us-west-2', :s3_permissions => 'public-read',
                    :url            => ":s3_alias_url",
                    :s3_host_alias  => 'cdn.minecraft-pe-servers.com',
                    hash_secret: "94dfda08e2ed473257345563594dfda08e2ed473257345563594dfda08e2ed473257345563594dfda08e2ed4732573455635",
                    path: 'servers/:attachment/resized:hash.:extension'

  validates_attachment_content_type :banner, content_type: /\Aimage\/.*\Z/
  has_many :tags

  def s3_credentials
    {:bucket => "cdn.minecraft-pe-servers.com", :access_key_id => "AKIAJQPU6FCAI3OMHT5A", :secret_access_key => "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"}
  end



end
