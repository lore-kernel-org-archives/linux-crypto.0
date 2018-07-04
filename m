From: Eric Biggers <ebiggers3@gmail.com>
Subject: Re: [PATCH] AF_ALG: register completely initialized request in list
Date: Wed, 4 Jul 2018 16:37:57 -0700
Message-ID: <20180704233757.GK725@sol.localdomain>
References: <00000000000092ad87056950ef9e@google.com>
 <3337259.MW9pfDCdka@positron.chronox.de>
 <CACT4Y+bGDOi-+vVs=-eD=wHaUbFz2ZVO13yF8hq4cU4dkGXorg@mail.gmail.com>
 <3223691.KS9TZr8pPl@tauon.chronox.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Dmitry Vyukov <dvyukov@google.com>,
        syzbot <syzbot+9c251bdd09f83b92ba95@syzkaller.appspotmail.com>,
        David Miller <davem@davemloft.net>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        linux-crypto@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>,
        syzkaller-bugs@googlegroups.com
To: Stephan Mueller <smueller@chronox.de>
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <3223691.KS9TZr8pPl@tauon.chronox.de>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

On Mon, Apr 09, 2018 at 09:54:12AM +0200, Stephan Mueller wrote:
> Am Montag, 9. April 2018, 09:51:13 CEST schrieb Dmitry Vyukov:
> 
> Hi Dmitry,
> 
> > You can ask syzbot to test by replying to its report email with a test
> > command, see:
> > https://github.com/google/syzkaller/blob/master/docs/syzbot.md#communication
> > -with-syzbot
> > 
> > Note that all testing of KMSAN bugs needs to go to KMSAN tree, for details
> > see:
> > https://github.com/google/syzkaller/blob/master/docs/syzbot.md#kmsan-bugs
> 
> Thank you. I will resend the patch later today with the proper tags.
> 
> Ciao
> Stephan

Hi Stephan, it seems you never sent your patch out.

- Eric
