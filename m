From: Stephan Mueller <smueller@chronox.de>
Subject: Re: [PATCH] AF_ALG: register completely initialized request in list
Date: Mon, 09 Apr 2018 09:54:12 +0200
Message-ID: <3223691.KS9TZr8pPl@tauon.chronox.de>
References: <00000000000092ad87056950ef9e@google.com> <3337259.MW9pfDCdka@positron.chronox.de> <CACT4Y+bGDOi-+vVs=-eD=wHaUbFz2ZVO13yF8hq4cU4dkGXorg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7Bit
Cc: syzbot <syzbot+9c251bdd09f83b92ba95@syzkaller.appspotmail.com>,
        David Miller <davem@davemloft.net>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        linux-crypto@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>,
        syzkaller-bugs@googlegroups.com
To: Dmitry Vyukov <dvyukov@google.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <CACT4Y+bGDOi-+vVs=-eD=wHaUbFz2ZVO13yF8hq4cU4dkGXorg@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

Am Montag, 9. April 2018, 09:51:13 CEST schrieb Dmitry Vyukov:

Hi Dmitry,

> You can ask syzbot to test by replying to its report email with a test
> command, see:
> https://github.com/google/syzkaller/blob/master/docs/syzbot.md#communication
> -with-syzbot
> 
> Note that all testing of KMSAN bugs needs to go to KMSAN tree, for details
> see:
> https://github.com/google/syzkaller/blob/master/docs/syzbot.md#kmsan-bugs

Thank you. I will resend the patch later today with the proper tags.

Ciao
Stephan
