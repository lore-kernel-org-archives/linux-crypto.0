From: Anatoly Pugachev <matorola@gmail.com>
Subject: Re: booting sun sparc T5120 with "nosmp" kernel causes OOPS in
 n2_crypto module
Date: Wed, 25 May 2016 23:45:53 +0300
Message-ID: <20160525204552.GA21792@yogzotot>
References: <CADxRZqyKYV=Y7P24uj-moc11qhd6To=i2jkXEu36=7vYFTvRqA@mail.gmail.com>
 <CADxRZqy0ftpM+QrEDHoXL7AAW383ae5OWOqR2Ts2sEB+oS8YRQ@mail.gmail.com>
 <CADxRZqysyGptB1FhuuC6qw7+4dAOp=9wSVPOtnPS5cDrm2ZOZg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: debian-sparc <debian-sparc@lists.debian.org>,
	linux-crypto@vger.kernel.org
To: sparclinux@vger.kernel.org
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from u164.east.ru ([195.170.63.164]:54922 "EHLO u164.east.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751110AbcEYUwu (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Wed, 25 May 2016 16:52:50 -0400
Content-Disposition: inline
In-Reply-To: <CADxRZqysyGptB1FhuuC6qw7+4dAOp=9wSVPOtnPS5cDrm2ZOZg@mail.gmail.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

tried to boot git kernel ( 4.6.0+ , git commit
ecc5fbd5ef472a4c659dc56a5739b3f041c0530c ) with "nosmp" , got n2_crypto OOPS
as well ext4 OOPS (unable to finish boot , mount / fs) , boot log :




SPARC Enterprise T5120, No Keyboard
Copyright (c) 1998, 2016, Oracle and/or its affiliates. All rights reserved.
OpenBoot 4.33.6.g, 16256 MB memory available, Serial #78400024.
Ethernet address 0:14:4f:ac:4a:18, Host ID: 84ac4a18.



Boot device: disk1  File and args: 
SILO Version 1.4.14
boot: 6
Allocated 64 Megs of memory at 0x40000000 for kernel
Uncompressing image...
Loaded kernel version 4.6.0
Loading initial ramdisk (17830856 bytes at 0xC800000 phys, 0x40C00000 virt)...
|
[    0.000000] PROMLIB: Sun IEEE Boot Prom 'OBP 4.33.6.g 2016/03/11 06:05'
[    0.000000] PROMLIB: Root node compatible: sun4v
[    0.000000] Linux version 4.6.0+ (mator@nvg5120) (gcc version 5.3.1 20160509 (Debian 5.3.1-19) ) #1 SMP Wed May 25 22:17:28 MSK 2016
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
[    0.000000] percpu: Embedded 10 pages/cpu @ffff8003ff000000 s37720 r8192 d36008 u131072
[    0.000000] SUN4V: Mondo queue sizes [cpu(8192) dev(16384) r(8192) nr(256)]
[    0.000000] Built 1 zonelists in Zone order, mobility grouping on.  Total pages: 2061296
[    0.000000] Kernel command line: root=/dev/mapper/vg1-root ro nosmp
[    0.000000] log_buf_len individual max cpu contribution: 4096 bytes
[    0.000000] log_buf_len total cpu_extra contributions: 258048 bytes
[    0.000000] log_buf_len min size: 131072 bytes
[    0.000000] log_buf_len: 524288 bytes
[    0.000000] early log buf free: 127696(97%)
[    0.000000] PID hash table entries: 4096 (order: 2, 32768 bytes)
[    0.000000] Dentry cache hash table entries: 2097152 (order: 11, 16777216 bytes)
[    0.000000] Inode-cache hash table entries: 1048576 (order: 10, 8388608 bytes)
[    0.000000] Sorting __ex_table...
[    0.000000] Memory: 16429712K/16636592K available (5626K kernel code, 737K rwdata, 1408K rodata, 464K init, 750K bss, 206880K reserved, 0K cma-reserved)
[    0.000000] Hierarchical RCU implementation.
[    0.000000]  Build-time adjustment of leaf fanout to 64.
[    0.000000]  RCU restricting CPUs from NR_CPUS=256 to nr_cpu_ids=64.
[    0.000000] RCU: Adjusting geometry for rcu_fanout_leaf=64, nr_cpu_ids=64
[    0.000000] NR_IRQS:2048 nr_irqs:2048 1
[    0.000000] SUN4V: Using IRQ API major 1, cookie only virqs disabled
[1319829.255759] clocksource: stick: mask: 0xffffffffffffffff max_cycles: 0x10cc5ac4c8a, max_idle_ns: 440795218862 ns
[1319829.257796] clocksource: mult[dbabc5] shift[24]
[1319829.258492] clockevent: mult[952b25d1] shift[31]
[1319829.261610] Console: colour dummy device 80x25
[1319829.262298] console [tty0] enabled
[1319829.262589] bootconsole [earlyprom0] disabled
[    0.000000] PROMLIB: Sun IEEE Boot Prom 'OBP 4.33.6.g 2016/03/11 06:05'
[    0.000000] PROMLIB: Root node compatible: sun4v
[    0.000000] Linux version 4.6.0+ (mator@nvg5120) (gcc version 5.3.1 20160509 (Debian 5.3.1-19) ) #1 SMP Wed May 25 22:17:28 MSK 2016
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
[    0.000000] percpu: Embedded 10 pages/cpu @ffff8003ff000000 s37720 r8192 d36008 u131072
[    0.000000] SUN4V: Mondo queue sizes [cpu(8192) dev(16384) r(8192) nr(256)]
[    0.000000] Built 1 zonelists in Zone order, mobility grouping on.  Total pages: 2061296
[    0.000000] Kernel command line: root=/dev/mapper/vg1-root ro nosmp
[    0.000000] log_buf_len individual max cpu contribution: 4096 bytes
[    0.000000] log_buf_len total cpu_extra contributions: 258048 bytes
[    0.000000] log_buf_len min size: 131072 bytes
[    0.000000] log_buf_len: 524288 bytes
[    0.000000] early log buf free: 127696(97%)
[    0.000000] PID hash table entries: 4096 (order: 2, 32768 bytes)
[    0.000000] Dentry cache hash table entries: 2097152 (order: 11, 16777216 bytes)
[    0.000000] Inode-cache hash table entries: 1048576 (order: 10, 8388608 bytes)
[    0.000000] Sorting __ex_table...
[    0.000000] Memory: 16429712K/16636592K available (5626K kernel code, 737K rwdata, 1408K rodata, 464K init, 750K bss, 206880K reserved, 0K cma-reserved)
[    0.000000] Hierarchical RCU implementation.
[    0.000000]  Build-time adjustment of leaf fanout to 64.
[    0.000000]  RCU restricting CPUs from NR_CPUS=256 to nr_cpu_ids=64.
[    0.000000] RCU: Adjusting geometry for rcu_fanout_leaf=64, nr_cpu_ids=64
[    0.000000] NR_IRQS:2048 nr_irqs:2048 1
[    0.000000] SUN4V: Using IRQ API major 1, cookie only virqs disabled
[1319829.255759] clocksource: stick: mask: 0xffffffffffffffff max_cycles: 0x10cc5ac4c8a, max_idle_ns: 440795218862 ns
[1319829.257796] clocksource: mult[dbabc5] shift[24]
[1319829.258492] clockevent: mult[952b25d1] shift[31]
[1319829.261610] Console: colour dummy device 80x25
[1319829.262298] console [tty0] enabled
[1319829.262589] bootconsole [earlyprom0] disabled
[1319829.366765] Calibrating delay using timer specific routine.. 2337.59 BogoMIPS (lpj=4675187)
[1319829.366801] pid_max: default: 65536 minimum: 512
[1319829.367866] Security Framework initialized
[1319829.367892] Yama: becoming mindful.
[1319829.367930] AppArmor: AppArmor disabled by boot time parameter
[1319829.368308] Mount-cache hash table entries: 32768 (order: 5, 262144 bytes)
[1319829.368342] Mountpoint-cache hash table entries: 32768 (order: 5, 262144 bytes)
[1319829.371820] ftrace: allocating 18685 entries in 37 pages
[1319829.413112] Brought up 1 CPUs
[1319829.415936] devtmpfs: initialized
[1319829.426597] Performance events: 
[1319829.426624] Testing NMI watchdog ... OK.
[1319829.506678] Supported PMU type is 'niagara2'
[1319829.507258] ldc.c:v1.1 (July 22, 2008)
[1319829.507731] clocksource: jiffies: mask: 0xffffffff max_cycles: 0xffffffff, max_idle_ns: 7645041785100000 ns
[1319829.509329] NET: Registered protocol family 16
[1319829.534127] VIO: Adding device channel-devices
[1319829.534404] VIO: Adding device vlds-port-0-0
[1319829.534644] VIO: Adding device vldc-port-3-0
[1319829.534890] VIO: Adding device vldc-port-3-1
[1319829.535155] VIO: Adding device vldc-port-3-2
[1319829.535436] VIO: Adding device vldc-port-3-3
[1319829.535699] VIO: Adding device vldc-port-3-4
[1319829.535973] VIO: Adding device vldc-port-3-5
[1319829.536234] VIO: Adding device vldc-port-2-0
[1319829.536514] VIO: Adding device vldc-port-0-0
[1319829.536776] VIO: Adding device vldc-port-0-1
[1319829.537057] VIO: Adding device vldc-port-0-2
[1319829.537318] VIO: Adding device vldc-port-1-0
[1319829.537580] VIO: Adding device vldc-port-3-7
[1319829.537846] VIO: Adding device vldc-port-3-8
[1319829.538137] VIO: Adding device ds-1
[1319829.538394] VIO: Adding device ds-0
[1319829.553352] pci_sun4v: Registered hvapi major[1] minor[0]
[1319829.553681] /pci@0: SUN4V PCI Bus Module
[1319829.553719] /pci@0: On NUMA node -1
[1319829.553756] /pci@0: PCI IO[c0f0000000] MEM[c100000000] MEM64[c200000000]
[1319829.553808] /pci@0: Unable to request IOMMU resource.
[1319829.603437] /pci@0: Imported 3 TSB entries from OBP
[1319829.606750] /pci@0: MSI Queue first[0] num[36] count[128] devino[0x18]
[1319829.606796] /pci@0: MSI first[0] num[256] mask[0xff] width[32]
[1319829.606835] /pci@0: MSI addr32[0x7fff0000:0x10000] addr64[0x3ffff0000:0x10000]
[1319829.606891] /pci@0: MSI queues at RA [00000003fce80000]
[1319829.606930] PCI: Scanning PBM /pci@0
[1319829.607266] pci_sun4v f028ca10: PCI host bridge to bus 0000:02
[1319829.607322] pci_bus 0000:02: root bus resource [io  0xc0f0000000-0xc0ffffffff] (bus address [0x0000-0xfffffff])
[1319829.607394] pci_bus 0000:02: root bus resource [mem 0xc100000000-0xc17ffeffff] (bus address [0x00000000-0x7ffeffff])
[1319829.607466] pci_bus 0000:02: root bus resource [mem 0xc200000000-0xc3fffeffff] (bus address [0x100000000-0x2fffeffff])
[1319829.607535] pci_bus 0000:02: root bus resource [bus 02-12]
[1319829.635050] HugeTLB registered 8 MB page size, pre-allocated 0 pages
[1319829.638214] vgaarb: loaded
[1319829.640570] SUN4V: Reboot data supported (maj=1,min=0).
[1319829.640749] ds.c:v1.0 (Jul 11, 2007)
[1319829.641352] clocksource: Switched to clocksource stick
[1319829.666332] ds-1: Registered pri service.
[1319829.671709] ds-1: Registered var-config-backup service.
[1319829.702272] VFS: Disk quotas dquot_6.6.0
[1319829.702634] VFS: Dquot-cache hash table entries: 1024 (order 0, 8192 bytes)
[1319829.718174] NET: Registered protocol family 2
[1319829.720023] TCP established hash table entries: 131072 (order: 7, 1048576 bytes)
[1319829.723517] TCP bind hash table entries: 65536 (order: 7, 1048576 bytes)
[1319829.727535] TCP: Hash tables configured (established 131072 bind 65536)
[1319829.727697] UDP hash table entries: 8192 (order: 5, 262144 bytes)
[1319829.728796] UDP-Lite hash table entries: 8192 (order: 5, 262144 bytes)
[1319829.731170] NET: Registered protocol family 1
[1319829.842116] Unpacking initramfs...
[1319831.468011] Freeing initrd memory: 17408K (ffff80000c800000 - ffff80000d900000)
[1319831.480178] futex hash table entries: 16384 (order: 7, 1048576 bytes)
[1319831.480775] audit: initializing netlink subsys (disabled)
[1319831.480885] audit: type=2000 audit(2.183:1): initialized
[1319831.481565] Initialise system trusted keyrings
[1319831.482192] workingset: timestamp_bits=45 max_order=21 bucket_order=0
[1319831.482310] zbud: loaded
[1319831.915769] Key type asymmetric registered
[1319831.915811] Asymmetric key parser 'x509' registered
[1319831.915972] Block layer SCSI generic (bsg) driver version 0.4 loaded (major 252)
[1319831.916277] io scheduler noop registered
[1319831.916319] io scheduler deadline registered
[1319831.916473] io scheduler cfq registered (default)
[1319831.918735] f0286d78: ttyS0 at I/O 0x0 (irq = 17, base_baud = 115200) is a SUN4V HCONS
[1319831.933294] console [ttyHV0] enabled
[1319831.937743] f0298d00: ttyS1 at MMIO 0xfff0ca0000 (irq = 24, base_baud = 115387) is a 16550A
[1319831.940545] mousedev: PS/2 mouse device common for all mice
[1319831.943196] rtc-sun4v rtc-sun4v: rtc core: registered sun4v as rtc0
[1319831.944086] ledtrig-cpu: registered to indicate activity on CPUs
[1319831.947197] NET: Registered protocol family 10
[1319831.953115] mip6: Mobile IPv6
[1319831.953173] NET: Registered protocol family 17
[1319831.953235] mpls_gso: MPLS GSO support
[1319831.954274] registered taskstats version 1
[1319831.954333] Loading compiled-in X.509 certificates
[1319831.954468] zswap: loaded using pool lzo/zbud
[1319831.964447] rtc-sun4v rtc-sun4v: setting system clock to 2016-05-25 20:22:12 UTC (1464207732)
[1319831.965850] This architecture does not have kernel memory protection.
Loading, please wait...
starting version 229
[1319832.057199] random: systemd-udevd urandom read with 1 bits of entropy available
[1319832.527141] crc32c_sparc64: sparc64 crc32c opcode not available.
[1319832.530338] crc32c_sparc64: sparc64 crc32c opcode not available.
[1319832.535916] crc32c_sparc64: sparc64 crc32c opcode not available.
[1319832.538730] crc32c_sparc64: sparc64 crc32c opcode not available.
[1319832.553001] crc32c_sparc64: sparc64 crc32c opcode not available.
[1319832.557281] crc32c_sparc64: sparc64 crc32c opcode not available.
[1319832.560260] crc32c_sparc64: sparc64 crc32c opcode not available.
[1319832.565852] crc32c_sparc64: sparc64 crc32c opcode not available.
[1319832.566833] crc32c_sparc64: sparc64 crc32c opcode not available.
[1319832.574535] crc32c_sparc64: sparc64 crc32c opcode not available.
[1319832.575292] crc32c_sparc64: sparc64 crc32c opcode not available.
[1319832.579951] crc32c_sparc64: sparc64 crc32c opcode not available.
[1319832.580953] crc32c_sparc64: sparc64 crc32c opcode not available.
[1319832.581686] crc32c_sparc64: sparc64 crc32c opcode not available.
[1319832.585634] crc32c_sparc64: sparc64 crc32c opcode not available.
[1319832.587650] crc32c_sparc64: sparc64 crc32c opcode not available.
[1319832.591926] crc32c_sparc64: sparc64 crc32c opcode not available.
[1319832.593411] crc32c_sparc64: sparc64 crc32c opcode not available.
[1319832.597216] crc32c_sparc64: sparc64 crc32c opcode not available.
[1319832.599206] crc32c_sparc64: sparc64 crc32c opcode not available.
[1319832.603946] crc32c_sparc64: sparc64 crc32c opcode not available.
[1319832.604963] crc32c_sparc64: sparc64 crc32c opcode not available.
[1319832.608793] crc32c_sparc64: sparc64 crc32c opcode not available.
[1319832.613619] crc32c_sparc64: sparc64 crc32c opcode not available.
[1319832.614382] crc32c_sparc64: sparc64 crc32c opcode not available.
[1319832.616390] crc32c_sparc64: sparc64 crc32c opcode not available.
[1319832.619483] crc32c_sparc64: sparc64 crc32c opcode not available.
[1319832.623949] crc32c_sparc64: sparc64 crc32c opcode not available.
[1319832.625188] crc32c_sparc64: sparc64 crc32c opcode not available.
[1319832.629035] crc32c_sparc64: sparc64 crc32c opcode not available.
[1319832.631050] crc32c_sparc64: sparc64 crc32c opcode not available.
[1319832.635976] crc32c_sparc64: sparc64 crc32c opcode not available.
[1319832.636826] crc32c_sparc64: sparc64 crc32c opcode not available.
[1319832.639960] crc32c_sparc64: sparc64 crc32c opcode not available.
[1319832.642697] crc32c_sparc64: sparc64 crc32c opcode not available.
[1319832.647754] crc32c_sparc64: sparc64 crc32c opcode not available.
[1319832.648514] crc32c_sparc64: sparc64 crc32c opcode not available.
[1319832.651972] crc32c_sparc64: sparc64 crc32c opcode not available.
[1319832.654273] crc32c_sparc64: sparc64 crc32c opcode not available.
[1319832.659474] crc32c_sparc64: sparc64 crc32c opcode not available.
[1319832.663364] crc32c_sparc64: sparc64 crc32c opcode not available.
[1319832.665294] crc32c_sparc64: sparc64 crc32c opcode not available.
[1319832.669134] crc32c_sparc64: sparc64 crc32c opcode not available.
[1319832.671145] crc32c_sparc64: sparc64 crc32c opcode not available.
[1319832.674969] crc32c_sparc64: sparc64 crc32c opcode not available.
[1319832.676889] crc32c_sparc64: sparc64 crc32c opcode not available.
[1319832.679970] crc32c_sparc64: sparc64 crc32c opcode not available.
[1319832.682721] crc32c_sparc64: sparc64 crc32c opcode not available.
[1319832.686540] crc32c_sparc64: sparc64 crc32c opcode not available.
[1319832.688453] crc32c_sparc64: sparc64 crc32c opcode not available.
[1319832.691963] crc32c_sparc64: sparc64 crc32c opcode not available.
[1319832.694217] crc32c_sparc64: sparc64 crc32c opcode not available.
[1319832.698043] crc32c_sparc64: sparc64 crc32c opcode not available.
[1319832.700042] crc32c_sparc64: sparc64 crc32c opcode not available.
[1319832.703880] crc32c_sparc64: sparc64 crc32c opcode not available.
[1319832.705764] crc32c_sparc64: sparc64 crc32c opcode not available.
[1319832.709569] crc32c_sparc64: sparc64 crc32c opcode not available.
[1319832.711493] crc32c_sparc64: sparc64 crc32c opcode not available.
[1319832.715469] crc32c_sparc64: sparc64 crc32c opcode not available.
[1319832.717383] crc32c_sparc64: sparc64 crc32c opcode not available.
[1319832.721238] crc32c_sparc64: sparc64 crc32c opcode not available.
[1319832.725090] crc32c_sparc64: sparc64 crc32c opcode not available.
[1319832.834755] pps_core: LinuxPPS API ver. 1 registered
[1319832.834915] pps_core: Software ver. 5.3.6 - Copyright 2005-2007 Rodolfo Giometti <giometti@linux.it>
[1319832.835798] usbcore: registered new interface driver usbfs
[1319832.836034] usbcore: registered new interface driver hub
[1319832.837242] PTP clock support registered
[1319832.838756] usbcore: registered new device driver usb
[1319832.841124] ehci_hcd: USB 2.0 'Enhanced' Host Controller (EHCI) Driver
[1319832.842029] ehci-pci: EHCI PCI platform driver
[1319832.842333] ehci-pci 0000:07:00.2: EHCI Host Controller
[1319832.844499] ohci_hcd: USB 1.1 'Open' Host Controller (OHCI) Driver
[1319832.854631] ehci-pci 0000:07:00.2: new USB bus registered, assigned bus number 1
[1319832.855036] ehci-pci 0000:07:00.2: irq 20, io mem 0xc100304000
[1319832.862095] e1000e: Intel(R) PRO/1000 Network Driver - 3.2.6-k
[1319832.862239] e1000e: Copyright(c) 1999 - 2015 Intel Corporation.
[1319832.866546] ehci-pci 0000:07:00.2: USB 2.0 started, EHCI 1.00
[1319832.866997] usb usb1: New USB device found, idVendor=1d6b, idProduct=0002
[1319832.867145] usb usb1: New USB device strings: Mfr=3, Product=2, SerialNumber=1
[1319832.867304] usb usb1: Product: EHCI Host Controller
[1319832.867406] usb usb1: Manufacturer: Linux 4.6.0+ ehci_hcd
[1319832.867473] usb usb1: SerialNumber: 0000:07:00.2
[1319832.868433] hub 1-0:1.0: USB hub found
[1319832.868535] hub 1-0:1.0: 5 ports detected
[1319832.870255] e1000e 0000:08:00.0: Interrupt Throttling Rate (ints/sec) set to dynamic conservative mode
[1319832.871753] ohci-pci: OHCI PCI platform driver
[1319832.871917] ohci-pci 0000:07:00.0: OHCI PCI host controller
[1319832.872120] ohci-pci 0000:07:00.0: new USB bus registered, assigned bus number 2
[1319832.872389] ohci-pci 0000:07:00.0: irq 22, io mem 0xc100300000
[1319832.916990] SCSI subsystem initialized
[1319832.928928] usb usb2: New USB device found, idVendor=1d6b, idProduct=0001
[1319832.929081] usb usb2: New USB device strings: Mfr=3, Product=2, SerialNumber=1
[1319832.929241] usb usb2: Product: OHCI PCI host controller
[1319832.929379] usb usb2: Manufacturer: Linux 4.6.0+ ohci_hcd
[1319832.929482] usb usb2: SerialNumber: 0000:07:00.0
[1319832.930712] hub 2-0:1.0: USB hub found
[1319832.931106] Fusion MPT base driver 3.04.20
[1319832.931195] Copyright (c) 1999-2008 LSI Corporation
[1319832.931424] hub 2-0:1.0: 3 ports detected
[1319832.935173] ohci-pci 0000:07:00.1: OHCI PCI host controller
[1319832.935347] ohci-pci 0000:07:00.1: new USB bus registered, assigned bus number 3
[1319832.935667] ohci-pci 0000:07:00.1: irq 23, io mem 0xc100302000
[1319832.952774] Fusion MPT SAS Host driver 3.04.20
[1319832.964823] mptbase: ioc0: Initiating bringup
[1319832.993365] usb usb3: New USB device found, idVendor=1d6b, idProduct=0001
[1319832.993516] usb usb3: New USB device strings: Mfr=3, Product=2, SerialNumber=1
[1319832.993676] usb usb3: Product: OHCI PCI host controller
[1319832.993813] usb usb3: Manufacturer: Linux 4.6.0+ ohci_hcd
[1319832.993916] usb usb3: SerialNumber: 0000:07:00.1
[1319832.995917] hub 3-0:1.0: USB hub found
[1319832.997012] hub 3-0:1.0: 2 ports detected
[1319833.052187] e1000e 0000:08:00.0 eth0: (PCI Express:2.5GT/s:Width x4) 00:14:4f:ac:4a:18
[1319833.052358] e1000e 0000:08:00.0 eth0: Intel(R) PRO/1000 Network Connection
[1319833.052579] e1000e 0000:08:00.0 eth0: MAC: 0, PHY: 4, PBA No: FFFFFF-0FF
[1319833.053966] e1000e 0000:08:00.1: Interrupt Throttling Rate (ints/sec) set to dynamic conservative mode
[1319833.178662] usb 1-2: new high-speed USB device number 2 using ehci-pci
[1319833.228119] e1000e 0000:08:00.1 eth1: (PCI Express:2.5GT/s:Width x4) 00:14:4f:ac:4a:19
[1319833.228289] e1000e 0000:08:00.1 eth1: Intel(R) PRO/1000 Network Connection
[1319833.228509] e1000e 0000:08:00.1 eth1: MAC: 0, PHY: 4, PBA No: FFFFFF-0FF
[1319833.231845] e1000e 0000:09:00.0: Interrupt Throttling Rate (ints/sec) set to dynamic conservative mode
[1319833.357132] usb 1-2: New USB device found, idVendor=0451, idProduct=625f
[1319833.357282] usb 1-2: New USB device strings: Mfr=5, Product=2, SerialNumber=1
[1319833.357442] usb 1-2: Product: 6250 FW: 03.05.02.22.562AD423
[1319833.357581] usb 1-2: Manufacturer: Texas Instruments Incorporated
[1319833.357685] usb 1-2: SerialNumber: ACD6CE63350D
[1319833.412189] e1000e 0000:09:00.0 eth2: (PCI Express:2.5GT/s:Width x4) 00:14:4f:ac:4a:1a
[1319833.412360] e1000e 0000:09:00.0 eth2: Intel(R) PRO/1000 Network Connection
[1319833.412579] e1000e 0000:09:00.0 eth2: MAC: 0, PHY: 4, PBA No: FFFFFF-0FF
[1319833.414478] e1000e 0000:09:00.1: Interrupt Throttling Rate (ints/sec) set to dynamic conservative mode
[1319833.470768] usb 1-4: new high-speed USB device number 3 using ehci-pci
[1319833.588235] e1000e 0000:09:00.1 eth3: (PCI Express:2.5GT/s:Width x4) 00:14:4f:ac:4a:1b
[1319833.588405] e1000e 0000:09:00.1 eth3: Intel(R) PRO/1000 Network Connection
[1319833.588627] e1000e 0000:09:00.1 eth3: MAC: 0, PHY: 4, PBA No: FFFFFF-0FF
[1319833.604716] usb 1-4: New USB device found, idVendor=04b4, idProduct=6560
[1319833.604868] usb 1-4: New USB device strings: Mfr=0, Product=0, SerialNumber=0
[1319833.606232] hub 1-4:1.0: USB hub found
[1319833.606696] hub 1-4:1.0: 4 ports detected
[1319833.618139] e1000e 0000:08:00.0 enp8s0f0: renamed from eth0
[1319833.642064] e1000e 0000:09:00.0 enp9s0f0: renamed from eth2
[1319833.643439] e1000e 0000:08:00.1 enp8s0f1: renamed from eth1
[1319833.644619] e1000e 0000:09:00.1 enp9s0f1: renamed from eth3
[1319833.652925] usb-storage 1-2:1.0: USB Mass Storage device detected
[1319833.666874] ioc0: LSISAS1068E B1: Capabilities={Initiator}
[1319833.682039] scsi host0: usb-storage 1-2:1.0
[1319833.682911] usbcore: registered new interface driver usb-storage
[1319833.684598] usbcore: registered new interface driver uas
[1319839.361850] scsi 0:0:0:0: CD-ROM            TSSTcorp CD/DVDW TS-T632A SR03 PQ: 0 ANSI: 0
[1319839.474070] sr 0:0:0:0: [sr0] scsi3-mmc drive: 6x/24x writer dvd-ram cd/rw xa/form2 cdda tray
[1319839.474236] cdrom: Uniform CD-ROM driver Revision: 3.20
[1319849.732214] scsi host1: ioc0: LSISAS1068E B1, FwRev=011b0000h, Ports=1, MaxQ=277, IRQ=22
[1319849.779503] mptsas: ioc0: attaching ssp device: fw_channel 0, fw_id 0, phy 0, sas_addr 0x5000c5000a5c8715
[1319849.785563] scsi 1:0:0:0: Direct-Access     SEAGATE  ST914602SSUN146G 0603 PQ: 0 ANSI: 5
[1319849.793617] mptsas: ioc0: attaching ssp device: fw_channel 0, fw_id 1, phy 1, sas_addr 0x5000c5000ee01681
[1319849.799588] scsi 1:0:1:0: Direct-Access     SEAGATE  ST914602SSUN146G 0603 PQ: 0 ANSI: 5
[1319849.830060] sd 1:0:0:0: [sda] 286739329 512-byte logical blocks: (147 GB/137 GiB)
[1319849.832316] sd 1:0:0:0: [sda] Write Protect is off
[1319849.834268] sd 1:0:0:0: [sda] Write cache: disabled, read cache: enabled, supports DPO and FUA
[1319849.839545] sd 1:0:1:0: [sdb] 286739329 512-byte logical blocks: (147 GB/137 GiB)
[1319849.843271] sd 1:0:1:0: [sdb] Write Protect is off
[1319849.845324] sd 1:0:1:0: [sdb] Write cache: disabled, read cache: enabled, supports DPO and FUA
[1319849.858925]  sdb: sdb1 sdb2 sdb3
[1319849.861862]  sda: sda1 sda2 sda3
[1319849.872815] sd 1:0:1:0: [sdb] Attached SCSI disk
[1319849.873593] sd 1:0:0:0: [sda] Attached SCSI disk
Begin: Loading essential drivers ... done.
Begin: Running /scripts/init-premount ... done.
Begin: Mounting root file system ... Begin: Running /scripts/local-top ... Begin: Assembling all MD arrays ... [1319850.379638] md: md0 stopped.
[1319850.383458] md: bind<sdb2>
[1319850.384340] md: bind<sda2>
[1319850.396891] md: raid1 personality registered for level 1
[1319850.399181] md/raid1:md0: active with 2 out of 2 mirrors
[1319850.399605] created bitmap (1 pages) for device md0
[1319850.400263] md0: bitmap initialized from disk: read 1 pages, set 0 of 2182 bits
[1319850.407319] md0: detected capacity change from 0 to 146415419392
mdadm: /dev/md0 has been started with 2 drives.
Success: assembled all arrays.
done.
  WARNING: Failed to connect to lvmetad. Falling back to device scanning.
[1319850.627808] device-mapper: uevent: version 1.0.3
[1319850.628379] device-mapper: ioctl: 4.34.0-ioctl (2015-10-28) initialised: dm-devel@redhat.com
done.
Begin: Running /scripts/local-premount ... done.
Begin: Will now check root file system ... fsck from util-linux 2.28
[1319850.963384] random: nonblocking pool is initialized
[/sbin/fsck.ext4 (1) -- /dev/mapper/vg1-root] fsck.ext4 -a -C0 /dev/mapper/vg1-root 
/dev/mapper/vg1-root: clean, 163646/5242880 files, 1836065/20971520 blocks
done.
[1319851.124299] crc32c_sparc64: sparc64 crc32c opcode not available.
[1319851.193279] EXT4-fs (dm-0): mounted filesystem with ordered data mode. Opts: (null)
done.
Begin: Running /scripts/local-bottom ... done.
Begin: Running /scripts/init-bottom ... done.
[1319852.059298] systemd[1]: systemd 229 running in system mode. (+PAM +AUDIT +SELINUX +IMA +APPARMOR +SMACK +SYSVINIT +UTMP +LIBCRYPTSETUP +GCRYPT +GNUTLS +ACL +XZ -LZ4 -SECCOMP +BLKID +ELFUTILS +KMOD -IDN)
[1319852.059873] systemd[1]: Detected architecture sparc64.

Welcome to Debian GNU/Linux stretch/sid!

[1319852.072486] systemd[1]: Set hostname to <nvg5120>.
[1319852.799555] systemd[1]: Set up automount Arbitrary Executable File Formats File System Automount Point.
[  OK  ] Set up automount Arbitrary Executab...ats File System Automount Point.
[1319852.800797] systemd[1]: Listening on Syslog Socket.
[  OK  ] Listening on Syslog Socket.
[1319852.801478] systemd[1]: Reached target Encrypted Volumes.
[  OK  ] Reached target Encrypted Volumes.
[1319852.802397] systemd[1]: Listening on Journal Socket (/dev/log).
[  OK  ] Listening on Journal Socket (/dev/log).
[1319852.803230] systemd[1]: Listening on LVM2 metadata daemon socket.
[  OK  ] Listening on LVM2 metadata daemon socket.
[1319852.804086] systemd[1]: Listening on /dev/initctl Compatibility Named Pipe.
[  OK  ] Listening on /dev/initctl Compatibility Named Pipe.
[1319852.804940] systemd[1]: Listening on Journal Audit Socket.
[  OK  ] Listening on Journal Audit Socket.
[1319852.805467] systemd[1]: Listening on LVM2 poll daemon socket.
[  OK  ] Listening on LVM2 poll daemon socket.
[1319852.807075] systemd[1]: Created slice System Slice.
[  OK  ] Created slice System Slice.
[1319852.808516] systemd[1]: Created slice system-getty.slice.
[  OK  ] Created slice system-getty.slice.
[1319852.808956] systemd[1]: Reached target Remote File Systems (Pre).
[  OK  ] Reached target Remote File Systems (Pre).
[1319852.809390] systemd[1]: Reached target Remote File Systems.
[  OK  ] Reached target Remote File Systems.
[1319852.810131] systemd[1]: Listening on Journal Socket.
[  OK  ] Listening on Journal Socket.
[1319852.814593] systemd[1]: Mounting Debug File System...
         Mounting Debug File System...
[1319852.824538] systemd[1]: Starting Create list of required static device nodes for the current kernel...
         Starting Create list of required st... nodes for the current kernel...
[1319852.835000] systemd[1]: Mounting POSIX Message Queue File System...
         Mounting POSIX Message Queue File System...
[1319852.858091] systemd[1]: Starting Load Kernel Modules...
         Starting Load Kernel Modules...
[1319852.882399] systemd[1]: Starting Journal Service...
         Starting Journal Service...
[1319852.883152] systemd[1]: Listening on udev Kernel Socket.
[  OK  ] Listening on udev Kernel Socket.
[1319852.884101] systemd[1]: Listening on fsck to fsckd communication Socket.
[  OK  ] Listening on fsck to fsckd communication Socket.
[1319852.886095] systemd[1]: Listening on Device-mapper event daemon FIFOs.
[  OK  ] Listening on Device-mapper event daemon FIFOs.
[1319852.895420] systemd[1]: Starting Monitoring of LVM2 mirrors, snapshots etc. using dmeventd or progress polling...
         Starting Monitoring of LVM2 mirrors... dmeventd or progress polling...
[1319852.897582] systemd[1]: Started Dispatch Password Requests to Console Directory Watch.
[  OK  ] Started Dispatch Password Requests to Console Directory Watch.
[1319852.907267] systemd[1]: Created slice User and Session Slice.
[  OK  ] Created slice User and Session Slice.
[1319852.911393] systemd[1]: Reached target Slices.
[  OK  ] Reached target Slices.
[1319852.912360] systemd[1]: Listening on udev Control Socket.
[  OK  ] Listening on udev Control Socket.
[1319852.919271] systemd[1]: Mounting Huge Pages File System...
         Mounting Huge Pages File System...
[1319852.930292] systemd[1]: Started Forward Password Requests to Wall Directory Watch.
[  OK  ] Started Forward Password Requests to Wall Directory Watch.
[1319852.936667] systemd[1]: Reached target Paths.
[  OK  ] Reached target Paths.
[1319852.945535] systemd[1]: Created slice system-systemd\x2dfsck.slice.
[  OK  ] Created slice system-systemd\x2dfsck.slice.
[1319852.960106] systemd[1]: Starting Remount Root and Kernel File Systems...
         Starting Remount Root and Kernel File Systems...
[1319853.012418] systemd[1]: Started Create list of required static device nodes for the current kernel.
[  OK  ] Started Create list of required sta...ce nodes for the current kernel.
[1319853.027548] systemd[1]: Started Load Kernel Modules.
[  OK  ] Started Load Kernel Modules.
[1319853.127397] systemd[1]: Mounted POSIX Message Queue File System.
[  OK  ] Mounted POSIX Message Queue File System.
[1319853.128394] systemd[1]: Mounted Huge Pages File System.
[  OK  ] Mounted Huge Pages File System.
[1319853.130000] systemd[1]: Mounted Debug File System.
[  OK  ] Mounted Debug File System.
[1319853.217932] EXT4-fs (dm-0): re-mounted. Opts: errors=remount-ro
[1319853.241855] systemd[1]: Started Remount Root and Kernel File Systems.
[  OK  ] Started Remount Root and Kernel File Systems.
[1319853.406652] systemd[1]: Started LVM2 metadata daemon.
[  OK  ] Started LVM2 metadata daemon.
[1319853.437786] systemd[1]: Starting udev Coldplug all Devices...
         Starting udev Coldplug all Devices...
[1319853.453829] systemd[1]: Starting Load/Save Random Seed...
         Starting Load/Save Random Seed...
[1319853.480318] systemd[1]: Starting Apply Kernel Variables...
         Starting Apply Kernel Variables...
[1319853.542255] systemd[1]: Starting Create Static Device Nodes in /dev...
         Starting Create Static Device Nodes in /dev...
[1319853.591852] systemd[1]: Started Load/Save Random Seed.
[  OK  ] Started Load/Save Random Seed.
[1319853.606507] systemd[1]: Started Apply Kernel Variables.
[  OK  ] Started Apply Kernel Variables.
[1319853.744278] systemd[1]: Started Create Static Device Nodes in /dev.
[  OK  ] Started Create Static Device Nodes in /dev.
[1319853.766618] systemd[1]: Started Journal Service.
[  OK  ] Started Journal Service.
         Starting Flush Journal to Persistent Storage...
         Starting udev Kernel Device Manager...
[1319853.982610] systemd-journald[194]: Received request to flush runtime journal from PID 1
[  OK  ] Started Monitoring of LVM2 mirrors,...ng dmeventd or progress polling.
[  OK  ] Reached target Local File Systems (Pre).
[  OK  ] Started udev Kernel Device Manager.
         Starting LSB: MD array assembly...
[  OK  ] Started udev Coldplug all Devices.
[  OK  ] Started LSB: MD array assembly.
[1319855.107974] sha1_sparc64: sparc64 sha1 opcode not available.
[1319855.109726] sha1_sparc64: sparc64 sha1 opcode not available.
[1319855.120817] sha1_sparc64: sparc64 sha1 opcode not available.
[1319855.121743] sha256_sparc64: sparc64 sha256 opcode not available.
[1319855.130852] sha1_sparc64: sparc64 sha1 opcode not available.
[1319855.131760] sha256_sparc64: sparc64 sha256 opcode not available.
[1319855.132608] sha1_sparc64: sparc64 sha1 opcode not available.
[1319855.139505] sha1_sparc64: sparc64 sha1 opcode not available.
[  OK  ] Started Flush Journal to Persistent Storage.
[1319855.148806] sha256_sparc64: sparc64 sha256 opcode not available.
[1319855.149824] sha512_sparc64: sparc64 sha512 opcode not available.
[1319855.155087] sha256_sparc64: sparc64 sha256 opcode not available.
[1319855.156069] sha512_sparc64: sparc64 sha512 opcode not available.
[1319855.157178] sha256_sparc64: sparc64 sha256 opcode not available.
[1319855.158135] sha512_sparc64: sparc64 sha512 opcode not available.
[1319855.159909] sha256_sparc64: sparc64 sha256 opcode not available.
[1319855.160861] sha512_sparc64: sparc64 sha512 opcode not available.
[1319855.161831] md5_sparc64: sparc64 md5 opcode not available.
[1319855.167178] md5_sparc64: sparc64 md5 opcode not available.
[1319855.168157] sha512_sparc64: sparc64 sha512 opcode not available.
[1319855.169130] md5_sparc64: sparc64 md5 opcode not available.
[1319855.174980] sha512_sparc64: sparc64 sha512 opcode not available.
[1319855.175939] md5_sparc64: sparc64 md5 opcode not available.
[1319855.177014] aes_sparc64: sparc64 aes opcodes not available.
[1319855.179922] md5_sparc64: sparc64 md5 opcode not available.
[1319855.180938] aes_sparc64: sparc64 aes opcodes not available.
[1319855.195156] md5_sparc64: sparc64 md5 opcode not available.
[1319855.208651] aes_sparc64: sparc64 aes opcodes not available.
[1319855.209391] aes_sparc64: sparc64 aes opcodes not available.
[1319855.214897] aes_sparc64: sparc64 aes opcodes not available.
[1319855.216101] des_sparc64: sparc64 des opcodes not available.
[1319855.220856] n2_crypto: n2_crypto.c:v0.2 (July 28, 2011)
[1319855.221000] n2_crypto: Found N2CP at /virtual-devices@100/n2cp@7
[1319855.221142] n2_crypto: Registered NCS HVAPI version 2.0
[1319855.221482] genirq: Flags mismatch irq 1. 00000000 (cwq-0) vs. 00000000 (cwq-0)
[1319855.221652] ------------[ cut here ]------------
[1319855.221760] WARNING: CPU: 0 PID: 238 at kernel/irq/manage.c:1447 __free_irq+0xac/0x2a0
[1319855.221847] Trying to free already-free IRQ 1
[1319855.221896] Modules linked in: n2_crypto(+) rng_core des_generic autofs4 crc32c_generic ext4 crc16 jbd2 mbcache dm_mod raid1 md_mod sd_mod sr_mod cdrom uas usb_storage mptsas scsi_transport_sas mptscsih mptbase scsi_mod ohci_pci e1000e ohci_hcd ehci_pci ehci_hcd ptp pps_core usbcore usb_common
[1319855.222672] CPU: 0 PID: 238 Comm: systemd-udevd Not tainted 4.6.0+ #1
[1319855.222738] Call Trace:
[1319855.222801]  [0000000000466ea0] __warn+0xc0/0xe0
[1319855.222862]  [0000000000466ef4] warn_slowpath_fmt+0x34/0x60
[1319855.222935]  [00000000004c02cc] __free_irq+0xac/0x2a0
[1319855.223039]  [00000000004c0560] free_irq+0x40/0x80
[1319855.223123]  [00000000107fc24c] spu_list_destroy+0xec/0x100 [n2_crypto]
[1319855.223211]  [00000000107fdc98] spu_mdesc_scan+0x298/0x4a0 [n2_crypto]
[1319855.223333]  [00000000107fe204] n2_crypto_probe+0x1a4/0x680 [n2_crypto]
[1319855.223410]  [00000000007d5034] platform_drv_probe+0x34/0xc0
[1319855.223488]  [00000000007d2a0c] driver_probe_device+0x24c/0x460
[1319855.223562]  [00000000007d2d10] __driver_attach+0xf0/0x120
[1319855.223670]  [00000000007d02fc] bus_for_each_dev+0x5c/0xa0
[1319855.223742]  [00000000007d201c] driver_attach+0x1c/0x40
[1319855.223813]  [00000000007d1a30] bus_add_driver+0x1f0/0x2a0
[1319855.223886]  [00000000007d3834] driver_register+0x74/0x120
[1319855.223992]  [00000000007d5204] __platform_register_drivers+0x64/0x160
[1319855.224076]  [0000000010804014] n2_init+0x14/0x24 [n2_crypto]
[1319855.224144] ---[ end trace cb982bd370b3b6da ]---
[1319855.232723] des_sparc64: sparc64 des opcodes not available.
[1319855.235025] aes_sparc64: sparc64 aes opcodes not available.
[1319855.236233] des_sparc64: sparc64 des opcodes not available.
[1319855.243513] des_sparc64: sparc64 des opcodes not available.
[1319855.244936] des_sparc64: sparc64 des opcodes not available.
[1319855.247138] des_sparc64: sparc64 des opcodes not available.
[1319855.248361] camellia_sparc64: sparc64 camellia opcodes not available.
[1319855.255279] camellia_sparc64: sparc64 camellia opcodes not available.
[1319855.256649] camellia_sparc64: sparc64 camellia opcodes not available.
[1319855.257697] camellia_sparc64: sparc64 camellia opcodes not available.
[1319855.258278] n2cp f028681c: /virtual-devices@100/n2cp@7: CWQ MDESC scan failed.
[1319855.258458] n2cp: probe of f028681c failed with error -16
[1319855.261301] n2rng.c:v0.2 (July 27, 2011)
[1319855.261403] n2rng f0286a1c: Registered RNG HVAPI major 2 minor 0
[1319855.261547] n2rng f0286a1c: Found single-unit RNG, units: 1
[1319855.262882] n2rng f0286a1c: Selftest passed on unit 0
[1319855.263028] n2rng f0286a1c: RNG ready
[1319855.268523] camellia_sparc64: sparc64 camellia opcodes not available.
[1319855.269522] crc32c_sparc64: sparc64 crc32c opcode not available.
[1319855.271866] camellia_sparc64: sparc64 camellia opcodes not available.
[1319855.272859] crc32c_sparc64: sparc64 crc32c opcode not available.
[1319855.273435] n2_crypto: Found NCP at /virtual-devices@100/ncp@6
[1319855.273582] n2_crypto: Registered NCS HVAPI version 2.0
[1319855.273833] genirq: Flags mismatch irq 9. 00000000 (mau-0) vs. 00000000 (mau-0)
[1319855.274000] ------------[ cut here ]------------
[1319855.274122] WARNING: CPU: 0 PID: 238 at kernel/irq/manage.c:1447 __free_irq+0xac/0x2a0
[1319855.274279] Trying to free already-free IRQ 9
[1319855.274362] Modules linked in: n2_rng n2_crypto(+) rng_core des_generic autofs4 crc32c_generic ext4 crc16 jbd2 mbcache dm_mod raid1 md_mod sd_mod sr_mod cdrom uas usb_storage mptsas scsi_transport_sas mptscsih mptbase scsi_mod ohci_pci e1000e ohci_hcd ehci_pci ehci_hcd ptp pps_core usbcore usb_common
[1319855.275143] CPU: 0 PID: 238 Comm: systemd-udevd Tainted: G        W       4.6.0+ #1
[1319855.275227] Call Trace:
[1319855.275283]  [0000000000466ea0] __warn+0xc0/0xe0
[1319855.275343]  [0000000000466ef4] warn_slowpath_fmt+0x34/0x60
[1319855.275415]  [00000000004c02cc] __free_irq+0xac/0x2a0
[1319855.275484]  [00000000004c0560] free_irq+0x40/0x80
[1319855.275640]  [00000000107fc24c] spu_list_destroy+0xec/0x100 [n2_crypto]
[1319855.276013]  [00000000107fdc98] spu_mdesc_scan+0x298/0x4a0 [n2_crypto]
[1319855.276101]  [00000000107fe968] n2_mau_probe+0x1a8/0x220 [n2_crypto]
[1319855.276174]  [00000000007d5034] platform_drv_probe+0x34/0xc0
[1319855.276247]  [00000000007d2a0c] driver_probe_device+0x24c/0x460
[1319855.276356]  [00000000007d2d10] __driver_attach+0xf0/0x120
[1319855.276715]  [00000000007d02fc] bus_for_each_dev+0x5c/0xa0
[1319855.276787]  [00000000007d201c] driver_attach+0x1c/0x40
[1319855.276859]  [00000000007d1a30] bus_add_driver+0x1f0/0x2a0
[1319855.276931]  [00000000007d3834] driver_register+0x74/0x120
[1319855.277002]  [00000000007d5204] __platform_register_drivers+0x64/0x160
[1319855.277086]  [0000000010804014] n2_init+0x14/0x24 [n2_crypto]
[1319855.277260] ---[ end trace cb982bd370b3b6db ]---
[1319855.283532] crc32c_sparc64: sparc64 crc32c opcode not available.
[1319855.285478] crc32c_sparc64: sparc64 crc32c opcode not available.
[1319855.287387] crc32c_sparc64: sparc64 crc32c opcode not available.
[1319855.290878] crc32c_sparc64: sparc64 crc32c opcode not available.
[1319855.302253] sha1_sparc64: sparc64 sha1 opcode not available.
[1319855.305742] sha256_sparc64: sparc64 sha256 opcode not available.
[1319855.310696] ncp f028691c: /virtual-devices@100/ncp@6: MAU MDESC scan failed.
[1319855.310891] ncp: probe of f028691c failed with error -16
[1319855.312632] sha256_sparc64: sparc64 sha256 opcode not available.
[1319855.313621] sha512_sparc64: sparc64 sha512 opcode not available.
[1319855.316854] sha512_sparc64: sparc64 sha512 opcode not available.
[1319855.324318] sha1_sparc64: sparc64 sha1 opcode not available.
[1319855.325283] sha256_sparc64: sparc64 sha256 opcode not available.
[1319855.326234] sha512_sparc64: sparc64 sha512 opcode not available.
[1319855.329709] sha1_sparc64: sparc64 sha1 opcode not available.
[1319855.333274] sha1_sparc64: sparc64 sha1 opcode not available.
[1319855.336859] sha1_sparc64: sparc64 sha1 opcode not available.
[1319855.340370] sha1_sparc64: sparc64 sha1 opcode not available.
[1319855.341193] sha256_sparc64: sparc64 sha256 opcode not available.
[1319855.342188] sha512_sparc64: sparc64 sha512 opcode not available.
[1319855.343664] sha256_sparc64: sparc64 sha256 opcode not available.
[1319855.344655] sha512_sparc64: sparc64 sha512 opcode not available.
[1319855.345738] sha256_sparc64: sparc64 sha256 opcode not available.
[1319855.350948] sha256_sparc64: sparc64 sha256 opcode not available.
[1319855.351684] md5_sparc64: sparc64 md5 opcode not available.
[1319855.352355] md5_sparc64: sparc64 md5 opcode not available.
[1319855.353445] aes_sparc64: sparc64 aes opcodes not available.
[1319855.356212] aes_sparc64: sparc64 aes opcodes not available.
[1319855.357236] sha512_sparc64: sparc64 sha512 opcode not available.
[1319855.358221] md5_sparc64: sparc64 md5 opcode not available.
[1319855.359599] sha512_sparc64: sparc64 sha512 opcode not available.
[1319855.360577] md5_sparc64: sparc64 md5 opcode not available.
[1319855.361625] aes_sparc64: sparc64 aes opcodes not available.
[1319855.365735] md5_sparc64: sparc64 md5 opcode not available.
[1319855.368001] sha1_sparc64: sparc64 sha1 opcode not available.
[1319855.369011] sha256_sparc64: sparc64 sha256 opcode not available.
[1319855.369972] sha512_sparc64: sparc64 sha512 opcode not available.
[1319855.371865] md5_sparc64: sparc64 md5 opcode not available.
[1319855.375457] sha1_sparc64: sparc64 sha1 opcode not available.
[1319855.376451] sha256_sparc64: sparc64 sha256 opcode not available.
[1319855.377433] sha512_sparc64: sparc64 sha512 opcode not available.
[1319855.378411] md5_sparc64: sparc64 md5 opcode not available.
[1319855.382095] sha1_sparc64: sparc64 sha1 opcode not available.
[1319855.387518] sha256_sparc64: sparc64 sha256 opcode not available.
[1319855.388516] sha512_sparc64: sparc64 sha512 opcode not available.
[1319855.389647] des_sparc64: sparc64 des opcodes not available.
[1319855.391994] des_sparc64: sparc64 des opcodes not available.
[1319855.393337] aes_sparc64: sparc64 aes opcodes not available.
[1319855.394061] aes_sparc64: sparc64 aes opcodes not available.
[1319855.396084] des_sparc64: sparc64 des opcodes not available.
[1319855.397194] aes_sparc64: sparc64 aes opcodes not available.
[1319855.398343] des_sparc64: sparc64 des opcodes not available.
[1319855.399663] camellia_sparc64: sparc64 camellia opcodes not available.
[1319855.400647] crc32c_sparc64: sparc64 crc32c opcode not available.
[1319855.402127] camellia_sparc64: sparc64 camellia opcodes not available.
[1319855.404635] camellia_sparc64: sparc64 camellia opcodes not available.
[1319855.406233] camellia_sparc64: sparc64 camellia opcodes not available.
[1319855.407837] camellia_sparc64: sparc64 camellia opcodes not available.
[1319855.409293] camellia_sparc64: sparc64 camellia opcodes not available.
[1319855.412701] md5_sparc64: sparc64 md5 opcode not available.
[1319855.413689] aes_sparc64: sparc64 aes opcodes not available.
[1319855.414423] aes_sparc64: sparc64 aes opcodes not available.
[1319855.416172] des_sparc64: sparc64 des opcodes not available.
[1319855.417492] des_sparc64: sparc64 des opcodes not available.
[1319855.418465] camellia_sparc64: sparc64 camellia opcodes not available.
[1319855.419584] crc32c_sparc64: sparc64 crc32c opcode not available.
[1319855.420165] crc32c_sparc64: sparc64 crc32c opcode not available.
[1319855.421280] crc32c_sparc64: sparc64 crc32c opcode not available.
[1319855.422116] crc32c_sparc64: sparc64 crc32c opcode not available.
[1319855.423795] crc32c_sparc64: sparc64 crc32c opcode not available.
[1319855.429315] sha1_sparc64: sparc64 sha1 opcode not available.
[1319855.430211] sha256_sparc64: sparc64 sha256 opcode not available.
[1319855.432054] crc32c_sparc64: sparc64 crc32c opcode not available.
[1319855.437250] sha1_sparc64: sparc64 sha1 opcode not available.
[1319855.438241] sha256_sparc64: sparc64 sha256 opcode not available.
[1319855.441420] sha1_sparc64: sparc64 sha1 opcode not available.
[1319855.442416] sha256_sparc64: sparc64 sha256 opcode not available.
[1319855.443586] aes_sparc64: sparc64 aes opcodes not available.
[1319855.444801] des_sparc64: sparc64 des opcodes not available.
[1319855.446197] crc32c_sparc64: sparc64 crc32c opcode not available.
[1319855.449858] sha1_sparc64: sparc64 sha1 opcode not available.
[1319855.452105] sha1_sparc64: sparc64 sha1 opcode not available.
[1319855.453460] sha512_sparc64: sparc64 sha512 opcode not available.
[1319855.454453] md5_sparc64: sparc64 md5 opcode not available.
[1319855.456367] crc32c_sparc64: sparc64 crc32c opcode not available.
[1319855.460836] sha1_sparc64: sparc64 sha1 opcode not available.
[1319855.462198] sha512_sparc64: sparc64 sha512 opcode not available.
[1319855.463964] crc32c_sparc64: sparc64 crc32c opcode not available.
[1319855.465080] sha512_sparc64: sparc64 sha512 opcode not available.
[1319855.466537] aes_sparc64: sparc64 aes opcodes not available.
[1319855.468078] sha512_sparc64: sparc64 sha512 opcode not available.
[1319855.470010] des_sparc64: sparc64 des opcodes not available.
[1319855.471788] sha512_sparc64: sparc64 sha512 opcode not available.
[1319855.473718] des_sparc64: sparc64 des opcodes not available.
[1319855.475948] sha512_sparc64: sparc64 sha512 opcode not available.
[1319855.477880] des_sparc64: sparc64 des opcodes not available.
[1319855.494187] des_sparc64: sparc64 des opcodes not available.
[1319855.495891] des_sparc64: sparc64 des opcodes not available.
[1319855.496276] sha1_sparc64: sparc64 sha1 opcode not available.
[1319855.496932] sha1_sparc64: sparc64 sha1 opcode not available.
[1319855.497988] sha256_sparc64: sparc64 sha256 opcode not available.
[1319855.500221] sha256_sparc64: sparc64 sha256 opcode not available.
[1319855.501222] sha512_sparc64: sparc64 sha512 opcode not available.
[1319855.502199] md5_sparc64: sparc64 md5 opcode not available.
[1319855.503670] sha1_sparc64: sparc64 sha1 opcode not available.
[1319855.504655] sha256_sparc64: sparc64 sha256 opcode not available.
[1319855.505629] sha512_sparc64: sparc64 sha512 opcode not available.
[1319855.506611] md5_sparc64: sparc64 md5 opcode not available.
[1319855.508861] aes_sparc64: sparc64 aes opcodes not available.
[1319855.510020] des_sparc64: sparc64 des opcodes not available.
[1319855.511546] sha512_sparc64: sparc64 sha512 opcode not available.
[1319855.512996] aes_sparc64: sparc64 aes opcodes not available.
[1319855.514135] des_sparc64: sparc64 des opcodes not available.
[1319855.515663] sha1_sparc64: sparc64 sha1 opcode not available.
[1319855.516681] sha256_sparc64: sparc64 sha256 opcode not available.
[1319855.517678] sha512_sparc64: sparc64 sha512 opcode not available.
[1319855.520299] camellia_sparc64: sparc64 camellia opcodes not available.
[1319855.521324] crc32c_sparc64: sparc64 crc32c opcode not available.
[1319855.522254] camellia_sparc64: sparc64 camellia opcodes not available.
[1319855.523700] camellia_sparc64: sparc64 camellia opcodes not available.
[1319855.524678] crc32c_sparc64: sparc64 crc32c opcode not available.
[1319855.525600] camellia_sparc64: sparc64 camellia opcodes not available.
[1319855.526596] crc32c_sparc64: sparc64 crc32c opcode not available.
[1319855.528007] camellia_sparc64: sparc64 camellia opcodes not available.
[1319855.529993] camellia_sparc64: sparc64 camellia opcodes not available.
[1319855.532108] aes_sparc64: sparc64 aes opcodes not available.
[1319855.533267] des_sparc64: sparc64 des opcodes not available.
[1319855.534314] camellia_sparc64: sparc64 camellia opcodes not available.
[1319855.536539] aes_sparc64: sparc64 aes opcodes not available.
[1319855.537704] des_sparc64: sparc64 des opcodes not available.
[1319855.543054] crc32c_sparc64: sparc64 crc32c opcode not available.
[1319855.544374] aes_sparc64: sparc64 aes opcodes not available.
[1319855.545533] des_sparc64: sparc64 des opcodes not available.
[1319855.558860] sha1_sparc64: sparc64 sha1 opcode not available.
[1319855.559548] sha1_sparc64: sparc64 sha1 opcode not available.
[1319855.560561] sha256_sparc64: sparc64 sha256 opcode not available.
[1319855.561565] sha512_sparc64: sparc64 sha512 opcode not available.
[1319855.562570] md5_sparc64: sparc64 md5 opcode not available.
[1319855.564267] sha1_sparc64: sparc64 sha1 opcode not available.
[1319855.565283] sha256_sparc64: sparc64 sha256 opcode not available.
[1319855.565943] sha1_sparc64: sparc64 sha1 opcode not available.
[1319855.567657] sha1_sparc64: sparc64 sha1 opcode not available.
[1319855.568694] sha256_sparc64: sparc64 sha256 opcode not available.
[1319855.570376] sha1_sparc64: sparc64 sha1 opcode not available.
[1319855.572053] sha256_sparc64: sparc64 sha256 opcode not available.
[1319855.572527] camellia_sparc64: sparc64 camellia opcodes not available.
[1319855.573221] camellia_sparc64: sparc64 camellia opcodes not available.
[1319855.574240] crc32c_sparc64: sparc64 crc32c opcode not available.
[1319855.576180] crc32c_sparc64: sparc64 crc32c opcode not available.
[1319855.577630] crc32c_sparc64: sparc64 crc32c opcode not available.
[1319855.578555] camellia_sparc64: sparc64 camellia opcodes not available.
[1319855.579746] sha256_sparc64: sparc64 sha256 opcode not available.
[1319855.580666] sha512_sparc64: sparc64 sha512 opcode not available.
[1319855.582066] aes_sparc64: sparc64 aes opcodes not available.
[1319855.587371] sha512_sparc64: sparc64 sha512 opcode not available.
[1319855.588770] aes_sparc64: sparc64 aes opcodes not available.
[1319855.589846] des_sparc64: sparc64 des opcodes not available.
[1319855.592041] sha512_sparc64: sparc64 sha512 opcode not available.
[1319855.593427] aes_sparc64: sparc64 aes opcodes not available.
[1319855.594504] des_sparc64: sparc64 des opcodes not available.
[1319855.596260] crc32c_sparc64: sparc64 crc32c opcode not available.
[1319855.599670] sha256_sparc64: sparc64 sha256 opcode not available.
[1319855.600587] sha512_sparc64: sparc64 sha512 opcode not available.
[1319855.601977] aes_sparc64: sparc64 aes opcodes not available.
[1319855.605691] sha1_sparc64: sparc64 sha1 opcode not available.
[1319855.606609] sha256_sparc64: sparc64 sha256 opcode not available.
[1319855.607765] sha512_sparc64: sparc64 sha512 opcode not available.
[1319855.609167] aes_sparc64: sparc64 aes opcodes not available.
[1319855.610607] camellia_sparc64: sparc64 camellia opcodes not available.
[1319855.613698] sha1_sparc64: sparc64 sha1 opcode not available.
[1319855.617318] sha1_sparc64: sparc64 sha1 opcode not available.
[1319855.618629] sha512_sparc64: sparc64 sha512 opcode not available.
[1319855.619743] sha1_sparc64: sparc64 sha1 opcode not available.
[1319855.621939] aes_sparc64: sparc64 aes opcodes not available.
[1319855.624117] aes_sparc64: sparc64 aes opcodes not available.
[1319855.625932] crc32c_sparc64: sparc64 crc32c opcode not available.
[1319855.628299] crc32c_sparc64: sparc64 crc32c opcode not available.
[1319855.632205] crc32c_sparc64: sparc64 crc32c opcode not available.
[1319855.633276] crc32c_sparc64: sparc64 crc32c opcode not available.
[1319855.634643] crc32c_sparc64: sparc64 crc32c opcode not available.
[1319855.636178] md5_sparc64: sparc64 md5 opcode not available.
[1319855.637193] aes_sparc64: sparc64 aes opcodes not available.
[1319855.638295] des_sparc64: sparc64 des opcodes not available.
[1319855.639974] des_sparc64: sparc64 des opcodes not available.
[1319855.640933] camellia_sparc64: sparc64 camellia opcodes not available.
[1319855.645572] sha1_sparc64: sparc64 sha1 opcode not available.
[1319855.649395] sha1_sparc64: sparc64 sha1 opcode not available.
[1319855.652946] camellia_sparc64: sparc64 camellia opcodes not available.
[1319855.654450] crc32c_sparc64: sparc64 crc32c opcode not available.
[1319855.662816] md5_sparc64: sparc64 md5 opcode not available.
[1319855.664525] aes_sparc64: sparc64 aes opcodes not available.
[1319855.665612] des_sparc64: sparc64 des opcodes not available.
[1319855.671589] sha1_sparc64: sparc64 sha1 opcode not available.
[1319855.672647] sha256_sparc64: sparc64 sha256 opcode not available.
[1319855.673232] sha1_sparc64: sparc64 sha1 opcode not available.
[1319855.674198] sha256_sparc64: sparc64 sha256 opcode not available.
[1319855.676941] sha1_sparc64: sparc64 sha1 opcode not available.
[1319855.677913] sha256_sparc64: sparc64 sha256 opcode not available.
[1319855.678408] sha512_sparc64: sparc64 sha512 opcode not available.
[1319855.679741] sha512_sparc64: sparc64 sha512 opcode not available.
[1319855.680658] md5_sparc64: sparc64 md5 opcode not available.
[1319855.681742] aes_sparc64: sparc64 aes opcodes not available.
[1319855.683997] md5_sparc64: sparc64 md5 opcode not available.
[1319855.685031] aes_sparc64: sparc64 aes opcodes not available.
[1319855.811547] sha512_sparc64: sparc64 sha512 opcode not available.
[1319855.812465] md5_sparc64: sparc64 md5 opcode not available.
[1319855.813399] aes_sparc64: sparc64 aes opcodes not available.
[1319855.815783] sha1_sparc64: sparc64 sha1 opcode not available.
[1319855.816662] sha256_sparc64: sparc64 sha256 opcode not available.
[1319855.823903] sha1_sparc64: sparc64 sha1 opcode not available.
[1319855.824781] sha512_sparc64: sparc64 sha512 opcode not available.
[1319855.825637] md5_sparc64: sparc64 md5 opcode not available.
[1319855.826234] sha512_sparc64: sparc64 sha512 opcode not available.
[1319855.828253] sha512_sparc64: sparc64 sha512 opcode not available.
[1319855.829112] md5_sparc64: sparc64 md5 opcode not available.
[1319855.829538] des_sparc64: sparc64 des opcodes not available.
[1319855.830244] camellia_sparc64: sparc64 camellia opcodes not available.
[1319855.831743] camellia_sparc64: sparc64 camellia opcodes not available.
[1319855.832585] crc32c_sparc64: sparc64 crc32c opcode not available.
[1319855.833710] crc32c_sparc64: sparc64 crc32c opcode not available.
[1319855.834564] camellia_sparc64: sparc64 camellia opcodes not available.
[1319855.836071] md5_sparc64: sparc64 md5 opcode not available.
[1319855.837015] aes_sparc64: sparc64 aes opcodes not available.
[1319855.838041] des_sparc64: sparc64 des opcodes not available.
[1319855.840023] sha512_sparc64: sparc64 sha512 opcode not available.
[1319855.840855] md5_sparc64: sparc64 md5 opcode not available.
[1319855.841790] aes_sparc64: sparc64 aes opcodes not available.
[1319855.844109] sha256_sparc64: sparc64 sha256 opcode not available.
[1319855.844957] sha512_sparc64: sparc64 sha512 opcode not available.
[1319855.845791] md5_sparc64: sparc64 md5 opcode not available.
[1319855.848108] crc32c_sparc64: sparc64 crc32c opcode not available.
[1319855.852747] sha1_sparc64: sparc64 sha1 opcode not available.
[1319855.855671] sha1_sparc64: sparc64 sha1 opcode not available.
[1319855.856571] sha256_sparc64: sparc64 sha256 opcode not available.
[1319855.859907] sha1_sparc64: sparc64 sha1 opcode not available.
[1319855.860813] sha256_sparc64: sparc64 sha256 opcode not available.
[1319855.861711] sha512_sparc64: sparc64 sha512 opcode not available.
[1319855.862569] crc32c_sparc64: sparc64 crc32c opcode not available.
[1319855.867466] md5_sparc64: sparc64 md5 opcode not available.
[1319855.867833] des_sparc64: sparc64 des opcodes not available.
[1319855.868495] des_sparc64: sparc64 des opcodes not available.
[1319855.869402] camellia_sparc64: sparc64 camellia opcodes not available.
[1319855.871689] aes_sparc64: sparc64 aes opcodes not available.
[1319855.872335] aes_sparc64: sparc64 aes opcodes not available.
[1319855.873358] des_sparc64: sparc64 des opcodes not available.
[1319855.874412] aes_sparc64: sparc64 aes opcodes not available.
[1319855.876265] des_sparc64: sparc64 des opcodes not available.
[1319855.877627] des_sparc64: sparc64 des opcodes not available.
[1319855.879425] camellia_sparc64: sparc64 camellia opcodes not available.
[1319855.880033] camellia_sparc64: sparc64 camellia opcodes not available.
[1319855.880964] crc32c_sparc64: sparc64 crc32c opcode not available.
[1319855.881816] camellia_sparc64: sparc64 camellia opcodes not available.
[1319855.882666] crc32c_sparc64: sparc64 crc32c opcode not available.
[1319855.885171] sha256_sparc64: sparc64 sha256 opcode not available.
[1319855.886023] sha512_sparc64: sparc64 sha512 opcode not available.
[1319855.887747] sha512_sparc64: sparc64 sha512 opcode not available.
[1319855.889145] camellia_sparc64: sparc64 camellia opcodes not available.
[1319855.890022] crc32c_sparc64: sparc64 crc32c opcode not available.
[1319855.891945] aes_sparc64: sparc64 aes opcodes not available.
[1319855.892976] des_sparc64: sparc64 des opcodes not available.
[1319855.893877] camellia_sparc64: sparc64 camellia opcodes not available.
[1319855.894721] crc32c_sparc64: sparc64 crc32c opcode not available.
[1319855.899338] sha1_sparc64: sparc64 sha1 opcode not available.
[1319855.899716] md5_sparc64: sparc64 md5 opcode not available.
[1319855.900286] md5_sparc64: sparc64 md5 opcode not available.
[1319855.901239] aes_sparc64: sparc64 aes opcodes not available.
[1319855.902327] des_sparc64: sparc64 des opcodes not available.
[1319855.904495] sha256_sparc64: sparc64 sha256 opcode not available.
[1319855.905355] sha512_sparc64: sparc64 sha512 opcode not available.
[1319855.906214] md5_sparc64: sparc64 md5 opcode not available.
[1319855.909852] sha1_sparc64: sparc64 sha1 opcode not available.
[1319855.910711] sha256_sparc64: sparc64 sha256 opcode not available.
[1319855.912074] aes_sparc64: sparc64 aes opcodes not available.
[1319855.913160] des_sparc64: sparc64 des opcodes not available.
[1319855.916939] sha1_sparc64: sparc64 sha1 opcode not available.
[1319855.922646] sha512_sparc64: sparc64 sha512 opcode not available.
[1319855.926723] md5_sparc64: sparc64 md5 opcode not available.
[1319855.936118] camellia_sparc64: sparc64 camellia opcodes not available.
[1319855.938171] aes_sparc64: sparc64 aes opcodes not available.
[1319855.939659] aes_sparc64: sparc64 aes opcodes not available.
[1319855.940989] camellia_sparc64: sparc64 camellia opcodes not available.
[1319855.942294] aes_sparc64: sparc64 aes opcodes not available.
[1319855.954286] crc32c_sparc64: sparc64 crc32c opcode not available.
[1319855.968193] sha512_sparc64: sparc64 sha512 opcode not available.
[1319855.970122] md5_sparc64: sparc64 md5 opcode not available.
[1319855.972440] des_sparc64: sparc64 des opcodes not available.
[1319855.977161] camellia_sparc64: sparc64 camellia opcodes not available.
[1319855.985376] sha1_sparc64: sparc64 sha1 opcode not available.
[1319855.986261] sha256_sparc64: sparc64 sha256 opcode not available.
[1319855.991487] sha1_sparc64: sparc64 sha1 opcode not available.
[1319855.992424] sha256_sparc64: sparc64 sha256 opcode not available.
[1319856.001376] camellia_sparc64: sparc64 camellia opcodes not available.
[1319856.002697] sha512_sparc64: sparc64 sha512 opcode not available.
[1319856.004511] sha1_sparc64: sparc64 sha1 opcode not available.
[1319856.005381] sha256_sparc64: sparc64 sha256 opcode not available.
[1319856.024358] md5_sparc64: sparc64 md5 opcode not available.
[1319856.040370] camellia_sparc64: sparc64 camellia opcodes not available.
[1319856.057409] sha1_sparc64: sparc64 sha1 opcode not available.
[1319856.081121] sha512_sparc64: sparc64 sha512 opcode not available.
[1319856.082279] sha512_sparc64: sparc64 sha512 opcode not available.
[1319856.100353] des_sparc64: sparc64 des opcodes not available.
[1319856.118773] aes_sparc64: sparc64 aes opcodes not available.
[1319856.132794] crc32c_sparc64: sparc64 crc32c opcode not available.
[1319856.136826] crc32c_sparc64: sparc64 crc32c opcode not available.
[1319856.378441] camellia_sparc64: sparc64 camellia opcodes not available.
[1319856.379529] aes_sparc64: sparc64 aes opcodes not available.
[1319856.415839] des_sparc64: sparc64 des opcodes not available.
[1319856.416934] des_sparc64: sparc64 des opcodes not available.
[1319856.417846] camellia_sparc64: sparc64 camellia opcodes not available.
[1319856.434037] des_sparc64: sparc64 des opcodes not available.
[1319856.441206] md5_sparc64: sparc64 md5 opcode not available.
[1319856.444879] sha512_sparc64: sparc64 sha512 opcode not available.
[1319856.445748] md5_sparc64: sparc64 md5 opcode not available.
[1319856.708149] des_sparc64: sparc64 des opcodes not available.
[1319856.709084] camellia_sparc64: sparc64 camellia opcodes not available.
[  OK  ] Found device 82571EB Gigabit Ethernet Controller.
[1319857.182596] sr 0:0:0:0: Attached scsi generic sg0 type 5
[1319857.184798] sd 1:0:0:0: Attached scsi generic sg1 type 0
[1319857.185285] sd 1:0:1:0: Attached scsi generic sg2 type 0
[1319857.199084] des_sparc64: sparc64 des opcodes not available.
[1319857.220751] camellia_sparc64: sparc64 camellia opcodes not available.
[1319857.391262] aes_sparc64: sparc64 aes opcodes not available.
[1319857.398991] des_sparc64: sparc64 des opcodes not available.
[1319857.404925] camellia_sparc64: sparc64 camellia opcodes not available.
[  OK  ] Found device ST914602SSUN146G 1.
         Starting File System Check on /dev/sdb1...
[  OK  ] Started File System Check Daemon to report status.
[  OK  ] Started File System Check on /dev/sdb1.
         Mounting /boot...
[1319857.971392] EXT4-fs (sdb1): mounting ext2 file system using the ext4 subsystem
[1319857.990574] EXT4-fs (sdb1): mounted filesystem without journal. Opts: (null)
[  OK  ] Mounted /boot.
[  OK  ] Reached target Local File Systems.
[  OK  ] Started ifup for enp8s0f0.
         Starting Create Volatile Files and Directories...
         Starting Raise network interfaces...
[  OK  ] Started Create Volatile Files and Directories.
         Starting Update UTMP about System Boot/Shutdown...
         Starting Network Time Synchronization...
[1319858.528797] IPv6: ADDRCONF(NETDEV_UP): enp8s0f0: link is not ready
[  OK  ] Started Update UTMP about System Boot/Shutdown.
[  OK  ] Started Network Time Synchronization.
[  OK  ] Reached target System Time Synchronized.
         Starting LSB: NFS support files common to client and server...
[  OK  ] Started LSB: NFS support files common to client and server.
[1319859.804939] e1000e: enp8s0f0 NIC Link is Up 100 Mbps Full Duplex, Flow Control: None
[1319859.805254] e1000e 0000:08:00.0 enp8s0f0: 10/100 speed: disabling TSO
[1319859.805531] IPv6: ADDRCONF(NETDEV_CHANGE): enp8s0f0: link becomes ready
[  OK  ] Started Raise network interfaces.
[  OK  ] Reached target Network.
[  OK  ] Reached target Network is Online.
[1319860.393660] kernel BUG at mm/slab.c:3058!
[1319860.393783]               \|/ ____ \|/
[1319860.393783]               "@'/ .. \`@"
[1319860.393783]               /_| \__/ |_\
[1319860.393783]                  \__U_/
[1319860.394094] systemd-journal(194): Kernel bad sw trap 5 [#1]
[1319860.394236] CPU: 0 PID: 194 Comm: systemd-journal Tainted: G        W       4.6.0+ #1
[1319860.394326] task: ffff8003eee8d280 ti: ffff8003f25b0000 task.ti: ffff8003f25b0000
[1319860.394415] TSTATE: 0000004411e01605 TPC: 00000000005bdd94 TNPC: 00000000005bdd98 Y: 00000000    Tainted: G        W      
[1319860.394530] TPC: <cache_alloc_refill+0x574/0x7e0>
[1319860.394582] g0: 0000000000c30800 g1: 0000000000c14614 g2: 0000000000000000 g3: 000000000000000e
[1319860.394672] g4: ffff8003eee8d280 g5: ffff8003fe3f0000 g6: ffff8003f25b0000 g7: 0000000000000362
[1319860.394761] o0: 0000000000a5e880 o1: 0000000000000bf2 o2: 0000000000000001 o3: ffff8003eeb0c000
[1319860.394849] o4: 000000001061751c o5: 0000600008e13f28 sp: ffff8003f25b2991 ret_pc: 00000000005bdd8c
[1319860.394940] RPC: <cache_alloc_refill+0x56c/0x7e0>
[1319860.394994] l0: 0000000000000055 l1: ffff8003eeee0068 l2: ffff80000d1f6580 l3: 0000000000000000
[1319860.395084] l4: 00005fffff80af50 l5: 0000000000afa400 l6: ffff8003f25b3fe0 l7: ffff8003f25b3fe8
[1319860.395173] i0: ffff8003eeb25560 i1: 0000000002400c40 i2: 0000000000000002 i3: ffff8003fe3f0000
[1319860.395261] i4: 0000dffc0141af50 i5: 0000000000000000 i6: ffff8003f25b2a41 i7: 00000000005be3e4
[1319860.395352] I7: <kmem_cache_alloc+0x1e4/0x200>
[1319860.395401] Call Trace:
[1319860.395452]  [00000000005be3e4] kmem_cache_alloc+0x1e4/0x200
[1319860.395566]  [00000000105e4c50] jbd2_alloc+0x110/0x160 [jbd2]
[1319860.395657]  [00000000105d9fa0] do_get_write_access+0x220/0x540 [jbd2]
[1319860.395749]  [00000000105da338] jbd2_journal_get_write_access+0x78/0xc0 [jbd2]
[1319860.396009]  [000000001064ae60] __ext4_journal_get_write_access+0x20/0x60 [ext4]
[1319860.396177]  [0000000010612e48] ext4_reserve_inode_write+0x68/0xa0 [ext4]
[1319860.396326]  [0000000010612eac] ext4_mark_inode_dirty+0x2c/0x280 [ext4]
[1319860.396474]  [000000001061751c] ext4_dirty_inode+0x3c/0x80 [ext4]
[1319860.396555]  [0000000000606b7c] __mark_inode_dirty+0x3c/0x420
[1319860.396633]  [00000000005f2f38] generic_update_time+0x98/0xe0
[1319860.396705]  [00000000005f30a0] file_update_time+0xa0/0x120
[1319860.396849]  [0000000010617794] ext4_page_mkwrite+0x34/0x4e0 [ext4]
[1319860.396935]  [00000000005944e8] do_page_mkwrite+0x68/0x100
[1319860.397011]  [0000000000595c50] do_wp_page+0x230/0x820
[1319860.397081]  [000000000059988c] handle_mm_fault+0xd6c/0x1760
[1319860.397153]  [0000000000981d9c] do_sparc64_fault+0x59c/0x9c0
[1319860.397217] Disabling lock debugging due to kernel taint
[1319860.397286] Caller[00000000005be3e4]: kmem_cache_alloc+0x1e4/0x200
[1319860.397374] Caller[00000000105e4c50]: jbd2_alloc+0x110/0x160 [jbd2]
[1319860.397465] Caller[00000000105d9fa0]: do_get_write_access+0x220/0x540 [jbd2]
[1319860.397575] Caller[00000000105da338]: jbd2_journal_get_write_access+0x78/0xc0 [jbd2]
[1319860.397742] Caller[000000001064ae60]: __ext4_journal_get_write_access+0x20/0x60 [ext4]
[1319860.397911] Caller[0000000010612e48]: ext4_reserve_inode_write+0x68/0xa0 [ext4]
[1319860.398078] Caller[0000000010612eac]: ext4_mark_inode_dirty+0x2c/0x280 [ext4]
[1319860.398245] Caller[000000001061751c]: ext4_dirty_inode+0x3c/0x80 [ext4]
[1319860.398321] Caller[0000000000606b7c]: __mark_inode_dirty+0x3c/0x420
[1319860.398396] Caller[00000000005f2f38]: generic_update_time+0x98/0xe0
[1319860.398470] Caller[00000000005f30a0]: file_update_time+0xa0/0x120
[1319860.398615] Caller[0000000010617794]: ext4_page_mkwrite+0x34/0x4e0 [ext4]
[1319860.398695] Caller[00000000005944e8]: do_page_mkwrite+0x68/0x100
[1319860.398770] Caller[0000000000595c50]: do_wp_page+0x230/0x820
[1319860.398842] Caller[000000000059988c]: handle_mm_fault+0xd6c/0x1760
[1319860.398912] Caller[0000000000981d9c]: do_sparc64_fault+0x59c/0x9c0
[1319860.398985] Caller[0000000000407c50]: sparc64_realfault_common+0x10/0x20
[1319860.399054] Caller[000001000001a1d0]: 0x1000001a1d0
[1319860.399115] Instruction DUMP: 92102bf2  7ff9a765  90122080 <91d02005> 83306000  8530e000  8220400a  83287003  8528b003 
[1319860.408922] systemd[1]: systemd-journald.service: Failed with result 'signal'.
[1319860.409343] systemd[1]: systemd-journald.service: Service has no hold-off time, scheduling restart.
[1319860.419436] systemd[1]: Stopped Flush Journal to Persistent Storage.
[  OK  ] Stopped Flush Journal to Persistent Storage.
[1319860.420042] systemd[1]: Stopping Flush Journal to Persistent Storage...
         Stopping Flush Journal to Persistent Storage...
[1319860.420536] systemd[1]: Stopped Journal Service.
[  OK  ] Stopped Journal Service.
[1319860.660416] systemd[1]: Starting Journal Service...
         Starting Journal Service...
[1319860.734187] systemd[1]: Found device /dev/vg1/swap_1.
[  OK  ] Found device /dev/vg1/swap_1.
[1319860.965407] systemd[1]: Started MD array monitor.
[  OK  ] Started MD array monitor.
[1319860.978255] systemd[1]: Activating swap /dev/vg1/swap_1...
         Activating swap /dev/vg1/swap_1...
[1319861.037462] Adding 5836792k swap on /dev/mapper/vg1-swap_1.  Priority:-1 extents:1 across:5836792k FS
[1319861.061826] systemd[1]: Activated swap /dev/vg1/swap_1.
[  OK  ] Activated swap /dev/vg1/swap_1.
[1319861.079894] systemd[1]: Reached target Swap.
[  OK  ] Reached target Swap.
[*     ] A start job is running for Journal Service (33s / 1min 30s)
