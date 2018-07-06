From: Stephan Mueller <smueller@chronox.de>
Subject: Re: KMSAN: uninit-value in af_alg_free_areq_sgls
Date: Fri, 06 Jul 2018 09:41:53 +0200
Message-ID: <2049675.lBcD2vaCCs@tauon.chronox.de>
References: <000000000000846e9e0570438176@google.com> <1626520.Rx0128ICKU@positron.chronox.de> <CACT4Y+YJUVJnFt2bn7rhV+ET6dVhwWrym8DK+LgV3rJGVUuCFA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Cc: syzbot <syzbot+9c251bdd09f83b92ba95@syzkaller.appspotmail.com>,
        David Miller <davem@davemloft.net>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "open list:HARDWARE RANDOM NUMBER GENERATOR CORE"
        <linux-crypto@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        syzkaller-bugs <syzkaller-bugs@googlegroups.com>
To: Dmitry Vyukov <dvyukov@google.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <CACT4Y+YJUVJnFt2bn7rhV+ET6dVhwWrym8DK+LgV3rJGVUuCFA@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

Am Freitag, 6. Juli 2018, 09:38:41 CEST schrieb Dmitry Vyukov:

Hi Dmitry,

> On Thu, Jul 5, 2018 at 8:45 PM, Stephan M=FCller <smueller@chronox.de> wr=
ote:
> > Am Donnerstag, 5. Juli 2018, 19:02:01 CEST schrieb syzbot:
> >=20
> > Hi Dimitry,
> >=20
> > does the syzkaller somehow uses the "---" separator as part of the URL?
>=20
> It used it as branch. Please see:
>=20
> https://github.com/google/syzkaller/blob/master/docs/syzbot.md#testing-pa=
tch
> es
>=20
> for formats. In all formats a git tree is not enough. And it is not
> enough to identify code state in any other context too, it's always
> git repo + branch or commit hash.

And which branch should I use for the kmsan.git repo?

Ciao
Stephan
