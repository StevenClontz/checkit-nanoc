require 'nokogiri'

class ExercisesDataSource < Nanoc::DataSource
    identifier :exercises
    BANK_ROOT = "../checkit/banks"
    BANK_SLUGS = ["tbil-la", "clontz-diff-eq"]

    def items
        items = []
        BANK_SLUGS.each do |bank_slug|
            bank_path = "#{BANK_ROOT}/#{bank_slug}"
            bank_xml = Nokogiri::XML(
                File.read("#{bank_path}/__bank__.xml")
            )
            bank_title = bank_xml.at_xpath("/bank/title").content
            bank_content = "<h3>#{bank_title}</h3><p>Choose an objective below for example exercises.</p><ul>"
            objectives = bank_xml.xpath("/bank/objectives/objective")
            objectives.each do |objective|
                title = objective.at_xpath("title").content
                slug = objective.at_xpath("slug").content
                content = "<h2>#{slug} - #{title}</h2>\n"
                build_path = "#{bank_path}/__build__/#{slug}"
                50.times do |seed_int|
                    content << "<hr id='ex-#{seed_int+1}' class='exercise-hr'/>\n"
                    content << "<h4 class='exercise-heading'>Example #{seed_int+1} <small><a href='#ex-#{seed_int+1}'>🔗</a></small></h4>"
                    content << File.read("#{build_path}/#{seed_int.to_s.rjust(4, "0")}.html")
                end
                item = new_item(
                    content,
                    {title: "#{slug} - #{title} | #{bank_title}", short_title: "#{slug} - #{title}"},
                    Nanoc::Identifier.new("/banks/#{bank_slug}/#{slug}.html"),
                )
                bank_content << "<li><a href='/banks/#{bank_slug}/#{slug}/'>#{slug} - #{title}</a></li>"
                items << item
            end
            bank_content << "</ul>"
            items << new_item(
                bank_content,
                {title: bank_title, short_title: bank_title},
                Nanoc::Identifier.new("/banks/#{bank_slug}.html"),
            )
        end

        return items

    end
end
