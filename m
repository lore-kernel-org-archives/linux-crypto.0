From: Ard Biesheuvel <ard.biesheuvel@linaro.org>
Subject: Re: [RFC PATCH] crypto: algapi - make crypto_xor() and crypto_inc()
 alignment agnostic
Date: Thu, 2 Feb 2017 07:52:23 +0000
Message-ID: <CAKv+Gu-TU+5EM8YLyxpaCgCkG=r-Pr0655aJq8B3OqT5szOq4A@mail.gmail.com>
References: <1485785489-5116-1-git-send-email-ard.biesheuvel@linaro.org> <20170202064716.GB582@zzz>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Cc: "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>,
        Herbert Xu <herbert@gondor.apana.org.au>
To: Eric Biggers <ebiggers3@gmail.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-it0-f45.google.com ([209.85.214.45]:37852 "EHLO
        mail-it0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750808AbdBBHwY (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 2 Feb 2017 02:52:24 -0500
Received: by mail-it0-f45.google.com with SMTP id r185so35831685ita.0
        for <linux-crypto@vger.kernel.org>; Wed, 01 Feb 2017 23:52:24 -0800 (PST)
In-Reply-To: <20170202064716.GB582@zzz>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On 2 February 2017 at 06:47, Eric Biggers <ebiggers3@gmail.com> wrote:
> On Mon, Jan 30, 2017 at 02:11:29PM +0000, Ard Biesheuvel wrote:
>> Instead of unconditionally forcing 4 byte alignment for all generic
>> chaining modes that rely on crypto_xor() or crypto_inc() (which may
>> result in unnecessary copying of data when the underlying hardware
>> can perform unaligned accesses efficiently), make those functions
>> deal with unaligned input explicitly, but only if the Kconfig symbol
>> HAVE_EFFICIENT_UNALIGNED_ACCESS is set. This will allow us to drop
>> the alignmasks from the CBC, CMAC, CTR, CTS, PCBC and SEQIV drivers.
>>
>> For crypto_inc(), this simply involves making the 4-byte stride
>> conditional on HAVE_EFFICIENT_UNALIGNED_ACCESS being set, given that
>> it typically operates on 16 byte buffers.
>>
>> For crypto_xor(), an algorithm is implemented that simply runs through
>> the input using the largest strides possible if unaligned accesses are
>> allowed. If they are not, an optimal sequence of memory accesses is
>> emitted that takes the relative alignment of the input buffers into
>> account, e.g., if the relative misalignment of dst and src is 4 bytes,
>> the entire xor operation will be completed using 4 byte loads and stores
>> (modulo unaligned bits at the start and end). Note that all expressions
>> involving startalign and misalign are simply eliminated by the compiler
>> if HAVE_EFFICIENT_UNALIGNED_ACCESS is defined.
>>
>
> Hi Ard,
>
> This is a good idea, and I think it was error-prone to be requiring 4-byte
> alignment always, and also inefficient on many architectures.
>
> The new crypto_inc() looks fine, but the new crypto_xor() is quite complicated.
> I'm wondering whether it has to be that way, especially since it seems to most
> commonly be used on very small input buffers, e.g. 8 or 16-byte blocks.  There
> are a couple trivial ways it could be simplified, e.g. using 'dst' and 'src'
> directly instead of 'a' and 'b' (which also seems to improve code generation by
> getting rid of the '+= len & ~mask' parts), or using sizeof(long) directly
> instead of 'size' and 'mask'.
>
> But also when I tried testing the proposed crypto_xor() on MIPS, it didn't work
> correctly on a misaligned buffer.  With startalign=1, it did one iteration of
> the following loop and then exited with startalign=0 and entered the "unsigned
> long at a time" loop, which is incorrect since at that point the buffers were
> not yet fully aligned:
>

Right. I knew it was convoluted but I thought that was justified by
its correctness :-)

>>               do {
>>                       if (len < sizeof(u8))
>>                               break;
>>
>>                       if (len >= size && !(startalign & 1) && !(misalign & 1))
>>                               break;
>>
>>                       *dst++ ^= *src++;
>>                       len -= sizeof(u8);
>>                       startalign &= ~sizeof(u8);
>>               } while (misalign & 1);
>
> I think it would need to do instead:
>
>                 startalign += sizeof(u8);
>                 startalign %= sizeof(unsigned long);
>
> But I am wondering whether you considered something simpler, using the
> get_unaligned/put_unaligned helpers, maybe even using a switch statement for the
> last (sizeof(long) - 1) bytes so it can be compiled as a jump table.  Something
> like this:
>
> #define xor_unaligned(dst, src) \
>         put_unaligned(get_unaligned(dst) ^ get_unaligned(src), (dst))
>
> void crypto_xor(u8 *dst, const u8 *src, unsigned int len)
> {
>         while (len >= sizeof(unsigned long)) {
>                 xor_unaligned((unsigned long *)dst, (unsigned long *)src);
>                 dst += sizeof(unsigned long);
>                 src += sizeof(unsigned long);
>                 len -= sizeof(unsigned long);
>         }
>
>         switch (len) {
> #ifdef CONFIG_64BIT
>         case 7:
>                 dst[6] ^= src[6];
>                 /* fall through */
>         case 6:
>                 xor_unaligned((u16 *)&dst[4], (u16 *)&src[4]);
>                 goto len_4;
>         case 5:
>                 dst[4] ^= src[4];
>                 /* fall through */
>         case 4:
>         len_4:
>                 xor_unaligned((u32 *)dst, (u32 *)src);
>                 break;
> #endif
>         case 3:
>                 dst[2] ^= src[2];
>                 /* fall through */
>         case 2:
>                 xor_unaligned((u16 *)dst, (u16 *)src);
>                 break;
>         case 1:
>                 dst[0] ^= src[0];
>                 break;
>         }
> }
>
> That would seem like a better choice for small buffers, which seems to be the
> more common case.  It should generate slightly faster code on architectures with
> fast unaligned access like x86_64, while still being sufficient on architectures
> without --- perhaps even faster, since it wouldn't have as many branches.
>

Well, what I tried to deal with explicitly is misaligned dst and src
by, e.g., 4 bytes. In my implementation, the idea was that it would
run through the entire input using 32-bit loads and stores, and the
standard unaligned accessors always take the hit of bytewise accesses
on architectures that don't have hardware support.

But I have an idea how I could simplify this, stay tuned please
