require 'net/http'

def get_feed(address,username,password)
  begin
    feed = Titanium.JSON.parse(fetch('activities',address,username,password).gsub('{"type":', '{"target_type":'))
    
    body = "<h1>Activities</h1>"
    Titanium.UI.setBadge(feed.activities.length.to_s)
      
    feed.activities.each do |activity|
      body << "<div class='comments'>
                <span class='from'>#{activity.user.username}</span>"
                if activity.target.target_type == 'Comment'
                  body << "<span class='comment'>#{activity.target.comment.body_html}</span>"
                end
      body << "</div></hr>"
    end
  rescue
    body = '<h3>just guessing, but maybe your username, password or address is not good?</h3>'
    
  end
  body
end

def fetch(page,address,username,password)
  Net::HTTP.start(address) do |http|
    req = Net::HTTP::Get.new("/#{page}.json")
    req.basic_auth username, password
    response = http.request(req)
    return response.body
  end
end
