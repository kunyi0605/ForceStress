#!/bin/bash
# change all files to 777
find ./ -type f -exec chmod 777 {} \;

# echo "Set device to test: ex.sdb"
# read target

target=$1
loop=$2

filepath="/usr/lib/libaio.so.1"

if [ -e $filepath ];then
     echo $filepath exists
else
     cp libaio.so.1 /usr/lib/
fi

# Move *.csv files to Tmp folder before test start.
ls *.log > /dev/null
if [ "$?" -eq "0" ] 
then  
    cur_time=`date +%Y-%m-%d-%H-%M-%S`
    result_dir="./result_${cur_time}-Tmp"
    rm -rf $result_dir
    mkdir -p $result_dir         

    find . -maxdepth 1 -type f -iname '*.log' -exec mv -t ./$result_dir/ {} \+
    find . -maxdepth 1 -type f -iname '*.csv' -exec mv -t ./$result_dir/ {} \+
else
    echo "There is no *.log file exist"
fi

# Create result folder.
cur_time=`date +%Y-%m-%d-%H-%M-%S`

#result_dir="./Seq_to_Rnd_result_${cur_time}"
result_dir="./loop${loop}_Seq_to_Rnd_${cur_time}"
rm -rf $result_dir
mkdir -p $result_dir

# start test
echo "Name=100%Seq_Write_1M, BlockSize=1048576Bytes, Sequential=100%, Read=0%, Write=100%, QD=32, NumJobs=1, Target=$target, 1stSeqW2DiscSize"
echo "Name,Read_IOPS,Write_IOPS,Total_IOPS,Read_BW(KB),Write_BW(KB),Total_BW(KB),Read_lantency(us),Write_lantency(us),Total_lantency(us)" >> 100%Seq_Write_1M.csv
#./fio --filename=/$target --rw=write --bs=1048576 --iodepth=32 --numjobs=1 --size=100% --name=100%Seq_Write_1M --norandommap --direct=1 --refill_buffers --ioengine=libaio --minimal>>100%Seq_Write_1M.log

#./fio --filename=/$target --rw=write --bs=1048576 --iodepth=32 --numjobs=1 --size=100% --name=100%Seq_Write_1M --norandommap --direct=1 --refill_buffers --ioengine=libaio --minimal>>100%Seq_Write_1M.log
./fio --filename=/$target --rw=write --bs=1048576 --iodepth=32 --time_based --size=100% --name=100%Seq_Write_1M --norandommap --direct=1 --refill_buffers --ioengine=libaio --minimal>>100%Seq_Write_1M.log
tail -n1 100%Seq_Write_1M.log| awk -F ";" '{printf "%s,%d,%d,%d,%d,%d,%d,%d,%d,%d\n","'100%Seq_Write_1M'",$8,$49,$8+$49,$7,$48,$7+$48,$40,$81,$40+$81}' >> 100%Seq_Write_1M.csv

echo "Name=100%Seq_Write_1M, BlockSize=1048576Bytes, Sequential=100%, Read=0%, Write=100%, QD=32, NumJobs=1, Target=$target, 2stSeqW2DiscSize"
echo "Name,Read_IOPS,Write_IOPS,Total_IOPS,Read_BW(KB),Write_BW(KB),Total_BW(KB),Read_lantency(us),Write_lantency(us),Total_lantency(us)" >> 100%Seq_Write_1M.csv
#./fio --filename=/$target --rw=write --bs=1048576 --iodepth=32 --numjobs=1 --size=50% --name=100%Seq_Write_1M --norandommap --direct=1 --refill_buffers --ioengine=libaio --minimal>>100%Seq_Write_1M.log

#./fio --filename=/$target --rw=write --bs=1048576 --iodepth=32 --numjobs=1 --size=50% --name=100%Seq_Write_1M --norandommap --direct=1 --refill_buffers --ioengine=libaio --minimal>>100%Seq_Write_1M.log
./fio --filename=/$target --rw=write --bs=1048576 --iodepth=32 --time_based --size=50% --name=100%Seq_Write_1M --norandommap --direct=1 --refill_buffers --ioengine=libaio --minimal>>100%Seq_Write_1M.log
tail -n1 100%Seq_Write_1M.log| awk -F ";" '{printf "%s,%d,%d,%d,%d,%d,%d,%d,%d,%d\n","'100%Seq_Write_1M'",$8,$49,$8+$49,$7,$48,$7+$48,$40,$81,$40+$81}' >> 100%Seq_Write_1M.csv

echo "Name=100%Random_Write_1M, BlockSize=1048576Bytes, Sequential=0%, Read=0%, Write=100%, QD=32, NumJobs=1, Target=$target, 3stRndW2DiscSize"
echo "Name,Read_IOPS,Write_IOPS,Total_IOPS,Read_BW(KB),Write_BW(KB),Total_BW(KB),Read_lantency(us),Write_lantency(us),Total_lantency(us)" >> 100%Random_Write_1M.csv
#./fio --filename=/$target --rw=randwrite --bs=1048576 --iodepth=32 --numjobs=1 --size=70% --name=100%Random_Write_1M --norandommap --direct=1 --refill_buffers --ioengine=libaio --minimal>>100%Random_Write_1M.log

#./fio --filename=/$target --rw=randwrite --bs=1048576 --iodepth=32 --numjobs=1 --size=70% --name=100%Random_Write_1M --norandommap --direct=1 --refill_buffers --ioengine=libaio --minimal>>100%Random_Write_1M.log
./fio --filename=/$target --rw=randwrite --bs=1048576 --iodepth=32 --time_based --size=70% --name=100%Random_Write_1M --norandommap --direct=1 --refill_buffers --ioengine=libaio --minimal>>100%Random_Write_1M.log
tail -n1 100%Random_Write_1M.log| awk -F ";" '{printf "%s,%d,%d,%d,%d,%d,%d,%d,%d,%d\n","'100%Random_Write_1M'",$8,$49,$8+$49,$7,$48,$7+$48,$40,$81,$40+$81}' >> 100%Random_Write_1M.csv
echo 6666666666666666666666666666
find . -maxdepth 1 -type f -iname '*.log' -exec mv -t ./$result_dir/ {} \+
find . -maxdepth 1 -type f -iname '*.csv' -exec mv -t ./$result_dir/ {} \+
echo 77777777777777
