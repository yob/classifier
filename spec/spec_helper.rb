RSpec.configure do |config|
  config.expect_with :rspec do |c|
    c.syntax = [:expect]
  end

  config.mock_with :rspec do |mocks|
    mocks.syntax = [:expect]
  end

  config.before :each, db: true do
    schema_path = File.expand_path("../../pg.sql", __FILE__)
    if !File.file?(schema_path)
      raise "schema not found at '#{schema_path}'"
    elsif ENV["DATABASE_URL"]
      db = Sequel.connect(ENV["DATABASE_URL"])
      db.execute("drop table if exists nb")
      db.execute(File.read(schema_path))
    else
      $stderr.puts "DATABASE_URL env var not found, unable to prepare database"
    end
  end

end
