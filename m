From: Stephan =?ISO-8859-1?Q?M=FCller?= <smueller@chronox.de>
Subject: Re: [PATCH] AF_ALG: register completely initialized request in list
Date: Thu, 05 Jul 2018 09:49:41 +0200
Message-ID: <3179058.YavDkrnvkQ@positron.chronox.de>
References: <00000000000092ad87056950ef9e@google.com> <3223691.KS9TZr8pPl@tauon.chronox.de> <20180704233757.GK725@sol.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7Bit
Cc: Dmitry Vyukov <dvyukov@google.com>,
        syzbot <syzbot+9c251bdd09f83b92ba95@syzkaller.appspotmail.com>,
        David Miller <davem@davemloft.net>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        linux-crypto@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>,
        syzkaller-bugs@googlegroups.com
To: Eric Biggers <ebiggers3@gmail.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20180704233757.GK725@sol.localdomain>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

Am Donnerstag, 5. Juli 2018, 01:37:57 CEST schrieb Eric Biggers:

Hi Eric,

> On Mon, Apr 09, 2018 at 09:54:12AM +0200, Stephan Mueller wrote:
> > Am Montag, 9. April 2018, 09:51:13 CEST schrieb Dmitry Vyukov:
> > 
> > Hi Dmitry,
> > 
> > > You can ask syzbot to test by replying to its report email with a test
> > > command, see:
> > > https://github.com/google/syzkaller/blob/master/docs/syzbot.md#communica
> > > tion -with-syzbot
> > > 
> > > Note that all testing of KMSAN bugs needs to go to KMSAN tree, for
> > > details
> > > see:
> > > https://github.com/google/syzkaller/blob/master/docs/syzbot.md#kmsan-bug
> > > s
> > 
> > Thank you. I will resend the patch later today with the proper tags.
> > 
> > Ciao
> > Stephan
> 
> Hi Stephan, it seems you never sent your patch out.

Thank you for pointing this one out. At the time, I was searching for how I 
can refer to the syzbot KMSAN branch that was used to produce the bug report. 
I only see guidance on how to point to the Linux kernel tree.

Do you have a hint how to point to a different syzbot tree?

Ciao
Stephan
