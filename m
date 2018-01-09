From: Gregory CLEMENT <gregory.clement@free-electrons.com>
Subject: Re: Hang loading omap_rng on MacchiatoBin with 4.15-rc7
Date: Tue, 09 Jan 2018 10:21:27 +0100
Message-ID: <87k1wr8k14.fsf@free-electrons.com>
References: <CAAqcGH=eG6PC2gmJ0MxOkLYProM3DqbE-cz=hSz1jEPGiBdTLg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Cc: Thomas Petazzoni <thomas.petazzoni@free-electrons.com>,
 Marcin Wojtas <mw@semihalf.com>, linux-crypto@vger.kernel.org,
 linux-arm-kernel@lists.infradead.org,
 Ard Biesheuvel <ard.biesheuvel@linaro.org>
To: Riku Voipio <riku.voipio@linaro.org>
Return-path: <linux-arm-kernel-bounces+linux-arm-kernel=m.gmane.org@lists.infradead.org>
In-Reply-To: <CAAqcGH=eG6PC2gmJ0MxOkLYProM3DqbE-cz=hSz1jEPGiBdTLg@mail.gmail.com>
 (Riku Voipio's message of "Tue, 9 Jan 2018 10:31:11 +0200")
List-Unsubscribe: <http://lists.infradead.org/mailman/options/linux-arm-kernel>,
 <mailto:linux-arm-kernel-request@lists.infradead.org?subject=unsubscribe>
List-Archive: <http://lists.infradead.org/pipermail/linux-arm-kernel/>
List-Post: <mailto:linux-arm-kernel@lists.infradead.org>
List-Help: <mailto:linux-arm-kernel-request@lists.infradead.org?subject=help>
List-Subscribe: <http://lists.infradead.org/mailman/listinfo/linux-arm-kernel>,
 <mailto:linux-arm-kernel-request@lists.infradead.org?subject=subscribe>
Sender: "linux-arm-kernel" <linux-arm-kernel-bounces@lists.infradead.org>
Errors-To: linux-arm-kernel-bounces+linux-arm-kernel=m.gmane.org@lists.infradead.org
List-Id: linux-crypto.vger.kernel.org

Hi Riku,
 
 On mar., janv. 09 2018, Riku Voipio <riku.voipio@linaro.org> wrote:

> Hi,
>
> Loading omap_rng module on McBin causes hangup (in about 9/10 times).
> Looking at /proc/interrupts it seems the interrupt starts running like
> crazy, and after a while the whole system is unresponsive. This with
> Debian kernel (everything possible as modules) and EFI as bootloader.
> The EFI firmware appears[1] to use the rng unit to provide a seed for
> KASRL, I wonder if the driver needs to depend less on the state left
> by firmware, or the firmware needs to de-initialize the RNG before
> booting.

I do not have a board with an EFI bootloader, so that may explain why I
didn't managed to reproduce your issue. I really would prefer to make
the driver less depend to the bootloader than the firmware de-initialize
the RNG before booting. However both things could be done independently.

I can have a look on the driver but as I don't have the configuration I
may ask you to test it for me.

Gregory

>
> root@debian:~# cat /proc/interrupts
>            CPU0       CPU1       CPU2       CPU3
>   1:          0          0          0          0     GICv2  25 Level     vgic
>   3:       1268       1983       1175       1139     GICv2  30 Level
>   arch_timer
>   4:          0          0          0          0     GICv2  27 Level
>   kvm guest timer
>   7:       1956          0          0          0     GICv2  51 Level     ttyS0
>   9:       4472          0        307          0     GICv2  48 Level     mmc0
>  18:          0          0          0          0      pMSI 4096 Edge
>    f0400000.xor
>  19:          0          0          0          0      pMSI 6144 Edge
>    f0420000.xor
>  20:          0          0          0          0      pMSI 8192 Edge
>    f0440000.xor
>  21:          0          0          0          0      pMSI 10240 Edge
>     f0460000.xor
>  22:          0          0          0          0      pMSI 12288 Edge
>     f26a0000.xor
>  23:          0          0          0          0      pMSI 14336 Edge
>     f26c0000.xor
>  24:          0          0          0          0      pMSI 16384 Edge
>     f46a0000.xor
>  25:          0          0          0          0      pMSI 18432 Edge
>     f46c0000.xor
>  26:          0          0          0          0
> f03f0100.interrupt-controller  17 Level     arm-pmu
>  27:          0          0          0          0  ICU.f21e0000  22
> Level     armada8k-pcie, PCIe PME, aerdrv
>  72:         13          0          0          0  ICU.f41e0000  40
> Level     eth2
>  73:          0         10          0          0  ICU.f41e0000  44
> Level     eth2
>  74:          0          0         29          0  ICU.f41e0000  48
> Level     eth2
>  75:          0          0          0         45  ICU.f41e0000  52
> Level     eth2
>  76:         36          0          0         55  ICU.f41e0000  56
> Level     eth2
>  78:        440          0         42          0  ICU.f21e0000  27
> Level     mmc1
>  79:          0          0          0          0  ICU.f41e0000  77
> Level     f4284000.rtc
>  80:          0          0          0          0  ICU.f21e0000 120
> Level     mv64xxx_i2c
>  81:          0          0          0          0  ICU.f21e0000 121
> Level     mv64xxx_i2c
>  82:          0          0          0          0  ICU.f21e0000 106
> Level     xhci-hcd:usb1
>  83:          0          0          0          0  ICU.f21e0000 105
> Level     xhci-hcd:usb3
>  84:          0          0          0          0  ICU.f41e0000 106
> Level     xhci-hcd:usb5
>  85:          0          0          0          0  ICU.f21e0000 107
> Level     ahci[f2540000.sata]
>  86:        268          0          0          0  ICU.f41e0000 107
> Level     ahci[f4540000.sata]
> IPI0:      2254       2458       1876       1844       Rescheduling interrupts
> IPI1:       110        107        299        165       Function call interrupts
> IPI2:         0          0          0          0       CPU stop interrupts
> IPI3:         0          0          0          0       CPU stop (for
> crash dump) interrupts
> IPI4:         0          0          0          0       Timer broadcast
> interrupts
> IPI5:         1          0          0          0       IRQ work interrupts
> IPI6:         0          0          0          0       CPU wake-up interrupts
> Err:          0
> root@debian:~# modprobe omap_rng
> root@debian:~# cat /proc/interrupts
>            CPU0       CPU1       CPU2       CPU3
>   1:          0          0          0          0     GICv2  25 Level     vgic
>   3:       1795       2736       1663       1620     GICv2  30 Level
>   arch_timer
>   4:          0          0          0          0     GICv2  27 Level
>   kvm guest timer
>   7:       2183          0          0          0     GICv2  51 Level     ttyS0
>   9:       4472          0       1759          0     GICv2  48 Level     mmc0
>  18:          0          0          0          0      pMSI 4096 Edge
>    f0400000.xor
>  19:          0          0          0          0      pMSI 6144 Edge
>    f0420000.xor
>  20:          0          0          0          0      pMSI 8192 Edge
>    f0440000.xor
>  21:          0          0          0          0      pMSI 10240 Edge
>     f0460000.xor
>  22:          0          0          0          0      pMSI 12288 Edge
>     f26a0000.xor
>  23:          0          0          0          0      pMSI 14336 Edge
>     f26c0000.xor
>  24:          0          0          0          0      pMSI 16384 Edge
>     f46a0000.xor
>  25:          0          0          0          0      pMSI 18432 Edge
>     f46c0000.xor
>  26:          0          0          0          0
> f03f0100.interrupt-controller  17 Level     arm-pmu
>  27:          0          0          0          0  ICU.f21e0000  22
> Level     armada8k-pcie, PCIe PME, aerdrv
>  72:         15          0          0          0  ICU.f41e0000  40
> Level     eth2
>  73:          0         11          0          0  ICU.f41e0000  44
> Level     eth2
>  74:          0          0         37          0  ICU.f41e0000  48
> Level     eth2
>  75:          0          0          0         68  ICU.f41e0000  52
> Level     eth2
>  76:         36          0          0        118  ICU.f41e0000  56
> Level     eth2
>  78:        440          0         68          0  ICU.f21e0000  27
> Level     mmc1
>  79:          0          0          0          0  ICU.f41e0000  77
> Level     f4284000.rtc
>  80:          0          0          0          0  ICU.f21e0000 120
> Level     mv64xxx_i2c
>  81:          0          0          0          0  ICU.f21e0000 121
> Level     mv64xxx_i2c
>  82:          0          0          0          0  ICU.f21e0000 106
> Level     xhci-hcd:usb1
>  83:          0          0          0          0  ICU.f21e0000 105
> Level     xhci-hcd:usb3
>  84:          0          0          0          0  ICU.f41e0000 106
> Level     xhci-hcd:usb5
>  85:          0          0          0          0  ICU.f21e0000 107
> Level     ahci[f2540000.sata]
>  86:        268          0          0          0  ICU.f41e0000 107
> Level     ahci[f4540000.sata]
>  87:          0          0          0          0  ICU.f21e0000  95
> Level     f2760000.trng
>  88:     889660          0          0          0  ICU.f41e0000  95
> Level     f4760000.trng
> IPI0:      2964       2559       2607       1957       Rescheduling interrupts
> IPI1:       110        107        299        165       Function call interrupts
> IPI2:         0          0          0          0       CPU stop interrupts
> IPI3:         0          0          0          0       CPU stop (for
> crash dump) interrupts
> IPI4:         0          0          0          0       Timer broadcast
> interrupts
> IPI5:         1          0          0          0       IRQ work interrupts
> IPI6:         0          0          0          0       CPU wake-up interrupts
> Err:          0
> root@debian:~# cat /proc/interrupts
>            CPU0       CPU1       CPU2       CPU3
>   1:          0          0          0          0     GICv2  25 Level     vgic
>   3:       2538       3498       2407       2364     GICv2  30 Level
>   arch_timer
>   4:          0          0          0          0     GICv2  27 Level
>   kvm guest timer
>   7:       2625          0          0          0     GICv2  51 Level     ttyS0
>   9:       4472          0       1768          0     GICv2  48 Level     mmc0
>  18:          0          0          0          0      pMSI 4096 Edge
>    f0400000.xor
>  19:          0          0          0          0      pMSI 6144 Edge
>    f0420000.xor
>  20:          0          0          0          0      pMSI 8192 Edge
>    f0440000.xor
>  21:          0          0          0          0      pMSI 10240 Edge
>     f0460000.xor
>  22:          0          0          0          0      pMSI 12288 Edge
>     f26a0000.xor
>  23:          0          0          0          0      pMSI 14336 Edge
>     f26c0000.xor
>  24:          0          0          0          0      pMSI 16384 Edge
>     f46a0000.xor
>  25:          0          0          0          0      pMSI 18432 Edge
>     f46c0000.xor
>  26:          0          0          0          0
> f03f0100.interrupt-controller  17 Level     arm-pmu
>  27:          0          0          0          0  ICU.f21e0000  22
> Level     armada8k-pcie, PCIe PME, aerdrv
>  72:         15          0          0          0  ICU.f41e0000  40
> Level     eth2
>  73:          0         11          0          0  ICU.f41e0000  44
> Level     eth2
>  74:          0          0         37          0  ICU.f41e0000  48
> Level     eth2
>  75:          0          0          0         68  ICU.f41e0000  52
> Level     eth2
>  76:         36          0          0        118  ICU.f41e0000  56
> Level     eth2
>  78:        440          0         71          0  ICU.f21e0000  27
> Level     mmc1
>  79:          0          0          0          0  ICU.f41e0000  77
> Level     f4284000.rtc
>  80:          0          0          0          0  ICU.f21e0000 120
> Level     mv64xxx_i2c
>  81:          0          0          0          0  ICU.f21e0000 121
> Level     mv64xxx_i2c
>  82:          0          0          0          0  ICU.f21e0000 106
> Level     xhci-hcd:usb1
>  83:          0          0          0          0  ICU.f21e0000 105
> Level     xhci-hcd:usb3
>  84:          0          0          0          0  ICU.f41e0000 106
> Level     xhci-hcd:usb5
>  85:          0          0          0          0  ICU.f21e0000 107
> Level     ahci[f2540000.sata]
>  86:        268          0          0          0  ICU.f41e0000 107
> Level     ahci[f4540000.sata]
>  87:          0          0          0          0  ICU.f21e0000  95
> Level     f2760000.trng
>  88:    2532580          0          0          0  ICU.f41e0000  95
> Level     f4760000.trng
> IPI0:      2964       2562       2640       2001       Rescheduling interrupts
> IPI1:       110        107        299        165       Function call interrupts
> IPI2:         0          0          0          0       CPU stop interrupts
> IPI3:         0          0          0          0       CPU stop (for
> crash dump) interrupts
> IPI4:         0          0          0          0       Timer broadcast
> interrupts
> IPI5:         1          0          0          0       IRQ work interrupts
> IPI6:         0          0          0          0       CPU wake-up interrupts
>
> [1] https://github.com/MarvellEmbeddedProcessors/edk2-open-platform/commit/4a0d8a37247b0da45baf37e1f207ae8737c7254b
>
> Full kernel log:
>
> [    0.000000] Booting Linux on physical CPU 0x0000000000 [0x410fd081]
> [    0.000000] Linux version 4.15.0-rc7-arm64
> (debian-kernel@lists.debian.org) (gcc version 7.2.0 (Debian 7.2.0-11))
> #1 SMP Debian 4.15~rc7-1~exp1 (2018-01-08)
> [    0.000000] Machine model: Marvell 8040 MACHIATOBin
> [    0.000000] efi: Getting EFI parameters from FDT:
> [    0.000000] efi: EFI v2.60 by EDK II
> [    0.000000] efi:  SMBIOS 3.0=0xbfd00000  ACPI 2.0=0xb6760000
> MEMATTR=0xb8862018  RNG=0xbffdbf98
> [    0.000000] random: fast init done
> [    0.000000] efi: seeding entropy pool
> [    0.000000] cma: Reserved 64 MiB at 0x00000000bb800000
> [    0.000000] NUMA: No NUMA configuration found
> [    0.000000] NUMA: Faking a node at [mem
> 0x0000000000000000-0x000000013fffffff]
> [    0.000000] NUMA: NODE_DATA [mem 0x13ffd3980-0x13ffd547f]
> [    0.000000] Zone ranges:
> [    0.000000]   DMA      [mem 0x0000000000000000-0x00000000ffffffff]
> [    0.000000]   Normal   [mem 0x0000000100000000-0x000000013fffffff]
> [    0.000000] Movable zone start for each node
> [    0.000000] Early memory node ranges
> [    0.000000]   node   0: [mem 0x0000000000000000-0x0000000003ffffff]
> [    0.000000]   node   0: [mem 0x0000000004200000-0x00000000bf80ffff]
> [    0.000000]   node   0: [mem 0x00000000bf810000-0x00000000bfbeffff]
> [    0.000000]   node   0: [mem 0x00000000bfbf0000-0x00000000bfc8ffff]
> [    0.000000]   node   0: [mem 0x00000000bfc90000-0x00000000bffdffff]
> [    0.000000]   node   0: [mem 0x00000000bffe0000-0x00000000bfffffff]
> [    0.000000]   node   0: [mem 0x0000000100000000-0x000000013fffffff]
> [    0.000000] Initmem setup node 0 [mem 0x0000000000000000-0x000000013fffffff]
> [    0.000000] On node 0 totalpages: 1048064
> [    0.000000]   DMA zone: 12280 pages used for memmap
> [    0.000000]   DMA zone: 0 pages reserved
> [    0.000000]   DMA zone: 785920 pages, LIFO batch:31
> [    0.000000]   Normal zone: 4096 pages used for memmap
> [    0.000000]   Normal zone: 262144 pages, LIFO batch:31
> [    0.000000] psci: probing for conduit method from DT.
> [    0.000000] psci: PSCIv1.0 detected in firmware.
> [    0.000000] psci: Using standard PSCI v0.2 function IDs
> [    0.000000] psci: MIGRATE_INFO_TYPE not supported.
> [    0.000000] percpu: Embedded 24 pages/cpu @        (ptrval) s58904
> r8192 d31208 u98304
> [    0.000000] pcpu-alloc: s58904 r8192 d31208 u98304 alloc=24*4096
> [    0.000000] pcpu-alloc: [0] 0 [0] 1 [0] 2 [0] 3
> [    0.000000] Detected PIPT I-cache on CPU0
> [    0.000000] Built 1 zonelists, mobility grouping on.  Total pages: 1031688
> [    0.000000] Policy zone: Normal
> [    0.000000] Kernel command line:
> BOOT_IMAGE=/boot/vmlinuz-4.15.0-rc7-arm64
> root=UUID=eac7cb10-f190-4ade-bf79-d1a979e18e8b ro quiet
> [    0.000000] software IO TLB [mem 0xb2700000-0xb6700000] (64MB)
> mapped at [        (ptrval)-        (ptrval)]
> [    0.000000] Memory: 3948596K/4192256K available (8316K kernel code,
> 1436K rwdata, 2748K rodata, 4480K init, 600K bss, 178124K reserved,
> 6553
> 6K cma-reserved)
> [    0.000000] Virtual kernel memory layout:
> [    0.000000]     modules : 0xffff000000000000 - 0xffff000008000000
> (   128 MB)
> [    0.000000]     vmalloc : 0xffff000008000000 - 0xffff7dffbfff0000
> (129022 GB)
> [    0.000000]       .text : 0x        (ptrval) - 0x        (ptrval)
> (  8320 KB)
> [    0.000000]     .rodata : 0x        (ptrval) - 0x        (ptrval)
> (  2816 KB)
> [    0.000000]       .init : 0x        (ptrval) - 0x        (ptrval)
> (  4480 KB)
> [    0.000000]       .data : 0x        (ptrval) - 0x        (ptrval)
> (  1437 KB)
> [    0.000000]        .bss : 0x        (ptrval) - 0x        (ptrval)
> (   601 KB)
> [    0.000000]     fixed   : 0xffff7dfffe7fd000 - 0xffff7dfffec00000
> (  4108 KB)
> [    0.000000]     PCI I/O : 0xffff7dfffee00000 - 0xffff7dffffe00000
> (    16 MB)
> [    0.000000]     vmemmap : 0xffff7e0000000000 - 0xffff800000000000
> (  2048 GB maximum)
> [    0.000000]               0xffff7f7ac9000000 - 0xffff7f7ace000000
> (    80 MB actual)
> [    0.000000]     memory  : 0xffffdeb240000000 - 0xffffdeb380000000
> (  5120 MB)
> [    0.000000] ftrace: allocating 31174 entries in 122 pages
> [    0.000000] Hierarchical RCU implementation.
> [    0.000000]  RCU restricting CPUs from NR_CPUS=256 to nr_cpu_ids=4.
> [    0.000000] RCU: Adjusting geometry for rcu_fanout_leaf=16, nr_cpu_ids=4
> [    0.000000] NR_IRQS: 64, nr_irqs: 64, preallocated irqs: 0
> [    0.000000] GIC: Adjusting CPU interface base to 0x00000000f022f000
> [    0.000000] GIC: Using split EOI/Deactivate mode
> [    0.000000] GICv2m: DT overriding V2M MSI_TYPER (base:160, num:32)
> [    0.000000] GICv2m: range[mem 0xf0280000-0xf0280fff], SPI[160:191]
> [    0.000000] GICv2m: DT overriding V2M MSI_TYPER (base:192, num:32)
> [    0.000000] GICv2m: range[mem 0xf0290000-0xf0290fff], SPI[192:223]
> [    0.000000] GICv2m: DT overriding V2M MSI_TYPER (base:224, num:32)
> [    0.000000] GICv2m: range[mem 0xf02a0000-0xf02a0fff], SPI[224:255]
> [    0.000000] GICv2m: DT overriding V2M MSI_TYPER (base:256, num:32)
> [    0.000000] GICv2m: range[mem 0xf02b0000-0xf02b0fff], SPI[256:287]
> [    0.000000] arch_timer: cp15 timer(s) running at 25.00MHz (phys).
> [    0.000000] clocksource: arch_sys_counter: mask: 0xffffffffffffff
> max_cycles: 0x5c40939b5, max_idle_ns: 440795202646 ns
> [    0.000002] sched_clock: 56 bits at 25MHz, resolution 40ns, wraps
> every 4398046511100ns
> [    0.000320] Console: colour dummy device 80x25
> [    0.000329] console [tty0] enabled
> [    0.000367] Calibrating delay loop (skipped), value calculated
> using timer frequency.. 50.00 BogoMIPS (lpj=100000)
> [    0.000373] pid_max: default: 32768 minimum: 301
> [    0.000455] Security Framework initialized
> [    0.000460] Yama: disabled by default; enable with sysctl kernel.yama.*
> [    0.000502] AppArmor: AppArmor initialized
> [    0.001673] Dentry cache hash table entries: 524288 (order: 10,
> 4194304 bytes)
> [    0.002270] Inode-cache hash table entries: 262144 (order: 9, 2097152 bytes)
> [    0.002318] Mount-cache hash table entries: 8192 (order: 4, 65536 bytes)
> [    0.002341] Mountpoint-cache hash table entries: 8192 (order: 4, 65536 bytes)
> [    0.003051] ASID allocator initialised with 65536 entries
> [    0.003095] Hierarchical SRCU implementation.
> [    0.004111] Remapping and enabling EFI services.
> [    0.004215]   EFI remap 0x00000000bf810000 =>         (ptrval)
> [    0.004292]   EFI remap 0x00000000bfc90000 =>         (ptrval)
> [    0.004296]   EFI remap 0x00000000f4284000 =>         (ptrval)
> [    0.004299]   EFI remap 0x00000000f4700000 =>         (ptrval)
> [    0.004306]   EFI remap 0x00000000f93c0000 =>         (ptrval)
> [    0.004610] smp: Bringing up secondary CPUs ...
> [    0.005038] Detected PIPT I-cache on CPU1
> [    0.005078] CPU1: Booted secondary processor 0x0000000001 [0x410fd081]
> [    0.005532] Detected PIPT I-cache on CPU2
> [    0.005562] CPU2: Booted secondary processor 0x0000000100 [0x410fd081]
> [    0.006013] Detected PIPT I-cache on CPU3
> [    0.006033] CPU3: Booted secondary processor 0x0000000101 [0x410fd081]
> [    0.006084] smp: Brought up 1 node, 4 CPUs
> [    0.006088] SMP: Total of 4 processors activated.
> [    0.006092] CPU features: detected feature: 32-bit EL0 Support
> [    0.006378] CPU: All CPU(s) started at EL2
> [    0.007024] devtmpfs: initialized
> [    0.009286] Registered cp15_barrier emulation handler
> [    0.009294] Registered setend emulation handler
> [    0.009408] clocksource: jiffies: mask: 0xffffffff max_cycles:
> 0xffffffff, max_idle_ns: 7645041785100000 ns
> [    0.009435] futex hash table entries: 1024 (order: 5, 131072 bytes)
> [    0.010231] pinctrl core: initialized pinctrl subsystem
> [    0.010660] SMBIOS 3.0.0 present.
> [    0.010671] DMI: Marvell Armada 8040 MacchiatoBin/Armada 8040
> MacchiatoBin, BIOS EDK II Dec 12 2017
> [    0.010837] NET: Registered protocol family 16
> [    0.010997] audit: initializing netlink subsys (disabled)
> [    0.011098] audit: type=2000 audit(0.008:1): state=initialized
> audit_enabled=0 res=1
> [    0.011559] cpuidle: using governor ladder
> [    0.011633] cpuidle: using governor menu
> [    0.011803] vdso: 2 pages (1 code @ 0000000000e7c779, 1 data @
> 000000009a994fe8)
> [    0.011812] hw-breakpoint: found 6 breakpoint and 4 watchpoint registers.
> [    0.012428] DMA: preallocated 256 KiB pool for atomic allocations
> [    0.012528] Serial: AMBA PL011 UART driver
> [    0.019355] HugeTLB registered 2.00 MiB page size, pre-allocated 0 pages
> [    0.019916] ACPI: Interpreter disabled.
> [    0.020101] vgaarb: loaded
> [    0.020268] EDAC MC: Ver: 3.0.0
> [    0.020437] Registered efivars operations
> [    0.023923] clocksource: Switched to clocksource arch_sys_counter
> [    0.048986] VFS: Disk quotas dquot_6.6.0
> [    0.049027] VFS: Dquot-cache hash table entries: 512 (order 0, 4096 bytes)
> [    0.049295] AppArmor: AppArmor Filesystem Enabled
> [    0.049454] pnp: PnP ACPI: disabled
> [    0.053211] NET: Registered protocol family 2
> [    0.053536] TCP established hash table entries: 32768 (order: 6,
> 262144 bytes)
> [    0.053685] TCP bind hash table entries: 32768 (order: 7, 524288 bytes)
> [    0.053910] TCP: Hash tables configured (established 32768 bind 32768)
> [    0.053982] UDP hash table entries: 2048 (order: 4, 65536 bytes)
> [    0.054008] UDP-Lite hash table entries: 2048 (order: 4, 65536 bytes)
> [    0.054127] NET: Registered protocol family 1
> [    0.054142] PCI: CLS 0 bytes, default 128
> [    0.054241] Unpacking initramfs...
> [    0.677482] Freeing initrd memory: 18500K
> [    0.677789] hw perfevents: unable to count PMU IRQs
> [    0.677803] hw perfevents: /ap806/config-space@f0000000/pmu: failed
> to register PMU devices!
> [    0.677970] kvm [1]: 8-bit VMID
> [    0.677973] kvm [1]: IDMAP page: 51c54000
> [    0.677975] kvm [1]: HYP VA range: 800000000000:ffffffffffff
> [    0.678466] kvm [1]: vgic-v2@f0240000
> [    0.678537] kvm [1]: vgic interrupt IRQ1
> [    0.678546] kvm [1]: virtual timer IRQ4
> [    0.678607] kvm [1]: Hyp mode initialized successfully
> [    0.679727] Initialise system trusted keyrings
> [    0.679801] workingset: timestamp_bits=44 max_order=20 bucket_order=0
> [    0.679880] zbud: loaded
> [    1.334003] Key type asymmetric registered
> [    1.334007] Asymmetric key parser 'x509' registered
> [    1.334050] Block layer SCSI generic (bsg) driver version 0.4
> loaded (major 246)
> [    1.334123] io scheduler noop registered
> [    1.334125] io scheduler deadline registered
> [    1.334154] io scheduler cfq registered (default)
> [    1.334156] io scheduler mq-deadline registered
> [    1.335649] armada-ap806-pinctrl
> f06f4000.system-controller:pinctrl: registered pinctrl driver
> [    1.336054] armada-cp110-pinctrl
> f2440000.system-controller:pinctrl: registered pinctrl driver
> [    1.336335] armada-cp110-pinctrl
> f4440000.system-controller:pinctrl: registered pinctrl driver
> [    1.340941] mv_xor_v2 f0400000.xor: Marvell Version 2 XOR driver
> [    1.341186] mv_xor_v2 f0420000.xor: Marvell Version 2 XOR driver
> [    1.341461] mv_xor_v2 f0440000.xor: Marvell Version 2 XOR driver
> [    1.341702] mv_xor_v2 f0460000.xor: Marvell Version 2 XOR driver
> [    1.342010] mv_xor_v2 f26a0000.xor: Marvell Version 2 XOR driver
> [    1.342263] mv_xor_v2 f26c0000.xor: Marvell Version 2 XOR driver
> [    1.342652] mv_xor_v2 f46a0000.xor: Marvell Version 2 XOR driver
> [    1.342914] mv_xor_v2 f46c0000.xor: Marvell Version 2 XOR driver
> [    1.343757] Serial: 8250/16550 driver, 4 ports, IRQ sharing enabled
> [    1.364902] f0512000.serial: ttyS0 at MMIO 0xf0512000 (irq = 7,
> base_baud = 12500000) is a 16550A
> [    1.369854] console [ttyS0] enabled
> [    1.370155] Serial: AMBA driver
> [    1.370306] msm_serial: driver initialized
> [    1.370630] cacheinfo: Unable to detect cache hierarchy for CPU 0
> [    1.370882] mousedev: PS/2 mouse device common for all mice
> [    1.371155] rtc-efi rtc-efi: rtc core: registered rtc-efi as rtc0
> [    1.371854] ledtrig-cpu: registered to indicate activity on CPUs
> [    1.372409] NET: Registered protocol family 10
> [    1.372782] Segment Routing with IPv6
> [    1.372812] mip6: Mobile IPv6
> [    1.372817] NET: Registered protocol family 17
> [    1.372822] mpls_gso: MPLS GSO support
> [    1.373117] registered taskstats version 1
> [    1.373120] Loading compiled-in X.509 certificates
> [    1.456522] Loaded X.509 cert 'Debian Project: Ben Hutchings:
> 008a018dca80932630'
> [    1.456573] zswap: loaded using pool lzo/zbud
> [    1.456649] AppArmor: AppArmor sha1 policy hashing enabled
> [    1.456655] ima: No TPM chip found, activating TPM-bypass! (rc=-19)
> [    1.458339] hw perfevents: enabled with armv8_cortex_a72 PMU
> driver, 7 counters available
> [    1.458570] OF: PCI: host bridge /cp110-master/pcie@f2600000 ranges:
> [    1.458584] OF: PCI:    IO 0xf9000000..0xf900ffff -> 0xf9000000
> [    1.458592] OF: PCI:   MEM 0xf6000000..0xf6efffff -> 0xf6000000
> [    2.459125] armada8k-pcie f2600000.pcie: phy link never came up
> [    2.465091] armada8k-pcie f2600000.pcie: Link not up after reconfiguration
> [    2.472079] armada8k-pcie f2600000.pcie: PCI host bridge to bus 0000:00
> [    2.472085] pci_bus 0000:00: root bus resource [bus 00-ff]
> [    2.472090] pci_bus 0000:00: root bus resource [io  0x0000-0xffff]
> (bus address [0xf9000000-0xf900ffff])
> [    2.472094] pci_bus 0000:00: root bus resource [mem 0xf6000000-0xf6efffff]
> [    2.472113] pci 0000:00:00.0: [11ab:0110] type 01 class 0x060400
> [    2.472138] pci 0000:00:00.0: reg 0x10: [mem 0x00000000-0x000fffff 64bit]
> [    2.472192] pci 0000:00:00.0: supports D1 D2
> [    2.472195] pci 0000:00:00.0: PME# supported from D0 D1 D3hot
> [    2.472307] pci 0000:00:00.0: bridge configuration invalid ([bus
> 00-00]), reconfiguring
> [    2.472365] pci_bus 0000:01: busn_res: [bus 01-ff] end is updated to 01
> [    2.472383] pci 0000:00:00.0: BAR 0: assigned [mem
> 0xf6000000-0xf60fffff 64bit]
> [    2.472393] pci 0000:00:00.0: PCI bridge to [bus 01]
> [    2.779832] pcieport 0000:00:00.0: Signaling PME with IRQ 27
> [    2.779895] pcieport 0000:00:00.0: AER enabled with IRQ 27
> [    2.780028] rtc-efi rtc-efi: setting system clock to 2018-05-19
> 00:53:40 UTC (1526691220)
> [    2.787233] Freeing unused kernel memory: 4480K
> [    2.910988] libphy: Fixed MDIO Bus: probed
> [    2.915788] sdhci: Secure Digital Host Controller Interface driver
> [    2.915792] sdhci: Copyright(c) Pierre Ossman
> [    2.916452] sdhci-pltfm: SDHCI platform and OF driver helper
> [    2.927389] usbcore: registered new interface driver usbfs
> [    2.927421] usbcore: registered new interface driver hub
> [    2.929827] usbcore: registered new device driver usb
> [    2.930648] mvpp2 f2000000.ethernet eth0: Using random mac address
> ce:c0:57:1c:27:7c
> [    2.935964] SCSI subsystem initialized
> [    2.936159] libphy: orion_mdio_bus: probed
> [    2.940813] libphy: orion_mdio_bus: probed
> [    2.948693] libata version 3.00 loaded.
> [    2.949269] mmc0: Switching to 3.3V signalling voltage failed
> [    2.951977] mvpp2 f4000000.ethernet eth1: Using random mac address
> aa:6b:ec:75:56:b1
> [    2.963178] mvpp2 f4000000.ethernet eth2: Using random mac address
> 16:4c:90:91:ba:0a
> [    2.964356] armada38x-rtc f4284000.rtc: rtc core: registered
> f4284000.rtc as rtc1
> [    2.988065] mmc0: SDHCI controller on f06e0000.sdhci
> [f06e0000.sdhci] using ADMA 64-bit
> [    3.011934] mmc1: SDHCI controller on f2780000.sdhci
> [f2780000.sdhci] using ADMA 64-bit
> [    3.012770] xhci-hcd f2500000.usb3: xHCI Host Controller
> [    3.012786] xhci-hcd f2500000.usb3: new USB bus registered,
> assigned bus number 1
> [    3.013294] xhci-hcd f2500000.usb3: hcc params 0x0a000990 hci
> version 0x100 quirks 0x00010010
> [    3.013326] xhci-hcd f2500000.usb3: irq 82, io mem 0xf2500000
> [    3.013525] usb usb1: New USB device found, idVendor=1d6b, idProduct=0002
> [    3.013529] usb usb1: New USB device strings: Mfr=3, Product=2,
> SerialNumber=1
> [    3.013533] usb usb1: Product: xHCI Host Controller
> [    3.013536] usb usb1: Manufacturer: Linux 4.15.0-rc7-arm64 xhci-hcd
> [    3.013539] usb usb1: SerialNumber: f2500000.usb3
> [    3.013879] hub 1-0:1.0: USB hub found
> [    3.014944] hub 1-0:1.0: 1 port detected
> [    3.015169] xhci-hcd f2500000.usb3: xHCI Host Controller
> [    3.015177] xhci-hcd f2500000.usb3: new USB bus registered,
> assigned bus number 2
> [    3.015238] usb usb2: We don't know the algorithms for LPM for this
> host, disabling LPM.
> [    3.015309] usb usb2: New USB device found, idVendor=1d6b, idProduct=0003
> [    3.015314] usb usb2: New USB device strings: Mfr=3, Product=2,
> SerialNumber=1
> [    3.015317] usb usb2: Product: xHCI Host Controller
> [    3.015321] usb usb2: Manufacturer: Linux 4.15.0-rc7-arm64 xhci-hcd
> [    3.015324] usb usb2: SerialNumber: f2500000.usb3
> [    3.016118] hub 2-0:1.0: USB hub found
> [    3.016136] hub 2-0:1.0: 1 port detected
> [    3.016465] xhci-hcd f2510000.usb3: xHCI Host Controller
> [    3.016475] xhci-hcd f2510000.usb3: new USB bus registered,
> assigned bus number 3
> [    3.016965] xhci-hcd f2510000.usb3: hcc params 0x0a000990 hci
> version 0x100 quirks 0x00010010
> [    3.016991] xhci-hcd f2510000.usb3: irq 83, io mem 0xf2510000
> [    3.017155] usb usb3: New USB device found, idVendor=1d6b, idProduct=0002
> [    3.017159] usb usb3: New USB device strings: Mfr=3, Product=2,
> SerialNumber=1
> [    3.017162] usb usb3: Product: xHCI Host Controller
> [    3.017165] usb usb3: Manufacturer: Linux 4.15.0-rc7-arm64 xhci-hcd
> [    3.017168] usb usb3: SerialNumber: f2510000.usb3
> [    3.017420] hub 3-0:1.0: USB hub found
> [    3.017443] hub 3-0:1.0: 1 port detected
> [    3.017622] xhci-hcd f2510000.usb3: xHCI Host Controller
> [    3.017629] xhci-hcd f2510000.usb3: new USB bus registered,
> assigned bus number 4
> [    3.017675] usb usb4: We don't know the algorithms for LPM for this
> host, disabling LPM.
> [    3.017733] usb usb4: New USB device found, idVendor=1d6b, idProduct=0003
> [    3.017737] usb usb4: New USB device strings: Mfr=3, Product=2,
> SerialNumber=1
> [    3.017740] usb usb4: Product: xHCI Host Controller
> [    3.017743] usb usb4: Manufacturer: Linux 4.15.0-rc7-arm64 xhci-hcd
> [    3.017746] usb usb4: SerialNumber: f2510000.usb3
> [    3.017970] hub 4-0:1.0: USB hub found
> [    3.017986] hub 4-0:1.0: 1 port detected
> [    3.018421] ahci f2540000.sata: AHCI 0001.0000 32 slots 2 ports 6
> Gbps 0x3 impl platform mode
> [    3.018426] ahci f2540000.sata: flags: 64bit ncq sntf led only pmp
> fbs pio slum part sxs
> [    3.018492] xhci-hcd f4500000.usb3: xHCI Host Controller
> [    3.018503] xhci-hcd f4500000.usb3: new USB bus registered,
> assigned bus number 5
> [    3.019059] xhci-hcd f4500000.usb3: hcc params 0x0a000990 hci
> version 0x100 quirks 0x00010010
> [    3.019080] xhci-hcd f4500000.usb3: irq 84, io mem 0xf4500000
> [    3.019263] scsi host0: ahci
> [    3.019312] usb usb5: New USB device found, idVendor=1d6b, idProduct=0002
> [    3.019316] usb usb5: New USB device strings: Mfr=3, Product=2,
> SerialNumber=1
> [    3.019319] usb usb5: Product: xHCI Host Controller
> [    3.019323] usb usb5: Manufacturer: Linux 4.15.0-rc7-arm64 xhci-hcd
> [    3.019326] usb usb5: SerialNumber: f4500000.usb3
> [    3.019491] scsi host1: ahci
> [    3.019629] ata1: SATA max UDMA/133 mmio [mem
> 0xf2540000-0xf256ffff] port 0x100 irq 85
> [    3.019633] ata2: SATA max UDMA/133 mmio [mem
> 0xf2540000-0xf256ffff] port 0x180 irq 85
> [    3.019642] hub 5-0:1.0: USB hub found
> [    3.019673] hub 5-0:1.0: 1 port detected
> [    3.019858] xhci-hcd f4500000.usb3: xHCI Host Controller
> [    3.019865] xhci-hcd f4500000.usb3: new USB bus registered,
> assigned bus number 6
> [    3.019947] usb usb6: We don't know the algorithms for LPM for this
> host, disabling LPM.
> [    3.020035] usb usb6: New USB device found, idVendor=1d6b, idProduct=0003
> [    3.020039] usb usb6: New USB device strings: Mfr=3, Product=2,
> SerialNumber=1
> [    3.020042] usb usb6: Product: xHCI Host Controller
> [    3.020045] usb usb6: Manufacturer: Linux 4.15.0-rc7-arm64 xhci-hcd
> [    3.020048] usb usb6: SerialNumber: f4500000.usb3
> [    3.020332] hub 6-0:1.0: USB hub found
> [    3.020353] hub 6-0:1.0: 1 port detected
> [    3.020752] ahci f4540000.sata: AHCI 0001.0000 32 slots 2 ports 6
> Gbps 0x3 impl platform mode
> [    3.020758] ahci f4540000.sata: flags: 64bit ncq sntf led only pmp
> fbs pio slum part sxs
> [    3.026127] scsi host2: ahci
> [    3.026428] scsi host3: ahci
> [    3.026547] ata3: SATA max UDMA/133 mmio [mem
> 0xf4540000-0xf456ffff] port 0x100 irq 86
> [    3.026551] ata4: SATA max UDMA/133 mmio [mem
> 0xf4540000-0xf456ffff] port 0x180 irq 86
> [    3.030874] mmc0: new high speed MMC card at address 0001
> [    3.031191] mmcblk0: mmc0:0001 8GME4R 7.28 GiB
> [    3.031331] mmcblk0boot0: mmc0:0001 8GME4R partition 1 4.00 MiB
> [    3.031470] mmcblk0boot1: mmc0:0001 8GME4R partition 2 4.00 MiB
> [    3.031557] mmcblk0rpmb: mmc0:0001 8GME4R partition 3 512 KiB,
> chardev (242:0)
> [    3.034350]  mmcblk0: p1 p2 p3
> [    3.053903] mmc1: new high speed SDHC card at address 1234
> [    3.054238] mmcblk1: mmc1:1234 SA08G 7.41 GiB
> [    3.055423]  mmcblk1: p1 p2
> [    3.334142] ata2: SATA link down (SStatus 0 SControl 300)
> [    3.334175] ata1: SATA link down (SStatus 0 SControl 300)
> [    3.503937] ata3: SATA link up 3.0 Gbps (SStatus 123 SControl 300)
> [    3.503958] ata4: SATA link up 6.0 Gbps (SStatus 133 SControl 300)
> [    3.504175] ata4.00: supports DRM functions and may not be fully accessible
> [    3.504181] ata4.00: ATA-9: Samsung SSD 850 EVO 500GB, EMT02B6Q, max UDMA/133
> [    3.504185] ata4.00: 976773168 sectors, multi 1: LBA48 NCQ (depth 31/32)
> [    3.505757] ata4.00: supports DRM functions and may not be fully accessible
> [    3.507050] ata4.00: configured for UDMA/133
> [    3.511148] ata3.00: ATA-8: WDC WD20EARS-00J99B0, 80.00A80, max UDMA/133
> [    3.511151] ata3.00: 3907029168 sectors, multi 0: LBA48 NCQ (depth 31/32)
> [    3.518179] ata3.00: configured for UDMA/133
> [    3.518433] scsi 2:0:0:0: Direct-Access     ATA      WDC
> WD20EARS-00J 0A80 PQ: 0 ANSI: 5
> [    3.518999] scsi 3:0:0:0: Direct-Access     ATA      Samsung SSD
> 850  2B6Q PQ: 0 ANSI: 5
> [    3.524036] sd 2:0:0:0: [sda] 3907029168 512-byte logical blocks:
> (2.00 TB/1.82 TiB)
> [    3.524042] sd 2:0:0:0: [sda] 4096-byte physical blocks
> [    3.524084] sd 2:0:0:0: [sda] Write Protect is off
> [    3.524088] sd 2:0:0:0: [sda] Mode Sense: 00 3a 00 00
> [    3.524133] sd 2:0:0:0: [sda] Write cache: enabled, read cache:
> enabled, doesn't support DPO or FUA
> [    3.524326] sd 3:0:0:0: [sdb] 976773168 512-byte logical blocks:
> (500 GB/466 GiB)
> [    3.524355] sd 3:0:0:0: [sdb] Write Protect is off
> [    3.524360] sd 3:0:0:0: [sdb] Mode Sense: 00 3a 00 00
> [    3.524410] sd 3:0:0:0: [sdb] Write cache: enabled, read cache:
> enabled, doesn't support DPO or FUA
> [    3.525680] sd 3:0:0:0: [sdb] Attached SCSI removable disk
> [    3.540619]  sda: sda1 sda2
> [    3.541248] sd 2:0:0:0: [sda] Attached SCSI removable disk
> [    3.815843] mmc0: Switching to 3.3V signalling voltage failed
> [    3.822247] PM: Starting manual resume from disk
> [    3.822515] PM: Image not found (code -22)
> [    3.937618] EXT4-fs (mmcblk0p2): mounted filesystem with ordered
> data mode. Opts: (null)
> [    4.308264] ip_tables: (C) 2000-2006 Netfilter Core Team
> [    4.335334] systemd[1]: systemd 236 running in system mode. (+PAM
> +AUDIT +SELINUX +IMA +APPARMOR +SMACK +SYSVINIT +UTMP +LIBCRYPTSETUP
> +GCRY
> PT +GNUTLS +ACL +XZ +LZ4 +SECCOMP +BLKID +ELFUTILS +KMOD -IDN2 +IDN
> default-hierarchy=hybrid)
> [    4.335635] systemd[1]: Detected architecture arm64.
> [    4.339813] systemd[1]: Set hostname to <debian>.
> [    4.475258] systemd-gpt-auto-generator[205]: Failed to dissect:
> Input/output error
> [    4.483749] systemd[200]:
> /lib/systemd/system-generators/systemd-gpt-auto-generator failed with
> error code 1.
> [    4.494976] systemd[1]: File
> /lib/systemd/system/systemd-journald.service:35 configures an IP
> firewall (IPAddressDeny=any), but the local sy
> stem does not support BPF/cgroup based firewalling.
> [    4.494983] systemd[1]: Proceeding WITHOUT firewalling in effect!
> (This warning is only shown for the first loaded unit using IP
> firewalling
> .)
> [    4.561763] systemd[1]: Reached target Remote File Systems.
> [    4.561976] systemd[1]: Started Forward Password Requests to Wall
> Directory Watch.
> [    4.562075] systemd[1]: Started Dispatch Password Requests to
> Console Directory Watch.
> [    4.562094] systemd[1]: Reached target Paths.
> [    4.624825] EXT4-fs (mmcblk0p2): re-mounted. Opts: errors=remount-ro
> [    4.693929] systemd-journald[217]: Received request to flush
> runtime journal from PID 1
> [    4.796241] sbsa-gwdt f0610000.watchdog: Initialized with 10s
> timeout @ 25000000 Hz, action=0.
> [    4.811412] EFI Variables Facility v0.08 2004-May-17
> [    4.834118] pstore: using zlib compression
> [    4.837066] shpchp: Standard Hot Plug PCI Controller Driver version: 0.4
> [    4.844672] pstore: Registered efi as persistent store backend
> [    4.896049] sd 2:0:0:0: Attached scsi generic sg0 type 0
> [    4.896176] sd 3:0:0:0: Attached scsi generic sg1 type 0
> [    4.990475] Adding 3942396k swap on /dev/mmcblk0p3.  Priority:-2
> extents:1 across:3942396k SSFS
> [    5.284816] audit: type=1400 audit(1526691223.000:2):
> apparmor="STATUS" operation="profile_load" profile="unconfined"
> name="/usr/bin/man" pi
> d=370 comm="apparmor_parser"
> [    5.284825] audit: type=1400 audit(1526691223.000:3):
> apparmor="STATUS" operation="profile_load" profile="unconfined"
> name="/usr/bin/man//fi
> lter" pid=370 comm="apparmor_parser"
> [    5.284831] audit: type=1400 audit(1526691223.000:4):
> apparmor="STATUS" operation="profile_load" profile="unconfined"
> name="/usr/bin/man//gr
> off" pid=370 comm="apparmor_parser"
> [    5.618325] IPv6: ADDRCONF(NETDEV_UP): eth2: link is not ready
> [    5.710874] mmc0: Switching to 3.3V signalling voltage failed
> [    9.796332] mvpp2 f4000000.ethernet eth2: Link is Up - 1Gbps/Full -
> flow control off
> [    9.796350] IPv6: ADDRCONF(NETDEV_CHANGE): eth2: link becomes ready
> [    9.800076] mmc0: Switching to 3.3V signalling voltage failed
> [   14.052137] mmc0: Switching to 3.3V signalling voltage failed
> [   15.844178] mmc0: Switching to 3.3V signalling voltage failed
> [   21.988130] mmc0: Switching to 3.3V signalling voltage failed
> [   22.050680] mmc0: Switching to 3.3V signalling voltage failed
> [   22.155246] mmc0: Switching to 3.3V signalling voltage failed
> [   22.845074] mmc0: Switching to 3.3V signalling voltage failed
> [   22.917350] mmc0: Switching to 3.3V signalling voltage failed
> [   24.834819] mmc0: Switching to 3.3V signalling voltage failed
> [   26.195699] mmc0: Switching to 3.3V signalling voltage failed
> [   27.876102] mmc0: Switching to 3.3V signalling voltage failed
> [   29.170275] mmc0: Switching to 3.3V signalling voltage failed
> [   34.020058] mmc0: Switching to 3.3V signalling voltage failed
> [   36.570406] mmc0: Switching to 3.3V signalling voltage failed
> [   39.139512] mmc0: Switching to 3.3V signalling voltage failed
> [   40.652720] mmc0: Switching to 3.3V signalling voltage failed
> [   44.772152] mmc0: Switching to 3.3V signalling voltage failed
> [   49.892041] mmc0: Switching to 3.3V signalling voltage failed
> [   50.420898] mmc0: Switching to 3.3V signalling voltage failed
> [   51.938299] random: crng init done
> [   55.012204] mmc0: Switching to 3.3V signalling voltage failed
> [   60.900100] mmc0: Switching to 3.3V signalling voltage failed
> [   67.044040] mmc0: Switching to 3.3V signalling voltage failed
> [   67.231406] mmc0: Switching to 3.3V signalling voltage failed
> [   72.931749] mmc0: Switching to 3.3V signalling voltage failed
> [   75.491437] mmc0: Switching to 3.3V signalling voltage failed
> [   78.819241] mmc0: Switching to 3.3V signalling voltage failed
> [   80.611246] mmc0: Switching to 3.3V signalling voltage failed
> [   84.962989] mmc0: Switching to 3.3V signalling voltage failed
> [   90.330158] mmc0: Switching to 3.3V signalling voltage failed
> [   93.332842] mmc0: Switching to 3.3V signalling voltage failed
> [   93.336740] omap_rng f2760000.trng: Random Number Generator ver. 203b34c
> [   95.970664] mmc0: Switching to 3.3V signalling voltage failed
> [  101.862573] mmc0: Switching to 3.3V signalling voltage failed
> [  106.210610] mmc0: Switching to 3.3V signalling voltage failed
> [  108.002491] mmc0: Switching to 3.3V signalling voltage failed
> [  111.334419] mmc0: Switching to 3.3V signalling voltage failed
> [  113.894416] mmc0: Switching to 3.3V signalling voltage failed
> [  114.330328] INFO: rcu_sched self-detected stall on CPU
> [  114.335500]  0-....: (5249 ticks this GP)
> idle=3b6/140000000000002/0 softirq=2065/2065 fqs=1944
> [  114.344325]
> [  114.344327] INFO: rcu_sched detected stalls on CPUs/tasks:
> [  114.344336]  0-....: (5249 ticks this GP)
> idle=3b6/140000000000002/0 softirq=2065/2065 fqs=1945
> [  114.344337]  (detected by 3, t=5252 jiffies, g=375, c=374, q=836)
> [  114.330328] INFO: rcu_sched self-detected stall on CPU
> [  114.335500]  0-....: (5249 ticks this GP)
> idle=3b6/140000000000002/0 softirq=2065/2065 fqs=1944
> [  114.344325]
> [  114.344327] INFO: rcu_sched detected stalls on CPUs/tasks:
> [  114.344336]  0-....: (5249 ticks this GP)
> idle=3b6/140000000000002/0 softirq=2065/2065 fqs=1945
> [  114.344337]  (detected by 3, t=5252 jiffies, g=375, c=374, q=836)
> [  114.344342] Task dump for CPU 0:
> [  114.344344] modprobe        R  running task        0   543    486 0x00000022
> [  114.344350] Call trace:
> [  114.344361]  __switch_to+0x98/0xb0
> [  114.344367]  __setup_irq+0x798/0x7f8
> [  114.366360]  (t=5259 jiffies g=375 c=374 q=836)
> [  114.366362] Task dump for CPU 0:
> [  114.366365] modprobe        R  running task        0   543    486 0x00000022
> [  114.366372] Call trace:
> [  114.366381]  dump_backtrace+0x0/0x200
> [  114.366386]  show_stack+0x24/0x30
> [  114.366391]  sched_show_task+0x174/0x198
> [  114.366394]  dump_cpu_task+0x48/0x58
> [  114.366399]  rcu_dump_cpu_stacks+0x9c/0xe0
> [  114.366403]  rcu_check_callbacks+0x6cc/0x908
> [  114.366406]  update_process_times+0x34/0x60
> [  114.366412]  tick_sched_handle.isra.5+0x34/0x70
> [  114.366415]  tick_sched_timer+0x48/0x98
> [  114.366419]  __hrtimer_run_queues+0xdc/0x2b8
> [  114.366422]  hrtimer_interrupt+0xa8/0x228
> [  114.366427]  arch_timer_handler_phys+0x38/0x58
> [  114.366431]  handle_percpu_devid_irq+0x90/0x268
> [  114.366436]  generic_handle_irq+0x34/0x50
> [  114.366439]  __handle_domain_irq+0x68/0xc0
> [  114.366442]  gic_handle_irq+0x60/0xb0
> [  114.366444]  el1_irq+0xb0/0x140
> [  114.366447]  __do_softirq+0xb0/0x334
> [  114.366451]  irq_exit+0xc0/0xf0
> [  114.366454]  __handle_domain_irq+0x6c/0xc0
> [  114.366456]  gic_handle_irq+0x60/0xb0
> [  114.366459]  el1_irq+0xb0/0x140
> [  114.366464]  _raw_spin_unlock_irqrestore+0x2c/0x38
> [  114.366467]  __setup_irq+0x548/0x7f8
> [  114.366470]  request_threaded_irq+0xf0/0x1b0
> [  114.366474]  devm_request_threaded_irq+0x80/0xf8
> [  114.366486]  omap_rng_probe+0x1f4/0x418 [omap_rng]
> [  114.366491]  platform_drv_probe+0x60/0xc0
> [  114.366496]  driver_probe_device+0x33c/0x4a0
> [  114.366499]  __driver_attach+0xdc/0x128
> [  114.366503]  bus_for_each_dev+0x78/0xd8
> [  114.366506]  driver_attach+0x30/0x40
> [  114.366510]  bus_add_driver+0x218/0x2b8
> [  114.366513]  driver_register+0x6c/0x118
> [  114.366516]  __platform_driver_register+0x54/0x60
> [  114.366522]  omap_rng_driver_init+0x20/0x1000 [omap_rng]
> [  114.366525]  do_one_initcall+0x58/0x168
> [  114.366529]  do_init_module+0x64/0x1d8
> [  114.366533]  load_module.isra.36+0x20e0/0x26a8
> [  114.366537]  SyS_finit_module+0x100/0x120
> [  114.366540]  el0_svc_naked+0x20/0x24
> [  116.454456] mmc0: Switching to 3.3V signalling voltage failed
> [  120.038421] mmc0: Switching to 3.3V signalling voltage failed
> [  125.922372] mmc0: Switching to 3.3V signalling voltage failed
> [  126.690483] mmc0: Switching to 3.3V signalling voltage failed
> [  131.810396] mmc0: Switching to 3.3V signalling voltage failed
> [  136.934029] mmc0: Switching to 3.3V signalling voltage failed
> [  140.005535] watchdog: BUG: soft lockup - CPU#0 stuck for 22s! [modprobe:543]
> [  140.005535] watchdog: BUG: soft lockup - CPU#0 stuck for 22s! [modprobe:543]
> [  140.012617] Modules linked in: omap_rng(+) rng_core nls_ascii
> nls_cp437 vfat fat aes_ce_blk crypto_simd cryptd sg aes_ce_cipher
> ghash_ce gf1
> 28mul sha2_ce shpchp efi_pstore efivars sha256_arm64 sbsa_gwdt sha1_ce
> efivarfs ip_tables x_tables autofs4 ext4 crc16 mbcache jbd2
> crc32c_gener
> ic fscrypto ecb aes_arm64 sd_mod phy_generic ahci_platform
> libahci_platform libahci libata marvell rtc_armada38x xhci_plat_hcd
> xhci_hcd scsi_mo
> d fixed usbcore i2c_mv64xxx sdhci_xenon_driver sdhci_pltfm sdhci
> mvmdio mvpp2 of_mdio fixed_phy phy_mvebu_cp110_comphy libphy
> [  140.012715] CPU: 0 PID: 543 Comm: modprobe Not tainted
> 4.15.0-rc7-arm64 #1 Debian 4.15~rc7-1~exp1
> [  140.012717] Hardware name: Marvell Armada 8040 MacchiatoBin/Armada
> 8040 MacchiatoBin, BIOS EDK II Dec 12 2017
> [  140.012721] pstate: 40000005 (nZcv daif -PAN -UAO)
> [  140.012725] pc : __do_softirq+0xb0/0x334
> [  140.012729] lr : irq_exit+0xc0/0xf0
> [  140.012731] sp : ffff000008003ed0
> [  140.012733] x29: ffff000008003ed0 x28: 0000000000000282
> [  140.012739] x27: 0000000000000000 x26: ffff000008004000
> [  140.012744] x25: ffff000008000000 x24: ffff3d049fa31000
> [  140.012749] x23: ffff000009e93770 x22: 0000000000000000
> [  140.012754] x21: 0000000000000000 x20: 0000000000000003
>
> Message from syslogd@debian at Jan  9 09:58:21 ...
>  kernel:[  140.005535] watchdog: BUG: soft lockup - CPU#0 stuck for
> 22s! [modprobe:543]
> [  140.012759] x19: ffff3d049fa31000 x18: 0000000000000014
> [  140.012764] x17: 000000000000000e x16: 0000000000000007
> [  140.012769] x15: 0000000000000001 x14: 0000000000000000
> [  140.012774] x13: 0000000000000033 x12: 0000000000000000
> [  140.012779] x11: ffff3d049f672150 x10: 0000000000000177
> [  140.012784] x9 : ffff3d049f672158 x8 : 0000000000000000
> [  140.012789] x7 : 0000000000000004 x6 : 00000000a6e967d8
> [  140.012794] x5 : 00ffffffffffffff x4 : 00000000ffff362f
> [  140.012799] x3 : ffff3d049fef9980 x2 : 0000a1aee0539000
> [  140.012804] x1 : ffff3d049fef9980 x0 : 0000000000000000
> [  140.012809] Call trace:
> [  140.012813]  __do_softirq+0xb0/0x334
> [  140.012816]  irq_exit+0xc0/0xf0
> [  140.012819]  __handle_domain_irq+0x6c/0xc0
> [  140.012822]  gic_handle_irq+0x60/0xb0
> [  140.012824]  el1_irq+0xb0/0x140
> [  140.012828]  _raw_spin_unlock_irqrestore+0x2c/0x38
> [  140.012831]  __setup_irq+0x548/0x7f8
> [  140.012834]  request_threaded_irq+0xf0/0x1b0
> [  140.012838]  devm_request_threaded_irq+0x80/0xf8
> [  140.012846]  omap_rng_probe+0x1f4/0x418 [omap_rng]
> [  140.012849]  platform_drv_probe+0x60/0xc0
> [  140.012853]  driver_probe_device+0x33c/0x4a0
> [  140.012857]  __driver_attach+0xdc/0x128
> [  140.012860]  bus_for_each_dev+0x78/0xd8
> [  140.012864]  driver_attach+0x30/0x40
> [  140.012867]  bus_add_driver+0x218/0x2b8
> [  140.012871]  driver_register+0x6c/0x118
> [  140.012874]  __platform_driver_register+0x54/0x60
> [  140.012879]  omap_rng_driver_init+0x20/0x1000 [omap_rng]
> [  140.012882]  do_one_initcall+0x58/0x168
> [  140.012886]  do_init_module+0x64/0x1d8
> [  140.012890]  load_module.isra.36+0x20e0/0x26a8
> [  140.012894]  SyS_finit_module+0x100/0x120
> [  140.012896]  el0_svc_naked+0x20/0x24
> [  142.049544] mmc0: Switching to 3.3V signalling voltage failed
>
> _______________________________________________
> linux-arm-kernel mailing list
> linux-arm-kernel@lists.infradead.org
> http://lists.infradead.org/mailman/listinfo/linux-arm-kernel

-- 
Gregory Clement, Free Electrons
Kernel, drivers, real-time and embedded Linux
development, consulting, training and support.
http://free-electrons.com
