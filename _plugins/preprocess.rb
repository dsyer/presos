require 'asciidoctor'
require 'asciidoctor-diagram'
require 'tilt'
require 'haml'

puts "Copying README"
FileUtils.copy 'README.md', '_includes/README.md'

module Jekyll

  class FencedHighlightGenerator < Generator
    safe true
    def generate(site)
      options = {:mkdirs => true, :safe => :unsafe, :attributes => 'linkcss', :to_dir => '_site/decks', :template_dir => 'asciidoctor-backends/haml/deckjs'}
      Dir.glob('decks/*.adoc') do |fname|
        output = (File.basename(fname, '.adoc') + '.html')
        site.keep_files << output
        puts 'Rendering ' + fname + ' to ' + output
        Asciidoctor.render_file(fname, options)
      end
      FileUtils.cp_r 'deck.js/', '_site/'
      FileUtils.cp_r 'themes/', '_site/deck.js/'
    end
  end

end
