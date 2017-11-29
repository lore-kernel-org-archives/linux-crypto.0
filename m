From: Eric Biggers <ebiggers3@gmail.com>
Subject: Re: KASAN: stack-out-of-bounds Read in crypto_chacha20_crypt
Date: Wed, 29 Nov 2017 00:58:16 -0800
Message-ID: <20171129085816.GB20992@zzz.localdomain>
References: <001a1145e854ca4c89055f1afb23@google.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: davem@davemloft.net, herbert@gondor.apana.org.au,
        linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
        syzkaller-bugs@googlegroups.com
To: syzbot
        <bot+f219f03f68409928407df625142fb818c077d0ae@syzkaller.appspotmail.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-pg0-f68.google.com ([74.125.83.68]:39735 "EHLO
        mail-pg0-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753676AbdK2I6T (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 29 Nov 2017 03:58:19 -0500
Content-Disposition: inline
In-Reply-To: <001a1145e854ca4c89055f1afb23@google.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Wed, Nov 29, 2017 at 12:33:01AM -0800, syzbot wrote:
> Hello,
> 
> syzkaller hit the following crash on
> 1ea8d039f9edcfefb20d8ddfe136930f6e551529
> git://git.cmpxchg.org/linux-mmots.git/master
> compiler: gcc (GCC) 7.1.1 20170620
> .config is attached
> Raw console output is attached.
> 
> Unfortunately, I don't have any reproducer for this bug yet.
> 
> 
> device gre0 entered promiscuous mode
> ==================================================================
> BUG: KASAN: stack-out-of-bounds in __le32_to_cpup
> include/uapi/linux/byteorder/little_endian.h:58 [inline]
> BUG: KASAN: stack-out-of-bounds in le32_to_cpuvp
> crypto/chacha20_generic.c:19 [inline]
> BUG: KASAN: stack-out-of-bounds in crypto_chacha20_init
> crypto/chacha20_generic.c:58 [inline]
> BUG: KASAN: stack-out-of-bounds in crypto_chacha20_crypt+0xaf1/0xbd0
> crypto/chacha20_generic.c:91
> Read of size 4 at addr ffff8801d1547630 by task syz-executor3/15071
> 

#syz dup: general protection fault in crypto_chacha20_crypt
