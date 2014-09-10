require 'json'
require 'redis'

$redis = Redis.new(url: ENV["REDISTOGO_URL"])

# Clear out any old data
$redis.flushdb

# Create a counter to track indexes
$redis.set("105862615635090070587_posts",[
    { "title"=>"Man smoking",
      "category"=>"portraiture",
      "url"=>"http://www.landscapephotography.info/wpcontent/uploads/2014/05/street_photography_portrait.jpg",
      "description"=>"black & white"
    },
    {
      "title"=>"woman smoking",
      "category"=>"portraiture",
      "url"=>"http://inspirationhut.net/wp-content/uploads/2013/07/110.jpg",
      "description"=>"black & white"
    },
    {
      "title"=>"Anne Hathaway",
      "category"=>"portraiture",
      "url"=>"http://briansmith.com/wp-content/uploads/2013/01/celebrity-portrait-photography.jpg",
      "description"=>"black & white, celebrity"
    },
    {
      "title"=>"Green landscape",
      "category"=>"landscape",
      "url"=>"http://www.smashandpeas.com/wp-content/uploads/2009/04/36.jpg",
      "description"=>"color"
    },
    {
      "title"=>"Sunflowers", "category"=>"landscape",
      "url"=>"http://digital-photography-school.com/wp-content/uploads/flickr/205125227_3f160763a0_o.jpg",
      "description"=>"color"
    },
    {
      "title"=>"Man in Jeans", "category"=>"portraiture",
      "url"=>"http://syedkazminyc.com/admin/uploadedData/project_general_media/tablets/editorial-fashion-photography-Syed-Kazmi-NYC_50b2fc731951c.jpg",
      "description"=>"color, fashion"
    },
    {
      "title"=>"Hilary Swank", "category"=>"portraiture",
      "url"=>"http://slappedbyfashion.com/wp-content/uploads/2014/02/fashion-photography7.jpg",
      "description"=>"black & white, celebrity"
    },
    {
      "title"=>"Girl with Flower",
      "category"=>"portraiture",
      "url"=>"http://2.bp.blogspot.com/_YSwFwbNbiu4/TTSr5U_jnlI/AAAAAAAAAUk/xeZI_WRpqHQ/s640/Roversi_Fashion.jpg",
      "description"=>"color, fashion, Paolo Roversi"
    },
    {
      "title"=>"Man",
      "category"=>"portraiture",
      "url"=>"http://media-cache-ec0.pinimg.com/236x/3f/d0/a4/3fd0a409d92b25eec9e05d39af163df3.jpg",
      "description"=>"fashion"
    },
    {
      "title"=>"Woman with Wig",
      "category"=>"portraiture",
      "url"=>"http://media-cache-ak0.pinimg.com/236x/a6/95/9a/a6959a4a9a5a503da650de122e11bea8.jpg",
      "description"=>"color, fashion, Paolo Roversi"
    },
    {
      "title"=>"Diptych",
      "category"=>"portraiture",
      "url"=>"http://hintmagazine.vaesite.net/__data/b7bd12679906780cfe35eb7a13608313.jpg",
      "description"=>"fashion, black & white"
    },
    {
      "title"=>"Frozen food",
      "category"=>"still_life",
      "url"=>"http://www.theasc.com/blog/wp-content/uploads/2011/03/11.tumblr_kw2lppUHlv1qa5h7no1_500.jpg",
      "description"=>"color, Irving Penn"
    },
    {
      "title"=>"Bee Stung",
      "category"=>"still_life",
      "url"=>"https://encrypted-tbn1.gstatic.com/images?q=tbn:ANd9GcT7JM8TZ70Orw5vyVUc98D8o1k0fivAV6lT_FqlhqyA0eH7_DaeIQ",
      "description"=>"fashion, Irving Penn, color"
    }
    ].to_json)


$redis.set("users", [].to_json)






