From: Stephan Mueller <smueller@chronox.de>
Subject: Re: KASAN: use-after-free Read in crypto_aead_free_instance
Date: Wed, 20 Dec 2017 10:55:28 +0100
Message-ID: <18467907.EfXNf1iGip@tauon.chronox.de>
References: <001a11c14bc887c2c60560c0cdda@google.com> <7081028.ZNJKGTzsya@tauon.chronox.de> <CACT4Y+Y5SdeqYv9fUyr83k8C-FmpcmFtCRRO_r9_TbvqpNyH7Q@mail.gmail.com>
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
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <CACT4Y+Y5SdeqYv9fUyr83k8C-FmpcmFtCRRO_r9_TbvqpNyH7Q@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

Am Mittwoch, 20. Dezember 2017, 10:50:10 CET schrieb Dmitry Vyukov:

Hi Dmitry,

> On Wed, Dec 20, 2017 at 10:29 AM, Stephan Mueller <smueller@chronox.de> 
wrote:
> > Am Mittwoch, 20. Dezember 2017, 10:19:43 CET schrieb Dmitry Vyukov:
> > 
> > Hi Dmitry,
> > 
> >> > This issue vanishes after applying the patch "[PATCH v2] crypto: AF_ALG
> >> > -
> >> > limit mask and type".
> >> 
> >> Hi Stephan,
> >> 
> >> syzbot does not understand arbitrary English prose, it only understands
> > 
> > this:
> >> > Once a fix for this bug is merged into any tree, reply to this email
> >> > with:
> >> > #syz fix: exact-commit-title
> >> 
> >> Let's tell it about the fix:
> >> 
> >> #syz fix: crypto: AF_ALG - limit mask and type
> > 
> > I have seen that this is the approach, but the fix is not yet in the tree.
> > I just want to let folks know that there is a patch.
> 
> Ah, ok, sorry. It's just difficult to tell when there is a reason to
> not provide the tag right now, or when people are don't know about
> them or ignore.
> If the patch is merged with this title, then there is nothing else to
> do. If it's merged under a different title, a new "#syz fix:" tag will
> override the old one.

Maybe you can teach the syzcaller that there is a proposed fix? E.g.

#syz proposed: commit-title


Ciao
Stephan
