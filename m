From: Stephan =?ISO-8859-1?Q?M=FCller?= <smueller@chronox.de>
Subject: AES-NI: BUG in gcmaes_decrypt
Date: Tue, 16 Jan 2018 22:13:29 +0100
Message-ID: <2389839.8lvrU0lKhj@positron.chronox.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7Bit
To: linux-crypto@vger.kernel.org
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail.eperm.de ([89.247.134.16]:58360 "EHLO mail.eperm.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1750750AbeAPVNc (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 16 Jan 2018 16:13:32 -0500
Received: from positron.chronox.de (mail.eperm.de [89.247.134.16])
        by mail.eperm.de (Postfix) with ESMTPA id 12DD01816072
        for <linux-crypto@vger.kernel.org>; Tue, 16 Jan 2018 22:13:30 +0100 (CET)
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Hi,

When compiling the current cryptodev-2.6 tree with CONFIG_DEBUG_SG and 
invoking a gcm(aes) decrypt operation with an empty ciphertext and an empty 
AAD, I get the following BUG:

[   79.294243] ------------[ cut here ]------------
[   79.294903] kernel BUG at ./include/linux/scatterlist.h:130!
[   79.295808] invalid opcode: 0000 [#1] SMP
[   79.296689] Modules linked in: ansi_cprng algif_rng ccm algif_aead 
algif_skcipher crypto_user des3_ede_x86_64 des_generic algif_hash af_alg 
ip6t_rpfilter ip6t_REJECT nf_reject_ipv6 nf_conntrack_ipv6 nf_defrag_ipv6 
nf_conntrack_ipv4 nf_defrag_ipv4 xt_conntrack nf_conntrack ip_set nfnetlink 
ebtable_nat ebtable_broute bridge stp llc ip6table_mangle ip6table_raw 
ip6table_security iptable_mangle iptable_raw iptable_security ebtable_filter 
ebtables ip6table_filter ip6_tables crct10dif_pclmul crc32_pclmul 
ghash_clmulni_intel pcspkr virtio_net virtio_balloon i2c_piix4 sch_fq_codel 
virtio_blk virtio_console crc32c_intel serio_raw virtio_pci virtio_ring virtio
[   79.304600] CPU: 3 PID: 13182 Comm: lt-kcapi Not tainted 4.15.0-rc3+ #584
[   79.305395] Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS 
1.10.2-2.fc27 04/01/2014
[   79.306514] RIP: 0010:gcmaes_decrypt.constprop.11+0x29f/0x310
[   79.307259] RSP: 0018:ffffa9ae026c3ca8 EFLAGS: 00010212
[   79.307948] RAX: ffffcc2a41ee1242 RBX: ffffa192b8cbfa00 RCX: 
0000000087654321
[   79.308853] RDX: ffffa192b8c91410 RSI: 000000005a5e678f RDI: 
0000000000000000
[   79.309749] RBP: 0000000000000010 R08: ffffa192b8c91c60 R09: 
ffffa192b8cbfa00
[   79.310652] R10: ffffa9ae026c3d70 R11: 0000000000000000 R12: 
ffffa192b89a7060
[   79.311552] R13: 0000000000000010 R14: ffffa192b8c91798 R15: 
0000000000000010
[   79.312446] FS:  00007fe6275f8700(0000) GS:ffffa192bfd80000(0000) knlGS:
0000000000000000
[   79.313643] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[   79.314120] CR2: 00007ffeb41ee000 CR3: 0000000078244006 CR4: 
00000000003606e0
[   79.315251] Call Trace:
[   79.315515]  ? sock_kfree_s+0x19/0x30
[   79.315845]  ? generic_gcmaes_decrypt+0x50/0x60
[   79.316251]  ? aead_recvmsg+0x5e1/0x670 [algif_aead]
[   79.316704]  ? aead_recvmsg+0x5e1/0x670 [algif_aead]
[   79.317144]  ? sock_read_iter+0x89/0xd0
[   79.317499]  ? __vfs_read+0xd1/0x120
[   79.317834]  ? vfs_read+0x89/0x130
[   79.318149]  ? SyS_read+0x42/0x90
[   79.318619]  ? do_syscall_64+0x5c/0x120
[   79.319501]  ? entry_SYSCALL64_slow_path+0x25/0x25


The BUG is triggered by the sg_page() invocation in gcmaes_decrypt which 
checks:

	BUG_ON(sg->sg_magic != SG_MAGIC);


The issue can be triggered with libkcapi using the following test:

kcapi   -x 2   -c "gcm(aes)" -i 0d92aa861746b324f20ee6b7 -k 
f4a6a5e5f2066f6dd9ec6fc5169c29043560ef595c9e81e76f42d29212cc581c -a "" -t 
"5f24c68cbe6f32c29652442bf5d483ad" -q ""

Ciao
Stephan
