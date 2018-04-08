From: Stephan =?ISO-8859-1?Q?M=FCller?= <smueller@chronox.de>
Subject: Re: WARNING in kmem_cache_free
Date: Sun, 08 Apr 2018 17:31:46 +0200
Message-ID: <4564679.HlOejCIXXz@positron.chronox.de>
References: <001a114467482dbc4b05692df8f9@google.com> <CACT4Y+YKnor5e6kT7KeEn3L3gut4M_tCPp7WbjmSTf=44icGxg@mail.gmail.com> <CACT4Y+YTjUzk7GFuHi6L4KT74p7xv9W-ACU3Uez4V=YLvy5PhQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7Bit
Cc: Matthew Wilcox <willy@infradead.org>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        David Miller <davem@davemloft.net>,
        linux-crypto@vger.kernel.org, Eric Biggers <ebiggers3@gmail.com>,
        syzbot <syzbot+75397ee3df5c70164154@syzkaller.appspotmail.com>,
        linux-fsdevel <linux-fsdevel@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        syzkaller-bugs@googlegroups.com, Al Viro <viro@zeniv.linux.org.uk>
To: Dmitry Vyukov <dvyukov@google.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <CACT4Y+YTjUzk7GFuHi6L4KT74p7xv9W-ACU3Uez4V=YLvy5PhQ@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

Am Sonntag, 8. April 2018, 13:18:06 CEST schrieb Dmitry Vyukov:

Hi Dmitry,

> 
> Running syz-repro utility on this log, I think I've found the guilty guy:
> https://gist.githubusercontent.com/dvyukov/1dd75d55efd238e7207af1cc38478b3a/
> raw/403859b56b161a6fbb158e8953fac5bb6e73b1a1/gistfile1.txt
> 

I am unable to reproduce it with the code. I am using the current 
cryptodev-2.6 tree with kazan enabled. Could you please give me your kernel 
config or a pointer of the used tree?

> It crashes as:
> BUG: KASAN: use-after-free in drbg_kcapi_seed+0x1178/0x12e0
> and:
> BUG: unable to handle kernel paging request at ffffebe000000020
> and with other indications of badly corrupted heap.
> 
> This points to crypto/drbg.c, so +crypto maintainers.


Ciao
Stephan
