require 'rubygems'
require 'cgi'
require 'hmac'
require 'hmac-sha2'
require 'digest'
require 'net/https'
require 'uri'

module RTunesU
  class Connection
    attr_accessor :user, :options, :token
    
    def initialize(options = {})
      self.user, self.options = options[:user], options
    end
    
    def generate_authorization_token
    	# create the token that contains the necessary elements to authorize the user	
    	# using a nested array because the alphabetical order must be maintained
    	token = [['credentials', self.user.to_credential_string,], ['identity', self.user.to_identity_string], ['time', Time.now.to_i.to_s]]
    	encoded_parms = token.collect {|pair| pair[1] = CGI.escape(pair[1]); pair.join('=')}.join('&')

      digest = Digest::SHA2.new
      digest.update(encoded_parms)

      hmac = HMAC::SHA256.new(self.options[:shared_secret])
      hmac.update(encoded_parms)

      # add the hashed digital signature to the end of the query parameters
      self.token = encoded_parms += "&signature=#{hmac.hexdigest}"
    end
        
    def upload_url_for_location(location)
      url_string = "#{API_URL}/GetUploadURL/#{self.options[:site]}.#{location.handle}?#{self.token}"
      url = URI.parse(url_string)
      http = Net::HTTP.new(url.host, url.port)
      http.use_ssl = true
      http.verify_mode = OpenSSL::SSL::VERIFY_NONE
      response = http.start {|http| 
        http.request(Net::HTTP::Get.new(url.path + '?' + url.query))
      }
      response.body
    end
    
    def webservices_url
      "#{API_URL}/ProcessWebServicesDocument/#{options[:site]}?#{self.generate_authorization_token}"
    end
    
    def process(xml)
      url = URI.parse(webservices_url)
        http = Net::HTTP.new(url.host, url.port)
        http.use_ssl = true
        http.verify_mode = OpenSSL::SSL::VERIFY_NONE
        http.start {
          request = Net::HTTP::Post.new(url.to_s)
          request.body = xml
          response = http.request(request)
          response.body
        }
    end
    
    def upload_to(upload_to)
      upload_location = webservices_url
      url = URI.parse(upload_location)
        http = Net::HTTP.new(url.host, url.port)
        http.use_ssl = true
        http.verify_mode = OpenSSL::SSL::VERIFY_NONE
        http.start {
          request = Net::HTTP::Post.new(url.to_s)
          request.body ="<?xml version=\"1.0\" encoding=\"UTF-8\"?>\n<ITunesUDocument>\n  <Version>1.1.1</Version>\n  <ShowTree>\n    <Handle>1278185</Handle>\n    <KeyGroup>minimal</KeyGroup>\n  </ShowTree>\n</ITunesUDocument>\n"
          response = http.request(request)
          response.body
        }
    end
  end
end