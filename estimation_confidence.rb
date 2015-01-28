# estimation confidence
# http://www.joelonsoftware.com/items/2007/10/26.html
#
# historical velocity
perfect_estimator = [ 1.0, 1.0, 1.0, 1.0, 1.0 ]
bad_estimator =  [ 0.1, 0.5, 1.7, 0.2, 1.2, 0.9, 13.0 ]
common_estimator = [ 0.6, 0.5, 0.6, 0.6, 0.5, 0.6, 0.7, 0.6 ]
#
# project estimates
project_estimate = [ 12, 8, 10, 20, 40, 5, 2, 2, 2 ]
#
# monte carlo
#
# for 100 simulations, each result is 1% probability
# for each future, divide each estimate by a randomly selected velocity from dev's historical velocity yeilding E/V
num_simulations = 100
# round the decimal by
r = 0
#
# note: have to convert hourly data into calendar data
perfect_monte = []
bad_monte = []
common_monte = []
#
# note: contractor time is 1 day = 6.8 hours
contractor_time = 24-6.8
#
# simulation
(0...num_simulations).each do |i|
	simulation_perfect = []
	simulation_bad = []
	simulation_common = []
	# generate E/V per estimator
	project_estimate.each do |estimate|
		simulation_perfect.push(estimate/perfect_estimator[Random.rand(0...perfect_estimator.length)])
		simulation_bad.push(estimate/bad_estimator[Random.rand(0...bad_estimator.length)])
		simulation_common.push(estimate/common_estimator[Random.rand(0...common_estimator.length)])
	end
	# convert to days, round decimal and acc
	perfect_monte.push((simulation_perfect.inject(:+)/contractor_time).round(r))
	bad_monte.push((simulation_bad.inject(:+)/contractor_time).round(r))
	common_monte.push((simulation_common.inject(:+)/contractor_time).round(r))
end
#
# collate the days, each vote is 1% confidence
confidence_perfect = Hash.new
confidence_bad = Hash.new
confidence_common = Hash.new
perfect_monte.each do |i|
	if confidence_perfect[i]
		confidence_perfect[i] = confidence_perfect[i] + 1
	else
		confidence_perfect[i] = 1
	end
end
bad_monte.each do |i|
	if confidence_bad[i]
		confidence_bad[i] = confidence_bad[i] + 1
	else
		confidence_bad[i] = 1
	end
end
common_monte.each do |i|
	if confidence_common[i]
		confidence_common[i] = confidence_common[i] + 1
	else
		confidence_common[i] = 1
	end
end
#
puts "Common confidence"
keys_sort = confidence_common.keys.sort
keys_sort.each do |i|
	puts "\t#{i} days, #{confidence_common[i]}%"
end
puts "Bad confidence"
keys_sort = confidence_bad.keys.sort
keys_sort.each do |i|
	puts "\t#{i} days, #{confidence_bad[i]}%"
end
puts "Perfect confidence"
keys_sort = confidence_perfect.keys.sort
keys_sort.each do |i|
	puts "\t#{i} days, #{confidence_perfect[i]}%"
end
