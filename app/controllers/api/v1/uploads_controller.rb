require "securerandom"

module Api
  module V1
    class UploadsController < ApplicationController
      # 5 MB — matches every other CLIuno backend template.
      MAX_UPLOAD_BYTES = 5 * 1024 * 1024

      # The extension comes from the detected mime, never from the client's filename.
      ALLOWED_IMAGE_TYPES = {
        "image/png" => ".png",
        "image/jpeg" => ".jpg",
        "image/webp" => ".webp",
        "image/gif" => ".gif"
      }.freeze

      # POST /api/v1/uploads/image
      # Stores the bytes and hands back a URL. Attaching it to a user or a post is the
      # caller's job (PATCH /users/current, POST /posts) — upload mutates nothing.
      def image
        file = params[:file]
        return render_error("No image file provided", :bad_request) if file.blank?

        extension = ALLOWED_IMAGE_TYPES[file.content_type]
        return render_error("Unsupported image type: #{file.content_type}", :bad_request) if extension.nil?

        if file.size > MAX_UPLOAD_BYTES
          return render_error("Image exceeds the 5 MB limit", :payload_too_large)
        end

        filename = "#{SecureRandom.uuid}#{extension}"
        # public/ is the docroot, so this is served back at /uploads/<filename>.
        target = Rails.root.join("public", "uploads")
        FileUtils.mkdir_p(target)
        File.binwrite(target.join(filename), file.read)

        # Absolute so a frontend on another origin can use it straight as an image source.
        base = (ENV["PUBLIC_BASE_URL"].presence || request.base_url).sub(%r{/+\z}, "")
        render_success({ url: "#{base}/uploads/#{filename}", filename: filename },
                       "Image uploaded", :created)
      end
    end
  end
end
