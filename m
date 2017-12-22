From: Ard Biesheuvel <ard.biesheuvel@linaro.org>
Subject: Re: [PATCH] [RFT] crypto: aes-generic - turn off -ftree-pre and -ftree-sra
Date: Fri, 22 Dec 2017 15:47:01 +0000
Message-ID: <CAKv+Gu8BQfe1ye-q2MQu=omkbMob6dPp9WpZuR0YkoH=Dsnq2g@mail.gmail.com>
References: <20171220205213.1025257-1-arnd@arndb.de> <20171220214648.GO2353@tucnak>
 <CAK8P3a2b7+KxJ5kKYcnrAV8jDkNBiCR4gCg47iRsiZGdyPoGVg@mail.gmail.com>
 <CAKv+Gu_BYU3JZBVOqeV4CwustnV+Z_Ok6jFipXEzeTpQ8Svy9g@mail.gmail.com> <CANc+2y61_o80Wf4JAYB1xi3bb3=6oai77QskSVNjSvpnNZJP0Q@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Cc: Arnd Bergmann <arnd@arndb.de>, Jakub Jelinek <jakub@redhat.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        James Morris <james.l.morris@oracle.com>,
        Richard Biener <rguenther@suse.de>,
        Jakub Jelinek <jakub@gcc.gnu.org>,
        "David S. Miller" <davem@davemloft.net>,
        "open list:HARDWARE RANDOM NUMBER GENERATOR CORE"
        <linux-crypto@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
To: PrasannaKumar Muralidharan <prasannatsmkumar@gmail.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-it0-f45.google.com ([209.85.214.45]:36977 "EHLO
        mail-it0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753735AbdLVPrD (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 22 Dec 2017 10:47:03 -0500
Received: by mail-it0-f45.google.com with SMTP id d137so15063137itc.2
        for <linux-crypto@vger.kernel.org>; Fri, 22 Dec 2017 07:47:02 -0800 (PST)
In-Reply-To: <CANc+2y61_o80Wf4JAYB1xi3bb3=6oai77QskSVNjSvpnNZJP0Q@mail.gmail.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On 21 December 2017 at 13:47, PrasannaKumar Muralidharan
<prasannatsmkumar@gmail.com> wrote:
> Hi Ard,
>
> On 21 December 2017 at 17:52, Ard Biesheuvel <ard.biesheuvel@linaro.org> wrote:
>> On 21 December 2017 at 10:20, Arnd Bergmann <arnd@arndb.de> wrote:
>>> On Wed, Dec 20, 2017 at 10:46 PM, Jakub Jelinek <jakub@redhat.com> wrote:
>>>> On Wed, Dec 20, 2017 at 09:52:05PM +0100, Arnd Bergmann wrote:
>>>>> diff --git a/crypto/aes_generic.c b/crypto/aes_generic.c
>>>>> index ca554d57d01e..35f973ba9878 100644
>>>>> --- a/crypto/aes_generic.c
>>>>> +++ b/crypto/aes_generic.c
>>>>> @@ -1331,6 +1331,20 @@ EXPORT_SYMBOL_GPL(crypto_aes_set_key);
>>>>>       f_rl(bo, bi, 3, k);     \
>>>>>  } while (0)
>>>>>
>>>>> +#if __GNUC__ >= 7
>>>>> +/*
>>>>> + * Newer compilers try to optimize integer arithmetic more aggressively,
>>>>> + * which generally improves code quality a lot, but in this specific case
>>>>> + * ends up hurting more than it helps, in some configurations drastically
>>>>> + * so. This turns off two optimization steps that have been shown to
>>>>> + * lead to rather badly optimized code with gcc-7.
>>>>> + *
>>>>> + * See also https://gcc.gnu.org/bugzilla/show_bug.cgi?id=83356
>>>>> + */
>>>>> +#pragma GCC optimize("-fno-tree-pre")
>>>>> +#pragma GCC optimize("-fno-tree-sra")
>>>>
>>>> So do it only when UBSAN is enabled?  GCC doesn't have a particular
>>>> predefined macro for those (only for asan and tsan), but either the kernel
>>>> does have something already, or could have something added in the
>>>> corresponding Makefile.
>>>
>>> My original interpretation of the resulting object code suggested that disabling
>>> those two optimizations produced better results for this particular
>>> file even without
>>> UBSAN, on both gcc-7 and gcc-8 (but not gcc-6), so my patch might have
>>> been better, but I did some measurements now as Ard suggested, showing
>>> cycles/byte for AES256/CBC with 8KB blocks:
>>>
>>>
>>>                default      ubsan         patched        patched+ubsan
>>> gcc-4.3.6        14.9        ----           14.9         ----
>>> gcc-4.6.4        15.0        ----           15.8         ----
>>> gcc-4.9.4        15.5        20.7           15.9         20.9
>>> gcc-5.5.0        15.6        47.3           86.4         48.8
>>> gcc-6.3.1        14.6        49.4           94.3         50.9
>>> gcc-7.1.1        13.5        54.6           15.2         52.0
>>> gcc-7.2.1        16.8       124.7           92.0         52.2
>>> gcc-8.0.0        15.0      no boot          15.3        no boot
>>>
>>> I checked that there are actually three significant digits on the measurements,
>>> detailed output is available at https://pastebin.com/eFsWYjQp
>>>
>>> It seems that I was wrong about the interpretation that disabling
>>> the optimization would be a win on gcc-7 and higher, it almost
>>> always makes things worse even with UBSAN. Making that
>>> check "#if __GNUC__ == 7 && IS_ENABLED(CONFIG_UBSAN_SANITIZE_ALL)"
>>> would help here, or we could list the file as an exception for
>>> UBSAN and never sanitize it.
>>>
>>> Looking at the 'default' column, I wonder if anyone would be interested
>>> in looking at why the throughput regressed with gcc-7.2 and gcc-8.
>>>
>>
>> Thanks for the elaborate benchmarks. Looking at the bugzilla entry, it
>> appears the UBSAN code inserts runtime checks to ensure that certain
>> u8 variables don't assume values <0 or >255, which seems like a rather
>> pointless exercise to me. But even if it didn't, I think it is
>> justified to disable UBSAN on all of the low-level cipher
>> implementations, given that they are hardly ever modified, and
>> typically don't suffer from the issues UBSAN tries to identify.
>>
>> So my vote is to disable UBSAN for all such cipher implementations:
>> aes_generic, but also aes_ti, which has a similar 256 byte lookup
>> table [although it does not seem to be affected by the same issue as
>> aes_generic], and possibly others as well.
>>
>> Perhaps it makes sense to move core cipher code into a separate
>> sub-directory, and disable UBSAN at the directory level?
>>
>> It would involve the following files
>>
>> crypto/aes_generic.c
>> crypto/aes_ti.c
>> crypto/anubis.c
>> crypto/arc4.c
>> crypto/blowfish_generic.c
>> crypto/camellia_generic.c
>> crypto/cast5_generic.c
>> crypto/cast6_generic.c
>> crypto/des_generic.c
>> crypto/fcrypt.c
>> crypto/khazad.c
>> crypto/seed.c
>> crypto/serpent_generic.c
>> crypto/tea.c
>> crypto/twofish_generic.c
>
> As *SAN is enabled only on developer setup, is such a change required?
> Looks like I am missing something here. Can you explain what value it
> provides?
>

Well, in this particular case, the value it provides is that the
kernel can still boot and invoke the AES code without overflowing the
kernel stack. Of course, this is a compiler issue that hopefully gets
fixed, but I think it may be reasonable to exclude some C code from
UBSAN by default.
