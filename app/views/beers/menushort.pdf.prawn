font_path = ::Rails.root.join('vendor','assets','fonts','familiar_pro.ttf').to_s
pdf.font_families.update("familiar" => {
	:normal => font_path
})
pdf.font "familiar"
pdf.text "Beers on Tap", size: 20

pdf.move_down(20)

@beers.menu.each do |beer|
	heading = "<u>" + beer.brewer.name + " - " + beer.name + "</u>"
	pdf.text heading, size: 14, inline_format: true
	line = beer.style.name + " - " + number_to_percentage(beer.abv, precision: 1)
	pdf.text line
	pdf.text beer.brewer.location
	pdf.move_down(5)
end

