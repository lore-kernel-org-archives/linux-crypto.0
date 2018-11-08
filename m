Return-Path: <SRS0=HYoH=NT=vger.kernel.org=linux-crypto-owner@kernel.org>
Received: from mail-it1-f193.google.com ([209.85.166.193]:51758 "EHLO
        mail-it1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726926AbeKIJLR (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 9 Nov 2018 04:11:17 -0500
Received: by mail-it1-f193.google.com with SMTP id m34-v6so705433iti.1
        for <linux-crypto@vger.kernel.org>; Thu, 08 Nov 2018 15:33:24 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <20181108225516.9967-1-ard.biesheuvel@linaro.org>
References: <20181108225516.9967-1-ard.biesheuvel@linaro.org>
From: Ard Biesheuvel <ard.biesheuvel@linaro.org>
Date: Fri, 9 Nov 2018 00:33:23 +0100
Message-ID: <CAKv+Gu_7M+A5OiCOsOd7_e5+GH7VkrOZ33iSexd2oacyzUNKEA@mail.gmail.com>
Subject: Re: [PATCH] crypto/simd: correctly take reqsize of wrapped skcipher
 into account
To: "open list:HARDWARE RANDOM NUMBER GENERATOR CORE"
        <linux-crypto@vger.kernel.org>
Cc: Herbert Xu <herbert@gondor.apana.org.au>, Qian Cai <cai@gmx.us>,
        Ard Biesheuvel <ard.biesheuvel@linaro.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On 8 November 2018 at 23:55, Ard Biesheuvel <ard.biesheuvel@linaro.org> wrote:
> The simd wrapper's skcipher request context structure consists
> of a single subrequest whose size is taken from the subordinate
> skcipher. However, in simd_skcipher_init(), the reqsize that is
> retrieved is not from the subordinate skcipher but from the
> cryptd request structure, whose size is completely unrelated to
> the actual wrapped skcipher.
>
> Reported-by: Qian Cai <cai@gmx.us>
> Signed-off-by: Ard Biesheuvel <ard.biesheuvel@linaro.org>
> ---
>  crypto/simd.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/crypto/simd.c b/crypto/simd.c
> index ea7240be3001..2f3d6e897afc 100644
> --- a/crypto/simd.c
> +++ b/crypto/simd.c
> @@ -125,7 +125,7 @@ static int simd_skcipher_init(struct crypto_skcipher *tfm)
>         ctx->cryptd_tfm = cryptd_tfm;
>
>         reqsize = sizeof(struct skcipher_request);
> -       reqsize += crypto_skcipher_reqsize(&cryptd_tfm->base);
> +       reqsize += crypto_skcipher_reqsize(cryptd_skcipher_child(cryptd_tfm));
>

This should be

reqsize += max(crypto_skcipher_reqsize(&cryptd_tfm->base);
       crypto_skcipher_reqsize(cryptd_skcipher_child(cryptd_tfm)));

since the cryptd path in simd still needs some space in the subreq for
the completion.
