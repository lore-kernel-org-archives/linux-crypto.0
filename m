From: Arnd Bergmann <arnd@arndb.de>
Subject: Re: [PATCH] [RFT] crypto: aes-generic - turn off -ftree-pre and -ftree-sra
Date: Wed, 3 Jan 2018 17:37:47 +0100
Message-ID: <CAK8P3a11y=HFaVZkyUFQMNO+47cuAF408+=vTFpEB9zJM8iRFA@mail.gmail.com>
References: <20171220205213.1025257-1-arnd@arndb.de> <20171220214648.GO2353@tucnak>
 <CAK8P3a2b7+KxJ5kKYcnrAV8jDkNBiCR4gCg47iRsiZGdyPoGVg@mail.gmail.com>
 <CAKv+Gu_BYU3JZBVOqeV4CwustnV+Z_Ok6jFipXEzeTpQ8Svy9g@mail.gmail.com>
 <CANc+2y61_o80Wf4JAYB1xi3bb3=6oai77QskSVNjSvpnNZJP0Q@mail.gmail.com> <CAKv+Gu8BQfe1ye-q2MQu=omkbMob6dPp9WpZuR0YkoH=Dsnq2g@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Cc: PrasannaKumar Muralidharan <prasannatsmkumar@gmail.com>,
        Jakub Jelinek <jakub@redhat.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        James Morris <james.l.morris@oracle.com>,
        Richard Biener <rguenther@suse.de>,
        Jakub Jelinek <jakub@gcc.gnu.org>,
        "David S. Miller" <davem@davemloft.net>,
        "open list:HARDWARE RANDOM NUMBER GENERATOR CORE"
        <linux-crypto@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
To: Ard Biesheuvel <ard.biesheuvel@linaro.org>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-qt0-f196.google.com ([209.85.216.196]:37499 "EHLO
        mail-qt0-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751255AbeACQhs (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 3 Jan 2018 11:37:48 -0500
In-Reply-To: <CAKv+Gu8BQfe1ye-q2MQu=omkbMob6dPp9WpZuR0YkoH=Dsnq2g@mail.gmail.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Fri, Dec 22, 2017 at 4:47 PM, Ard Biesheuvel
<ard.biesheuvel@linaro.org> wrote:
> On 21 December 2017 at 13:47, PrasannaKumar Muralidharan <prasannatsmkumar@gmail.com> wrote:
>> On 21 December 2017 at 17:52, Ard Biesheuvel <ard.biesheuvel@linaro.org> wrote:
>>> On 21 December 2017 at 10:20, Arnd Bergmann <arnd@arndb.de> wrote:
>>>
>>> So my vote is to disable UBSAN for all such cipher implementations:
>>> aes_generic, but also aes_ti, which has a similar 256 byte lookup
>>> table [although it does not seem to be affected by the same issue as
>>> aes_generic], and possibly others as well.
>>>
>>> Perhaps it makes sense to move core cipher code into a separate
>>> sub-directory, and disable UBSAN at the directory level?
>>>
>>> It would involve the following files
>>>
>>> crypto/aes_generic.c
>>> crypto/aes_ti.c
>>> crypto/anubis.c
>>> crypto/arc4.c
>>> crypto/blowfish_generic.c
>>> crypto/camellia_generic.c
>>> crypto/cast5_generic.c
>>> crypto/cast6_generic.c
>>> crypto/des_generic.c
>>> crypto/fcrypt.c
>>> crypto/khazad.c
>>> crypto/seed.c
>>> crypto/serpent_generic.c
>>> crypto/tea.c
>>> crypto/twofish_generic.c
>>
>> As *SAN is enabled only on developer setup, is such a change required?
>> Looks like I am missing something here. Can you explain what value it
>> provides?
>>
>
> Well, in this particular case, the value it provides is that the
> kernel can still boot and invoke the AES code without overflowing the
> kernel stack. Of course, this is a compiler issue that hopefully gets
> fixed, but I think it may be reasonable to exclude some C code from
> UBSAN by default.

Any idea how to proceed here? I've retested with the latest gcc snapshot
and verified that the problem is still there. No idea what the chance of
getting it fixed before the 7.3 release is. From the performance tests
I've done, the patch I posted is pretty much useless, it causes significant
performance regressions on most other compiler versions.

A minimal patch would be to disable UBSAN specifically for aes-generic.c
for gcc-7.2+ but not gcc-8 to avoid the potential stack overflow. We could
also force building with -Os on gcc-7, and leave UBSAN enabled,
this would improve performance some 3-5% on x86 with gcc-7 (both
7.1 and 7.2.1) and avoid the stack overflow.

For the performance regression in gcc-7.2.1 on this file, I've opened
a separate gcc PR now, see https://gcc.gnu.org/bugzilla/show_bug.cgi?id=83651
I've also tested the libressl version of their generic AES code, with
mixed results (it's appears to be much slower than the kernel version
to start with, and while it has further performance regressions with recent
compilers, those are with a different set of versions compared to the
kernel implementation, and it does not suffer from the high stack usage).

       Arnd
