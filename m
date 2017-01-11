From: Ard Biesheuvel <ard.biesheuvel@linaro.org>
Subject: Re: [PATCH v2] crypto: x86/chacha20 - Manually align stack buffer
Date: Wed, 11 Jan 2017 12:31:02 +0000
Message-ID: <CAKv+Gu_W3K6k5d--PZ4v0i4u1xcbL2O_ZDBjNgcmUA3-PgfLgQ@mail.gmail.com>
References: <20170111120816.GA9004@gondor.apana.org.au> <CAKv+Gu9tQu_Tq6LR+ie-qFdEmh2We3ZxAMbX7rVHmsa4K+rqUA@mail.gmail.com>
 <20170111122806.GA9056@gondor.apana.org.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Cc: Linux Crypto Mailing List <linux-crypto@vger.kernel.org>
To: Herbert Xu <herbert@gondor.apana.org.au>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-io0-f176.google.com ([209.85.223.176]:36748 "EHLO
        mail-io0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750924AbdAKMbE (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 11 Jan 2017 07:31:04 -0500
Received: by mail-io0-f176.google.com with SMTP id j13so73826270iod.3
        for <linux-crypto@vger.kernel.org>; Wed, 11 Jan 2017 04:31:04 -0800 (PST)
In-Reply-To: <20170111122806.GA9056@gondor.apana.org.au>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On 11 January 2017 at 12:28, Herbert Xu <herbert@gondor.apana.org.au> wrote:
> On Wed, Jan 11, 2017 at 12:14:24PM +0000, Ard Biesheuvel wrote:
>>
>> I think the old code was fine, actually:
>>
>> u32 *state, state_buf[16 + (CHACHA20_STATE_ALIGN / sizeof(u32)) - 1];
>>
>> ends up allocating 16 + 3 *words* == 64 + 12 bytes , which given the
>> guaranteed 4 byte alignment is sufficient for ensuring the pointer can
>> be 16 byte aligned.
>
> Ah yes you're right, it's a u32.
>
>> So [16 + 2] should be sufficient here
>
> Here's an updated version.
>
> ---8<---
> The kernel on x86-64 cannot use gcc attribute align to align to
> a 16-byte boundary.  This patch reverts to the old way of aligning
> it by hand.
>
> Fixes: 9ae433bc79f9 ("crypto: chacha20 - convert generic and...")
> Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
>
> diff --git a/arch/x86/crypto/chacha20_glue.c b/arch/x86/crypto/chacha20_glue.c
> index 78f75b0..1e6af1b 100644
> --- a/arch/x86/crypto/chacha20_glue.c
> +++ b/arch/x86/crypto/chacha20_glue.c
> @@ -67,10 +67,13 @@ static int chacha20_simd(struct skcipher_request *req)
>  {
>         struct crypto_skcipher *tfm = crypto_skcipher_reqtfm(req);
>         struct chacha20_ctx *ctx = crypto_skcipher_ctx(tfm);
> -       u32 state[16] __aligned(CHACHA20_STATE_ALIGN);
> +       u32 *state, state_buf[16 + 2] __aligned(8);
>         struct skcipher_walk walk;
>         int err;
>
> +       BUILD_BUG_ON(CHACHA20_STATE_ALIGN != 16);
> +       state = PTR_ALIGN(state_buf + 0, CHACHA20_STATE_ALIGN);
> +
>         if (req->cryptlen <= CHACHA20_BLOCK_SIZE || !may_use_simd())
>                 return crypto_chacha20_crypt(req);
>

Reviewed-by: Ard Biesheuvel <ard.biesheuvel@linaro.org>
