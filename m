From: Eric Biggers <ebiggers3@gmail.com>
Subject: Re: general protection fault in blkcipher_walk_done (2)
Date: Wed, 3 Jan 2018 11:42:55 -0800
Message-ID: <20180103194255.GA22540@gmail.com>
References: <089e082658c4ad68360561db69d5@google.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: davem@davemloft.net, herbert@gondor.apana.org.au,
        linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
        syzkaller-bugs@googlegroups.com
To: syzbot <syzbot+9da652f470afd0313350@syzkaller.appspotmail.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-it0-f66.google.com ([209.85.214.66]:40445 "EHLO
        mail-it0-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751235AbeACTm7 (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 3 Jan 2018 14:42:59 -0500
Content-Disposition: inline
In-Reply-To: <089e082658c4ad68360561db69d5@google.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Wed, Jan 03, 2018 at 12:58:02AM -0800, syzbot wrote:
> Hello,
> 
> syzkaller hit the following crash on
> 72bca2084a21edda74b802bc076083d5951f67b4
> git://git.kernel.org/pub/scm/linux/kernel/git/davem/net-next.git/master
> compiler: gcc (GCC) 7.1.1 20170620
> .config is attached
> Raw console output is attached.
> C reproducer is attached
> syzkaller reproducer is attached. See https://goo.gl/kgGztJ
> for information about syzkaller reproducers
> 
> 
> IMPORTANT: if you fix the bug, please add the following tag to the commit:
> Reported-by: syzbot+9da652f470afd0313350@syzkaller.appspotmail.com
> It will help syzbot understand when the bug is fixed. See footer for
> details.
> If you forward the report, please keep this part and the footer.
> 
> audit: type=1400 audit(1514967540.602:7): avc:  denied  { map } for
> pid=3499 comm="syzkaller241446" path="/root/syzkaller241446574"
> dev="sda1" ino=16481
> scontext=unconfined_u:system_r:insmod_t:s0-s0:c0.c1023
> tcontext=unconfined_u:object_r:user_home_t:s0 tclass=file
> permissive=1
> kasan: CONFIG_KASAN_INLINE enabled
> kasan: GPF could be caused by NULL-ptr deref or user memory access
> general protection fault: 0000 [#1] SMP KASAN
> Dumping ftrace buffer:
>    (ftrace buffer empty)
> Modules linked in:
> CPU: 1 PID: 3499 Comm: syzkaller241446 Not tainted 4.15.0-rc5+ #173
> Hardware name: Google Google Compute Engine/Google Compute Engine,
> BIOS Google 01/01/2011
> RIP: 0010:scatterwalk_start include/crypto/scatterwalk.h:86 [inline]
> RIP: 0010:scatterwalk_pagedone include/crypto/scatterwalk.h:111 [inline]
> RIP: 0010:scatterwalk_done include/crypto/scatterwalk.h:119 [inline]
> RIP: 0010:blkcipher_walk_done+0x300/0xde0 crypto/blkcipher.c:124
> RSP: 0018:ffff8801c027f340 EFLAGS: 00010202
> RAX: 0000000000000000 RBX: 00000000a74a7bf1 RCX: 0000000000000001
> RDX: dffffc0000000000 RSI: 0000000000000400 RDI: 0000000000000008
> RBP: ffff8801c027f390 R08: 00000000fffff8f8 R09: 0000000000000000
> R10: 0000000000000003 R11: 0000000000000000 R12: ffff8801c027f640
> R13: ffff8801c027f4f0 R14: ffff8801c027f538 R15: ffff8801c027f518
> FS:  0000000001046880(0000) GS:ffff8801db300000(0000) knlGS:0000000000000000
> CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> CR2: 00000000201c9000 CR3: 00000001c09f5005 CR4: 00000000001606e0
> DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
> DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
> Call Trace:
>  glue_ctr_crypt_128bit+0x597/0xc20 arch/x86/crypto/glue_helper.c:289
>  ctr_crypt+0x34/0x40 arch/x86/crypto/serpent_avx2_glue.c:168
>  __ablk_encrypt+0x1d1/0x2d0 crypto/ablk_helper.c:64
>  ablk_encrypt+0x23e/0x2c0 crypto/ablk_helper.c:84
>  skcipher_crypt_ablkcipher crypto/skcipher.c:712 [inline]
>  skcipher_decrypt_ablkcipher+0x312/0x420 crypto/skcipher.c:730
>  crypto_skcipher_decrypt include/crypto/skcipher.h:463 [inline]
>  chacha_decrypt crypto/chacha20poly1305.c:152 [inline]
>  poly_tail_continue+0x42a/0x6b0 crypto/chacha20poly1305.c:167
>  poly_tail+0x40f/0x520 crypto/chacha20poly1305.c:201
>  poly_cipherpad+0x33e/0x470 crypto/chacha20poly1305.c:231
>  poly_cipher+0x303/0x440 crypto/chacha20poly1305.c:262
>  poly_adpad+0x347/0x480 crypto/chacha20poly1305.c:292
>  poly_ad+0x25c/0x300 crypto/chacha20poly1305.c:316
>  poly_setkey+0x2fc/0x3e0 crypto/chacha20poly1305.c:343
>  poly_init+0x16c/0x1d0 crypto/chacha20poly1305.c:366
>  poly_genkey+0x422/0x590 crypto/chacha20poly1305.c:406
>  chachapoly_decrypt+0x73/0x90 crypto/chacha20poly1305.c:488
>  crypto_aead_decrypt include/crypto/aead.h:362 [inline]
>  _aead_recvmsg crypto/algif_aead.c:314 [inline]
>  aead_recvmsg+0x154a/0x1cf0 crypto/algif_aead.c:335
>  sock_recvmsg_nosec net/socket.c:801 [inline]
>  sock_recvmsg+0xc9/0x110 net/socket.c:808
>  ___sys_recvmsg+0x2a4/0x640 net/socket.c:2177
>  __sys_recvmsg+0xe2/0x210 net/socket.c:2222
>  SYSC_recvmsg net/socket.c:2234 [inline]
>  SyS_recvmsg+0x2d/0x50 net/socket.c:2229
>  entry_SYSCALL_64_fastpath+0x23/0x9a
> RIP: 0033:0x43ff19
> RSP: 002b:00007ffce23dfc18 EFLAGS: 00000217 ORIG_RAX: 000000000000002f
> RAX: ffffffffffffffda RBX: ffffffffffffffff RCX: 000000000043ff19
> RDX: 0000000000000000 RSI: 0000000020318fc8 RDI: 0000000000000004
> RBP: 00000000006ca018 R08: 0000000000000000 R09: 0000000000000000
> R10: 0000000000000000 R11: 0000000000000217 R12: 0000000000401880
> R13: 0000000000401910 R14: 0000000000000000 R15: 0000000000000000
> Code: 00 fc ff df 48 c1 e9 03 80 3c 11 00 0f 85 7a 09 00 00 48 8d 78
> 08 48 ba 00 00 00 00 00 fc ff df 49 89 45 20 48 89 f9 48 c1 e9 03
> <0f> b6 14 11 84 d2 74 09 80 fa 03 0f 8e 3e 09 00 00 4c 89 f9 8b
> RIP: scatterwalk_start include/crypto/scatterwalk.h:86 [inline] RSP:
> ffff8801c027f340
> RIP: scatterwalk_pagedone include/crypto/scatterwalk.h:111 [inline]
> RSP: ffff8801c027f340
> RIP: scatterwalk_done include/crypto/scatterwalk.h:119 [inline] RSP:
> ffff8801c027f340
> RIP: blkcipher_walk_done+0x300/0xde0 crypto/blkcipher.c:124 RSP:
> ffff8801c027f340
> ---[ end trace ca435b26a13c286a ]---
> 
> 

Duplicate:

#syz dup: KASAN: wild-memory-access Write in scatterwalk_copychunks

Fix is already in crypto/master ("crypto: chacha20poly1305 - validate the digest size")
