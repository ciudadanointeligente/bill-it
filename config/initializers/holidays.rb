all_holidays = YAML.load_file("#{Rails.root}/config/holidays.yml")
all_holidays.values.each do |year|
  year.values.each do |holiday|
    BusinessTime::Config.holidays << holiday.to_date
  end
end