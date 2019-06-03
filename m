Return-Path: <SRS0=YB2u=UC=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 24260C04AB6
	for <linux-crypto@archiver.kernel.org>; Mon,  3 Jun 2019 06:48:53 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id EC1A4263A6
	for <linux-crypto@archiver.kernel.org>; Mon,  3 Jun 2019 06:48:52 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="R5ycCceA"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727074AbfFCGsw (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Mon, 3 Jun 2019 02:48:52 -0400
Received: from mail-io1-f67.google.com ([209.85.166.67]:44416 "EHLO
        mail-io1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727057AbfFCGsw (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 3 Jun 2019 02:48:52 -0400
Received: by mail-io1-f67.google.com with SMTP id s7so6035791iob.11
        for <linux-crypto@vger.kernel.org>; Sun, 02 Jun 2019 23:48:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=1x53BZDVIaKk4LjF6Xa0/7D/gWNAk35BIYzi+JwlUCA=;
        b=R5ycCceA75lB6srSDSAW9RaAXHbada4AbHqC+PQq/4qF+I+X+hKGdaPe6Sxulk714l
         r1yZKE1+eay89hCYB1LrDpUu2VdYxb7kI1HRBOcslz2IT9dqNHD39ICJjkZ3tByp3el5
         X+tmCfgB8Z0hWqaiRoqUQoaPAxjNPLCco3M82OF8FsQsvT/dVA+ehG2zdBnHFKqr+H09
         aOpfwdn7OzPXL8gy81p+u3hrYB8Mgd/uI1rNHEayLrx0WHEnWBPVcZtA/wLd7ObdLNoL
         IDHna7nvgCzKNziMFfg2MrmUoTujSwASWyDDJHU6FxQvE7JpKnZHHc2klBlQ7XSyLsJO
         +/aQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=1x53BZDVIaKk4LjF6Xa0/7D/gWNAk35BIYzi+JwlUCA=;
        b=EpoCWziiQNjIMbgzY1WcpYUNPOXGxTTSAHDxUo7jF3PIVYACvFeK53KoBblyBU9dag
         w/47aW9purYJNlP2fRlnDB4li9u0Yz7wXXkVq94bsSmae+uTosEiECXY2PKvuu7Z3dx2
         ffkJafvZ3Mt8qn6/lUSADamwJbiX7btrrUho1j+x4tiUsH0vrtnYjqfXmG4NksIYF08T
         CbPwfCqyI+War1G6Mo2w0H3aUA9KCj1Ub1YqGesUmGfHRu2zBIRVuObYBS3FgbeJwPO6
         rUBomkkbuEO0a5TCL8PNy2xY49AqLVOrrBlsBDfou3FKajoxYh21CSMy4DH12wxSquNo
         8+YQ==
X-Gm-Message-State: APjAAAWcRRTeduHfGj55GiUAM3CJ5megzp/j+QYXH5J0p/KolkIPFPAk
        zSQ874hazjSVJBTmhm9VMPRGi7jwJplUuXIhziKMo+zFlNXka8s7
X-Google-Smtp-Source: APXvYqxKjrGbswYDZDBayC/U6hpIqap3Mp+qD3XlSDRJcvm7vQ0rdscpvrDZyGwQ0gDltE0QjQEppO7dDixM8Nznxdg=
X-Received: by 2002:a5d:9d83:: with SMTP id 3mr13829285ion.65.1559544531316;
 Sun, 02 Jun 2019 23:48:51 -0700 (PDT)
MIME-Version: 1.0
References: <20190603054611.6257-1-ebiggers@kernel.org>
In-Reply-To: <20190603054611.6257-1-ebiggers@kernel.org>
From:   Ard Biesheuvel <ard.biesheuvel@linaro.org>
Date:   Mon, 3 Jun 2019 08:48:39 +0200
Message-ID: <CAKv+Gu_u8Kc4KHGWq_8Mn2yu3+ROG_wCVj4xaradZBa2YQB7bQ@mail.gmail.com>
Subject: Re: [PATCH] crypto: skcipher - make chunksize and walksize accessors internal
To:     Eric Biggers <ebiggers@kernel.org>
Cc:     "open list:HARDWARE RANDOM NUMBER GENERATOR CORE" 
        <linux-crypto@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Mon, 3 Jun 2019 at 07:46, Eric Biggers <ebiggers@kernel.org> wrote:
>
> From: Eric Biggers <ebiggers@google.com>
>
> The 'chunksize' and 'walksize' properties of skcipher algorithms are
> implementation details that users of the skcipher API should not be
> looking at.  So move their accessor functions from <crypto/skcipher.h>
> to <crypto/internal/skcipher.h>.
>
> Signed-off-by: Eric Biggers <ebiggers@google.com>

Acked-by: Ard Biesheuvel <ard.biesheuvel@linaro.org>

> ---
>  include/crypto/internal/skcipher.h | 60 ++++++++++++++++++++++++++++++
>  include/crypto/skcipher.h          | 60 ------------------------------
>  2 files changed, 60 insertions(+), 60 deletions(-)
>
> diff --git a/include/crypto/internal/skcipher.h b/include/crypto/internal/skcipher.h
> index 9de6032209cb1..abb1096495c2f 100644
> --- a/include/crypto/internal/skcipher.h
> +++ b/include/crypto/internal/skcipher.h
> @@ -205,6 +205,66 @@ static inline unsigned int crypto_skcipher_alg_max_keysize(
>         return alg->max_keysize;
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
> +static inline unsigned int crypto_skcipher_alg_walksize(
> +       struct skcipher_alg *alg)
> +{
> +       if ((alg->base.cra_flags & CRYPTO_ALG_TYPE_MASK) ==
> +           CRYPTO_ALG_TYPE_BLKCIPHER)
> +               return alg->base.cra_blocksize;
> +
> +       if (alg->base.cra_ablkcipher.encrypt)
> +               return alg->base.cra_blocksize;
> +
> +       return alg->walksize;
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
> +/**
> + * crypto_skcipher_walksize() - obtain walk size
> + * @tfm: cipher handle
> + *
> + * In some cases, algorithms can only perform optimally when operating on
> + * multiple blocks in parallel. This is reflected by the walksize, which
> + * must be a multiple of the chunksize (or equal if the concern does not
> + * apply)
> + *
> + * Return: walk size in bytes
> + */
> +static inline unsigned int crypto_skcipher_walksize(
> +       struct crypto_skcipher *tfm)
> +{
> +       return crypto_skcipher_alg_walksize(crypto_skcipher_alg(tfm));
> +}
> +
>  /* Helpers for simple block cipher modes of operation */
>  struct skcipher_ctx_simple {
>         struct crypto_cipher *cipher;   /* underlying block cipher */
> diff --git a/include/crypto/skcipher.h b/include/crypto/skcipher.h
> index 98547d1f18c53..694397fb0faab 100644
> --- a/include/crypto/skcipher.h
> +++ b/include/crypto/skcipher.h
> @@ -293,66 +293,6 @@ static inline unsigned int crypto_sync_skcipher_ivsize(
>         return crypto_skcipher_ivsize(&tfm->base);
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
> -static inline unsigned int crypto_skcipher_alg_walksize(
> -       struct skcipher_alg *alg)
> -{
> -       if ((alg->base.cra_flags & CRYPTO_ALG_TYPE_MASK) ==
> -           CRYPTO_ALG_TYPE_BLKCIPHER)
> -               return alg->base.cra_blocksize;
> -
> -       if (alg->base.cra_ablkcipher.encrypt)
> -               return alg->base.cra_blocksize;
> -
> -       return alg->walksize;
> -}
> -
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
> -/**
> - * crypto_skcipher_walksize() - obtain walk size
> - * @tfm: cipher handle
> - *
> - * In some cases, algorithms can only perform optimally when operating on
> - * multiple blocks in parallel. This is reflected by the walksize, which
> - * must be a multiple of the chunksize (or equal if the concern does not
> - * apply)
> - *
> - * Return: walk size in bytes
> - */
> -static inline unsigned int crypto_skcipher_walksize(
> -       struct crypto_skcipher *tfm)
> -{
> -       return crypto_skcipher_alg_walksize(crypto_skcipher_alg(tfm));
> -}
> -
>  /**
>   * crypto_skcipher_blocksize() - obtain block size of cipher
>   * @tfm: cipher handle
> --
> 2.21.0
>
