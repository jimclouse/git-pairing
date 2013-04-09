module GitPairs
  class Commands
    def self.add(conf, path_to_conf, partners)
      partners.uniq.each do |partner|
        unless GitPairs::Helper.exists?(conf, partner)
          GitPairs::Helper.add(conf, path_to_conf, partner)
        else
          puts ""
          puts "Pairing Partner '#{partner}' already exists"
          puts "To replace '#{partner}', first execute:  git pair rm #{partner}"
        end
      end
    end

    def self.rm(conf, path_to_conf, partners)
      if partners.empty?
        puts ""
        Trollop::die "Please supply at least 1 set of initials"
      end
      partners.uniq.each do |partner|
        unless GitPairs::Helper.exists?(conf, partner)
          puts "There is no pairing partner configured for: #{partner}"
        else
          GitPairs::Helper.delete(conf, path_to_conf, partner)
        end
      end

    end

    def self.set(conf, path_to_conf, partners)
      if partners.empty? || partners.size < 2
        puts ""
        Trollop::die "Please supply at least 2 sets of initials"
      end

      authors = []
      partners.uniq.each do |partner|
        unless GitPairs::Helper.exists?(conf, partner)
          GitPairs::Helper.add(conf, path_to_conf, partner)
        end
        #concatenate each partner's info into delimited strings
        author =  GitPairs::Helper.fetch(conf, partner)
        name = author["username"]
        email = author["email"]
        authors << ["#{name}","#{partner}", "#{email}"]
      end

      GitPairs::Helper.set(conf, authors)
    end
  end
end
