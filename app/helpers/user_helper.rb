module UserHelper
    
    def image_for(user)
        if user.image
            image_tag "/user_images/#{user.image}", class: "profile_img"
            else
            image_tag "NO_DATA.png", class: "profile_img"
        end
    end
    
    def api(isbn)
        
        @isbn = isbn
        uri = 'https://app.rakuten.co.jp/services/api/BooksBook/Search/20130522?applicationId=1097463767217933326'
        
        #htmlからパラメータを受け取り代入する
        parameter = {
            title: '',
            author: '',
            size: '0', #書籍の種類についてのパラメータ
            isbn: @isbn, #isbnコードのパラメータ
        }
        
        def make_url uri, parameter
            url = uri
            parameter.each do |key, value|
                tmp = CGI.escape(value)
                url += "&#{key}=#{tmp}" unless value == '' #それぞれのvalueが空でない時request_urlの後ろに追加する。
            end
            url
        end
        
        def get_json request_url
            res = open(request_url)
            code, message = res.status # res.status => ["200", "OK"]
            
            if code == '200'
                json = ActiveSupport::JSON.decode res.read
                return json
                else
                puts "OMG!! #{code} #{message}"  #error
                return 'error'
            end
        end
        
        request_url = make_url uri, parameter
        json = get_json request_url
        if json == 'error'
            puts "error"
            else
            items = json["Items"]
            # resultを使ってなんやかんや処理をする
            @data = []
            for i in 0..0 do
                
                
                input = {
                    title: items.dig(i,"Item", "title"),
                    subTitle: items.dig(i, "Item", "subTitle"),
                    author: items.dig(i, "Item", "author"),
                    size: items.dig(i, "Item", "size"),
                    isbn: items.dig(i, "Item", "isbn"),
                    itemUrl: items.dig(i, "Item", "itemUrl"),
                    imageUrl: items.dig(i, "Item", "largeImageUrl"),
                }
                @data[i] = input
            end
        end
        @data[0]
    end
end
