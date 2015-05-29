From: Stephan Mueller <smueller@chronox.de>
Subject: Re: [PATCH 8/10] crypto: aesni - Convert top-level rfc4106 algorithm to new interface
Date: Fri, 29 May 2015 23:39:03 +0200
Message-ID: <3237777.1pZ3XZ1aYV@tachyon.chronox.de>
References: <20150528140311.GA8423@gondor.apana.org.au> <E1YxyTb-0002L9-6g@gondolin.me.apana.org.au>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7Bit
Cc: Linux Crypto Mailing List <linux-crypto@vger.kernel.org>,
	Steffen Klassert <steffen.klassert@secunet.com>,
	Adrian Hoban <adrian.hoban@intel.com>,
	Tadeusz Struk <tadeusz.struk@intel.com>,
	Timothy McCaffrey <timothy.mccaffrey@unisys.com>,
	Tim Chen <tim.c.chen@linux.intel.com>
To: Herbert Xu <herbert@gondor.apana.org.au>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail.eperm.de ([89.247.134.16]:58355 "EHLO mail.eperm.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756266AbbE2VjI (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Fri, 29 May 2015 17:39:08 -0400
In-Reply-To: <E1YxyTb-0002L9-6g@gondolin.me.apana.org.au>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Am Donnerstag, 28. Mai 2015, 22:08:03 schrieb Herbert Xu:

Hi Herbert,

> This patch converts rfc4106-gcm-aesni to the new AEAD interface.
> The low-level interface remains as is for now because we can't
> touch it until cryptd itself is upgraded.

Not sure what goes wrong, but when using algif_aead with the new code, I get:

[   18.895375] BUG: unable to handle kernel paging request at ffffea000402d1c0
[   18.895380] IP: [<ffffffff812b7044>] scatterwalk_done+0x54/0x70
[   18.895384] PGD 7f7da067 PUD 7f7d9067 PMD 0 
[   18.895387] Oops: 0000 [#1] SMP 
[   18.895388] Modules linked in: crypto_user algif_aead af_alg nf_conntrack_netbios_ns nf_conntrack_broadcast ip6t_rpfilter ip6t_REJECT nf_reject_ipv6 nf_conntrack_ipv6 nf_defrag_ipv6 nf_conntrack_ipv4 nf_defrag_ipv4 xt_conntrack nf_conntrack cfg80211 ebtable_nat ebtable_broute bridge stp llc ebtable_filter ebtables ip6table_mangle ip6table_security ip6table_raw ip6table_filter ip6_tables iptable_mangle iptable_security iptable_raw crct10dif_pclmul crc32_pclmul crc32c_intel ghash_clmulni_intel aesni_intel aes_x86_64 glue_helper ablk_helper microcode joydev virtio_balloon pcspkr serio_raw i2c_piix4 acpi_cpufreq virtio_net qxl virtio_blk drm_kms_helper ttm drm virtio_pci virtio_ring virtio
[   18.895411] CPU: 1 PID: 1617 Comm: kcapi Not tainted 4.0.0+ #228
[   18.895413] Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS 1.7.5-20140709_153950- 04/01/2014
[   18.895414] task: ffff88007c6cdd80 ti: ffff88007c378000 task.ti: ffff88007c378000
[   18.895416] RIP: 0010:[<ffffffff812b7044>]  [<ffffffff812b7044>] scatterwalk_done+0x54/0x70
[   18.895418] RSP: 0018:ffff88007c37bc10  EFLAGS: 00010286
[   18.895420] RAX: ffffea000402d1c0 RBX: ffff880000b4800c RCX: ffffea000002d200
[   18.895421] RDX: 0000000000000000 RSI: 0000000000000001 RDI: ffff88007c37bc78
[   18.895422] RBP: ffff88007c37bcb8 R08: 0000000000000000 R09: ffff88007b758208
[   18.895423] R10: ffff880000b4801c R11: 000000000000000c R12: ffff88007b74b000
[   18.895424] R13: ffff88007b75ad30 R14: ffff88007a4f9890 R15: 000000000000000c
[   18.895425] FS:  00007fa99d637700(0000) GS:ffff88007fd00000(0000) knlGS:0000000000000000
[   18.895427] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[   18.895428] CR2: ffffea000402d1c0 CR3: 000000007b9c3000 CR4: 00000000000407e0
[   18.895433] Stack:
[   18.895434]  ffffffffa0111681 ffff88007b74b000 000000000000000c ffff880000b4801c
[   18.895436]  000000000000000c 0000000000000000 ffff88007b74b00c 01ff88000000000c
[   18.895438]  ffff88007a4f98a0 72b5edc49473eb8a 0100000029402a3d ffff88007b758008
[   18.895440] Call Trace:
[   18.895446]  [<ffffffffa0111681>] ? helper_rfc4106_encrypt+0x2a1/0x2b0 [aesni_intel]
[   18.895450]  [<ffffffffa0110145>] rfc4106_encrypt+0x95/0xb0 [aesni_intel]
[   18.895452]  [<ffffffffa029252b>] aead_recvmsg+0x41b/0x4a0 [algif_aead]
[   18.895455]  [<ffffffff81560bd8>] sock_recvmsg+0x38/0x50
[   18.895458]  [<ffffffff81560c78>] sock_read_iter+0x88/0xd0
[   18.895460]  [<ffffffff811a9990>] __vfs_read+0x90/0xc0
[   18.895462]  [<ffffffff811aa12a>] vfs_read+0x8a/0x140
[   18.895464]  [<ffffffff811aab56>] SyS_read+0x46/0xb0
[   18.895467]  [<ffffffff816877ee>] system_call_fastpath+0x12/0x71
[   18.895468] Code: a9 ff 0f 00 00 74 08 85 d2 74 04 c3 0f 1f 00 85 f6 74 1b 49 8b 01 48 83 e0 fc 48 89 c1 41 8d 40 ff c1 e8 0c 48 c1 e0 06 48 01 c8 <48> 8b 00 85 d2 74 d9 55 48 89 e5 e8 ac fc ff ff 5d c3 66 2e 0f 
[   18.895489] RIP  [<ffffffff812b7044>] scatterwalk_done+0x54/0x70
[   18.895492]  RSP <ffff88007c37bc10>
[   18.895493] CR2: ffffea000402d1c0
[   18.895494] ---[ end trace 78452ec206bb3972 ]----- 
Ciao
Stephan
