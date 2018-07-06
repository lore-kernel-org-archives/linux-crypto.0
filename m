From: Dmitry Vyukov <dvyukov@google.com>
Subject: Re: KMSAN: uninit-value in af_alg_free_areq_sgls
Date: Fri, 6 Jul 2018 09:44:23 +0200
Message-ID: <CACT4Y+b5JS5BboDz4Z92KoHpp6HEp-SByzWDAXARrLJtyR0Aug@mail.gmail.com>
References: <000000000000846e9e0570438176@google.com> <1626520.Rx0128ICKU@positron.chronox.de>
 <CACT4Y+YJUVJnFt2bn7rhV+ET6dVhwWrym8DK+LgV3rJGVUuCFA@mail.gmail.com> <2049675.lBcD2vaCCs@tauon.chronox.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Cc: syzbot <syzbot+9c251bdd09f83b92ba95@syzkaller.appspotmail.com>,
        David Miller <davem@davemloft.net>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "open list:HARDWARE RANDOM NUMBER GENERATOR CORE"
        <linux-crypto@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        syzkaller-bugs <syzkaller-bugs@googlegroups.com>
To: Stephan Mueller <smueller@chronox.de>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <2049675.lBcD2vaCCs@tauon.chronox.de>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

On Fri, Jul 6, 2018 at 9:41 AM, Stephan Mueller <smueller@chronox.de> wrote=
:
> Am Freitag, 6. Juli 2018, 09:38:41 CEST schrieb Dmitry Vyukov:
>
> Hi Dmitry,
>
>> On Thu, Jul 5, 2018 at 8:45 PM, Stephan M=C3=BCller <smueller@chronox.de=
> wrote:
>> > Am Donnerstag, 5. Juli 2018, 19:02:01 CEST schrieb syzbot:
>> >
>> > Hi Dimitry,
>> >
>> > does the syzkaller somehow uses the "---" separator as part of the URL=
?
>>
>> It used it as branch. Please see:
>>
>> https://github.com/google/syzkaller/blob/master/docs/syzbot.md#testing-p=
atch
>> es
>>
>> for formats. In all formats a git tree is not enough. And it is not
>> enough to identify code state in any other context too, it's always
>> git repo + branch or commit hash.
>
> And which branch should I use for the kmsan.git repo?

master, as specified in the original syzbot report. I will add this to
the doc too.
