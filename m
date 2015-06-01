From: Stephan Mueller <smueller@chronox.de>
Subject: AEAD x86 assembler crash
Date: Mon, 01 Jun 2015 11:12:45 +0200
Message-ID: <5734608.jOsyQWs821@tachyon.chronox.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7Bit
Cc: linux-crypto@vger.kernel.org
To: herbert@gondor.apana.org.au
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail.eperm.de ([89.247.134.16]:58390 "EHLO mail.eperm.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751239AbbFAJMr (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Mon, 1 Jun 2015 05:12:47 -0400
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Hi Herbert,

another crash with all of the latest patches and using gcm_base(ctr(aes-
asm),ghash-generic) using the standard AEAD interface and performing 
encryption.



[  599.243110] ------------[ cut here ]------------
[  599.243113] kernel BUG at crypto/scatterwalk.c:37!
[  599.243115] invalid opcode: 0000 [#1] SMP 
[  599.243118] Modules linked in: ctr ghash_generic gcm ecb cbc kcapi_cavs(OE) 
sha512_ssse3 sha512_generic sha256_ssse3 sha1_ssse3 sha1_generic 
nf_conntrack_netbios_ns nf_conntrack_broadcast ip6t_rpfilter ip6t_REJECT 
nf_reject_ipv6 nf_conntrack_ipv6 nf_defrag_ipv6 nf_conntrack_ipv4 
nf_defrag_ipv4 xt_conntrack nf_conntrack cfg80211 ebtable_nat ebtable_broute 
bridge stp llc ebtable_filter ebtables ip6table_mangle ip6table_security 
ip6table_raw ip6table_filter ip6_tables iptable_mangle iptable_security 
iptable_raw crct10dif_pclmul crc32_pclmul crc32c_intel ghash_clmulni_intel 
aesni_intel aes_x86_64 glue_helper ablk_helper joydev microcode virtio_balloon 
serio_raw pcspkr acpi_cpufreq i2c_piix4 virtio_blk qxl virtio_net 
drm_kms_helper ttm drm virtio_pci virtio_ring virtio [last unloaded: 
kcapi_cavs]
[  599.243163] CPU: 0 PID: 8711 Comm: perl Tainted: G           OE   4.0.0+ 
#228
[  599.243164] Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS 
1.8.1-20150318_183358- 04/01/2014
[  599.243167] task: ffff88007c03dd80 ti: ffff88007c064000 task.ti: 
ffff88007c064000
[  599.243169] RIP: 0010:[<ffffffff812b6cc9>]  [<ffffffff812b6cc9>] 
scatterwalk_start.part.6+0x9/0x10
[  599.243175] RSP: 0018:ffff88007c067bf8  EFLAGS: 00010246
[  599.243176] RAX: ffff88007c067d78 RBX: 0000000000000010 RCX: 
ffffea0000000000
[  599.243178] RDX: 0000000000000000 RSI: ffffea0001e2d800 RDI: 
ffff88007c067c18
[  599.243179] RBP: ffff88007c067bf8 R08: 0000000000000001 R09: 
0000000000000010
[  599.243181] R10: 0000000000000010 R11: ffff88007c067b68 R12: 
0000000000000001
[  599.243182] R13: ffff880000026940 R14: ffff8800363a5100 R15: 
0000000000000010
[  599.243184] FS:  00007fb331f9d700(0000) GS:ffff88007fc00000(0000) 
knlGS:0000000000000000
[  599.243186] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[  599.243188] CR2: 00007f20183b6d74 CR3: 00000000133b7000 CR4: 
00000000000407f0
[  599.243192] Stack:
[  599.243194]  ffff88007c067c78 ffffffff812b712d ffff88007c067d78 
0000000000000010
[  599.243197]  ffff88007c067c28 ffffffff812bdd96 ffff88007c067c48 
ffffffff812bd595
[  599.243200]  ffff880000026940 ffff8800000268e0 ffff88007c067c58 
ffffffff812bd5e6
[  599.243203] Call Trace:
[  599.243207]  [<ffffffff812b712d>] scatterwalk_map_and_copy+0xcd/0xd0
[  599.243210]  [<ffffffff812bdd96>] ? shash_async_final+0x16/0x20
[  599.243212]  [<ffffffff812bd595>] ? crypto_ahash_op+0x25/0x60
[  599.243215]  [<ffffffff812bd5e6>] ? crypto_ahash_final+0x16/0x20
[  599.243218]  [<ffffffffa02c82d8>] gcm_enc_copy_hash+0x28/0x30 [gcm]
[  599.243221]  [<ffffffffa02c935c>] crypto_gcm_encrypt+0xec/0x100 [gcm]
[  599.243224]  [<ffffffffa02c9270>] ? crypto_gcm_init_crypt+0x1e0/0x1e0 [gcm]
[  599.243227]  [<ffffffff812b7b85>] old_crypt+0xc5/0xe0
[  599.243229]  [<ffffffff812b7bdd>] old_encrypt+0x1d/0x20
[  599.243233]  [<ffffffffa02c1183>] kccavs_aead_encdec+0x53/0x80 [kcapi_cavs]
[  599.243235]  [<ffffffffa02c1cca>] kccavs_test_aead+0x23a/0x3e0 [kcapi_cavs]
[  599.243238]  [<ffffffffa02c0f17>] kccavs_data_read+0xf7/0x130 [kcapi_cavs]
[  599.243242]  [<ffffffff811a9928>] __vfs_read+0x28/0xc0
[  599.243244]  [<ffffffff81294324>] ? security_file_permission+0x84/0xa0
[  599.243247]  [<ffffffff811a9ff3>] ? rw_verify_area+0x53/0x100
[  599.243249]  [<ffffffff811aa12a>] vfs_read+0x8a/0x140
[  599.243252]  [<ffffffff811aab56>] SyS_read+0x46/0xb0
[  599.243256]  [<ffffffff816877ee>] system_call_fastpath+0x12/0x71
[  599.243257] Code: dd 7d d7 5b b8 ff ff ff ff 41 5c 41 5d 41 5e 5d c3 90 5b 
44 89 e0 41 5c 41 5d 41 5e 5d c3 0f 1f 40 00 66 66 66 66 90 55 48 89 e5 <0f> 
0b 0f 1f 44 00 00 66 66 66 66 90 48 89 37 8b 46 0c 85 c0 74 
[  599.243286] RIP  [<ffffffff812b6cc9>] scatterwalk_start.part.6+0x9/0x10
[  599.243290]  RSP <ffff88007c067bf8>
[  599.243292] ---[ end trace d4df29cff525b7a7 ]---




-- 
Ciao
Stephan
