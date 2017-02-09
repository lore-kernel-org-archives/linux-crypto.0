From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: [PATCH] random: Don't overwrite CRNG state in crng_initialize()
Date: Thu, 9 Feb 2017 12:56:00 -0500
Message-ID: <20170209175600.pnyn7e3iypmd5sis@thunk.org>
References: <1486611086-2290-1-git-send-email-alden.tondettar@gmail.com>
 <20170209041931.xgkmysquazppiewx@thunk.org>
 <20170209081322.GA17535@rincewind>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: quoted-printable
Cc: Arnd Bergmann <arnd@arndb.de>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org
To: Alden Tondettar <alden.tondettar@gmail.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from imap.thunk.org ([74.207.234.97]:52282 "EHLO imap.thunk.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1753850AbdBITAZ (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 9 Feb 2017 14:00:25 -0500
Content-Disposition: inline
In-Reply-To: <20170209081322.GA17535@rincewind>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Thu, Feb 09, 2017 at 01:13:22AM -0700, Alden Tondettar wrote:
> And using:
>=20
> $ qemu-system-x86_64 --version
> QEMU emulator version 2.1.2 (Debian 1:2.1+dfsg-12+deb8u6), Copyright (c) =
2003-2008 Fabrice Bellard
> $ qemu-system-x86_64 -nographic -enable-kvm -m 1024M -kernel bzImage -app=
end "root=3D/dev/sda1 loglevel=3D3 console=3DttyS0" hd3

Hmm, I'm not seeing this at *all*.  I assume you must be using Debian
stable?  I'm using Debain Testing, which has much newer version of qemu:

% /usr/bin/kvm --version
QEMU emulator version 2.8.0(Debian 1:2.8+dfsg-2)
Copyright (c) 2003-2016 Fabrice Bellard and the QEMU Project developers

And I'm using:

/usr/bin/kvm -drive file=3D/usr/projects/xfstests-bld/build-32/kvm-xfstests=
/test-appliance/root_fs.img,if=3Dvirtio,snapshot=3Don -vga none -nographic =
-m 1024 --kernel /build/random/arch/x86/boot/bzImage --append "root=3D/dev/=
vda console=3DttyS0,115200"

See below for an excerpt of the log, but basically we don't get the
first call to crng_fast_load until a good 2 seconds into the boot,
when we're doing device probing.

The only thing I think of is that your version of qemu is spewing a
*huge* number of interrupts to the guest kernel, as soon as interrupts
are enabled, and *before* the kernel even starts trying to talk to the
devices.

That's bad, because it's going to be destroying CPU efficiency of the
VM, and even if we add a safety mechanism to prohibit calling
crng_fast_load until after crng_initialize() has been called, it's
likely that you're not getting much entropy from the interrupts,
because qemu must be spewing interrupts as fast as possible, and there
may not be a lot of unpredictability in that circumstance.  So we can
put in some changes to try to mitigate this, but even with your patch,
there might not be a lot of entropy because qemu is clearly spewing
interrupts at line rate.

Hence, I'd call this a qemu BUG, and I'd strongly suggest you look at
fixing it by upgrading qemu.

       	  				- Ted


[    0.029226] mce: CPU supports 10 MCE banks
[    0.030077] Last level iTLB entries: 4KB 0, 2MB 0, 4MB 0
[    0.033339] Last level dTLB entries: 4KB 0, 2MB 0, 4MB 0, 1GB 0
[    0.041436] Freeing SMP alternatives memory: 20K
[    0.043621] ftrace: allocating 34091 entries in 67 pages
[    0.053659] smpboot: Max logical packages: 1
[    0.056696] Enabling APIC mode:  Flat.  Using 1 I/O APICs
[    0.061854] ..TIMER: vector=3D0x30 apic1=3D0 pin1=3D2 apic2=3D-1 pin2=3D=
-1
[    0.063333] smpboot: CPU0: Intel QEMU Virtual CPU version 2.5+ (family: =
0x6, model: 0x6, stepping: 0x3)
[    0.063588] Performance Events: PMU not available due to virtualization,=
 using software events only.
[    0.067555] crng_initialize called
[    0.070107] smp: Bringing up secondary CPUs ...
[    0.072108] smp: Brought up 1 node, 1 CPU
[    0.073351] smpboot: Total of 1 processors activated (4801.01 BogoMIPS)
[    0.077456] devtmpfs: initialized
[    0.079945] clocksource: jiffies: mask: 0xffffffff max_cycles: 0xfffffff=
f, max_idle_ns: 6370867519511994 ns
    ....
[    2.063906] crng: dumping entropy
[    2.065382] crng_fast_load called
[    2.066747] crng_fast_load: 16/64
[    2.066747] crng_fast_load: 16
[    2.073526] tsc: Refined TSC clocksource calibration: 2399.998 MHz
[    2.076219] clocksource: tsc: mask: 0xffffffffffffffff max_cycles: 0x229=
835b7123, max_idle_ns: 440795242976 ns
[    2.134486] ata2.00: ATAPI: QEMU DVD-ROM, 2.5+, max UDMA/100
[    2.144405] ata2.00: configured for MWDMA2
[    2.153349] scsi 1:0:0:0: CD-ROM            QEMU     QEMU DVD-ROM     2.=
5+ PQ: 0 ANSI: 5
[    2.187210] sr 1:0:0:0: [sr0] scsi3-mmc drive: 4x/4x cd/rw xa/form2 tray
[    2.194289] cdrom: Uniform CD-ROM driver Revision: 3.20
[    2.205026] sr 1:0:0:0: Attached scsi generic sg0 type 5
[    2.277461] crng: dumping entropy
[    2.279017] crng_fast_load called
[    2.279017] crng_fast_load: 32/64
[    2.279017] crng_fast_load: 16
[    2.720393] crng: dumping entropy
[    2.723448] crng_fast_load called
[    2.723448] crng_fast_load: 48/64
[    2.723448] crng_fast_load: 16
[    2.744182] input: ImExPS/2 Generic Explorer Mouse as /devices/platform/=
i8042/serio1/input/input3
[    2.760954] EXT4-fs (vda): couldn't mount as ext3 due to feature incompa=
tibilities
[    2.774648] EXT4-fs (vda): mounted filesystem with ordered data mode. Op=
ts: (null)
[    2.779939] VFS: Mounted root (ext4 filesystem) readonly on device 254:0.
[    2.785356] devtmpfs: mounted
[    2.788127] Freeing unused kernel memory: 2404K
[    2.789833] Write protecting the kernel text: 7512k
[    2.791856] Write protecting the kernel read-only data: 3568k
[    2.793918] NX-protecting the kernel data: 8872k
[    2.822964] x86/mm: Checked W+X mappings: FAILED, 96 W+X pages found.
[    2.845398] crng: dumping entropy
[    2.846536] crng_fast_load called
[    2.847460] crng_fast_load: 64/64
[    2.848137] random: fast init done
[    2.848137] crng_fast_load: 16
[    2.914998] systemd[1]: systemd 215 running in system mode. (+PAM +AUDIT=
 +SELINUX +IMA +SYSVINIT +LIBCRYPTSETUP +GCRYPT +ACL +XZ -SECCOMP -APPARMOR)
[    2.920775] systemd[1]: Detected virtualization 'kvm'.
[    2.923019] systemd[1]: Detected architecture 'x86'.

Welcome to =1B[1mDebian GNU/Linux 8 (jessie)=1B[0m!
