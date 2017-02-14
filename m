From: Ard Biesheuvel <ard.biesheuvel@linaro.org>
Subject: Re: [PATCH v3] crypto: algapi - make crypto_xor() and crypto_inc()
 alignment agnostic
Date: Tue, 14 Feb 2017 09:24:15 +0000
Message-ID: <CAKv+Gu987iQawZjKFkOYavMvOBpPb1tK-iTc8B5RWuNQ2Knmpw@mail.gmail.com>
References: <1486289172-18604-1-git-send-email-ard.biesheuvel@linaro.org> <CAHmME9o9Rg2bcb1dibAyTUCSYGuzicSU__62P_G9G8ARJkgs=Q@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Cc: Linux Crypto Mailing List <linux-crypto@vger.kernel.org>,
        Eric Biggers <ebiggers3@gmail.com>,
        Herbert Xu <herbert@gondor.apana.org.au>
To: "Jason A. Donenfeld" <Jason@zx2c4.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-it0-f49.google.com ([209.85.214.49]:36478 "EHLO
        mail-it0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752923AbdBNJYV (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 14 Feb 2017 04:24:21 -0500
Received: by mail-it0-f49.google.com with SMTP id c7so28076152itd.1
        for <linux-crypto@vger.kernel.org>; Tue, 14 Feb 2017 01:24:21 -0800 (PST)
In-Reply-To: <CAHmME9o9Rg2bcb1dibAyTUCSYGuzicSU__62P_G9G8ARJkgs=Q@mail.gmail.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On 13 February 2017 at 21:55, Jason A. Donenfeld <Jason@zx2c4.com> wrote:
> On Sun, Feb 5, 2017 at 11:06 AM, Ard Biesheuvel
> <ard.biesheuvel@linaro.org> wrote:
>> +       if (IS_ENABLED(CONFIG_HAVE_EFFICIENT_UNALIGNED_ACCESS) ||
>> +           !((unsigned long)b & (__alignof__(*b) - 1)))
>
> Why not simply use the IS_ALIGNED macro?
>

Good point.

> Also, are you might consider checking to see if this is a constant, so
> that you can avoid an unnecessary branch.

Check if what is a constant? The buffer address?

> Alternatively, if you want
> to use the branch, I'd be interested in you writing back saying, "I
> tested both cases, and branching is faster than always using the slow
> unaligned path."

When using the 4-byte wide path, the loop terminates after 1 iteration
unless there is a carry in the low word. The likelihood of the loop
iterating multiple times in the 1-byte wide path is 1 in 256.

I suppose we could add this if there is concern about the branching

diff --git a/crypto/algapi.c b/crypto/algapi.c
index 6b52e8f0b95f..03670390a2e4 100644
--- a/crypto/algapi.c
+++ b/crypto/algapi.c
@@ -967,7 +967,7 @@ void crypto_inc(u8 *a, unsigned int size)
                for (; size >= 4; size -= 4) {
                        c = be32_to_cpu(*--b) + 1;
                        *b = cpu_to_be32(c);
-                       if (c)
+                       if (likely(c))
                                return;
                }

but other than that, I see little reason to introduce complicated logic here.


>> +               while (((unsigned long)dst & (relalign - 1)) && len > 0) {
>
> IS_ALIGNED
>
>> +static inline void crypto_xor(u8 *dst, const u8 *src, unsigned int size)
>> +{
>> +       if (IS_ENABLED(CONFIG_HAVE_EFFICIENT_UNALIGNED_ACCESS) &&
>> +           __builtin_constant_p(size) &&
>> +           (size % sizeof(unsigned long)) == 0) {
>
> You can expand this condition to be:
>
> if ( (is_constant(size) && size%sizeof(ulong)==0) &&
> (efficient_unaligned || (is_constant(dst) && is_constant(src) &&
> is_aligned(dst) && is_aligned(src))) )
>
> It might seem complex, but it all gets compiled out.

Care to explain how? Could you point me to any references to
crypto_xor() where either of the buffer addresses are compile time
(not link time) constants?
