From: Dmitry Vyukov <dvyukov@google.com>
Subject: Re: WARNING in kmem_cache_free
Date: Sun, 8 Apr 2018 17:41:17 +0200
Message-ID: <CACT4Y+Y7hdm6LX5-PZu9zXFSmAKMP_jCYY7Z7g6a0xd_XCEYhA@mail.gmail.com>
References: <001a114467482dbc4b05692df8f9@google.com> <CACT4Y+YKnor5e6kT7KeEn3L3gut4M_tCPp7WbjmSTf=44icGxg@mail.gmail.com>
 <CACT4Y+YTjUzk7GFuHi6L4KT74p7xv9W-ACU3Uez4V=YLvy5PhQ@mail.gmail.com> <4564679.HlOejCIXXz@positron.chronox.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Cc: Matthew Wilcox <willy@infradead.org>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        David Miller <davem@davemloft.net>,
        linux-crypto@vger.kernel.org, Eric Biggers <ebiggers3@gmail.com>,
        syzbot <syzbot+75397ee3df5c70164154@syzkaller.appspotmail.com>,
        linux-fsdevel <linux-fsdevel@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        syzkaller-bugs@googlegroups.com, Al Viro <viro@zeniv.linux.org.uk>
To: =?UTF-8?Q?Stephan_M=C3=BCller?= <smueller@chronox.de>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <4564679.HlOejCIXXz@positron.chronox.de>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

On Sun, Apr 8, 2018 at 5:31 PM, Stephan M=C3=BCller <smueller@chronox.de> w=
rote:
> Am Sonntag, 8. April 2018, 13:18:06 CEST schrieb Dmitry Vyukov:
>
> Hi Dmitry,
>
>>
>> Running syz-repro utility on this log, I think I've found the guilty guy=
:
>> https://gist.githubusercontent.com/dvyukov/1dd75d55efd238e7207af1cc38478=
b3a/
>> raw/403859b56b161a6fbb158e8953fac5bb6e73b1a1/gistfile1.txt
>>
>
> I am unable to reproduce it with the code. I am using the current
> cryptodev-2.6 tree with kazan enabled. Could you please give me your kern=
el
> config or a pointer of the used tree?

Hi,

Here is config and kernel commit:
https://groups.google.com/d/msg/syzkaller-bugs/PINYyzoaG1s/ntZPOZdcCAAJ
You can also find compiler and image here if necessary:
https://github.com/google/syzkaller/blob/master/docs/syzbot.md

And note that the program needs to be compiled with -m32. The bugs is
probably not-compat specific, but the program injects fault into a
particular malloc invocation and maybe malloc numbering is affected by
compat path.


>> It crashes as:
>> BUG: KASAN: use-after-free in drbg_kcapi_seed+0x1178/0x12e0
>> and:
>> BUG: unable to handle kernel paging request at ffffebe000000020
>> and with other indications of badly corrupted heap.
>>
>> This points to crypto/drbg.c, so +crypto maintainers.
>
>
> Ciao
> Stephan
>
>
> --
> You received this message because you are subscribed to the Google Groups=
 "syzkaller-bugs" group.
> To unsubscribe from this group and stop receiving emails from it, send an=
 email to syzkaller-bugs+unsubscribe@googlegroups.com.
> To view this discussion on the web visit https://groups.google.com/d/msgi=
d/syzkaller-bugs/4564679.HlOejCIXXz%40positron.chronox.de.
> For more options, visit https://groups.google.com/d/optout.
