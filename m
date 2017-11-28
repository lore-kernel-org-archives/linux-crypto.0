From: Stephan Mueller <smueller@chronox.de>
Subject: Re: KASAN: use-after-free Read in aead_recvmsg
Date: Tue, 28 Nov 2017 07:30:46 +0100
Message-ID: <5111191.QYDWLsXdp1@tauon.chronox.de>
References: <001a113ebb5ece8a7a055efb7676@google.com> <2409323.isfI9bk5QC@positron.chronox.de> <20171127224308.GB8426@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7Bit
Cc: syzbot
        <bot+6fbc13c3b1ed2105e7a2e516be43d6a0624a59c0@syzkaller.appspotmail.com>,
        davem@davemloft.net, herbert@gondor.apana.org.au,
        linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
        syzkaller-bugs@googlegroups.com
To: Eric Biggers <ebiggers3@gmail.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail.eperm.de ([89.247.134.16]:42508 "EHLO mail.eperm.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1750711AbdK1Gat (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 28 Nov 2017 01:30:49 -0500
In-Reply-To: <20171127224308.GB8426@gmail.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Am Montag, 27. November 2017, 23:43:08 CET schrieb Eric Biggers:

Hi Eric,

> No, that doesn't help.  I tested v4.15-rc1 with all the extra commits from
> crypto-2.6.git/master applied:
> 
> 	crypto: algif_aead - skip SGL entries with NULL page
> 	crypto: af_alg - remove locking in async callback
> 	crypto: skcipher - Fix skcipher_walk_aead_common
> 
> Did you use the .config the bot provided?  It's possible the bug is only
> noticable with KASAN enabled.

Not so far, but the bug seemed to be there without my patch and then gone 
after testing it with my patch. It seems not.

I will use your config then.

Thank you.



Ciao
Stephan
