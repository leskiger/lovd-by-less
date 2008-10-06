module AssetsHelper
  
  def asset_title asset, opts = {}
    default_opts = {:null_message => ""}
    default_opts.update(opts) if opts.is_a? Hash
    asset.title ? default_opts[:null_message] : asset.title
  end

  def asset_caption asset, opts = {}
    default_opts = {:null_message => ""}
    default_opts.update(opts) if opts.is_a? Hash
    asset.caption ? default_opts[:null_message] : asset.caption
  end
end