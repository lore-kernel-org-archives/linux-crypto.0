From: Anatoly Pugachev <matorola@gmail.com>
Subject: Re: [crypto / sparc64] cryptomgr_test OOPS
Date: Thu, 5 May 2016 12:40:18 +0300
Message-ID: <CADxRZqwxB-+DTV-qKFK6CVXwVV0h9yDkH6GxcjmA-M9KY2HM7g@mail.gmail.com>
References: <20160503.123301.298039059390449291.davem@davemloft.net>
	<20160504040731.GA25758@gondor.apana.org.au>
	<CADxRZqws2yAMSqeMDYb6w6OUXJMMbv9wMaY7Zc6YX+szk2vO3g@mail.gmail.com>
	<20160505084249.GA4971@gondor.apana.org.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Cc: David Miller <davem@davemloft.net>, linux-crypto@vger.kernel.org,
	sparclinux@vger.kernel.org, Nicolai Stange <nicstange@gmail.com>
To: Herbert Xu <herbert@gondor.apana.org.au>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-vk0-f66.google.com ([209.85.213.66]:34370 "EHLO
	mail-vk0-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756489AbcEEJkT (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Thu, 5 May 2016 05:40:19 -0400
In-Reply-To: <20160505084249.GA4971@gondor.apana.org.au>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Thu, May 5, 2016 at 11:42 AM, Herbert Xu <herbert@gondor.apana.org.au> wrote:
> On Wed, May 04, 2016 at 05:49:04PM +0300, Anatoly Pugachev wrote:
>>
>> just tested cryptodev (
>> http://git.kernel.org/pub/scm/linux/kernel/git/herbert/cryptodev-2.6.git
>> ) kernel, same OOPS, but kernel version is 4.6.0-rc2+ .
>> kernel OOPS message - https://paste.fedoraproject.org/362554/23732641/
>
> Anatoly, could you please test this patch on top of cryptodev?

Herbert,

sure, based on your cryptodev git, just tried 4.3 (6a13feb , good)
kernel in attempt to find (bisect) when RSA code break, already tested
4.5 (44d1b6d , bad) , 4.4 (afd2ff9 , bad).
Going to try your patch soon (when I'm back home).
So far 4.3 passes RSA stage without OOPS, but for other reason does
not boot to login prompt. Boot log exempt (4.3), this is with
CONFIG_CRYPTO_RSA=y :

[    0.000000] PROMLIB: Sun IEEE Boot Prom 'OBP 4.38.3 2015/11/11 10:38'
[    0.000000] PROMLIB: Root node compatible: sun4v
[    0.000000] Initializing cgroup subsys cpuset
[    0.000000] Initializing cgroup subsys cpu
[    0.000000] Initializing cgroup subsys cpuacct
[    0.000000] Linux version 4.3.0+ (mator@ttip) (gcc version 6.0.1
20160423 (prerelease) (Debian 6.0.1-2) ) #4 SMP Thu May 5 05:26:2
8 EDT 2016
[    0.000000] debug: skip boot console de-registration.
[    0.000000] bootconsole [earlyprom0] enabled
[    0.000000] ARCH: SUN4V
[    0.000000] Ethernet address: 00:14:4f:f8:be:54
[    0.000000] MM: PAGE_OFFSET is 0xfff8000000000000 (max_phys_bits == 47)
[    0.000000] MM: VMALLOC [0x0000000100000000 --> 0x0006000000000000]
[    0.000000] MM: VMEMMAP [0x0006000000000000 --> 0x000c000000000000]
[    0.000000] Kernel: Using 3 locked TLB entries for main kernel image.
[    0.000000] Remapping the kernel... done.
[    0.000000] OF stdout device is: /virtual-devices@100/console@1
[    0.000000] PROM: Built device tree with 76231 bytes of memory.
[    0.000000] MDESC: Size is 35264 bytes.
[    0.000000] PLATFORM: banner-name [SPARC T5-2]
[    0.000000] PLATFORM: name [ORCL,SPARC-T5-2]
[    0.000000] PLATFORM: hostid [84f8be54]
[    0.000000] PLATFORM: serial# [0035260e]
[    0.000000] PLATFORM: stick-frequency [3b9aca00]
[    0.000000] PLATFORM: mac-address [144ff8be54]
[    0.000000] PLATFORM: watchdog-resolution [1000 ms]
[    0.000000] PLATFORM: watchdog-max-timeout [31536000000 ms]
[    0.000000] PLATFORM: max-cpus [1024]
[    0.000000] Top of RAM: 0x20afff0000, Total RAM: 0x2ffa06000
[    0.000000] Memory hole size: 121605MB
[    0.000000] Allocated 32768 bytes for kernel page tables.
[    0.000000] Zone ranges:
[    0.000000]   Normal   [mem 0x0000000030400000-0x00000020affeffff]
[    0.000000] Movable zone start for each node
[    0.000000] Early memory node ranges
[    0.000000]   node   0: [mem 0x0000000030400000-0x000000006fe7ffff]
[    0.000000]   node   0: [mem 0x000000006ff00000-0x000000006ff25fff]
[    0.000000]   node   0: [mem 0x0000000070000000-0x00000002afffffff]
[    0.000000]   node   0: [mem 0x0000002030000000-0x00000020aff3ffff]
[    0.000000]   node   0: [mem 0x00000020affc0000-0x00000020affd5fff]
[    0.000000]   node   0: [mem 0x00000020affe6000-0x00000020affeffff]
[    0.000000] Initmem setup node 0 [mem 0x0000000030400000-0x00000020affeffff]
[    0.000000] Booting Linux...
[    0.000000] CPU CAPS: [flush,stbar,swap,muldiv,v9,blkinit,n2,mul32]
[    0.000000] CPU CAPS: [div32,v8plus,popc,vis,vis2,ASIBlkInit,fmaf,vis3]
[    0.000000] CPU CAPS: [hpc,ima,pause,cbcond,aes,des,kasumi,camellia]
[    0.000000] CPU CAPS: [md5,sha1,sha256,sha512,mpmul,montmul,montsqr,crc32c]
[    0.000000] PERCPU: Embedded 8 pages/cpu @fff80020ae400000 s28184
r8192 d29160 u65536
[    0.000000] SUN4V: Mondo queue sizes [cpu(131072) dev(16384) r(8192) nr(256)]
[    0.000000] Built 1 zonelists in Zone order, mobility grouping on.
Total pages: 1558281
[    0.000000] Kernel command line: root=/dev/vdiska2 ro keep_bootcon
noresume debug loglevel=7
[    0.000000] log_buf_len individual max cpu contribution: 4096 bytes
[    0.000000] log_buf_len total cpu_extra contributions: 1044480 bytes
[    0.000000] log_buf_len min size: 131072 bytes
[    0.000000] log_buf_len: 2097152 bytes
[    0.000000] early log buf free: 126168(96%)
[    0.000000] PID hash table entries: 4096 (order: 2, 32768 bytes)
[    0.000000] Dentry cache hash table entries: 2097152 (order: 11,
16777216 bytes)
[    0.000000] Inode-cache hash table entries: 1048576 (order: 10,
8388608 bytes)
[    0.000000] Sorting __ex_table...
[    0.000000] Memory: 12364272K/12576792K available (5381K kernel
code, 702K rwdata, 1424K rodata, 440K init, 747K bss, 212520K rese
rved, 0K cma-reserved)
[    0.000000] Hierarchical RCU implementation.
[    0.000000]  Build-time adjustment of leaf fanout to 64.
[    0.000000] NR_IRQS:2048 nr_irqs:2048 1
[    0.000000] SUN4V: Using IRQ API major 3, cookie only virqs enabled
[5664484.612319] clocksource: stick: mask: 0xffffffffffffffff
max_cycles: 0x1cd42e4dffb, max_idle_ns: 881590591483 ns
[5664484.612410] clocksource: mult[800000] shift[23]
[5664484.612453] clockevent: mult[80000000] shift[31]
[5664484.613868] Console: colour dummy device 80x25
[5664484.613915] console [tty0] enabled
[5664484.705131] Calibrating delay using timer specific routine..
2001.42 BogoMIPS (lpj=4002844)
[5664484.705214] pid_max: default: 262144 minimum: 2048
[5664484.705712] Security Framework initialized
[5664484.705757] Yama: becoming mindful.
[5664484.705801] AppArmor: AppArmor disabled by boot time parameter
[5664484.706096] Mount-cache hash table entries: 32768 (order: 5, 262144 bytes)
[5664484.706162] Mountpoint-cache hash table entries: 32768 (order: 5,
262144 bytes)
[5664484.707010] Initializing cgroup subsys io
[5664484.707062] Initializing cgroup subsys memory
[5664484.707169] Initializing cgroup subsys devices
[5664484.707216] Initializing cgroup subsys freezer
[5664484.707262] Initializing cgroup subsys net_cls
[5664484.707308] Initializing cgroup subsys perf_event
[5664484.707361] Initializing cgroup subsys net_prio
[5664484.707406] Initializing cgroup subsys pids
[5664484.707528] ftrace: allocating 17874 entries in 35 pages
[5664484.728490] Brought up 32 CPUs
[5664484.729958] devtmpfs: initialized
[5664484.731055] Performance events:
[5664484.731109] Testing NMI watchdog ... OK.
[5664484.811243] Supported PMU type is 'niagara5'
[5664484.857536] ldc.c:v1.1 (July 22, 2008)
[5664484.857924] clocksource: jiffies: mask: 0xffffffff max_cycles:
0xffffffff, max_idle_ns: 7645041785100000 ns
[5664484.859295] NET: Registered protocol family 16
[5664484.861480] VIO: Adding device channel-devices
[5664484.861591] VIO: Adding device vnet-port-0-0
[5664484.861689] VIO: Adding device vnet-port-0-1
[5664484.861784] VIO: Adding device vnet-port-0-2
[5664484.861879] VIO: Adding device vnet-port-0-3
[5664484.861986] VIO: Adding device vnet-port-0-4
[5664484.862095] VIO: Adding device vnet-port-0-5
[5664484.862204] VIO: Adding device vdc-port-0-0
[5664484.862313] VIO: Adding device vdc-port-1-0
[5664484.862423] VIO: Adding device vlds-port-0-0
[5664484.862537] VIO: Adding device ds-0
[5664484.887582] vgaarb: loaded
[5664484.888156] SUN4V: Reboot data supported (maj=1,min=0).
[5664484.888252] ds.c:v1.0 (Jul 11, 2007)
[5664484.888413] ds-0: ds_conn_reset() from send_events
[5664484.888574] clocksource: Switched to clocksource stick
[5664484.907509] NET: Registered protocol family 2
[5664484.908786] TCP established hash table entries: 131072 (order: 7,
1048576 bytes)
[5664484.909367] TCP bind hash table entries: 65536 (order: 7, 1048576 bytes)
[5664484.909935] TCP: Hash tables configured (established 131072 bind 65536)
[5664484.910043] UDP hash table entries: 8192 (order: 5, 262144 bytes)
[5664484.910229] UDP-Lite hash table entries: 8192 (order: 5, 262144 bytes)
[5664484.911380] NET: Registered protocol family 1
[5664484.911536] Unpacking initramfs...
[5664485.168111] Freeing initrd memory: 12856K (fff8002034000000 -
fff8002034c8e000)
[5664485.175591] futex hash table entries: 65536 (order: 9, 4194304 bytes)
[5664485.176769] audit: initializing netlink subsys (disabled)
[5664485.176857] audit: type=2000 audit(0.472:1): initialized
[5664485.177082] Initialise system trusted keyring
[5664485.177318] HugeTLB registered 8 MB page size, pre-allocated 0 pages
[5664485.177453] zbud: loaded
[5664485.177840] VFS: Disk quotas dquot_6.6.0
[5664485.178033] VFS: Dquot-cache hash table entries: 1024 (order 0, 8192 bytes)
[5664485.218487] alg: rsa: test failed on vector 2, err=-76
[5664485.219462] Key type asymmetric registered
[5664485.219513] Asymmetric key parser 'x509' registered
[5664485.219583] Block layer SCSI generic (bsg) driver version 0.4
loaded (major 252)
[5664485.220292] io scheduler noop registered
[5664485.220341] io scheduler deadline registered
[5664485.220467] io scheduler cfq registered (default)
[5664485.220950] f029b808: ttyS0 at I/O 0x0 (irq = 1, base_baud =
115200) is a SUN4V HCONS
[5664485.221197] console [ttyHV0] enabled


Thanks.
