# Display loop number on screen
# Add Seq_to_Rnd script  
# Add Read/Write mixed funtion

declare -i rnd

loopTime=$1
target=$2

rw_arr=(read write randrw)
rwmix_arr=(0 10 20 30 40 50 60 70 80 90 100) 
qd_arr=(1 4 8 16 32)
bs_arr=(0.5 1 4 8 16 32 64 128)
para_line="--direct=1 --refill_buffers --ioengine=libaio --numjobs=1 --norandommap"

# for test
# para_line="--direct=1 --refill_buffers --ioengine=libaio --numjobs=1 --norandommap --runtime=1 --time_based"

stress()
{
    output="random_"`date +%Y%m%d_%H%M%S`.txt

    echo ./fio --filename=/dev/$target --rw=randwrite --bs=4k --iodepth=32 --name=4k_randwrite_QD32 ${para_line} | tee -a $output
    ./fio --filename=/dev/$target --rw=randwrite --bs=4k --iodepth=32 --name=4k_randwrite_QD32 ${para_line} | tee -a $output

    for (( i=1; i<=$loopTime; i=i+1 ))
    do
        rnd=$RANDOM*3/32768
        rw=${rw_arr[$rnd]}

        if [ "$rnd" -eq "2" ]; then
            rnd=$RANDOM*11/32768
            rwmix=${rwmix_arr[$rnd]}
            rw_behavior="--rw="$rw" --rwmixread="$rwmix
        else
            rw_behavior="--rw="$rw
        fi

        rnd=$RANDOM*6/32768
        qd=${qd_arr[$rnd]}

        rnd=$RANDOM*12/32768
        bs=${bs_arr[$rnd]}

        echo | tee -a $output
        echo "*** Loop "$i	"***"| tee -a $output
        echo | tee -a $output
        echo ./fio --filename=/dev/$target $rw_behavior --bs=$bs\k --iodepth=$qd --name=$bs\k_$rw\_QD$qd ${para_line} | tee -a $output
        #./fio --filename=/dev/$target $rw_behavior --bs=$bs\k --iodepth=$qd --name=$bs\k_$rw\_QD$qd ${para_line} | tee -a $output
        ./fio --filename=/dev/$target $rw_behavior --bs=$bs\k --iodepth=$qd --name=$bs\k_$rw\_QD$qd ${para_line} | tee -a $output
        
        bash Seq_to_Rnd.sh $target $i

    done

    find ./ -type d -exec chmod 777 {} \;
}

main()
{

    echo "Set device to test: ${target}"
    ##read target
    echo "Set loop times: ${loopTime}"
    ##read loopTime

    # change all files to 777
    find ./ -type f -exec chmod 777 {} \;

    filepath="/usr/lib/libaio.so.1"

    if [ -e $filepath ];then

        echo $filepath exists >/dev/null
    else

        cp libaio.so.1 /usr/lib/
    fi
}

main
stress
echo stress end
echo -------------------------------------------------------------------------
