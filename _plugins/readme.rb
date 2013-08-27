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
    end
  end

end
