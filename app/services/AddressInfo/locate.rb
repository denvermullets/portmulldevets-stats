# service that just grabs the specified Ballot with an optional Voter info attached

module AddressInfo
  class Locate < Service
    def initialize(ip_address:)
      @ip = Rails.env.development? ? ENV.fetch('LOCAL_IP') : ip_address
      @user = User.find_or_create_by(address: @ip)
      @token = ENV.fetch('IPINFO_TOKEN')
    end

    def call
      # if it's been 15 days, update the user record
      # return @user unless @user.updated_at > 15.days.ago

      response = HTTP.get("https://ipinfo.io/#{@ip}?token=#{@token}")
      ip_info = JSON.parse(response.body.to_s)

      @user.update(
        timezone: ip_info['timezone'],
        postal: ip_info['postal'],
        org: ip_info['org'],
        loc: ip_info['loc'],
        country: ip_info['country'],
        region: ip_info['region'],
        city: ip_info['city'],
        hostname: ip_info['hostname']
      )

      @user
    end
  end
end
