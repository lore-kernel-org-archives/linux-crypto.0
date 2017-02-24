From: Stephan =?ISO-8859-1?Q?M=FCller?= <smueller@chronox.de>
Subject: authenc: crash if key is not set
Date: Fri, 24 Feb 2017 21:24:34 +0100
Message-ID: <13796038.esLDiIrSPd@positron.chronox.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7Bit
Cc: linux-crypto@vger.kernel.org
To: herbert@gondor.apana.org.au
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail.eperm.de ([89.247.134.16]:59788 "EHLO mail.eperm.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751232AbdBXUYo (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 24 Feb 2017 15:24:44 -0500
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Hi Herbert,

I am working on fuzzing the AF_ALG interface.

The fuzzer reliably triggered the following type of bug when I use 
authenc(hmac(sha256),cbc(aes)) or other types of authenc() but do not call 
setkey.

Note, it works with gcm or ccm.

Is that bug similar in nature as the algif_skcipher and algif_hash bugs that 
were fixed with the *nokey functions?

[ 3417.581670] BUG: unable to handle kernel NULL pointer dereference at 
0000000000000008
[ 3417.582004] IP: skcipher_walk_skcipher+0x18/0xc0
[ 3417.582004] PGD 7a487067 
[ 3417.582004] PUD 7b1a5067 
[ 3417.582004] PMD 0 

[ 3417.582004] Oops: 0000 [#13] SMP
[ 3417.582004] Modules linked in: algif_aead authenc ansi_cprng algif_rng ccm 
gcm crypto_user des3_ede_x86_64 des_generic algif_hash algif_akcipher(E) 
algif_skcipher(E) af_alg ip6t_rpfilter ip6t_REJECT nf_reject_ipv6 
nf_conntrack_ipv6 nf_defrag_ipv6 nf_conntrack_ipv4 nf_defrag_ipv4 xt_conntrack 
nf_conntrack ip_set nfnetlink ebtable_broute bridge stp llc ebtable_nat 
ip6table_raw ip6table_security ip6table_mangle iptable_raw iptable_security 
iptable_mangle ebtable_filter ebtables ip6table_filter ip6_tables 
crct10dif_pclmul crc32_pclmul ghash_clmulni_intel pcspkr i2c_piix4 
virtio_balloon virtio_net acpi_cpufreq sch_fq_codel virtio_blk virtio_console 
crc32c_intel serio_raw virtio_pci virtio_ring virtio [last unloaded: 
algif_aead]
[ 3417.582004] CPU: 0 PID: 13092 Comm: kcapi Tainted: G      D     E   4.10.0-
rc3+ #371
[ 3417.582004] Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS 
1.9.3-1.fc25 04/01/2014
[ 3417.582004] task: ffff931bfbd55940 task.stack: ffffa53e008ec000
[ 3417.582004] RIP: 0010:skcipher_walk_skcipher+0x18/0xc0
[ 3417.582004] RSP: 0018:ffffa53e008efb60 EFLAGS: 00010246
[ 3417.582004] RAX: 0000000000000000 RBX: ffffa53e008efba0 RCX: 
0000000000000000
[ 3417.582004] RDX: ffff931bfa70f828 RSI: ffff931bfb0b7c28 RDI: 
ffffa53e008efba0
[ 3417.582004] RBP: ffffa53e008efb80 R08: 0000000000000000 R09: 
0000000000000000
[ 3417.582004] R10: ffffffffab809f80 R11: ffff931bfb0b7ca8 R12: 
0000000000000001
[ 3417.582004] R13: ffff931bfb0b7c28 R14: ffff931bfb2a0548 R15: 
0000000000000000
[ 3417.582004] FS:  00007f0f47460700(0000) GS:ffff931bffc00000(0000) knlGS:
0000000000000000
[ 3417.582004] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[ 3417.582004] CR2: 0000000000000008 CR3: 000000007b113000 CR4: 
00000000003406f0
[ 3417.582004] Call Trace:
[ 3417.582004]  ? skcipher_walk_virt+0x1e/0x40
[ 3417.582004]  cbc_decrypt+0x31/0xa0
[ 3417.582004]  ? sha1_avx2_finup+0x15/0x20
[ 3417.582004]  ? crypto_shash_finup+0x1f/0x30
[ 3417.582004]  ? hmac_finup+0x9b/0xb0
[ 3417.582004]  ? shash_ahash_finup+0x43/0x90
[ 3417.582004]  ? shash_ahash_digest+0xf0/0xf0
[ 3417.582004]  simd_skcipher_decrypt+0xb7/0xc0
[ 3417.582004]  crypto_authenc_decrypt_tail.isra.3+0xf0/0x100 [authenc]
[ 3417.582004]  crypto_authenc_decrypt+0x87/0x90 [authenc]
[ 3417.582004]  aead_recvmsg+0x633/0x650 [algif_aead]
[ 3417.582004]  ? selinux_socket_recvmsg+0x23/0x30
[ 3417.582004]  ? security_socket_recvmsg+0x4b/0x70
[ 3417.582004]  sock_recvmsg+0x3d/0x50
[ 3417.582004]  sock_read_iter+0x86/0xc0
[ 3417.582004]  __vfs_read+0xbf/0x110
[ 3417.582004]  vfs_read+0x96/0x130
[ 3417.582004]  SyS_read+0x46/0xa0
[ 3417.582004]  entry_SYSCALL_64_fastpath+0x1e/0xad
[ 3417.582004] RIP: 0033:0x7f0f46f77bd0
[ 3417.582004] RSP: 002b:00007ffed6bbd278 EFLAGS: 00000246 ORIG_RAX: 
0000000000000000
[ 3417.582004] RAX: ffffffffffffffda RBX: 0000000000000006 RCX: 
00007f0f46f77bd0
[ 3417.582004] RDX: 0000000000001000 RSI: 00007ffed6bbe330 RDI: 
0000000000000006
[ 3417.582004] RBP: 00007ffed6bbbfa0 R08: 00000000025c6530 R09: 
0000000000000000
[ 3417.582004] R10: 0000000000000001 R11: 0000000000000246 R12: 
00007ffed6bbc1f8
[ 3417.582004] R13: 00007ffed6bbbf10 R14: 00007ffed6bbf4d0 R15: 
0000000000000000
[ 3417.582004] Code: ff ff ff e9 16 ff ff ff 90 66 2e 0f 1f 84 00 00 00 00 00 
0f 1f 44 00 00 48 8b 46 10 48 8b 56 40 55 8b 8f 84 00 00 00 48 89 47 20 <8b> 
40 08 48 89 e5 83 e1 ef 89 47 28 48 8b 46 18 48 89 47 38 8b 
[ 3417.582004] RIP: skcipher_walk_skcipher+0x18/0xc0 RSP: ffffa53e008efb60
[ 3417.582004] CR2: 0000000000000008
[ 3417.582004] ---[ end trace 2a142ea12ab5141a ]---


Ciao
Stephan
