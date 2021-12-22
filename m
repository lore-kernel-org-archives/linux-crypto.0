Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 31E0CC433F5
	for <linux-crypto@archiver.kernel.org>; Wed, 22 Dec 2021 10:23:18 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238918AbhLVKXR (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Wed, 22 Dec 2021 05:23:17 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33994 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234558AbhLVKXR (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 22 Dec 2021 05:23:17 -0500
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D50A4C061574
        for <linux-crypto@vger.kernel.org>; Wed, 22 Dec 2021 02:23:16 -0800 (PST)
Received: from drehscheibe.grey.stw.pengutronix.de ([2a0a:edc0:0:c01:1d::a2])
        by metis.ext.pengutronix.de with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <ukl@pengutronix.de>)
        id 1mzym6-0005Jz-Ki; Wed, 22 Dec 2021 11:23:10 +0100
Received: from [2a0a:edc0:0:900:1d::77] (helo=ptz.office.stw.pengutronix.de)
        by drehscheibe.grey.stw.pengutronix.de with esmtps  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <ukl@pengutronix.de>)
        id 1mzym2-005z8b-VW; Wed, 22 Dec 2021 11:23:06 +0100
Received: from ukl by ptz.office.stw.pengutronix.de with local (Exim 4.92)
        (envelope-from <ukl@pengutronix.de>)
        id 1mzym1-0004If-U3; Wed, 22 Dec 2021 11:23:05 +0100
Date:   Wed, 22 Dec 2021 11:22:46 +0100
From:   Uwe =?utf-8?Q?Kleine-K=C3=B6nig?= <u.kleine-koenig@pengutronix.de>
To:     Herbert Xu <herbert@gondor.apana.org.au>
Cc:     Guenter Roeck <linux@roeck-us.net>,
        Linux Crypto Mailing List <linux-crypto@vger.kernel.org>,
        Vladis Dronov <vdronov@redhat.com>,
        Simo Sorce <ssorce@redhat.com>,
        Eric Biggers <ebiggers@kernel.org>, kernel@pengutronixx.de
Subject: Re: [v2 PATCH] crypto: api - Fix built-in testing dependency failures
Message-ID: <20211222102246.qibf7v2q4atl6gc6@pengutronix.de>
References: <20210913071251.GA15235@gondor.apana.org.au>
 <20210917002619.GA6407@gondor.apana.org.au>
 <20211026163319.GA2785420@roeck-us.net>
 <20211106034725.GA18680@gondor.apana.org.au>
 <729fc135-8e55-fd4f-707a-60b9a222ab97@roeck-us.net>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
        protocol="application/pgp-signature"; boundary="45t73oo4egm3ysts"
Content-Disposition: inline
In-Reply-To: <729fc135-8e55-fd4f-707a-60b9a222ab97@roeck-us.net>
X-SA-Exim-Connect-IP: 2a0a:edc0:0:c01:1d::a2
X-SA-Exim-Mail-From: ukl@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-crypto@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org


--45t73oo4egm3ysts
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hello,

I didn't find a more suitable mail to respond to ...

On Sat, Nov 06, 2021 at 07:55:48AM -0700, Guenter Roeck wrote:
> On 11/5/21 8:47 PM, Herbert Xu wrote:
> > On Tue, Oct 26, 2021 at 09:33:19AM -0700, Guenter Roeck wrote:
> > > Hi,
> > >=20
> > > On Fri, Sep 17, 2021 at 08:26:19AM +0800, Herbert Xu wrote:
> > > > When complex algorithms that depend on other algorithms are built
> > > > into the kernel, the order of registration must be done such that
> > > > the underlying algorithms are ready before the ones on top are
> > > > registered.  As otherwise they would fail during the self-test
> > > > which is required during registration.
> > > >=20
> > > > In the past we have used subsystem initialisation ordering to
> > > > guarantee this.  The number of such precedence levels are limited
> > > > and they may cause ripple effects in other subsystems.
> > > >=20
> > > > This patch solves this problem by delaying all self-tests during
> > > > boot-up for built-in algorithms.  They will be tested either when
> > > > something else in the kernel requests for them, or when we have
> > > > finished registering all built-in algorithms, whichever comes
> > > > earlier.
> > > >=20
> > > > Reported-by: Vladis Dronov <vdronov@redhat.com>
> > > > Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
> > > >=20
> > >=20
> > > I can not explain it, but this patch causes a crash with one of my bo=
ot
> > > tests (riscv32 with riscv32 virt machine and e1000 network adapter):
> > >=20
> > > [    9.948557] e1000 0000:00:01.0: enabling device (0000 -> 0003)
> >=20
> > Does this still occur with the latest patch I sent yesterday?
> >=20
>=20
> No, I don't see that problem anymore, neither in mainline with your
> patch applied nor in the latest -next with your patch applied.

I still experience a problem with the patch that got
adad556efcdd42a1d9e060cbe5f6161cccf1fa28 in v5.16-rc1. I saw there are
two commit fixing this one (

	cad439fc040e crypto: api - Do not create test larvals if manager is disabl=
ed
	e42dff467ee6 crypto: api - Export crypto_boot_test_finished

) but I still encounter the following on 2f47a9a4dfa3:

[    0.000000] Booting Linux on physical CPU 0x0
[    0.000000] Linux version 5.16.0-rc6-00031-g2f47a9a4dfa3 (ukl@dude) (arm=
-v7a-linux-gnueabihf-gcc (OSELAS.Toolchain-2018.12.0 8-20181130) 8.2.1 2018=
1130, GNU ld (GNU Binutils) 2.31.1) #17 SMP PREEMPT Wed Dec 22 10:51:46 CET=
 2021
[    0.000000] CPU: ARMv7 Processor [410fc075] revision 5 (ARMv7), cr=3D10c=
5387d
[    0.000000] CPU: div instructions available: patching division code
[    0.000000] CPU: PIPT / VIPT nonaliasing data cache, VIPT aliasing instr=
uction cache
[    0.000000] OF: fdt: Machine model: STMicroelectronics STM32MP157C eval =
daughter on eval mother
[    0.000000] Memory policy: Data cache writealloc
[    0.000000] Reserved memory: created DMA memory pool at 0x10000000, size=
 0 MiB
[    0.000000] OF: reserved mem: initialized node mcuram2@10000000, compati=
ble id shared-dma-pool
[    0.000000] Reserved memory: created DMA memory pool at 0x10040000, size=
 0 MiB
[    0.000000] OF: reserved mem: initialized node vdev0vring0@10040000, com=
patible id shared-dma-pool
[    0.000000] Reserved memory: created DMA memory pool at 0x10041000, size=
 0 MiB
[    0.000000] OF: reserved mem: initialized node vdev0vring1@10041000, com=
patible id shared-dma-pool
[    0.000000] Reserved memory: created DMA memory pool at 0x10042000, size=
 0 MiB
[    0.000000] OF: reserved mem: initialized node vdev0buffer@10042000, com=
patible id shared-dma-pool
[    0.000000] Reserved memory: created DMA memory pool at 0x30000000, size=
 0 MiB
[    0.000000] OF: reserved mem: initialized node mcuram@30000000, compatib=
le id shared-dma-pool
[    0.000000] Reserved memory: created DMA memory pool at 0x38000000, size=
 0 MiB
[    0.000000] OF: reserved mem: initialized node retram@38000000, compatib=
le id shared-dma-pool
[    0.000000] cma: Reserved 16 MiB at 0xfe800000
[    0.000000] Zone ranges:
[    0.000000]   DMA      [mem 0x00000000c0000000-0x00000000e7ffffff]
[    0.000000]   Normal   empty
[    0.000000]   HighMem  [mem 0x00000000e8000000-0x00000000ffffefff]
[    0.000000] Movable zone start for each node
[    0.000000] Early memory node ranges
[    0.000000]   node   0: [mem 0x00000000c0000000-0x00000000e7ffffff]
[    0.000000]   node   0: [mem 0x00000000e8000000-0x00000000efffffff]
[    0.000000]   node   0: [mem 0x00000000f0000000-0x00000000ffffefff]
[    0.000000] Initmem setup node 0 [mem 0x00000000c0000000-0x00000000ffffe=
fff]
[    0.000000] psci: probing for conduit method from DT.
[    0.000000] psci: PSCIv1.1 detected in firmware.
[    0.000000] psci: Using standard PSCI v0.2 function IDs
[    0.000000] psci: MIGRATE_INFO_TYPE not supported.
[    0.000000] psci: SMC Calling Convention v1.2
[    0.000000] percpu: Embedded 16 pages/cpu s35148 r8192 d22196 u65536
[    0.000000] Built 1 zonelists, mobility grouping on.  Total pages: 260703
[    0.000000] Kernel command line: root=3D/dev/nfs nfsroot=3D192.168.23.4:=
/home/ukl/nfsroot/stm32mp157c-ev1,v3,tcp ip=3Ddhcp console=3DttySTM0,115200=
n8 rootwait rw=20
[    0.000000] Dentry cache hash table entries: 131072 (order: 7, 524288 by=
tes, linear)
[    0.000000] Inode-cache hash table entries: 65536 (order: 6, 262144 byte=
s, linear)
[    0.000000] mem auto-init: stack:off, heap alloc:off, heap free:off
[    0.000000] Memory: 874968K/1048572K available (9216K kernel code, 1064K=
 rwdata, 3368K rodata, 1024K init, 200K bss, 157220K reserved, 16384K cma-r=
eserved, 245756K highmem)
[    0.000000] random: get_random_u32 called from cache_random_seq_create+0=
x84/0x15c with crng_init=3D0
[    0.000000] SLUB: HWalign=3D64, Order=3D0-3, MinObjects=3D0, CPUs=3D2, N=
odes=3D1
[    0.000000] ftrace: allocating 34278 entries in 67 pages
[    0.000000] ftrace: allocated 67 pages with 3 groups
[    0.000000] trace event string verifier disabled
[    0.000000] rcu: Preemptible hierarchical RCU implementation.
[    0.000000] rcu: 	RCU restricting CPUs from NR_CPUS=3D4 to nr_cpu_ids=3D=
2.
[    0.000000] 	Trampoline variant of Tasks RCU enabled.
[    0.000000] 	Rude variant of Tasks RCU enabled.
[    0.000000] 	Tracing variant of Tasks RCU enabled.
[    0.000000] rcu: RCU calculated value of scheduler-enlistment delay is 1=
0 jiffies.
[    0.000000] rcu: Adjusting geometry for rcu_fanout_leaf=3D16, nr_cpu_ids=
=3D2
[    0.000000] NR_IRQS: 16, nr_irqs: 16, preallocated irqs: 16
[    0.000000] arch_timer: cp15 timer(s) running at 24.00MHz (virt).
[    0.000000] clocksource: arch_sys_counter: mask: 0xffffffffffffff max_cy=
cles: 0x588fe9dc0, max_idle_ns: 440795202592 ns
[    0.000002] sched_clock: 56 bits at 24MHz, resolution 41ns, wraps every =
4398046511097ns
[    0.000031] Switching to timer-based delay loop, resolution 41ns
[    0.006510] Calibrating delay loop (skipped), value calculated using tim=
er frequency.. 48.00 BogoMIPS (lpj=3D240000)
[    0.006551] pid_max: default: 32768 minimum: 301
[    0.006906] Mount-cache hash table entries: 2048 (order: 1, 8192 bytes, =
linear)
[    0.006943] Mountpoint-cache hash table entries: 2048 (order: 1, 8192 by=
tes, linear)
[    0.008536] CPU: Testing write buffer coherency: ok
[    0.009012] CPU0: update cpu_capacity 1024
[    0.009041] CPU0: thread -1, cpu 0, socket 0, mpidr 80000000
[    0.010632] Setting up static identity map for 0xc0100000 - 0xc0100060
[    0.010866] rcu: Hierarchical SRCU implementation.
[    0.012500] smp: Bringing up secondary CPUs ...
[    0.013639] CPU1: update cpu_capacity 1024
[    0.013660] CPU1: thread -1, cpu 1, socket 0, mpidr 80000001
[    0.013885] smp: Brought up 1 node, 2 CPUs
[    0.013929] SMP: Total of 2 processors activated (96.00 BogoMIPS).
[    0.013948] CPU: All CPU(s) started in SVC mode.
[    0.014920] devtmpfs: initialized
[    0.040428] VFP support v0.3: implementor 41 architecture 2 part 30 vari=
ant 7 rev 5
[    0.040723] clocksource: jiffies: mask: 0xffffffff max_cycles: 0xfffffff=
f, max_idle_ns: 19112604462750000 ns
[    0.040766] futex hash table entries: 512 (order: 3, 32768 bytes, linear)
[    0.041935] pinctrl core: initialized pinctrl subsystem
[    0.043866] NET: Registered PF_NETLINK/PF_ROUTE protocol family
[    0.047307] DMA: preallocated 256 KiB pool for atomic coherent allocatio=
ns
[    0.050013] thermal_sys: Registered thermal governor 'step_wise'
[    0.050438] cpuidle: using governor ladder
[    0.050517] cpuidle: using governor menu
[    0.051016] hw-breakpoint: found 5 (+1 reserved) breakpoint and 4 watchp=
oint registers.
[    0.051048] hw-breakpoint: maximum watchpoint size is 8 bytes.
[    0.051639] Serial: AMBA PL011 UART driver
[    0.084163] /soc/interrupt-controller@5000d000: bank0
[    0.084225] /soc/interrupt-controller@5000d000: bank1
[    0.084257] /soc/interrupt-controller@5000d000: bank2
[    0.099885] stm32mp157-pinctrl soc:pin-controller@50002000: GPIOA bank a=
dded
[    0.100856] stm32mp157-pinctrl soc:pin-controller@50002000: GPIOB bank a=
dded
[    0.101680] stm32mp157-pinctrl soc:pin-controller@50002000: GPIOC bank a=
dded
[    0.102428] stm32mp157-pinctrl soc:pin-controller@50002000: GPIOD bank a=
dded
[    0.103191] stm32mp157-pinctrl soc:pin-controller@50002000: GPIOE bank a=
dded
[    0.103985] stm32mp157-pinctrl soc:pin-controller@50002000: GPIOF bank a=
dded
[    0.104776] stm32mp157-pinctrl soc:pin-controller@50002000: GPIOG bank a=
dded
[    0.105569] stm32mp157-pinctrl soc:pin-controller@50002000: GPIOH bank a=
dded
[    0.106332] stm32mp157-pinctrl soc:pin-controller@50002000: GPIOI bank a=
dded
[    0.107158] stm32mp157-pinctrl soc:pin-controller@50002000: GPIOJ bank a=
dded
[    0.107896] stm32mp157-pinctrl soc:pin-controller@50002000: GPIOK bank a=
dded
[    0.108167] stm32mp157-pinctrl soc:pin-controller@50002000: Pinctrl STM3=
2 initialized
[    0.112296] stm32mp157-pinctrl soc:pin-controller-z@54004000: GPIOZ bank=
 added
[    0.112355] stm32mp157-pinctrl soc:pin-controller-z@54004000: Pinctrl ST=
M32 initialized
[    0.115621] platform 5a000000.dsi: Fixing up cyclic dependency with 5a00=
1000.display-controller
[    0.134041] cryptd: max_cpu_qlen set to 1000
[    0.137839] stm32-dma 48000000.dma-controller: STM32 DMA driver register=
ed
[    0.139723] stm32-dma 48001000.dma-controller: STM32 DMA driver register=
ed
[    0.143877] stm32-mdma 58000000.dma-controller: STM32 MDMA driver regist=
ered
[    0.147444] usbcore: registered new interface driver usbfs
[    0.147563] usbcore: registered new interface driver hub
[    0.147643] usbcore: registered new device driver usb
[    0.148661] pps_core: LinuxPPS API ver. 1 registered
[    0.148682] pps_core: Software ver. 5.3.6 - Copyright 2005-2007 Rodolfo =
Giometti <giometti@linux.it>
[    0.148722] PTP clock support registered
[    0.151497] clocksource: Switched to clocksource arch_sys_counter
[    0.224527] NET: Registered PF_INET protocol family
[    0.224891] IP idents hash table entries: 16384 (order: 5, 131072 bytes,=
 linear)
[    0.226763] tcp_listen_portaddr_hash hash table entries: 512 (order: 0, =
6144 bytes, linear)
[    0.226838] TCP established hash table entries: 8192 (order: 3, 32768 by=
tes, linear)
[    0.226975] TCP bind hash table entries: 8192 (order: 4, 65536 bytes, li=
near)
[    0.227163] TCP: Hash tables configured (established 8192 bind 8192)
[    0.227345] UDP hash table entries: 512 (order: 2, 16384 bytes, linear)
[    0.227432] UDP-Lite hash table entries: 512 (order: 2, 16384 bytes, lin=
ear)
[    0.227773] NET: Registered PF_UNIX/PF_LOCAL protocol family
[    0.228694] RPC: Registered named UNIX socket transport module.
[    0.228733] RPC: Registered udp transport module.
[    0.228747] RPC: Registered tcp transport module.
[    0.228760] RPC: Registered tcp NFSv4.1 backchannel transport module.
[    0.228779] NET: Registered PF_XDP protocol family
[    0.229889] hw perfevents: enabled with armv7_cortex_a7 PMU driver, 5 co=
unters available
[    0.232522] workingset: timestamp_bits=3D14 max_order=3D18 bucket_order=
=3D4
[    0.247322] NFS: Registering the id_resolver key type
[    0.247411] Key type id_resolver registered
[    0.247428] Key type id_legacy registered
[    0.247796] 9p: Installing v9fs 9p2000 file system support
[    0.248584] bounce: pool size: 64 pages
[    0.257261] Serial: 8250/16550 driver, 4 ports, IRQ sharing enabled
[    0.259560] STM32 USART driver initialized
[    0.260412] stm32-usart 40010000.serial: interrupt mode for rx (no dma)
[    0.260447] stm32-usart 40010000.serial: interrupt mode for tx (no dma)
[    0.260484] 40010000.serial: ttySTM0 at MMIO 0x40010000 (irq =3D 73, bas=
e_baud =3D 4000000) is a stm32-usart
[    1.174613] printk: console [ttySTM0] enabled
[    1.202878] loop: module loaded
[    1.203635] random: fast init done
[    1.209179] wireguard: WireGuard 1.0.0 loaded. See www.wireguard.com for=
 information.
[    1.211339] random: crng init done
[    1.215888] wireguard: Copyright (C) 2015-2019 Jason A. Donenfeld <Jason=
@zx2c4.com>. All Rights Reserved.
[    1.230257] libphy: Fixed MDIO Bus: probed
[    1.236782] stm32-dwmac 5800a000.ethernet: IRQ eth_wake_irq not found
[    1.241840] stm32-dwmac 5800a000.ethernet: IRQ eth_lpi not found
[    1.248794] stm32-dwmac 5800a000.ethernet: User ID: 0x40, Synopsys ID: 0=
x42
[    1.254847] stm32-dwmac 5800a000.ethernet: 	DWMAC4/5
[    1.259691] stm32-dwmac 5800a000.ethernet: DMA HW capability register su=
pported
[    1.267024] stm32-dwmac 5800a000.ethernet: RX Checksum Offload Engine su=
pported
[    1.274329] stm32-dwmac 5800a000.ethernet: TX Checksum insertion support=
ed
[    1.281165] stm32-dwmac 5800a000.ethernet: Wake-Up On Lan supported
[    1.287450] stm32-dwmac 5800a000.ethernet: TSO supported
[    1.292752] stm32-dwmac 5800a000.ethernet: Enable RX Mitigation via HW W=
atchdog Timer
[    1.300560] stm32-dwmac 5800a000.ethernet: Enabled L3L4 Flow TC (entries=
=3D2)
[    1.307548] stm32-dwmac 5800a000.ethernet: Enabled RFS Flow TC (entries=
=3D8)
[    1.314422] stm32-dwmac 5800a000.ethernet: TSO feature enabled
[    1.320208] stm32-dwmac 5800a000.ethernet: Using 32 bits DMA width
[    1.327329] libphy: stmmac: probed
[    1.335104] usbcore: registered new interface driver asix
[    1.339123] usbcore: registered new interface driver ax88179_178a
[    1.345392] usbcore: registered new interface driver smsc95xx
[    1.351931] ehci_hcd: USB 2.0 'Enhanced' Host Controller (EHCI) Driver
[    1.357436] ehci-omap: OMAP-EHCI Host Controller driver
[    1.362882] ehci-atmel: EHCI Atmel driver
[    1.369108] stm32_rtc 5c004000.rtc: IRQ index 1 not found
[    1.373092] stm32_rtc 5c004000.rtc: alarm can't wake up the system: -6
[    1.380262] stm32_rtc 5c004000.rtc: registered as rtc0
[    1.384811] stm32_rtc 5c004000.rtc: setting system clock to 2000-01-01T0=
2:37:57 UTC (946694277)
[    1.393860] stm32_rtc 5c004000.rtc: Date/Time must be initialized
[    1.399487] stm32_rtc 5c004000.rtc: registered rev:1.2
[    1.404985] i2c_dev: i2c /dev entries driver
[    1.430431] i2c 0-003c: Fixing up cyclic dependency with 4c006000.dcmi
[    1.437252] stm32f7-i2c 40013000.i2c: STM32F7 I2C-0 bus adapter
[    1.463227] stm32f7-i2c 40015000.i2c: STM32F7 I2C-1 bus adapter
[    1.493652] stpmic1 2-0033: PMIC Chip Version: 0x10
[    1.514417] vdda: Bringing 1800000uV into 2900000-2900000uV
[    1.520804] v2v8: Bringing 1800000uV into 2800000-2800000uV
[    1.534135] v1v8: Bringing 1000000uV into 1800000-1800000uV
[    1.547247] stm32f7-i2c 5c002000.i2c: STM32F7 I2C-2 bus adapter
[    1.555103] stm_thermal 50028000.thermal: stm_thermal_probe: Driver init=
ialized successfully
[    1.566947] mmci-pl18x 58005000.mmc: Got CD GPIO
[    1.571295] mmci-pl18x 58005000.mmc: mmc0: PL180 manf 53 rev2 at 0x58005=
000 irq 59,0 (pio)
[    1.609532] mmci-pl18x 58007000.mmc: mmc1: PL180 manf 53 rev2 at 0x58007=
000 irq 60,0 (pio)
[    1.650912] sdhci: Secure Digital Host Controller Interface driver
[    1.655771] sdhci: Copyright(c) Pierre Ossman
[    1.660461] sdhci-pltfm: SDHCI platform and OF driver helper
[    1.669007] ledtrig-cpu: registered to indicate activity on CPUs
[    1.673999] SMCCC: SOC_ID: ARCH_SOC_ID not implemented, skipping ....
[    1.682512] stm32-ipcc 4c001000.mailbox: ipcc rev:1.0 enabled, 6 chans, =
proc 0
[    1.689646] stm32-rproc 10000000.m4: wdg irq registered
[    1.700148] mmc0: new ultra high speed DDR50 SDHC card at address 0001
[    1.706661] remoteproc remoteproc0: m4 is available
[    1.717321] Initializing XFRM netlink socket
[    1.720971] NET: Registered PF_INET6 protocol family
[    1.726295] mmcblk0: mmc0:0001 00000 7.44 GiB=20
[    1.730578] Segment Routing with IPv6
[    1.733350] In-situ OAM (IOAM) with IPv6
[    1.737435] NET: Registered PF_PACKET protocol family
[    1.742266] NET: Registered PF_KEY protocol family
[    1.747283] 9pnet: Installing 9P2000 support
[    1.751319] Key type dns_resolver registered
[    1.755779] Registering SWP/SWPB emulation handler
[    1.762484] Internal error: Oops - undefined instruction: 0 [#1] PREEMPT=
 SMP ARM
[    1.768451] Modules linked in:
[    1.771491] CPU: 0 PID: 1 Comm: swapper/0 Not tainted 5.16.0-rc6-00031-g=
2f47a9a4dfa3 #17
[    1.779575] Hardware name: STM32 (Device Tree Support)
[    1.784706] PC is at crypto_unregister_alg+0xfc/0x104
[    1.789748] LR is at 0x0
[    1.792269] pc : [<c04b7008>]    lr : [<00000000>]    psr: 20000113
[    1.798529] sp : c18c9ea0  ip : 00000000  fp : c0e58858
[    1.803746] r10: 00000008  r9 : c18eb400  r8 : c192b600
[    1.808963] r7 : c100b41c  r6 : c18c9eac  r5 : c0f04ec8  r4 : c1b91e80
[    1.815484] r3 : 00000002  r2 : ffffffff  r1 : 00000001  r0 : c0f9e088
[    1.822006] Flags: nzCv  IRQs on  FIQs on  Mode SVC_32  ISA ARM  Segment=
 none
[    1.829138] Control: 10c5387d  Table: c000406a  DAC: 00000051
[    1.834875] Register r0 information: non-slab/vmalloc memory
[    1.840527] Register r1 information: non-paged memory
[    1.845570] Register r2 information: non-paged memory
[    1.850613] Register r3 information: non-paged memory
[    1.855657] Register r4 information: slab kmalloc-512 start c1b91e00 poi=
nter offset 128 size 512
[    1.864440] Register r5 information: non-slab/vmalloc memory
[    1.870092] Register r6 information: non-slab/vmalloc memory
[    1.875745] Register r7 information: non-slab/vmalloc memory
[    1.881398] Register r8 information: slab task_struct start c192b600 poi=
nter offset 0
[    1.889224] Register r9 information: slab kmalloc-128 start c18eb400 poi=
nter offset 0 size 128
[    1.897834] Register r10 information: non-paged memory
[    1.902966] Register r11 information: non-slab/vmalloc memory
[    1.908706] Register r12 information: NULL pointer
[    1.913489] Process swapper/0 (pid: 1, stack limit =3D 0xb3b87711)
[    1.919490] Stack: (0xc18c9ea0 to 0xc18ca000)
[    1.923847] 9ea0: c192b600 c0f0b16a 00000008 c18c9eac c18c9eac 0cd60047 =
c1b91e00 c100b430
[    1.932021] 9ec0: 00000001 c04c3864 c100b420 c011e448 c0f0b240 fffffffe =
00000001 c0e083e0
[    1.940195] 9ee0: c0ff43a0 c0f04ec8 c0e08360 00000000 c192b600 c0101fa0 =
c019c37c c0e00424
[    1.948368] 9f00: c0ffc000 00000000 00000007 c0ce0378 c0c44b28 00000000 =
00000000 c0f04ec8
[    1.956542] 9f20: c0c5eae8 c0c4e8b8 37320000 c18eb476 00000000 0cd60047 =
c0f478c0 00000008
[    1.964715] 9f40: c0d48594 0cd60047 c0e9581c c0d48594 c100b000 c0e58838 =
000000b4 c0e012f4
[    1.972888] 9f60: 00000007 00000007 00000000 c0e00424 c0e58808 c0e00424 =
00000000 00004ec0
[    1.981062] 9f80: c09eb450 00000000 00000000 00000000 00000000 00000000 =
00000000 c09eb46c
[    1.989236] 9fa0: 00000000 c09eb450 00000000 c0100148 00000000 00000000 =
00000000 00000000
[    1.997411] 9fc0: 00000000 00000000 00000000 00000000 00000000 00000000 =
00000000 00000000
[    2.005586] 9fe0: 00000000 00000000 00000000 00000000 00000013 00000000 =
00000000 00000000
[    2.013769] [<c04b7008>] (crypto_unregister_alg) from [<c04c3864>] (simd=
_skcipher_free+0x18/0x24)
[    2.022629] [<c04c3864>] (simd_skcipher_free) from [<c011e448>] (aes_exi=
t+0x28/0x44)
[    2.030367] [<c011e448>] (aes_exit) from [<c0e083e0>] (aes_init+0x80/0x9=
c)
[    2.037238] [<c0e083e0>] (aes_init) from [<c0101fa0>] (do_one_initcall+0=
x50/0x25c)
[    2.044802] [<c0101fa0>] (do_one_initcall) from [<c0e012f4>] (kernel_ini=
t_freeable+0x21c/0x278)
[    2.053497] [<c0e012f4>] (kernel_init_freeable) from [<c09eb46c>] (kerne=
l_init+0x1c/0x138)
[    2.061760] [<c09eb46c>] (kernel_init) from [<c0100148>] (ret_from_fork+=
0x14/0x2c)
[    2.069322] Exception stack(0xc18c9fb0 to 0xc18c9ff8)
[    2.074370] 9fa0:                                     00000000 00000000 =
00000000 00000000
[    2.082548] 9fc0: 00000000 00000000 00000000 00000000 00000000 00000000 =
00000000 00000000
[    2.090721] 9fe0: 00000000 00000000 00000000 00000000 00000013 00000000
[    2.097335] Code: e3a02009 e30011ca eb14a2e2 eaffffec (e7f001f2)=20
[    2.103429] ---[ end trace 78f3561a8b67f754 ]---
[    2.108290] Kernel panic - not syncing: Attempted to kill init! exitcode=
=3D0x0000000b
[    2.115684] CPU1: stopping
[    2.118373] CPU: 1 PID: 0 Comm: swapper/1 Tainted: G      D           5.=
16.0-rc6-00031-g2f47a9a4dfa3 #17
[    2.127848] Hardware name: STM32 (Device Tree Support)
[    2.132986] [<c0110d2c>] (unwind_backtrace) from [<c010c81c>] (show_stac=
k+0x18/0x1c)
[    2.140721] [<c010c81c>] (show_stack) from [<c09e5360>] (dump_stack_lvl+=
0x40/0x4c)
[    2.148287] [<c09e5360>] (dump_stack_lvl) from [<c010e8b8>] (do_handle_I=
PI+0x32c/0x354)
[    2.156286] [<c010e8b8>] (do_handle_IPI) from [<c010e900>] (ipi_handler+=
0x20/0x28)
[    2.163850] [<c010e900>] (ipi_handler) from [<c019813c>] (handle_percpu_=
devid_irq+0xa8/0x244)
[    2.172372] [<c019813c>] (handle_percpu_devid_irq) from [<c0191ce0>] (ge=
neric_handle_domain_irq+0x4c/0x90)
[    2.182025] [<c0191ce0>] (generic_handle_domain_irq) from [<c0536310>] (=
gic_handle_irq+0x7c/0x90)
[    2.190895] [<c0536310>] (gic_handle_irq) from [<c09eaf04>] (generic_han=
dle_arch_irq+0x58/0x78)
[    2.199588] [<c09eaf04>] (generic_handle_arch_irq) from [<c0100b10>] (__=
irq_svc+0x50/0x80)
[    2.207848] Exception stack(0xc191ff48 to 0xc191ff90)
[    2.212899] ff40:                   000003ba c0c5eae8 00000000 c011a6a0 =
c0ff4fc0 c0f04f58
[    2.221073] ff60: 00000002 00000000 00000000 c0cf2868 c1946c00 c0e9ce38 =
c0f03d00 c191ff98
[    2.229244] ff80: c01091b0 c01091b4 60000113 ffffffff
[    2.234286] [<c0100b10>] (__irq_svc) from [<c01091b4>] (arch_cpu_idle+0x=
40/0x44)
[    2.241676] [<c01091b4>] (arch_cpu_idle) from [<c09f2620>] (default_idle=
_call.part.2+0x2c/0x120)
[    2.250458] [<c09f2620>] (default_idle_call.part.2) from [<c016ae58>] (d=
o_idle+0x260/0x290)
[    2.258806] [<c016ae58>] (do_idle) from [<c016b18c>] (cpu_startup_entry+=
0x20/0x24)
[    2.266369] [<c016b18c>] (cpu_startup_entry) from [<c0101674>] (__enable=
NOTICE:  CPU: STM32MP157AAA Rev.B

Bisection identified adad556efcdd42a1d9e060cbe5f6161cccf1fa28:

	# bad: [fa55b7dcdc43c1aa1ba12bca9d2dd4318c2a0dbf] Linux 5.16-rc1
	# good: [8bb7eca972ad531c9b149c0a51ab43a417385813] Linux 5.15
	git bisect start 'v5.16-rc1' 'v5.15'
	# bad: [313b6ffc8e90173f1709b2f4bf9d30c4730a1dde] Merge tag 'linux-kselfte=
st-kunit-5.16-rc1' of git://git.kernel.org/pub/scm/linux/kernel/git/shuah/l=
inux-kselftest
	git bisect bad 313b6ffc8e90173f1709b2f4bf9d30c4730a1dde
	# good: [84882cf72cd774cf16fd338bdbf00f69ac9f9194] Revert "net: avoid doub=
le accounting for pure zerocopy skbs"
	git bisect good 84882cf72cd774cf16fd338bdbf00f69ac9f9194
	# good: [79ef0c00142519bc34e1341447f3797436cc48bf] Merge tag 'trace-v5.16'=
 of git://git.kernel.org/pub/scm/linux/kernel/git/rostedt/linux-trace
	git bisect good 79ef0c00142519bc34e1341447f3797436cc48bf
	# good: [0f3d2b680444d5697650b5529c9e749acbf7371f] drm/amdkfd: protect rav=
en_device_info with KFD_SUPPORT_IOMMU_V2
	git bisect good 0f3d2b680444d5697650b5529c9e749acbf7371f
	# bad: [a64a325bf6313aa5cde7ecd691927e92892d1b7f] Merge tag 'afs-next-2021=
1102' of git://git.kernel.org/pub/scm/linux/kernel/git/dhowells/linux-fs
	git bisect bad a64a325bf6313aa5cde7ecd691927e92892d1b7f
	# good: [52cf891d8dbd7592261fa30f373410b97f22b76c] Merge tag 'kvm-riscv-5.=
16-2' of https://github.com/kvm-riscv/linux into HEAD
	git bisect good 52cf891d8dbd7592261fa30f373410b97f22b76c
	# bad: [bfc484fe6abba4b89ec9330e0e68778e2a9856b2] Merge branch 'linus' of =
git://git.kernel.org/pub/scm/linux/kernel/git/herbert/crypto-2.6
	git bisect bad bfc484fe6abba4b89ec9330e0e68778e2a9856b2
	# good: [d2fac0afe89fe30c39eaa98dda71f7c4cea190c2] Merge tag 'audit-pr-202=
11101' of git://git.kernel.org/pub/scm/linux/kernel/git/pcmoore/audit
	git bisect good d2fac0afe89fe30c39eaa98dda71f7c4cea190c2
	# bad: [183b60e005975d3c84c22199ca64a9221e620fb6] crypto: hisilicon/qm - m=
odify the uacce mode check
	git bisect bad 183b60e005975d3c84c22199ca64a9221e620fb6
	# good: [0e64dcd7c94b94f90b820bfbe57bbcea8bf21545] crypto: qat - remove un=
matched CPU affinity to cluster IRQ
	git bisect good 0e64dcd7c94b94f90b820bfbe57bbcea8bf21545
	# good: [f20311cc9c58052e0b215013046cbf390937910c] crypto: caam - disable =
pkc for non-E SoCs
	git bisect good f20311cc9c58052e0b215013046cbf390937910c
	# bad: [f7324d4ba9e846e96ac85fbe74afe3fbdacf3b75] hwrng: meson - Improve e=
rror handling for core clock
	git bisect bad f7324d4ba9e846e96ac85fbe74afe3fbdacf3b75
	# good: [7c5329697ed4e0e1bf9a4e4fc9f0053f2f58935d] crypto: marvell/cesa - =
drop unneeded MODULE_ALIAS
	git bisect good 7c5329697ed4e0e1bf9a4e4fc9f0053f2f58935d
	# bad: [adad556efcdd42a1d9e060cbe5f6161cccf1fa28] crypto: api - Fix built-=
in testing dependency failures
	git bisect bad adad556efcdd42a1d9e060cbe5f6161cccf1fa28
	# first bad commit: [adad556efcdd42a1d9e060cbe5f6161cccf1fa28] crypto: api=
 - Fix built-in testing dependency failures

	$ grep CRYPTO .config
	CONFIG_ARM_CRYPTO=3Dy
	# CONFIG_CRYPTO_SHA1_ARM is not set
	# CONFIG_CRYPTO_SHA1_ARM_NEON is not set
	# CONFIG_CRYPTO_SHA1_ARM_CE is not set
	# CONFIG_CRYPTO_SHA2_ARM_CE is not set
	# CONFIG_CRYPTO_SHA256_ARM is not set
	# CONFIG_CRYPTO_SHA512_ARM is not set
	CONFIG_CRYPTO_BLAKE2S_ARM=3Dy
	# CONFIG_CRYPTO_BLAKE2B_NEON is not set
	CONFIG_CRYPTO_AES_ARM=3Dy
	CONFIG_CRYPTO_AES_ARM_BS=3Dy
	# CONFIG_CRYPTO_AES_ARM_CE is not set
	# CONFIG_CRYPTO_GHASH_ARM_CE is not set
	# CONFIG_CRYPTO_CRC32_ARM_CE is not set
	CONFIG_CRYPTO_CHACHA20_NEON=3Dy
	CONFIG_CRYPTO_POLY1305_ARM=3Dy
	# CONFIG_CRYPTO_NHPOLY1305_NEON is not set
	CONFIG_CRYPTO_CURVE25519_NEON=3Dy
	CONFIG_CRYPTO=3Dy
	CONFIG_CRYPTO_ALGAPI=3Dy
	CONFIG_CRYPTO_ALGAPI2=3Dy
	CONFIG_CRYPTO_AEAD=3Dy
	CONFIG_CRYPTO_AEAD2=3Dy
	CONFIG_CRYPTO_SKCIPHER=3Dy
	CONFIG_CRYPTO_SKCIPHER2=3Dy
	CONFIG_CRYPTO_HASH=3Dy
	CONFIG_CRYPTO_HASH2=3Dy
	CONFIG_CRYPTO_RNG=3Dy
	CONFIG_CRYPTO_RNG2=3Dy
	CONFIG_CRYPTO_AKCIPHER2=3Dy
	CONFIG_CRYPTO_AKCIPHER=3Dy
	CONFIG_CRYPTO_KPP2=3Dy
	CONFIG_CRYPTO_ACOMP2=3Dy
	CONFIG_CRYPTO_MANAGER=3Dy
	CONFIG_CRYPTO_MANAGER2=3Dy
	# CONFIG_CRYPTO_USER is not set
	CONFIG_CRYPTO_MANAGER_DISABLE_TESTS=3Dy
	CONFIG_CRYPTO_NULL=3Dy
	CONFIG_CRYPTO_NULL2=3Dy
	# CONFIG_CRYPTO_PCRYPT is not set
	CONFIG_CRYPTO_CRYPTD=3Dy
	CONFIG_CRYPTO_AUTHENC=3Dy
	# CONFIG_CRYPTO_TEST is not set
	CONFIG_CRYPTO_SIMD=3Dy
	CONFIG_CRYPTO_ENGINE=3Dy
	CONFIG_CRYPTO_RSA=3Dy
	# CONFIG_CRYPTO_DH is not set
	# CONFIG_CRYPTO_ECDH is not set
	# CONFIG_CRYPTO_ECDSA is not set
	# CONFIG_CRYPTO_ECRDSA is not set
	# CONFIG_CRYPTO_SM2 is not set
	# CONFIG_CRYPTO_CURVE25519 is not set
	# CONFIG_CRYPTO_CCM is not set
	# CONFIG_CRYPTO_GCM is not set
	# CONFIG_CRYPTO_CHACHA20POLY1305 is not set
	# CONFIG_CRYPTO_AEGIS128 is not set
	# CONFIG_CRYPTO_SEQIV is not set
	# CONFIG_CRYPTO_ECHAINIV is not set
	# CONFIG_CRYPTO_CBC is not set
	# CONFIG_CRYPTO_CFB is not set
	# CONFIG_CRYPTO_CTR is not set
	# CONFIG_CRYPTO_CTS is not set
	CONFIG_CRYPTO_ECB=3Dy
	# CONFIG_CRYPTO_LRW is not set
	# CONFIG_CRYPTO_OFB is not set
	# CONFIG_CRYPTO_PCBC is not set
	CONFIG_CRYPTO_XTS=3Dy
	# CONFIG_CRYPTO_KEYWRAP is not set
	# CONFIG_CRYPTO_ADIANTUM is not set
	# CONFIG_CRYPTO_ESSIV is not set
	# CONFIG_CRYPTO_CMAC is not set
	# CONFIG_CRYPTO_HMAC is not set
	# CONFIG_CRYPTO_XCBC is not set
	# CONFIG_CRYPTO_VMAC is not set
	CONFIG_CRYPTO_CRC32C=3Dy
	# CONFIG_CRYPTO_CRC32 is not set
	# CONFIG_CRYPTO_XXHASH is not set
	# CONFIG_CRYPTO_BLAKE2B is not set
	# CONFIG_CRYPTO_BLAKE2S is not set
	# CONFIG_CRYPTO_CRCT10DIF is not set
	# CONFIG_CRYPTO_GHASH is not set
	# CONFIG_CRYPTO_POLY1305 is not set
	# CONFIG_CRYPTO_MD4 is not set
	# CONFIG_CRYPTO_MD5 is not set
	# CONFIG_CRYPTO_MICHAEL_MIC is not set
	# CONFIG_CRYPTO_RMD160 is not set
	# CONFIG_CRYPTO_SHA1 is not set
	# CONFIG_CRYPTO_SHA256 is not set
	# CONFIG_CRYPTO_SHA512 is not set
	# CONFIG_CRYPTO_SHA3 is not set
	# CONFIG_CRYPTO_SM3 is not set
	# CONFIG_CRYPTO_STREEBOG is not set
	# CONFIG_CRYPTO_WP512 is not set
	CONFIG_CRYPTO_AES=3Dy
	# CONFIG_CRYPTO_AES_TI is not set
	# CONFIG_CRYPTO_BLOWFISH is not set
	# CONFIG_CRYPTO_CAMELLIA is not set
	# CONFIG_CRYPTO_CAST5 is not set
	# CONFIG_CRYPTO_CAST6 is not set
	CONFIG_CRYPTO_DES=3Dy
	# CONFIG_CRYPTO_FCRYPT is not set
	# CONFIG_CRYPTO_CHACHA20 is not set
	# CONFIG_CRYPTO_SERPENT is not set
	# CONFIG_CRYPTO_SM4 is not set
	# CONFIG_CRYPTO_TWOFISH is not set
	# CONFIG_CRYPTO_DEFLATE is not set
	# CONFIG_CRYPTO_LZO is not set
	# CONFIG_CRYPTO_842 is not set
	# CONFIG_CRYPTO_LZ4 is not set
	# CONFIG_CRYPTO_LZ4HC is not set
	# CONFIG_CRYPTO_ZSTD is not set
	# CONFIG_CRYPTO_ANSI_CPRNG is not set
	# CONFIG_CRYPTO_DRBG_MENU is not set
	# CONFIG_CRYPTO_JITTERENTROPY is not set
	# CONFIG_CRYPTO_USER_API_HASH is not set
	# CONFIG_CRYPTO_USER_API_SKCIPHER is not set
	# CONFIG_CRYPTO_USER_API_RNG is not set
	# CONFIG_CRYPTO_USER_API_AEAD is not set
	CONFIG_CRYPTO_LIB_AES=3Dy
	CONFIG_CRYPTO_ARCH_HAVE_LIB_BLAKE2S=3Dy
	CONFIG_CRYPTO_LIB_BLAKE2S=3Dy
	CONFIG_CRYPTO_ARCH_HAVE_LIB_CHACHA=3Dy
	CONFIG_CRYPTO_LIB_CHACHA=3Dy
	CONFIG_CRYPTO_ARCH_HAVE_LIB_CURVE25519=3Dy
	CONFIG_CRYPTO_LIB_CURVE25519_GENERIC=3Dy
	CONFIG_CRYPTO_LIB_CURVE25519=3Dy
	CONFIG_CRYPTO_LIB_DES=3Dy
	CONFIG_CRYPTO_LIB_POLY1305_RSIZE=3D9
	CONFIG_CRYPTO_ARCH_HAVE_LIB_POLY1305=3Dy
	CONFIG_CRYPTO_LIB_POLY1305=3Dy
	CONFIG_CRYPTO_LIB_CHACHA20POLY1305=3Dy
	CONFIG_CRYPTO_HW=3Dy
	CONFIG_CRYPTO_DEV_FSL_CAAM_COMMON=3Dy
	CONFIG_CRYPTO_DEV_FSL_CAAM_CRYPTO_API_DESC=3Dy
	CONFIG_CRYPTO_DEV_FSL_CAAM_AHASH_API_DESC=3Dy
	CONFIG_CRYPTO_DEV_FSL_CAAM=3Dy
	# CONFIG_CRYPTO_DEV_FSL_CAAM_DEBUG is not set
	CONFIG_CRYPTO_DEV_FSL_CAAM_JR=3Dy
	CONFIG_CRYPTO_DEV_FSL_CAAM_RINGSIZE=3D9
	# CONFIG_CRYPTO_DEV_FSL_CAAM_INTC is not set
	CONFIG_CRYPTO_DEV_FSL_CAAM_CRYPTO_API=3Dy
	CONFIG_CRYPTO_DEV_FSL_CAAM_AHASH_API=3Dy
	CONFIG_CRYPTO_DEV_FSL_CAAM_PKC_API=3Dy
	CONFIG_CRYPTO_DEV_FSL_CAAM_RNG_API=3Dy
	# CONFIG_CRYPTO_DEV_OMAP is not set
	# CONFIG_CRYPTO_DEV_SAHARA is not set
	# CONFIG_CRYPTO_DEV_ATMEL_AES is not set
	# CONFIG_CRYPTO_DEV_ATMEL_TDES is not set
	# CONFIG_CRYPTO_DEV_ATMEL_SHA is not set
	# CONFIG_CRYPTO_DEV_ATMEL_ECC is not set
	# CONFIG_CRYPTO_DEV_ATMEL_SHA204A is not set
	# CONFIG_CRYPTO_DEV_MXS_DCP is not set
	# CONFIG_CRYPTO_DEV_VIRTIO is not set
	# CONFIG_CRYPTO_DEV_STM32_CRC is not set
	# CONFIG_CRYPTO_DEV_STM32_HASH is not set
	# CONFIG_CRYPTO_DEV_STM32_CRYP is not set
	# CONFIG_CRYPTO_DEV_SAFEXCEL is not set
	# CONFIG_CRYPTO_DEV_CCREE is not set
	# CONFIG_CRYPTO_DEV_AMLOGIC_GXL is not set

I didn't try to understand and fix that. If you need more information,
just tell me.

Best regards
Uwe

--=20
Pengutronix e.K.                           | Uwe Kleine-K=F6nig            |
Industrial Linux Solutions                 | https://www.pengutronix.de/ |

--45t73oo4egm3ysts
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCgAdFiEEfnIqFpAYrP8+dKQLwfwUeK3K7AkFAmHC/HMACgkQwfwUeK3K
7AlNvwf9GHFLkXTOkY7ytfEk+oTCLLAYn9KgVbgimUN2M1PcMWVnAOrIhBtwNPoY
HeOyjeZMx6myC3lnc6ztjhO6KrvNy0BZFtuPaQPW32odjRn2k5kJe5H8W5m4iupb
/meRHhA7dOwaPfTimI10QnS1EOicbTWpsNbM4cv1qZdhJG07uO4+15Zb5hdDvr9b
CHPkCWohgwRjLakVQ4++5vVhrjWQ3zHs8+6mLJWkf7/hbH2Zj9TdsUpjfE53g6nA
dDGKsDkMhjMmh+OLONbXt9yyfOEBdVC4YiTK2bwJY77z8oPAcAvDdlvhLjaE4Wqu
hD/zY24sU0pwEQC5w/ed52Nx8uViZg==
=Kh0f
-----END PGP SIGNATURE-----

--45t73oo4egm3ysts--
