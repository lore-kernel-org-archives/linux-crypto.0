From: Eric Biggers <ebiggers3@gmail.com>
Subject: Re: KASAN: use-after-free Read in aead_recvmsg
Date: Fri, 1 Dec 2017 11:11:08 -0800
Message-ID: <20171201191108.GC142348@gmail.com>
References: <001a113ebb5ece8a7a055efb7676@google.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: davem@davemloft.net, herbert@gondor.apana.org.au,
        linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
        syzkaller-bugs@googlegroups.com
To: syzbot
        <bot+6fbc13c3b1ed2105e7a2e516be43d6a0624a59c0@syzkaller.appspotmail.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-io0-f193.google.com ([209.85.223.193]:39558 "EHLO
        mail-io0-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750965AbdLATLM (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 1 Dec 2017 14:11:12 -0500
Content-Disposition: inline
In-Reply-To: <001a113ebb5ece8a7a055efb7676@google.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Mon, Nov 27, 2017 at 10:56:46AM -0800, syzbot wrote:
> ==================================================================
> BUG: KASAN: use-after-free in skcipher_request_set_tfm
> include/crypto/skcipher.h:499 [inline]
> BUG: KASAN: use-after-free in crypto_aead_copy_sgl
> crypto/algif_aead.c:85 [inline]
> BUG: KASAN: use-after-free in _aead_recvmsg crypto/algif_aead.c:210 [inline]
> BUG: KASAN: use-after-free in aead_recvmsg+0x1552/0x1970
> crypto/algif_aead.c:313
> Read of size 4 at addr ffff8801c7194e5c by task syzkaller438416/3340
> 
> CPU: 0 PID: 3340 Comm: syzkaller438416 Not tainted 4.14.0-next-20171124+ #51
> Hardware name: Google Google Compute Engine/Google Compute Engine,
> BIOS Google 01/01/2011
> Call Trace:
>  __dump_stack lib/dump_stack.c:17 [inline]
>  dump_stack+0x194/0x257 lib/dump_stack.c:53
>  print_address_description+0x73/0x250 mm/kasan/report.c:252
>  kasan_report_error mm/kasan/report.c:351 [inline]
>  kasan_report+0x25b/0x340 mm/kasan/report.c:409
>  __asan_report_load4_noabort+0x14/0x20 mm/kasan/report.c:429
>  skcipher_request_set_tfm include/crypto/skcipher.h:499 [inline]
>  crypto_aead_copy_sgl crypto/algif_aead.c:85 [inline]
>  _aead_recvmsg crypto/algif_aead.c:210 [inline]
>  aead_recvmsg+0x1552/0x1970 crypto/algif_aead.c:313
>  sock_recvmsg_nosec net/socket.c:805 [inline]
>  sock_recvmsg+0xc9/0x110 net/socket.c:812
>  ___sys_recvmsg+0x29b/0x630 net/socket.c:2207
>  __sys_recvmsg+0xe2/0x210 net/socket.c:2252
>  SYSC_recvmsg net/socket.c:2264 [inline]
>  SyS_recvmsg+0x2d/0x50 net/socket.c:2259
>  entry_SYSCALL_64_fastpath+0x1f/0x96

#syz fix: crypto: algif_aead - fix reference counting of null skcipher
