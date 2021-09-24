#
# simple FIFO simulation
# generate HL-LHC triggers
# put in simulated FIFO
# read at fixed rate
#
using DataStructures

const bx_rate = 40.08e6
const bufsize = 32

function fsim( l1_rate, read_rate, run_time)

    thr = l1_rate/bx_rate
    ticks = bx_rate*run_time
    read_tick = floor( bx_rate/read_rate)
    println("Read every ", read_tick, " ticks")

    lastbuff = 0
    nbuff = 0
    oflow = 0

    insum::Int64 = 0
    outsum::Int64 = 0

    H = zeros(Int64,bufsize)

    F = CircularBuffer{Int64}(bufsize)

    for i::Int64 = 1:ticks
        #-- trigger? --
        if rand() < thr
            if isfull(F)
                oflow += 1
            else
                push!( F, i)
                insum += i
            end
        end

        #-- readout? --
        if mod(i,read_tick) == 0 && nbuff > 0
            if !isempty(F)
                d = popfirst!(F)
                outsum += d
            end
        end

        nbuff = length(F)
        if nbuff != lastbuff && nbuff > 0
            H[nbuff] += 1
            lastbuff = nbuff
        end

    end

    extra::Int64 = 0

    for i::Int64 = 1:bufsize
        if !isempty(F)
            d = popfirst!(F)
            outsum += d
            extra += 1
        end
    end

    for i=1:bufsize
        if H[i] > 0
            println( i, " ", H[i])
        end
    end
    println("Overflows: ", oflow)    

    println("Sums in: ", insum, " out: ", outsum, insum == outsum ? " match" : " don't match")
    println("Extras: ", extra)
   
end
