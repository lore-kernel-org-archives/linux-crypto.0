From: Ard Biesheuvel <ard.biesheuvel@linaro.org>
Subject: Re: crypto: x86/chacha20 - Manually align stack buffer
Date: Wed, 11 Jan 2017 12:14:24 +0000
Message-ID: <CAKv+Gu9tQu_Tq6LR+ie-qFdEmh2We3ZxAMbX7rVHmsa4K+rqUA@mail.gmail.com>
References: <20170111120816.GA9004@gondor.apana.org.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Cc: Linux Crypto Mailing List <linux-crypto@vger.kernel.org>
To: Herbert Xu <herbert@gondor.apana.org.au>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-it0-f51.google.com ([209.85.214.51]:38872 "EHLO
        mail-it0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750898AbdAKMOZ (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 11 Jan 2017 07:14:25 -0500
Received: by mail-it0-f51.google.com with SMTP id x2so111637303itf.1
        for <linux-crypto@vger.kernel.org>; Wed, 11 Jan 2017 04:14:25 -0800 (PST)
In-Reply-To: <20170111120816.GA9004@gondor.apana.org.au>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On 11 January 2017 at 12:08, Herbert Xu <herbert@gondor.apana.org.au> wrote:
> The kernel on x86-64 cannot use gcc attribute align to align to
> a 16-byte boundary.  This patch reverts to the old way of aligning
> it by hand.
>
> Incidentally the old way was actually broken in not allocating
> enough space and would silently corrupt the stack.  This patch
> fixes it by allocating an extra 8 bytes.
>

I think the old code was fine, actually:

u32 *state, state_buf[16 + (CHACHA20_STATE_ALIGN / sizeof(u32)) - 1];

ends up allocating 16 + 3 *words* == 64 + 12 bytes , which given the
guaranteed 4 byte alignment is sufficient for ensuring the pointer can
be 16 byte aligned.

So [16 + 2] should be sufficient here

> Fixes: 9ae433bc79f9 ("crypto: chacha20 - convert generic and...")
> Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
>
> diff --git a/arch/x86/crypto/chacha20_glue.c b/arch/x86/crypto/chacha20_glue.c
> index 78f75b0..054306d 100644
> --- a/arch/x86/crypto/chacha20_glue.c
> +++ b/arch/x86/crypto/chacha20_glue.c
> @@ -67,10 +67,13 @@ static int chacha20_simd(struct skcipher_request *req)
>  {
>         struct crypto_skcipher *tfm = crypto_skcipher_reqtfm(req);
>         struct chacha20_ctx *ctx = crypto_skcipher_ctx(tfm);
> -       u32 state[16] __aligned(CHACHA20_STATE_ALIGN);
> +       u32 *state, state_buf[16 + 8] __aligned(8);
>         struct skcipher_walk walk;
>         int err;
>
> +       BUILD_BUG_ON(CHACHA20_STATE_ALIGN != 16);
> +       state = PTR_ALIGN(state_buf + 0, CHACHA20_STATE_ALIGN);
> +
>         if (req->cryptlen <= CHACHA20_BLOCK_SIZE || !may_use_simd())
>                 return crypto_chacha20_crypt(req);
>
> --
> Email: Herbert Xu <herbert@gondor.apana.org.au>
> Home Page: http://gondor.apana.org.au/~herbert/
> PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
