Return-Path: <SRS0=VsuX=XG=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8DD66C49ED6
	for <linux-crypto@archiver.kernel.org>; Wed, 11 Sep 2019 16:58:54 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 58BD020872
	for <linux-crypto@archiver.kernel.org>; Wed, 11 Sep 2019 16:58:54 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="yHlWc0Cp"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729334AbfIKQ6x (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Wed, 11 Sep 2019 12:58:53 -0400
Received: from mail-wm1-f66.google.com ([209.85.128.66]:40487 "EHLO
        mail-wm1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729256AbfIKQ6x (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 11 Sep 2019 12:58:53 -0400
Received: by mail-wm1-f66.google.com with SMTP id m3so538515wmc.5
        for <linux-crypto@vger.kernel.org>; Wed, 11 Sep 2019 09:58:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=7lWpf8OyZoq7PA04dqTaHZNXGGj1XQLp2xAJKzHCYwU=;
        b=yHlWc0CpkpCFqBJoLf7v0HxYEwHE8/MarrHZo2gf8uOfXRDDEZZ+UuAvaJHzDblSfK
         fPWiY+qLgNK5+DRL4sEWAUV1fsaK1/jaRaGM6ooxm816XyXt07ybN2XBjlwERo649Pco
         DIKpBKPcR4AqwIs4szTsvNa9MCkjt0wDV3DpvI58SG5xDFtkU14uhjQa0MxSfXnZDHO9
         86Cly6IS29tIK/QIiWC753pYQsk5LTvnQewd7PAqT9a3rAszW1CExa11BsqPo8nhNx6c
         j2HIJv3DKbAhByUW3FMkJnBh7B4AxAOhEvgyGbwd8qxonTKy/ZpWRcTJ1a26I1Zo5s4z
         yIZw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=7lWpf8OyZoq7PA04dqTaHZNXGGj1XQLp2xAJKzHCYwU=;
        b=duHjuauNoVKQVN9N1Di55dsA934Ni1FcFrjM9t0o8KbFuwP8+EDe2QXIwJpnjJ/REE
         rPWKWvRovZeVCoUb85f6O7TDK/AR9nV/oqUdUgOHuQlKXB0SWuSYpmQ2iYanHQIQobP+
         OuMtEfharIUka4gJCr3gg7wlj2c/wv3Zc96+pQhqDY+giiXSKrWTfeSOhy3q5y1yoa/d
         X/JqX95gQx6FQop14M82r6cNq7eK4MigO1oFvHP5WQzZmcQ1CUxJL+jw4qFEwE0uyosh
         rvqZUhj20trId41VQNFu4zdXmfFwD2XlQhN07mJapZHKQSRi+tHUBM7bQCj48Ym1h7K9
         LsZw==
X-Gm-Message-State: APjAAAUvgO9Cd4vZ1cZ7vKfG+fAZIzoiVXElgaI1gdTEjqlLeqR+S6iP
        IpG/ukvuqpYwW16Dj3RHUj7/Gx7xPHP44KicSk73SvtJQch1HQ==
X-Google-Smtp-Source: APXvYqy3mk9v9J33HuZbAL1brLDc5MhtTgViXnT++KCrEk66iUAnX2IjqM0RlwOIW5Ir+ngeXsNvaaLgsNBIy2LKme8=
X-Received: by 2002:a7b:cc86:: with SMTP id p6mr4400619wma.136.1568221130263;
 Wed, 11 Sep 2019 09:58:50 -0700 (PDT)
MIME-Version: 1.0
References: <20190910014205.GA26506@gondor.apana.org.au>
In-Reply-To: <20190910014205.GA26506@gondor.apana.org.au>
From:   Ard Biesheuvel <ard.biesheuvel@linaro.org>
Date:   Wed, 11 Sep 2019 17:58:29 +0100
Message-ID: <CAKv+Gu_1_DSopcZdURpQ=sM73Enc=23WsTUxWN2uJsmenMzhOg@mail.gmail.com>
Subject: Re: [PATCH] crypto: algif_skcipher - Use chunksize instead of blocksize
To:     Herbert Xu <herbert@gondor.apana.org.au>
Cc:     Linux Crypto Mailing List <linux-crypto@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Tue, 10 Sep 2019 at 02:42, Herbert Xu <herbert@gondor.apana.org.au> wrote:
>
> When algif_skcipher does a partial operation it always process data
> that is a multiple of blocksize.  However, for algorithms such as
> CTR this is wrong because even though it can process any number of
> bytes overall, the partial block must come at the very end and not
> in the middle.
>
> This is exactly what chunksize is meant to describe so this patch
> changes blocksize to chunksize.
>
> Fixes: 8ff590903d5f ("crypto: algif_skcipher - User-space...")
> Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>

Acked-by: Ard Biesheuvel <ard.biesheuvel@linaro.org>

>
> diff --git a/crypto/algif_skcipher.c b/crypto/algif_skcipher.c
> index c1601edd70e3..e2c8ab408bed 100644
> --- a/crypto/algif_skcipher.c
> +++ b/crypto/algif_skcipher.c
> @@ -56,7 +56,7 @@ static int _skcipher_recvmsg(struct socket *sock, struct msghdr *msg,
>         struct alg_sock *pask = alg_sk(psk);
>         struct af_alg_ctx *ctx = ask->private;
>         struct crypto_skcipher *tfm = pask->private;
> -       unsigned int bs = crypto_skcipher_blocksize(tfm);
> +       unsigned int bs = crypto_skcipher_chunksize(tfm);
>         struct af_alg_async_req *areq;
>         int err = 0;
>         size_t len = 0;
> diff --git a/include/crypto/internal/skcipher.h b/include/crypto/internal/skcipher.h
> index 734b6f7081b8..3175dfeaed2c 100644
> --- a/include/crypto/internal/skcipher.h
> +++ b/include/crypto/internal/skcipher.h
> @@ -205,19 +205,6 @@ static inline unsigned int crypto_skcipher_alg_max_keysize(
>         return alg->max_keysize;
>  }
>
> -static inline unsigned int crypto_skcipher_alg_chunksize(
> -       struct skcipher_alg *alg)
> -{
> -       if ((alg->base.cra_flags & CRYPTO_ALG_TYPE_MASK) ==
> -           CRYPTO_ALG_TYPE_BLKCIPHER)
> -               return alg->base.cra_blocksize;
> -
> -       if (alg->base.cra_ablkcipher.encrypt)
> -               return alg->base.cra_blocksize;
> -
> -       return alg->chunksize;
> -}
> -
>  static inline unsigned int crypto_skcipher_alg_walksize(
>         struct skcipher_alg *alg)
>  {
> @@ -231,23 +218,6 @@ static inline unsigned int crypto_skcipher_alg_walksize(
>         return alg->walksize;
>  }
>
> -/**
> - * crypto_skcipher_chunksize() - obtain chunk size
> - * @tfm: cipher handle
> - *
> - * The block size is set to one for ciphers such as CTR.  However,
> - * you still need to provide incremental updates in multiples of
> - * the underlying block size as the IV does not have sub-block
> - * granularity.  This is known in this API as the chunk size.
> - *
> - * Return: chunk size in bytes
> - */
> -static inline unsigned int crypto_skcipher_chunksize(
> -       struct crypto_skcipher *tfm)
> -{
> -       return crypto_skcipher_alg_chunksize(crypto_skcipher_alg(tfm));
> -}
> -
>  /**
>   * crypto_skcipher_walksize() - obtain walk size
>   * @tfm: cipher handle
> diff --git a/include/crypto/skcipher.h b/include/crypto/skcipher.h
> index 37c164234d97..aada87916918 100644
> --- a/include/crypto/skcipher.h
> +++ b/include/crypto/skcipher.h
> @@ -304,6 +304,36 @@ static inline unsigned int crypto_skcipher_blocksize(
>         return crypto_tfm_alg_blocksize(crypto_skcipher_tfm(tfm));
>  }
>
> +static inline unsigned int crypto_skcipher_alg_chunksize(
> +       struct skcipher_alg *alg)
> +{
> +       if ((alg->base.cra_flags & CRYPTO_ALG_TYPE_MASK) ==
> +           CRYPTO_ALG_TYPE_BLKCIPHER)
> +               return alg->base.cra_blocksize;
> +
> +       if (alg->base.cra_ablkcipher.encrypt)
> +               return alg->base.cra_blocksize;
> +
> +       return alg->chunksize;
> +}
> +
> +/**
> + * crypto_skcipher_chunksize() - obtain chunk size
> + * @tfm: cipher handle
> + *
> + * The block size is set to one for ciphers such as CTR.  However,
> + * you still need to provide incremental updates in multiples of
> + * the underlying block size as the IV does not have sub-block
> + * granularity.  This is known in this API as the chunk size.
> + *
> + * Return: chunk size in bytes
> + */
> +static inline unsigned int crypto_skcipher_chunksize(
> +       struct crypto_skcipher *tfm)
> +{
> +       return crypto_skcipher_alg_chunksize(crypto_skcipher_alg(tfm));
> +}
> +
>  static inline unsigned int crypto_sync_skcipher_blocksize(
>         struct crypto_sync_skcipher *tfm)
>  {
> --
> Email: Herbert Xu <herbert@gondor.apana.org.au>
> Home Page: http://gondor.apana.org.au/~herbert/
> PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
