From: Eric Biggers <ebiggers3@gmail.com>
Subject: Re: KASAN: use-after-free Read in aead_recvmsg
Date: Mon, 27 Nov 2017 14:43:08 -0800
Message-ID: <20171127224308.GB8426@gmail.com>
References: <001a113ebb5ece8a7a055efb7676@google.com>
 <2409323.isfI9bk5QC@positron.chronox.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 8bit
Cc: syzbot
        <bot+6fbc13c3b1ed2105e7a2e516be43d6a0624a59c0@syzkaller.appspotmail.com>,
        davem@davemloft.net, herbert@gondor.apana.org.au,
        linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
        syzkaller-bugs@googlegroups.com
To: Stephan =?iso-8859-1?Q?M=FCller?= <smueller@chronox.de>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-io0-f196.google.com ([209.85.223.196]:41103 "EHLO
        mail-io0-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752126AbdK0WnM (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 27 Nov 2017 17:43:12 -0500
Content-Disposition: inline
In-Reply-To: <2409323.isfI9bk5QC@positron.chronox.de>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Mon, Nov 27, 2017 at 11:02:08PM +0100, Stephan Müller wrote:
> Am Montag, 27. November 2017, 19:56:46 CET schrieb syzbot:
> 
> Hi,
> 
> > Hello,
> > 
> > syzkaller hit the following crash on
> > 6fc478f80f6809cc4b1a4230f47a62d3b7378dc0
> > git://git.kernel.org/pub/scm/linux/kernel/git/next/linux-next.git/master
> > compiler: gcc (GCC) 7.1.1 20170620
> > .config is attached
> > Raw console output is attached.
> > C reproducer is attached
> > syzkaller reproducer is attached. See https://goo.gl/kgGztJ
> > for information about syzkaller reproducers
> 
> Could you please re-perform the test applying the patch https://
> git.kernel.org/pub/scm/linux/kernel/git/herbert/crypto-2.6.git/commit/?
> id=8e1fa89aa8bc2870009b4486644e4a58f2e2a4f5 ?
> 
> At least I am not able to reproduce that issue using the repro.c with the 
> patch applied.
> 

No, that doesn't help.  I tested v4.15-rc1 with all the extra commits from
crypto-2.6.git/master applied:

	crypto: algif_aead - skip SGL entries with NULL page
	crypto: af_alg - remove locking in async callback
	crypto: skcipher - Fix skcipher_walk_aead_common

Did you use the .config the bot provided?  It's possible the bug is only
noticable with KASAN enabled.

Eric
