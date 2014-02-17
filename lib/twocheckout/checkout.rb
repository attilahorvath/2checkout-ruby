module Twocheckout
  class Checkout < HashObject

    def self.form(params={}, html_options={})
      @form = "<form id=\"#{html_options[:form_id] || '2checkout'}\"#{' class="' + html_options[:form_class] + '"' if html_options[:form_class]} action=\"https://www.2checkout.com/checkout/purchase\" method=\"post\">\n";
      params.each do |k,v|
        @form = @form + "<input type=\"hidden\" name=\"" + k.to_s + "\" value=\"" + v.to_s + "\" />\n"
      end
      @form + "<input type=\"submit\" value=\"#{html_options[:button_text] || 'Proceed to Checkout'}\"#{' class="' + html_options[:button_class] + '"' if html_options[:button_class]}#{' id="' + html_options[:button_id] + '"' if html_options[:button_id]} />\n</form>"
    end

    def self.submit(params={})
      @form = "<form id=\"2checkout\" action=\"https://www.2checkout.com/checkout/purchase\" method=\"post\">\n";
      params.each do |k,v|
        @form = @form + "<input type=\"hidden\" name=\"" + k + "\" value=\"" + v.to_s + "\" />\n"
      end
      @form = @form + "</form>\n"
      @form = @form + "<script type=\"text/javascript\">document.getElementById('2checkout').submit();</script>"
    end

    def self.direct(params={}, button_text='Proceed to Checkout')
      @form = "<form id=\"2checkout\" action=\"https://www.2checkout.com/checkout/purchase\" method=\"post\">\n";
      params.each do |k,v|
        @form = @form + "<input type=\"hidden\" name=\"" + k + "\" value=\"" + v.to_s + "\" />\n"
      end
      @form = @form + "<input type=\"submit\" value=\"" + button_text + "\" />\n</form>\n"
      @form = @form + "<script src=\"https://www.2checkout.com/static/checkout/javascript/direct.min.js\"></script>"
    end

    def self.link(params={}, url="https://www.2checkout.com/checkout/purchase")
      @querystring = params.map{|k,v| "#{CGI.escape(k.to_s)}=#{CGI.escape(v.to_s)}"}.join("&")
      @purchase_url = "#{url}?#{@querystring}"
    end

    def self.authorize(params={})
      response = Twocheckout::API.request(:post, 'authService', params)
      response['response']
    end
  end
end