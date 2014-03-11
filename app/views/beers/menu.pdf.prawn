font_path = ::Rails.root.join('vendor','assets','fonts','familiar_pro.ttf').to_s
pdf.font_families.update("familiar" => {
	:normal => font_path
})
pdf.font "familiar"
pdf.text "Tasting Notes", size: 30

pdf.move_down(20)

@beers.menu.each do |beer|
	pdf.fill_color "40701A"
	heading = "<u>" + beer.brewer.name + " - " + beer.name + "</u>"
	pdf.text heading, size: 20, inline_format: true
	pdf.move_down(10)
	pdf.fill_color "000000"
	pdf.text beer.style.name
	pdf.text beer.brewer.location
	pdf.text number_to_percentage(beer.abv, precision: 1)
	pdf.move_down(10)
	pdf.text beer.note
	pdf.move_down(20)
end

