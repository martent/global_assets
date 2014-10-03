class AssetUtils

  # Convert erb template to JS variable
  def self.jsify(erb_file, js_var)
    # Convert erb template to html
    erb = File.read(File.expand_path(erb_file))
    html = ERB.new(erb).result(binding)

    # Make it a one line string and attach it to a js var
    html = html.gsub(/^\s+/, '').gsub(/\n/, ' ').gsub(/\s+/, ' ').gsub(/'/, '"').strip
    "var #{js_var} = '#{html}';"
  end
end
