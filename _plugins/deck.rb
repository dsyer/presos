module Jekyll
  module Converters
    class Markdown < Converter
      alias :super_convert :convert
      def convert(content)
        content = super_convert(content.gsub(/^##\s*$/, "<h2></h2>"))
        items = content.split(/(<h[12])/)
        count = 0
        items.collect! do |item|
          if item =~ /<h[12]/ then
            count = count + 1
            (count > 1 ? "</div>" : "" ) + "<div class=\"slide\" id=\"slide#{count}\">" + item
          else
            item
          end
        end
        content = items.join('') + "</div>"
      end    
    end
  end
end
