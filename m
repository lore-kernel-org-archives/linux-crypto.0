From: Stephan Mueller <smueller@chronox.de>
Subject: Re: general protection fault in blkcipher_walk_done
Date: Tue, 28 Nov 2017 09:31:33 +0100
Message-ID: <8642775.1nriSlZD2S@tauon.chronox.de>
References: <001a113f2cd2d62b59055efb7618@google.com> <20171128053738.GA2383@zzz.localdomain> <20171128075307.GA23413@zzz.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7Bit
Cc: syzbot
        <bot+3401d9494b9380f7244bcc7fec49680878fccba6@syzkaller.appspotmail.com>,
        davem@davemloft.net, herbert@gondor.apana.org.au,
        linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
        syzkaller-bugs@googlegroups.com
To: Eric Biggers <ebiggers3@gmail.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail.eperm.de ([89.247.134.16]:42534 "EHLO mail.eperm.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751770AbdK1Ibh (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 28 Nov 2017 03:31:37 -0500
In-Reply-To: <20171128075307.GA23413@zzz.localdomain>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Am Dienstag, 28. November 2017, 08:53:07 CET schrieb Eric Biggers:

Hi Eric,

> On Mon, Nov 27, 2017 at 09:37:38PM -0800, Eric Biggers wrote:
> > On Mon, Nov 27, 2017 at 10:56:47AM -0800, syzbot wrote:
> > > Hello,
> > > 
> > > syzkaller hit the following crash on
> > > 1ea8d039f9edcfefb20d8ddfe136930f6e551529
> > > git://git.cmpxchg.org/linux-mmots.git/master
> > > compiler: gcc (GCC) 7.1.1 20170620
> > > .config is attached
> > > Raw console output is attached.
> > > C reproducer is attached
> > > syzkaller reproducer is attached. See https://goo.gl/kgGztJ
> > > for information about syzkaller reproducers
> > 
> > Still happens on latest Linus tree (v4.15-rc1) with crypto/master merged
> > in.  It seems that _aead_recvmsg() is being confused by the operation
> > mode being changed from encryption to decryption while it has dropped the
> > socket lock in
> > af_alg_wait_for_data().  Here's a simplified reproducer:
> Stephan, why does af_alg_get_rsgl() call af_alg_wait_for_data()?  It's not
> actually reading anything from the "TX SGL" yet; it's just preparing the "RX
> SGL".  It seems to be in completely the wrong place.

I would disagree with this assertion: If there is no TX SGL to be processed, 
why should the kernel prepare already an RX SGL (and thus allocate memory)? 
The RX SGL should only have a very short life span, i.e. when there is real 
work to be done. If we are waiting for work, the kernel should not occupy 
resources that may or may not be used.

> And how exactly
> should the AEAD interface know when to wait anyway, given that someone
> could ask to encrypt 0 bytes to get the authentication tag for that?

This very issue is caught with af_alg_wait_for_data where the sleep is 
terminated or not even entered with " || !ctx->more". For AEAD you need to 
clear the MSG_MORE flag when you sent the last chunk of data.

See [1] for a test where a gcm(aes) encryption is performed with zero 
plaintext, zero AAD, zero expected ciphertext but where only the tag is 
calculated. 

[1] https://github.com/smuellerDD/libkcapi/blob/master/test/test.sh#L305
> 
> Eric



Ciao
Stephan
