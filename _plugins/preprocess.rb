require 'asciidoctor'
require 'asciidoctor-diagram'
require 'tilt'
require 'haml'

puts "Copying README"
FileUtils.copy 'README.md', '_includes/README.md'
Asciidoctor::DEFAULT_EXTENSIONS['deckjs'] = '.html'

module Jekyll

  class FencedHighlightGenerator < Generator
    def generate(site)
      options = {:mkdirs => true, :safe => :unsafe, :attributes => 'linkcss', :to_dir => '_site/decks', :template_dirs => ['asciidoctor-backends/haml/deckjs'], :to_file => true}
      Dir.glob('decks/*.adoc') do |fname|
        puts 'Rendering ' + fname
        Asciidoctor.convert_file(fname, options)
      end
      FileUtils.cp_r 'deck.js/', '_site/'
      FileUtils.cp_r 'themes/', '_site/deck.js/'
    end
  end

end
