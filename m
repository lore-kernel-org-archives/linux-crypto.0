From: Dmitry Vyukov <dvyukov@google.com>
Subject: Re: [PATCH] AF_ALG: register completely initialized request in list
Date: Thu, 5 Jul 2018 10:43:10 +0200
Message-ID: <CACT4Y+bcB3xBwh9K+USZb=DGKkFSBPqtuMy9Lf0gFC7Hf+HYDw@mail.gmail.com>
References: <00000000000092ad87056950ef9e@google.com> <3223691.KS9TZr8pPl@tauon.chronox.de>
 <20180704233757.GK725@sol.localdomain> <3179058.YavDkrnvkQ@positron.chronox.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Cc: Eric Biggers <ebiggers3@gmail.com>,
        syzbot <syzbot+9c251bdd09f83b92ba95@syzkaller.appspotmail.com>,
        David Miller <davem@davemloft.net>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "open list:HARDWARE RANDOM NUMBER GENERATOR CORE"
        <linux-crypto@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        syzkaller-bugs <syzkaller-bugs@googlegroups.com>
To: =?UTF-8?Q?Stephan_M=C3=BCller?= <smueller@chronox.de>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <3179058.YavDkrnvkQ@positron.chronox.de>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

On Thu, Jul 5, 2018 at 9:49 AM, Stephan M=C3=BCller <smueller@chronox.de> w=
rote:
> Am Donnerstag, 5. Juli 2018, 01:37:57 CEST schrieb Eric Biggers:
>
> Hi Eric,
>
>> On Mon, Apr 09, 2018 at 09:54:12AM +0200, Stephan Mueller wrote:
>> > Am Montag, 9. April 2018, 09:51:13 CEST schrieb Dmitry Vyukov:
>> >
>> > Hi Dmitry,
>> >
>> > > You can ask syzbot to test by replying to its report email with a te=
st
>> > > command, see:
>> > > https://github.com/google/syzkaller/blob/master/docs/syzbot.md#commu=
nica
>> > > tion -with-syzbot
>> > >
>> > > Note that all testing of KMSAN bugs needs to go to KMSAN tree, for
>> > > details
>> > > see:
>> > > https://github.com/google/syzkaller/blob/master/docs/syzbot.md#kmsan=
-bug
>> > > s
>> >
>> > Thank you. I will resend the patch later today with the proper tags.
>> >
>> > Ciao
>> > Stephan
>>
>> Hi Stephan, it seems you never sent your patch out.
>
> Thank you for pointing this one out. At the time, I was searching for how=
 I
> can refer to the syzbot KMSAN branch that was used to produce the bug rep=
ort.
> I only see guidance on how to point to the Linux kernel tree.
>
> Do you have a hint how to point to a different syzbot tree?

Hi Stephan,

The general info about patch testing is here:

https://github.com/google/syzkaller/blob/master/docs/syzbot.md#testing-patc=
hes

Some additional KMSAN-specific info is at the bottom of the page:

https://github.com/google/syzkaller/blob/master/docs/syzbot.md#kmsan-bugs

In sort, you issue test command against
https://github.com/google/kmsan.git master and attach the patch.
The git tree/branch are also referenced in the syzbot report:
https://groups.google.com/forum/#!msg/syzkaller-bugs/nCuxVFfvc0I/zE1-hC3lCA=
AJ

Where did you see instructions mentioning Linus tree? I don't see we
ever refer to that tree in the instructions.

Thanks
