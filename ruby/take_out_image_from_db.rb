require 'mysql2'
require 'pry'

def db
  return @db_client if defined?(@db_client)

  @db_client = Mysql2::Client.new(
    host: ENV.fetch('ISUBATA_DB_HOST') { '127.0.0.1' },
    port: ENV.fetch('ISUBATA_DB_PORT') { '3306' },
    username: ENV.fetch('ISUBATA_DB_USER') { 'root' },
    password: ENV.fetch('ISUBATA_DB_PASSWORD') { 'root' },
    database: 'isubata',
    encoding: 'utf8mb4'
  )
  @db_client.query('SET SESSION sql_mode=\'TRADITIONAL,NO_AUTO_VALUE_ON_ZERO,ONLY_FULL_GROUP_BY\'')
  @db_client
end

def take_out_image_from_db
  statement = db.prepare('SELECT * FROM image')
  datas = statement.execute.to_a

  datas.each.with_index do |data,i|
    file_name = data["name"]
    content = data["data"]

    File.open("../public/image/#{file_name}", "w+") do |f|
      f.puts(content)
    end
  end
end

take_out_image_from_db
