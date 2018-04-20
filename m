From: Minchan Kim <minchan@kernel.org>
Subject: Re: [PATCH v7 0/5] add compression algorithm zBeWalgo
Date: Fri, 20 Apr 2018 16:33:46 +0900
Message-ID: <20180420073346.GA17757@rodete-desktop-imager.corp.google.com>
References: <20180413154840.5901-1-4bwarnke@informatik.uni-hamburg.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
        herbert@gondor.apana.org.au, davem@davemloft.net,
        sergey.senozhatsky.work@gmail.com, ngupta@vflare.org,
        pombredanne@nexb.com, ebiggers3@gmail.com, smueller@chronox.de
To: Benjamin Warnke <4bwarnke@informatik.uni-hamburg.de>
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20180413154840.5901-1-4bwarnke@informatik.uni-hamburg.de>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

Hi Benjamin,

Today I tried your new patchset but I couldn't go further due to below
problem. Unfortunately, I don't have the time to look into.
Could you check on it?

Thanks.

[  169.597064] zram0: detected capacity change from 1073741824 to 0
[  177.523268] zram0: detected capacity change from 0 to 1073741824
[  181.312545] BUG: sleeping function called from invalid context at mm/page-writeback.c:2274
[  181.315578] in_atomic(): 1, irqs_disabled(): 0, pid: 2051, name: dd
[  181.317804] 1 lock held by dd/2051:
[  181.318973]  #0: 00000000d83cd3cb (&bdev->bd_mutex){+.+.}, at: __blkdev_put+0x41/0x1f0
[  181.321590] CPU: 5 PID: 2051 Comm: dd Not tainted 4.16.0-mm1+ #202
[  181.323599] Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS 1.10.2-1 04/01/2014
[  181.326295] Call Trace:
[  181.327117]  dump_stack+0x67/0x9b
[  181.328246]  ___might_sleep+0x149/0x230
[  181.329475]  write_cache_pages+0x31d/0x620
[  181.330726]  ? tag_pages_for_writeback+0x140/0x140
[  181.332201]  ? __lock_acquire+0x2b5/0x1300
[  181.333466]  generic_writepages+0x5f/0x90
[  181.334695]  ? do_writepages+0x4b/0xf0
[  181.335840]  ? blkdev_readpages+0x20/0x20
[  181.337077]  do_writepages+0x4b/0xf0
[  181.338174]  ? __filemap_fdatawrite_range+0xb4/0x100
[  181.339672]  ? __blkdev_put+0x41/0x1f0
[  181.340826]  ? __filemap_fdatawrite_range+0xc1/0x100
[  181.342251]  __filemap_fdatawrite_range+0xc1/0x100
[  181.343610]  filemap_write_and_wait+0x2c/0x70
[  181.344867]  __blkdev_put+0x71/0x1f0
[  181.345891]  blkdev_close+0x21/0x30
[  181.346889]  __fput+0xeb/0x220
[  181.347769]  task_work_run+0x93/0xc0
[  181.348803]  exit_to_usermode_loop+0x8d/0x90
[  181.350009]  do_syscall_64+0x16b/0x1b0
[  181.351080]  entry_SYSCALL_64_after_hwframe+0x42/0xb7
[  181.352498] RIP: 0033:0x7f5e88e028f0
[  181.353512] RSP: 002b:00007fff448399d8 EFLAGS: 00000246 ORIG_RAX: 0000000000000003
[  181.355501] RAX: 0000000000000000 RBX: 0000000000000001 RCX: 00007f5e88e028f0
[  181.357382] RDX: 0000000000001000 RSI: 0000000000000000 RDI: 0000000000000001
[  181.359254] RBP: 00007f5e892e2698 R08: 000000000117e000 R09: 00007fff448f2080
[  181.361134] R10: 000000000000086f R11: 0000000000000246 R12: 0000000000000000
[  181.362995] R13: 0000000000000000 R14: 0000000000000000 R15: 0000000000000000
[  181.365448] show_signal_msg: 12 callbacks suppressed
[  181.365452] dd[2051]: segfault at 7f5e88d78d70 ip 00007f5e88d78d70 sp 00007fff44839548 error 14 in libc-2.23.so[7f5e88d0b000+1c0000]
[  181.369877] BUG: scheduling while atomic: dd/2051/0x00000002
[  181.371734] no locks held by dd/2051.
[  181.372658] Modules linked in:
[  181.373503] CPU: 5 PID: 2051 Comm: dd Tainted: G        W         4.16.0-mm1+ #202
[  181.375379] Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS 1.10.2-1 04/01/2014
[  181.377454] Call Trace:
[  181.378055]  dump_stack+0x67/0x9b
[  181.378854]  __schedule_bug+0x5d/0x80
[  181.379731]  __schedule+0x7b5/0xbd0
[  181.380569]  ? find_held_lock+0x2d/0x90
[  181.381503]  ? try_to_wake_up+0x56/0x510
[  181.382437]  ? wait_for_completion+0x112/0x1a0
[  181.383486]  schedule+0x2f/0x90
[  181.384237]  schedule_timeout+0x22b/0x550
[  181.385198]  ? find_held_lock+0x2d/0x90
[  181.386105]  ? wait_for_completion+0x132/0x1a0
[  181.387158]  ? wait_for_completion+0x112/0x1a0
[  181.388221]  wait_for_completion+0x13a/0x1a0
[  181.389236]  ? wake_up_q+0x70/0x70
[  181.390008]  call_usermodehelper_exec+0x13b/0x170
[  181.391067]  do_coredump+0xaed/0x1040
[  181.391893]  ? try_to_wake_up+0x56/0x510
[  181.392815]  ? __lock_is_held+0x55/0x90
[  181.393694]  get_signal+0x32f/0x8e0
[  181.394485]  ? page_fault+0x2f/0x50
[  181.395271]  do_signal+0x36/0x6f0
[  181.396021]  ? force_sig_info_fault+0x97/0xf0
[  181.397018]  ? __bad_area_nosemaphore+0x19e/0x1b0
[  181.398074]  ? __do_page_fault+0xde/0x4b0
[  181.398977]  ? page_fault+0x2f/0x50
[  181.399780]  exit_to_usermode_loop+0x62/0x90
[  181.400770]  prepare_exit_to_usermode+0xbf/0xd0
[  181.401734]  retint_user+0x8/0x18
[  181.402446] RIP: 0033:0x7f5e88d78d70
[  181.403213] RSP: 002b:00007fff44839548 EFLAGS: 00010246
[  181.404319] RAX: 00007fff4483956f RBX: 00007fff44839550 RCX: 007361696c612e65
[  181.405827] RDX: 0000000000000000 RSI: 00007f5e88e97733 RDI: 00007fff44839550
[  181.407245] RBP: 00007fff44839790 R08: 656c61636f6c2f65 R09: feff7e5cff372c00
[  181.408920] R10: 0000000000000000 R11: 0000000000000000 R12: 000000000117df30
[  181.410817] R13: 00007fff44839860 R14: 00007fff44839880 R15: 0000000000000000



On Fri, Apr 13, 2018 at 05:48:35PM +0200, Benjamin Warnke wrote:
> This patch series adds a new compression algorithm to the kernel and to
> the crypto api.
> 
> Changes since v6:
> - Fixed git apply error due to other recently applied patches
> 
> Changes since v5:
> - Fixed compile-error due to variable definitions inside #ifdef CONFIG_ZRAM_WRITEBACK
> 
> Changes since v4:
> - Fix mismatching function-prototypes
> - Fix mismatching License errors
> - Add static to global vars
> - Add ULL to long constants
> 
> Changes since v3:
> - Split patch into patchset
> - Add Zstd = Zstandard to the list of benchmarked algorithms
> - Added configurable compression levels to crypto-api
> - Added multiple compression levels to the benchmarks below
> - Added unsafe decompressor functions to crypto-api
> - Added flag to mark unstable algorithms to crypto-api
> - Test the code using afl-fuzz -> and fix the code
> - Added 2 new Benchmark datasets
> - checkpatch.pl fixes
> 
> Changes since v2:
> - added linux-kernel Mailinglist
> 
> Changes since v1:
> - improved documentation
> - improved code style
> - replaced numerous casts with get_unaligned*
> - added tests in crypto/testmgr.h/c
> - added zBeWalgo to the list of algorithms shown by 
> /sys/block/zram0/comp_algorithm
> 
> 
> Currently ZRAM uses compression-algorithms from the crypto-api. ZRAM
> compresses each page individually. As a result the compression algorithm is
> forced to use a very small sliding window. None of the available compression
> algorithms is designed to achieve high compression ratios with small inputs.
> 
> This patch-set adds a new compression algorithm 'zBeWalgo' to the crypto api.
> This algorithm focusses on increasing the capacity of the compressed
> block-device created by ZRAM. The choice of compression algorithms is always
> a tradeoff between speed and compression ratio.
> 
> If faster algorithms like 'lz4' are chosen the compression ratio is often
> lower than the ratio of zBeWalgo as shown in the following benchmarks. Due to
> the lower compression ratio, ZRAM needs to fall back to backing_devices
> mode often. If backing_devices are required, the effective speed of ZRAM is a
> weighted average of de/compression time and writing/reading from the
> backing_device. This should be considered when comparing the speeds in the
> benchmarks.
> 
> There are different kinds of backing_devices, each with its own drawbacks.
> 1. HDDs: This kind of backing device is very slow. If the compression ratio
> of an algorithm is much lower than the ratio of zBeWalgo, it might be faster
> to use zBewalgo instead.
> 2. SSDs: I tested a swap partition on my NVME-SSD. The speed is even higher
> than zram with lz4, but after about 5 Minutes the SSD is blocking all
> read/write requests due to overheating. This is definitly not an option.
> 
> 
> Benchmarks:
> 
> 
> To obtain reproducable benchmarks, the datasets were first loaded into a
> userspace-program. Than the data is written directly to a clean
> zram-partition without any filesystem. Between writing and reading 'sync'
> and 'echo 3 > /proc/sys/vm/drop_caches' is called. All time measurements are
> wall clock times, and the benchmarks are using only one cpu-core at a time.
> The new algorithm is compared to all available compression algorithms from
> the crypto-api.
> 
> Before loading the datasets to user-space deduplication is applied, since
> none Algorithm has deduplication. Duplicated pages are removed to
> prevent an algorithm to obtain high/low ratios, just because a single page can
> be compressed very well - or not.
> 
> All Algorithms marked with '*' are using unsafe decompression.
> 
> All Read and Write Speed Measurements are given in MBit/s
> 
> zbewalgo' uses per dataset specialized different combinations. These can be
> specified at runtime via /sys/kernel/zbewalgo/combinations.
> 
> 
> - '/dev/zero' This dataset is used to measure the speed limitations
> for ZRAM. ZRAM filters zero-data internally and does not even call the
> specified compression algorithm.
> 
> Algorithm       write    read
> --zram--      2724.08 2828.87
> 
> 
> - 'ecoham' This dataset is one of the input files for the scientific
> application ECOHAM which runs an ocean simulation. This dataset contains a
> lot of zeros - even after deduplication. Where the data is not zero there are
> arrays of floating point values, adjacent float values are likely to be
> similar to each other, allowing for high compression ratios.
> 
> zbewalgo reaches very high compression ratios and is a lot faster than other
> algorithms with similar compression ratios.
> 
> Algorithm    ratio    write     read
> --hdd--       1.00   134.70   156.62
> lz4*_10       6.73  1303.12  1547.17
> lz4_10        6.73  1303.12  1574.51
> lzo           6.88  1205.98  1468.09
> lz4*_05       7.00  1291.81  1642.41
> lz4_05        7.00  1291.81  1682.81
> lz4_07        7.13  1250.29  1593.89
> lz4*_07       7.13  1250.29  1677.08
> lz4_06        7.16  1307.62  1666.66
> lz4*_06       7.16  1307.62  1669.42
> lz4_03        7.21  1250.87  1449.48
> lz4*_03       7.21  1250.87  1621.97
> lz4*_04       7.23  1281.62  1645.56
> lz4_04        7.23  1281.62  1666.81
> lz4_02        7.33  1267.54  1523.11
> lz4*_02       7.33  1267.54  1576.54
> lz4_09        7.36  1140.55  1510.01
> lz4*_09       7.36  1140.55  1692.38
> lz4*_01       7.36  1215.40  1575.38
> lz4_01        7.36  1215.40  1676.65
> lz4_08        7.36  1242.73  1544.07
> lz4*_08       7.36  1242.73  1692.92
> lz4hc_01      7.51   235.85  1545.61
> lz4hc*_01     7.51   235.85  1678.00
> lz4hc_02      7.62   226.30  1697.42
> lz4hc*_02     7.62   226.30  1738.79
> lz4hc*_03     7.71   194.64  1711.58
> lz4hc_03      7.71   194.64  1713.59
> lz4hc*_04     7.76   177.17  1642.39
> lz4hc_04      7.76   177.17  1698.36
> deflate_1     7.80    84.71   584.89
> lz4hc*_05     7.81   149.11  1558.43
> lz4hc_05      7.81   149.11  1686.71
> deflate_2     7.82    82.83   599.38
> deflate_3     7.86    84.27   616.05
> lz4hc_06      7.88   106.61  1680.52
> lz4hc*_06     7.88   106.61  1739.78
> zstd_07       7.92   230.34  1016.91
> zstd_05       7.92   252.71  1070.46
> zstd_06       7.93   237.84  1062.11
> lz4hc*_07     7.94    75.22  1751.91
> lz4hc_07      7.94    75.22  1768.98
> zstd_04       7.94   403.21  1080.62
> zstd_03       7.94   411.91  1077.26
> zstd_01       7.94   455.89  1082.54
> zstd_09       7.94   456.81  1079.22
> zstd_08       7.94   459.54  1082.07
> zstd_02       7.94   465.82  1056.67
> zstd_11       7.95   150.15  1070.31
> zstd_10       7.95   169.95  1107.86
> lz4hc_08      7.98    49.53  1611.61
> lz4hc*_08     7.98    49.53  1793.68
> lz4hc_09      7.98    49.62  1629.63
> lz4hc*_09     7.98    49.62  1639.83
> lz4hc*_10     7.99    37.96  1742.65
> lz4hc_10      7.99    37.96  1790.08
> zbewalgo      8.02    38.58   237.92
> zbewalgo*     8.02    38.58   239.10
> 842           8.05   169.90   597.01
> zstd_13       8.06   129.78  1131.66
> zstd_12       8.06   135.50  1126.59
> deflate_4     8.16    71.14   546.52
> deflate_5     8.17    70.86   537.05
> zstd_17       8.19    61.46  1061.45
> zstd_14       8.20   124.43  1133.68
> zstd_18       8.21    56.82  1151.25
> zstd_19       8.22    51.51  1161.83
> zstd_20       8.24    44.26  1108.36
> zstd_16       8.25    76.26  1042.82
> zstd_15       8.25    86.65  1181.98
> deflate_6     8.28    66.45   619.62
> deflate_7     8.30    63.83   631.13
> zstd_21       8.41     6.73  1177.38
> zstd_22       8.46     2.23  1188.39
> deflate_9     8.47    44.16   678.43
> deflate_8     8.47    48.00   677.50
> zbewalgo'     8.80   634.68  1247.56
> zbewalgo'*    8.80   634.68  1429.42
> 
> 
> - 'source-code' This dataset is a tarball of the source-code from a
> linux-kernel.
> 
> zBeWalgo is very bad in compressing text based datasets.
> 
> 
> Algorithm    ratio   write     read
> --hdd--       1.00  134.70   156.62
> lz4_10        1.49  584.41  1200.01
> lz4*_10       1.49  584.41  1251.79
> lz4*_07       1.64  559.05  1160.75
> lz4_07        1.64  559.05  1160.97
> 842           1.65   63.66   158.53
> lz4_06        1.71  513.03  1068.18
> lz4*_06       1.71  513.03  1162.68
> lz4_05        1.78  526.31  1136.51
> lz4*_05       1.78  526.31  1144.81
> lz4*_04       1.87  506.63  1106.31
> lz4_04        1.87  506.63  1132.96
> zbewalgo      1.89   27.56    35.04
> zbewalgo*     1.89   27.56    36.20
> zbewalgo'     1.89   46.62    34.75
> zbewalgo'*    1.89   46.62    36.34
> lz4_03        1.98  485.91   984.92
> lz4*_03       1.98  485.91  1125.68
> lz4_02        2.07  454.96  1061.05
> lz4*_02       2.07  454.96  1133.42
> lz4_01        2.17  441.11  1141.52
> lz4*_01       2.17  441.11  1146.26
> lz4*_08       2.17  446.45  1103.61
> lz4_08        2.17  446.45  1163.91
> lz4*_09       2.17  453.21  1071.91
> lz4_09        2.17  453.21  1155.43
> lzo           2.27  430.27   871.87
> lz4hc*_01     2.35  137.71  1089.94
> lz4hc_01      2.35  137.71  1200.45
> lz4hc_02      2.38  139.18  1117.44
> lz4hc*_02     2.38  139.18  1210.58
> lz4hc_03      2.39  127.09  1097.90
> lz4hc*_03     2.39  127.09  1214.22
> lz4hc_10      2.40   96.26  1203.89
> lz4hc*_10     2.40   96.26  1221.94
> lz4hc*_08     2.40   98.80  1191.79
> lz4hc_08      2.40   98.80  1226.59
> lz4hc*_09     2.40  102.36  1213.34
> lz4hc_09      2.40  102.36  1225.45
> lz4hc*_07     2.40  113.81  1217.63
> lz4hc_07      2.40  113.81  1218.49
> lz4hc*_06     2.40  117.32  1214.13
> lz4hc_06      2.40  117.32  1224.51
> lz4hc_05      2.40  122.12  1108.34
> lz4hc*_05     2.40  122.12  1214.97
> lz4hc*_04     2.40  124.91  1093.58
> lz4hc_04      2.40  124.91  1222.05
> zstd_01       2.93  200.01   401.15
> zstd_08       2.93  200.01   414.52
> zstd_09       2.93  200.26   394.83
> zstd_02       3.00  201.12   405.73
> deflate_1     3.01   53.83   240.64
> deflate_2     3.05   52.58   243.31
> deflate_3     3.08   52.07   244.84
> zstd_04       3.10  158.80   365.06
> zstd_03       3.10  169.56   405.92
> zstd_05       3.18  125.00   410.23
> zstd_06       3.20  106.50   404.81
> zstd_07       3.21   99.02   404.23
> zstd_15       3.22   24.95   376.58
> zstd_16       3.22   26.88   416.44
> deflate_4     3.22   45.26   225.56
> zstd_13       3.22   62.53   388.33
> zstd_14       3.22   64.15   391.81
> zstd_12       3.22   66.24   417.67
> zstd_11       3.22   66.44   404.31
> zstd_10       3.22   73.13   401.98
> zstd_17       3.24   14.66   412.00
> zstd_18       3.25   13.37   408.46
> deflate_5     3.26   43.54   252.18
> deflate_7     3.27   39.37   245.63
> deflate_6     3.27   42.51   251.33
> deflate_9     3.28   40.02   253.99
> deflate_8     3.28   40.10   253.98
> zstd_19       3.34   10.36   399.85
> zstd_22       3.35    4.88   353.63
> zstd_21       3.35    6.02   323.33
> zstd_20       3.35    8.34   339.81
> 
> 
> - 'hpcg' This dataset is a (partial) memory-snapshot of the
> running hpcg-benchmark. At the time of the snapshot, that application
> performed a sparse matrix - vector multiplication.
> 
> The compression ratio of zBeWalgo on this dataset is nearly 3 times higher
> than the ratio of any other algorithm regardless of the compression-level
> specified.
> 
> Algorithm     ratio    write     read
> --hdd--        1.00   134.70   156.62
> lz4*_10        1.00  1130.73  2131.82
> lz4_10         1.00  1130.73  2181.60
> lz4_06         1.34   625.48  1145.74
> lz4*_06        1.34   625.48  1145.90
> lz4_07         1.57   515.39   895.42
> lz4*_07        1.57   515.39  1062.53
> lz4*_05        1.72   539.40  1030.76
> lz4_05         1.72   539.40  1038.86
> lzo            1.76   475.20   805.41
> lz4_08         1.76   480.35   939.16
> lz4*_08        1.76   480.35  1015.04
> lz4*_03        1.76   488.05   893.13
> lz4_03         1.76   488.05  1013.65
> lz4*_09        1.76   501.49  1032.69
> lz4_09         1.76   501.49  1105.47
> lz4*_01        1.76   501.54  1040.72
> lz4_01         1.76   501.54  1102.22
> lz4*_02        1.76   510.79  1014.78
> lz4_02         1.76   510.79  1080.69
> lz4_04         1.76   516.18  1047.06
> lz4*_04        1.76   516.18  1049.55
> 842            2.35   109.68   192.50
> lz4hc_07       2.36   152.57  1265.77
> lz4hc*_07      2.36   152.57  1331.01
> lz4hc*_06      2.36   155.78  1313.85
> lz4hc_06       2.36   155.78  1346.52
> lz4hc*_08      2.36   158.80  1297.16
> lz4hc_08       2.36   158.80  1382.54
> lz4hc*_10      2.36   159.84  1317.81
> lz4hc_10       2.36   159.84  1346.85
> lz4hc*_03      2.36   160.01  1162.91
> lz4hc_03       2.36   160.01  1377.09
> lz4hc*_09      2.36   161.02  1320.87
> lz4hc_09       2.36   161.02  1374.39
> lz4hc*_05      2.36   164.67  1324.40
> lz4hc_05       2.36   164.67  1341.64
> lz4hc*_04      2.36   168.11  1323.19
> lz4hc_04       2.36   168.11  1377.56
> lz4hc_01       2.36   168.40  1231.55
> lz4hc*_01      2.36   168.40  1329.72
> lz4hc*_02      2.36   170.74  1316.54
> lz4hc_02       2.36   170.74  1337.42
> deflate_3      3.52    46.51   336.67
> deflate_2      3.52    62.05   343.03
> deflate_1      3.52    65.68   359.96
> deflate_4      4.01    61.01   432.66
> deflate_8      4.61    41.51   408.29
> deflate_5      4.61    44.09   434.79
> deflate_9      4.61    45.14   417.18
> deflate_7      4.61    45.22   440.27
> deflate_6      4.61    46.01   440.39
> zstd_09        5.95   277.11   542.93
> zstd_08        5.95   277.40   541.27
> zstd_01        5.95   277.41   540.61
> zstd_16        5.97    32.05   465.03
> zstd_15        5.97    39.12   515.07
> zstd_13        5.97    70.90   511.94
> zstd_14        5.97    72.20   522.68
> zstd_11        5.97    74.14   512.18
> zstd_12        5.97    74.27   497.95
> zstd_10        5.97    86.98   519.78
> zstd_07        5.97   135.16   504.07
> zstd_06        5.97   145.49   505.10
> zstd_05        6.02   177.86   510.08
> zstd_04        6.02   205.13   516.29
> zstd_03        6.02   217.82   515.50
> zstd_02        6.02   260.97   484.64
> zstd_18        6.27    12.10   490.72
> zstd_17        6.27    12.33   462.65
> zstd_21        6.70     9.25   391.16
> zstd_20        6.70     9.50   395.38
> zstd_22        6.70     9.74   390.99
> zstd_19        6.70     9.99   450.42
> zbewalgo      16.33    47.17   430.06
> zbewalgo*     16.33    47.17   436.92
> zbewalgo'     16.33   188.86   427.78
> zbewalgo'*    16.33   188.86   437.43
> 
> 
> - 'partdiff' (8 GiB) Array of double values. Adjacent doubles are similar, but
> not equal. This array is produced by a partial differential equation solver
> using a Jakobi-implementation.
> 
> zBewalgo gains higher compression ratios than all other algorithms.
> Some algorithms are even slower than a hdd without any compression at all.
> 
> Algorithm    ratio    write     read
> zstd_18       1.00    13.77  2080.06
> zstd_17       1.00    13.80  2075.23
> zstd_16       1.00    28.04  2138.99
> zstd_15       1.00    45.04  2143.32
> zstd_13       1.00    55.72  2128.27
> zstd_14       1.00    56.09  2123.54
> zstd_11       1.00    57.31  2095.04
> zstd_12       1.00    57.53  2134.61
> 842           1.00    61.61  2267.89
> zstd_10       1.00    80.40  2081.35
> zstd_07       1.00   120.66  2119.09
> zstd_06       1.00   128.80  2134.02
> zstd_05       1.00   131.25  2133.01
> --hdd--       1.00   134.70   156.62
> lz4hc*_03     1.00   152.82  1982.94
> lz4hc_03      1.00   152.82  2261.55
> lz4hc*_07     1.00   159.43  1990.03
> lz4hc_07      1.00   159.43  2269.05
> lz4hc_10      1.00   166.33  2243.78
> lz4hc*_10     1.00   166.33  2260.63
> lz4hc_09      1.00   167.03  2244.20
> lz4hc*_09     1.00   167.03  2264.72
> lz4hc*_06     1.00   167.17  2245.15
> lz4hc_06      1.00   167.17  2271.88
> lz4hc_08      1.00   167.49  2237.79
> lz4hc*_08     1.00   167.49  2283.98
> lz4hc_02      1.00   167.51  2275.36
> lz4hc*_02     1.00   167.51  2279.72
> lz4hc*_05     1.00   167.52  2248.92
> lz4hc_05      1.00   167.52  2273.99
> lz4hc*_04     1.00   167.71  2268.23
> lz4hc_04      1.00   167.71  2268.78
> lz4hc*_01     1.00   167.91  2268.76
> lz4hc_01      1.00   167.91  2269.16
> zstd_04       1.00   175.84  2241.60
> zstd_03       1.00   176.35  2285.13
> zstd_02       1.00   195.41  2269.51
> zstd_09       1.00   199.47  2271.91
> zstd_01       1.00   199.74  2287.15
> zstd_08       1.00   199.87  2286.27
> lz4_01        1.00  1160.95  2257.78
> lz4*_01       1.00  1160.95  2275.42
> lz4_08        1.00  1164.37  2280.06
> lz4*_08       1.00  1164.37  2280.43
> lz4*_09       1.00  1166.30  2263.05
> lz4_09        1.00  1166.30  2280.54
> lz4*_03       1.00  1174.00  2074.96
> lz4_03        1.00  1174.00  2257.37
> lz4_02        1.00  1212.18  2273.60
> lz4*_02       1.00  1212.18  2285.66
> lz4*_04       1.00  1253.55  2259.60
> lz4_04        1.00  1253.55  2287.15
> lz4_05        1.00  1279.88  2282.47
> lz4*_05       1.00  1279.88  2287.05
> lz4_06        1.00  1292.22  2277.95
> lz4*_06       1.00  1292.22  2284.84
> lz4*_07       1.00  1303.58  2276.10
> lz4_07        1.00  1303.58  2276.99
> lz4*_10       1.00  1304.80  2183.30
> lz4_10        1.00  1304.80  2285.25
> lzo           1.00  1360.88  2281.19
> deflate_7     1.07    33.51   463.73
> deflate_2     1.07    33.99   473.07
> deflate_9     1.07    34.05   473.57
> deflate_6     1.07    34.06   473.69
> deflate_8     1.07    34.12   472.86
> deflate_5     1.07    34.22   468.03
> deflate_4     1.07    34.32   447.33
> deflate_1     1.07    35.45   431.95
> deflate_3     1.07    35.63   472.56
> zstd_22       1.11     9.81   668.64
> zstd_21       1.11    10.71   734.52
> zstd_20       1.11    10.78   714.86
> zstd_19       1.11    12.02   790.71
> zbewalgo      1.29    25.93   225.07
> zbewalgo*     1.29    25.93   226.72
> zbewalgo'*    1.31    23.54    84.29
> zbewalgo'     1.31    23.54    86.08
> 
> - 'Isabella CLOUDf01'
> This dataset is an array of floating point values between 0.00000 and 0.00332.
> Detailed Information about this dataset is online available at
> http://www.vets.ucar.edu/vg/isabeldata/readme.html
> 
> All algorithms obtain similar compression ratios. The compression ratio of
> zBeWalgo is slightly higher, and the speed is higher too.
> 
> Algorithm    ratio    write     read
> --hdd--       1.00   134.70   156.62
> lzo           2.06  1022.09   916.22
> lz4*_10       2.09  1126.03  1533.35
> lz4_10        2.09  1126.03  1569.06
> lz4*_07       2.09  1135.89  1444.21
> lz4_07        2.09  1135.89  1581.96
> lz4*_01       2.10   972.22  1405.21
> lz4_01        2.10   972.22  1579.78
> lz4*_09       2.10   982.39  1429.17
> lz4_09        2.10   982.39  1490.27
> lz4_08        2.10  1006.56  1491.14
> lz4*_08       2.10  1006.56  1558.66
> lz4_02        2.10  1019.82  1366.16
> lz4*_02       2.10  1019.82  1578.79
> lz4_03        2.10  1129.74  1417.33
> lz4*_03       2.10  1129.74  1456.68
> lz4_04        2.10  1131.28  1478.27
> lz4*_04       2.10  1131.28  1517.84
> lz4_06        2.10  1147.78  1424.90
> lz4*_06       2.10  1147.78  1462.47
> lz4*_05       2.10  1172.44  1434.86
> lz4_05        2.10  1172.44  1578.80
> lz4hc*_10     2.11    29.01  1498.01
> lz4hc_10      2.11    29.01  1580.23
> lz4hc*_09     2.11    56.30  1510.26
> lz4hc_09      2.11    56.30  1583.11
> lz4hc_08      2.11    56.39  1426.43
> lz4hc*_08     2.11    56.39  1565.12
> lz4hc_07      2.11   129.27  1540.38
> lz4hc*_07     2.11   129.27  1578.35
> lz4hc*_06     2.11   162.72  1456.27
> lz4hc_06      2.11   162.72  1581.69
> lz4hc*_05     2.11   183.78  1487.71
> lz4hc_05      2.11   183.78  1589.10
> lz4hc*_04     2.11   187.41  1431.35
> lz4hc_04      2.11   187.41  1566.24
> lz4hc*_03     2.11   190.21  1531.98
> lz4hc_03      2.11   190.21  1580.81
> lz4hc*_02     2.11   199.69  1432.00
> lz4hc_02      2.11   199.69  1565.10
> lz4hc_01      2.11   205.87  1540.33
> lz4hc*_01     2.11   205.87  1567.68
> 842           2.15    89.89   414.49
> deflate_1     2.29    48.84   352.09
> deflate_2     2.29    49.47   353.77
> deflate_3     2.30    50.00   345.88
> zstd_22       2.31     5.59   658.59
> zstd_21       2.31    14.34   664.02
> zstd_20       2.31    21.22   665.77
> zstd_19       2.31    24.26   587.99
> zstd_17       2.31    26.24   670.14
> zstd_18       2.31    26.47   668.64
> deflate_9     2.31    33.79   345.81
> deflate_8     2.31    34.67   347.96
> deflate_4     2.31    41.46   326.50
> deflate_7     2.31    42.56   346.99
> deflate_6     2.31    43.51   343.56
> deflate_5     2.31    45.83   343.86
> zstd_05       2.31   126.01   571.70
> zstd_04       2.31   178.39   597.26
> zstd_03       2.31   192.04   644.24
> zstd_01       2.31   206.31   563.68
> zstd_08       2.31   207.39   669.05
> zstd_02       2.31   216.98   600.77
> zstd_09       2.31   236.92   667.64
> zstd_16       2.32    41.47   660.06
> zstd_15       2.32    60.37   584.45
> zstd_14       2.32    74.60   673.10
> zstd_12       2.32    75.16   661.96
> zstd_13       2.32    75.22   676.12
> zstd_11       2.32    75.58   636.75
> zstd_10       2.32    95.05   645.07
> zstd_07       2.32   139.52   672.88
> zstd_06       2.32   145.40   670.45
> zbewalgo'*    2.37   337.07   463.32
> zbewalgo'     2.37   337.07   468.96
> zbewalgo*     2.60   101.17   578.35
> zbewalgo      2.60   101.17   586.88
> 
> 
> - 'Isabella TCf01'
> This dataset is an array of floating point values between -83.00402 and 31.51576.
> Detailed Information about this dataset is online available at
> http://www.vets.ucar.edu/vg/isabeldata/readme.html
> 
> zBeWalgo is the only algorithm which can compress this dataset with a noticeable
> compressionratio.
> 
> Algorithm    ratio    write     read
> 842           1.00    60.09  1956.26
> --hdd--       1.00   134.70   156.62
> lz4hc_01      1.00   154.81  1839.37
> lz4hc*_01     1.00   154.81  2105.53
> lz4hc_10      1.00   157.33  2078.69
> lz4hc*_10     1.00   157.33  2113.14
> lz4hc_09      1.00   158.50  2018.51
> lz4hc*_09     1.00   158.50  2093.65
> lz4hc*_02     1.00   159.54  2104.91
> lz4hc_02      1.00   159.54  2117.34
> lz4hc_03      1.00   161.26  2070.76
> lz4hc*_03     1.00   161.26  2107.27
> lz4hc*_08     1.00   161.34  2100.74
> lz4hc_08      1.00   161.34  2105.26
> lz4hc*_04     1.00   161.95  2080.96
> lz4hc_04      1.00   161.95  2104.00
> lz4hc_05      1.00   162.17  2044.43
> lz4hc*_05     1.00   162.17  2101.74
> lz4hc*_06     1.00   163.61  2087.19
> lz4hc_06      1.00   163.61  2104.61
> lz4hc_07      1.00   164.51  2094.78
> lz4hc*_07     1.00   164.51  2105.53
> lz4_01        1.00  1134.89  2109.70
> lz4*_01       1.00  1134.89  2118.71
> lz4*_08       1.00  1141.96  2104.87
> lz4_08        1.00  1141.96  2118.97
> lz4_09        1.00  1145.55  2087.76
> lz4*_09       1.00  1145.55  2118.85
> lz4_02        1.00  1157.28  2094.33
> lz4*_02       1.00  1157.28  2124.67
> lz4*_03       1.00  1194.18  2106.36
> lz4_03        1.00  1194.18  2119.89
> lz4_04        1.00  1195.09  2117.03
> lz4*_04       1.00  1195.09  2120.23
> lz4*_05       1.00  1225.56  2109.04
> lz4_05        1.00  1225.56  2120.52
> lz4*_06       1.00  1261.67  2109.14
> lz4_06        1.00  1261.67  2121.13
> lz4*_07       1.00  1270.86  1844.63
> lz4_07        1.00  1270.86  2041.08
> lz4_10        1.00  1305.36  2109.22
> lz4*_10       1.00  1305.36  2120.65
> lzo           1.00  1338.61  2109.66
> zstd_17       1.03    13.93  1138.94
> zstd_18       1.03    14.01  1170.78
> zstd_16       1.03    27.12  1073.75
> zstd_15       1.03    43.52  1061.97
> zstd_14       1.03    49.60  1082.98
> zstd_12       1.03    55.03  1042.43
> zstd_13       1.03    55.14  1173.50
> zstd_11       1.03    55.24  1178.05
> zstd_10       1.03    70.01  1173.05
> zstd_07       1.03   118.10  1041.92
> zstd_06       1.03   123.00  1171.59
> zstd_05       1.03   124.61  1165.74
> zstd_01       1.03   166.80  1005.29
> zstd_04       1.03   170.25  1127.75
> zstd_03       1.03   171.40  1172.34
> zstd_02       1.03   174.08  1017.34
> zstd_09       1.03   195.30  1176.82
> zstd_08       1.03   195.98  1175.09
> deflate_9     1.05    30.15   483.55
> deflate_8     1.05    30.45   466.67
> deflate_5     1.05    31.25   480.92
> deflate_4     1.05    31.84   472.81
> deflate_7     1.05    31.84   484.18
> deflate_6     1.05    31.94   481.37
> deflate_2     1.05    33.07   484.09
> deflate_3     1.05    33.11   463.57
> deflate_1     1.05    33.19   469.71
> zstd_22       1.06     8.89   647.75
> zstd_21       1.06    10.70   700.11
> zstd_20       1.06    10.80   723.42
> zstd_19       1.06    12.41   764.24
> zbewalgo*     1.51   146.45   581.43
> zbewalgo      1.51   146.45   592.86
> zbewalgo'*    1.54    38.14   120.96
> zbewalgo'     1.54    38.14   125.81
> 
> 
> Signed-off-by: Benjamin Warnke <4bwarnke@informatik.uni-hamburg.de>
> 
> Benjamin Warnke (5):
>   add compression algorithm zBeWalgo
>   crypto: add zBeWalgo to crypto-api
>   crypto: add unsafe decompression to api
>   crypto: configurable compression level
>   crypto: add flag for unstable encoding
> 
>  crypto/842.c                         |   3 +-
>  crypto/Kconfig                       |  12 +
>  crypto/Makefile                      |   1 +
>  crypto/api.c                         |  76 ++++
>  crypto/compress.c                    |  10 +
>  crypto/crypto_null.c                 |   3 +-
>  crypto/deflate.c                     |  19 +-
>  crypto/lz4.c                         |  39 +-
>  crypto/lz4hc.c                       |  36 +-
>  crypto/lzo.c                         |   3 +-
>  crypto/testmgr.c                     |  39 +-
>  crypto/testmgr.h                     | 134 +++++++
>  crypto/zbewalgo.c                    | 191 ++++++++++
>  drivers/block/zram/zcomp.c           |  13 +-
>  drivers/block/zram/zcomp.h           |   3 +-
>  drivers/block/zram/zram_drv.c        |  56 ++-
>  drivers/block/zram/zram_drv.h        |   2 +
>  drivers/crypto/cavium/zip/zip_main.c |   6 +-
>  drivers/crypto/nx/nx-842-powernv.c   |   3 +-
>  drivers/crypto/nx/nx-842-pseries.c   |   3 +-
>  fs/ubifs/compress.c                  |   2 +-
>  include/linux/crypto.h               |  31 +-
>  include/linux/zbewalgo.h             |  50 +++
>  lib/Kconfig                          |   3 +
>  lib/Makefile                         |   1 +
>  lib/zbewalgo/BWT.c                   | 120 ++++++
>  lib/zbewalgo/BWT.h                   |  21 ++
>  lib/zbewalgo/JBE.c                   | 204 ++++++++++
>  lib/zbewalgo/JBE.h                   |  13 +
>  lib/zbewalgo/JBE2.c                  | 221 +++++++++++
>  lib/zbewalgo/JBE2.h                  |  13 +
>  lib/zbewalgo/MTF.c                   | 122 ++++++
>  lib/zbewalgo/MTF.h                   |  13 +
>  lib/zbewalgo/Makefile                |   4 +
>  lib/zbewalgo/RLE.c                   | 137 +++++++
>  lib/zbewalgo/RLE.h                   |  13 +
>  lib/zbewalgo/bewalgo.c               | 401 ++++++++++++++++++++
>  lib/zbewalgo/bewalgo.h               |  13 +
>  lib/zbewalgo/bewalgo2.c              | 407 ++++++++++++++++++++
>  lib/zbewalgo/bewalgo2.h              |  13 +
>  lib/zbewalgo/bitshuffle.c            |  93 +++++
>  lib/zbewalgo/bitshuffle.h            |  13 +
>  lib/zbewalgo/huffman.c               | 262 +++++++++++++
>  lib/zbewalgo/huffman.h               |  13 +
>  lib/zbewalgo/include.h               |  94 +++++
>  lib/zbewalgo/zbewalgo.c              | 713 +++++++++++++++++++++++++++++++++++
>  mm/zswap.c                           |   2 +-
>  net/xfrm/xfrm_ipcomp.c               |   3 +-
>  48 files changed, 3605 insertions(+), 42 deletions(-)
>  create mode 100644 crypto/zbewalgo.c
>  create mode 100644 include/linux/zbewalgo.h
>  create mode 100644 lib/zbewalgo/BWT.c
>  create mode 100644 lib/zbewalgo/BWT.h
>  create mode 100644 lib/zbewalgo/JBE.c
>  create mode 100644 lib/zbewalgo/JBE.h
>  create mode 100644 lib/zbewalgo/JBE2.c
>  create mode 100644 lib/zbewalgo/JBE2.h
>  create mode 100644 lib/zbewalgo/MTF.c
>  create mode 100644 lib/zbewalgo/MTF.h
>  create mode 100644 lib/zbewalgo/Makefile
>  create mode 100644 lib/zbewalgo/RLE.c
>  create mode 100644 lib/zbewalgo/RLE.h
>  create mode 100644 lib/zbewalgo/bewalgo.c
>  create mode 100644 lib/zbewalgo/bewalgo.h
>  create mode 100644 lib/zbewalgo/bewalgo2.c
>  create mode 100644 lib/zbewalgo/bewalgo2.h
>  create mode 100644 lib/zbewalgo/bitshuffle.c
>  create mode 100644 lib/zbewalgo/bitshuffle.h
>  create mode 100644 lib/zbewalgo/huffman.c
>  create mode 100644 lib/zbewalgo/huffman.h
>  create mode 100644 lib/zbewalgo/include.h
>  create mode 100644 lib/zbewalgo/zbewalgo.c
> 
> -- 
> 2.14.1
> 
