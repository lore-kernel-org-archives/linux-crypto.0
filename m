From: Stephan Mueller <smueller@chronox.de>
Subject: Re: KASAN: use-after-free Read in crypto_aead_free_instance
Date: Wed, 20 Dec 2017 10:29:05 +0100
Message-ID: <7081028.ZNJKGTzsya@tauon.chronox.de>
References: <001a11c14bc887c2c60560c0cdda@google.com> <2720015.COYl3plZzm@positron.chronox.de> <CACT4Y+Zgm=g2Tnne-p2J1sXEhfa2BVZsLXox3sxzq_NW4MBKmQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7Bit
Cc: syzbot
        <bot+e5e6fab2d4dc3d9877ac240fed364027bb960ad0@syzkaller.appspotmail.com>,
        David Miller <davem@davemloft.net>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        linux-crypto@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>,
        syzkaller-bugs@googlegroups.com
To: Dmitry Vyukov <dvyukov@google.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail.eperm.de ([89.247.134.16]:44452 "EHLO mail.eperm.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1754153AbdLTJ3I (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 20 Dec 2017 04:29:08 -0500
In-Reply-To: <CACT4Y+Zgm=g2Tnne-p2J1sXEhfa2BVZsLXox3sxzq_NW4MBKmQ@mail.gmail.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Am Mittwoch, 20. Dezember 2017, 10:19:43 CET schrieb Dmitry Vyukov:

Hi Dmitry,
> > 
> > This issue vanishes after applying the patch "[PATCH v2] crypto: AF_ALG -
> > limit mask and type".
> 
> Hi Stephan,
> 
> syzbot does not understand arbitrary English prose, it only understands 
this:
> > Once a fix for this bug is merged into any tree, reply to this email with:
> > #syz fix: exact-commit-title
> 
> Let's tell it about the fix:
> 
> #syz fix: crypto: AF_ALG - limit mask and type

I have seen that this is the approach, but the fix is not yet in the tree. I 
just want to let folks know that there is a patch.


Ciao
Stephan
