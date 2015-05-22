From: Stephan Mueller <smueller@chronox.de>
Subject: alloc of Intel rfc4106 crashes
Date: Fri, 22 May 2015 12:31:52 +0200
Message-ID: <5617832.rX3Zor0TMY@tachyon.chronox.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7Bit
Cc: linux-crypto@vger.kernel.org
To: herbert@gondor.apana.org.au, tadeusz.struk@intel.com
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail.eperm.de ([89.247.134.16]:58180 "EHLO mail.eperm.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1161070AbbEVKbz (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Fri, 22 May 2015 06:31:55 -0400
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Hi Herbert, Tadeusz,

With the current cryptodev-2.6 tree (ex the patches to AEAD from the last 2 days), I get the following oops that is triggered by simply calling

crypto_alloc_aead("rfc4106(gcm(aes))", 0, 0);

Contrary, when calling

crypto_alloc_aead("rfc4106(gcm(aes-generic))", 0, 0);

all works fine.


[   57.461418] BUG: unable to handle kernel NULL pointer dereference at 0000000000000044
[   57.461423] IP: [<ffffffff812b4e23>] crypto_create_tfm+0x13/0xc0
[   57.461428] PGD 0 
[   57.461430] Oops: 0000 [#1] SMP 
[   57.461432] Modules linked in: gcm kcapi_cavs(OE) nf_conntrack_netbios_ns nf_conntrack_broadcast ip6t_rpfilter ip6t_REJECT nf_reject_ipv6 nf_conntrack_ipv6 nf_defrag_ipv6 nf_conntrack_ipv4 nf_defrag_ipv4 xt_conntrack nf_conntrack cfg80211 ebtable_nat ebtable_broute bridge stp llc ebtable_filter ebtables ip6table_mangle ip6table_security ip6table_raw ip6table_filter ip6_tables iptable_mangle iptable_security iptable_raw crct10dif_pclmul crc32_pclmul crc32c_intel ghash_clmulni_intel aesni_intel aes_x86_64 glue_helper ablk_helper microcode joydev virtio_balloon pcspkr serio_raw acpi_cpufreq i2c_piix4 qxl virtio_net virtio_blk drm_kms_helper ttm drm virtio_pci virtio_ring virtio
[   57.461457] CPU: 1 PID: 1975 Comm: cryptomgr_test Tainted: G           OE   4.0.0+ #219
[   57.461459] Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS 1.7.5-20140709_153950- 04/01/2014
[   57.461460] task: ffff88007b40a200 ti: ffff88007b6f0000 task.ti: ffff88007b6f0000
[   57.461461] RIP: 0010:[<ffffffff812b4e23>]  [<ffffffff812b4e23>] crypto_create_tfm+0x13/0xc0
[   57.461465] RSP: 0018:ffff88007b6f3b08  EFLAGS: 00010287
[   57.461466] RAX: ffffffffa0131a00 RBX: ffffffffa0131a00 RCX: 0000000000000003
[   57.461467] RDX: 0000000000000001 RSI: 0000000000000000 RDI: ffffffffa0131a00
[   57.461468] RBP: ffff88007b6f3b28 R08: 00000000000191e0 R09: ffff88007b08acc0
[   57.461470] R10: ffff88007b08acc0 R11: 0000000000000000 R12: ffff88007a5a3338
[   57.461471] R13: ffffffffa0131a00 R14: 0000000000000000 R15: ffffffff8182fe80
[   57.461472] FS:  0000000000000000(0000) GS:ffff88007fd00000(0000) knlGS:0000000000000000
[   57.461473] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[   57.461475] CR2: 0000000000000044 CR3: 0000000001c08000 CR4: 00000000000407e0
[   57.461478] Stack:
[   57.461480]  ffffffffa0131a00 ffff88007a5a3338 ffff88007a5a3200 0000000000000000
[   57.461482]  ffff88007b6f3b58 ffffffff812b5da4 ffff88007b6f3b58 ffffffff812b4e3a
[   57.461484]  ffff88007b08acf8 ffff88007b08acc0 ffff88007b6f3b78 ffffffff812c8361
[   57.461486] Call Trace:
[   57.461492]  [<ffffffff812b5da4>] crypto_spawn_tfm2+0x34/0x60
[   57.461494]  [<ffffffff812b4e3a>] ? crypto_create_tfm+0x2a/0xc0
[   57.461497]  [<ffffffff812c8361>] cryptd_aead_init_tfm+0x21/0x50
[   57.461499]  [<ffffffff812b4e90>] crypto_create_tfm+0x80/0xc0
[   57.461501]  [<ffffffff812b4f4b>] crypto_alloc_tfm+0x7b/0x130
[   57.461503]  [<ffffffff8130bc44>] ? snprintf+0x34/0x40
[   57.461506]  [<ffffffff812b7b89>] crypto_alloc_aead+0x19/0x20
[   57.461508]  [<ffffffff812c7c0e>] cryptd_alloc_aead+0x5e/0xb0
[   57.461512]  [<ffffffff81193b99>] ? __kmalloc+0x259/0x2a0
[   57.461517]  [<ffffffffa0114233>] rfc4106_init+0x33/0x80 [aesni_intel]
[   57.461521]  [<ffffffff812b4e90>] crypto_create_tfm+0x80/0xc0
[   57.461523]  [<ffffffff812b5da4>] crypto_spawn_tfm2+0x34/0x60
[   57.461526]  [<ffffffff81193b99>] ? __kmalloc+0x259/0x2a0
[   57.461528]  [<ffffffff812b78a1>] aead_geniv_init+0x21/0x40
[   57.461530]  [<ffffffff812bb3cb>] seqiv_aead_init+0x1b/0x20
[   57.461532]  [<ffffffff812b4e90>] crypto_create_tfm+0x80/0xc0
[   57.461544]  [<ffffffff812b4f4b>] crypto_alloc_tfm+0x7b/0x130
[   57.461546]  [<ffffffff812b7b89>] crypto_alloc_aead+0x19/0x20
[   57.461548]  [<ffffffff812c2019>] alg_test_aead+0x29/0xc0
[   57.461550]  [<ffffffff812be658>] alg_test+0x198/0x3a0
[   57.461553]  [<ffffffff81682a30>] ? __schedule+0x280/0x910
[   57.461555]  [<ffffffff812bd070>] ? crypto_unregister_pcomp+0x20/0x20
[   57.461556]  [<ffffffff812bd0b5>] cryptomgr_test+0x45/0x50
[   57.461559]  [<ffffffff81070b8b>] kthread+0xdb/0x100
[   57.461561]  [<ffffffff81070ab0>] ? kthread_create_on_node+0x170/0x170
[   57.461564]  [<ffffffff81687092>] ret_from_fork+0x42/0x70
[   57.461565]  [<ffffffff81070ab0>] ? kthread_create_on_node+0x170/0x170
[   57.461566] Code: d2 48 8b 4d c0 48 8b 45 c8 eb aa 48 63 c3 e9 7c ff ff ff 0f 1f 44 00 00 66 66 66 66 90 55 48 89 e5 41 56 41 55 41 54 53 49 89 fd <8b> 5e 44 49 89 f6 ff 56 08 be d0 80 00 00 8d 7c 03 50 e8 06 eb 
[   57.461588] RIP  [<ffffffff812b4e23>] crypto_create_tfm+0x13/0xc0
[   57.461591]  RSP <ffff88007b6f3b08>
[   57.461591] CR2: 0000000000000044
[   57.461594] ---[ end trace 14501b7db9b27df8 ]---
[   58.980163] ------------[ cut here ]------------
[   58.980171] WARNING: CPU: 1 PID: 1944 at crypto/algapi.c:339 crypto_wait_for_test+0x71/0x90()
[   58.980172] Modules linked in: gcm kcapi_cavs(OE) nf_conntrack_netbios_ns nf_conntrack_broadcast ip6t_rpfilter ip6t_REJECT nf_reject_ipv6 nf_conntrack_ipv6 nf_defrag_ipv6 nf_conntrack_ipv4 nf_defrag_ipv4 xt_conntrack nf_conntrack cfg80211 ebtable_nat ebtable_broute bridge stp llc ebtable_filter ebtables ip6table_mangle ip6table_security ip6table_raw ip6table_filter ip6_tables iptable_mangle iptable_security iptable_raw crct10dif_pclmul crc32_pclmul crc32c_intel ghash_clmulni_intel aesni_intel aes_x86_64 glue_helper ablk_helper microcode joydev virtio_balloon pcspkr serio_raw acpi_cpufreq i2c_piix4 qxl virtio_net virtio_blk drm_kms_helper ttm drm virtio_pci virtio_ring virtio
[   58.980200] CPU: 1 PID: 1944 Comm: perl Tainted: G      D    OE   4.0.0+ #219
[   58.980202] Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS 1.7.5-20140709_153950- 04/01/2014
[   58.980203]  ffffffff81a2afaa ffff88007c19fb28 ffffffff81681194 0000000000000007
[   58.980205]  0000000000000000 ffff88007c19fb68 ffffffff810551aa dead000000100100
[   58.980207]  ffff880036630200 0000000000000000 ffffffff81c7ebc0 ffff880036630200
[   58.980209] Call Trace:
[   58.980213]  [<ffffffff81681194>] dump_stack+0x45/0x57
[   58.980216]  [<ffffffff810551aa>] warn_slowpath_common+0x8a/0xc0
[   58.980218]  [<ffffffff8105529a>] warn_slowpath_null+0x1a/0x20
[   58.980220]  [<ffffffff812b6861>] crypto_wait_for_test+0x71/0x90
[   58.980222]  [<ffffffff812b6acb>] crypto_register_instance+0xbb/0x100
[   58.980225]  [<ffffffff812b7a46>] crypto_nivaead_default+0x166/0x1a0
[   58.980227]  [<ffffffff812b7b1a>] crypto_lookup_aead+0x9a/0xf0
[   58.980229]  [<ffffffff812b4f33>] crypto_alloc_tfm+0x63/0x130
[   58.980231]  [<ffffffff812b7b89>] crypto_alloc_aead+0x19/0x20
[   58.980234]  [<ffffffffa02873ec>] kccavs_test_aead+0x4c/0x350 [kcapi_cavs]
[   58.980236]  [<ffffffff810a3f09>] ? vprintk_default+0x29/0x50
[   58.980238]  [<ffffffff8167fe46>] ? printk+0x46/0x48
[   58.980240]  [<ffffffffa0286f17>] kccavs_data_read+0xf7/0x130 [kcapi_cavs]
[   58.980242]  [<ffffffff811a9928>] __vfs_read+0x28/0xc0
[   58.980245]  [<ffffffff81294324>] ? security_file_permission+0x84/0xa0
[   58.980246]  [<ffffffff811a9ff3>] ? rw_verify_area+0x53/0x100
[   58.980248]  [<ffffffff811aa12a>] vfs_read+0x8a/0x140
[   58.980250]  [<ffffffff811aab56>] SyS_read+0x46/0xb0
[   58.980252]  [<ffffffff81686cae>] system_call_fastpath+0x12/0x71
[   58.980254] ---[ end trace 14501b7db9b27df9 ]---
[   58.980258] could not allocate aead handle for rfc4106(gcm(aes)) -4



-- 
Ciao
Stephan
