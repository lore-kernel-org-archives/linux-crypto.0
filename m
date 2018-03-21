From: Maninder Singh <maninder1.s@samsung.com>
Subject: [PATCH 0/1] cover-letter/lz4: Implement lz4 with dynamic offset
 length.
Date: Wed, 21 Mar 2018 10:10:41 +0530
Message-ID: <1521607242-3968-1-git-send-email-maninder1.s@samsung.com>
References: <CGME20180321044137epcas5p221e7ee4a0b7464eaa00dad8320f0251d@epcas5p2.samsung.com>
Content-Type: text/plain; charset="utf-8"
Cc: linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
        pankaj.m@samsung.com, a.sahrawat@samsung.com, v.narang@samsung.com,
        Maninder Singh <maninder1.s@samsung.com>
To: herbert@gondor.apana.org.au, davem@davemloft.net,
        minchan@kernel.org, ngupta@vflare.org,
        sergey.senozhatsky.work@gmail.com, keescook@chromium.org,
        anton@enomsg.org, ccross@android.com, tony.luck@intel.com,
        akpm@linux-foundation.org, colin.king@canonical.com
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

(Added cover letter to avoid much text in patch description)

LZ4 specification defines 2 byte offset length for 64 KB data.
But in case of ZRAM we compress data per page and in most of
architecture PAGE_SIZE is 4KB. So we can decide offset length based
on actual offset value. For this we can reserve 1 bit to decide offset
length (1 byte or 2 byte). 2 byte required only if ofsset is greater than 127,
else 1 byte is enough.

With this new implementation new offset value can be at MAX 32 KB.

Thus we can save more memory for compressed data.

results checked with new implementation:-

comression size for same input source
(LZ4_DYN < LZO < LZ4)

LZO
=======
orig_data_size: 78917632
compr_data_size: 15894668
mem_used_total: 17117184

LZ4
========
orig_data_size: 78917632
compr_data_size: 16310717
mem_used_total: 17592320

LZ4_DYN
=======
orig_data_size: 78917632
compr_data_size: 15520506
mem_used_total: 16748544

checked performance with below tool:-
https://github.com/sergey-senozhatsky/zram-perf-test
# ./fio-perf-o-meter.sh /tmp/test-fio-zram-lz4 /tmp/test-fio-zram-lz4_dyn
Processing /tmp/test-fio-zram-lz4
Processing /tmp/test-fio-zram-lz4_dyn
#jobs1
WRITE:          1101.7MB/s       1197.7MB/s
WRITE:          799829KB/s       900838KB/s
READ:           2670.2MB/s       2649.5MB/s
READ:           2027.8MB/s       2039.9MB/s
READ:           603703KB/s       597855KB/s
WRITE:          602943KB/s       597103KB/s
READ:           680438KB/s       707986KB/s
WRITE:          679582KB/s       707095KB/s
#jobs2
WRITE:          1993.2MB/s       2121.2MB/s
WRITE:          1654.1MB/s       1700.2MB/s
READ:           5038.2MB/s       4970.9MB/s
READ:           3930.1MB/s       3908.5MB/s
READ:           1113.2MB/s       1117.4MB/s
WRITE:          1111.8MB/s       1115.2MB/s
READ:           1255.8MB/s       1286.5MB/s
WRITE:          1254.2MB/s       1284.9MB/s
#jobs3
WRITE:          2875.6MB/s       3010.3MB/s
WRITE:          2394.4MB/s       2363.2MB/s
READ:           7384.7MB/s       7314.3MB/s
READ:           5389.5MB/s       5427.6MB/s
READ:           1570.8MB/s       1557.3MB/s
WRITE:          1568.8MB/s       1555.3MB/s
READ:           1848.5MB/s       1854.0MB/s
WRITE:          1846.2MB/s       1851.7MB/s
#jobs4
WRITE:          3720.3MB/s       3077.4MB/s
WRITE:          3027.4MB/s       3072.8MB/s
READ:           9694.7MB/s       9822.6MB/s
READ:           6606.5MB/s       6617.2MB/s
READ:           1941.6MB/s       1966.8MB/s
WRITE:          1939.1MB/s       1964.3MB/s
READ:           2405.3MB/s       2347.5MB/s
WRITE:          2402.3MB/s       2344.5MB/s
#jobs5
WRITE:          3335.6MB/s       3360.7MB/s
WRITE:          2670.2MB/s       2677.9MB/s
READ:           9455.3MB/s       8782.2MB/s
READ:           6534.8MB/s       6501.7MB/s
READ:           1848.9MB/s       1858.3MB/s
WRITE:          1846.6MB/s       1855.1MB/s
READ:           2232.4MB/s       2223.7MB/s
WRITE:          2229.6MB/s       2220.9MB/s
#jobs6
WRITE:          3896.5MB/s       3772.9MB/s
WRITE:          3171.1MB/s       3109.4MB/s
READ:           11060MB/s        11120MB/s
READ:           7375.8MB/s       7384.7MB/s
READ:           2132.5MB/s       2133.1MB/s
WRITE:          2129.8MB/s       2131.3MB/s
READ:           2608.4MB/s       2627.3MB/s
WRITE:          2605.7MB/s       2623.2MB/s
#jobs7
WRITE:          4129.4MB/s       4083.2MB/s
WRITE:          3364.5MB/s       3384.4MB/s
READ:           12088MB/s        11062MB/s
READ:           7868.3MB/s       7851.5MB/s
READ:           2277.8MB/s       2291.6MB/s
WRITE:          2274.9MB/s       2288.7MB/s
READ:           2798.5MB/s       2890.1MB/s
WRITE:          2794.1MB/s       2887.4MB/s
#jobs8
WRITE:          4623.3MB/s       4794.9MB/s
WRITE:          3749.3MB/s       3676.9MB/s
READ:           12337MB/s        14076MB/s
READ:           8320.1MB/s       8229.4MB/s
READ:           2496.9MB/s       2486.3MB/s
WRITE:          2493.8MB/s       2483.2MB/s
READ:           3340.4MB/s       3370.6MB/s
WRITE:          3336.2MB/s       3366.4MB/s
#jobs9
WRITE:          4427.6MB/s       4341.3MB/s
WRITE:          3542.6MB/s       3597.2MB/s
READ:           10094MB/s        9888.5MB/s
READ:           7863.5MB/s       8119.9MB/s
READ:           2357.1MB/s       2382.1MB/s
WRITE:          2354.1MB/s       2379.1MB/s
READ:           2828.8MB/s       2826.2MB/s
WRITE:          2825.3MB/s       2822.7MB/s
#jobs10
WRITE:          4463.9MB/s       4327.7MB/s
WRITE:          3637.7MB/s       3592.4MB/s
READ:           10020MB/s        11118MB/s
READ:           7837.8MB/s       8098.7MB/s
READ:           2459.6MB/s       2406.5MB/s
WRITE:          2456.5MB/s       2403.4MB/s
READ:           2804.2MB/s       2829.8MB/s
WRITE:          2800.7MB/s       2826.2MB/s
jobs1                              perfstat
stalled-cycles-frontend     20,23,52,25,317 (  54.32%)    19,29,10,49,608 (  54.50%)
instructions                44,62,30,88,401 (    1.20)    42,50,67,71,907 (    1.20)
branches                     7,12,44,77,233 ( 738.975)     6,64,52,15,491 ( 725.584)
branch-misses                   2,38,66,520 (   0.33%)        2,04,33,819 (   0.31%)
jobs2                              perfstat
stalled-cycles-frontend     42,82,90,69,149 (  56.63%)    41,58,70,01,387 (  56.01%)
instructions                85,33,18,31,411 (    1.13)    85,32,92,28,973 (    1.15)
branches                    13,35,34,99,713 ( 677.499)    13,34,97,00,453 ( 693.104)
branch-misses                   4,50,17,075 (   0.34%)        4,47,28,378 (   0.34%)
jobs3                              perfstat
stalled-cycles-frontend     66,01,57,23,062 (  57.10%)    65,86,74,97,814 (  57.30%)
instructions              1,28,18,27,80,041 (    1.11)  1,28,04,92,91,306 (    1.11)
branches                    20,06,14,16,000 ( 651.453)    20,02,85,32,864 ( 652.536)
branch-misses                   7,10,66,773 (   0.35%)        7,12,75,728 (   0.36%)
jobs4                              perfstat
stalled-cycles-frontend     91,98,71,83,315 (  58.09%)    93,70,91,50,920 (  58.66%)
instructions              1,70,82,79,66,403 (    1.08)  1,71,18,67,74,366 (    1.07)
branches                    26,73,53,03,398 ( 621.532)    26,80,89,38,054 ( 618.718)
branch-misses                   9,82,07,177 (   0.37%)        9,81,64,098 (   0.37%)
jobs5                              perfstat
stalled-cycles-frontend   1,47,29,71,29,605 (  63.59%)  1,47,91,01,92,835 (  63.86%)
instructions              2,18,90,41,63,988 (    0.95)  2,18,55,73,09,594 (    0.94)
branches                    34,64,46,32,880 ( 553.209)    34,55,08,02,781 ( 551.953)
branch-misses                  14,16,79,279 (   0.41%)       13,84,85,054 (   0.40%)
jobs6                              perfstat
stalled-cycles-frontend   2,02,92,92,98,242 (  66.70%)  2,05,33,49,39,627 (  67.01%)
instructions              2,65,13,90,22,217 (    0.87)  2,64,84,45,49,149 (    0.86)
branches                    42,11,54,07,400 ( 510.085)    42,03,58,57,789 ( 505.746)
branch-misses                  17,71,33,628 (   0.42%)       17,74,31,942 (   0.42%)
jobs7                              perfstat
stalled-cycles-frontend   2,79,22,74,37,283 (  70.23%)  2,80,02,50,89,154 (  70.48%)
instructions              3,11,90,38,02,741 (    0.78)  3,09,20,69,87,835 (    0.78)
branches                    49,71,39,90,321 ( 460.940)    49,10,44,23,983 ( 455.686)
branch-misses                  22,43,84,102 (   0.45%)       21,96,67,440 (   0.45%)
jobs8                              perfstat
stalled-cycles-frontend   3,59,62,09,66,766 (  73.38%)  3,58,04,85,16,351 (  73.37%)
instructions              3,43,83,05,02,841 (    0.70)  3,43,33,76,84,985 (    0.70)
branches                    54,02,15,25,784 ( 406.256)    53,91,13,38,774 ( 407.265)
branch-misses                  25,20,35,507 (   0.47%)       25,05,71,030 (   0.46%)
jobs9                              perfstat
stalled-cycles-frontend   4,15,33,64,48,628 (  73.76%)  4,22,88,52,47,923 (  74.16%)
instructions              3,90,79,09,16,552 (    0.69)  3,91,12,92,41,516 (    0.69)
branches                    61,66,87,76,271 ( 403.896)    61,73,58,17,174 ( 399.363)
branch-misses                  28,46,21,136 (   0.46%)       28,45,74,774 (   0.46%)
jobs10                             perfstat
stalled-cycles-frontend   4,74,43,71,32,846 (  74.30%)  4,66,34,70,59,452 (  73.82%)
instructions              4,35,23,51,39,076 (    0.68)  4,38,48,78,54,987 (    0.69)
branches                    68,72,17,08,212 ( 396.945)    69,48,52,50,280 ( 405.847)
branch-misses                  31,73,62,053 (   0.46%)       32,34,76,102 (   0.47%)
seconds elapsed        11.470858891     10.862984653
seconds elapsed        11.802220972     11.348959061
seconds elapsed        11.847204652     11.850297919
seconds elapsed        12.352068602     12.853222188
seconds elapsed        16.162715423     16.355883496
seconds elapsed        16.605502317     16.855938732
seconds elapsed        18.108333660     18.108347866
seconds elapsed        18.621296174     18.354183020
seconds elapsed        22.366502860     22.357632546
seconds elapsed        24.362417439     24.363003009

Maninder Singh, Vaneet Narang (1):
  lz4: Implement lz4 with dynamic offset (lz4_dyn).

 crypto/lz4.c               |   64 ++++++++++++++++++++++++++++++++-
 drivers/block/zram/zcomp.c |    4 ++
 fs/pstore/platform.c       |    2 +-
 include/linux/lz4.h        |   15 ++++++--
 lib/decompress_unlz4.c     |    2 +-
 lib/lz4/lz4_compress.c     |   84 +++++++++++++++++++++++++++++++++++--------
 lib/lz4/lz4_decompress.c   |   56 ++++++++++++++++++++---------
 lib/lz4/lz4defs.h          |   11 ++++++
 8 files changed, 197 insertions(+), 41 deletions(-)
