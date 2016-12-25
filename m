From: Anatoly Pugachev <matorola@gmail.com>
Subject: [sparc64] cryptomgr_test OOPS kernel 4.9.0+
Date: Sun, 25 Dec 2016 20:56:08 +0300
Message-ID: <CADxRZqwxU+XjTe+jwfrDdsp7Vs47YsJHww3=bsENhrUsYgHvkg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Cc: Sparc kernel list <sparclinux@vger.kernel.org>
To: linux-crypto@vger.kernel.org
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-wj0-f182.google.com ([209.85.210.182]:33602 "EHLO
        mail-wj0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752426AbcLYR4L (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Sun, 25 Dec 2016 12:56:11 -0500
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Hello!

Disabling kernel config option
CRYPTO_MANAGER_DISABLE_TESTS
i.e. enable run-time self tests, makes kernel unbootable:

tested with git kernels v4.9-8648-g5cc60aeedf31 and v4.9-12259-g7c0f6ba682b9


SILO Version 1.4.14
boot:
Allocated 64 Megs of memory at 0x40000000 for kernel
Uncompressing image...
Loaded kernel version 4.9.0
Loading initial ramdisk (14000758 bytes at 0x74000000 phys, 0x40C00000 virt)...
/
[    0.000000] PROMLIB: Sun IEEE Boot Prom 'OBP 4.38.5 2016/06/22 19:36'
[    0.000000] PROMLIB: Root node compatible: sun4v
[    0.000000] Linux version 4.9.0+ (mator@ttip) (gcc version 6.2.1
20161215 (Debian 6.2.1-7) ) #38 SMP Sun Dec 25 13:35:48 MSK 2016
[    0.000000] debug: skip boot console de-registration.
[    0.000000] bootconsole [earlyprom0] enabled
[    0.000000] ARCH: SUN4V
[    0.000000] Ethernet address: 00:14:4f:fa:06:f2
[    0.000000] MM: PAGE_OFFSET is 0xfff8000000000000 (max_phys_bits == 47)
[    0.000000] MM: VMALLOC [0x0000000100000000 --> 0x0006000000000000]
[    0.000000] MM: VMEMMAP [0x0006000000000000 --> 0x000c000000000000]
[    0.000000] Kernel: Using 5 locked TLB entries for main kernel image.
[    0.000000] Remapping the kernel...
[    0.000000] done.
[    0.000000] kmemleak: Kernel memory leak detector disabled
[    0.000000] OF stdout device is: /virtual-devices@100/console@1
[    0.000000] PROM: Built device tree with 85327 bytes of memory.
[    0.000000] MDESC: Size is 35552 bytes.
[    0.000000] PLATFORM: banner-name [SPARC T5-2]
[    0.000000] PLATFORM: name [ORCL,SPARC-T5-2]
[    0.000000] PLATFORM: hostid [84fa06f2]
[    0.000000] PLATFORM: serial# [0035260e]
[    0.000000] PLATFORM: stick-frequency [3b9aca00]
[    0.000000] PLATFORM: mac-address [144ffa06f2]
[    0.000000] PLATFORM: watchdog-resolution [1000 ms]
[    0.000000] PLATFORM: watchdog-max-timeout [31536000000 ms]
[    0.000000] PLATFORM: max-cpus [1024]
[    0.000000] Top of RAM: 0x82f93a000, Total RAM: 0x7ff350000
[    0.000000] Memory hole size: 773MB
[    0.000000] Allocated 24576 bytes for kernel page tables.
[    0.000000] Zone ranges:
[    0.000000]   Normal   [mem 0x0000000030400000-0x000000082f939fff]
[    0.000000] Movable zone start for each node
[    0.000000] Early memory node ranges
[    0.000000]   node   0: [mem 0x0000000030400000-0x000000006fe7ffff]
[    0.000000]   node   0: [mem 0x000000006ff00000-0x000000006ff25fff]
[    0.000000]   node   0: [mem 0x0000000070000000-0x000000082f87ffff]
[    0.000000]   node   0: [mem 0x000000082f900000-0x000000082f921fff]
[    0.000000]   node   0: [mem 0x000000082f932000-0x000000082f939fff]
[    0.000000] Initmem setup node 0 [mem 0x0000000030400000-0x000000082f939fff]
[    0.000000] Booting Linux...
[    0.000000] CPU CAPS: [flush,stbar,swap,muldiv,v9,blkinit,n2,mul32]
[    0.000000] CPU CAPS: [div32,v8plus,popc,vis,vis2,ASIBlkInit,fmaf,vis3]
[    0.000000] CPU CAPS: [hpc,ima,pause,cbcond,aes,des,kasumi,camellia]
[    0.000000] CPU CAPS: [md5,sha1,sha256,sha512,mpmul,montmul,montsqr,crc32c]
[    0.000000] percpu: Embedded 11 pages/cpu @fff800082d000000 s46024
r8192 d35896 u131072
[    0.000000] SUN4V: Mondo queue sizes [cpu(131072) dev(16384) r(8192) nr(256)]
[    0.000000] Built 1 zonelists in Zone order, mobility grouping on.
Total pages: 4155828
[    0.000000] Kernel command line: root=/dev/vdiska2 ro
zswap.enabled=1 keep_bootcon noresume
[    0.000000] log_buf_len individual max cpu contribution: 4096 bytes
[    0.000000] log_buf_len total cpu_extra contributions: 1044480 bytes
[    0.000000] log_buf_len min size: 131072 bytes
[    0.000000] log_buf_len: 2097152 bytes
[    0.000000] early log buf free: 126208(96%)
[    0.000000] PID hash table entries: 4096 (order: 2, 32768 bytes)
[    0.000000] Dentry cache hash table entries: 4194304 (order: 12,
33554432 bytes)
[    0.000000] Inode-cache hash table entries: 2097152 (order: 11,
16777216 bytes)
[    0.000000] Sorting __ex_table...
[    0.000000] Memory: 33114224K/33541440K available (6603K kernel
code, 894K rwdata, 1824K rodata, 608K init, 9985K bss, 427216K
reserved, 0K cma-reserved)
[    0.000000] Running RCU self tests
[    0.000000] Hierarchical RCU implementation.
[    0.000000]  RCU lockdep checking is enabled.
[    0.000000]  Build-time adjustment of leaf fanout to 64.
[    0.000000] NR_IRQS:2048 nr_irqs:2048 1
[    0.000000] SUN4V: Using IRQ API major 3, cookie only virqs enabled
[11059882.082988] clocksource: stick: mask: 0xffffffffffffffff
max_cycles: 0x1cd42e4dffb, max_idle_ns: 881590591483 ns
[11059882.083097] clocksource: mult[800000] shift[23]
[11059882.083148] clockevent: mult[80000000] shift[31]
[11059882.085633] Console: colour dummy device 80x25
[11059882.085696] console [tty0] enabled
[11059882.085740] Lock dependency validator: Copyright (c) 2006 Red
Hat, Inc., Ingo Molnar
[11059882.085819] ... MAX_LOCKDEP_SUBCLASSES:  8
[11059882.085866] ... MAX_LOCK_DEPTH:          48
[11059882.085912] ... MAX_LOCKDEP_KEYS:        8191
[11059882.085962] ... CLASSHASH_SIZE:          4096
[11059882.086011] ... MAX_LOCKDEP_ENTRIES:     16384
[11059882.086061] ... MAX_LOCKDEP_CHAINS:      32768
[11059882.086110] ... CHAINHASH_SIZE:          16384
[11059882.086160]  memory used by lock dependency info: 5855 kB
[11059882.086221]  per task-struct memory footprint: 1920 bytes
[11059882.086971] kmemleak: Early log buffer exceeded (26295), please
increase DEBUG_KMEMLEAK_EARLY_LOG_SIZE
[11059884.094525] Calibrating delay using timer specific routine..
2006.23 BogoMIPS (lpj=4012467)
[11059884.094652] pid_max: default: 262144 minimum: 2048
[11059884.095661] Security Framework initialized
[11059884.095713] Yama: becoming mindful.
[11059884.095776] AppArmor: AppArmor disabled by boot time parameter
[11059884.096179] Mount-cache hash table entries: 65536 (order: 6, 524288 bytes)
[11059884.096261] Mountpoint-cache hash table entries: 65536 (order:
6, 524288 bytes)
[11059884.098289] ftrace: allocating 19365 entries in 38 pages
[11059884.119485] smp: Bringing up secondary CPUs ...
[11059884.173617] smp: Brought up 1 node, 32 CPUs
[11059884.179296] devtmpfs: initialized
[11059884.185352] Performance events:
[11059884.185387] Testing NMI watchdog ...
[11059884.265513] OK.
[11059884.265632] Supported PMU type is 'niagara5'
[11059884.299456] ldc.c:v1.1 (July 22, 2008)
[11059884.301371] clocksource: jiffies: mask: 0xffffffff max_cycles:
0xffffffff, max_idle_ns: 7645041785100000 ns
[11059884.306042] NET: Registered protocol family 16
[11059884.316862] VIO: Adding device channel-devices
[11059884.317163] VIO: Adding device vnet-port-0-0
[11059884.317437] VIO: Adding device vnet-port-0-1
[11059884.317694] VIO: Adding device vnet-port-0-2
[11059884.317961] VIO: Adding device vnet-port-0-3
[11059884.318852] VIO: Adding device vnet-port-0-4
[11059884.319757] VIO: Adding device vdc-port-0-0
[11059884.320640] VIO: Adding device vdc-port-1-0
[11059884.321523] VIO: Adding device vdc-port-2-0
[11059884.322420] VIO: Adding device vdc-port-3-0
[11059884.323303] VIO: Adding device vlds-port-0-0
[11059884.324207] VIO: Adding device ds-0
[11059884.393536] HugeTLB registered 8 MB page size, pre-allocated 0 pages
[11059884.403418] vgaarb: loaded
[11059884.407260] SUN4V: Reboot data supported (maj=1,min=0).
[11059884.407477] ds.c:v1.0 (Jul 11, 2007)
[11059884.407815] ds-0: ds_conn_reset() from send_events
[11059884.407968] ds-0: Registered md-update service.
[11059884.408021] ds-0: Registered domain-shutdown service.
[11059884.408090] ds-0: Registered domain-panic service.
[11059884.408155] ds-0: Registered dr-cpu service.
[11059884.408211] ds-0: Registered pri service.
[11059884.408266] ds-0: Registered var-config service.
[11059884.408413] clocksource: Switched to clocksource stick
[11059884.509681] VFS: Disk quotas dquot_6.6.0
[11059884.511529] VFS: Dquot-cache hash table entries: 1024 (order 0,
8192 bytes)
[11059884.531075] NET: Registered protocol family 2
[11059884.538440] TCP established hash table entries: 262144 (order:
8, 2097152 bytes)
[11059884.539519] TCP bind hash table entries: 65536 (order: 9, 4194304 bytes)
[11059884.550419] TCP: Hash tables configured (established 262144 bind 65536)
[11059884.550753] UDP hash table entries: 16384 (order: 8, 2621440 bytes)
[11059884.557183] UDP-Lite hash table entries: 16384 (order: 8, 2621440 bytes)
[11059884.568838] NET: Registered protocol family 1
[11059884.569346] Unpacking initramfs...
[11059884.902162] Freeing initrd memory: 13672K
[11059884.944211] futex hash table entries: 65536 (order: 10, 8388608 bytes)
[11059884.955799] audit: initializing netlink subsys (disabled)
[11059884.956191] audit: type=2000 audit(0.936:1): initialized
[11059884.958931] workingset: timestamp_bits=46 max_order=22 bucket_order=0
[11059884.960142] zbud: loaded
[11059884.979364] Unable to handle kernel paging request at virtual
address 000612000001c000
[11059884.979448] tsk->{mm,active_mm}->context = 0000000000000000
[11059884.979502] tsk->{mm,active_mm}->pgd = fff8000070002000
[11059884.979555]               \|/ ____ \|/
[11059884.979555]               "@'/ .. \`@"
[11059884.979555]               /_| \__/ |_\
[11059884.979555]                  \__U_/
[11059884.979695] cryptomgr_test(229): Oops [#1]
[11059884.979743] CPU: 27 PID: 229 Comm: cryptomgr_test Not tainted 4.9.0+ #38
[11059884.979808] task: fff800080c42c040 task.stack: fff8000808c74000
[11059884.979866] TSTATE: 0000009980001602 TPC: 0000000000745208 TNPC:
000000000074520c Y: 000000d1    Not tainted
[11059884.979966] TPC: <scatterwalk_copychunks+0xa8/0x1e0>
[11059884.980015] g0: 0000000000000000 g1: 000612000001cc20 g2:
00000000000000b8 g3: 0000000000000002
[11059884.980096] g4: fff800080c42c040 g5: fff800082c5ac000 g6:
fff8000808c74000 g7: 0000000000001b00
[11059884.980177] o0: fff8000808c77b08 o1: 00000001003a4000 o2:
0000000000000046 o3: 00000000024002c0
[11059884.980258] o4: fff8000030404920 o5: 0000000000cdec00 sp:
fff8000808c76f11 ret_pc: 0000000000000000
[11059884.980341] RPC: <          (null)>
[11059884.980405] l0: 0000000000001fff l1: 0000000000000000 l2:
0000000000baddf0 l3: 00000000000011e8
[11059884.980492] l4: 00000fff00000000 l5: 0006000000000000 l6:
0000000000d0afc0 l7: 0000000000dc13c8
[11059884.980573] i0: 00000001003a4000 i1: fff8000808c77870 i2:
0000000000000046 i3: 0000000000000000
[11059884.980651] i4: 0000000000000046 i5: 0000000000000046 i6:
fff8000808c76fc1 i7: 000000000074537c
[11059884.980734] I7: <scatterwalk_map_and_copy+0x3c/0xc0>
[11059884.980784] Call Trace:
[11059884.980814]  [000000000074537c] scatterwalk_map_and_copy+0x3c/0xc0
[11059884.980879]  [000000000074ba94] scomp_acomp_comp_decomp+0xb4/0x260
[11059884.980940]  [000000000074bc70] scomp_acomp_compress+0x10/0x20
[11059884.981000]  [0000000000751080] test_acomp+0x160/0x4c0
[11059884.981052]  [0000000000751474] alg_test_comp+0x94/0x100
[11059884.981104]  [000000000074f6fc] alg_test+0x15c/0x300
[11059884.981157]  [000000000074c748] cryptomgr_test+0x48/0x60
[11059884.982214]  [00000000004927cc] kthread+0xec/0x140
[11059884.982265]  [0000000000406084] ret_from_fork+0x1c/0x2c
[11059884.982317]  [0000000000000000]           (null)
[11059884.982364] Disabling lock debugging due to kernel taint
[11059884.982416] Caller[000000000074537c]: scatterwalk_map_and_copy+0x3c/0xc0
[11059884.982479] Caller[000000000074ba94]: scomp_acomp_comp_decomp+0xb4/0x260
[11059884.982544] Caller[000000000074bc70]: scomp_acomp_compress+0x10/0x20
[11059884.982606] Caller[0000000000751080]: test_acomp+0x160/0x4c0
[11059884.982661] Caller[0000000000751474]: alg_test_comp+0x94/0x100
[11059884.982717] Caller[000000000074f6fc]: alg_test+0x15c/0x300
[11059884.982773] Caller[000000000074c748]: cryptomgr_test+0x48/0x60
[11059884.982829] Caller[00000000004927cc]: kthread+0xec/0x140
[11059884.982881] Caller[0000000000406084]: ret_from_fork+0x1c/0x2c
[11059884.982937] Caller[0000000000000000]:           (null)
[11059884.982987] Instruction DUMP:
[11059884.982989]  c4066008
[11059884.983021]  92100018
[11059884.983050]  9410001c
[11059884.983079] <d0586040>
[11059884.983106]  82088010
[11059884.983135]  90020001
[11059884.983162]  937ec408
[11059884.983190]  40019e7a
[11059884.983219]  917ec418
[11059884.983247]
[11059884.983298] note: cryptomgr_test[229] exited with preempt_count 2
