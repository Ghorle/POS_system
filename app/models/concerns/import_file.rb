class ImportFile
  require 'csv'
  require 'roo'

  def initialize(file)
    @file = file
  end

  def import
    spreadsheet = open_spreadsheet
    header = spreadsheet.row(1)
    (2..spreadsheet.last_row).each do |i|
      row = Hash[[header, spreadsheet.row(i)].transpose]
      raw_material = RawMaterial.find_or_initialize_by(name: row["name"])
      raw_material.assign_attributes(quantity: row["quantity"])
      raw_material.save!
    end
  end

  private

  def open_spreadsheet
    case File.extname(@file.original_filename)
    when ".csv" then Roo::CSV.new(@file.path)
    when ".xls" then Roo::Excel.new(@file.path)
    when ".xlsx" then Roo::Excelx.new(@file.path)
    else raise "Unknown file type: #{@file.original_filename}"
    end
  end
end