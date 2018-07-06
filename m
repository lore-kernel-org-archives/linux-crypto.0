From: Stephan Mueller <smueller@chronox.de>
Subject: Re: KMSAN: uninit-value in af_alg_free_areq_sgls
Date: Fri, 06 Jul 2018 18:27:07 +0200
Message-ID: <2936767.s7CfvshsC6@tauon.chronox.de>
References: <1616306.R4SzcgHSdy@positron.chronox.de> <000000000000363e2e0570502d42@google.com> <CACT4Y+Yv8M93-N3J1U6r1X=Oy2SaKQpJU1S6iJeFC8bJMnjuKg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7Bit
Cc: syzbot <syzbot+9c251bdd09f83b92ba95@syzkaller.appspotmail.com>,
        David Miller <davem@davemloft.net>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "open list:HARDWARE RANDOM NUMBER GENERATOR CORE"
        <linux-crypto@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        syzkaller-bugs <syzkaller-bugs@googlegroups.com>
To: Dmitry Vyukov <dvyukov@google.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <CACT4Y+Yv8M93-N3J1U6r1X=Oy2SaKQpJU1S6iJeFC8bJMnjuKg@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

Am Freitag, 6. Juli 2018, 10:19:07 CEST schrieb Dmitry Vyukov:

Hi Dmitry,

> On Fri, Jul 6, 2018 at 10:09 AM, syzbot
> 
> <syzbot+9c251bdd09f83b92ba95@syzkaller.appspotmail.com> wrote:
> > Hello,
> > 
> > syzbot tried to test the proposed patch but build/boot failed:
> > 
> > lost connection to test machine
> 
> Looking into this.

syzkaller reported the following which implies that the patch seems to fix the 
issue.


syzbot has tested the proposed patch and the reproducer did not trigger  
crash:

Reported-and-tested-by:  
syzbot+9c251bdd09f83b92ba95@syzkaller.appspotmail.com

Tested on:

commit:         a00de5aa4da3 kmsan: delete some dead code
git tree:       https://github.com/google/kmsan.git/master
kernel config:  https://syzkaller.appspot.com/x/.config?x=b11f4cfb262ee607
compiler:       clang version 7.0.0 (trunk 334104)
patch:          https://syzkaller.appspot.com/x/patch.diff?x=13194968400000

Note: testing is done by a robot and is best-effort only.


Ciao
Stephan
