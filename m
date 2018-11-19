Return-Path: <SRS0=9Ofa=N6=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_PASS autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D0A72C43441
	for <linux-crypto@archiver.kernel.org>; Mon, 19 Nov 2018 20:25:23 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 9561D20851
	for <linux-crypto@archiver.kernel.org>; Mon, 19 Nov 2018 20:25:23 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=linaro.org header.i=@linaro.org header.b="IrCmBPng"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 9561D20851
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=linaro.org
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-crypto-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730350AbeKTGuj (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Tue, 20 Nov 2018 01:50:39 -0500
Received: from mail-io1-f68.google.com ([209.85.166.68]:36144 "EHLO
        mail-io1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728926AbeKTGuj (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 20 Nov 2018 01:50:39 -0500
Received: by mail-io1-f68.google.com with SMTP id m19so17561042ioh.3
        for <linux-crypto@vger.kernel.org>; Mon, 19 Nov 2018 12:25:21 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=SW76frBgmIxnQj6FbUvYe17VUf1Wc2R/AGi8b/6ZdH8=;
        b=IrCmBPnglmOh5pNgVx60lJyzAq2HMCcFXS+SR8ReDkal7sRcyoaIv+T/Txzug6le/H
         w+8HNdvSup6SrvMzUs/5r9gIvZ+s5Z6EcFwUH9FYVNW3Eae333JL+PGjRsbMZ8F6gLWi
         96+PpdaGcklwMVpjIv9SzGf4TJumcDPkmOr1c=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=SW76frBgmIxnQj6FbUvYe17VUf1Wc2R/AGi8b/6ZdH8=;
        b=GaI4nNPADZ5aBD346sL8FQzCr+KsBatfEcZm8pbJkJOhloEOyyeHFaruCefbYFl5zV
         eOEwesAFc+SUR37AbKc+S5eMx9EJ2scT2gEkv0heBdK9tvMYa0OSddb2yobMW8yQf40z
         oSIk8mbfesvVi+fEG7XKQZ9d9/8cn1Eu00DzLPabdfQcD2e+xMHDDx9ZyM69aMxlUgtY
         zh35GF2ynpyE7p9cuzpGssu39C5dg96jQxggvAHYiioYU8DvLD8CkmoLUpJ6ofB+ZQHh
         Y2uEQzrXw3plMeTG5wUss7yMULP4YeZYcUfZYzhpiN4GNfKqMSkEhqGiVnwH8xoAXfBZ
         k/aQ==
X-Gm-Message-State: AA+aEWYsziTElHYqENKfIO3XAR8kPVqf+pSVmbP1QQtOyvHpBrqBgC+Z
        DDbCDBcDKu/g9BbHrA7WKMTe/ZBGz0DCtsdzmZbkBQ==
X-Google-Smtp-Source: AFSGD/WpPrhjZxCJ0p9GvxJzQQnzEf4P1pU9gGNoQJ9m1YkU+Tdldl3KnmC8wuE2pDsm4dE+W1XJ8t7vNPojZanW7ew=
X-Received: by 2002:a6b:7a46:: with SMTP id k6mr16560434iop.60.1542659121003;
 Mon, 19 Nov 2018 12:25:21 -0800 (PST)
MIME-Version: 1.0
References: <1542657210-37739-1-git-send-email-clabbe@baylibre.com> <1542657210-37739-2-git-send-email-clabbe@baylibre.com>
In-Reply-To: <1542657210-37739-2-git-send-email-clabbe@baylibre.com>
From:   Ard Biesheuvel <ard.biesheuvel@linaro.org>
Date:   Mon, 19 Nov 2018 12:25:10 -0800
Message-ID:
 <CAKv+Gu80ArVHwBOmD3qjKUEP=LsbOEfZrCyO-rPDtpX3AbykoA@mail.gmail.com>
Subject: Re: [PATCH v2 01/11] crypto: move crypto_alg_get/crypto_alg_put to linux/crypto.h
To:     Corentin Labbe <clabbe@baylibre.com>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Eric Biggers <ebiggers@kernel.org>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        nhorman@tuxdriver.com,
        "open list:HARDWARE RANDOM NUMBER GENERATOR CORE" 
        <linux-crypto@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org
Message-ID: <20181119202510.y8VDzx3gqDoEvKTjnHXtScT7uJgk6d85q49KazCcN5M@z>

On Mon, 19 Nov 2018 at 11:53, Corentin Labbe <clabbe@baylibre.com> wrote:
>
> Since we will need crypto_alg_get/crypto_alg_put for "locking"
> crypto_alg when updating stats, we need it to be via linux/crypto.h
>

This seems backwards to me. Surely, crypto stats are permitted to use
the internal crypto API?

> Signed-off-by: Corentin Labbe <clabbe@baylibre.com>
> ---
>  crypto/internal.h      | 12 ------------
>  include/linux/crypto.h | 12 ++++++++++++
>  2 files changed, 12 insertions(+), 12 deletions(-)
>
> diff --git a/crypto/internal.h b/crypto/internal.h
> index ef769b5e8ad3..d81f033aeb5c 100644
> --- a/crypto/internal.h
> +++ b/crypto/internal.h
> @@ -91,18 +91,6 @@ unsigned int crypto_alg_extsize(struct crypto_alg *alg);
>  int crypto_type_has_alg(const char *name, const struct crypto_type *frontend,
>                         u32 type, u32 mask);
>
> -static inline struct crypto_alg *crypto_alg_get(struct crypto_alg *alg)
> -{
> -       refcount_inc(&alg->cra_refcnt);
> -       return alg;
> -}
> -
> -static inline void crypto_alg_put(struct crypto_alg *alg)
> -{
> -       if (refcount_dec_and_test(&alg->cra_refcnt) && alg->cra_destroy)
> -               alg->cra_destroy(alg);
> -}
> -
>  static inline int crypto_tmpl_get(struct crypto_template *tmpl)
>  {
>         return try_module_get(tmpl->module);
> diff --git a/include/linux/crypto.h b/include/linux/crypto.h
> index 3634ad6fe202..ac8f4168a831 100644
> --- a/include/linux/crypto.h
> +++ b/include/linux/crypto.h
> @@ -607,6 +607,18 @@ int crypto_unregister_algs(struct crypto_alg *algs, int count);
>   */
>  int crypto_has_alg(const char *name, u32 type, u32 mask);
>
> +static inline struct crypto_alg *crypto_alg_get(struct crypto_alg *alg)
> +{
> +       refcount_inc(&alg->cra_refcnt);
> +       return alg;
> +}
> +
> +static inline void crypto_alg_put(struct crypto_alg *alg)
> +{
> +       if (refcount_dec_and_test(&alg->cra_refcnt) && alg->cra_destroy)
> +               alg->cra_destroy(alg);
> +}
> +
>  /*
>   * Transforms: user-instantiated objects which encapsulate algorithms
>   * and core processing logic.  Managed via crypto_alloc_*() and
> --
> 2.18.1
>
