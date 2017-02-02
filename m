From: Ard Biesheuvel <ard.biesheuvel@linaro.org>
Subject: Re: [RFC PATCH v2 4/4] crypto: aes - add generic time invariant AES
 for CTR/CCM/GCM
Date: Thu, 2 Feb 2017 07:48:41 +0000
Message-ID: <CAKv+Gu-0WK7AkgcTsFNUUCeyaafQiWziSuYzY6VEWAPZ41E1ag@mail.gmail.com>
References: <1485646413-17491-1-git-send-email-ard.biesheuvel@linaro.org>
 <1485646413-17491-5-git-send-email-ard.biesheuvel@linaro.org> <20170202073824.GC582@zzz>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Cc: "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org"
        <linux-arm-kernel@lists.infradead.org>,
        Herbert Xu <herbert@gondor.apana.org.au>
To: Eric Biggers <ebiggers3@gmail.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-it0-f45.google.com ([209.85.214.45]:37877 "EHLO
        mail-it0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750871AbdBBHsn (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 2 Feb 2017 02:48:43 -0500
Received: by mail-it0-f45.google.com with SMTP id r185so35785351ita.0
        for <linux-crypto@vger.kernel.org>; Wed, 01 Feb 2017 23:48:42 -0800 (PST)
In-Reply-To: <20170202073824.GC582@zzz>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On 2 February 2017 at 07:38, Eric Biggers <ebiggers3@gmail.com> wrote:
> Hi Ard,
>
> On Sat, Jan 28, 2017 at 11:33:33PM +0000, Ard Biesheuvel wrote:
>>
>> Note that this only implements AES encryption, which is all we need
>> for CTR and CBC-MAC. AES decryption can easily be implemented in a
>> similar way, but is significantly more costly.
>
> Is the expectation of decryption being more costly the only reason why "aes-ti"
> couldn't be a "cipher" algorithm, allowing it to automatically be used by the
> existing templates for CTR, CBC-MAC, CBC, ECB, XTS, CMAC, etc.?

Yes.

> It doesn't seem
> to do anything expensive on a per-block basis like loading SSE registers, so it
> seems it would fit better as a "cipher" algorithm if at all possible.  Then
> there would be no need to implement all these modes yet again.
>

True.

> Also, what would be the feasibility of simply replacing aes-generic with the
> time-invariant implementation, rather than offering two implementations and
> requiring users to choose one, usually without the needed expertise?
>

Well, it is a policy decision whether you want the best performance or
reduced correlation between timing and the input, so there is no way
to make everybody happy by replacing one with the other. But I can
certainly implement is as a cipher, and we can take the discussion
from there.

>> +
>> +/*
>> + * Emit the sbox as __weak with external linkage to prevent the compiler
>> + * from doing constant folding on sbox references involving fixed indexes.
>> + */
>> +__weak const u8 __cacheline_aligned __aesti_sbox[] = {
>
> Did you consider marking it 'volatile' instead?
>

I did not, and I expect the result to be the same. I can replace it if
it matters.

>> +static int aesti_set_key(struct aes_ti_ctx *ctx, const u8 *in_key,
>> +                      unsigned int key_len)
>> +{
>> +     struct crypto_aes_ctx rk;
>> +     int err;
>> +
>> +     err = crypto_aes_expand_key(&rk, in_key, key_len);
>> +     if (err)
>> +             return err;
>
> crypto_aes_expand_key() assumes that the key is u32-aligned; I don't think
> that's guaranteed here.
>

No, I don't think so. AFAICT it expects the round keys to be u32
aligned, which is guaranteed due to the fact that struct
crypto_aes_ctx encapsulates an array of u32

Regards,
Ard.
