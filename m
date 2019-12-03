Return-Path: <SRS0=f4rb=ZZ=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 34302C432C3
	for <linux-crypto@archiver.kernel.org>; Tue,  3 Dec 2019 18:14:35 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id EF8BD20661
	for <linux-crypto@archiver.kernel.org>; Tue,  3 Dec 2019 18:14:34 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="rGuMv80/"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726057AbfLCSOe (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Tue, 3 Dec 2019 13:14:34 -0500
Received: from mail-wm1-f67.google.com ([209.85.128.67]:53817 "EHLO
        mail-wm1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726718AbfLCSOe (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 3 Dec 2019 13:14:34 -0500
Received: by mail-wm1-f67.google.com with SMTP id u18so3968450wmc.3
        for <linux-crypto@vger.kernel.org>; Tue, 03 Dec 2019 10:14:32 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=v28tIMN3yyGobO7efEpS9p7P9A+fO5b5Rba2tcdyPkw=;
        b=rGuMv80/CZyeQHIBa9o7Cbz6/mkQXQZPStxkKkT4fF74B3NNMQoYV6BIVS5diSk2TO
         EKrtNQBkZgSDhMXElX5Dpu7rF2qgU2Jq1L9a1P0mNsr2LntfOqiB5s/ZztdxpNJkhEsn
         DGPx2KrVeQ+whCklRIARcUdmGUJLneoINH05Q44D35nRwnyTPQFZhY0UKB1IdpxHlUCl
         cV4a+imRC+LW1bdP883lX19gpkIr2raY561EsJ/VMyxgPE/p/zzK2trw7cUX+ApcVfwv
         T3kco3R7Hp8FBMgMvYQj4mBz6c51bTWqhx/2aDTgMjEA4GuNQsGZ7WE5CzGQvDvotEYH
         qmAg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=v28tIMN3yyGobO7efEpS9p7P9A+fO5b5Rba2tcdyPkw=;
        b=itpPO5yI4Pd+jGU6YFq4WUDdab6x2JImd57Wp6z2ltrISbq1+sgD2lNlrikqL3hC2/
         DD4Sf0Ex9ecyCEHP95ni9lAxEppJhQ0zXJMqhQDTdJn256+Yr0k3VC0JW2aINpITYUTV
         1ALJ5Czy2s4C1vkMY8+WDL86qGUVta73EuKwy63LuwDSHQs1t3CN0q62I1Pc4qwtNSg2
         vPQ3YdodSWrWR38vqb7AJEQZzBNYNQKdd3DH0bksnXVKDw6cA8z5JKHuI6JyOT0Ecc30
         VxzHvjIv9Ol+Aa/VU2Qoxo8NFFrisKPvFf/oNik73BBzQODGfatIxeIAPLGusZKW+P/y
         HNqw==
X-Gm-Message-State: APjAAAWE8Tie4afuvdtR37BUAwjn3nD3+WFJ8nRXCAJlJOxMuwHA7yht
        vhRg47TK8HGT/Z4cn+8+56wlNnxB9q8dabsUwwNhlimyIH9eZQ==
X-Google-Smtp-Source: APXvYqyLt1m6arQ/C5+ZBxHf0KlBls6smD13pwq4Rhe2xIpR7Fmg2d1bOIA7y+2JhF2mNcR0+RPel5Sxes7xF8JSd88=
X-Received: by 2002:a1c:4c10:: with SMTP id z16mr33799469wmf.136.1575396871718;
 Tue, 03 Dec 2019 10:14:31 -0800 (PST)
MIME-Version: 1.0
References: <20191129193522.52513-1-ebiggers@kernel.org>
In-Reply-To: <20191129193522.52513-1-ebiggers@kernel.org>
From:   Ard Biesheuvel <ard.biesheuvel@linaro.org>
Date:   Tue, 3 Dec 2019 18:14:27 +0000
Message-ID: <CAKv+Gu-feQdhtoUske0u_TCQD+CWF0TuHAZO2Ji5XMy8RCrzjA@mail.gmail.com>
Subject: Re: [PATCH] crypto: shash - allow essiv and hmac to use OPTIONAL_KEY algorithms
To:     Eric Biggers <ebiggers@kernel.org>
Cc:     "open list:HARDWARE RANDOM NUMBER GENERATOR CORE" 
        <linux-crypto@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Fri, 29 Nov 2019 at 20:36, Eric Biggers <ebiggers@kernel.org> wrote:
>
> From: Eric Biggers <ebiggers@google.com>
>
> The essiv and hmac templates refuse to use any hash algorithm that has a
> ->setkey() function, which includes not just algorithms that always need
> a key, but also algorithms that optionally take a key.
>
> Previously the only optionally-keyed hash algorithms in the crypto API
> were non-cryptographic algorithms like crc32, so this didn't really
> matter.  But that's changed with BLAKE2 support being added.  BLAKE2
> should work with essiv and hmac, just like any other cryptographic hash.
>
> Fix this by allowing the use of both algorithms without a ->setkey()
> function and algorithms that have the OPTIONAL_KEY flag set.
>
> Signed-off-by: Eric Biggers <ebiggers@google.com>

Hey Eric,

Even though I am not convinced that using hmac() with blake2 makes a
lot of sense, I agree that the mere presence or absence of the
setkey() hook should decide whether this is permitted.

So,

Acked-by: Ard Biesheuvel <ardb@kernel.org>

> ---
>  crypto/essiv.c                 | 2 +-
>  crypto/hmac.c                  | 4 ++--
>  crypto/shash.c                 | 3 +--
>  include/crypto/internal/hash.h | 6 ++++++
>  4 files changed, 10 insertions(+), 5 deletions(-)
>
> diff --git a/crypto/essiv.c b/crypto/essiv.c
> index 808f2b362106..e4b32c2ea7ec 100644
> --- a/crypto/essiv.c
> +++ b/crypto/essiv.c
> @@ -442,7 +442,7 @@ static bool essiv_supported_algorithms(const char *essiv_cipher_name,
>         if (ivsize != alg->cra_blocksize)
>                 goto out;
>
> -       if (crypto_shash_alg_has_setkey(hash_alg))
> +       if (crypto_shash_alg_needs_key(hash_alg))
>                 goto out;
>
>         ret = true;
> diff --git a/crypto/hmac.c b/crypto/hmac.c
> index 8b2a212eb0ad..377f07733e2f 100644
> --- a/crypto/hmac.c
> +++ b/crypto/hmac.c
> @@ -185,9 +185,9 @@ static int hmac_create(struct crypto_template *tmpl, struct rtattr **tb)
>                 return PTR_ERR(salg);
>         alg = &salg->base;
>
> -       /* The underlying hash algorithm must be unkeyed */
> +       /* The underlying hash algorithm must not require a key */
>         err = -EINVAL;
> -       if (crypto_shash_alg_has_setkey(salg))
> +       if (crypto_shash_alg_needs_key(salg))
>                 goto out_put_alg;
>
>         ds = salg->digestsize;
> diff --git a/crypto/shash.c b/crypto/shash.c
> index e83c5124f6eb..7989258a46b4 100644
> --- a/crypto/shash.c
> +++ b/crypto/shash.c
> @@ -50,8 +50,7 @@ static int shash_setkey_unaligned(struct crypto_shash *tfm, const u8 *key,
>
>  static void shash_set_needkey(struct crypto_shash *tfm, struct shash_alg *alg)
>  {
> -       if (crypto_shash_alg_has_setkey(alg) &&
> -           !(alg->base.cra_flags & CRYPTO_ALG_OPTIONAL_KEY))
> +       if (crypto_shash_alg_needs_key(alg))
>                 crypto_shash_set_flags(tfm, CRYPTO_TFM_NEED_KEY);
>  }
>
> diff --git a/include/crypto/internal/hash.h b/include/crypto/internal/hash.h
> index bfc9db7b100d..f68dab38f160 100644
> --- a/include/crypto/internal/hash.h
> +++ b/include/crypto/internal/hash.h
> @@ -85,6 +85,12 @@ static inline bool crypto_shash_alg_has_setkey(struct shash_alg *alg)
>         return alg->setkey != shash_no_setkey;
>  }
>
> +static inline bool crypto_shash_alg_needs_key(struct shash_alg *alg)
> +{
> +       return crypto_shash_alg_has_setkey(alg) &&
> +               !(alg->base.cra_flags & CRYPTO_ALG_OPTIONAL_KEY);
> +}
> +
>  bool crypto_hash_alg_has_setkey(struct hash_alg_common *halg);
>
>  int crypto_init_ahash_spawn(struct crypto_ahash_spawn *spawn,
> --
> 2.24.0
>
