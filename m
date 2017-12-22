From: Dmitry Vyukov <dvyukov@google.com>
Subject: Re: BUG: unable to handle kernel paging request in hmac_init_tfm
Date: Fri, 22 Dec 2017 10:01:04 +0100
Message-ID: <CACT4Y+Y8meeD=aVr=1jFRnZ9e8SE1D+jrvftqkqS9avZqVKFzw@mail.gmail.com>
References: <94eb2c0d010ad8f1660560a275fd@google.com> <20171220230947.GF38504@gmail.com>
 <CACT4Y+bRD5C=ffgOBZNCVFNheH=W304CVRzyGr1FB3W=aYuBNA@mail.gmail.com> <20171222022751.GA26818@zzz.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Cc: syzbot
        <bot+428944d1a848e9d7464aa96da32ba353cc812457@syzkaller.appspotmail.com>,
        David Miller <davem@davemloft.net>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        linux-crypto@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>,
        syzkaller-bugs@googlegroups.com
To: Eric Biggers <ebiggers3@gmail.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20171222022751.GA26818@zzz.localdomain>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

On Fri, Dec 22, 2017 at 3:27 AM, Eric Biggers <ebiggers3@gmail.com> wrote:
> On Thu, Dec 21, 2017 at 08:44:03AM +0100, 'Dmitry Vyukov' via syzkaller-bugs wrote:
>> On Thu, Dec 21, 2017 at 12:09 AM, Eric Biggers <ebiggers3@gmail.com> wrote:
>> > On Mon, Dec 18, 2017 at 11:36:01AM -0800, syzbot wrote:
>> >> Hello,
>> >>
>> >> syzkaller hit the following crash on
>> >> 6084b576dca2e898f5c101baef151f7bfdbb606d
>> >> git://git.kernel.org/pub/scm/linux/kernel/git/next/linux-next.git/master
>> >> compiler: gcc (GCC) 7.1.1 20170620
>> >> .config is attached
>> >
>> > FYI, in linux-next KASAN and other memory debugging options are now behind
>> > CONFIG_DEBUG_MEMORY.  So, I think KASAN isn't getting turned on anymore, despite
>> > the CONFIG_KASAN=y.  (Patch was "lib/: make "Memory Debugging" a menuconfig to
>> > ease disabling it all".)
>>
>> Ouch! That would be pretty bad.
>>
>> But I've tried both linux-next HEAD at:
>>
>> commit 0e08c463db387a2adcb0243b15ab868a73f87807 (HEAD, tag:
>> next-20171221, linux-next/master)
>> Author: Stephen Rothwell <sfr@canb.auug.org.au>
>> Date:   Thu Dec 21 15:37:39 2017 +1100
>>     Add linux-next specific files for 20171221
>>
>> and mmots HEAD at:
>>
>> commit 75aa5540627fdb3d8f86229776ea87f995275351 (HEAD, tag:
>> v4.15-rc4-mmots-2017-12-20-19-10, mmots/master)
>> Author: Linus Torvalds <torvalds@linux-foundation.org>
>> Date:   Thu Dec 21 04:02:17 2017 +0000
>>     pci: test for unexpectedly disabled bridges
>>
>> and after running make olddefconfig I still see CONFIG_KASAN=y in
>> .config, nor I can find CONFIG_DEBUG_MEMORY in menuconfig.
>>
>> What am I missing? What commit has added the config?
>>
>
> Ah, I see the patch was added to -mm on 2017-12-12 but removed two days later:
>
> https://www.spinics.net/lists/mm-commits/msg129685.html
> https://www.spinics.net/lists/mm-commits/msg129696.html
>
> So it was in linux-next temporarily (including the kernel version used for this
> particular bug report) but now it's not.  Just keep an eye out for it coming
> back, I guess.


I see. Then I will add CONFIG_DEBUG_MEMORY=y to our config
proactively. Without that patch olddefconfig will just wipe that
config, so should work.
