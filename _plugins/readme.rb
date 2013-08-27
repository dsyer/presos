puts "Copying README"
FileUtils.copy 'README.md', '_includes/README.md'

module Jekyll

  class FencedHighlightGenerator < Generator
    safe true
    def generate(site)
      source = site.source
      site.source = 'deck.js'
      site.read_directories
      site.source = source
      site.pages.each do |page|
        page.content = page.content.gsub(/```(\w+)(.*)```/m, "{% highlight \\1 %}\n\\2\n{% endhighlight %}")
      end
    end
  end

end
