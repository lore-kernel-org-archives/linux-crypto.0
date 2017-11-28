From: Eric Biggers <ebiggers3@gmail.com>
Subject: Re: general protection fault in blkcipher_walk_done
Date: Mon, 27 Nov 2017 23:53:07 -0800
Message-ID: <20171128075307.GA23413@zzz.localdomain>
References: <001a113f2cd2d62b59055efb7618@google.com>
 <20171128053738.GA2383@zzz.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: davem@davemloft.net, herbert@gondor.apana.org.au,
        linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
        syzkaller-bugs@googlegroups.com,
        Stephan Mueller <smueller@chronox.de>
To: syzbot
        <bot+3401d9494b9380f7244bcc7fec49680878fccba6@syzkaller.appspotmail.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-pg0-f65.google.com ([74.125.83.65]:37023 "EHLO
        mail-pg0-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751133AbdK1HxK (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 28 Nov 2017 02:53:10 -0500
Content-Disposition: inline
In-Reply-To: <20171128053738.GA2383@zzz.localdomain>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Mon, Nov 27, 2017 at 09:37:38PM -0800, Eric Biggers wrote:
> On Mon, Nov 27, 2017 at 10:56:47AM -0800, syzbot wrote:
> > Hello,
> > 
> > syzkaller hit the following crash on
> > 1ea8d039f9edcfefb20d8ddfe136930f6e551529
> > git://git.cmpxchg.org/linux-mmots.git/master
> > compiler: gcc (GCC) 7.1.1 20170620
> > .config is attached
> > Raw console output is attached.
> > C reproducer is attached
> > syzkaller reproducer is attached. See https://goo.gl/kgGztJ
> > for information about syzkaller reproducers
> 
> Still happens on latest Linus tree (v4.15-rc1) with crypto/master merged in.  It
> seems that _aead_recvmsg() is being confused by the operation mode being changed
> from encryption to decryption while it has dropped the socket lock in
> af_alg_wait_for_data().  Here's a simplified reproducer:
> 

Stephan, why does af_alg_get_rsgl() call af_alg_wait_for_data()?  It's not
actually reading anything from the "TX SGL" yet; it's just preparing the "RX
SGL".  It seems to be in completely the wrong place.  And how exactly should the
AEAD interface know when to wait anyway, given that someone could ask to encrypt
0 bytes to get the authentication tag for that?

Eric
