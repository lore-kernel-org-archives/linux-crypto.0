From: Anatoly Pugachev <matorola@gmail.com>
Subject: Re: booting sun sparc T5120 with "nosmp" kernel 4.5.4 causes OOPS in
 n2_crypto module
Date: Tue, 24 May 2016 15:08:37 +0300
Message-ID: <CADxRZqy0ftpM+QrEDHoXL7AAW383ae5OWOqR2Ts2sEB+oS8YRQ@mail.gmail.com>
References: <CADxRZqyKYV=Y7P24uj-moc11qhd6To=i2jkXEu36=7vYFTvRqA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Cc: debian-sparc <debian-sparc@lists.debian.org>,
	linux-crypto@vger.kernel.org
To: sparclinux@vger.kernel.org
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-vk0-f66.google.com ([209.85.213.66]:36572 "EHLO
	mail-vk0-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754597AbcEXMIi (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Tue, 24 May 2016 08:08:38 -0400
In-Reply-To: <CADxRZqyKYV=Y7P24uj-moc11qhd6To=i2jkXEu36=7vYFTvRqA@mail.gmail.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

(re-sent in plain text)

Hello!

Tried to boot T5120 with nosmp kernel option, gives OOPS in n2_crypto module:


May 24 13:11:48 nvg5120 kernel: Kernel command line:
root=/dev/mapper/vg1-root ro nosmp
...
May 24 13:11:48 nvg5120 kernel: Loading compiled-in X.509 certificates
May 24 13:11:48 nvg5120 kernel: Kernel unaligned access at TPC[739430]
mpi_read_buffer+0xd0/0x120
May 24 13:11:48 nvg5120 kernel: Loaded X.509 cert 'Debian Project: Ben
Hutchings: 008a018dca80932630'
May 24 13:11:48 nvg5120 kernel: rtc-sun4v rtc-sun4v: setting system
clock to 2016-05-24 10:11:26 UTC (1464084686)
May 24 13:11:48 nvg5120 kernel: aes_sparc64: module verification
failed: signature and/or required key missing - tainting kernel
May 24 13:11:48 nvg5120 kernel: aes_sparc64: sparc64 aes opcodes not available.
...
May 24 13:11:50 nvg5120 kernel: sha256_sparc64: sparc64 sha256 opcode
not available.
May 24 13:11:50 nvg5120 kernel: n2rng.c:v0.2 (July 27, 2011)
May 24 13:11:50 nvg5120 kernel: n2rng f0286a1c: Registered RNG HVAPI
major 2 minor 0
May 24 13:11:50 nvg5120 kernel: n2rng f0286a1c: Found single-unit RNG, units: 1
May 24 13:11:50 nvg5120 kernel: n2rng f0286a1c: Selftest passed on unit 0
May 24 13:11:50 nvg5120 kernel: n2rng f0286a1c: RNG ready
May 24 13:11:50 nvg5120 kernel: des_sparc64: sparc64 des opcodes not available.
May 24 13:11:50 nvg5120 kernel: des_sparc64: sparc64 des opcodes not available.
May 24 13:11:50 nvg5120 kernel: des_sparc64: sparc64 des opcodes not available.
May 24 13:11:50 nvg5120 kernel: sha1_sparc64: sparc64 sha1 opcode not available.
May 24 13:11:50 nvg5120 kernel: des_sparc64: sparc64 des opcodes not available.
May 24 13:11:50 nvg5120 kernel: n2_crypto: n2_crypto.c:v0.2 (July 28, 2011)
May 24 13:11:50 nvg5120 kernel: n2_crypto: Found N2CP at
/virtual-devices@100/n2cp@7
May 24 13:11:50 nvg5120 kernel: n2_crypto: Registered NCS HVAPI version 2.0
May 24 13:11:50 nvg5120 kernel: genirq: Flags mismatch irq 1. 00000000
(cwq-0) vs. 00000000 (cwq-0)
May 24 13:11:50 nvg5120 kernel: ------------[ cut here ]------------
May 24 13:11:50 nvg5120 kernel: WARNING: CPU: 0 PID: 260 at
/build/linux-c06pcb/linux-4.5.4/kernel/irq/manage.c:1449
__free_irq+0xac/0x2a0()
May 24 13:11:50 nvg5120 kernel: Trying to free already-free IRQ 1
May 24 13:11:50 nvg5120 kernel: Modules linked in: n2_crypto(E+)
n2_rng(E+) sha512_sparc64(E+) rng_core(E) des_generic(E) autofs4(E)
ext4(E) ecb(E)
May 24 13:11:50 nvg5120 kernel: CPU: 0 PID: 260 Comm: systemd-udevd
Tainted: G            E   4.5.0-2-sparc64-smp #1 Debian 4.5.4-1
May 24 13:11:50 nvg5120 kernel: Call Trace:
May 24 13:11:50 nvg5120 kernel:  [00000000004669d0]
warn_slowpath_common+0x70/0xc0
May 24 13:11:50 nvg5120 kernel:  [0000000000466a50] warn_slowpath_fmt+0x30/0x40
May 24 13:11:50 nvg5120 kernel:  [00000000004bdd0c] __free_irq+0xac/0x2a0
May 24 13:11:50 nvg5120 kernel:  [00000000004bdfa0] free_irq+0x40/0x80
May 24 13:11:50 nvg5120 kernel:  [0000000010aae24c]
spu_list_destroy+0xec/0x100 [n2_crypto]
May 24 13:11:50 nvg5120 kernel:  [0000000010aafc98]
spu_mdesc_scan+0x298/0x4a0 [n2_crypto]
May 24 13:11:50 nvg5120 kernel:  [0000000010ab0204]
n2_crypto_probe+0x1a4/0x680 [n2_crypto]
May 24 13:11:50 nvg5120 kernel:  [00000000007c95f4] platform_drv_probe+0x34/0xc0
May 24 13:11:50 nvg5120 kernel:  [00000000007c708c]
driver_probe_device+0x24c/0x460
May 24 13:11:50 nvg5120 kernel:  [00000000007c7328] __driver_attach+0x88/0xa0
May 24 13:11:50 nvg5120 kernel:  [00000000007c497c] bus_for_each_dev+0x5c/0xa0
May 24 13:11:50 nvg5120 kernel:  [00000000007c669c] driver_attach+0x1c/0x40
May 24 13:11:50 nvg5120 kernel:  [00000000007c60b0] bus_add_driver+0x1f0/0x2a0
May 24 13:11:50 nvg5120 kernel:  [00000000007c7db4] driver_register+0x74/0x120
May 24 13:11:50 nvg5120 kernel:  [00000000007c97c4]
__platform_register_drivers+0x64/0x160
May 24 13:11:50 nvg5120 kernel:  [0000000010ab6014] n2_init+0x14/0x24
[n2_crypto]
May 24 13:11:50 nvg5120 kernel: ---[ end trace 7aa1f0163177edff ]---
May 24 13:11:50 nvg5120 kernel: camellia_sparc64: sparc64 camellia opcodes
not available.


Full boot logs, "nosmp" and usual (smp) are in [1].

1. https://bugzilla.kernel.org/show_bug.cgi?id=118831
