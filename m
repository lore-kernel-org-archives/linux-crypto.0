Return-Path: <SRS0=9Ofa=N6=vger.kernel.org=linux-crypto-owner@kernel.org>
Received: from mail-io1-f68.google.com ([209.85.166.68]:36144 "EHLO
        mail-io1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728926AbeKTGuj (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 20 Nov 2018 01:50:39 -0500
Received: by mail-io1-f68.google.com with SMTP id m19so17561042ioh.3
        for <linux-crypto@vger.kernel.org>; Mon, 19 Nov 2018 12:25:21 -0800 (PST)
MIME-Version: 1.0
References: <1542657210-37739-1-git-send-email-clabbe@baylibre.com> <1542657210-37739-2-git-send-email-clabbe@baylibre.com>
In-Reply-To: <1542657210-37739-2-git-send-email-clabbe@baylibre.com>
From: Ard Biesheuvel <ard.biesheuvel@linaro.org>
Date: Mon, 19 Nov 2018 12:25:10 -0800
Message-ID: <CAKv+Gu80ArVHwBOmD3qjKUEP=LsbOEfZrCyO-rPDtpX3AbykoA@mail.gmail.com>
Subject: Re: [PATCH v2 01/11] crypto: move crypto_alg_get/crypto_alg_put to linux/crypto.h
To: Corentin Labbe <clabbe@baylibre.com>
Cc: "David S. Miller" <davem@davemloft.net>,
        Eric Biggers <ebiggers@kernel.org>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        nhorman@tuxdriver.com,
        "open list:HARDWARE RANDOM NUMBER GENERATOR CORE"
        <linux-crypto@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

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
