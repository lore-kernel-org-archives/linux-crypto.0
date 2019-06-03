Return-Path: <SRS0=YB2u=UC=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 929BEC04AB6
	for <linux-crypto@archiver.kernel.org>; Mon,  3 Jun 2019 06:50:35 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 5D58826E66
	for <linux-crypto@archiver.kernel.org>; Mon,  3 Jun 2019 06:50:35 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="Cq+jJelV"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726713AbfFCGue (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Mon, 3 Jun 2019 02:50:34 -0400
Received: from mail-it1-f194.google.com ([209.85.166.194]:50358 "EHLO
        mail-it1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726383AbfFCGue (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 3 Jun 2019 02:50:34 -0400
Received: by mail-it1-f194.google.com with SMTP id a186so25610717itg.0
        for <linux-crypto@vger.kernel.org>; Sun, 02 Jun 2019 23:50:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=hHb5yojwbJQybGGvYA68Ct0nFyRWaeQ/WiYQHJZyD7Q=;
        b=Cq+jJelVNt8/fYGOSR3WUB3xk3jG9SZNoT5EDMh1U0hFm7FT6yHo8eXnrBuWGmaAOQ
         bu+v5pLwv6BDE1TXVKcyEpANxoKEvYp8jTIU3lP5LYbycbkqEk8AdQXvh/wzygOXImk1
         IfAj0RVvRwEuieJ6fDPzjp1l/bGPv+SBj0UJapFC1ATyxxtgldeBmBFF9CgjsTgtbtO2
         WaIeXwyY9RDVpkiWOE/oqWuRi88bJ0j7+lUbgi3MWuRfFQcq1A+4r3MOcSe4p2v5OIon
         bKWfs00jEvJGpiuR/r8tCoXFwDIkYYnwYo/mSNF0eGs/cFvUE8+DQ0nBhIk+ZR9iLqx7
         g5NQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=hHb5yojwbJQybGGvYA68Ct0nFyRWaeQ/WiYQHJZyD7Q=;
        b=IrFDUYKeMgrSyhHOIWAVae75DFMb5aED7heiQqjVjrs9JStRtFyAbt7EovZhW8wgR5
         VuiNPprPrgptyHLhHJlG3uF4eXpEgluSFXOXDxv4MvoApakP7UP9UNp4zMp8hh3UCWR6
         KWxdyTbljmCy4CxgOLub5+ECv63q+uPQ9spqq/cEDjLekjk17mFWxrwu1vnmN2tyLM9e
         vnxKZ7ZxkdouwB0imt7UsK8L8CfuXXn0rnUntCB14MlNz25oJA+jbM0/U9hnok+MU4AG
         C28lWoby23DELU4ziU0/+/4g1Ej5h76mWKWTk/jfBZJy0cArBoy4sBqzFCrcWUOkEwHv
         7gLA==
X-Gm-Message-State: APjAAAUi9e2ChEjLf6SiEdgC+RUwwxRKIROF7UaCf+Qac+KB1JDXXAfp
        72UWrpmkw0hZU33CEanFTCVkrdI0+lWRU1BewTkXhnBgkIXFxUor
X-Google-Smtp-Source: APXvYqwGZR7gFadVGuFWYfuTcv6x2YK32pm/1lbg6JHiLUs7e/dHAkowy7DmfxeoxWbrmG58eetORpoQlVNYkbPtDeE=
X-Received: by 2002:a24:740f:: with SMTP id o15mr59943itc.76.1559544633310;
 Sun, 02 Jun 2019 23:50:33 -0700 (PDT)
MIME-Version: 1.0
References: <20190603054450.5993-1-ebiggers@kernel.org>
In-Reply-To: <20190603054450.5993-1-ebiggers@kernel.org>
From:   Ard Biesheuvel <ard.biesheuvel@linaro.org>
Date:   Mon, 3 Jun 2019 08:50:20 +0200
Message-ID: <CAKv+Gu8dUTKwYDR7uNHSBaPp_Xf8gj7zP_wCDdHthRX6uTfDSQ@mail.gmail.com>
Subject: Re: [PATCH] crypto: x86/aesni - remove unused internal cipher algorithm
To:     Eric Biggers <ebiggers@kernel.org>
Cc:     "open list:HARDWARE RANDOM NUMBER GENERATOR CORE" 
        <linux-crypto@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Mon, 3 Jun 2019 at 07:45, Eric Biggers <ebiggers@kernel.org> wrote:
>
> From: Eric Biggers <ebiggers@google.com>
>
> Since commit 944585a64f5e ("crypto: x86/aes-ni - remove special handling
> of AES in PCBC mode"), the "__aes-aesni" internal cipher algorithm is no
> longer used.  So remove it too.
>
> Signed-off-by: Eric Biggers <ebiggers@google.com>

Acked-by: Ard Biesheuvel <ard.biesheuvel@linaro.org>

> ---
>  arch/x86/crypto/aesni-intel_glue.c | 45 +++++-------------------------
>  1 file changed, 7 insertions(+), 38 deletions(-)
>
> diff --git a/arch/x86/crypto/aesni-intel_glue.c b/arch/x86/crypto/aesni-intel_glue.c
> index 21c246799aa58..c95bd397dc076 100644
> --- a/arch/x86/crypto/aesni-intel_glue.c
> +++ b/arch/x86/crypto/aesni-intel_glue.c
> @@ -375,20 +375,6 @@ static void aes_decrypt(struct crypto_tfm *tfm, u8 *dst, const u8 *src)
>         }
>  }
>
> -static void __aes_encrypt(struct crypto_tfm *tfm, u8 *dst, const u8 *src)
> -{
> -       struct crypto_aes_ctx *ctx = aes_ctx(crypto_tfm_ctx(tfm));
> -
> -       aesni_enc(ctx, dst, src);
> -}
> -
> -static void __aes_decrypt(struct crypto_tfm *tfm, u8 *dst, const u8 *src)
> -{
> -       struct crypto_aes_ctx *ctx = aes_ctx(crypto_tfm_ctx(tfm));
> -
> -       aesni_dec(ctx, dst, src);
> -}
> -
>  static int aesni_skcipher_setkey(struct crypto_skcipher *tfm, const u8 *key,
>                                  unsigned int len)
>  {
> @@ -924,7 +910,7 @@ static int helper_rfc4106_decrypt(struct aead_request *req)
>  }
>  #endif
>
> -static struct crypto_alg aesni_algs[] = { {
> +static struct crypto_alg aesni_cipher_alg = {
>         .cra_name               = "aes",
>         .cra_driver_name        = "aes-aesni",
>         .cra_priority           = 300,
> @@ -941,24 +927,7 @@ static struct crypto_alg aesni_algs[] = { {
>                         .cia_decrypt            = aes_decrypt
>                 }
>         }
> -}, {
> -       .cra_name               = "__aes",
> -       .cra_driver_name        = "__aes-aesni",
> -       .cra_priority           = 300,
> -       .cra_flags              = CRYPTO_ALG_TYPE_CIPHER | CRYPTO_ALG_INTERNAL,
> -       .cra_blocksize          = AES_BLOCK_SIZE,
> -       .cra_ctxsize            = CRYPTO_AES_CTX_SIZE,
> -       .cra_module             = THIS_MODULE,
> -       .cra_u  = {
> -               .cipher = {
> -                       .cia_min_keysize        = AES_MIN_KEY_SIZE,
> -                       .cia_max_keysize        = AES_MAX_KEY_SIZE,
> -                       .cia_setkey             = aes_set_key,
> -                       .cia_encrypt            = __aes_encrypt,
> -                       .cia_decrypt            = __aes_decrypt
> -               }
> -       }
> -} };
> +};
>
>  static struct skcipher_alg aesni_skciphers[] = {
>         {
> @@ -1154,7 +1123,7 @@ static int __init aesni_init(void)
>  #endif
>  #endif
>
> -       err = crypto_register_algs(aesni_algs, ARRAY_SIZE(aesni_algs));
> +       err = crypto_register_alg(&aesni_cipher_alg);
>         if (err)
>                 return err;
>
> @@ -1162,7 +1131,7 @@ static int __init aesni_init(void)
>                                              ARRAY_SIZE(aesni_skciphers),
>                                              aesni_simd_skciphers);
>         if (err)
> -               goto unregister_algs;
> +               goto unregister_cipher;
>
>         err = simd_register_aeads_compat(aesni_aeads, ARRAY_SIZE(aesni_aeads),
>                                          aesni_simd_aeads);
> @@ -1174,8 +1143,8 @@ static int __init aesni_init(void)
>  unregister_skciphers:
>         simd_unregister_skciphers(aesni_skciphers, ARRAY_SIZE(aesni_skciphers),
>                                   aesni_simd_skciphers);
> -unregister_algs:
> -       crypto_unregister_algs(aesni_algs, ARRAY_SIZE(aesni_algs));
> +unregister_cipher:
> +       crypto_unregister_alg(&aesni_cipher_alg);
>         return err;
>  }
>
> @@ -1185,7 +1154,7 @@ static void __exit aesni_exit(void)
>                               aesni_simd_aeads);
>         simd_unregister_skciphers(aesni_skciphers, ARRAY_SIZE(aesni_skciphers),
>                                   aesni_simd_skciphers);
> -       crypto_unregister_algs(aesni_algs, ARRAY_SIZE(aesni_algs));
> +       crypto_unregister_alg(&aesni_cipher_alg);
>  }
>
>  late_initcall(aesni_init);
> --
> 2.21.0
>
