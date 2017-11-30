From: Eric Biggers <ebiggers3@gmail.com>
Subject: Re: KASAN: slab-out-of-bounds Read in crypto_chacha20_crypt
Date: Thu, 30 Nov 2017 01:01:05 -0800
Message-ID: <20171130090105.GB5451@zzz.localdomain>
References: <001a11440c80f04903055f2f275f@google.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: davem@davemloft.net, herbert@gondor.apana.org.au,
        linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
        syzkaller-bugs@googlegroups.com
To: syzbot
        <bot+f574f3c1cda02a64178d8a137bc83881e246ac9c@syzkaller.appspotmail.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-pf0-f180.google.com ([209.85.192.180]:33848 "EHLO
        mail-pf0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750830AbdK3JBI (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 30 Nov 2017 04:01:08 -0500
Content-Disposition: inline
In-Reply-To: <001a11440c80f04903055f2f275f@google.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Thu, Nov 30, 2017 at 12:37:01AM -0800, syzbot wrote:
> ==================================================================
> BUG: KASAN: slab-out-of-bounds in __le32_to_cpup
> include/uapi/linux/byteorder/little_endian.h:58 [inline]
> BUG: KASAN: slab-out-of-bounds in le32_to_cpuvp crypto/chacha20_generic.c:19
> [inline]
> BUG: KASAN: slab-out-of-bounds in crypto_chacha20_init
> crypto/chacha20_generic.c:58 [inline]
> BUG: KASAN: slab-out-of-bounds in crypto_chacha20_crypt+0xaf1/0xbd0
> crypto/chacha20_generic.c:91
> Read of size 4 at addr ffff880100000006 by task syz-executor1/15417

#syz dup: general protection fault in crypto_chacha20_crypt
