From: Ard Biesheuvel <ard.biesheuvel@linaro.org>
Subject: Re: [PATCH v2] crypto: algapi - make crypto_xor() and crypto_inc()
 alignment agnostic
Date: Sat, 4 Feb 2017 21:49:15 +0000
Message-ID: <CAKv+Gu9Jc0ESEaVy8cgqAZRbdfnwN-+TrjAqvOoGOqkPz=jqEQ@mail.gmail.com>
References: <1486050988-20407-1-git-send-email-ard.biesheuvel@linaro.org> <20170204212038.GA5621@zzz>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Cc: "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>,
        Herbert Xu <herbert@gondor.apana.org.au>
To: Eric Biggers <ebiggers3@gmail.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-it0-f49.google.com ([209.85.214.49]:33443 "EHLO
        mail-it0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751084AbdBDVtQ (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Sat, 4 Feb 2017 16:49:16 -0500
Received: by mail-it0-f49.google.com with SMTP id d9so15208593itc.0
        for <linux-crypto@vger.kernel.org>; Sat, 04 Feb 2017 13:49:16 -0800 (PST)
In-Reply-To: <20170204212038.GA5621@zzz>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On 4 February 2017 at 21:20, Eric Biggers <ebiggers3@gmail.com> wrote:
> Hi Ard,
>
> On Thu, Feb 02, 2017 at 03:56:28PM +0000, Ard Biesheuvel wrote:
>> +     const int size = sizeof(unsigned long);
>> +     int delta = ((unsigned long)dst ^ (unsigned long)src) & (size - 1);
>> +     int misalign = 0;
>> +
>> +     if (!IS_ENABLED(CONFIG_HAVE_EFFICIENT_UNALIGNED_ACCESS) && delta) {
>> +             misalign = 1 << __ffs(delta);
>> +
>> +             /*
>> +              * If we care about alignment, process as many bytes as
>> +              * needed to advance dst and src to values whose alignments
>> +              * equal their relative misalignment. This will allow us to
>> +              * process the remainder of the input using optimal strides.
>> +              */
>> +             while (((unsigned long)dst & (misalign - 1)) && len > 0) {
>> +                     *dst++ ^= *src++;
>> +                     len--;
>> +             }
>> +     }
>>
>> +     while (len >= size && !misalign) {
>> +             *(unsigned long *)dst ^= *(unsigned long *)src;
>> +             dst += size;
>> +             src += size;
>> +             len -= size;
>> +     }
>>
>
> Unfortunately this is still broken, for two different reasons.  First, if the
> pointers have the same relative misalignment, then 'delta' and 'misalign' will
> be set to 0 and long accesses will be used, even though the pointers may
> actually be misaligned, e.g. 0x80000001 and 0x90000001.

In this case, the initial loop should run 7 times, but it obviously does not :-(

>  Second, if the pointers
> have a relative misalignent that is not a power-of-2, then 'misalign' will be
> set to the wrong value.  For example, with delta=3, it's actually only safe to
> do byte accesses, but the code will set misalign=2 and do u16 accesses.
>

As you realised, delta == 3 results in misalign == 1, which I think
does the right thing (module the initial loop which is incorrect)

> I kind of liked the version with put_unaligned/get_unaligned (and it seems to
> perform okay on MIPS, though not on ARM which is probably more important).

The reason I don't like the _unaligned() accessors is because they
take the performance hit regardless of whether the pointer is aligned
or not.

>  But
> if the various cases with !CONFIG_HAVE_EFFICIENT_UNALIGNED_ACCESS are going to
> be handled/optimized I think they will just need to be separated out, maybe
> something like this:
>
> void crypto_xor(u8 *dst, const u8 *src, unsigned int len)
> {
> #ifndef CONFIG_HAVE_EFFICIENT_UNALIGNED_ACCESS
>         unsigned long delta;
>
>         if (((unsigned long)dst | (unsigned long)src | len) %
>             sizeof(unsigned long) == 0) {
>                 /* fast path: everything is aligned, including len */
>                 while (len >= sizeof(unsigned long)) {
>                         *(unsigned long *)dst ^= *(unsigned long *)src;
>                         dst += sizeof(unsigned long);
>                         src += sizeof(unsigned long);
>                         len -= sizeof(unsigned long);
>                 }
>                 return;
>         }
>
>         /* handle relative misalignment */
>         delta = (unsigned long)dst ^ (unsigned long)src;
>         if (delta % sizeof(unsigned long)) {
>
>                 /* 1-byte relative misalignment: do byte accesses */
>                 if (delta & 1) {
>                         while (len--)
>                                 *dst++ ^= *src++;
>                         return;
>                 }
>
>                 /* 2-byte relative misalignment: do u16 accesses */
>                 if ((delta & 2) || sizeof(unsigned long) == 4) {
>                         if ((unsigned long)dst % 2 && len) {
>                                 *dst++ ^= *src++;
>                                 len--;
>                         }
>                         while (len >= 2) {
>                                 *(u16 *)dst ^= *(u16 *)src;
>                                 dst += 2, src += 2, len -= 2;
>                         }
>                         if (len)
>                                 *dst ^= *src;
>                         return;
>                 }
>
>                 /* 4-byte relative misalignment: do u32 accesses */
>                 while ((unsigned long)dst % 4 && len) {
>                         *dst++ ^= *src++;
>                         len--;
>                 }
>                 while (len >= 4) {
>                         *(u32 *)dst ^= *(u32 *)src;
>                         dst += 4, src += 4, len -= 4;
>                 }
>                 while (len--)
>                         *dst++ ^= *src++;
>                 return;
>         }
>
>         /* handle absolute misalignment */
>         while ((unsigned long)dst % sizeof(unsigned long) && len) {
>                 *dst++ ^= *src++;
>                 len--;
>         }
> #endif /* !CONFIG_HAVE_EFFICIENT_UNALIGNED_ACCESS */
>
>         while (len >= sizeof(unsigned long)) {
>                 *(unsigned long *)dst ^= *(unsigned long *)src;
>                 dst += sizeof(unsigned long);
>                 src += sizeof(unsigned long);
>                 len -= sizeof(unsigned long);
>         }
>
>         while (len--)
>                 *dst++ ^= *src++;
> }
