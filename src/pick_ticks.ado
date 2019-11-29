* Determine optimal tick placements in a plot
* Code by Kevin Kiernan
* See also: http://vis.stanford.edu/files/2010-TickLabels-InfoVis.pdf

capture program drop pick_ticks
program define pick_ticks, rclass
	syntax varname(numeric) [if], [Verbose] [Number(integer 5)]

	su `varlist' `if', mean
	loc max = r(max)
	loc min = r(min)
	if (`min' > 0) loc min = 0
	if (`max' < 0) loc max = 0
	loc range = `max' - `min'
	loc neg_share = -1 * (`min' / `range')
	loc pos_share = `max' / `range'

	loc neg_bins = ceil(`neg_share' * `number')
	loc pos_bins = ceil(`pos_share' * `number')

	loc k = `pos_bins'
	if (`neg_bins' > `pos_bins') loc k = `neg_bins'
	loc abs_max = `max'
	if (`neg_bins' > `pos_bins') loc abs_max = `min'
	if (`abs_max' < 0) loc abs_max = -1*(`abs_max')
	loc base = `abs_max' / `k'

	loc right = 10 ^ int(log10(`base'))

	loc width = ceil(`base' / `right') * `right'

	/* loc range_full = `width' * `k'
	if (`width' * (`k' - 1) > `range') loc range_full = `width' * (`k' - 1)
	if (`width' * (`k' - 2) > `range') loc range_full = `width' * (`k' - 2) */

	if (`width' * -1*(`neg_bins' - 1) < `min') loc neg_bins = `neg_bins' - 1
	if (`width' * -1*(`neg_bins' - 2) < `min') loc neg_bins = `neg_bins' - 2

	if (`width' * (`pos_bins' - 1) > `max') loc pos_bins = `pos_bins' - 1
	if (`width' * (`pos_bins' - 2) > `max') loc pos_bins = `pos_bins' - 2

	loc low_lim = -1*`neg_bins'*`width'
	loc upp_lim = `pos_bins'*`width'

	*if ("`verbose'" != "") di as error "width=<`width'> right=<`right'> max=<`max'> base=<`base'>"
	if ("`verbose'" != "") di as error `"`low_lim'(`width')`upp_lim'"'

	return local ticks `"`low_lim'(`width')`upp_lim'"'
	return local ll `low_lim'
	return local ul `upp_lim'
	return local width `width'
end
