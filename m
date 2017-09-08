From: Stephan =?ISO-8859-1?Q?M=FCller?= <smueller@chronox.de>
Subject: Re: [PATCH v2] crypto: add NULL check to scatterwalk_start
Date: Sat, 09 Sep 2017 01:01:11 +0200
Message-ID: <3139392.zccUg1ukXt@positron.chronox.de>
References: <4634467.01PS30tDXi@positron.chronox.de> <20170907060108.GA21208@gondor.apana.org.au> <6172557.07oG34Eo4q@positron.chronox.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: 8BIT
Cc: Herbert Xu <herbert@gondor.apana.org.au>,
        linux-crypto@vger.kernel.org
To: Stephan =?ISO-8859-1?Q?M=FCller?= <smueller@chronox.de>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail.eperm.de ([89.247.134.16]:34678 "EHLO mail.eperm.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1757309AbdIHXBO (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 8 Sep 2017 19:01:14 -0400
In-Reply-To: <6172557.07oG34Eo4q@positron.chronox.de>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Am Samstag, 9. September 2017, 00:20:50 CEST schrieb Stephan Müller:

Hi Herbert,

>  	walk->sg = sg;
> -	walk->offset = sg->offset;
> +	if (sg)
> +		walk->offset = sg->offset;
> +	else
> +		walk->offset = 0;
>  }

After running more fuzzing tests, I now cause other types of spurious crashes. 
Do you have any suggestion on how to handle that issue?

Changing skcipher_walk_skcipher with the following instead of the previously 
suggested patch does not help.

	if (!req->cryptlen)
		return 0;

Or do you see authenc() as a special case that does not support zero length 
plaintext/ciphertext?

[ 5420.521073] ------------[ cut here ]------------
[ 5420.521770] kernel BUG at ./include/linux/scatterlist.h:123!
[ 5420.522736] invalid opcode: 0000 [#1] SMP
[ 5420.523723] Modules linked in: ansi_cprng algif_rng ccm algif_skcipher 
des3_ede_x86_64 des_generic algif_hash crypto_user authenc algif_aead af_alg 
ip6t_rpfilter ip6t_REJECT nf_reject_ipv6 nf_conntrack_ipv6 nf_defrag_ipv6 
nf_conntrack_ipv4 nf_defrag_ipv4 xt_conntrack nf_conntrack ip_set nfnetlink 
ebtable_nat ebtable_broute bridge stp llc ip6table_mangle ip6table_raw 
ip6table_security iptable_mangle iptable_raw iptable_security ebtable_filter 
ebtables ip6table_filter ip6_tables crct10dif_pclmul crc32_pclmul 
virtio_balloon ghash_clmulni_intel pcspkr i2c_piix4 virtio_net sch_fq_codel 
virtio_console virtio_blk crc32c_intel virtio_pci virtio_ring serio_raw virtio
[ 5420.523723] CPU: 3 PID: 20541 Comm: kcapi Not tainted 4.13.0-rc1+ #483
[ 5420.523723] Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS 
1.10.2-1.fc26 04/01/2014
[ 5420.523723] task: ffffa384b9ca6800 task.stack: ffffa512c3a9c000
[ 5420.523723] RIP: 0010:shash_ahash_digest+0xc9/0xd0
[ 5420.523723] RSP: 0018:ffffa512c3a9fc38 EFLAGS: 00010286
[ 5420.523723] RAX: 0000000087654321 RBX: ffffa38475fb44b8 RCX: 
ffffa38475fb4010
[ 5420.523723] RDX: 0000000000000000 RSI: ffffa38475fb4508 RDI: 
0000000075fb4088
[ 5420.523723] RBP: ffffa512c3a9fc58 R08: 00000000000147d6 R09: 
0000000000000007
[ 5420.523723] R10: ffffa512c3a9fcb8 R11: ffffffff8211c14d R12: 
ffffa38475fb4508
[ 5420.523723] R13: ffffa384b7e88188 R14: ffffa384b9b98600 R15: 
ffffa38475fb4010
[ 5420.523723] FS:  00007f7b9f535700(0000) GS:ffffa384bfd80000(0000) knlGS:
0000000000000000
[ 5420.523723] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[ 5420.523723] CR2: 0000000000000000 CR3: 000000007a8ef000 CR4: 
00000000003406e0
[ 5420.523723] Call Trace:
[ 5420.523723]  ? shash_ahash_digest+0xd0/0xd0
[ 5420.523723]  shash_async_digest+0x24/0x30
[ 5420.523723]  crypto_ahash_op+0x29/0x70
[ 5420.523723]  ? printk+0x43/0x4b
[ 5420.523723]  crypto_ahash_digest+0x16/0x20
[ 5420.523723]  crypto_authenc_genicv+0x7b/0xb0 [authenc]
[ 5420.523723]  ? simd_skcipher_encrypt+0xb7/0xc0
[ 5420.523723]  crypto_authenc_encrypt+0xb8/0x180 [authenc]
[ 5420.523723]  aead_recvmsg+0x510/0x5c0 [algif_aead]
[ 5420.523723]  sock_recvmsg+0x3d/0x50
[ 5420.523723]  sock_read_iter+0x86/0xc0
[ 5420.523723]  __vfs_read+0xcb/0x120
[ 5420.523723]  vfs_read+0x8e/0x130
[ 5420.523723]  SyS_read+0x46/0xa0
[ 5420.523723]  do_syscall_64+0x5b/0xc0
[ 5420.523723]  entry_SYSCALL64_slow_path+0x25/0x25
[ 5420.523723] RIP: 0033:0x7f7b9ee43180
[ 5420.523723] RSP: 002b:00007ffd3f975718 EFLAGS: 00000246 ORIG_RAX: 
0000000000000000
[ 5420.523723] RAX: ffffffffffffffda RBX: 0000000000001000 RCX: 
00007f7b9ee43180
[ 5420.523723] RDX: 0000000000001000 RSI: 00007ffd3f976820 RDI: 
0000000000000006
[ 5420.523723] RBP: 0000000000fa701c R08: 0000000000000000 R09: 
0000000000000000
[ 5420.523723] R10: 0000000000000000 R11: 0000000000000246 R12: 
0000000000000000
[ 5420.523723] R13: 00007ffd3f976820 R14: 00007ffd3f976820 R15: 
00007ffd3f975820
[ 5420.523723] Code: 03 35 d4 9a a4 00 48 01 fe 4c 89 e7 e8 71 fa ff ff 41 89 
c5 41 83 ae 80 08 00 00 01 41 f6 44 24 09 02 74 92 e8 c9 c3 41 00 eb 8b <0f> 
0b 0f 0b 0f 1f 00 0f 1f 44 00 00 48 8b 47 20 55 48 8d 77 50 
[ 5420.523723] RIP: shash_ahash_digest+0xc9/0xd0 RSP: ffffa512c3a9fc38



Ciao
Stephan
