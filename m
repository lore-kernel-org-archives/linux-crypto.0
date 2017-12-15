From: Eric Biggers <ebiggers3@gmail.com>
Subject: Re: general protection fault in ___cache_free
Date: Fri, 15 Dec 2017 09:21:48 -0800
Message-ID: <20171215172148.GA629@zzz.localdomain>
References: <f403045fbfa060791f05605c6a5e@google.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: davem@davemloft.net, herbert@gondor.apana.org.au,
        linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
        syzkaller-bugs@googlegroups.com
To: syzbot
        <bot+1cfe6406582d72de07f78837946d111c2aea6936@syzkaller.appspotmail.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-pg0-f49.google.com ([74.125.83.49]:43947 "EHLO
        mail-pg0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1755449AbdLORVv (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 15 Dec 2017 12:21:51 -0500
Content-Disposition: inline
In-Reply-To: <f403045fbfa060791f05605c6a5e@google.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Fri, Dec 15, 2017 at 12:02:01AM -0800, syzbot wrote:
> Call Trace:
>  __cache_free mm/slab.c:3494 [inline]
>  kfree+0x1a3/0x250 mm/slab.c:3806
>  blkcipher_walk_done+0x72b/0xde0 crypto/blkcipher.c:139
>  encrypt+0x20e/0x540 arch/x86/crypto/salsa20_glue.c:79
>  skcipher_crypt_blkcipher crypto/skcipher.c:622 [inline]
>  skcipher_decrypt_blkcipher+0x213/0x310 crypto/skcipher.c:640
>  crypto_skcipher_decrypt include/crypto/skcipher.h:463 [inline]
>  _skcipher_recvmsg crypto/algif_skcipher.c:144 [inline]
>  skcipher_recvmsg+0xa54/0xf20 crypto/algif_skcipher.c:165
>  sock_recvmsg_nosec net/socket.c:809 [inline]
>  sock_recvmsg+0xc9/0x110 net/socket.c:816
>  ___sys_recvmsg+0x29b/0x630 net/socket.c:2185
>  __sys_recvmsg+0xe2/0x210 net/socket.c:2230
>  SYSC_recvmsg net/socket.c:2242 [inline]
>  SyS_recvmsg+0x2d/0x50 net/socket.c:2237
>  entry_SYSCALL_64_fastpath+0x1f/0x96

Already fixed:

#syz fix: crypto: salsa20 - fix blkcipher_walk API usage
