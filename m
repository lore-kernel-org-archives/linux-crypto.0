From: Julian Wollrath <jwollrath@web.de>
Subject: Oops on 3.10-rc1 related to ssh256_ssse3
Date: Thu, 16 May 2013 15:41:35 +0200
Message-ID: <20130516154135.17e03aca@ilfaris>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
To: linux-crypto@vger.kernel.org
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mout.web.de ([212.227.15.4]:51716 "EHLO mout.web.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751990Ab3EPOEY (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Thu, 16 May 2013 10:04:24 -0400
Received: from ilfaris ([134.76.63.1]) by smtp.web.de (mrweb003) with ESMTPSA
 (Nemesis) id 0MXYTG-1UyL4x3RTS-00W6n1 for <linux-crypto@vger.kernel.org>;
 Thu, 16 May 2013 15:41:37 +0200
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Hello,

I have an encrypted disc (dm-crypt, type LUKS1, ssh256 as hash
algorithm). I have an Intel Core i5 M450 that supports ssse3. Find
below the output from netconsole with the oops. The last warning
appeared when I restart the pc using the magic sysrq key combination
REISUB. I have the same problem with a different laptop with an AMD
E-450 APU.

If you need further information, feel free to ask.


Best regards,
Julian Wollrath

[    3.647071] device-mapper: uevent: version 1.0.3
[    3.647245] device-mapper: ioctl: 4.24.0-ioctl (2013-01-15) initialised: dm-devel@redhat.com
[   11.619603] sha256_ssse3: Using SSSE3 optimized SHA-256 implementation
[   12.131483] BUG: unable to handle kernel paging request at ffff8800bb593000
[   12.131848] IP: [<ffffffffa016b083>] loop0+0x27/0x44 [sha256_ssse3]
[   12.132032] PGD 1a32067 PUD 1a35067 PMD 1a36067 PTE 0
[   12.132427] Oops: 0000 [#1] SMP 
[   12.132670] Modules linked in: sha256_ssse3(+) sha256_generic twofish_generic twofish_x86_64_3way xts lrw gf128mul glue_helper twofish_x86_64 twofish_common cbc dm_crypt dm_mod netconsole sg sr_mod sd_mod cdrom crc_t10dif crc32c_intel microcode ahci libahci ehci_pci ehci_hcd libata scsi_mod r8169 mii usbcore usb_common thermal thermal_sys
[   12.135396] CPU: 3 PID: 276 Comm: cryptomgr_test Not tainted 3.10.0-rc1+ #2
[   12.135559] Hardware name: Dell Inc. Vostro 3500/0NVXFV, BIOS A10 10/25/2010
[   12.135720] task: ffff880037572090 ti: ffff8800b66b6000 task.ti: ffff8800b66b6000
[   12.135836] RIP: 0010:[<ffffffffa016b083>]  [<ffffffffa016b083>] loop0+0x27/0x44 [sha256_ssse3]
[   12.136032] RSP: 0018:ffff8800b66b7af0  EFLAGS: 00010287
[   12.136130] RAX: 00000000a186fc15 RBX: 00000000704bb939 RCX: 00000000d1b791ec
[   12.136232] RDX: 000000001fd2088a RSI: ffff880037a97ee8 RDI: ffff8800bb592fc8
[   12.136334] RBP: ffffffffa016f000 R08: 0000000052a5c3c8 R09: 000000005db427ef
[   12.136439] R10: 00000000b80a833e R11: 0000000029c53567 R12: ffff8800b66b7b08
[   12.136543] R13: 000000003158a213 R14: 00000000c7fc368e R15: 0000000001008012
[   12.136647] FS:  0000000000000000(0000) GS:ffff8800bb180000(0000) knlGS:0000000000000000
[   12.136763] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[   12.136863] CR2: ffff8800bb593000 CR3: 000000000180b000 CR4: 00000000000007e0
[   12.136964] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
[   12.137066] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
[   12.137167] Stack:
[   12.137257]  ffff880108c634c8 ffff8800bb592f88 6033fb357b8c96fd c5e119eaebeb38a3
[   12.137668]  ffff880037a97f08 ffff8800b66b7b80 0000000000000008 0000000000000008
[   12.138077]  ffff880037a97ed0 ffffffffa016dc4e ffff880001496ae5 ffff880037a97ee0
[   12.138484] Call Trace:
[   12.138580]  [<ffffffffa016dc4e>] ? __sha256_ssse3_update+0x5e/0xe0 [sha256_ssse3]
[   12.138701]  [<ffffffffa016df15>] ? sha256_ssse3_final+0x145/0x1ec [sha256_ssse3]
[   12.138825]  [<ffffffff81214362>] ? shash_ahash_finup+0x32/0x80
[   12.138931]  [<ffffffff81217523>] ? test_hash+0x383/0x6b0
[   12.139034]  [<ffffffff8120c8a0>] ? crypto_mod_get+0x10/0x30
[   12.139141]  [<ffffffff811186d6>] ? __kmalloc+0x1c6/0x1f0
[   12.139243]  [<ffffffff8120cdfc>] ? __crypto_alg_lookup+0xac/0xf0
[   12.139344]  [<ffffffff8120ca48>] ? crypto_create_tfm+0x48/0xd0
[   12.139445]  [<ffffffff812146cd>] ? crypto_init_shash_ops_async+0x2d/0xd0
[   12.139548]  [<ffffffff81217893>] ? alg_test_hash+0x43/0xa0
[   12.139650]  [<ffffffff81215b9b>] ? alg_test+0x9b/0x230
[   12.139753]  [<ffffffff81421351>] ? __schedule+0x271/0x650
[   12.139856]  [<ffffffff81214940>] ? cryptomgr_probe+0xb0/0xb0
[   12.139954]  [<ffffffff81214978>] ? cryptomgr_test+0x38/0x40
[   12.140058]  [<ffffffff8105c53f>] ? kthread+0xaf/0xc0
[   12.140219]  [<ffffffff8105c490>] ? kthread_create_on_node+0x110/0x110
[   12.140382]  [<ffffffff814237ac>] ? ret_from_fork+0x7c/0xb0
[   12.140482]  [<ffffffff8105c490>] ? kthread_create_on_node+0x110/0x110
[   12.140585] Code: c4 40 00 00 48 8d 2d 9d 3f 00 00 f3 0f 6f 27 66 41 0f 38 00 e4 f3 0f 6f 6f 10 66 41 0f 38 00 ec f3 0f 6f 77 20 66 41 0f 38 00 f4 <f3> 0f 6f 7f 30 66 41 0f 38 00 fc 48 89 7c 24 08 48 c7 c7 03 00 
[   12.145708] RIP  [<ffffffffa016b083>] loop0+0x27/0x44 [sha256_ssse3]
[   12.145885]  RSP <ffff8800b66b7af0>
[   12.145979] CR2: ffff8800bb593000
[   12.146075] ---[ end trace 0382cf30f3465fd1 ]---
[   12.146173] note: cryptomgr_test[276] exited with preempt_count 1
[   12.146347] BUG: scheduling while atomic: cryptomgr_test/276/0x10000001
[   12.146485] Modules linked in: sha256_ssse3(+) sha256_generic twofish_generic twofish_x86_64_3way xts lrw gf128mul glue_helper twofish_x86_64 twofish_common cbc dm_crypt dm_mod netconsole sg sr_mod sd_mod cdrom crc_t10dif crc32c_intel microcode ahci libahci ehci_pci ehci_hcd libata scsi_mod r8169 mii usbcore usb_common thermal thermal_sys
[   12.150126] CPU: 3 PID: 276 Comm: cryptomgr_test Tainted: G      D      3.10.0-rc1+ #2
[   12.150282] Hardware name: Dell Inc. Vostro 3500/0NVXFV, BIOS A10 10/25/2010
[   12.150428]  ffffffff8141eaf7 ffffffff8141bca7 ffffffff8142167a 0000000000000035
[   12.151034]  0000000000000046 ffff8800b66b7fd8 ffff8800b66b7fd8 ffff8800b66b7fd8
[   12.151610]  ffff880037572090 ffff8800b66b6000 ffff8800375725d0 0000000000000046
[   12.152215] Call Trace:
[   12.152352]  [<ffffffff8141eaf7>] ? dump_stack+0xc/0x15
[   12.152496]  [<ffffffff8141bca7>] ? __schedule_bug+0x3f/0x4c
[   12.152637]  [<ffffffff8142167a>] ? __schedule+0x59a/0x650
[   12.152764]  [<ffffffff81067ccd>] ? __cond_resched+0x1d/0x30
[   12.152898]  [<ffffffff814217a6>] ? _cond_resched+0x26/0x30
[   12.153033]  [<ffffffff81420405>] ? mutex_lock+0x15/0x40
[   12.153169]  [<ffffffff810cfba0>] ? perf_event_exit_task+0x20/0x1e0
[   12.153277]  [<ffffffff8103e24f>] ? do_exit+0x29f/0xa10
[   12.153414]  [<ffffffff81005ca6>] ? oops_end+0x96/0xe0
[   12.153550]  [<ffffffff8141afd9>] ? no_context+0x24c/0x275
[   12.153692]  [<ffffffff8102d51e>] ? __do_page_fault+0x2ee/0x480
[   12.153834]  [<ffffffff810db066>] ? __alloc_pages_nodemask+0x106/0x8f0
[   12.153962]  [<ffffffff81423332>] ? page_fault+0x22/0x30
[   12.154102]  [<ffffffffa016b083>] ? loop0+0x27/0x44 [sha256_ssse3]
[   12.154232]  [<ffffffffa016dc4e>] ? __sha256_ssse3_update+0x5e/0xe0 [sha256_ssse3]
[   12.154380]  [<ffffffffa016df15>] ? sha256_ssse3_final+0x145/0x1ec [sha256_ssse3]
[   12.154532]  [<ffffffff81214362>] ? shash_ahash_finup+0x32/0x80
[   12.154660]  [<ffffffff81217523>] ? test_hash+0x383/0x6b0
[   12.154800]  [<ffffffff8120c8a0>] ? crypto_mod_get+0x10/0x30
[   12.154940]  [<ffffffff811186d6>] ? __kmalloc+0x1c6/0x1f0
[   12.155042]  [<ffffffff8120cdfc>] ? __crypto_alg_lookup+0xac/0xf0
[   12.155183]  [<ffffffff8120ca48>] ? crypto_create_tfm+0x48/0xd0
[   12.155327]  [<ffffffff812146cd>] ? crypto_init_shash_ops_async+0x2d/0xd0
[   12.155466]  [<ffffffff81217893>] ? alg_test_hash+0x43/0xa0
[   12.155609]  [<ffffffff81215b9b>] ? alg_test+0x9b/0x230
[   12.155746]  [<ffffffff81421351>] ? __schedule+0x271/0x650
[   12.155886]  [<ffffffff81214940>] ? cryptomgr_probe+0xb0/0xb0
[   12.156018]  [<ffffffff81214978>] ? cryptomgr_test+0x38/0x40
[   12.156150]  [<ffffffff8105c53f>] ? kthread+0xaf/0xc0
[   12.156275]  [<ffffffff8105c490>] ? kthread_create_on_node+0x110/0x110
[   12.156408]  [<ffffffff814237ac>] ? ret_from_fork+0x7c/0xb0
[   12.156542]  [<ffffffff8105c490>] ? kthread_create_on_node+0x110/0x110
[   16.822251] SysRq : Keyboard mode set to system default
[   18.165412] SysRq : Terminate All Tasks
[   18.165722] ------------[ cut here ]------------
[   18.165825] WARNING: at crypto/algapi.c:329 crypto_wait_for_test+0x55/0x70()
[   18.165846] Modules linked in: sha256_ssse3(+) sha256_generic twofish_generic twofish_x86_64_3way xts lrw gf128mul glue_helper twofish_x86_64 twofish_common cbc dm_crypt dm_mod netconsole sg sr_mod sd_mod cdrom crc_t10dif crc32c_intel microcode ahci libahci ehci_pci ehci_hcd libata scsi_mod r8169 mii usbcore usb_common thermal thermal_sys
[   18.165847] CPU: 3 PID: 273 Comm: modprobe Tainted: G      D W    3.10.0-rc1+ #2
[   18.165849] Hardware name: Dell Inc. Vostro 3500/0NVXFV, BIOS A10 10/25/2010
[   18.165851]  ffffffff8141eaf7 ffffffff810390fa ffff8800b669b400 ffff8800b669b400
[   18.165853]  ffffffffa016f660 ffffffffa016f6b0 0000000000000001 ffffffff8120e4d5
[   18.165854]  0000000000000000 ffffffff8120e634 ffffffffa0046000 0000000000000000
[   18.165855] Call Trace:
[   18.165858]  [<ffffffff8141eaf7>] ? dump_stack+0xc/0x15
[   18.165861]  [<ffffffff810390fa>] ? warn_slowpath_common+0x6a/0xa0
[   18.165863]  [<ffffffff8120e4d5>] ? crypto_wait_for_test+0x55/0x70
[   18.165864]  [<ffffffff8120e634>] ? crypto_register_alg+0x64/0x80
[   18.165867]  [<ffffffffa0046000>] ? 0xffffffffa0045fff
[   18.165868]  [<ffffffff810002fa>] ? do_one_initcall+0x10a/0x160
[   18.165873]  [<ffffffff81090a57>] ? load_module+0x1b37/0x2450
[   18.165875]  [<ffffffff8108ca90>] ? unset_module_init_ro_nx+0x80/0x80
[   18.165877]  [<ffffffff81091430>] ? SyS_init_module+0xc0/0xf0
[   18.165879]  [<ffffffff81423852>] ? system_call_fastpath+0x16/0x1b
[   18.165880] ---[ end trace 0382cf30f3465fd2 ]---
[   18.166140] bio: create slab <bio-1> at 1
[   20.123114] SysRq : Kill All Tasks
[   20.882858] SysRq : Emergency Sync
[   20.883148] Emergency Sync complete
[   22.531845] SysRq : Emergency Remount R/O
[   22.532141] Emergency Remount complete
[   23.386434] SysRq : Resetting
[   23.386663] ACPI MEMORY or I/O RESET_REG.
