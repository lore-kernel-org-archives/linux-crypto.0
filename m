From: David Gstir <david@sigma-star.at>
Subject: Geode LX AES/RNG driver triggers warning
Date: Sat, 31 Dec 2016 00:58:54 +0100
Message-ID: <A0185338-47A4-42BE-B2D4-F1EB082593E3@sigma-star.at>
Mime-Version: 1.0 (Mac OS X Mail 9.3 \(3124\))
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 8BIT
Cc: linux-kernel@vger.kernel.org, teheo@suse.de,
        prasannatsmkumar@gmail.com, Richard Weinberger <richard@nod.at>
To: linux-geode@lists.infradead.org, linux-crypto@vger.kernel.org
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

Hi!

I recently tested kernel v4.9 on my AMD Geode platform and noticed that its AES hardware driver triggers this warning on initialization:

[    1.265708] ------------[ cut here ]------------
[    1.267932] WARNING: CPU: 0 PID: 1 at drivers/base/dd.c:344 driver_probe_device+0x5d/0x1ad
[    1.272427] CPU: 0 PID: 1 Comm: swapper Not tainted 4.9.0 #2
[    1.277416]  cf82be70 c1153046 cf82be8c c102a98b 00000158 c11ad3ab cf8b9868 c14342b4
[    1.297179]  c14342b4 cf82bea0 c102aa0e 00000009 00000000 00000000 cf82beb8 c11ad3ab
[    1.316912]  00000000 cf8b9868 c14342b4 cf8b989c cf82becc c11ad553 00000000 c14342b4
[    1.336645] Call Trace:
[    1.340044]  [<c1153046>] dump_stack+0x16/0x18
[    1.345423]  [<c102a98b>] __warn+0xa0/0xb7
[    1.349743]  [<c11ad3ab>] ? driver_probe_device+0x5d/0x1ad
[    1.354224]  [<c102aa0e>] warn_slowpath_null+0x11/0x16
[    1.357663]  [<c11ad3ab>] driver_probe_device+0x5d/0x1ad
[    1.361621]  [<c11ad553>] __driver_attach+0x58/0x74
[    1.364282]  [<c11ac1d7>] bus_for_each_dev+0x4b/0x68
[    1.367202]  [<c11ad6c2>] driver_attach+0x14/0x16
[    1.373345]  [<c11ad4fb>] ? driver_probe_device+0x1ad/0x1ad
[    1.378087]  [<c11ac7b4>] bus_add_driver+0xaf/0x181
[    1.380750]  [<c1467007>] ? firmware_map_add_early+0xaa/0xaa
[    1.385746]  [<c11ad9f7>] driver_register+0x6f/0xa4
[    1.388405]  [<c1467007>] ? firmware_map_add_early+0xaa/0xaa
[    1.393414]  [<c117ae35>] __pci_register_driver+0x27/0x2a
[    1.397628]  [<c146701b>] geode_aes_driver_init+0x14/0x16
[    1.401846]  [<c144ab1e>] do_one_initcall+0x7c/0xec
[    1.404516]  [<c103a5a0>] ? parse_args+0x1c3/0x283
[    1.410913]  [<c144ac48>] ? kernel_init_freeable+0xba/0x157
[    1.411646]  [<c144ac68>] kernel_init_freeable+0xda/0x157
[    1.415872]  [<c12f998d>] ? rest_init+0x59/0x59
[    1.421489]  [<c12f9995>] kernel_init+0x8/0xcb
[    1.426856]  [<c12fbb77>] ret_from_fork+0x1b/0x28
[    1.428999] ---[ end trace 24dfe638898c8e1f ]---

I narrowed it down to commit 6e9b5e76882c ("hwrng: geode - Migrate to managed API") which seems to introduce this. It looks to me like some issue between devres, the Geode hwrng and AES drivers which both use the same PCI device.

I'm no expert here, but I curious if this will cause any issues when using the hardware crypto drivers and also what's the best way to get rid of this?

Thanks,
David
