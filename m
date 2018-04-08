From: Dmitry Vyukov <dvyukov@google.com>
Subject: Re: WARNING in kmem_cache_free
Date: Sun, 8 Apr 2018 13:18:06 +0200
Message-ID: <CACT4Y+YTjUzk7GFuHi6L4KT74p7xv9W-ACU3Uez4V=YLvy5PhQ@mail.gmail.com>
References: <001a114467482dbc4b05692df8f9@google.com> <CACT4Y+adiXih0-jfNGHgf1kEQ2=KLY5NdX-87BTDbrQgEAHc9g@mail.gmail.com>
 <20180408060140.GB16007@bombadil.infradead.org> <CACT4Y+YKnor5e6kT7KeEn3L3gut4M_tCPp7WbjmSTf=44icGxg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Cc: syzbot <syzbot+75397ee3df5c70164154@syzkaller.appspotmail.com>,
        linux-fsdevel <linux-fsdevel@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        syzkaller-bugs@googlegroups.com, Al Viro <viro@zeniv.linux.org.uk>
To: Matthew Wilcox <willy@infradead.org>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        David Miller <davem@davemloft.net>,
        linux-crypto@vger.kernel.org,
        Stephan Mueller <smueller@chronox.de>,
        Eric Biggers <ebiggers3@gmail.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <CACT4Y+YKnor5e6kT7KeEn3L3gut4M_tCPp7WbjmSTf=44icGxg@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

On Sun, Apr 8, 2018 at 12:26 PM, Dmitry Vyukov <dvyukov@google.com> wrote:
> On Sun, Apr 8, 2018 at 8:01 AM, Matthew Wilcox <willy@infradead.org> wrote:
>> On Fri, Apr 06, 2018 at 03:33:36PM +0200, Dmitry Vyukov wrote:
>>> On Fri, Apr 6, 2018 at 3:24 PM, syzbot
>>> <syzbot+75397ee3df5c70164154@syzkaller.appspotmail.com> wrote:
>>> > Unfortunately, I don't have any reproducer for this crash yet.
>>>
>>> Interesting type of bug, I think we see this for the first time.
>>
>> Can you focus syzbot to try to find a reproducer?  This seems to be
>> produced by calling mount() with a pathname that's somewhere between,
>> say, 3950 & 4100 bytes long from a compat 32-bit task.
>
>
> Something in the log definitely triggers a very bad heap corruption.
>
> This can be reproduced following instructions at:
> https://github.com/google/syzkaller/blob/master/docs/syzbot.md#syzkaller-reproducers
>
> and then running:
> ./syz-execprog -sandbox=namespace -arch=386 -repeat=0 -procs=10 log.txt
>
> where log.txt comes from "Raw console output" link.
>
> Note that you need to build syzkaller with 'make TARGETARCH=386' and
> the use bin/linux_386/syz-executor.
>
> While running it I got:
> BUG: KASAN: double-free or invalid-free in free_request_size+0x5b/0x70
> block/blk-core.c:769
> https://gist.githubusercontent.com/dvyukov/05f4e77a34795d329aa7a2f40265e396/raw/63a29123b79f1fbad3521d0ff034946be68bfd4a/gistfile1.txt
>
> Then kernel BUG at mm/slab.c:4407!
> https://gist.githubusercontent.com/dvyukov/5b3bcc90d326e9da3636aea2c95ace8f/raw/1589504c708994936681d61ba9d70029998b9b1a/gistfile1.txt
>
> And then BUG: unable to handle kernel paging request at ffffebe000000020
> https://gist.githubusercontent.com/dvyukov/72025b1c68e488f4fda243e0c152f044/raw/d2c171bc55ad3a43cea33095fa2eea48768b1131/gistfile1.txt
>
> One interesting thing is that if I run the log once and it does not
> crash, then when I try to start binary again I am getting:
> [  456.837870] Invalid argument reading file caps for /root/syz-executor
> The binary somehow becomes broken on disk...
>
> I guess syzbot did find a reproducer in this log, but did not
> attribute it to this bug as it causes crashes all over the place.



Running syz-repro utility on this log, I think I've found the guilty guy:
https://gist.githubusercontent.com/dvyukov/1dd75d55efd238e7207af1cc38478b3a/raw/403859b56b161a6fbb158e8953fac5bb6e73b1a1/gistfile1.txt

It crashes as:
BUG: KASAN: use-after-free in drbg_kcapi_seed+0x1178/0x12e0
and:
BUG: unable to handle kernel paging request at ffffebe000000020
and with other indications of badly corrupted heap.

This points to crypto/drbg.c, so +crypto maintainers.
