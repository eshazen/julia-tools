#
# simple FIFO simulation
# generate HL-LHC triggers
# put in simulated FIFO
# read at fixed rate
#

const bx_rate = 40.08e6
const bufsize = 32


function fsimn( l1_rate, read_rate, run_time)

    thr = l1_rate/bx_rate
    ticks = bx_rate*run_time
    read_tick = floor( bx_rate/read_rate)
    println("Read every ", read_tick, " ticks")

    lastbuff = 0
    nbuff = 0
    oflow = 0

    H = zeros(Int64,bufsize)

    for i = 1:ticks
        if rand() < thr
            nbuff = nbuff + 1
        end
        if mod(i,read_tick) == 0 && nbuff > 0
            nbuff = nbuff - 1
        end
        if lastbuff != nbuff
            if nbuff > 0
                if nbuff > bufsize
                    oflow += 1
                    nbuff = bufsize
                else
                    H[nbuff] += 1
                end
            end
        end
        lastbuff = nbuff
    end

    for i=1:bufsize
        if H[i] > 0
            println( i, " ", H[i])
        end
    end
    println("Overflows: ", oflow)    

        
   
end
