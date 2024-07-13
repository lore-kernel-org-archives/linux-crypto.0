Received: from mail-il1-f199.google.com (mail-il1-f199.google.com [209.85.166.199])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DC8E16EB55
	for <linux-crypto@vger.kernel.org>; Sat, 13 Jul 2024 14:46:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.199
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720881984; cv=none; b=QRmCPEwUUsHy8CNiZ5wgihYV9R7EqgdJQ52s7asffLPFRkFlNBP/rMkztDwjrrWNAgnof5Cg4i+QT/N4QrZ29PKoWKzTTGVDzkJG2CcBXCY0SewoTLsKkk34qRfoCAGJqh7H5d80NX+BYQNUNfCEcoyKkTUrW3oXFdgCX1eTtg4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720881984; c=relaxed/simple;
	bh=1mdsiKV32nf9uFWaNnsrMQ608EmMiItAKLWyBv5YcVw=;
	h=MIME-Version:Date:Message-ID:Subject:From:To:Content-Type; b=OEjsJrFxlvsxCZjqsANjU/JcrgQdi56E+Il4/uBYCh9f8TjxLUIHbmCu0BGR+54iHt2DoqhTOU+LYSh5D+aKGR8LLWLlpqPYaI3Wm+LzPBYTee9NudjILPI+0VyGt78HDEQFMmSJpoGt+2nb7rdVhPm/Ke9LrOYXFqrCLI2ii04=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com; arc=none smtp.client-ip=209.85.166.199
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
Received: by mail-il1-f199.google.com with SMTP id e9e14a558f8ab-38b6062903fso36939265ab.2
        for <linux-crypto@vger.kernel.org>; Sat, 13 Jul 2024 07:46:20 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1720881980; x=1721486780;
        h=content-transfer-encoding:to:from:subject:message-id:date
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=WXWhQuYgvYDYcnFRJlwSDEYtqRuqGRlH1qsAB4d8pAM=;
        b=jLurmGAkRHSKiN3wBLUO1uQsff1Lzk60Ocqq+izNqISKnZlIe8m1+JWaR0NahkpUpa
         ciHTq6vRXppy+nd4xjazQfITrclfeMSk9fr/NjS1P+AfWNW4tFBO/iA4DcwkNGZJcUVM
         kSpgZY6AlGX0yhiJyFCWxpWf8lECky6PcTX9KurDKjNzn2xYWFGicfT/fX/M8C5Gt3mP
         ooD1mzcL+tuza2LziMlW0hhsaW5qM5oo2Wu2GUtbYsCsKPvsYekzForAM9T9UO4Gx7BG
         osB8u+U06p65EhFlmAC4EYjf+bRRGOqBIXTdxbO0xuex+bb1y3lPvYUp9cqqQr3mzF3I
         lqSA==
X-Forwarded-Encrypted: i=1; AJvYcCXOJ+MK4R9ZBdY19B73MMNHu2uXPU7SrGeisrpYj5VXCpgNd+jKyWSk8K0AVv3xk0M11vcb1OpRNpqW1pYCFkApBq623oeUVlt1+2Wv
X-Gm-Message-State: AOJu0YwIrtSCPap0EEAaaMU0yIiOEAf7B/0Z7O7TY0jTPKsZGs8abAgI
	33SeKQzxBqa06lh0KLcidUqfONp7AOF9nEUSRssyO5lJKyxLSxWi75ajZWmpswrFK3Fj4GFN1nW
	MyFUqz6904ezfda96eiHvz535hRC/YFpZ39dYerT+tI5X4SQyFfU5zMc=
X-Google-Smtp-Source: AGHT+IEW1myKSnM3c95gstH/Baxkq37fM7jihIvstSsFrGPnwb8q+XtoJbFr9ENVY3Df9EIxsQU3I33QXppw0jqrYHF8ggbzdcuD
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Received: by 2002:a05:6e02:4a4:b0:374:9a34:a16 with SMTP id
 e9e14a558f8ab-38a5a45d9a9mr2788405ab.5.1720881980019; Sat, 13 Jul 2024
 07:46:20 -0700 (PDT)
Date: Sat, 13 Jul 2024 07:46:20 -0700
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <0000000000001ea4c3061d220fae@google.com>
Subject: [syzbot] [crypto?] possible deadlock in alloc_workqueue
From: syzbot <syzbot+2009b142f47c1e8fe762@syzkaller.appspotmail.com>
To: daniel.m.jordan@oracle.com, davem@davemloft.net, 
	herbert@gondor.apana.org.au, linux-crypto@vger.kernel.org, 
	linux-kernel@vger.kernel.org, steffen.klassert@secunet.com, 
	syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Hello,

syzbot found the following issue on:

HEAD commit:    82d01fe6ee52 Add linux-next specific files for 20240709
git tree:       linux-next
console output: https://syzkaller.appspot.com/x/log.txt?x=3D15ecf3b9980000
kernel config:  https://syzkaller.appspot.com/x/.config?x=3D95a20e7acf35799=
8
dashboard link: https://syzkaller.appspot.com/bug?extid=3D2009b142f47c1e8fe=
762
compiler:       Debian clang version 15.0.6, GNU ld (GNU Binutils for Debia=
n) 2.40

Unfortunately, I don't have any reproducer for this issue yet.

Downloadable assets:
disk image: https://storage.googleapis.com/syzbot-assets/12dcacb06142/disk-=
82d01fe6.raw.xz
vmlinux: https://storage.googleapis.com/syzbot-assets/6ef954821378/vmlinux-=
82d01fe6.xz
kernel image: https://storage.googleapis.com/syzbot-assets/9ebf01d42887/bzI=
mage-82d01fe6.xz

IMPORTANT: if you fix the issue, please add the following tag to the commit=
:
Reported-by: syzbot+2009b142f47c1e8fe762@syzkaller.appspotmail.com

smpboot: CPU0: Intel(R) Xeon(R) CPU @ 2.20GHz (family: 0x6, model: 0x4f, st=
epping: 0x0)
Running RCU Tasks wait API self tests
Running RCU Tasks Trace wait API self tests
Performance Events: unsupported p6 CPU model 79 no PMU driver, software eve=
nts only.
signal: max sigframe size: 1776
rcu: Hierarchical SRCU implementation.
rcu: 	Max phase no-delay instances is 1000.
NMI watchdog: Perf NMI watchdog permanently disabled
smp: Bringing up secondary CPUs ...
smpboot: x86: Booting SMP configuration:
.... node  #0, CPUs:      #1
MDS CPU bug present and SMT on, data leak possible. See https://www.kernel.=
org/doc/html/latest/admin-guide/hw-vuln/mds.html for more details.
TAA CPU bug present and SMT on, data leak possible. See https://www.kernel.=
org/doc/html/latest/admin-guide/hw-vuln/tsx_async_abort.html for more detai=
ls.
MMIO Stale Data CPU bug present and SMT on, data leak possible. See https:/=
/www.kernel.org/doc/html/latest/admin-guide/hw-vuln/processor_mmio_stale_da=
ta.html for more details.
smp: Brought up 2 nodes, 2 CPUs
smpboot: Total of 2 processors activated (8800.88 BogoMIPS)
Memory: 6566488K/8388204K available (176128K kernel code, 27765K rwdata, 36=
408K rodata, 26132K init, 37024K bss, 1632444K reserved, 0K cma-reserved)
devtmpfs: initialized
x86/mm: Memory block size: 128MB
Running RCU synchronous self tests
Running RCU synchronous self tests
clocksource: jiffies: mask: 0xffffffff max_cycles: 0xffffffff, max_idle_ns:=
 19112604462750000 ns
futex hash table entries: 512 (order: 4, 65536 bytes, vmalloc)
PM: RTC time: 14:38:46, date: 2024-07-09
NET: Registered PF_NETLINK/PF_ROUTE protocol family
audit: initializing netlink subsys (disabled)
thermal_sys: Registered thermal governor 'step_wise'
thermal_sys: Registered thermal governor 'user_space'
cpuidle: using governor menu
NET: Registered PF_QIPCRTR protocol family
dca service started, version 1.12.1
PCI: Using configuration type 1 for base access
HugeTLB: registered 1.00 GiB page size, pre-allocated 0 pages
HugeTLB: 16380 KiB vmemmap can be freed for a 1.00 GiB page
HugeTLB: registered 2.00 MiB page size, pre-allocated 0 pages
HugeTLB: 28 KiB vmemmap can be freed for a 2.00 MiB page

=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
WARNING: possible recursive locking detected
6.10.0-rc7-next-20240709-syzkaller #0 Not tainted
--------------------------------------------
swapper/0/1 is trying to acquire lock:
ffffffff8e1d19f0 (cpu_hotplug_lock){++++}-{0:0}, at: apply_wqattrs_lock ker=
nel/workqueue.c:5134 [inline]
ffffffff8e1d19f0 (cpu_hotplug_lock){++++}-{0:0}, at: alloc_workqueue+0xb99/=
0x1ff0 kernel/workqueue.c:5719

but task is already holding lock:
ffffffff8e1d19f0 (cpu_hotplug_lock){++++}-{0:0}, at: padata_alloc+0xaa/0x37=
0 kernel/padata.c:1005

other info that might help us debug this:
 Possible unsafe locking scenario:

       CPU0
       ----
  lock(cpu_hotplug_lock);
  lock(cpu_hotplug_lock);

 *** DEADLOCK ***

 May be due to missing lock nesting notation

1 lock held by swapper/0/1:
 #0: ffffffff8e1d19f0 (cpu_hotplug_lock){++++}-{0:0}, at: padata_alloc+0xaa=
/0x370 kernel/padata.c:1005

stack backtrace:
CPU: 1 UID: 0 PID: 1 Comm: swapper/0 Not tainted 6.10.0-rc7-next-20240709-s=
yzkaller #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Goo=
gle 06/07/2024
Call Trace:
 <TASK>
 __dump_stack lib/dump_stack.c:94 [inline]
 dump_stack_lvl+0x241/0x360 lib/dump_stack.c:120
 print_deadlock_bug+0x483/0x620 kernel/locking/lockdep.c:3034
 check_deadlock kernel/locking/lockdep.c:3086 [inline]
 validate_chain+0x15e2/0x5920 kernel/locking/lockdep.c:3888
 __lock_acquire+0x1359/0x2000 kernel/locking/lockdep.c:5193
 lock_acquire+0x1ed/0x550 kernel/locking/lockdep.c:5816
 percpu_down_read include/linux/percpu-rwsem.h:51 [inline]
 cpus_read_lock+0x42/0x150 kernel/cpu.c:490
 apply_wqattrs_lock kernel/workqueue.c:5134 [inline]
 alloc_workqueue+0xb99/0x1ff0 kernel/workqueue.c:5719
 padata_alloc+0xc3/0x370 kernel/padata.c:1007
 pcrypt_init_padata+0x27/0x100 crypto/pcrypt.c:327
 pcrypt_init+0x65/0xe0 crypto/pcrypt.c:352
 do_one_initcall+0x248/0x880 init/main.c:1267
 do_initcall_level+0x157/0x210 init/main.c:1329
 do_initcalls+0x3f/0x80 init/main.c:1345
 kernel_init_freeable+0x435/0x5d0 init/main.c:1578
 kernel_init+0x1d/0x2b0 init/main.c:1467
 ret_from_fork+0x4b/0x80 arch/x86/kernel/process.c:147
 ret_from_fork_asm+0x1a/0x30 arch/x86/entry/entry_64.S:244
 </TASK>
cryptd: max_cpu_qlen set to 1000
raid6: skipped pq benchmark and selected avx2x4
raid6: using avx2x2 recovery algorithm
ACPI: Added _OSI(Module Device)
ACPI: Added _OSI(Processor Device)
ACPI: Added _OSI(3.0 _SCP Extensions)
ACPI: Added _OSI(Processor Aggregator Device)
ACPI: 2 ACPI AML tables successfully acquired and loaded
ACPI: Interpreter enabled
ACPI: PM: (supports S0 S3 S4 S5)
ACPI: Using IOAPIC for interrupt routing
PCI: Using host bridge windows from ACPI; if necessary, use "pci=3Dnocrs" a=
nd report a bug
PCI: Ignoring E820 reservations for host bridge windows
ACPI: Enabled 16 GPEs in block 00 to 0F
ACPI: PCI Root Bridge [PCI0] (domain 0000 [bus 00-ff])
acpi PNP0A03:00: _OSC: OS supports [ASPM ClockPM Segments MSI HPX-Type3]
acpi PNP0A03:00: _OSC: not requesting OS control; OS requires [ExtendedConf=
ig ASPM ClockPM MSI]
acpi PNP0A03:00: fail to add MMCONFIG information, can't access extended co=
nfiguration space under this bridge
PCI host bridge to bus 0000:00
pci_bus 0000:00: Unknown NUMA node; performance will be reduced
pci_bus 0000:00: root bus resource [io  0x0000-0x0cf7 window]
pci_bus 0000:00: root bus resource [io  0x0d00-0xffff window]
pci_bus 0000:00: root bus resource [mem 0x000a0000-0x000bffff window]
pci_bus 0000:00: root bus resource [mem 0xc0000000-0xfebfefff window]
pci_bus 0000:00: root bus resource [bus 00-ff]
pci 0000:00:00.0: [8086:1237] type 00 class 0x060000 conventional PCI endpo=
int
pci 0000:00:01.0: [8086:7110] type 00 class 0x060100 conventional PCI endpo=
int
pci 0000:00:01.3: [8086:7113] type 00 class 0x068000 conventional PCI endpo=
int
pci 0000:00:01.3: quirk: [io  0xb000-0xb03f] claimed by PIIX4 ACPI
pci 0000:00:03.0: [1af4:1004] type 00 class 0x000000 conventional PCI endpo=
int
pci 0000:00:03.0: BAR 0 [io  0xc000-0xc03f]
pci 0000:00:03.0: BAR 1 [mem 0xfe800000-0xfe80007f]
pci 0000:00:04.0: [1af4:1000] type 00 class 0x020000 conventional PCI endpo=
int
pci 0000:00:04.0: BAR 0 [io  0xc040-0xc07f]
pci 0000:00:04.0: BAR 1 [mem 0xfe801000-0xfe80107f]
pci 0000:00:05.0: [1ae0:a002] type 00 class 0x030000 conventional PCI endpo=
int
pci 0000:00:05.0: BAR 0 [mem 0xfe000000-0xfe7fffff]
pci 0000:00:05.0: Video device with shadowed ROM at [mem 0x000c0000-0x000df=
fff]
pci 0000:00:06.0: [1af4:1002] type 00 class 0x00ff00 conventional PCI endpo=
int
pci 0000:00:06.0: BAR 0 [io  0xc080-0xc09f]
pci 0000:00:06.0: BAR 1 [mem 0xfe802000-0xfe80207f]
pci 0000:00:07.0: [1af4:1005] type 00 class 0x00ff00 conventional PCI endpo=
int
pci 0000:00:07.0: BAR 0 [io  0xc0a0-0xc0bf]
pci 0000:00:07.0: BAR 1 [mem 0xfe803000-0xfe80303f]
ACPI: PCI: Interrupt link LNKA configured for IRQ 10
ACPI: PCI: Interrupt link LNKB configured for IRQ 10
ACPI: PCI: Interrupt link LNKC configured for IRQ 11
ACPI: PCI: Interrupt link LNKD configured for IRQ 11
ACPI: PCI: Interrupt link LNKS configured for IRQ 9
iommu: Default domain type: Translated
iommu: DMA domain TLB invalidation policy: lazy mode
SCSI subsystem initialized
libata version 3.00 loaded.
ACPI: bus type USB registered
usbcore: registered new interface driver usbfs
usbcore: registered new interface driver hub
usbcore: registered new device driver usb
mc: Linux media interface: v0.10
videodev: Linux video capture interface: v2.00
pps_core: LinuxPPS API ver. 1 registered
pps_core: Software ver. 5.3.6 - Copyright 2005-2007 Rodolfo Giometti <giome=
tti@linux.it>
PTP clock support registered
EDAC MC: Ver: 3.0.0
Advanced Linux Sound Architecture Driver Initialized.
Bluetooth: Core ver 2.22
NET: Registered PF_BLUETOOTH protocol family
Bluetooth: HCI device and connection manager initialized
Bluetooth: HCI socket layer initialized
Bluetooth: L2CAP socket layer initialized
Bluetooth: SCO socket layer initialized
NET: Registered PF_ATMPVC protocol family
NET: Registered PF_ATMSVC protocol family
NetLabel: Initializing
NetLabel:  domain hash size =3D 128
NetLabel:  protocols =3D UNLABELED CIPSOv4 CALIPSO
NetLabel:  unlabeled traffic allowed by default
nfc: nfc_init: NFC Core ver 0.1
NET: Registered PF_NFC protocol family
PCI: Using ACPI for IRQ routing
PCI: pci_cache_line_size set to 64 bytes
e820: reserve RAM buffer [mem 0x0009fc00-0x0009ffff]
e820: reserve RAM buffer [mem 0xbfffd000-0xbfffffff]
pci 0000:00:05.0: vgaarb: setting as boot VGA device
pci 0000:00:05.0: vgaarb: bridge control possible
pci 0000:00:05.0: vgaarb: VGA device added: decodes=3Dio+mem,owns=3Dio+mem,=
locks=3Dnone
vgaarb: loaded
clocksource: Switched to clocksource kvm-clock
VFS: Disk quotas dquot_6.6.0
VFS: Dquot-cache hash table entries: 512 (order 0, 4096 bytes)
netfs: FS-Cache loaded
CacheFiles: Loaded
TOMOYO: 2.6.0
Mandatory Access Control activated.
AppArmor: AppArmor Filesystem Enabled
pnp: PnP ACPI init
pnp: PnP ACPI: found 7 devices
clocksource: acpi_pm: mask: 0xffffff max_cycles: 0xffffff, max_idle_ns: 208=
5701024 ns
NET: Registered PF_INET protocol family
IP idents hash table entries: 131072 (order: 8, 1048576 bytes, vmalloc)
tcp_listen_portaddr_hash hash table entries: 4096 (order: 6, 294912 bytes, =
vmalloc)
Table-perturb hash table entries: 65536 (order: 6, 262144 bytes, vmalloc)
TCP established hash table entries: 65536 (order: 7, 524288 bytes, vmalloc)
TCP bind hash table entries: 65536 (order: 11, 9437184 bytes, vmalloc hugep=
age)
TCP: Hash tables configured (established 65536 bind 65536)
MPTCP token hash table entries: 8192 (order: 7, 720896 bytes, vmalloc)
UDP hash table entries: 4096 (order: 7, 655360 bytes, vmalloc)
UDP-Lite hash table entries: 4096 (order: 7, 655360 bytes, vmalloc)
NET: Registered PF_UNIX/PF_LOCAL protocol family
RPC: Registered named UNIX socket transport module.
RPC: Registered udp transport module.
RPC: Registered tcp transport module.
RPC: Registered tcp-with-tls transport module.
RPC: Registered tcp NFSv4.1 backchannel transport module.
NET: Registered PF_XDP protocol family
pci_bus 0000:00: resource 4 [io  0x0000-0x0cf7 window]
pci_bus 0000:00: resource 5 [io  0x0d00-0xffff window]
pci_bus 0000:00: resource 6 [mem 0x000a0000-0x000bffff window]
pci_bus 0000:00: resource 7 [mem 0xc0000000-0xfebfefff window]
pci 0000:00:00.0: Limiting direct PCI/PCI transfers
PCI: CLS 0 bytes, default 64
PCI-DMA: Using software bounce buffering for IO (SWIOTLB)
software IO TLB: mapped [mem 0x00000000b5400000-0x00000000b9400000] (64MB)
ACPI: bus type thunderbolt registered
RAPL PMU: API unit is 2^-32 Joules, 0 fixed counters, 10737418240 ms ovfl t=
imer
kvm_amd: CPU 1 isn't AMD or Hygon
clocksource: tsc: mask: 0xffffffffffffffff max_cycles: 0x1fb702bab20, max_i=
dle_ns: 440795313305 ns
clocksource: Switched to clocksource tsc
Initialise system trusted keyrings
workingset: timestamp_bits=3D40 max_order=3D21 bucket_order=3D0
DLM installed
squashfs: version 4.0 (2009/01/31) Phillip Lougher
NFS: Registering the id_resolver key type
Key type id_resolver registered
Key type id_legacy registered
nfs4filelayout_init: NFSv4 File Layout Driver Registering...
nfs4flexfilelayout_init: NFSv4 Flexfile Layout Driver Registering...
Key type cifs.spnego registered
Key type cifs.idmap registered
ntfs3: Enabled Linux POSIX ACLs support
ntfs3: Read-only LZX/Xpress compression included
efs: 1.0a - http://aeschi.ch.eu.org/efs/
jffs2: version 2.2. (NAND) (SUMMARY)  =C2=A9 2001-2006 Red Hat, Inc.
romfs: ROMFS MTD (C) 2007 Red Hat, Inc.
QNX4 filesystem 0.2.3 registered.
qnx6: QNX6 filesystem 1.0.0 registered.
fuse: init (API version 7.40)
orangefs_debugfs_init: called with debug mask: :none: :0:
orangefs_init: module version upstream loaded
JFS: nTxBlock =3D 8192, nTxLock =3D 65536
SGI XFS with ACLs, security attributes, realtime, quota, no debug enabled
9p: Installing v9fs 9p2000 file system support
NILFS version 2 loaded
befs: version: 0.9.3
ocfs2: Registered cluster interface o2cb
ocfs2: Registered cluster interface user
OCFS2 User DLM kernel interface loaded
gfs2: GFS2 installed
ceph: loaded (mds proto 32)
NET: Registered PF_ALG protocol family
xor: automatically using best checksumming function   avx      =20
async_tx: api initialized (async)
Key type asymmetric registered
Asymmetric key parser 'x509' registered
Asymmetric key parser 'pkcs8' registered
Key type pkcs7_test registered
Block layer SCSI generic (bsg) driver version 0.4 loaded (major 239)
io scheduler mq-deadline registered
io scheduler kyber registered
io scheduler bfq registered
input: Power Button as /devices/LNXSYSTM:00/LNXPWRBN:00/input/input0
ACPI: button: Power Button [PWRF]
input: Sleep Button as /devices/LNXSYSTM:00/LNXSLPBN:00/input/input1
ACPI: button: Sleep Button [SLPF]
ioatdma: Intel(R) QuickData Technology Driver 5.00
ACPI: \_SB_.LNKC: Enabled at IRQ 11
virtio-pci 0000:00:03.0: virtio_pci: leaving for legacy driver
ACPI: \_SB_.LNKD: Enabled at IRQ 10
virtio-pci 0000:00:04.0: virtio_pci: leaving for legacy driver
ACPI: \_SB_.LNKB: Enabled at IRQ 10
virtio-pci 0000:00:06.0: virtio_pci: leaving for legacy driver
virtio-pci 0000:00:07.0: virtio_pci: leaving for legacy driver
N_HDLC line discipline registered with maxframe=3D4096
Serial: 8250/16550 driver, 4 ports, IRQ sharing enabled
00:03: ttyS0 at I/O 0x3f8 (irq =3D 4, base_baud =3D 115200) is a 16550A
00:04: ttyS1 at I/O 0x2f8 (irq =3D 3, base_baud =3D 115200) is a 16550A
00:05: ttyS2 at I/O 0x3e8 (irq =3D 6, base_baud =3D 115200) is a 16550A
00:06: ttyS3 at I/O 0x2e8 (irq =3D 7, base_baud =3D 115200) is a 16550A
Non-volatile memory driver v1.3
Linux agpgart interface v0.103
ACPI: bus type drm_connector registered
[drm] Initialized vgem 1.0.0 for vgem on minor 0
[drm] Initialized vkms 1.0.0 for vkms on minor 1
Console: switching to colour frame buffer device 128x48
platform vkms: [drm] fb0: vkmsdrmfb frame buffer device
usbcore: registered new interface driver udl
brd: module loaded
loop: module loaded
zram: Added device: zram0
null_blk: disk nullb0 created
null_blk: module loaded
Guest personality initialized and is inactive
VMCI host device registered (name=3Dvmci, major=3D10, minor=3D118)
Initialized host personality
usbcore: registered new interface driver rtsx_usb
usbcore: registered new interface driver viperboard
usbcore: registered new interface driver dln2
usbcore: registered new interface driver pn533_usb
nfcsim 0.2 initialized
usbcore: registered new interface driver port100
usbcore: registered new interface driver nfcmrvl
Loading iSCSI transport class v2.0-870.
virtio_scsi virtio0: 1/0/0 default/read/poll queues
scsi host0: Virtio SCSI HBA
st: Version 20160209, fixed bufsize 32768, s/g segs 256
Rounding down aligned max_sectors from 4294967295 to 4294967288
db_root: cannot open: /etc/target
slram: not enough parameters.
ftl_cs: FTL header not found.
wireguard: WireGuard 1.0.0 loaded. See www.wireguard.com for information.
wireguard: Copyright (C) 2015-2019 Jason A. Donenfeld <Jason@zx2c4.com>. Al=
l Rights Reserved.
eql: Equalizer2002: Simon Janes (simon@ncm.com) and David S. Miller (davem@=
redhat.com)
MACsec IEEE 802.1AE
tun: Universal TUN/TAP device driver, 1.6
vcan: Virtual CAN interface driver
vxcan: Virtual CAN Tunnel driver
slcan: serial line CAN interface driver
CAN device driver interface
usbcore: registered new interface driver usb_8dev
usbcore: registered new interface driver ems_usb
usbcore: registered new interface driver gs_usb
usbcore: registered new interface driver kvaser_usb
usbcore: registered new interface driver mcba_usb
usbcore: registered new interface driver peak_usb
e100: Intel(R) PRO/100 Network Driver
e100: Copyright(c) 1999-2006 Intel Corporation
e1000: Intel(R) PRO/1000 Network Driver
e1000: Copyright (c) 1999-2006 Intel Corporation.
e1000e: Intel(R) PRO/1000 Network Driver
e1000e: Copyright(c) 1999 - 2015 Intel Corporation.
mkiss: AX.25 Multikiss, Hans Albas PE1AYX
AX.25: 6pack driver, Revision: 0.3.0
AX.25: bpqether driver version 004
PPP generic driver version 2.4.2
PPP BSD Compression module registered
PPP Deflate Compression module registered
PPP MPPE Compression module registered
NET: Registered PF_PPPOX protocol family
PPTP driver version 0.8.5
SLIP: version 0.8.4-NET3.019-NEWTTY (dynamic channels, max=3D256) (6 bit en=
capsulation enabled).
CSLIP: code copyright 1989 Regents of the University of California.
SLIP linefill/keepalive option.
hdlc: HDLC support module revision 1.22
LAPB Ethernet driver version 0.02
usbcore: registered new interface driver ath9k_htc
usbcore: registered new interface driver carl9170
usbcore: registered new interface driver ath6kl_usb
usbcore: registered new interface driver ar5523
usbcore: registered new interface driver ath10k_usb
mac80211_hwsim: initializing netlink
ieee80211 phy0: Selected rate control algorithm 'minstrel_ht'
ieee80211 phy1: Selected rate control algorithm 'minstrel_ht'
usbcore: registered new interface driver atusb
mac802154_hwsim mac802154_hwsim: Added 2 mac802154 hwsim hardware radios
VMware vmxnet3 virtual NIC driver - version 1.9.0.0-k-NAPI
usbcore: registered new interface driver catc
usbcore: registered new interface driver kaweth
pegasus: Pegasus/Pegasus II USB Ethernet driver
usbcore: registered new interface driver pegasus
usbcore: registered new interface driver rtl8150
usbcore: registered new device driver r8152-cfgselector
usbcore: registered new interface driver r8152
usbcore: registered new interface driver hso
usbcore: registered new interface driver lan78xx
usbcore: registered new interface driver asix
usbcore: registered new interface driver ax88179_178a
usbcore: registered new interface driver cdc_ether
usbcore: registered new interface driver cdc_eem
usbcore: registered new interface driver dm9601
usbcore: registered new interface driver sr9700
usbcore: registered new interface driver CoreChips
usbcore: registered new interface driver smsc75xx
usbcore: registered new interface driver smsc95xx
usbcore: registered new interface driver gl620a
usbcore: registered new interface driver net1080
usbcore: registered new interface driver plusb
usbcore: registered new interface driver rndis_host
usbcore: registered new interface driver cdc_subset
usbcore: registered new interface driver zaurus
usbcore: registered new interface driver MOSCHIP usb-ethernet driver
usbcore: registered new interface driver int51x1
usbcore: registered new interface driver cdc_phonet
usbcore: registered new interface driver kalmia
usbcore: registered new interface driver ipheth
usbcore: registered new interface driver sierra_net
usbcore: registered new interface driver cx82310_eth
usbcore: registered new interface driver cdc_ncm
usbcore: registered new interface driver huawei_cdc_ncm
usbcore: registered new interface driver lg-vl600
usbcore: registered new interface driver qmi_wwan
usbcore: registered new interface driver cdc_mbim
usbcore: registered new interface driver ch9200
usbcore: registered new interface driver r8153_ecm
VFIO - User Level meta-driver version: 0.3
aoe: AoE v85 initialised.
SPI driver max3421-hcd has no spi_device_id for maxim,max3421
usbcore: registered new interface driver cdc_acm
cdc_acm: USB Abstract Control Model driver for USB modems and ISDN adapters
usbcore: registered new interface driver usblp
usbcore: registered new interface driver cdc_wdm
usbcore: registered new interface driver usbtmc
usbcore: registered new interface driver uas
usbcore: registered new interface driver usb-storage
usbcore: registered new interface driver ums-alauda
usbcore: registered new interface driver ums-cypress
usbcore: registered new interface driver ums-datafab
usbcore: registered new interface driver ums_eneub6250
usbcore: registered new interface driver ums-freecom
usbcore: registered new interface driver ums-isd200
usbcore: registered new interface driver ums-jumpshot
usbcore: registered new interface driver ums-karma
usbcore: registered new interface driver ums-onetouch
usbcore: registered new interface driver ums-realtek
usbcore: registered new interface driver ums-sddr09
usbcore: registered new interface driver ums-sddr55
usbcore: registered new interface driver ums-usbat
usbcore: registered new interface driver mdc800
mdc800: v0.7.5 (30/10/2000):USB Driver for Mustek MDC800 Digital Camera
usbcore: registered new interface driver microtekX6
usbcore: registered new interface driver usbserial_generic
usbserial: USB Serial support registered for generic
usbcore: registered new interface driver aircable
usbserial: USB Serial support registered for aircable
usbcore: registered new interface driver ark3116
usbserial: USB Serial support registered for ark3116
usbcore: registered new interface driver belkin_sa
usbserial: USB Serial support registered for Belkin / Peracom / GoHubs USB =
Serial Adapter
usbcore: registered new interface driver ch341
usbserial: USB Serial support registered for ch341-uart
usbcore: registered new interface driver cp210x
usbserial: USB Serial support registered for cp210x
usbcore: registered new interface driver cyberjack
usbserial: USB Serial support registered for Reiner SCT Cyberjack USB card =
reader
usbcore: registered new interface driver cypress_m8
usbserial: USB Serial support registered for DeLorme Earthmate USB
usbserial: USB Serial support registered for HID->COM RS232 Adapter
usbserial: USB Serial support registered for Nokia CA-42 V2 Adapter
usbcore: registered new interface driver usb_debug
usbserial: USB Serial support registered for debug
usbserial: USB Serial support registered for xhci_dbc
usbcore: registered new interface driver digi_acceleport
usbserial: USB Serial support registered for Digi 2 port USB adapter
usbserial: USB Serial support registered for Digi 4 port USB adapter
usbcore: registered new interface driver io_edgeport
usbserial: USB Serial support registered for Edgeport 2 port adapter
usbserial: USB Serial support registered for Edgeport 4 port adapter
usbserial: USB Serial support registered for Edgeport 8 port adapter
usbserial: USB Serial support registered for EPiC device
usbcore: registered new interface driver io_ti
usbserial: USB Serial support registered for Edgeport TI 1 port adapter
usbserial: USB Serial support registered for Edgeport TI 2 port adapter
usbcore: registered new interface driver empeg
usbserial: USB Serial support registered for empeg
usbcore: registered new interface driver f81534a_ctrl
usbcore: registered new interface driver f81232
usbserial: USB Serial support registered for f81232
usbserial: USB Serial support registered for f81534a
usbcore: registered new interface driver f81534
usbserial: USB Serial support registered for Fintek F81532/F81534
usbcore: registered new interface driver ftdi_sio
usbserial: USB Serial support registered for FTDI USB Serial Device
usbcore: registered new interface driver garmin_gps
usbserial: USB Serial support registered for Garmin GPS usb/tty
usbcore: registered new interface driver ipaq
usbserial: USB Serial support registered for PocketPC PDA
usbcore: registered new interface driver ipw
usbserial: USB Serial support registered for IPWireless converter
usbcore: registered new interface driver ir_usb
usbserial: USB Serial support registered for IR Dongle
usbcore: registered new interface driver iuu_phoenix
usbserial: USB Serial support registered for iuu_phoenix
usbcore: registered new interface driver keyspan
usbserial: USB Serial support registered for Keyspan - (without firmware)
usbserial: USB Serial support registered for Keyspan 1 port adapter
usbserial: USB Serial support registered for Keyspan 2 port adapter
usbserial: USB Serial support registered for Keyspan 4 port adapter
usbcore: registered new interface driver keyspan_pda
usbserial: USB Serial support registered for Keyspan PDA
usbserial: USB Serial support registered for Keyspan PDA - (prerenumeration=
)
usbcore: registered new interface driver kl5kusb105
usbserial: USB Serial support registered for KL5KUSB105D / PalmConnect
usbcore: registered new interface driver kobil_sct
usbserial: USB Serial support registered for KOBIL USB smart card terminal
usbcore: registered new interface driver mct_u232
usbserial: USB Serial support registered for MCT U232
usbcore: registered new interface driver metro_usb
usbserial: USB Serial support registered for Metrologic USB to Serial
usbcore: registered new interface driver mos7720
usbserial: USB Serial support registered for Moschip 2 port adapter
usbcore: registered new interface driver mos7840
usbserial: USB Serial support registered for Moschip 7840/7820 USB Serial D=
river
usbcore: registered new interface driver mxuport
usbserial: USB Serial support registered for MOXA UPort
usbcore: registered new interface driver navman
usbserial: USB Serial support registered for navman
usbcore: registered new interface driver omninet
usbserial: USB Serial support registered for ZyXEL - omni.net usb
usbcore: registered new interface driver opticon
usbserial: USB Serial support registered for opticon
usbcore: registered new interface driver option
usbserial: USB Serial support registered for GSM modem (1-port)
usbcore: registered new interface driver oti6858
usbserial: USB Serial support registered for oti6858
usbcore: registered new interface driver pl2303
usbserial: USB Serial support registered for pl2303
usbcore: registered new interface driver qcaux
usbserial: USB Serial support registered for qcaux
usbcore: registered new interface driver qcserial
usbserial: USB Serial support registered for Qualcomm USB modem
usbcore: registered new interface driver quatech2
usbserial: USB Serial support registered for Quatech 2nd gen USB to Serial =
Driver
usbcore: registered new interface driver safe_serial
usbserial: USB Serial support registered for safe_serial
usbcore: registered new interface driver sierra
usbserial: USB Serial support registered for Sierra USB modem
usbcore: registered new interface driver usb_serial_simple
usbserial: USB Serial support registered for carelink
usbserial: USB Serial support registered for flashloader
usbserial: USB Serial support registered for funsoft
usbserial: USB Serial support registered for google
usbserial: USB Serial support registered for hp4x
usbserial: USB Serial support registered for kaufmann
usbserial: USB Serial support registered for libtransistor
usbserial: USB Serial support registered for moto_modem
usbserial: USB Serial support registered for motorola_tetra
usbserial: USB Serial support registered for nokia
usbserial: USB Serial support registered for novatel_gps
usbserial: USB Serial support registered for siemens_mpi
usbserial: USB Serial support registered for suunto
usbserial: USB Serial support registered for vivopay
usbserial: USB Serial support registered for zio
usbcore: registered new interface driver spcp8x5
usbserial: USB Serial support registered for SPCP8x5
usbcore: registered new interface driver ssu100
usbserial: USB Serial support registered for Quatech SSU-100 USB to Serial =
Driver
usbcore: registered new interface driver symbolserial
usbserial: USB Serial support registered for symbol
usbcore: registered new interface driver ti_usb_3410_5052
usbserial: USB Serial support registered for TI USB 3410 1 port adapter
usbserial: USB Serial support registered for TI USB 5052 2 port adapter
usbcore: registered new interface driver upd78f0730
usbserial: USB Serial support registered for upd78f0730
usbcore: registered new interface driver visor
usbserial: USB Serial support registered for Handspring Visor / Palm OS
usbserial: USB Serial support registered for Sony Clie 5.0
usbserial: USB Serial support registered for Sony Clie 3.5
usbcore: registered new interface driver wishbone_serial
usbserial: USB Serial support registered for wishbone_serial
usbcore: registered new interface driver whiteheat
usbserial: USB Serial support registered for Connect Tech - WhiteHEAT - (pr=
erenumeration)
usbserial: USB Serial support registered for Connect Tech - WhiteHEAT
usbcore: registered new interface driver xr_serial
usbserial: USB Serial support registered for xr_serial
usbcore: registered new interface driver xsens_mt
usbserial: USB Serial support registered for xsens_mt
usbcore: registered new interface driver adutux
usbcore: registered new interface driver appledisplay
usbcore: registered new interface driver cypress_cy7c63
usbcore: registered new interface driver cytherm
usbcore: registered new interface driver emi26 - firmware loader
usbcore: registered new interface driver emi62 - firmware loader
usbcore: registered new interface driver idmouse
usbcore: registered new interface driver iowarrior
usbcore: registered new interface driver isight_firmware
usbcore: registered new interface driver usblcd
usbcore: registered new interface driver ldusb
usbcore: registered new interface driver legousbtower
usbcore: registered new interface driver usbtest
usbcore: registered new interface driver usb_ehset_test
usbcore: registered new interface driver trancevibrator
usbcore: registered new interface driver uss720
uss720: USB Parport Cable driver for Cables using the Lucent Technologies U=
SS720 Chip
uss720: NOTE: this is a special purpose driver to allow nonstandard
uss720: protocols (eg. bitbang) over USS720 usb to parallel cables
uss720: If you just want to connect to a printer, use usblp instead
usbcore: registered new interface driver usbsevseg
usbcore: registered new interface driver yurex
usbcore: registered new interface driver chaoskey
usbcore: registered new interface driver sisusb
usbcore: registered new interface driver lvs
usbcore: registered new interface driver cxacru
usbcore: registered new interface driver speedtch
usbcore: registered new interface driver ueagle-atm
xusbatm: malformed module parameters
dummy_hcd dummy_hcd.0: USB Host+Gadget Emulator, driver 02 May 2005
dummy_hcd dummy_hcd.0: Dummy host controller
dummy_hcd dummy_hcd.0: new USB bus registered, assigned bus number 1
usb usb1: New USB device found, idVendor=3D1d6b, idProduct=3D0002, bcdDevic=
e=3D 6.10
usb usb1: New USB device strings: Mfr=3D3, Product=3D2, SerialNumber=3D1
usb usb1: Product: Dummy host controller
usb usb1: Manufacturer: Linux 6.10.0-rc7-next-20240709-syzkaller dummy_hcd
usb usb1: SerialNumber: dummy_hcd.0
hub 1-0:1.0: USB hub found
hub 1-0:1.0: 1 port detected
dummy_hcd dummy_hcd.1: USB Host+Gadget Emulator, driver 02 May 2005
dummy_hcd dummy_hcd.1: Dummy host controller
dummy_hcd dummy_hcd.1: new USB bus registered, assigned bus number 2
usb usb2: New USB device found, idVendor=3D1d6b, idProduct=3D0002, bcdDevic=
e=3D 6.10
usb usb2: New USB device strings: Mfr=3D3, Product=3D2, SerialNumber=3D1
usb usb2: Product: Dummy host controller
usb usb2: Manufacturer: Linux 6.10.0-rc7-next-20240709-syzkaller dummy_hcd
usb usb2: SerialNumber: dummy_hcd.1
hub 2-0:1.0: USB hub found
hub 2-0:1.0: 1 port detected
dummy_hcd dummy_hcd.2: USB Host+Gadget Emulator, driver 02 May 2005
dummy_hcd dummy_hcd.2: Dummy host controller
dummy_hcd dummy_hcd.2: new USB bus registered, assigned bus number 3
usb usb3: New USB device found, idVendor=3D1d6b, idProduct=3D0002, bcdDevic=
e=3D 6.10
usb usb3: New USB device strings: Mfr=3D3, Product=3D2, SerialNumber=3D1
usb usb3: Product: Dummy host controller
usb usb3: Manufacturer: Linux 6.10.0-rc7-next-20240709-syzkaller dummy_hcd
usb usb3: SerialNumber: dummy_hcd.2
hub 3-0:1.0: USB hub found
hub 3-0:1.0: 1 port detected
dummy_hcd dummy_hcd.3: USB Host+Gadget Emulator, driver 02 May 2005
dummy_hcd dummy_hcd.3: Dummy host controller
dummy_hcd dummy_hcd.3: new USB bus registered, assigned bus number 4
usb usb4: New USB device found, idVendor=3D1d6b, idProduct=3D0002, bcdDevic=
e=3D 6.10
usb usb4: New USB device strings: Mfr=3D3, Product=3D2, SerialNumber=3D1
usb usb4: Product: Dummy host controller
usb usb4: Manufacturer: Linux 6.10.0-rc7-next-20240709-syzkaller dummy_hcd
usb usb4: SerialNumber: dummy_hcd.3
hub 4-0:1.0: USB hub found
hub 4-0:1.0: 1 port detected
dummy_hcd dummy_hcd.4: USB Host+Gadget Emulator, driver 02 May 2005
dummy_hcd dummy_hcd.4: Dummy host controller
dummy_hcd dummy_hcd.4: new USB bus registered, assigned bus number 5
usb usb5: New USB device found, idVendor=3D1d6b, idProduct=3D0002, bcdDevic=
e=3D 6.10
usb usb5: New USB device strings: Mfr=3D3, Product=3D2, SerialNumber=3D1
usb usb5: Product: Dummy host controller
usb usb5: Manufacturer: Linux 6.10.0-rc7-next-20240709-syzkaller dummy_hcd
usb usb5: SerialNumber: dummy_hcd.4
hub 5-0:1.0: USB hub found
hub 5-0:1.0: 1 port detected
dummy_hcd dummy_hcd.5: USB Host+Gadget Emulator, driver 02 May 2005
dummy_hcd dummy_hcd.5: Dummy host controller
dummy_hcd dummy_hcd.5: new USB bus registered, assigned bus number 6
usb usb6: New USB device found, idVendor=3D1d6b, idProduct=3D0002, bcdDevic=
e=3D 6.10
usb usb6: New USB device strings: Mfr=3D3, Product=3D2, SerialNumber=3D1
usb usb6: Product: Dummy host controller
usb usb6: Manufacturer: Linux 6.10.0-rc7-next-20240709-syzkaller dummy_hcd
usb usb6: SerialNumber: dummy_hcd.5
hub 6-0:1.0: USB hub found
hub 6-0:1.0: 1 port detected
dummy_hcd dummy_hcd.6: USB Host+Gadget Emulator, driver 02 May 2005
dummy_hcd dummy_hcd.6: Dummy host controller
dummy_hcd dummy_hcd.6: new USB bus registered, assigned bus number 7
usb usb7: New USB device found, idVendor=3D1d6b, idProduct=3D0002, bcdDevic=
e=3D 6.10
usb usb7: New USB device strings: Mfr=3D3, Product=3D2, SerialNumber=3D1
usb usb7: Product: Dummy host controller
usb usb7: Manufacturer: Linux 6.10.0-rc7-next-20240709-syzkaller dummy_hcd
usb usb7: SerialNumber: dummy_hcd.6
hub 7-0:1.0: USB hub found
hub 7-0:1.0: 1 port detected
dummy_hcd dummy_hcd.7: USB Host+Gadget Emulator, driver 02 May 2005
dummy_hcd dummy_hcd.7: Dummy host controller
dummy_hcd dummy_hcd.7: new USB bus registered, assigned bus number 8
usb usb8: New USB device found, idVendor=3D1d6b, idProduct=3D0002, bcdDevic=
e=3D 6.10
usb usb8: New USB device strings: Mfr=3D3, Product=3D2, SerialNumber=3D1
usb usb8: Product: Dummy host controller
usb usb8: Manufacturer: Linux 6.10.0-rc7-next-20240709-syzkaller dummy_hcd
usb usb8: SerialNumber: dummy_hcd.7
hub 8-0:1.0: USB hub found
hub 8-0:1.0: 1 port detected
gadgetfs: USB Gadget filesystem, version 24 Aug 2004
vhci_hcd vhci_hcd.0: USB/IP Virtual Host Controller
vhci_hcd vhci_hcd.0: new USB bus registered, assigned bus number 9
vhci_hcd: created sysfs vhci_hcd.0
usb usb9: New USB device found, idVendor=3D1d6b, idProduct=3D0002, bcdDevic=
e=3D 6.10
usb usb9: New USB device strings: Mfr=3D3, Product=3D2, SerialNumber=3D1
usb usb9: Product: USB/IP Virtual Host Controller
usb usb9: Manufacturer: Linux 6.10.0-rc7-next-20240709-syzkaller vhci_hcd
usb usb9: SerialNumber: vhci_hcd.0
hub 9-0:1.0: USB hub found
hub 9-0:1.0: 8 ports detected
vhci_hcd vhci_hcd.0: USB/IP Virtual Host Controller
vhci_hcd vhci_hcd.0: new USB bus registered, assigned bus number 10
usb usb10: We don't know the algorithms for LPM for this host, disabling LP=
M.
usb usb10: New USB device found, idVendor=3D1d6b, idProduct=3D0003, bcdDevi=
ce=3D 6.10
usb usb10: New USB device strings: Mfr=3D3, Product=3D2, SerialNumber=3D1
usb usb10: Product: USB/IP Virtual Host Controller
usb usb10: Manufacturer: Linux 6.10.0-rc7-next-20240709-syzkaller vhci_hcd
usb usb10: SerialNumber: vhci_hcd.0
hub 10-0:1.0: USB hub found
hub 10-0:1.0: 8 ports detected
vhci_hcd vhci_hcd.1: USB/IP Virtual Host Controller
vhci_hcd vhci_hcd.1: new USB bus registered, assigned bus number 11
usb usb11: New USB device found, idVendor=3D1d6b, idProduct=3D0002, bcdDevi=
ce=3D 6.10
usb usb11: New USB device strings: Mfr=3D3, Product=3D2, SerialNumber=3D1
usb usb11: Product: USB/IP Virtual Host Controller
usb usb11: Manufacturer: Linux 6.10.0-rc7-next-20240709-syzkaller vhci_hcd
usb usb11: SerialNumber: vhci_hcd.1
hub 11-0:1.0: USB hub found
hub 11-0:1.0: 8 ports detected
vhci_hcd vhci_hcd.1: USB/IP Virtual Host Controller
vhci_hcd vhci_hcd.1: new USB bus registered, assigned bus number 12
usb usb12: We don't know the algorithms for LPM for this host, disabling LP=
M.
usb usb12: New USB device found, idVendor=3D1d6b, idProduct=3D0003, bcdDevi=
ce=3D 6.10
usb usb12: New USB device strings: Mfr=3D3, Product=3D2, SerialNumber=3D1
usb usb12: Product: USB/IP Virtual Host Controller
usb usb12: Manufacturer: Linux 6.10.0-rc7-next-20240709-syzkaller vhci_hcd
usb usb12: SerialNumber: vhci_hcd.1
hub 12-0:1.0: USB hub found
hub 12-0:1.0: 8 ports detected
vhci_hcd vhci_hcd.2: USB/IP Virtual Host Controller
vhci_hcd vhci_hcd.2: new USB bus registered, assigned bus number 13
usb usb13: New USB device found, idVendor=3D1d6b, idProduct=3D0002, bcdDevi=
ce=3D 6.10
usb usb13: New USB device strings: Mfr=3D3, Product=3D2, SerialNumber=3D1
usb usb13: Product: USB/IP Virtual Host Controller
usb usb13: Manufacturer: Linux 6.10.0-rc7-next-20240709-syzkaller vhci_hcd
usb usb13: SerialNumber: vhci_hcd.2
hub 13-0:1.0: USB hub found
hub 13-0:1.0: 8 ports detected
vhci_hcd vhci_hcd.2: USB/IP Virtual Host Controller
vhci_hcd vhci_hcd.2: new USB bus registered, assigned bus number 14
usb usb14: We don't know the algorithms for LPM for this host, disabling LP=
M.
usb usb14: New USB device found, idVendor=3D1d6b, idProduct=3D0003, bcdDevi=
ce=3D 6.10
usb usb14: New USB device strings: Mfr=3D3, Product=3D2, SerialNumber=3D1
usb usb14: Product: USB/IP Virtual Host Controller
usb usb14: Manufacturer: Linux 6.10.0-rc7-next-20240709-syzkaller vhci_hcd
usb usb14: SerialNumber: vhci_hcd.2
hub 14-0:1.0: USB hub found
hub 14-0:1.0: 8 ports detected
vhci_hcd vhci_hcd.3: USB/IP Virtual Host Controller
vhci_hcd vhci_hcd.3: new USB bus registered, assigned bus number 15
usb usb15: New USB device found, idVendor=3D1d6b, idProduct=3D0002, bcdDevi=
ce=3D 6.10
usb usb15: New USB device strings: Mfr=3D3, Product=3D2, SerialNumber=3D1
usb usb15: Product: USB/IP Virtual Host Controller
usb usb15: Manufacturer: Linux 6.10.0-rc7-next-20240709-syzkaller vhci_hcd
usb usb15: SerialNumber: vhci_hcd.3
hub 15-0:1.0: USB hub found
hub 15-0:1.0: 8 ports detected
vhci_hcd vhci_hcd.3: USB/IP Virtual Host Controller
vhci_hcd vhci_hcd.3: new USB bus registered, assigned bus number 16
usb usb16: We don't know the algorithms for LPM for this host, disabling LP=
M.
usb usb16: New USB device found, idVendor=3D1d6b, idProduct=3D0003, bcdDevi=
ce=3D 6.10
usb usb16: New USB device strings: Mfr=3D3, Product=3D2, SerialNumber=3D1
usb usb16: Product: USB/IP Virtual Host Controller
usb usb16: Manufacturer: Linux 6.10.0-rc7-next-20240709-syzkaller vhci_hcd
usb usb16: SerialNumber: vhci_hcd.3
hub 16-0:1.0: USB hub found
hub 16-0:1.0: 8 ports detected
vhci_hcd vhci_hcd.4: USB/IP Virtual Host Controller
vhci_hcd vhci_hcd.4: new USB bus registered, assigned bus number 17
usb usb17: New USB device found, idVendor=3D1d6b, idProduct=3D0002, bcdDevi=
ce=3D 6.10
usb usb17: New USB device strings: Mfr=3D3, Product=3D2, SerialNumber=3D1
usb usb17: Product: USB/IP Virtual Host Controller
usb usb17: Manufacturer: Linux 6.10.0-rc7-next-20240709-syzkaller vhci_hcd
usb usb17: SerialNumber: vhci_hcd.4
hub 17-0:1.0: USB hub found
hub 17-0:1.0: 8 ports detected
vhci_hcd vhci_hcd.4: USB/IP Virtual Host Controller
vhci_hcd vhci_hcd.4: new USB bus registered, assigned bus number 18
usb usb18: We don't know the algorithms for LPM for this host, disabling LP=
M.
usb usb18: New USB device found, idVendor=3D1d6b, idProduct=3D0003, bcdDevi=
ce=3D 6.10
usb usb18: New USB device strings: Mfr=3D3, Product=3D2, SerialNumber=3D1
usb usb18: Product: USB/IP Virtual Host Controller
usb usb18: Manufacturer: Linux 6.10.0-rc7-next-20240709-syzkaller vhci_hcd
usb usb18: SerialNumber: vhci_hcd.4
hub 18-0:1.0: USB hub found
hub 18-0:1.0: 8 ports detected
vhci_hcd vhci_hcd.5: USB/IP Virtual Host Controller
vhci_hcd vhci_hcd.5: new USB bus registered, assigned bus number 19
usb usb19: New USB device found, idVendor=3D1d6b, idProduct=3D0002, bcdDevi=
ce=3D 6.10
usb usb19: New USB device strings: Mfr=3D3, Product=3D2, SerialNumber=3D1
usb usb19: Product: USB/IP Virtual Host Controller
usb usb19: Manufacturer: Linux 6.10.0-rc7-next-20240709-syzkaller vhci_hcd
usb usb19: SerialNumber: vhci_hcd.5
hub 19-0:1.0: USB hub found
hub 19-0:1.0: 8 ports detected
vhci_hcd vhci_hcd.5: USB/IP Virtual Host Controller
vhci_hcd vhci_hcd.5: new USB bus registered, assigned bus number 20
usb usb20: We don't know the algorithms for LPM for this host, disabling LP=
M.
usb usb20: New USB device found, idVendor=3D1d6b, idProduct=3D0003, bcdDevi=
ce=3D 6.10
usb usb20: New USB device strings: Mfr=3D3, Product=3D2, SerialNumber=3D1
usb usb20: Product: USB/IP Virtual Host Controller
usb usb20: Manufacturer: Linux 6.10.0-rc7-next-20240709-syzkaller vhci_hcd
usb usb20: SerialNumber: vhci_hcd.5
hub 20-0:1.0: USB hub found
hub 20-0:1.0: 8 ports detected
vhci_hcd vhci_hcd.6: USB/IP Virtual Host Controller
vhci_hcd vhci_hcd.6: new USB bus registered, assigned bus number 21
usb usb21: New USB device found, idVendor=3D1d6b, idProduct=3D0002, bcdDevi=
ce=3D 6.10
usb usb21: New USB device strings: Mfr=3D3, Product=3D2, SerialNumber=3D1
usb usb21: Product: USB/IP Virtual Host Controller
usb usb21: Manufacturer: Linux 6.10.0-rc7-next-20240709-syzkaller vhci_hcd
usb usb21: SerialNumber: vhci_hcd.6
hub 21-0:1.0: USB hub found
hub 21-0:1.0: 8 ports detected
vhci_hcd vhci_hcd.6: USB/IP Virtual Host Controller
vhci_hcd vhci_hcd.6: new USB bus registered, assigned bus number 22
usb usb22: We don't know the algorithms for LPM for this host, disabling LP=
M.
usb usb22: New USB device found, idVendor=3D1d6b, idProduct=3D0003, bcdDevi=
ce=3D 6.10
usb usb22: New USB device strings: Mfr=3D3, Product=3D2, SerialNumber=3D1
usb usb22: Product: USB/IP Virtual Host Controller
usb usb22: Manufacturer: Linux 6.10.0-rc7-next-20240709-syzkaller vhci_hcd
usb usb22: SerialNumber: vhci_hcd.6
hub 22-0:1.0: USB hub found
hub 22-0:1.0: 8 ports detected
vhci_hcd vhci_hcd.7: USB/IP Virtual Host Controller
vhci_hcd vhci_hcd.7: new USB bus registered, assigned bus number 23
usb usb23: New USB device found, idVendor=3D1d6b, idProduct=3D0002, bcdDevi=
ce=3D 6.10
usb usb23: New USB device strings: Mfr=3D3, Product=3D2, SerialNumber=3D1
usb usb23: Product: USB/IP Virtual Host Controller
usb usb23: Manufacturer: Linux 6.10.0-rc7-next-20240709-syzkaller vhci_hcd
usb usb23: SerialNumber: vhci_hcd.7
hub 23-0:1.0: USB hub found
hub 23-0:1.0: 8 ports detected
vhci_hcd vhci_hcd.7: USB/IP Virtual Host Controller
vhci_hcd vhci_hcd.7: new USB bus registered, assigned bus number 24
usb usb24: We don't know the algorithms for LPM for this host, disabling LP=
M.
usb usb24: New USB device found, idVendor=3D1d6b, idProduct=3D0003, bcdDevi=
ce=3D 6.10
usb usb24: New USB device strings: Mfr=3D3, Product=3D2, SerialNumber=3D1
usb usb24: Product: USB/IP Virtual Host Controller
usb usb24: Manufacturer: Linux 6.10.0-rc7-next-20240709-syzkaller vhci_hcd
usb usb24: SerialNumber: vhci_hcd.7
hub 24-0:1.0: USB hub found
hub 24-0:1.0: 8 ports detected
vhci_hcd vhci_hcd.8: USB/IP Virtual Host Controller
vhci_hcd vhci_hcd.8: new USB bus registered, assigned bus number 25
usb usb25: New USB device found, idVendor=3D1d6b, idProduct=3D0002, bcdDevi=
ce=3D 6.10
usb usb25: New USB device strings: Mfr=3D3, Product=3D2, SerialNumber=3D1
usb usb25: Product: USB/IP Virtual Host Controller
usb usb25: Manufacturer: Linux 6.10.0-rc7-next-20240709-syzkaller vhci_hcd
usb usb25: SerialNumber: vhci_hcd.8
hub 25-0:1.0: USB hub found
hub 25-0:1.0: 8 ports detected
vhci_hcd vhci_hcd.8: USB/IP Virtual Host Controller
vhci_hcd vhci_hcd.8: new USB bus registered, assigned bus number 26
usb usb26: We don't know the algorithms for LPM for this host, disabling LP=
M.
usb usb26: New USB device found, idVendor=3D1d6b, idProduct=3D0003, bcdDevi=
ce=3D 6.10
usb usb26: New USB device strings: Mfr=3D3, Product=3D2, SerialNumber=3D1
usb usb26: Product: USB/IP Virtual Host Controller
usb usb26: Manufacturer: Linux 6.10.0-rc7-next-20240709-syzkaller vhci_hcd
usb usb26: SerialNumber: vhci_hcd.8
hub 26-0:1.0: USB hub found
hub 26-0:1.0: 8 ports detected
vhci_hcd vhci_hcd.9: USB/IP Virtual Host Controller
vhci_hcd vhci_hcd.9: new USB bus registered, assigned bus number 27
usb usb27: New USB device found, idVendor=3D1d6b, idProduct=3D0002, bcdDevi=
ce=3D 6.10
usb usb27: New USB device strings: Mfr=3D3, Product=3D2, SerialNumber=3D1
usb usb27: Product: USB/IP Virtual Host Controller
usb usb27: Manufacturer: Linux 6.10.0-rc7-next-20240709-syzkaller vhci_hcd
usb usb27: SerialNumber: vhci_hcd.9
hub 27-0:1.0: USB hub found
hub 27-0:1.0: 8 ports detected
vhci_hcd vhci_hcd.9: USB/IP Virtual Host Controller
vhci_hcd vhci_hcd.9: new USB bus registered, assigned bus number 28
usb usb28: We don't know the algorithms for LPM for this host, disabling LP=
M.
usb usb28: New USB device found, idVendor=3D1d6b, idProduct=3D0003, bcdDevi=
ce=3D 6.10
usb usb28: New USB device strings: Mfr=3D3, Product=3D2, SerialNumber=3D1
usb usb28: Product: USB/IP Virtual Host Controller
usb usb28: Manufacturer: Linux 6.10.0-rc7-next-20240709-syzkaller vhci_hcd
usb usb28: SerialNumber: vhci_hcd.9
hub 28-0:1.0: USB hub found
hub 28-0:1.0: 8 ports detected
vhci_hcd vhci_hcd.10: USB/IP Virtual Host Controller
vhci_hcd vhci_hcd.10: new USB bus registered, assigned bus number 29
usb usb29: New USB device found, idVendor=3D1d6b, idProduct=3D0002, bcdDevi=
ce=3D 6.10
usb usb29: New USB device strings: Mfr=3D3, Product=3D2, SerialNumber=3D1
usb usb29: Product: USB/IP Virtual Host Controller
usb usb29: Manufacturer: Linux 6.10.0-rc7-next-20240709-syzkaller vhci_hcd
usb usb29: SerialNumber: vhci_hcd.10
hub 29-0:1.0: USB hub found
hub 29-0:1.0: 8 ports detected
vhci_hcd vhci_hcd.10: USB/IP Virtual Host Controller
vhci_hcd vhci_hcd.10: new USB bus registered, assigned bus number 30
usb usb30: We don't know the algorithms for LPM for this host, disabling LP=
M.
usb usb30: New USB device found, idVendor=3D1d6b, idProduct=3D0003, bcdDevi=
ce=3D 6.10
usb usb30: New USB device strings: Mfr=3D3, Product=3D2, SerialNumber=3D1
usb usb30: Product: USB/IP Virtual Host Controller
usb usb30: Manufacturer: Linux 6.10.0-rc7-next-20240709-syzkaller vhci_hcd
usb usb30: SerialNumber: vhci_hcd.10
hub 30-0:1.0: USB hub found
hub 30-0:1.0: 8 ports detected
vhci_hcd vhci_hcd.11: USB/IP Virtual Host Controller
vhci_hcd vhci_hcd.11: new USB bus registered, assigned bus number 31
usb usb31: New USB device found, idVendor=3D1d6b, idProduct=3D0002, bcdDevi=
ce=3D 6.10
usb usb31: New USB device strings: Mfr=3D3, Product=3D2, SerialNumber=3D1
usb usb31: Product: USB/IP Virtual Host Controller
usb usb31: Manufacturer: Linux 6.10.0-rc7-next-20240709-syzkaller vhci_hcd
usb usb31: SerialNumber: vhci_hcd.11
hub 31-0:1.0: USB hub found
hub 31-0:1.0: 8 ports detected
vhci_hcd vhci_hcd.11: USB/IP Virtual Host Controller
vhci_hcd vhci_hcd.11: new USB bus registered, assigned bus number 32
usb usb32: We don't know the algorithms for LPM for this host, disabling LP=
M.
usb usb32: New USB device found, idVendor=3D1d6b, idProduct=3D0003, bcdDevi=
ce=3D 6.10
usb usb32: New USB device strings: Mfr=3D3, Product=3D2, SerialNumber=3D1
usb usb32: Product: USB/IP Virtual Host Controller
usb usb32: Manufacturer: Linux 6.10.0-rc7-next-20240709-syzkaller vhci_hcd
usb usb32: SerialNumber: vhci_hcd.11
hub 32-0:1.0: USB hub found
hub 32-0:1.0: 8 ports detected
vhci_hcd vhci_hcd.12: USB/IP Virtual Host Controller
vhci_hcd vhci_hcd.12: new USB bus registered, assigned bus number 33
usb usb33: New USB device found, idVendor=3D1d6b, idProduct=3D0002, bcdDevi=
ce=3D 6.10
usb usb33: New USB device strings: Mfr=3D3, Product=3D2, SerialNumber=3D1
usb usb33: Product: USB/IP Virtual Host Controller
usb usb33: Manufacturer: Linux 6.10.0-rc7-next-20240709-syzkaller vhci_hcd
usb usb33: SerialNumber: vhci_hcd.12
hub 33-0:1.0: USB hub found
hub 33-0:1.0: 8 ports detected
vhci_hcd vhci_hcd.12: USB/IP Virtual Host Controller
vhci_hcd vhci_hcd.12: new USB bus registered, assigned bus number 34
usb usb34: We don't know the algorithms for LPM for this host, disabling LP=
M.
usb usb34: New USB device found, idVendor=3D1d6b, idProduct=3D0003, bcdDevi=
ce=3D 6.10
usb usb34: New USB device strings: Mfr=3D3, Product=3D2, SerialNumber=3D1
usb usb34: Product: USB/IP Virtual Host Controller
usb usb34: Manufacturer: Linux 6.10.0-rc7-next-20240709-syzkaller vhci_hcd
usb usb34: SerialNumber: vhci_hcd.12
hub 34-0:1.0: USB hub found
hub 34-0:1.0: 8 ports detected
vhci_hcd vhci_hcd.13: USB/IP Virtual Host Controller
vhci_hcd vhci_hcd.13: new USB bus registered, assigned bus number 35
usb usb35: New USB device found, idVendor=3D1d6b, idProduct=3D0002, bcdDevi=
ce=3D 6.10
usb usb35: New USB device strings: Mfr=3D3, Product=3D2, SerialNumber=3D1
usb usb35: Product: USB/IP Virtual Host Controller
usb usb35: Manufacturer: Linux 6.10.0-rc7-next-20240709-syzkaller vhci_hcd
usb usb35: SerialNumber: vhci_hcd.13
hub 35-0:1.0: USB hub found
hub 35-0:1.0: 8 ports detected
vhci_hcd vhci_hcd.13: USB/IP Virtual Host Controller
vhci_hcd vhci_hcd.13: new USB bus registered, assigned bus number 36
usb usb36: We don't know the algorithms for LPM for this host, disabling LP=
M.
usb usb36: New USB device found, idVendor=3D1d6b, idProduct=3D0003, bcdDevi=
ce=3D 6.10
usb usb36: New USB device strings: Mfr=3D3, Product=3D2, SerialNumber=3D1
usb usb36: Product: USB/IP Virtual Host Controller
usb usb36: Manufacturer: Linux 6.10.0-rc7-next-20240709-syzkaller vhci_hcd
usb usb36: SerialNumber: vhci_hcd.13
hub 36-0:1.0: USB hub found
hub 36-0:1.0: 8 ports detected
vhci_hcd vhci_hcd.14: USB/IP Virtual Host Controller
vhci_hcd vhci_hcd.14: new USB bus registered, assigned bus number 37
usb usb37: New USB device found, idVendor=3D1d6b, idProduct=3D0002, bcdDevi=
ce=3D 6.10
usb usb37: New USB device strings: Mfr=3D3, Product=3D2, SerialNumber=3D1
usb usb37: Product: USB/IP Virtual Host Controller
usb usb37: Manufacturer: Linux 6.10.0-rc7-next-20240709-syzkaller vhci_hcd
usb usb37: SerialNumber: vhci_hcd.14
hub 37-0:1.0: USB hub found
hub 37-0:1.0: 8 ports detected
vhci_hcd vhci_hcd.14: USB/IP Virtual Host Controller
vhci_hcd vhci_hcd.14: new USB bus registered, assigned bus number 38
usb usb38: We don't know the algorithms for LPM for this host, disabling LP=
M.
usb usb38: New USB device found, idVendor=3D1d6b, idProduct=3D0003, bcdDevi=
ce=3D 6.10
usb usb38: New USB device strings: Mfr=3D3, Product=3D2, SerialNumber=3D1
usb usb38: Product: USB/IP Virtual Host Controller
usb usb38: Manufacturer: Linux 6.10.0-rc7-next-20240709-syzkaller vhci_hcd
usb usb38: SerialNumber: vhci_hcd.14
hub 38-0:1.0: USB hub found
hub 38-0:1.0: 8 ports detected
vhci_hcd vhci_hcd.15: USB/IP Virtual Host Controller
vhci_hcd vhci_hcd.15: new USB bus registered, assigned bus number 39
usb usb39: New USB device found, idVendor=3D1d6b, idProduct=3D0002, bcdDevi=
ce=3D 6.10
usb usb39: New USB device strings: Mfr=3D3, Product=3D2, SerialNumber=3D1
usb usb39: Product: USB/IP Virtual Host Controller
usb usb39: Manufacturer: Linux 6.10.0-rc7-next-20240709-syzkaller vhci_hcd
usb usb39: SerialNumber: vhci_hcd.15
hub 39-0:1.0: USB hub found
hub 39-0:1.0: 8 ports detected
vhci_hcd vhci_hcd.15: USB/IP Virtual Host Controller
vhci_hcd vhci_hcd.15: new USB bus registered, assigned bus number 40
usb usb40: We don't know the algorithms for LPM for this host, disabling LP=
M.
usb usb40: New USB device found, idVendor=3D1d6b, idProduct=3D0003, bcdDevi=
ce=3D 6.10
usb usb40: New USB device strings: Mfr=3D3, Product=3D2, SerialNumber=3D1
usb usb40: Product: USB/IP Virtual Host Controller
usb usb40: Manufacturer: Linux 6.10.0-rc7-next-20240709-syzkaller vhci_hcd
usb usb40: SerialNumber: vhci_hcd.15
hub 40-0:1.0: USB hub found
hub 40-0:1.0: 8 ports detected
usbcore: registered new device driver usbip-host
i8042: PNP: PS/2 Controller [PNP0303:KBD,PNP0f13:MOU] at 0x60,0x64 irq 1,12
i8042: Warning: Keylock active
serio: i8042 KBD port at 0x60,0x64 irq 1
serio: i8042 AUX port at 0x60,0x64 irq 12
mousedev: PS/2 mouse device common for all mice
usbcore: registered new interface driver appletouch
usbcore: registered new interface driver bcm5974
usbcore: registered new interface driver synaptics_usb
usbcore: registered new interface driver iforce
usbcore: registered new interface driver xpad
usbcore: registered new interface driver usb_acecad
usbcore: registered new interface driver aiptek
usbcore: registered new interface driver hanwang
usbcore: registered new interface driver kbtab
usbcore: registered new interface driver pegasus_notetaker
usbcore: registered new interface driver usbtouchscreen
usbcore: registered new interface driver sur40
usbcore: registered new interface driver ati_remote2
cm109: Keymap for Komunikate KIP1000 phone loaded
usbcore: registered new interface driver cm109
cm109: CM109 phone driver: 20080805 (C) Alfred E. Heggestad
usbcore: registered new interface driver ims_pcu
usbcore: registered new interface driver keyspan_remote
usbcore: registered new interface driver powermate
usbcore: registered new interface driver yealink
rtc_cmos 00:00: RTC can wake from S4
rtc_cmos 00:00: registered as rtc0
rtc_cmos 00:00: alarms up to one day, 114 bytes nvram
i2c_dev: i2c /dev entries driver
usbcore: registered new interface driver i2c-diolan-u2c
usbcore: registered new interface driver RobotFuzz Open Source InterFace, O=
SIF
usbcore: registered new interface driver i2c-tiny-usb
usbcore: registered new interface driver igorplugusb
usbcore: registered new interface driver iguanair
usbcore: registered new interface driver imon
usbcore: registered new interface driver mceusb
usbcore: registered new interface driver redrat3
usbcore: registered new interface driver streamzap
usbcore: registered new interface driver ttusbir
usbcore: registered new interface driver ati_remote
b2c2-flexcop: B2C2 FlexcopII/II(b)/III digital TV receiver chip loaded succ=
essfully
usbcore: registered new interface driver b2c2_flexcop_usb
usbcore: registered new interface driver dvb_usb_vp7045
usbcore: registered new interface driver dvb_usb_vp702x
usbcore: registered new interface driver dvb_usb_gp8psk
usbcore: registered new interface driver dvb_usb_dtt200u
usbcore: registered new interface driver dvb_usb_a800
usbcore: registered new interface driver dvb_usb_dibusb_mb
usbcore: registered new interface driver dvb_usb_dibusb_mc
usbcore: registered new interface driver dvb_usb_nova_t_usb2
usbcore: registered new interface driver dvb_usb_umt_010
usbcore: registered new interface driver dvb_usb_m920x
usbcore: registered new interface driver dvb_usb_digitv
usbcore: registered new interface driver dvb_usb_cxusb
usbcore: registered new interface driver dvb_usb_ttusb2
usbcore: registered new interface driver dvb_usb_dib0700
usbcore: registered new interface driver opera1
usbcore: registered new interface driver dvb_usb_af9005
failing symbol_get of non-GPLONLY symbol af9005_rc_decode.
failing symbol_get of non-GPLONLY symbol af9005_rc_decode.
failing symbol_get of non-GPLONLY symbol rc_map_af9005_table.
failing symbol_get of non-GPLONLY symbol rc_map_af9005_table.
failing symbol_get of non-GPLONLY symbol rc_map_af9005_table_size.
failing symbol_get of non-GPLONLY symbol rc_map_af9005_table_size.
af9005: af9005_rc_decode function not found, disabling remote
usbcore: registered new interface driver pctv452e
usbcore: registered new interface driver dw2102
usbcore: registered new interface driver dvb_usb_dtv5100
usbcore: registered new interface driver cinergyT2
usbcore: registered new interface driver dvb_usb_az6027
usbcore: registered new interface driver dvb_usb_technisat_usb2
usbcore: registered new interface driver dvb_usb_af9015
usbcore: registered new interface driver dvb_usb_af9035
usbcore: registered new interface driver dvb_usb_anysee
usbcore: registered new interface driver dvb_usb_au6610
usbcore: registered new interface driver dvb_usb_az6007
usbcore: registered new interface driver dvb_usb_ce6230
usbcore: registered new interface driver dvb_usb_ec168
usbcore: registered new interface driver dvb_usb_lmedm04
usbcore: registered new interface driver dvb_usb_gl861
usbcore: registered new interface driver dvb_usb_mxl111sf
usbcore: registered new interface driver dvb_usb_rtl28xxu
usbcore: registered new interface driver dvb_usb_dvbsky
usbcore: registered new interface driver zd1301
usbcore: registered new interface driver s2255
usbcore: registered new interface driver smsusb
usbcore: registered new interface driver ttusb
usbcore: registered new interface driver ttusb-dec
usbcore: registered new interface driver Abilis Systems as10x usb driver
usbcore: registered new interface driver airspy
gspca_main: v2.14.0 registered
usbcore: registered new interface driver benq
usbcore: registered new interface driver conex
usbcore: registered new interface driver cpia1
usbcore: registered new interface driver dtcs033
usbcore: registered new interface driver etoms
usbcore: registered new interface driver finepix
usbcore: registered new interface driver jeilinj
usbcore: registered new interface driver jl2005bcd
usbcore: registered new interface driver kinect
usbcore: registered new interface driver konica
usbcore: registered new interface driver mars
usbcore: registered new interface driver mr97310a
usbcore: registered new interface driver nw80x
usbcore: registered new interface driver ov519
usbcore: registered new interface driver ov534
usbcore: registered new interface driver ov534_9
usbcore: registered new interface driver pac207
usbcore: registered new interface driver gspca_pac7302
usbcore: registered new interface driver pac7311
usbcore: registered new interface driver se401
usbcore: registered new interface driver sn9c2028
usbcore: registered new interface driver gspca_sn9c20x
usbcore: registered new interface driver sonixb
usbcore: registered new interface driver sonixj
usbcore: registered new interface driver spca500
usbcore: registered new interface driver spca501
usbcore: registered new interface driver spca505
usbcore: registered new interface driver spca506
usbcore: registered new interface driver spca508
usbcore: registered new interface driver spca561
usbcore: registered new interface driver spca1528
usbcore: registered new interface driver sq905
usbcore: registered new interface driver sq905c
usbcore: registered new interface driver sq930x
usbcore: registered new interface driver sunplus
usbcore: registered new interface driver stk014
usbcore: registered new interface driver stk1135
usbcore: registered new interface driver stv0680
usbcore: registered new interface driver t613
usbcore: registered new interface driver gspca_topro
usbcore: registered new interface driver touptek
usbcore: registered new interface driver tv8532
usbcore: registered new interface driver vc032x
usbcore: registered new interface driver vicam
usbcore: registered new interface driver xirlink-cit
usbcore: registered new interface driver gspca_zc3xx
usbcore: registered new interface driver ALi m5602
usbcore: registered new interface driver STV06xx
usbcore: registered new interface driver gspca_gl860
usbcore: registered new interface driver hackrf
usbcore: registered new interface driver msi2500
usbcore: registered new interface driver Philips webcam
usbcore: registered new interface driver uvcvideo
au0828: au0828 driver loaded
usbcore: registered new interface driver au0828
usbcore: registered new interface driver cx231xx
usbcore: registered new interface driver em28xx
em28xx: Registered (Em28xx v4l2 Extension) extension
em28xx: Registered (Em28xx Audio Extension) extension
em28xx: Registered (Em28xx dvb Extension) extension
em28xx: Registered (Em28xx Input Extension) extension
usbcore: registered new interface driver go7007
usbcore: registered new interface driver go7007-loader
usbcore: registered new interface driver hdpvr
usbcore: registered new interface driver pvrusb2
pvrusb2: V4L in-tree version:Hauppauge WinTV-PVR-USB2 MPEG2 Encoder/Tuner
pvrusb2: Debug mask is 31 (0x1f)
usbcore: registered new interface driver stk1160
usbcore: registered new interface driver usbtv
dvbdev: DVB: registering new adapter (dvb_vidtv_bridge)
i2c i2c-0: DVB: registering adapter 0 frontend 0 (Dummy demod for DVB-T/T2/=
C/S/S2)...
dvbdev: dvb_create_media_entity: media entity 'Dummy demod for DVB-T/T2/C/S=
/S2' registered.
dvbdev: dvb_create_media_entity: media entity 'dvb-demux' registered.
vidtv vidtv.0: Successfully initialized vidtv!
vicodec vicodec.0: Device 'stateful-encoder' registered as /dev/video0
vicodec vicodec.0: Device 'stateful-decoder' registered as /dev/video1
vicodec vicodec.0: Device 'stateless-decoder' registered as /dev/video2
vim2m vim2m.0: Device registered as /dev/video0
vivid-000: using single planar format API
vivid-000: CEC adapter cec0 registered for HDMI input
vivid-000: V4L2 capture device registered as video7
vivid-000: CEC adapter cec1 registered for HDMI output 0
vivid-000: V4L2 output device registered as video8
vivid-000: V4L2 capture device registered as vbi0, supports raw and sliced =
VBI
vivid-000: V4L2 output device registered as vbi1, supports raw and sliced V=
BI
vivid-000: V4L2 capture device registered as swradio0
vivid-000: V4L2 receiver device registered as radio0
vivid-000: V4L2 transmitter device registered as radio1
vivid-000: V4L2 metadata capture device registered as video9
vivid-000: V4L2 metadata output device registered as video10
vivid-000: V4L2 touch capture device registered as v4l-touch0
vivid-001: using multiplanar format API
vivid-001: CEC adapter cec2 registered for HDMI input
vivid-001: V4L2 capture device registered as video11
vivid-001: CEC adapter cec3 registered for HDMI output 0
vivid-001: V4L2 output device registered as video12
vivid-001: V4L2 capture device registered as vbi2, supports raw and sliced =
VBI
vivid-001: V4L2 output device registered as vbi3, supports raw and sliced V=
BI
vivid-001: V4L2 capture device registered as swradio1
vivid-001: V4L2 receiver device registered as radio2
vivid-001: V4L2 transmitter device registered as radio3
vivid-001: V4L2 metadata capture device registered as video13
vivid-001: V4L2 metadata output device registered as video14
vivid-001: V4L2 touch capture device registered as v4l-touch1
vivid-002: using single planar format API
vivid-002: CEC adapter cec4 registered for HDMI input
vivid-002: V4L2 capture device registered as video15
vivid-002: CEC adapter cec5 registered for HDMI output 0
vivid-002: V4L2 output device registered as video16
vivid-002: V4L2 capture device registered as vbi4, supports raw and sliced =
VBI
vivid-002: V4L2 output device registered as vbi5, supports raw and sliced V=
BI
vivid-002: V4L2 capture device registered as swradio2
vivid-002: V4L2 receiver device registered as radio4
vivid-002: V4L2 transmitter device registered as radio5
vivid-002: V4L2 metadata capture device registered as video17
vivid-002: V4L2 metadata output device registered as video18
vivid-002: V4L2 touch capture device registered as v4l-touch2
vivid-003: using multiplanar format API
vivid-003: CEC adapter cec6 registered for HDMI input
vivid-003: V4L2 capture device registered as video19
vivid-003: CEC adapter cec7 registered for HDMI output 0
vivid-003: V4L2 output device registered as video20
vivid-003: V4L2 capture device registered as vbi6, supports raw and sliced =
VBI
vivid-003: V4L2 output device registered as vbi7, supports raw and sliced V=
BI
vivid-003: V4L2 capture device registered as swradio3
vivid-003: V4L2 receiver device registered as radio6
vivid-003: V4L2 transmitter device registered as radio7
vivid-003: V4L2 metadata capture device registered as video21
vivid-003: V4L2 metadata output device registered as video22
vivid-003: V4L2 touch capture device registered as v4l-touch3
vivid-004: using single planar format API
vivid-004: CEC adapter cec8 registered for HDMI input
vivid-004: V4L2 capture device registered as video23
vivid-004: CEC adapter cec9 registered for HDMI output 0
vivid-004: V4L2 output device registered as video24
vivid-004: V4L2 capture device registered as vbi8, supports raw and sliced =
VBI
vivid-004: V4L2 output device registered as vbi9, supports raw and sliced V=
BI
vivid-004: V4L2 capture device registered as swradio4
vivid-004: V4L2 receiver device registered as radio8
vivid-004: V4L2 transmitter device registered as radio9
vivid-004: V4L2 metadata capture device registered as video25
vivid-004: V4L2 metadata output device registered as video26
vivid-004: V4L2 touch capture device registered as v4l-touch4
vivid-005: using multiplanar format API
vivid-005: CEC adapter cec10 registered for HDMI input
vivid-005: V4L2 capture device registered as video27
vivid-005: CEC adapter cec11 registered for HDMI output 0
vivid-005: V4L2 output device registered as video28
vivid-005: V4L2 capture device registered as vbi10, supports raw and sliced=
 VBI
vivid-005: V4L2 output device registered as vbi11, supports raw and sliced =
VBI
vivid-005: V4L2 capture device registered as swradio5
vivid-005: V4L2 receiver de

---
This report is generated by a bot. It may contain errors.
See https://goo.gl/tpsmEJ for more information about syzbot.
syzbot engineers can be reached at syzkaller@googlegroups.com.

syzbot will keep track of this issue. See:
https://goo.gl/tpsmEJ#status for how to communicate with syzbot.

If the report is already addressed, let syzbot know by replying with:
#syz fix: exact-commit-title

If you want to overwrite report's subsystems, reply with:
#syz set subsystems: new-subsystem
(See the list of subsystem names on the web dashboard)

If the report is a duplicate of another one, reply with:
#syz dup: exact-subject-of-another-report

If you want to undo deduplication, reply with:
#syz undup
