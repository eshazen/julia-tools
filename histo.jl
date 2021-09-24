#
# histogram demo
#

using Plots
using Distributions
using Random
using DataStructures

const bx_rate = 40.08e6
const bufsize = 512

const chip_size_mean = 200
const chip_size_sigma = 50
const chip_size_min = 100
const chip_size_max = 256

# d = Normal(chip_size_mean, chip_size_sigma)

dist = Truncated( Normal( chip_size_mean, chip_size_sigma), 
                  chip_size_min, chip_size_max)

S = rand( dist, Int(1e6))

h = histogram( S)
