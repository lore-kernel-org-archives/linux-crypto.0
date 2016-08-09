From: Tapas Sarangi <TSarangi@trustwave.com>
Subject: RSA key size not allowed in FIPS
Date: Tue, 9 Aug 2016 14:10:33 +0000
Message-ID: <D3CF4E8C.2883%tsarangi@trustwave.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: 8BIT
To: "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from seg-node-chi-03.trustwave.com ([204.13.200.31]:19352 "EHLO
	seg-node-chi-03.trustwave.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752711AbcHIOZi convert rfc822-to-8bit
	(ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Tue, 9 Aug 2016 10:25:38 -0400
Content-Language: en-US
Content-ID: <61BEB30B992E6245B34181F0D82B60F5@namprd07.prod.outlook.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Hello,

I am using vanilla kernel-4.7 source. It crashes with the following when
booted with ³fips=1 boot=/dev/sda1² option at the kernel command line
argument.

[    0.642411] RSA: key size not allowed in FIPS mode
[    0.643099] Problem loading in-kernel X.509 certificate (-22)
[    0.800524] BUG: unable to handle kernel NULL pointer dereference at
0000000000000068
[    0.803075] IP: [<ffffffff811e1ad7>] kernfs_find_ns+0x17/0xf0
[    0.804111] PGD 0
[    0.804111] Oops: 0000 [#1] SMP
[    0.804111] Modules linked in:
[    0.804111] CPU: 0 PID: 6 Comm: kworker/u2:0 Tainted: G        W
4.7.0-1.tos2_5 #1
[    0.804111] Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS
1.8.2-20150714_191134- 04/01/2014
[    0.804111] Workqueue: events_unbound async_run_entry_fn
[    0.804111] task: ffff88003e214100 ti: ffff88003e264000 task.ti:
ffff88003e264000
[    0.804111] RIP: 0010:[<ffffffff811e1ad7>]  [<ffffffff811e1ad7>]
kernfs_find_ns+0x17/0xf0
[    0.804111] RSP: 0018:ffff88003e267868  EFLAGS: 00010282
[    0.804111] RAX: ffff88003e214100 RBX: 0000000000000000 RCX:
ffff88003e264008
[    0.804111] RDX: 0000000000000000 RSI: ffffffff8166bb80 RDI:
0000000000000000
[    0.804111] RBP: ffff88003e267898 R08: 0000000000000000 R09:
ffffffff8166bb80
[    0.804111] R10: 00000000000c6000 R11: 0000000000000001 R12:
ffffffff8166bb80
[    0.804111] R13: 0000000000000000 R14: ffffffff8173048a R15:
ffff88003b17b1a0
[    0.804111] FS:  0000000000000000(0000) GS:ffff88003fc00000(0000)
knlGS:0000000000000000
[    0.804111] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[    0.804111] CR2: 0000000000000068 CR3: 0000000001806000 CR4:
00000000000406f0
[    0.804111] Stack:
[    0.804111]  ffff88003e267898 0000000000000000 ffff880000000001
0000000000000000
[    0.804111]  ffffffff8166bb80 0000000000000000 ffff88003e2678c8
ffffffff811e1e77
[    0.804111]  0000000000000096 ffffffff81873d40 ffff88003b152828
0000000000000005
[    0.804111] Call Trace:
[    0.804111]  [<ffffffff811e1e77>] kernfs_find_and_get_ns+0x37/0x60
[    0.804111]  [<ffffffff811e5c58>] sysfs_unmerge_group+0x18/0x60
[    0.804111]  [<ffffffff8139c187>] dpm_sysfs_remove+0x27/0x60



Thanks for any suggestion.
-Tapas
Ps : I could not send any attachment, is it possible to send attachment to
this mailing list ?




________________________________

This transmission may contain information that is privileged, confidential, and/or exempt from disclosure under applicable law. If you are not the intended recipient, you are hereby notified that any disclosure, copying, distribution, or use of the information contained herein (including any reliance thereon) is strictly prohibited. If you received this transmission in error, please immediately contact the sender and destroy the material in its entirety, whether in electronic or hard copy format.
