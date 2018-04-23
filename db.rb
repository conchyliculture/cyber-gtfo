module CyberDB
    require "sequel"
    require "set"
    if not Object.const_defined?(:DB)
        DB = Sequel.sqlite 'gtfo.sqlite'
    end
    unless DB.table_exists?(:cyber)
        DB.create_table :cyber do
            primary_key :id
            String :img_url
            String :tags
        end
    end

    class Cyber < Sequel::Model(:cyber) ; end

    def CyberDB.get_random(number)
        Cyber.order(Sequel.lit('RANDOM()')).limit(number)
    end

    def CyberDB.exist?(url)
        return Cyber.where(img_url:url).count >= 1
    end

    def CyberDB.add(url, tags)
        Cyber.insert(img_url: url, tags: tags)
    end

    def CyberDB.search_tag(tag)
        a = Cyber.where(Sequel.like(:tags, "%#{tag}%"))
    end

    def CyberDB.get_all_tags()
        res = Set.new
        Cyber.select(:tags).each do |ts|
            ts[:tags].split(',').each do |t|
                res << t
            end
        end
        return res.to_a
    end
end
