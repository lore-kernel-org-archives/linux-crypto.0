From: Eric Biggers <ebiggers3@gmail.com>
Subject: Re: KASAN: use-after-free Read in blkcipher_walk_virt
Date: Thu, 30 Nov 2017 00:59:44 -0800
Message-ID: <20171130085944.GA5451@zzz.localdomain>
References: <001a1143d526ebb745055f2f27c1@google.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: davem@davemloft.net, herbert@gondor.apana.org.au,
        linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
        syzkaller-bugs@googlegroups.com
To: syzbot
        <bot+63a09d8c7627bb7c054d94ba904d8d2d3687d64a@syzkaller.appspotmail.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-pf0-f179.google.com ([209.85.192.179]:32884 "EHLO
        mail-pf0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752042AbdK3I7s (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 30 Nov 2017 03:59:48 -0500
Content-Disposition: inline
In-Reply-To: <001a1143d526ebb745055f2f27c1@google.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Thu, Nov 30, 2017 at 12:37:01AM -0800, syzbot wrote:
> ==================================================================
> BUG: KASAN: use-after-free in crypto_tfm_alg_blocksize
> include/linux/crypto.h:671 [inline]
> BUG: KASAN: use-after-free in crypto_blkcipher_blocksize
> include/linux/crypto.h:1214 [inline]
> BUG: KASAN: use-after-free in blkcipher_walk_virt+0x286/0x2a0
> crypto/blkcipher.c:304
> Read of size 8 at addr ffff8801ccba7f38 by task syz-executor5/4473
> 

#syz dup: KASAN: use-after-free Read in aead_recvmsg
