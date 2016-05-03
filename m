From: Anatoly Pugachev <matorola@gmail.com>
Subject: [crypto / sparc64] cryptomgr_test OOPS
Date: Tue, 3 May 2016 16:54:18 +0300
Message-ID: <CADxRZqyMwme53etMrnx3xkpGsR6-W88RHLA3nh0GCGAzcz5=Fw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Cc: sparclinux@vger.kernel.org
To: linux-crypto@vger.kernel.org
Return-path: <sparclinux-owner@vger.kernel.org>
Sender: sparclinux-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

Hello!

I have git kernel OOPS (4.6.0-rc6) on sparc64. This OOPS does not
happen, if I set the following kernel option:

CONFIG_CRYPTO_MANAGER_DISABLE_TESTS=y

Can someone please look at https://bugzilla.kernel.org/show_bug.cgi?id=117551 ?

Thanks.

There's attached kernel config on bugzilla.

kernel OOPS:


SPARC Enterprise T5120, No Keyboard
Copyright (c) 1998, 2014, Oracle and/or its affiliates. All rights reserved.
OpenBoot 4.33.6.f, 16256 MB memory available, Serial #78400024.
Ethernet address 0:14:4f:ac:4a:18, Host ID: 84ac4a18.



Boot device: disk1  File and args:
SILO Version 1.4.14
boot:
Linux                    LinuxOLD                 6
boot: 6
Allocated 64 Megs of memory at 0x40000000 for kernel
Uncompressing image...
Loaded kernel version 4.6.0
Loading initial ramdisk (14627617 bytes at 0xC800000 phys, 0x40C00000 virt)...
/
[    0.000000] PROMLIB: Sun IEEE Boot Prom 'OBP 4.33.6.f 2014/07/10 10:23'
[    0.000000] PROMLIB: Root node compatible: sun4v
[    0.000000] Linux version 4.6.0-rc6+ (mator@deb4g) (gcc version
6.0.1 20160423 (prerelease) (Debian 6.0.1-2) ) #1 SMP Tue May 3
13:49:36 MSK 2016
[    0.000000] debug: skip boot console de-registration.
[    0.000000] bootconsole [earlyprom0] enabled
[    0.000000] ARCH: SUN4V
[    0.000000] Ethernet address: 00:14:4f:ac:4a:18
[    0.000000] MM: PAGE_OFFSET is 0xffff800000000000 (max_phys_bits == 39)
[    0.000000] MM: VMALLOC [0x0000000100000000 --> 0x0000600000000000]
[    0.000000] MM: VMEMMAP [0x0000600000000000 --> 0x0000c00000000000]
[    0.000000] Kernel: Using 3 locked TLB entries for main kernel image.
[    0.000000] Remapping the kernel... done.
[    0.000000] OF stdout device is: /virtual-devices@100/console@1
[    0.000000] PROM: Built device tree with 195069 bytes of memory.
[    0.000000] MDESC: Size is 61728 bytes.
[    0.000000] PLATFORM: banner-name [SPARC Enterprise T5120]
[    0.000000] PLATFORM: name [SUNW,SPARC-Enterprise-T5120]
[    0.000000] PLATFORM: hostid [84ac4a18]
[    0.000000] PLATFORM: serial# [00ab4130]
[    0.000000] PLATFORM: stick-frequency [457646c0]
[    0.000000] PLATFORM: mac-address [144fac4a18]
[    0.000000] PLATFORM: watchdog-resolution [1000 ms]
[    0.000000] PLATFORM: watchdog-max-timeout [31536000000 ms]
[    0.000000] PLATFORM: max-cpus [64]
[    0.000000] Top of RAM: 0x3ffb16000, Total RAM: 0x3f76ac000
[    0.000000] Memory hole size: 132MB
[    0.000000] Allocated 16384 bytes for kernel page tables.
[    0.000000] Zone ranges:
[    0.000000]   Normal   [mem 0x0000000008400000-0x00000003ffb15fff]
[    0.000000] Movable zone start for each node
[    0.000000] Early memory node ranges
[    0.000000]   node   0: [mem 0x0000000008400000-0x00000003ffa89fff]
[    0.000000]   node   0: [mem 0x00000003ffa9a000-0x00000003ffaadfff]
[    0.000000]   node   0: [mem 0x00000003ffb08000-0x00000003ffb15fff]
[    0.000000] Initmem setup node 0 [mem 0x0000000008400000-0x00000003ffb15fff]
[    0.000000] Booting Linux...
[    0.000000] CPU CAPS: [flush,stbar,swap,muldiv,v9,blkinit,n2,mul32]
[    0.000000] CPU CAPS: [div32,v8plus,popc,vis,vis2,ASIBlkInit]
[    0.000000] percpu: Embedded 9 pages/cpu @ffff8003ff000000 s29528
r8192 d36008 u131072
[    0.000000] SUN4V: Mondo queue sizes [cpu(8192) dev(16384) r(8192) nr(256)]
[    0.000000] Built 1 zonelists in Zone order, mobility grouping on.
Total pages: 2061296
[    0.000000] Kernel command line: root=/dev/mapper/vg1-root ro
keep_bootcon console=ttyS0
[    0.000000] log_buf_len individual max cpu contribution: 4096 bytes
[    0.000000] log_buf_len total cpu_extra contributions: 258048 bytes
[    0.000000] log_buf_len min size: 131072 bytes
[    0.000000] log_buf_len: 524288 bytes
[    0.000000] early log buf free: 127592(97%)
[    0.000000] PID hash table entries: 4096 (order: 2, 32768 bytes)
[    0.000000] Dentry cache hash table entries: 2097152 (order: 11,
16777216 bytes)
[    0.000000] Inode-cache hash table entries: 1048576 (order: 10,
8388608 bytes)
[    0.000000] Sorting __ex_table...
[    0.000000] Memory: 16433448K/16636592K available (5565K kernel
code, 733K rwdata, 1392K rodata, 456K init, 742K bss, 203144K
reserved, 0K cma-reserved)
[    0.000000] Hierarchical RCU implementation.
[    0.000000]  Build-time adjustment of leaf fanout to 64.
[    0.000000]  RCU restricting CPUs from NR_CPUS=256 to nr_cpu_ids=64.
[    0.000000] RCU: Adjusting geometry for rcu_fanout_leaf=64, nr_cpu_ids=64
[    0.000000] NR_IRQS:2048 nr_irqs:2048 1
[    0.000000] SUN4V: Using IRQ API major 1, cookie only virqs disabled
[ 7218.283063] clocksource: stick: mask: 0xffffffffffffffff
max_cycles: 0x10cc5ac4c8a, max_idle_ns: 440795218862 ns
[ 7218.283875] clocksource: mult[dbabc5] shift[24]
[ 7218.284206] clockevent: mult[952b25d1] shift[31]
[ 7218.286792] Console: colour dummy device 80x25
[ 7218.364903] Calibrating delay using timer specific routine..
2337.22 BogoMIPS (lpj=4674457)
[ 7218.365869] pid_max: default: 65536 minimum: 512
[ 7218.367733] Security Framework initialized
[ 7218.368387] Yama: becoming mindful.
[ 7218.369633] AppArmor: AppArmor disabled by boot time parameter
[ 7218.370843] Mount-cache hash table entries: 32768 (order: 5, 262144 bytes)
[ 7218.372659] Mountpoint-cache hash table entries: 32768 (order: 5,
262144 bytes)
[ 7218.377060] ftrace: allocating 18467 entries in 37 pages
[ 7218.491669] Brought up 64 CPUs
[ 7218.501017] devtmpfs: initialized
[ 7218.512380] Performance events:
[ 7218.513039] Testing NMI watchdog ... OK.
[ 7218.594081] Supported PMU type is 'niagara2'
[ 7218.632340] ldc.c:v1.1 (July 22, 2008)
[ 7218.633966] clocksource: jiffies: mask: 0xffffffff max_cycles:
0xffffffff, max_idle_ns: 7645041785100000 ns
[ 7218.637279] NET: Registered protocol family 16
[ 7218.662264] VIO: Adding device channel-devices
[ 7218.663207] VIO: Adding device vlds-port-0-0
[ 7218.663753] VIO: Adding device vldc-port-3-0
[ 7218.664311] VIO: Adding device vldc-port-3-1
[ 7218.664857] VIO: Adding device vldc-port-3-2
[ 7218.665415] VIO: Adding device vldc-port-3-3
[ 7218.665982] VIO: Adding device vldc-port-3-4
[ 7218.666530] VIO: Adding device vldc-port-3-5
[ 7218.667347] VIO: Adding device vldc-port-2-0
[ 7218.667917] VIO: Adding device vldc-port-0-0
[ 7218.668745] VIO: Adding device vldc-port-0-1
[ 7218.669829] VIO: Adding device vldc-port-0-2
[ 7218.671328] VIO: Adding device vldc-port-1-0
[ 7218.672168] VIO: Adding device vldc-port-3-7
[ 7218.673495] VIO: Adding device vldc-port-3-8
[ 7218.674065] VIO: Adding device ds-1
[ 7218.674596] VIO: Adding device ds-0
[ 7218.692674] pci_sun4v: Registered hvapi major[1] minor[0]
[ 7218.693713] /pci@0: SUN4V PCI Bus Module
[ 7218.694017] /pci@0: On NUMA node -1
[ 7218.694302] /pci@0: PCI IO[c0f0000000] MEM[c100000000] MEM64[c200000000]
[ 7218.694846] /pci@0: Unable to request IOMMU resource.
[ 7218.744155] /pci@0: Imported 3 TSB entries from OBP
[ 7218.748187] /pci@0: MSI Queue first[0] num[36] count[128] devino[0x18]
[ 7218.748680] /pci@0: MSI first[0] num[256] mask[0xff] width[32]
[ 7218.749144] /pci@0: MSI addr32[0x7fff0000:0x10000]
addr64[0x3ffff0000:0x10000]
[ 7218.749696] /pci@0: MSI queues at RA [00000003f1e00000]
[ 7218.750157] PCI: Scanning PBM /pci@0
[ 7218.750786] pci_sun4v f028ca10: PCI host bridge to bus 0000:02
[ 7218.751347] pci_bus 0000:02: root bus resource [io
0xc0f0000000-0xc0ffffffff] (bus address [0x0000-0xfffffff])
[ 7218.752160] pci_bus 0000:02: root bus resource [mem
0xc100000000-0xc17ffeffff] (bus address [0x00000000-0x7ffeffff])
[ 7218.753086] pci_bus 0000:02: root bus resource [mem
0xc200000000-0xc3fffeffff] (bus address [0x100000000-0x2fffeffff])
[ 7218.753888] pci_bus 0000:02: root bus resource [bus 02-12]
[ 7218.793314] HugeTLB registered 8 MB page size, pre-allocated 0 pages
[ 7218.798204] vgaarb: loaded
[ 7218.801710] SUN4V: Reboot data supported (maj=1,min=0).
[ 7218.802613] ds.c:v1.0 (Jul 11, 2007)
[ 7218.804525] clocksource: Switched to clocksource stick
[ 7218.826813] ds-1: Registered pri service.
[ 7218.831038] ds-1: Registered var-config-backup service.
[ 7218.861476] VFS: Disk quotas dquot_6.6.0
[ 7218.862524] VFS: Dquot-cache hash table entries: 1024 (order 0, 8192 bytes)
[ 7218.880853] NET: Registered protocol family 2
[ 7218.883989] TCP established hash table entries: 131072 (order: 7,
1048576 bytes)
[ 7218.888309] TCP bind hash table entries: 65536 (order: 7, 1048576 bytes)
[ 7218.893181] TCP: Hash tables configured (established 131072 bind 65536)
[ 7218.894190] UDP hash table entries: 8192 (order: 5, 262144 bytes)
[ 7218.895694] UDP-Lite hash table entries: 8192 (order: 5, 262144 bytes)
[ 7218.898883] NET: Registered protocol family 1
[ 7219.009101] Unpacking initramfs...
[ 7220.326000] Freeing initrd memory: 14280K (ffff80000c800000 -
ffff80000d5f2000)
[ 7220.339774] futex hash table entries: 16384 (order: 7, 1048576 bytes)
[ 7220.340944] audit: initializing netlink subsys (disabled)
[ 7220.341448] audit: type=2000 audit(1.971:1): initialized
[ 7220.342562] Initialise system trusted keyring
[ 7220.344050] workingset: timestamp_bits=45 max_order=21 bucket_order=0
[ 7220.344704] zbud: loaded
[ 7220.346807] Unable to handle kernel paging request at virtual
address 0000612000016000
[ 7220.347392] tsk->{mm,active_mm}->context = 0000000000000000
[ 7220.347800] tsk->{mm,active_mm}->pgd = ffff800008802000
[ 7220.348185]               \|/ ____ \|/
[ 7220.348185]               "@'/ .. \`@"
[ 7220.348185]               /_| \__/ |_\
[ 7220.348185]                  \__U_/
[ 7220.349273] cryptomgr_test(412): Oops [#1]
[ 7220.349595] CPU: 45 PID: 412 Comm: cryptomgr_test Not tainted 4.6.0-rc6+ #1
[ 7220.350102] task: ffff8003ee232b80 ti: ffff8003ee254000 task.ti:
ffff8003ee254000
[ 7220.350651] TSTATE: 0000000080001600 TPC: 000000000073d530 TNPC:
000000000073d534 Y: 00000000    Not tainted
[ 7220.351363] TPC: <mpi_read_raw_from_sgl+0x30/0x2c0>
[ 7220.351729] g0: 0000000000000000 g1: 0000612000017658 g2:
0000000000000002 g3: 0000000000000068
[ 7220.352355] g4: ffff8003ee232b80 g5: ffff8003fe9a4000 g6:
ffff8003ee254000 g7: 0000000000000008
[ 7220.352995] o0: 0000000000000002 o1: 00000000024000c0 o2:
0000000000000020 o3: ffff8000084020c0
[ 7220.353624] o4: ffff8003ee2128e0 o5: 0000000000000480 sp:
ffff8003ee257091 ret_pc: 000000000073d508
[ 7220.354280] RPC: <mpi_read_raw_from_sgl+0x8/0x2c0>
[ 7220.354641] l0: 0000000000000002 l1: 00000000024000c0 l2:
ffff800008404208 l3: 0000000040000000
[ 7220.355268] l4: ffff800008404218 l5: 0000600008de6d90 l6:
ffffffffffffffff l7: ffff8003ff5ab688
[ 7220.355894] i0: ffff8003ee257b10 i1: 0000000000000008 i2:
ffff8003ee257b10 i3: ffff8003ee257ad0
[ 7220.356508] i4: 0000000000000000 i5: 0000000000000000 i6:
ffff8003ee257141 i7: 00000000006bb7a0
[ 7220.357165] I7: <rsa_enc+0x40/0xc0>
[ 7220.357438] Call Trace:
[ 7220.357639]  [00000000006bb7a0] rsa_enc+0x40/0xc0
[ 7220.357998]  [00000000006c08c0] do_test_rsa+0x1e0/0x440
[ 7220.358388]  [00000000006c0ba0] alg_test_akcipher+0x80/0x100
[ 7220.358819]  [00000000006c01a8] alg_test+0x188/0x3c0
[ 7220.359191]  [00000000006bd3e8] cryptomgr_test+0x48/0x60
[ 7220.359593]  [000000000048716c] kthread+0xac/0xe0
[ 7220.359957]  [00000000004060a4] ret_from_fork+0x1c/0x2c
[ 7220.360343]  [0000000000000000]           (null)
[ 7220.360687] Disabling lock debugging due to kernel taint
[ 7220.361113] Caller[00000000006bb7a0]: rsa_enc+0x40/0xc0
[ 7220.361512] Caller[00000000006c08c0]: do_test_rsa+0x1e0/0x440
[ 7220.361937] Caller[00000000006c0ba0]: alg_test_akcipher+0x80/0x100
[ 7220.362389] Caller[00000000006c01a8]: alg_test+0x188/0x3c0
[ 7220.362796] Caller[00000000006bd3e8]: cryptomgr_test+0x48/0x60
[ 7220.363240] Caller[000000000048716c]: kthread+0xac/0xe0
[ 7220.363634] Caller[00000000004060a4]: ret_from_fork+0x1c/0x2c
[ 7220.364054] Caller[0000000000000000]:           (null)
[ 7220.364431] Instruction DUMP: c606a008  82087ffc  ce06a00c
<c2586040> 80a1e000  02400010  84004003  c2084003  80a06000
