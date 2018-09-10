From: "Theodore Y. Ts'o" <tytso@mit.edu>
Subject: Re: rng_dev_read: Kernel memory exposure attempt detected from SLUB
 object 'kmalloc-64'
Date: Mon, 10 Sep 2018 15:53:42 -0400
Message-ID: <20180910195342.GD16557@thunk.org>
References: <alpine.LRH.2.21.1809102006280.8926@math.ut.ee>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Linux Kernel list <linux-kernel@vger.kernel.org>,
        linux-crypto@vger.kernel.org
To: Meelis Roos <mroos@linux.ee>
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <alpine.LRH.2.21.1809102006280.8926@math.ut.ee>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

On Mon, Sep 10, 2018 at 08:08:51PM +0300, Meelis Roos wrote:
> This is weekend's 4.19.0-rc2-00246-gd7b686ebf704 on a Thinkad T460s. 
> There seems to be a usercopy warning from rng_dev read (full dmesg 
> below).

Looking at rng_dev_head(), which is in drivers/char/hw_random.c, it
looks like this was probably caused by a problem in the specific
hardware random number generator being used.  Can you tell us which
one was in use?

Thanks!!
						- Ted


> [    0.000000] microcode: microcode updated early to revision 0xc6, date = 2018-04-17
> [    0.000000] Linux version 4.19.0-rc2-00246-gd7b686ebf704 (mroos@t460s) (gcc version 8.2.0 (Debian 8.2.0-5)) #36 SMP Sat Sep 8 16:27:54 EEST 2018
> [    0.000000] Command line: BOOT_IMAGE=/vmlinuz-4.19.0-rc2-00246-gd7b686ebf704 root=/dev/mapper/TP-ROOT ro
> [    0.000000] x86/fpu: Supporting XSAVE feature 0x001: 'x87 floating point registers'
> [    0.000000] x86/fpu: Supporting XSAVE feature 0x002: 'SSE registers'
> [    0.000000] x86/fpu: Supporting XSAVE feature 0x004: 'AVX registers'
> [    0.000000] x86/fpu: Supporting XSAVE feature 0x008: 'MPX bounds registers'
> [    0.000000] x86/fpu: Supporting XSAVE feature 0x010: 'MPX CSR'
> [    0.000000] x86/fpu: xstate_offset[2]:  576, xstate_sizes[2]:  256
> [    0.000000] x86/fpu: xstate_offset[3]:  832, xstate_sizes[3]:   64
> [    0.000000] x86/fpu: xstate_offset[4]:  896, xstate_sizes[4]:   64
> [    0.000000] x86/fpu: Enabled xstate features 0x1f, context size is 960 bytes, using 'compacted' format.
> [    0.000000] BIOS-provided physical RAM map:
> [    0.000000] BIOS-e820: [mem 0x0000000000000000-0x000000000009cfff] usable
> [    0.000000] BIOS-e820: [mem 0x000000000009d000-0x000000000009ffff] reserved
> [    0.000000] BIOS-e820: [mem 0x00000000000e0000-0x00000000000fffff] reserved
> [    0.000000] BIOS-e820: [mem 0x0000000000100000-0x00000000b100afff] usable
> [    0.000000] BIOS-e820: [mem 0x00000000b100b000-0x00000000c3ed5fff] reserved
> [    0.000000] BIOS-e820: [mem 0x00000000c3ed6000-0x00000000c3ed6fff] ACPI NVS
> [    0.000000] BIOS-e820: [mem 0x00000000c3ed7000-0x00000000cff75fff] reserved
> [    0.000000] BIOS-e820: [mem 0x00000000cff76000-0x00000000cff77fff] ACPI NVS
> [    0.000000] BIOS-e820: [mem 0x00000000cff78000-0x00000000cff78fff] reserved
> [    0.000000] BIOS-e820: [mem 0x00000000cff79000-0x00000000cffc5fff] ACPI NVS
> [    0.000000] BIOS-e820: [mem 0x00000000cffc6000-0x00000000cfffdfff] ACPI data
> [    0.000000] BIOS-e820: [mem 0x00000000cfffe000-0x00000000d7ffffff] reserved
> [    0.000000] BIOS-e820: [mem 0x00000000d8600000-0x00000000dc7fffff] reserved
> [    0.000000] BIOS-e820: [mem 0x00000000f8000000-0x00000000fbffffff] reserved
> [    0.000000] BIOS-e820: [mem 0x00000000fd000000-0x00000000fe7fffff] reserved
> [    0.000000] BIOS-e820: [mem 0x00000000fec00000-0x00000000fec00fff] reserved
> [    0.000000] BIOS-e820: [mem 0x00000000fed00000-0x00000000fed00fff] reserved
> [    0.000000] BIOS-e820: [mem 0x00000000fed10000-0x00000000fed19fff] reserved
> [    0.000000] BIOS-e820: [mem 0x00000000fed84000-0x00000000fed84fff] reserved
> [    0.000000] BIOS-e820: [mem 0x00000000fee00000-0x00000000fee00fff] reserved
> [    0.000000] BIOS-e820: [mem 0x00000000ff800000-0x00000000ffffffff] reserved
> [    0.000000] BIOS-e820: [mem 0x0000000100000000-0x00000003227fffff] usable
> [    0.000000] NX (Execute Disable) protection: active
> [    0.000000] SMBIOS 2.8 present.
> [    0.000000] DMI: LENOVO 20F9003SMS/20F9003SMS, BIOS N1CET65W (1.33 ) 02/16/2018
> [    0.000000] tsc: Detected 2400.000 MHz processor
> [    0.002224] e820: update [mem 0x00000000-0x00000fff] usable ==> reserved
> [    0.002226] e820: remove [mem 0x000a0000-0x000fffff] usable
> [    0.002234] last_pfn = 0x322800 max_arch_pfn = 0x400000000
> [    0.002238] MTRR default type: write-back
> [    0.002239] MTRR fixed ranges enabled:
> [    0.002240]   00000-9FFFF write-back
> [    0.002241]   A0000-BFFFF uncachable
> [    0.002242]   C0000-FFFFF write-protect
> [    0.002242] MTRR variable ranges enabled:
> [    0.002244]   0 base 00E0000000 mask 7FE0000000 uncachable
> [    0.002245]   1 base 00DC000000 mask 7FFC000000 uncachable
> [    0.002246]   2 base 00DA000000 mask 7FFE000000 uncachable
> [    0.002246]   3 disabled
> [    0.002246]   4 disabled
> [    0.002247]   5 disabled
> [    0.002247]   6 disabled
> [    0.002248]   7 disabled
> [    0.002248]   8 disabled
> [    0.002248]   9 disabled
> [    0.003223] x86/PAT: Configuration [0-7]: WB  WC  UC- UC  WB  WP  UC- WT  
> [    0.003726] last_pfn = 0xb100b max_arch_pfn = 0x400000000
> [    0.011684] Scanning 1 areas for low memory corruption
> [    0.011688] Base memory trampoline at [(____ptrval____)] 97000 size 24576
> [    0.011691] Using GB pages for direct mapping
> [    0.011693] BRK [0x2422f6000, 0x2422f6fff] PGTABLE
> [    0.011695] BRK [0x2422f7000, 0x2422f7fff] PGTABLE
> [    0.011696] BRK [0x2422f8000, 0x2422f8fff] PGTABLE
> [    0.011724] BRK [0x2422f9000, 0x2422f9fff] PGTABLE
> [    0.011726] BRK [0x2422fa000, 0x2422fafff] PGTABLE
> [    0.011888] BRK [0x2422fb000, 0x2422fbfff] PGTABLE
> [    0.011917] BRK [0x2422fc000, 0x2422fcfff] PGTABLE
> [    0.011986] RAMDISK: [mem 0x36a31000-0x3750ffff]
> [    0.011996] ACPI: Early table checksum verification disabled
> [    0.012029] ACPI: RSDP 0x00000000000F0120 000024 (v02 LENOVO)
> [    0.012033] ACPI: XSDT 0x00000000CFFCF188 0000EC (v01 LENOVO TP-N1C   00000000 PTEC 00000002)
> [    0.012039] ACPI: FACP 0x00000000CFFF1000 0000F4 (v05 LENOVO TP-N1C   00001330 PTEC 00000002)
> [    0.012044] ACPI: DSDT 0x00000000CFFDA000 01258F (v02 LENOVO TP-N1C   00001330 INTL 20141107)
> [    0.012047] ACPI: FACS 0x00000000CFF90000 000040
> [    0.012050] ACPI: TCPA 0x00000000CFFFB000 000032 (v02 LENOVO TP-N1C   00000002 PTEC 00000002)
> [    0.012053] ACPI: SSDT 0x00000000CFFFA000 0004B7 (v02 LENOVO Tpm2Tabl 00001000 INTL 20141107)
> [    0.012056] ACPI: SSDT 0x00000000CFFF9000 00004B (v02 LENOVO MeSsdt   00003000 INTL 20141107)
> [    0.012058] ACPI: TPM2 0x00000000CFFF8000 000034 (v03 LENOVO TP-N1C   00001330 PTEC 00000002)
> [    0.012061] ACPI: UEFI 0x00000000CFFA7000 000042 (v01 LENOVO TP-N1C   00001330 PTEC 00000002)
> [    0.012064] ACPI: SSDT 0x00000000CFFF3000 004E0A (v02 LENOVO SaSsdt   00003000 INTL 20141107)
> [    0.012067] ACPI: SSDT 0x00000000CFFF2000 0005C5 (v02 LENOVO PerfTune 00001000 INTL 20141107)
> [    0.012070] ACPI: ECDT 0x00000000CFFF0000 000052 (v01 LENOVO TP-N1C   00001330 PTEC 00000002)
> [    0.012073] ACPI: HPET 0x00000000CFFEF000 000038 (v01 LENOVO TP-N1C   00001330 PTEC 00000002)
> [    0.012076] ACPI: APIC 0x00000000CFFEE000 0000BC (v03 LENOVO TP-N1C   00001330 PTEC 00000002)
> [    0.012078] ACPI: MCFG 0x00000000CFFED000 00003C (v01 LENOVO TP-N1C   00001330 PTEC 00000002)
> [    0.012081] ACPI: SSDT 0x00000000CFFD8000 0018D2 (v01 LENOVO SataAhci 00001000 INTL 20141107)
> [    0.012084] ACPI: DBGP 0x00000000CFFD7000 000034 (v01 LENOVO TP-N1C   00001330 PTEC 00000002)
> [    0.012087] ACPI: DBG2 0x00000000CFFD6000 000054 (v00 LENOVO TP-N1C   00001330 PTEC 00000002)
> [    0.012090] ACPI: BOOT 0x00000000CFFD5000 000028 (v01 LENOVO TP-N1C   00001330 PTEC 00000002)
> [    0.012093] ACPI: BATB 0x00000000CFFD4000 00004A (v02 LENOVO TP-N1C   00001330 PTEC 00000002)
> [    0.012095] ACPI: SLIC 0x00000000CFFD3000 000176 (v01 LENOVO TP-N1C   00001330 PTEC 00000002)
> [    0.012098] ACPI: SSDT 0x00000000CFFD2000 000E73 (v02 LENOVO CpuSsdt  00003000 INTL 20141107)
> [    0.012101] ACPI: SSDT 0x00000000CFFD1000 000403 (v02 LENOVO CtdpB    00001000 INTL 20141107)
> [    0.012104] ACPI: MSDM 0x00000000CFFD0000 000055 (v03 LENOVO TP-N1C   00001330 PTEC 00000002)
> [    0.012107] ACPI: DMAR 0x00000000CFFFC000 0000A8 (v01 LENOVO TP-N1C   00001330 PTEC 00000002)
> [    0.012110] ACPI: ASF! 0x00000000CFFCE000 0000A5 (v32 LENOVO TP-N1C   00001330 PTEC 00000002)
> [    0.012113] ACPI: FPDT 0x00000000CFFCD000 000044 (v01 LENOVO TP-N1C   00001330 PTEC 00000002)
> [    0.012115] ACPI: UEFI 0x00000000CFF8E000 00013E (v01 LENOVO TP-N1C   00001330 PTEC 00000002)
> [    0.012123] ACPI: Local APIC address 0xfee00000
> [    0.012139] Zone ranges:
> [    0.012140]   DMA      [mem 0x0000000000001000-0x0000000000ffffff]
> [    0.012142]   DMA32    [mem 0x0000000001000000-0x00000000ffffffff]
> [    0.012143]   Normal   [mem 0x0000000100000000-0x00000003227fffff]
> [    0.012145] Movable zone start for each node
> [    0.012145] Early memory node ranges
> [    0.012146]   node   0: [mem 0x0000000000001000-0x000000000009cfff]
> [    0.012148]   node   0: [mem 0x0000000000100000-0x00000000b100afff]
> [    0.012148]   node   0: [mem 0x0000000100000000-0x00000003227fffff]
> [    0.012625] Reserved but unavailable: 28761 pages
> [    0.012627] Initmem setup node 0 [mem 0x0000000000001000-0x00000003227fffff]
> [    0.012628] On node 0 totalpages: 2963367
> [    0.012629]   DMA zone: 64 pages used for memmap
> [    0.012630]   DMA zone: 21 pages reserved
> [    0.012631]   DMA zone: 3996 pages, LIFO batch:0
> [    0.012705]   DMA32 zone: 11265 pages used for memmap
> [    0.012706]   DMA32 zone: 720907 pages, LIFO batch:63
> [    0.027072]   Normal zone: 34976 pages used for memmap
> [    0.027072]   Normal zone: 2238464 pages, LIFO batch:63
> [    0.067222] Reserving Intel graphics memory at [mem 0xda800000-0xdc7fffff]
> [    0.067443] ACPI: PM-Timer IO Port: 0x1808
> [    0.067444] ACPI: Local APIC address 0xfee00000
> [    0.067449] ACPI: LAPIC_NMI (acpi_id[0x01] high edge lint[0x1])
> [    0.067450] ACPI: LAPIC_NMI (acpi_id[0x02] high edge lint[0x1])
> [    0.067451] ACPI: LAPIC_NMI (acpi_id[0x03] high edge lint[0x1])
> [    0.067452] ACPI: LAPIC_NMI (acpi_id[0x04] high edge lint[0x1])
> [    0.067453] ACPI: LAPIC_NMI (acpi_id[0x05] high edge lint[0x1])
> [    0.067454] ACPI: LAPIC_NMI (acpi_id[0x06] high edge lint[0x1])
> [    0.067454] ACPI: LAPIC_NMI (acpi_id[0x07] high edge lint[0x1])
> [    0.067455] ACPI: LAPIC_NMI (acpi_id[0x08] high edge lint[0x1])
> [    0.067487] IOAPIC[0]: apic_id 2, version 32, address 0xfec00000, GSI 0-119
> [    0.067489] ACPI: INT_SRC_OVR (bus 0 bus_irq 0 global_irq 2 dfl dfl)
> [    0.067490] ACPI: INT_SRC_OVR (bus 0 bus_irq 9 global_irq 9 high level)
> [    0.067492] ACPI: IRQ0 used by override.
> [    0.067493] ACPI: IRQ9 used by override.
> [    0.067494] Using ACPI (MADT) for SMP configuration information
> [    0.067496] ACPI: HPET id: 0x8086a201 base: 0xfed00000
> [    0.067499] smpboot: Allowing 4 CPUs, 0 hotplug CPUs
> [    0.067515] PM: Registered nosave memory: [mem 0x00000000-0x00000fff]
> [    0.067516] PM: Registered nosave memory: [mem 0x0009d000-0x0009ffff]
> [    0.067517] PM: Registered nosave memory: [mem 0x000a0000-0x000dffff]
> [    0.067518] PM: Registered nosave memory: [mem 0x000e0000-0x000fffff]
> [    0.067520] PM: Registered nosave memory: [mem 0xb100b000-0xc3ed5fff]
> [    0.067520] PM: Registered nosave memory: [mem 0xc3ed6000-0xc3ed6fff]
> [    0.067521] PM: Registered nosave memory: [mem 0xc3ed7000-0xcff75fff]
> [    0.067522] PM: Registered nosave memory: [mem 0xcff76000-0xcff77fff]
> [    0.067523] PM: Registered nosave memory: [mem 0xcff78000-0xcff78fff]
> [    0.067524] PM: Registered nosave memory: [mem 0xcff79000-0xcffc5fff]
> [    0.067525] PM: Registered nosave memory: [mem 0xcffc6000-0xcfffdfff]
> [    0.067525] PM: Registered nosave memory: [mem 0xcfffe000-0xd7ffffff]
> [    0.067526] PM: Registered nosave memory: [mem 0xd8000000-0xd85fffff]
> [    0.067527] PM: Registered nosave memory: [mem 0xd8600000-0xdc7fffff]
> [    0.067528] PM: Registered nosave memory: [mem 0xdc800000-0xf7ffffff]
> [    0.067528] PM: Registered nosave memory: [mem 0xf8000000-0xfbffffff]
> [    0.067529] PM: Registered nosave memory: [mem 0xfc000000-0xfcffffff]
> [    0.067530] PM: Registered nosave memory: [mem 0xfd000000-0xfe7fffff]
> [    0.067531] PM: Registered nosave memory: [mem 0xfe800000-0xfebfffff]
> [    0.067532] PM: Registered nosave memory: [mem 0xfec00000-0xfec00fff]
> [    0.067532] PM: Registered nosave memory: [mem 0xfec01000-0xfecfffff]
> [    0.067533] PM: Registered nosave memory: [mem 0xfed00000-0xfed00fff]
> [    0.067534] PM: Registered nosave memory: [mem 0xfed01000-0xfed0ffff]
> [    0.067535] PM: Registered nosave memory: [mem 0xfed10000-0xfed19fff]
> [    0.067536] PM: Registered nosave memory: [mem 0xfed1a000-0xfed83fff]
> [    0.067536] PM: Registered nosave memory: [mem 0xfed84000-0xfed84fff]
> [    0.067537] PM: Registered nosave memory: [mem 0xfed85000-0xfedfffff]
> [    0.067538] PM: Registered nosave memory: [mem 0xfee00000-0xfee00fff]
> [    0.067539] PM: Registered nosave memory: [mem 0xfee01000-0xff7fffff]
> [    0.067540] PM: Registered nosave memory: [mem 0xff800000-0xffffffff]
> [    0.067542] [mem 0xdc800000-0xf7ffffff] available for PCI devices
> [    0.067545] clocksource: refined-jiffies: mask: 0xffffffff max_cycles: 0xffffffff, max_idle_ns: 1910969940391419 ns
> [    0.176376] random: get_random_bytes called from start_kernel+0x8a/0x4ee with crng_init=0
> [    0.176385] setup_percpu: NR_CPUS:8 nr_cpumask_bits:8 nr_cpu_ids:4 nr_node_ids:1
> [    0.176619] percpu: Embedded 44 pages/cpu @(____ptrval____) s139672 r8192 d32360 u524288
> [    0.176626] pcpu-alloc: s139672 r8192 d32360 u524288 alloc=1*2097152
> [    0.176627] pcpu-alloc: [0] 0 1 2 3 
> [    0.176646] Built 1 zonelists, mobility grouping on.  Total pages: 2917041
> [    0.176648] Kernel command line: BOOT_IMAGE=/vmlinuz-4.19.0-rc2-00246-gd7b686ebf704 root=/dev/mapper/TP-ROOT ro
> [    0.177603] Dentry cache hash table entries: 2097152 (order: 12, 16777216 bytes)
> [    0.178042] Inode-cache hash table entries: 1048576 (order: 11, 8388608 bytes)
> [    0.211705] Memory: 11536920K/11853468K available (12316K kernel code, 1370K rwdata, 3100K rodata, 1140K init, 580K bss, 316548K reserved, 0K cma-reserved)
> [    0.211750] SLUB: HWalign=64, Order=0-3, MinObjects=0, CPUs=4, Nodes=1
> [    0.211755] Kernel/User page tables isolation: enabled
> [    0.228135] rcu: Hierarchical RCU implementation.
> [    0.228137] rcu: 	RCU restricting CPUs from NR_CPUS=8 to nr_cpu_ids=4.
> [    0.228138] rcu: Adjusting geometry for rcu_fanout_leaf=16, nr_cpu_ids=4
> [    0.228277] NR_IRQS: 4352, nr_irqs: 1024, preallocated irqs: 16
> [    0.231296] Console: colour VGA+ 80x25
> [    0.254588] console [tty0] enabled
> [    0.254720] ACPI: Core revision 20180810
> [    0.255191] clocksource: hpet: mask: 0xffffffff max_cycles: 0xffffffff, max_idle_ns: 79635855245 ns
> [    0.255431] hpet clockevent registered
> [    0.255473] APIC: Switch to symmetric I/O mode setup
> [    0.255607] DMAR: Host address width 39
> [    0.255736] DMAR: DRHD base: 0x000000fed90000 flags: 0x0
> [    0.255874] DMAR: dmar0: reg_base_addr fed90000 ver 1:0 cap 1c0000c40660462 ecap 7e3ff0505e
> [    0.256083] DMAR: DRHD base: 0x000000fed91000 flags: 0x1
> [    0.256219] DMAR: dmar1: reg_base_addr fed91000 ver 1:0 cap d2008c40660462 ecap f050da
> [    0.256425] DMAR: RMRR base: 0x000000cf51f000 end: 0x000000cf53efff
> [    0.256590] DMAR: RMRR base: 0x000000da000000 end: 0x000000dc7fffff
> [    0.256729] DMAR-IR: IOAPIC id 2 under DRHD base  0xfed91000 IOMMU 1
> [    0.256867] DMAR-IR: HPET id 0 under DRHD base 0xfed91000
> [    0.258623] DMAR-IR: Enabled IRQ remapping in xapic mode
> [    0.262861] ..TIMER: vector=0x30 apic1=0 pin1=2 apic2=-1 pin2=-1
> [    0.267445] clocksource: tsc-early: mask: 0xffffffffffffffff max_cycles: 0x22983777dd9, max_idle_ns: 440795300422 ns
> [    0.267672] Calibrating delay loop (skipped), value calculated using timer frequency.. 4800.00 BogoMIPS (lpj=2400000)
> [    0.267891] pid_max: default: 32768 minimum: 301
> [    0.268040] Security Framework initialized
> [    0.268173] AppArmor: AppArmor disabled by boot time parameter
> [    0.268343] Mount-cache hash table entries: 32768 (order: 6, 262144 bytes)
> [    0.268691] Mountpoint-cache hash table entries: 32768 (order: 6, 262144 bytes)
> [    0.269063] ENERGY_PERF_BIAS: Set to 'normal', was 'performance'
> [    0.269201] ENERGY_PERF_BIAS: View and update with x86_energy_perf_policy(8)
> [    0.269347] mce: CPU supports 8 MCE banks
> [    0.269487] CPU0: Thermal monitoring enabled (TM1)
> [    0.269678] process: using mwait in idle threads
> [    0.269814] Last level iTLB entries: 4KB 64, 2MB 8, 4MB 8
> [    0.269948] Last level dTLB entries: 4KB 64, 2MB 0, 4MB 0, 1GB 4
> [    0.270085] Spectre V2 : Mitigation: Full generic retpoline
> [    0.270221] Spectre V2 : Spectre v2 / SpectreRSB mitigation: Filling RSB on context switch
> [    0.270428] Spectre V2 : Spectre v2 mitigation: Enabling Indirect Branch Prediction Barrier
> [    0.270636] Spectre V2 : Enabling Restricted Speculation for firmware calls
> [    0.270663] Speculative Store Bypass: Mitigation: Speculative Store Bypass disabled via prctl and seccomp
> [    0.277685] Freeing SMP alternatives memory: 40K
> [    0.278725] TSC deadline timer enabled
> [    0.278729] smpboot: CPU0: Intel(R) Core(TM) i5-6200U CPU @ 2.30GHz (family: 0x6, model: 0x4e, stepping: 0x3)
> [    0.279140] Performance Events: PEBS fmt3+, Skylake events, 32-deep LBR, full-width counters, Intel PMU driver.
> [    0.279517] ... version:                4
> [    0.279662] ... bit width:              48
> [    0.279663] ... generic registers:      4
> [    0.279857] ... value mask:             0000ffffffffffff
> [    0.280054] ... max period:             00007fffffffffff
> [    0.280252] ... fixed-purpose events:   3
> [    0.280445] ... event mask:             000000070000000f
> [    0.280681] rcu: Hierarchical SRCU implementation.
> [    0.281384] random: crng done (trusting CPU's manufacturer)
> [    0.281867] NMI watchdog: Enabled. Permanently consumes one hw-PMU counter.
> [    0.282108] smp: Bringing up secondary CPUs ...
> [    0.282358] x86: Booting SMP configuration:
> [    0.282554] .... node  #0, CPUs:      #1 #2 #3
> [    0.285195] smp: Brought up 1 node, 4 CPUs
> [    0.285195] smpboot: Max logical packages: 1
> [    0.285664] smpboot: Total of 4 processors activated (19200.00 BogoMIPS)
> [    0.286893] devtmpfs: initialized
> [    0.286978] PM: Registering ACPI NVS region [mem 0xc3ed6000-0xc3ed6fff] (4096 bytes)
> [    0.287665] PM: Registering ACPI NVS region [mem 0xcff76000-0xcff77fff] (8192 bytes)
> [    0.287999] PM: Registering ACPI NVS region [mem 0xcff79000-0xcffc5fff] (315392 bytes)
> [    0.288375] clocksource: jiffies: mask: 0xffffffff max_cycles: 0xffffffff, max_idle_ns: 1911260446275000 ns
> [    0.288667] futex hash table entries: 1024 (order: 4, 65536 bytes)
> [    0.288961] NET: Registered protocol family 16
> [    0.289238] audit: initializing netlink subsys (disabled)
> [    0.289443] audit: type=2000 audit(1536418320.034:1): state=initialized audit_enabled=0 res=1
> [    0.289666] cpuidle: using governor ladder
> [    0.289871] cpuidle: using governor menu
> [    0.289878] Simple Boot Flag at 0x47 set to 0x1
> [    0.289892] ACPI: bus type PCI registered
> [    0.290664] acpiphp: ACPI Hot Plug PCI Controller Driver version: 0.5
> [    0.291047] PCI: MMCONFIG for domain 0000 [bus 00-3f] at [mem 0xf8000000-0xfbffffff] (base 0xf8000000)
> [    0.291396] PCI: MMCONFIG at [mem 0xf8000000-0xfbffffff] reserved in E820
> [    0.291608] PCI: Using configuration type 1 for base access
> [    0.294865] HugeTLB registered 1.00 GiB page size, pre-allocated 0 pages
> [    0.294880] HugeTLB registered 2.00 MiB page size, pre-allocated 0 pages
> [    0.295100] cryptd: max_cpu_qlen set to 1000
> [    0.295716] ACPI: Added _OSI(Module Device)
> [    0.295913] ACPI: Added _OSI(Processor Device)
> [    0.296109] ACPI: Added _OSI(3.0 _SCP Extensions)
> [    0.296305] ACPI: Added _OSI(Processor Aggregator Device)
> [    0.296305] ACPI: Added _OSI(Linux-Dell-Video)
> [    0.296305] ACPI: Added _OSI(Linux-Lenovo-NV-HDMI-Audio)
> [    0.296305] ACPI: EC: EC started
> [    0.296305] ACPI: EC: interrupt blocked
> [    0.296481] ACPI: \: Used as first EC
> [    0.296664] ACPI: \: GPE=0x16, EC_CMD/EC_SC=0x66, EC_DATA=0x62
> [    0.296865] ACPI: \: Used as boot ECDT EC to handle transactions
> [    0.324758] ACPI: 8 ACPI AML tables successfully acquired and loaded
> [    0.327079] ACPI: [Firmware Bug]: BIOS _OSI(Linux) query ignored
> [    0.335832] ACPI: Dynamic OEM Table Load:
> [    0.336042] ACPI: SSDT 0xFFFF9C2D146B3000 00068B (v02 PmRef  Cpu0Ist  00003000 INTL 20141107)
> [    0.336042] ACPI: \_PR_.CPU0: _OSC native thermal LVT Acked
> [    0.336767] ACPI: Dynamic OEM Table Load:
> [    0.336971] ACPI: SSDT 0xFFFF9C2D145EA800 0003CF (v02 PmRef  Cpu0Cst  00003001 INTL 20141107)
> [    0.337669] ACPI: Dynamic OEM Table Load:
> [    0.337871] ACPI: SSDT 0xFFFF9C2D147A3000 00008E (v02 PmRef  Cpu0Hwp  00003000 INTL 20141107)
> [    0.338460] ACPI: Dynamic OEM Table Load:
> [    0.338660] ACPI: SSDT 0xFFFF9C2D14147A00 000130 (v02 PmRef  HwpLvt   00003000 INTL 20141107)
> [    0.339761] ACPI: Dynamic OEM Table Load:
> [    0.339965] ACPI: SSDT 0xFFFF9C2D146B3800 0005AA (v02 PmRef  ApIst    00003000 INTL 20141107)
> [    0.340876] ACPI: Dynamic OEM Table Load:
> [    0.341077] ACPI: SSDT 0xFFFF9C2D14147C00 000119 (v02 PmRef  ApHwp    00003000 INTL 20141107)
> [    0.341747] ACPI: Dynamic OEM Table Load:
> [    0.341947] ACPI: SSDT 0xFFFF9C2D14147E00 000119 (v02 PmRef  ApCst    00003000 INTL 20141107)
> [    0.343737] ACPI: Interpreter enabled
> [    0.343977] ACPI: (supports S0 S3 S4 S5)
> [    0.344173] ACPI: Using IOAPIC for interrupt routing
> [    0.344399] PCI: Using host bridge windows from ACPI; if necessary, use "pci=nocrs" and report a bug
> [    0.344847] ACPI: Enabled 5 GPEs in block 00 to 7F
> [    0.347906] ACPI: Power Resource [PUBS] (on)
> [    0.348669] ACPI: Power Resource [PG00] (on)
> [    0.348670] ACPI: Power Resource [PG01] (on)
> [    0.349759] ACPI: Power Resource [PG02] (on)
> [    0.351596] ACPI: Power Resource [WRST] (off)
> [    0.351750] ACPI: Power Resource [WRST] (off)
> [    0.366980] ACPI: PCI Interrupt Link [LNKA] (IRQs 3 4 5 6 7 9 10 11) *0, disabled.
> [    0.367398] ACPI: PCI Interrupt Link [LNKB] (IRQs 3 4 5 6 7 9 10 11) *0, disabled.
> [    0.367738] ACPI: PCI Interrupt Link [LNKC] (IRQs 3 4 5 6 7 9 10 11) *0, disabled.
> [    0.368151] ACPI: PCI Interrupt Link [LNKD] (IRQs 3 4 5 6 7 9 10 11) *0, disabled.
> [    0.368566] ACPI: PCI Interrupt Link [LNKE] (IRQs 3 4 5 6 7 9 10 11) *0, disabled.
> [    0.368738] ACPI: PCI Interrupt Link [LNKF] (IRQs 3 4 5 6 7 9 10 11) *0, disabled.
> [    0.369150] ACPI: PCI Interrupt Link [LNKG] (IRQs 3 4 5 6 7 9 10 11) *0, disabled.
> [    0.369563] ACPI: PCI Interrupt Link [LNKH] (IRQs 3 4 5 6 7 9 10 11) *0, disabled.
> [    0.369740] ACPI: PCI Root Bridge [PCI0] (domain 0000 [bus 00-3f])
> [    0.369948] acpi PNP0A08:00: _OSC: OS supports [ExtendedConfig ASPM ClockPM Segments MSI]
> [    0.370366] acpi PNP0A08:00: _OSC: platform does not support [PCIeCapability LTR]
> [    0.370699] acpi PNP0A08:00: _OSC: not requesting control; platform does not support [PCIeCapability]
> [    0.371042] acpi PNP0A08:00: _OSC: OS requested [PCIeHotplug PME AER PCIeCapability LTR]
> [    0.371378] acpi PNP0A08:00: _OSC: platform willing to grant [PCIeHotplug PME AER]
> [    0.371664] acpi PNP0A08:00: _OSC failed (AE_SUPPORT); disabling ASPM
> [    0.372064] PCI host bridge to bus 0000:00
> [    0.372261] pci_bus 0000:00: root bus resource [io  0x0000-0x0cf7 window]
> [    0.372465] pci_bus 0000:00: root bus resource [io  0x0d00-0xffff window]
> [    0.372664] pci_bus 0000:00: root bus resource [mem 0x000a0000-0x000bffff window]
> [    0.372998] pci_bus 0000:00: root bus resource [mem 0xdc800000-0xfebfffff window]
> [    0.373332] pci_bus 0000:00: root bus resource [bus 00-3f]
> [    0.373539] pci 0000:00:00.0: [8086:1904] type 00 class 0x060000
> [    0.373642] pci 0000:00:02.0: [8086:1916] type 00 class 0x030000
> [    0.373655] pci 0000:00:02.0: reg 0x10: [mem 0xf0000000-0xf0ffffff 64bit]
> [    0.373662] pci 0000:00:02.0: reg 0x18: [mem 0xe0000000-0xefffffff 64bit pref]
> [    0.373667] pci 0000:00:02.0: reg 0x20: [io  0xe000-0xe03f]
> [    0.373792] pci 0000:00:08.0: [8086:1911] type 00 class 0x088000
> [    0.373809] pci 0000:00:08.0: reg 0x10: [mem 0xf124a000-0xf124afff 64bit]
> [    0.373944] pci 0000:00:14.0: [8086:9d2f] type 00 class 0x0c0330
> [    0.373969] pci 0000:00:14.0: reg 0x10: [mem 0xf1220000-0xf122ffff 64bit]
> [    0.374040] pci 0000:00:14.0: PME# supported from D3hot D3cold
> [    0.374669] pci 0000:00:14.2: [8086:9d31] type 00 class 0x118000
> [    0.374669] pci 0000:00:14.2: reg 0x10: [mem 0xf124b000-0xf124bfff 64bit]
> [    0.374669] pci 0000:00:16.0: [8086:9d3a] type 00 class 0x078000
> [    0.374669] pci 0000:00:16.0: reg 0x10: [mem 0xf124c000-0xf124cfff 64bit]
> [    0.374669] pci 0000:00:16.0: PME# supported from D3hot
> [    0.374669] pci 0000:00:17.0: [8086:9d03] type 00 class 0x010601
> [    0.374669] pci 0000:00:17.0: reg 0x10: [mem 0xf1248000-0xf1249fff]
> [    0.374669] pci 0000:00:17.0: reg 0x14: [mem 0xf124f000-0xf124f0ff]
> [    0.374669] pci 0000:00:17.0: reg 0x18: [io  0xe080-0xe087]
> [    0.374674] pci 0000:00:17.0: reg 0x1c: [io  0xe088-0xe08b]
> [    0.374682] pci 0000:00:17.0: reg 0x20: [io  0xe060-0xe07f]
> [    0.374690] pci 0000:00:17.0: reg 0x24: [mem 0xf124d000-0xf124d7ff]
> [    0.374736] pci 0000:00:17.0: PME# supported from D3hot
> [    0.374869] pci 0000:00:1c.0: [8086:9d10] type 01 class 0x060400
> [    0.374953] pci 0000:00:1c.0: PME# supported from D0 D3hot D3cold
> [    0.375098] pci 0000:00:1c.2: [8086:9d12] type 01 class 0x060400
> [    0.375179] pci 0000:00:1c.2: PME# supported from D0 D3hot D3cold
> [    0.375669] pci 0000:00:1f.0: [8086:9d48] type 00 class 0x060100
> [    0.375669] pci 0000:00:1f.2: [8086:9d21] type 00 class 0x058000
> [    0.375669] pci 0000:00:1f.2: reg 0x10: [mem 0xf1244000-0xf1247fff]
> [    0.375767] pci 0000:00:1f.3: [8086:9d70] type 00 class 0x040300
> [    0.375799] pci 0000:00:1f.3: reg 0x10: [mem 0xf1240000-0xf1243fff 64bit]
> [    0.375833] pci 0000:00:1f.3: reg 0x20: [mem 0xf1230000-0xf123ffff 64bit]
> [    0.375888] pci 0000:00:1f.3: PME# supported from D3hot D3cold
> [    0.376019] pci 0000:00:1f.4: [8086:9d23] type 00 class 0x0c0500
> [    0.376083] pci 0000:00:1f.4: reg 0x10: [mem 0xf124e000-0xf124e0ff 64bit]
> [    0.376154] pci 0000:00:1f.4: reg 0x20: [io  0xefa0-0xefbf]
> [    0.376669] pci 0000:00:1f.6: [8086:1570] type 00 class 0x020000
> [    0.376669] pci 0000:00:1f.6: reg 0x10: [mem 0xf1200000-0xf121ffff]
> [    0.376669] pci 0000:00:1f.6: PME# supported from D0 D3hot D3cold
> [    0.376681] pci 0000:02:00.0: [10ec:522a] type 00 class 0xff0000
> [    0.376711] pci 0000:02:00.0: reg 0x10: [mem 0xf1100000-0xf1100fff]
> [    0.376847] pci 0000:02:00.0: supports D1 D2
> [    0.376848] pci 0000:02:00.0: PME# supported from D1 D2 D3hot D3cold
> [    0.376896] pci 0000:02:00.0: 2.000 Gb/s available PCIe bandwidth, limited by 2.5 GT/s x1 link at 0000:00:1c.0 (capable of 7.876 Gb/s with 8 GT/s x1 link)
> [    0.377475] pci 0000:00:1c.0: PCI bridge to [bus 02]
> [    0.377670] pci 0000:00:1c.0:   bridge window [mem 0xf1100000-0xf11fffff]
> [    0.378078] pci 0000:04:00.0: [8086:24f3] type 00 class 0x028000
> [    0.378178] pci 0000:04:00.0: reg 0x10: [mem 0xf1000000-0xf1001fff 64bit]
> [    0.378463] pci 0000:04:00.0: PME# supported from D0 D3hot D3cold
> [    0.378626] pci 0000:04:00.0: 2.000 Gb/s available PCIe bandwidth, limited by 2.5 GT/s x1 link at 0000:00:1c.2 (capable of 7.876 Gb/s with 8 GT/s x1 link)
> [    0.379508] pci 0000:00:1c.2: PCI bridge to [bus 04]
> [    0.383670] pci 0000:00:1c.2:   bridge window [mem 0xf1000000-0xf10fffff]
> [    0.383685] pci_bus 0000:00: on NUMA node 0
> [    0.384889] ACPI: EC: interrupt unblocked
> [    0.385127] ACPI: EC: event unblocked
> [    0.385376] ACPI: \_SB_.PCI0.LPC_.EC__: GPE=0x16, EC_CMD/EC_SC=0x66, EC_DATA=0x62
> [    0.385666] ACPI: \_SB_.PCI0.LPC_.EC__: Used as boot DSDT EC to handle transactions and events
> [    0.386063] pci 0000:00:02.0: vgaarb: setting as boot VGA device
> [    0.386063] pci 0000:00:02.0: vgaarb: VGA device added: decodes=io+mem,owns=io+mem,locks=none
> [    0.386214] pci 0000:00:02.0: vgaarb: bridge control possible
> [    0.386664] vgaarb: loaded
> [    0.386894] SCSI subsystem initialized
> [    0.387686] libata version 3.00 loaded.
> [    0.387736] ACPI: bus type USB registered
> [    0.387951] usbcore: registered new interface driver usbfs
> [    0.387951] usbcore: registered new interface driver hub
> [    0.387951] usbcore: registered new device driver usb
> [    0.388710] Advanced Linux Sound Architecture Driver Initialized.
> [    0.388919] PCI: Using ACPI for IRQ routing
> [    0.396114] PCI: pci_cache_line_size set to 64 bytes
> [    0.396226] e820: reserve RAM buffer [mem 0x0009d000-0x0009ffff]
> [    0.396228] e820: reserve RAM buffer [mem 0xb100b000-0xb3ffffff]
> [    0.396229] e820: reserve RAM buffer [mem 0x322800000-0x323ffffff]
> [    0.396332] hpet0: at MMIO 0xfed00000, IRQs 2, 8, 0, 0, 0, 0, 0, 0
> [    0.396332] hpet0: 8 comparators, 64-bit 24.000000 MHz counter
> [    0.398677] clocksource: Switched to clocksource tsc-early
> [    0.406708] pnp: PnP ACPI init
> [    0.407330] system 00:00: [mem 0x00000000-0x0009ffff] could not be reserved
> [    0.407538] system 00:00: [mem 0x000c0000-0x000c3fff] could not be reserved
> [    0.407749] system 00:00: [mem 0x000c4000-0x000c7fff] could not be reserved
> [    0.407955] system 00:00: [mem 0x000c8000-0x000cbfff] could not be reserved
> [    0.408160] system 00:00: [mem 0x000cc000-0x000cffff] could not be reserved
> [    0.408365] system 00:00: [mem 0x000d0000-0x000d3fff] has been reserved
> [    0.408568] system 00:00: [mem 0x000d4000-0x000d7fff] has been reserved
> [    0.408775] system 00:00: [mem 0x000d8000-0x000dbfff] has been reserved
> [    0.408978] system 00:00: [mem 0x000dc000-0x000dffff] has been reserved
> [    0.409182] system 00:00: [mem 0x000e0000-0x000e3fff] could not be reserved
> [    0.409387] system 00:00: [mem 0x000e4000-0x000e7fff] could not be reserved
> [    0.409592] system 00:00: [mem 0x000e8000-0x000ebfff] could not be reserved
> [    0.409798] system 00:00: [mem 0x000ec000-0x000effff] could not be reserved
> [    0.410003] system 00:00: [mem 0x000f0000-0x000fffff] could not be reserved
> [    0.410208] system 00:00: [mem 0x00100000-0xdc7fffff] could not be reserved
> [    0.410413] system 00:00: [mem 0xfec00000-0xfed3ffff] could not be reserved
> [    0.410618] system 00:00: [mem 0xfed4c000-0xffffffff] could not be reserved
> [    0.410830] system 00:00: Plug and Play ACPI device, IDs PNP0c01 (active)
> [    0.410942] system 00:01: [io  0x1800-0x189f] has been reserved
> [    0.411147] system 00:01: [io  0x0800-0x087f] has been reserved
> [    0.411348] system 00:01: [io  0x0880-0x08ff] has been reserved
> [    0.411549] system 00:01: [io  0x0900-0x097f] has been reserved
> [    0.411753] system 00:01: [io  0x0980-0x09ff] has been reserved
> [    0.411954] system 00:01: [io  0x0a00-0x0a7f] has been reserved
> [    0.412155] system 00:01: [io  0x0a80-0x0aff] has been reserved
> [    0.412356] system 00:01: [io  0x0b00-0x0b7f] has been reserved
> [    0.412558] system 00:01: [io  0x0b80-0x0bff] has been reserved
> [    0.412762] system 00:01: [io  0x15e0-0x15ef] has been reserved
> [    0.412964] system 00:01: [io  0x1600-0x167f] has been reserved
> [    0.413165] system 00:01: [io  0x1640-0x165f] has been reserved
> [    0.413367] system 00:01: [mem 0xf8000000-0xfbffffff] has been reserved
> [    0.413571] system 00:01: [mem 0xfed10000-0xfed13fff] has been reserved
> [    0.413777] system 00:01: [mem 0xfed18000-0xfed18fff] has been reserved
> [    0.413981] system 00:01: [mem 0xfed19000-0xfed19fff] has been reserved
> [    0.414186] system 00:01: [mem 0xfeb00000-0xfebfffff] has been reserved
> [    0.414389] system 00:01: [mem 0xfed20000-0xfed3ffff] has been reserved
> [    0.414593] system 00:01: [mem 0xfed90000-0xfed93fff] could not be reserved
> [    0.414800] system 00:01: [mem 0xf7fe0000-0xf7ffffff] has been reserved
> [    0.415007] system 00:01: Plug and Play ACPI device, IDs PNP0c02 (active)
> [    0.415069] pnp 00:02: Plug and Play ACPI device, IDs PNP0b00 (active)
> [    0.415087] pnp 00:03: Plug and Play ACPI device, IDs LEN0071 PNP0303 (active)
> [    0.415102] pnp 00:04: Plug and Play ACPI device, IDs LEN004b PNP0f13 (active)
> [    0.415139] system 00:05: [io  0x1854-0x1857] has been reserved
> [    0.415346] system 00:05: Plug and Play ACPI device, IDs INT3f0d PNP0c02 (active)
> [    0.415958] system 00:06: [mem 0xfd000000-0xfdabffff] has been reserved
> [    0.416164] system 00:06: [mem 0xfdad0000-0xfdadffff] has been reserved
> [    0.416367] system 00:06: [mem 0xfdb00000-0xfdffffff] has been reserved
> [    0.416571] system 00:06: [mem 0xfe000000-0xfe01ffff] has been reserved
> [    0.416778] system 00:06: [mem 0xfe036000-0xfe03bfff] has been reserved
> [    0.416982] system 00:06: [mem 0xfe03d000-0xfe3fffff] has been reserved
> [    0.417185] system 00:06: [mem 0xfe410000-0xfe7fffff] has been reserved
> [    0.417392] system 00:06: Plug and Play ACPI device, IDs PNP0c02 (active)
> [    0.417674] system 00:07: [io  0xff00-0xfffe] has been reserved
> [    0.417880] system 00:07: Plug and Play ACPI device, IDs PNP0c02 (active)
> [    0.417951] pnp: PnP ACPI: found 8 devices
> [    0.423993] clocksource: acpi_pm: mask: 0xffffff max_cycles: 0xffffff, max_idle_ns: 2085701024 ns
> [    0.424356] pci 0000:00:1c.0: PCI bridge to [bus 02]
> [    0.424557] pci 0000:00:1c.0:   bridge window [mem 0xf1100000-0xf11fffff]
> [    0.424769] pci 0000:00:1c.2: PCI bridge to [bus 04]
> [    0.424969] pci 0000:00:1c.2:   bridge window [mem 0xf1000000-0xf10fffff]
> [    0.425179] pci_bus 0000:00: resource 4 [io  0x0000-0x0cf7 window]
> [    0.425181] pci_bus 0000:00: resource 5 [io  0x0d00-0xffff window]
> [    0.425182] pci_bus 0000:00: resource 6 [mem 0x000a0000-0x000bffff window]
> [    0.425184] pci_bus 0000:00: resource 7 [mem 0xdc800000-0xfebfffff window]
> [    0.425186] pci_bus 0000:02: resource 1 [mem 0xf1100000-0xf11fffff]
> [    0.425187] pci_bus 0000:04: resource 1 [mem 0xf1000000-0xf10fffff]
> [    0.425273] NET: Registered protocol family 2
> [    0.425582] tcp_listen_portaddr_hash hash table entries: 8192 (order: 5, 131072 bytes)
> [    0.425942] TCP established hash table entries: 131072 (order: 8, 1048576 bytes)
> [    0.426408] TCP bind hash table entries: 65536 (order: 8, 1048576 bytes)
> [    0.426738] TCP: Hash tables configured (established 131072 bind 65536)
> [    0.426964] UDP hash table entries: 8192 (order: 6, 262144 bytes)
> [    0.427198] UDP-Lite hash table entries: 8192 (order: 6, 262144 bytes)
> [    0.427462] NET: Registered protocol family 1
> [    0.427741] RPC: Registered named UNIX socket transport module.
> [    0.427954] RPC: Registered udp transport module.
> [    0.428151] RPC: Registered tcp transport module.
> [    0.428346] RPC: Registered tcp NFSv4.1 backchannel transport module.
> [    0.428549] NET: Registered protocol family 44
> [    0.428757] pci 0000:00:02.0: Video device with shadowed ROM at [mem 0x000c0000-0x000dffff]
> [    0.429381] PCI: CLS 0 bytes, default 64
> [    0.429407] Unpacking initramfs...
> [    0.595610] Freeing initrd memory: 11132K
> [    0.599827] PCI-DMA: Using software bounce buffering for IO (SWIOTLB)
> [    0.600034] software IO TLB: mapped [mem 0xad00b000-0xb100b000] (64MB)
> [    0.600288] RAPL PMU: API unit is 2^-32 Joules, 5 fixed counters, 655360 ms ovfl timer
> [    0.600624] RAPL PMU: hw unit of domain pp0-core 2^-14 Joules
> [    0.600827] RAPL PMU: hw unit of domain package 2^-14 Joules
> [    0.601027] RAPL PMU: hw unit of domain dram 2^-14 Joules
> [    0.601227] RAPL PMU: hw unit of domain pp1-gpu 2^-14 Joules
> [    0.601426] RAPL PMU: hw unit of domain psys 2^-14 Joules
> [    0.601662] resource sanity check: requesting [mem 0xfed10000-0xfed15fff], which spans more than pnp 00:01 [mem 0xfed10000-0xfed13fff]
> [    0.602027] caller snb_uncore_imc_init_box+0x67/0xa0 mapping multiple BARs
> [    0.602471] clocksource: tsc: mask: 0xffffffffffffffff max_cycles: 0x22983777dd9, max_idle_ns: 440795300422 ns
> [    0.602828] clocksource: Switched to clocksource tsc
> [    0.603314] Scanning for low memory corruption every 60 seconds
> [    0.604560] Initialise system trusted keyrings
> [    0.604785] workingset: timestamp_bits=46 max_order=22 bucket_order=0
> [    0.607233] NFS: Registering the id_resolver key type
> [    0.607438] Key type id_resolver registered
> [    0.607632] Key type id_legacy registered
> [    0.607831] nfs4filelayout_init: NFSv4 File Layout Driver Registering...
> [    0.608715] Key type asymmetric registered
> [    0.608911] Asymmetric key parser 'x509' registered
> [    0.609117] Block layer SCSI generic (bsg) driver version 0.4 loaded (major 251)
> [    0.609472] io scheduler noop registered
> [    0.609670] io scheduler deadline registered
> [    0.609888] io scheduler cfq registered (default)
> [    0.610087] io scheduler mq-deadline registered
> [    0.610723] intel_idle: MWAIT substates: 0x11142120
> [    0.610725] intel_idle: v0.4.1 model 0x4E
> [    0.610907] intel_idle: lapic_timer_reliable_states 0xffffffff
> [    0.611209] ACPI: AC Adapter [AC] (on-line)
> [    0.611469] input: Lid Switch as /devices/LNXSYSTM:00/LNXSYBUS:00/PNP0C0D:00/input/input0
> [    0.611819] ACPI: Lid Switch [LID]
> [    0.612046] input: Sleep Button as /devices/LNXSYSTM:00/LNXSYBUS:00/PNP0C0E:00/input/input1
> [    0.612389] ACPI: Sleep Button [SLPB]
> [    0.612627] input: Power Button as /devices/LNXSYSTM:00/LNXPWRBN:00/input/input2
> [    0.612972] ACPI: Power Button [PWRF]
> [    0.616055] thermal LNXTHERM:00: registered as thermal_zone0
> [    0.616258] ACPI: Thermal Zone [THM0] (47 C)
> [    0.616539] Serial: 8250/16550 driver, 4 ports, IRQ sharing disabled
> [    0.617564] Non-volatile memory driver v1.3
> [    0.618217] Linux agpgart interface v0.103
> [    0.619548] [drm] Replacing VGA console driver
> [    0.627270] Console: switching to colour dummy device 80x25
> [    0.628411] [drm] Supports vblank timestamp caching Rev 2 (21.10.2013).
> [    0.628415] [drm] Driver supports precise vblank timestamp query.
> [    0.628823] i915 0000:00:02.0: vgaarb: changed VGA decodes: olddecodes=io+mem,decodes=io+mem:owns=io+mem
> [    0.630788] [drm] Finished loading DMC firmware i915/skl_dmc_ver1_27.bin (v1.27)
> [    0.637833] battery: ACPI: Battery Slot [BAT0] (battery present)
> [    0.654829] battery: ACPI: Battery Slot [BAT1] (battery present)
> [    1.174054] [drm] Initialized i915 1.6.0 20180719 for 0000:00:02.0 on minor 0
> [    1.175753] ACPI: Video Device [GFX0] (multi-head: yes  rom: no  post: no)
> [    1.175993] input: Video Bus as /devices/LNXSYSTM:00/LNXSYBUS:00/PNP0A08:00/LNXVIDEO:00/input/input3
> [    1.177337] loop: module loaded
> [    1.177418] ahci 0000:00:17.0: version 3.0
> [    1.177629] ahci 0000:00:17.0: AHCI 0001.0301 32 slots 1 ports 6 Gbps 0x2 impl SATA mode
> [    1.177636] ahci 0000:00:17.0: flags: 64bit ncq pm led clo only pio slum part deso sadm sds apst 
> [    1.177880] scsi host0: ahci
> [    1.177988] scsi host1: ahci
> [    1.178051] ata1: DUMMY
> [    1.178060] ata2: SATA max UDMA/133 abar m2048@0xf124d000 port 0xf124d180 irq 123
> [    1.178122] ehci_hcd: USB 2.0 'Enhanced' Host Controller (EHCI) Driver
> [    1.178128] ehci-pci: EHCI PCI platform driver
> [    1.178141] uhci_hcd: USB Universal Host Controller Interface driver
> [    1.178293] xhci_hcd 0000:00:14.0: xHCI Host Controller
> [    1.178301] xhci_hcd 0000:00:14.0: new USB bus registered, assigned bus number 1
> [    1.179382] xhci_hcd 0000:00:14.0: hcc params 0x200077c1 hci version 0x100 quirks 0x0000000000109810
> [    1.179393] xhci_hcd 0000:00:14.0: cache line size of 64 is not supported
> [    1.179556] usb usb1: New USB device found, idVendor=1d6b, idProduct=0002, bcdDevice= 4.19
> [    1.179559] usb usb1: New USB device strings: Mfr=3, Product=2, SerialNumber=1
> [    1.179563] usb usb1: Product: xHCI Host Controller
> [    1.179565] usb usb1: Manufacturer: Linux 4.19.0-rc2-00246-gd7b686ebf704 xhci-hcd
> [    1.179568] usb usb1: SerialNumber: 0000:00:14.0
> [    1.179668] hub 1-0:1.0: USB hub found
> [    1.179690] hub 1-0:1.0: 12 ports detected
> [    1.180992] xhci_hcd 0000:00:14.0: xHCI Host Controller
> [    1.180998] xhci_hcd 0000:00:14.0: new USB bus registered, assigned bus number 2
> [    1.181002] xhci_hcd 0000:00:14.0: Host supports USB 3.0  SuperSpeed
> [    1.181038] usb usb2: New USB device found, idVendor=1d6b, idProduct=0003, bcdDevice= 4.19
> [    1.181042] usb usb2: New USB device strings: Mfr=3, Product=2, SerialNumber=1
> [    1.181045] usb usb2: Product: xHCI Host Controller
> [    1.181048] usb usb2: Manufacturer: Linux 4.19.0-rc2-00246-gd7b686ebf704 xhci-hcd
> [    1.181051] usb usb2: SerialNumber: 0000:00:14.0
> [    1.181124] hub 2-0:1.0: USB hub found
> [    1.181139] hub 2-0:1.0: 6 ports detected
> [    1.181975] usb: port power management may be unreliable
> [    1.182271] usbcore: registered new interface driver usb-storage
> [    1.182311] i8042: PNP: PS/2 Controller [PNP0303:KBD,PNP0f13:MOU] at 0x60,0x64 irq 1,12
> [    1.184417] serio: i8042 KBD port at 0x60,0x64 irq 1
> [    1.184422] serio: i8042 AUX port at 0x60,0x64 irq 12
> [    1.184510] mousedev: PS/2 mouse device common for all mice
> [    1.184674] rtc_cmos 00:02: RTC can wake from S4
> [    1.185140] rtc_cmos 00:02: registered as rtc0
> [    1.185158] rtc_cmos 00:02: alarms up to one month, y3k, 114 bytes nvram, hpet irqs
> [    1.185174] intel_pstate: Intel P-state driver initializing
> [    1.185374] intel_pstate: HWP enabled
> [    1.185388] hidraw: raw HID events driver (C) Jiri Kosina
> [    1.185404] usbcore: registered new interface driver usbhid
> [    1.185407] usbhid: USB HID core driver
> [    1.185579] Initializing XFRM netlink socket
> [    1.185698] NET: Registered protocol family 10
> [    1.186541] input: AT Translated Set 2 keyboard as /devices/platform/i8042/serio0/input/input4
> [    1.188192] Segment Routing with IPv6
> [    1.188213] sit: IPv6, IPv4 and MPLS over IPv4 tunneling driver
> [    1.188407] NET: Registered protocol family 17
> [    1.188437] Key type dns_resolver registered
> [    1.188605] microcode: sig=0x406e3, pf=0x80, revision=0xc6
> [    1.188653] microcode: Microcode Update Driver: v2.2.
> [    1.188660] AVX2 version of gcm_enc/dec engaged.
> [    1.188673] AES CTR mode by8 optimization enabled
> [    1.188911] sched_clock: Marking stable (1162834625, 26073149)->(1196801685, -7893911)
> [    1.189067] registered taskstats version 1
> [    1.189070] Loading compiled-in X.509 certificates
> [    1.189762] console [netcon0] enabled
> [    1.189764] netconsole: network logging started
> [    1.189870] rtc_cmos 00:02: setting system clock to 2018-09-08 14:52:01 UTC (1536418321)
> [    1.189906] ALSA device list:
> [    1.189907]   No soundcards found.
> [    1.331981] fbcon: inteldrmfb (fb0) is primary device
> [    1.488937] ata2: SATA link up 6.0 Gbps (SStatus 133 SControl 300)
> [    1.491370] ata2.00: ACPI cmd ef/02:00:00:00:00:a0 (SET FEATURES) succeeded
> [    1.491377] ata2.00: ACPI cmd f5/00:00:00:00:00:a0 (SECURITY FREEZE LOCK) filtered out
> [    1.491532] ata2.00: ACPI cmd ef/10:09:00:00:00:a0 (SET FEATURES) succeeded
> [    1.491929] ata2.00: supports DRM functions and may not be fully accessible
> [    1.493111] ata2.00: ATA-9: SAMSUNG MZNLN256HCHP-000L7, EMT22L6Q, max UDMA/133
> [    1.493115] ata2.00: 500118192 sectors, multi 1: LBA48 NCQ (depth 32), AA
> [    1.495716] ata2.00: ACPI cmd ef/02:00:00:00:00:a0 (SET FEATURES) succeeded
> [    1.495722] ata2.00: ACPI cmd f5/00:00:00:00:00:a0 (SECURITY FREEZE LOCK) filtered out
> [    1.495872] ata2.00: ACPI cmd ef/10:09:00:00:00:a0 (SET FEATURES) succeeded
> [    1.496281] ata2.00: supports DRM functions and may not be fully accessible
> [    1.498771] ata2.00: configured for UDMA/133
> [    1.505249] usb 1-2: new high-speed USB device number 2 using xhci_hcd
> [    1.641065] usb 1-2: New USB device found, idVendor=1199, idProduct=a001, bcdDevice=17.29
> [    1.641069] usb 1-2: New USB device strings: Mfr=1, Product=2, SerialNumber=3
> [    1.641073] usb 1-2: Product: Sierra Wireless EM7345 4G LTE
> [    1.641076] usb 1-2: Manufacturer: Sierra Wireless Inc.
> [    1.641079] usb 1-2: SerialNumber: 013937008064022
> [    1.770778] usb 1-4: new low-speed USB device number 3 using xhci_hcd
> [    1.901221] usb 1-4: New USB device found, idVendor=046d, idProduct=c077, bcdDevice=72.00
> [    1.901226] usb 1-4: New USB device strings: Mfr=1, Product=2, SerialNumber=0
> [    1.901229] usb 1-4: Product: USB Optical Mouse
> [    1.901232] usb 1-4: Manufacturer: Logitech
> [    2.017715] usb 1-5: new full-speed USB device number 4 using xhci_hcd
> [    2.031536] psmouse serio1: synaptics: queried max coordinates: x [..5676], y [..4762]
> [    2.067482] psmouse serio1: synaptics: queried min coordinates: x [1266..], y [1094..]
> [    2.067494] psmouse serio1: synaptics: Your touchpad (PNP: LEN004b PNP0f13) says it can support a different bus. If i2c-hid and hid-rmi are not used, you might want to try setting psmouse.synaptics_intertouch to 1 and report this to linux-input@vger.kernel.org.
> [    2.137088] psmouse serio1: synaptics: Touchpad model: 1, fw: 8.2, id: 0x1e2b1, caps: 0xf003a3/0x943300/0x12e800/0x10000, board id: 3145, fw id: 2073050
> [    2.137105] psmouse serio1: synaptics: serio: Synaptics pass-through port at isa0060/serio1/input0
> [    2.155209] usb 1-5: New USB device found, idVendor=058f, idProduct=9540, bcdDevice= 1.20
> [    2.155213] usb 1-5: New USB device strings: Mfr=1, Product=2, SerialNumber=0
> [    2.155217] usb 1-5: Product: EMV Smartcard Reader
> [    2.155220] usb 1-5: Manufacturer: Generic
> [    2.177785] input: SynPS/2 Synaptics TouchPad as /devices/platform/i8042/serio1/input/input6
> [    2.270793] usb 1-7: new full-speed USB device number 5 using xhci_hcd
> [    2.398179] usb 1-7: New USB device found, idVendor=8087, idProduct=0a2b, bcdDevice= 0.01
> [    2.398184] usb 1-7: New USB device strings: Mfr=0, Product=0, SerialNumber=0
> [    2.514745] usb 1-8: new high-speed USB device number 6 using xhci_hcd
> [    2.521062] Console: switching to colour frame buffer device 240x67
> [    2.540579] i915 0000:00:02.0: fb0: inteldrmfb frame buffer device
> [    2.541087] scsi 1:0:0:0: Direct-Access     ATA      SAMSUNG MZNLN256 2L6Q PQ: 0 ANSI: 5
> [    2.541515] sd 1:0:0:0: [sda] 500118192 512-byte logical blocks: (256 GB/238 GiB)
> [    2.541593] sd 1:0:0:0: Attached scsi generic sg0 type 0
> [    2.541654] sd 1:0:0:0: [sda] Write Protect is off
> [    2.541782] sd 1:0:0:0: [sda] Mode Sense: 00 3a 00 00
> [    2.541806] sd 1:0:0:0: [sda] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
> [    2.547216]  sda: sda1 sda2 < sda5 >
> [    2.551283] sd 1:0:0:0: [sda] supports TCG Opal
> [    2.554378] sd 1:0:0:0: [sda] Attached SCSI disk
> [    2.693835] usb 1-8: New USB device found, idVendor=04f2, idProduct=b52c, bcdDevice= 0.29
> [    2.695728] usb 1-8: New USB device strings: Mfr=3, Product=1, SerialNumber=2
> [    2.697657] usb 1-8: Product: Integrated Camera
> [    2.699531] usb 1-8: Manufacturer: Chicony Electronics Co.,Ltd.
> [    2.701409] usb 1-8: SerialNumber: 0001
> [    2.729365] Freeing unused kernel image memory: 1140K
> [    2.740999] Write protecting the kernel read-only data: 18432k
> [    2.743128] Freeing unused kernel image memory: 1972K
> [    2.744410] Freeing unused kernel image memory: 996K
> [    2.751037] x86/mm: Checked W+X mappings: passed, no W+X pages found.
> [    2.752136] x86/mm: Checking user space page tables
> [    2.758706] x86/mm: Checked W+X mappings: passed, no W+X pages found.
> [    2.759767] Run /init as init process
> [    2.820718] usb 1-9: new full-speed USB device number 7 using xhci_hcd
> [    2.831121] psmouse serio2: trackpoint: IBM TrackPoint firmware: 0x0e, buttons: 3/3
> [    2.887037] i801_smbus 0000:00:1f.4: SPD Write Disable is set
> [    2.888887] i801_smbus 0000:00:1f.4: SMBus using PCI interrupt
> [    2.891333] e1000e: Intel(R) PRO/1000 Network Driver - 3.2.6-k
> [    2.892991] e1000e: Copyright(c) 1999 - 2015 Intel Corporation.
> [    2.895052] e1000e 0000:00:1f.6: Interrupt Throttling Rate (ints/sec) set to dynamic conservative mode
> [    2.949027] usb 1-9: New USB device found, idVendor=138a, idProduct=0090, bcdDevice= 1.64
> [    2.950110] usb 1-9: New USB device strings: Mfr=0, Product=0, SerialNumber=1
> [    2.951216] usb 1-9: SerialNumber: 948380d9447e
> [    2.956731] input: Logitech USB Optical Mouse as /devices/pci0000:00/0000:00:14.0/usb1/1-4/1-4:1.0/0003:046D:C077.0001/input/input8
> [    2.958017] hid-generic 0003:046D:C077.0001: input,hidraw0: USB HID v1.11 Mouse [Logitech USB Optical Mouse] on usb-0000:00:14.0-4/input0
> [    3.044346] input: TPPS/2 IBM TrackPoint as /devices/platform/i8042/serio1/serio2/input/input7
> [    3.241547] e1000e 0000:00:1f.6 eth0: (PCI Express:2.5GT/s:Width x1) 50:7b:9d:a5:9f:71
> [    3.245265] e1000e 0000:00:1f.6 eth0: Intel(R) PRO/1000 Network Connection
> [    3.249002] e1000e 0000:00:1f.6 eth0: MAC: 12, PHY: 12, PBA No: 1000FF-0FF
> [    3.254307] e1000e 0000:00:1f.6 enp0s31f6: renamed from eth0
> [    3.343466] device-mapper: uevent: version 1.0.3
> [    3.344949] device-mapper: ioctl: 4.39.0-ioctl (2018-04-03) initialised: dm-devel@redhat.com
> [   10.383342] EXT4-fs (dm-2): mounted filesystem with ordered data mode. Opts: (null)
> [   10.570568] systemd[1]: systemd 239 running in system mode. (+PAM +AUDIT +SELINUX +IMA +APPARMOR +SMACK +SYSVINIT +UTMP +LIBCRYPTSETUP +GCRYPT +GNUTLS +ACL +XZ +LZ4 +SECCOMP +BLKID +ELFUTILS +KMOD -IDN2 +IDN -PCRE2 default-hierarchy=hybrid)
> [   10.589145] systemd[1]: Detected architecture x86-64.
> [   10.608456] systemd[1]: Set hostname to <t460s>.
> [   10.727198] systemd[1]: Reached target Remote File Systems.
> [   10.730292] systemd[1]: Listening on LVM2 poll daemon socket.
> [   10.733246] systemd[1]: Listening on LVM2 metadata daemon socket.
> [   10.736861] systemd[1]: Created slice User and Session Slice.
> [   10.739808] systemd[1]: Reached target User and Group Name Lookups.
> [   10.742843] systemd[1]: Listening on Journal Socket (/dev/log).
> [   10.745916] systemd[1]: Listening on initctl Compatibility Named Pipe.
> [   10.796327] EXT4-fs (dm-2): re-mounted. Opts: errors=remount-ro
> [   10.890947] systemd-journald[1405]: Received request to flush runtime journal from PID 1
> [   10.987722] thinkpad_acpi: ThinkPad ACPI Extras v0.26
> [   10.989080] thinkpad_acpi: http://ibm-acpi.sf.net/
> [   10.990294] thinkpad_acpi: ThinkPad BIOS N1CET65W (1.33 ), EC unknown
> [   10.991468] thinkpad_acpi: Lenovo ThinkPad T460s, model 20F9003SMS
> [   10.995952] thinkpad_acpi: radio switch found; radios are enabled
> [   10.997678] thinkpad_acpi: This ThinkPad has standard ACPI backlight brightness control, supported by the ACPI video driver
> [   10.999008] thinkpad_acpi: Disabling thinkpad-acpi brightness events by default...
> [   11.003326] thinkpad_acpi: rfkill switch tpacpi_bluetooth_sw: radio is unblocked
> [   11.005849] mei_me 0000:00:16.0: enabling device (0000 -> 0002)
> [   11.008148] thinkpad_acpi: rfkill switch tpacpi_wwan_sw: radio is unblocked
> [   11.018971] thinkpad_acpi: Standard ACPI backlight interface available, not loading native one
> [   11.034566] thinkpad_acpi: battery 2 registered (start 0, stop 100)
> [   11.037330] thinkpad_acpi: battery 1 registered (start 0, stop 100)
> [   11.038869] battery: new extension: ThinkPad Battery Extension
> [   11.041623] input: ThinkPad Extra Buttons as /devices/platform/thinkpad_acpi/input/input9
> [   11.049119] Bluetooth: Core ver 2.22
> [   11.050356] NET: Registered protocol family 31
> [   11.051485] Bluetooth: HCI device and connection manager initialized
> [   11.052612] Bluetooth: HCI socket layer initialized
> [   11.053587] Bluetooth: L2CAP socket layer initialized
> [   11.053696] cdc_acm 1-2:1.2: ttyACM0: USB ACM device
> [   11.054716] Bluetooth: SCO socket layer initialized
> [   11.057199] usbcore: registered new interface driver cdc_acm
> [   11.058779] cdc_acm: USB Abstract Control Model driver for USB modems and ISDN adapters
> [   11.062692] media: Linux media interface: v0.10
> [   11.068402] iTCO_vendor_support: vendor-support=0
> [   11.070321] cfg80211: Loading compiled-in X.509 certificates for regulatory database
> [   11.071858] videodev: Linux video capture interface: v2.00
> [   11.073547] iTCO_wdt: Intel TCO WatchDog Timer Driver v1.11
> [   11.075225] snd_hda_intel 0000:00:1f.3: bound 0000:00:02.0 (ops 0xffffffffa46a9d00)
> [   11.076795] iTCO_wdt: Found a Intel PCH TCO device (Version=4, TCOBASE=0x0400)
> [   11.078156] input: PC Speaker as /devices/platform/pcspkr/input/input10
> [   11.078193] iTCO_wdt: initialized. heartbeat=30 sec (nowayout=0)
> [   11.079794] usbcore: registered new interface driver btusb
> [   11.082258] Bluetooth: hci0: Bootloader revision 0.0 build 2 week 52 2014
> [   11.086130] cfg80211: Loaded X.509 cert 'sforshee: 00b28ddf47aef9cea7'
> [   11.086800] usbcore: registered new interface driver cdc_ncm
> [   11.088431] platform regulatory.0: Direct firmware load for regulatory.db.p7s failed with error -2
> [   11.088985] Bluetooth: hci0: Device revision is 5
> [   11.090525] cfg80211: loaded regulatory.db is malformed or signature is missing/invalid
> [   11.093028] Bluetooth: hci0: Secure boot is enabled
> [   11.094191] Bluetooth: hci0: OTP lock is enabled
> [   11.095357] Bluetooth: hci0: API lock is enabled
> [   11.096543] Bluetooth: hci0: Debug lock is disabled
> [   11.097721] Bluetooth: hci0: Minimum firmware build 1 week 10 2014
> [   11.100457] usbcore: registered new interface driver cdc_wdm
> [   11.104003] Bluetooth: hci0: Found device firmware: intel/ibt-11-5.sfi
> [   11.109772] Intel(R) Wireless WiFi driver for Linux
> [   11.111153] Copyright(c) 2003- 2015 Intel Corporation
> [   11.113007] snd_hda_codec_realtek hdaudioC0D0: autoconfig for ALC293: line_outs=1 (0x14/0x0/0x0/0x0/0x0) type:speaker
> [   11.114498] snd_hda_codec_realtek hdaudioC0D0:    speaker_outs=0 (0x0/0x0/0x0/0x0/0x0)
> [   11.115959] snd_hda_codec_realtek hdaudioC0D0:    hp_outs=2 (0x16/0x15/0x0/0x0/0x0)
> [   11.117311] snd_hda_codec_realtek hdaudioC0D0:    mono: mono_out=0x0
> [   11.118905] snd_hda_codec_realtek hdaudioC0D0:    inputs:
> [   11.120463] snd_hda_codec_realtek hdaudioC0D0:      Dock Mic=0x19
> [   11.121793] snd_hda_codec_realtek hdaudioC0D0:      Mic=0x1a
> [   11.122306] iwlwifi 0000:04:00.0: loaded firmware version 36.e91976c0.0 op_mode iwlmvm
> [   11.123426] snd_hda_codec_realtek hdaudioC0D0:      Internal Mic=0x12
> [   11.133367] uvcvideo: Found UVC 1.00 device Integrated Camera (04f2:b52c)
> [   11.148144] uvcvideo: Failed to initialize entity for entity 6
> [   11.148145] uvcvideo: Failed to register entites (-22).
> [   11.148351] input: Integrated Camera: Integrated C as /devices/pci0000:00/0000:00:14.0/usb1/1-8/1-8:1.0/input/input12
> [   11.148422] usbcore: registered new interface driver uvcvideo
> [   11.148423] USB Video Class driver (1.1.1)
> [   11.156604] iwlwifi 0000:04:00.0: Detected Intel(R) Dual Band Wireless AC 8260, REV=0x208
> [   11.170889] Bluetooth: hci0: Failed to send firmware data (-38)
> [   11.176545] input: HDA Digital PCBeep as /devices/pci0000:00/0000:00:1f.3/sound/card0/input11
> [   11.178645] input: HDA Intel PCH Dock Mic as /devices/pci0000:00/0000:00:1f.3/sound/card0/input13
> [   11.180200] input: HDA Intel PCH Mic as /devices/pci0000:00/0000:00:1f.3/sound/card0/input14
> [   11.181718] input: HDA Intel PCH Dock Headphone as /devices/pci0000:00/0000:00:1f.3/sound/card0/input15
> [   11.185734] cdc_mbim 1-2:1.0: setting rx_max = 16384
> [   11.187812] input: HDA Intel PCH Headphone as /devices/pci0000:00/0000:00:1f.3/sound/card0/input16
> [   11.188378] cdc_mbim 1-2:1.0: cdc-wdm0: USB WDM device
> [   11.190711] input: HDA Intel PCH HDMI/DP,pcm=3 as /devices/pci0000:00/0000:00:1f.3/sound/card0/input17
> [   11.191648] cdc_mbim 1-2:1.0 wwan0: register 'cdc_mbim' at usb-0000:00:14.0-2, CDC MBIM, 7e:16:17:c1:40:20
> [   11.193678] input: HDA Intel PCH HDMI/DP,pcm=7 as /devices/pci0000:00/0000:00:1f.3/sound/card0/input18
> [   11.193973] usbcore: registered new interface driver cdc_mbim
> [   11.197070] input: HDA Intel PCH HDMI/DP,pcm=8 as /devices/pci0000:00/0000:00:1f.3/sound/card0/input19
> [   11.198751] input: HDA Intel PCH HDMI/DP,pcm=9 as /devices/pci0000:00/0000:00:1f.3/sound/card0/input20
> [   11.200476] input: HDA Intel PCH HDMI/DP,pcm=10 as /devices/pci0000:00/0000:00:1f.3/sound/card0/input21
> [   11.218071] cdc_mbim 1-2:1.0 wwp0s20f0u2: renamed from wwan0
> [   11.239301] iwlwifi 0000:04:00.0: base HW address: a4:34:d9:a2:84:e7
> [   11.267073] Adding 11718652k swap on /dev/mapper/TP-SWAP.  Priority:-2 extents:1 across:11718652k SS
> [   11.312842] ieee80211 phy0: Selected rate control algorithm 'iwl-mvm-rs'
> [   11.313060] thermal thermal_zone3: failed to read out thermal zone (-61)
> [   11.315772] iwlwifi 0000:04:00.0 wlp4s0: renamed from wlan0
> [   11.333144] usb 1-7: USB disconnect, device number 5
> [   11.349841] EXT4-fs (sda1): mounted filesystem with ordered data mode. Opts: (null)
> [   11.643346] Bluetooth: BNEP (Ethernet Emulation) ver 1.3
> [   11.644979] Bluetooth: BNEP filters: protocol multicast
> [   11.646585] Bluetooth: BNEP socket layer initialized
> [   11.890396] IPv6: ADDRCONF(NETDEV_UP): enp0s31f6: link is not ready
> [   12.104191] IPv6: ADDRCONF(NETDEV_UP): enp0s31f6: link is not ready
> [   12.112401] IPv6: ADDRCONF(NETDEV_UP): wlp4s0: link is not ready
> [   12.382254] IPv6: ADDRCONF(NETDEV_UP): wlp4s0: link is not ready
> [   12.658949] IPv6: ADDRCONF(NETDEV_UP): wlp4s0: link is not ready
> [   12.738862] IPv6: ADDRCONF(NETDEV_UP): wlp4s0: link is not ready
> [   17.211872] IPv6: ADDRCONF(NETDEV_UP): wlp4s0: link is not ready
> [   22.949764] fuse init (API version 7.27)
> [   42.481782] bridge: filtering via arp/ip/ip6tables is no longer available by default. Update your scripts to load br_netfilter if you need this.
> [   42.484790] Bridge firewalling registered
> [   42.536331] bpfilter: Loaded bpfilter_umh pid 2711
> [   42.840326] IPv6: ADDRCONF(NETDEV_UP): docker0: link is not ready
> [   47.042857] IPv6: ADDRCONF(NETDEV_UP): wlp4s0: link is not ready
> [   47.063195] IPv6: ADDRCONF(NETDEV_UP): wlp4s0: link is not ready
> [   47.204294] IPv6: ADDRCONF(NETDEV_UP): wlp4s0: link is not ready
> [   49.528826] wlp4s0: authenticate with e8:de:27:6d:c0:0d
> [   49.539997] wlp4s0: send auth to e8:de:27:6d:c0:0d (try 1/3)
> [   49.545622] wlp4s0: authenticated
> [   49.546754] wlp4s0: associate with e8:de:27:6d:c0:0d (try 1/3)
> [   49.548212] wlp4s0: RX AssocResp from e8:de:27:6d:c0:0d (capab=0x411 status=0 aid=1)
> [   49.550401] wlp4s0: associated
> [   49.569164] wlp4s0: Limiting TX power to 23 (23 - 0) dBm as advertised by e8:de:27:6d:c0:0d
> [   49.569615] IPv6: ADDRCONF(NETDEV_CHANGE): wlp4s0: link becomes ready
> [   62.271049] tun: Universal TUN/TAP device driver, 1.6
> [16586.594898] usb 1-3: new high-speed USB device number 8 using xhci_hcd
> [16586.722493] usb 1-3: New USB device found, idVendor=05ac, idProduct=12a8, bcdDevice= 8.04
> [16586.722510] usb 1-3: New USB device strings: Mfr=1, Product=2, SerialNumber=3
> [16586.722520] usb 1-3: Product: iPhone
> [16586.722529] usb 1-3: Manufacturer: Apple Inc.
> [16586.722537] usb 1-3: SerialNumber: aefd92ebe590be7607104ad23646b1ab81cfed37
> [16586.771914] ipheth 1-3:4.2: Apple iPhone USB Ethernet device attached
> [16586.773240] usbcore: registered new interface driver ipheth
> [16586.776705] ipheth 1-3:4.2 enp0s20f0u3c4i2: renamed from eth0
> [16586.792319] IPv6: ADDRCONF(NETDEV_UP): enp0s20f0u3c4i2: link is not ready
> [16586.793443] IPv6: ADDRCONF(NETDEV_UP): enp0s20f0u3c4i2: link is not ready
> [17652.479099] ipheth 1-3:4.2: ipheth_rcvbulk_callback: urb status: -71
> [17652.479480] usb 1-3: USB disconnect, device number 8
> [17652.494749] ipheth 1-3:4.2: Apple iPhone USB Ethernet now disconnected
> [58573.052160] perf: interrupt took too long (2579 > 2500), lowering kernel.perf_event_max_sample_rate to 77000
> [61077.066240] perf: interrupt took too long (3269 > 3223), lowering kernel.perf_event_max_sample_rate to 61000
> [74109.459225] perf: interrupt took too long (4089 > 4086), lowering kernel.perf_event_max_sample_rate to 48000
> [85278.120326] perf: interrupt took too long (5246 > 5111), lowering kernel.perf_event_max_sample_rate to 38000
> [146058.115816] perf: interrupt took too long (6560 > 6557), lowering kernel.perf_event_max_sample_rate to 30000
> [146535.257274] tpm tpm0: A TPM error (379) occurred attempting get random
> [146535.257304] usercopy: Kernel memory exposure attempt detected from SLUB object 'kmalloc-64' (offset 0, size 379)!
> [146535.257331] ------------[ cut here ]------------
> [146535.257338] kernel BUG at mm/usercopy.c:102!
> [146535.257361] invalid opcode: 0000 [#1] SMP PTI
> [146535.257375] CPU: 0 PID: 1729 Comm: rngd Not tainted 4.19.0-rc2-00246-gd7b686ebf704 #36
> [146535.257382] Hardware name: LENOVO 20F9003SMS/20F9003SMS, BIOS N1CET65W (1.33 ) 02/16/2018
> [146535.257402] RIP: 0010:usercopy_abort+0x6f/0x71
> [146535.257412] Code: 0f 45 c6 48 c7 c2 b4 26 80 a4 48 c7 c6 b5 53 7f a4 51 48 0f 45 f2 48 89 f9 41 52 48 89 c2 48 c7 c7 80 27 80 a4 e8 7e 3a ed ff <0f> 0b 49 89 e8 31 c9 44 89 e2 31 f6 48 c7 c7 e8 26 80 a4 e8 79 ff
> [146535.257421] RSP: 0018:ffffbc4ec076bdb0 EFLAGS: 00010246
> [146535.257433] RAX: 0000000000000065 RBX: ffff9c2d1464ad80 RCX: 0000000000000006
> [146535.257441] RDX: 0000000000000000 RSI: 0000000000000086 RDI: ffff9c2d16a15500
> [146535.257449] RBP: 000000000000017b R08: ffffffffa3f11900 R09: 0000000000000065
> [146535.257457] R10: ffffffffa50908d8 R11: ffffffffa507efae R12: 0000000000000001
> [146535.257463] R13: ffff9c2d1464aefb R14: 000000000000017b R15: 000000000000017b
> [146535.257474] FS:  00007f023c524700(0000) GS:ffff9c2d16a00000(0000) knlGS:0000000000000000
> [146535.257484] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> [146535.257492] CR2: 00001834aa0fc000 CR3: 0000000309104005 CR4: 00000000003606f0
> [146535.257499] Call Trace:
> [146535.257524]  __check_heap_object+0xd5/0x100
> [146535.257539]  __check_object_size+0xf5/0x17c
> [146535.257554]  rng_dev_read+0x6e/0x270
> [146535.257576]  __vfs_read+0x31/0x170
> [146535.257604]  vfs_read+0x85/0x130
> [146535.257631]  ksys_read+0x4a/0xb0
> [146535.257658]  do_syscall_64+0x4a/0xf0
> [146535.257695]  entry_SYSCALL_64_after_hwframe+0x44/0xa9
> [146535.257716] RIP: 0033:0x7f023c6f6394
> [146535.257735] Code: 84 00 00 00 00 00 41 54 55 49 89 d4 53 48 89 f5 89 fb 48 83 ec 10 e8 8b fc ff ff 4c 89 e2 41 89 c0 48 89 ee 89 df 31 c0 0f 05 <48> 3d 00 f0 ff ff 77 38 44 89 c7 48 89 44 24 08 e8 c7 fc ff ff 48
> [146535.257748] RSP: 002b:00007f023c523e10 EFLAGS: 00000246 ORIG_RAX: 0000000000000000
> [146535.257767] RAX: ffffffffffffffda RBX: 0000000000000003 RCX: 00007f023c6f6394
> [146535.257776] RDX: 00000000000009c4 RSI: 0000563938a24f00 RDI: 0000000000000003
> [146535.257790] RBP: 0000563938a24f00 R08: 0000000000000000 R09: 00007fff1df64080
> [146535.257803] R10: 0000000000000001 R11: 0000000000000246 R12: 00000000000009c4
> [146535.257816] R13: 00007fff1dedba3f R14: 00007fff1dedba40 R15: 0000000000000000
> [146535.257836] Modules linked in: ipheth tun ipt_MASQUERADE nf_conntrack_netlink iptable_nat nf_nat_ipv4 xt_addrtype iptable_filter bpfilter xt_conntrack nf_nat nf_conntrack nf_defrag_ipv6 nf_defrag_ipv4 libcrc32c br_netfilter bridge stp llc overlay fuse bnep cpufreq_userspace snd_hda_codec_hdmi iwlmvm mac80211 uvcvideo snd_hda_codec_realtek videobuf2_vmalloc cdc_mbim iwlwifi x86_pkg_temp_thermal videobuf2_memops snd_hda_codec_generic intel_powerclamp cdc_wdm videobuf2_v4l2 coretemp videobuf2_common joydev pcspkr cdc_ncm btusb snd_hda_intel iTCO_wdt btrtl iTCO_vendor_support btbcm snd_hda_codec videodev snd_hwdep media usbnet btintel snd_hda_core mii cdc_acm cfg80211 bluetooth ecdh_generic mei_me mei intel_pch_thermal tpm_crb tpm_tis tpm_tis_core thinkpad_acpi tpm pcc_cpufreq ip_tables 
 dm_crypt dm_mod
> [146535.258082]  dax hid_generic rtsx_pci_sdmmc mmc_core crct10dif_pclmul e1000e i2c_i801 rtsx_pci mfd_core
> [146535.258139] ---[ end trace 40fa61fde8e22944 ]---
> [146535.258260] RIP: 0010:usercopy_abort+0x6f/0x71
> [146535.258290] Code: 0f 45 c6 48 c7 c2 b4 26 80 a4 48 c7 c6 b5 53 7f a4 51 48 0f 45 f2 48 89 f9 41 52 48 89 c2 48 c7 c7 80 27 80 a4 e8 7e 3a ed ff <0f> 0b 49 89 e8 31 c9 44 89 e2 31 f6 48 c7 c7 e8 26 80 a4 e8 79 ff
> [146535.258315] RSP: 0018:ffffbc4ec076bdb0 EFLAGS: 00010246
> [146535.258367] RAX: 0000000000000065 RBX: ffff9c2d1464ad80 RCX: 0000000000000006
> [146535.258391] RDX: 0000000000000000 RSI: 0000000000000086 RDI: ffff9c2d16a15500
> [146535.258421] RBP: 000000000000017b R08: ffffffffa3f11900 R09: 0000000000000065
> [146535.258450] R10: ffffffffa50908d8 R11: ffffffffa507efae R12: 0000000000000001
> [146535.258485] R13: ffff9c2d1464aefb R14: 000000000000017b R15: 000000000000017b
> [146535.258520] FS:  00007f023c524700(0000) GS:ffff9c2d16a00000(0000) knlGS:0000000000000000
> [146535.258555] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> [146535.258593] CR2: 00001834aa0fc000 CR3: 0000000309104005 CR4: 00000000003606f0
> 
> -- 
> Meelis Roos (mroos@linux.ee)
