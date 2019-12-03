Return-Path: <SRS0=f4rb=ZZ=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DDD9AC432C0
	for <linux-crypto@archiver.kernel.org>; Tue,  3 Dec 2019 11:44:21 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id A4CE520674
	for <linux-crypto@archiver.kernel.org>; Tue,  3 Dec 2019 11:44:21 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="InKZHISq"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725848AbfLCLoV (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Tue, 3 Dec 2019 06:44:21 -0500
Received: from mail-wm1-f66.google.com ([209.85.128.66]:38905 "EHLO
        mail-wm1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725773AbfLCLoU (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 3 Dec 2019 06:44:20 -0500
Received: by mail-wm1-f66.google.com with SMTP id p17so3088897wmi.3
        for <linux-crypto@vger.kernel.org>; Tue, 03 Dec 2019 03:44:18 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=RZYe8xfpHtdI0ODvJzzh3JqtdbqD9pNcsnaGt7b7sy4=;
        b=InKZHISq/ywuTx9B7Sp4eC1lM2Kj/sFvHxLd5PZShR7CyPQLrXu3GZwD3PcQrBRuvb
         ErilwhXYxFa7uG2QTYOOwCyOASTMAr91cCtnm9tVXTg0kjDFAdxT8fWra9HYmegtZRa6
         OZCWQHtXNPYcdBsA7NHKEcMr9AXcL99PlMSn1Xh1oOJj306yrsDUZA3RKFsh9YS1Si+Q
         1boMgHSmkUwfFs0/WxPBa8SRlk00nK34Pef1QtECe3D/Kwf8PoM2ckSemEXwyqu7a358
         VJjmfeHK1aAMtcqszqerN65nHfD2T+unmBBOc1NNg7xn1FTJxrWji7pV4WT9p4UOTF09
         VrqQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=RZYe8xfpHtdI0ODvJzzh3JqtdbqD9pNcsnaGt7b7sy4=;
        b=iyoceRoY9z3+pn7MzSLKS3/2fIWbAptN9fsh5Oj4ApiVl09Xbl4cMltB2ldO07Rm9m
         LTzOCTomUEoK4OwdKe8qBj17ZdnnCCYhseR8sWdmEN8mi7Ud6bSTclwOXxTEIJbxjPg6
         gJ9qh915u6uz0KrfqM4MODoDksHcmB0PwqjTcXs7d1Ffmhkrqb47wKnLmMFN7zgbd+/j
         k/ataVo1tymT+Rl8Sbh3pCE6JyAH2Wr89hN5bNUZGYMMTLJZUO+Zl6Pi6bLk8BxmOXiE
         xME+wmV3xSXfQ9Z+oxx9Dv0grEr/lpYkofCxP7/Tl5pRyRb+ZPy4AV3KDZPnOEIUqgWZ
         12vg==
X-Gm-Message-State: APjAAAW1zUfFLCCFUX08LEtgGIHI5HRTDumqP124BOFpBkQrmgN6hTSw
        GUnlNos8LmDWH0Jgz1hsMmGI30jFNCOYZO3xYN9xW50rpeFHCw==
X-Google-Smtp-Source: APXvYqx0BTCZuxTVv+zInNU+ihppi14PxtpjT0+w152idVQVFeYeJT6eTzxQWMwYRpkIb96j7Vi3CtVhEc7vmZ+IStA=
X-Received: by 2002:a1c:4c10:: with SMTP id z16mr32084034wmf.136.1575373457782;
 Tue, 03 Dec 2019 03:44:17 -0800 (PST)
MIME-Version: 1.0
References: <20191202221319.258002-1-ebiggers@kernel.org>
In-Reply-To: <20191202221319.258002-1-ebiggers@kernel.org>
From:   Ard Biesheuvel <ard.biesheuvel@linaro.org>
Date:   Tue, 3 Dec 2019 11:44:13 +0000
Message-ID: <CAKv+Gu-h+yFj-9FwNnA7Qj_TWMQf_rcbRt=NMW7NOvkafCZnUw@mail.gmail.com>
Subject: Re: [PATCH] crypto: api - fix unexpectedly getting generic implementation
To:     Eric Biggers <ebiggers@kernel.org>
Cc:     "open list:HARDWARE RANDOM NUMBER GENERATOR CORE" 
        <linux-crypto@vger.kernel.org>,
        Pascal Van Leeuwen <pvanleeuwen@verimatrix.com>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Mon, 2 Dec 2019 at 22:13, Eric Biggers <ebiggers@kernel.org> wrote:
>
> From: Eric Biggers <ebiggers@google.com>
>
> When CONFIG_CRYPTO_MANAGER_EXTRA_TESTS=y, the first lookup of an
> algorithm that needs to be instantiated using a template will always get
> the generic implementation, even when an accelerated one is available.
>
> This happens because the extra self-tests for the accelerated
> implementation allocate the generic implementation for comparison
> purposes, and then crypto_alg_tested() for the generic implementation
> "fulfills" the original request (i.e. sets crypto_larval::adult).
>
> Fix this by making crypto_alg_tested() replace an already-set
> crypto_larval::adult when it has lower priority and the larval hasn't
> already been complete()d (by cryptomgr_probe()).
>
> This also required adding crypto_alg_sem protection to completing the
> larval in cryptomgr_probe().
>
> Also add some comments to crypto_alg_tested() to make it easier to
> understand what's going on.
>
> Fixes: 9a8a6b3f0950 ("crypto: testmgr - fuzz hashes against their generic implementation")
> Fixes: d435e10e67be ("crypto: testmgr - fuzz skciphers against their generic implementation")
> Fixes: 40153b10d91c ("crypto: testmgr - fuzz AEADs against their generic implementation")
> Signed-off-by: Eric Biggers <ebiggers@google.com>

Thanks for fixing this.

Acked-by: Ard Biesheuvel <ardb@kernel.org>

> ---
>  crypto/algapi.c   | 46 +++++++++++++++++++++++++++++++++++++++++-----
>  crypto/algboss.c  |  4 ++++
>  crypto/api.c      |  5 -----
>  crypto/internal.h |  5 +++++
>  4 files changed, 50 insertions(+), 10 deletions(-)
>
> diff --git a/crypto/algapi.c b/crypto/algapi.c
> index b052f38edba621..6c5406d342e2b7 100644
> --- a/crypto/algapi.c
> +++ b/crypto/algapi.c
> @@ -251,6 +251,17 @@ static struct crypto_larval *__crypto_register_alg(struct crypto_alg *alg)
>         goto out;
>  }
>
> +/**
> + * crypto_alg_tested() - handle a self-test result
> + * @name: the driver name of the algorithm that was tested
> + * @err: 0 if testing passed, nonzero if testing failed
> + *
> + * If testing passed, mark the algorithm as tested and try to use it to fulfill
> + * any outstanding template instantiation requests.  Also remove any template
> + * instances that use a lower-priority implementation of the same algorithm.
> + *
> + * In any case, also wake up anyone waiting for the algorithm to be tested.
> + */
>  void crypto_alg_tested(const char *name, int err)
>  {
>         struct crypto_larval *test;
> @@ -258,6 +269,7 @@ void crypto_alg_tested(const char *name, int err)
>         struct crypto_alg *q;
>         LIST_HEAD(list);
>
> +       /* Find the algorithm's test larval */
>         down_write(&crypto_alg_sem);
>         list_for_each_entry(q, &crypto_alg_list, cra_list) {
>                 if (crypto_is_moribund(q) || !crypto_is_larval(q))
> @@ -290,26 +302,50 @@ void crypto_alg_tested(const char *name, int err)
>                 if (crypto_is_larval(q)) {
>                         struct crypto_larval *larval = (void *)q;
>
> +                       if (crypto_is_test_larval(larval))
> +                               continue;
> +
>                         /*
> -                        * Check to see if either our generic name or
> -                        * specific name can satisfy the name requested
> -                        * by the larval entry q.
> +                        * Fulfill the request larval 'q' (set larval->adult) if
> +                        * the tested algorithm is compatible with it, i.e. if
> +                        * the request is for the same generic or driver name
> +                        * and for compatible flags.
> +                        *
> +                        * If larval->adult is already set, replace it if the
> +                        * tested algorithm is higher priority and the larval
> +                        * hasn't been completed()d yet.  This is needed to
> +                        * avoid users always getting the generic implementation
> +                        * on first use when the extra self-tests are enabled.
>                          */
> +
>                         if (strcmp(alg->cra_name, q->cra_name) &&
>                             strcmp(alg->cra_driver_name, q->cra_name))
>                                 continue;
>
> -                       if (larval->adult)
> -                               continue;
>                         if ((q->cra_flags ^ alg->cra_flags) & larval->mask)
>                                 continue;
> +
> +                       if (larval->adult &&
> +                           larval->adult->cra_priority >= alg->cra_priority)
> +                               continue;
> +
> +                       if (completion_done(&larval->completion))
> +                               continue;
> +
>                         if (!crypto_mod_get(alg))
>                                 continue;
>
> +                       if (larval->adult)
> +                               crypto_mod_put(larval->adult);
>                         larval->adult = alg;
>                         continue;
>                 }
>
> +               /*
> +                * Remove any template instances that use a lower-priority
> +                * implementation of the same algorithm.
> +                */
> +
>                 if (strcmp(alg->cra_name, q->cra_name))
>                         continue;
>
> diff --git a/crypto/algboss.c b/crypto/algboss.c
> index a62149d6c839f5..f2b3b3ab008334 100644
> --- a/crypto/algboss.c
> +++ b/crypto/algboss.c
> @@ -81,7 +81,11 @@ static int cryptomgr_probe(void *data)
>         crypto_tmpl_put(tmpl);
>
>  out:
> +       /* crypto_alg_sem is needed to synchronize with crypto_alg_tested() */
> +       down_write(&crypto_alg_sem);
>         complete_all(&param->larval->completion);
> +       up_write(&crypto_alg_sem);
> +
>         crypto_alg_put(&param->larval->alg);
>         kfree(param);
>         module_put_and_exit(0);
> diff --git a/crypto/api.c b/crypto/api.c
> index ef96142ceca746..855004cb0b4d59 100644
> --- a/crypto/api.c
> +++ b/crypto/api.c
> @@ -47,11 +47,6 @@ void crypto_mod_put(struct crypto_alg *alg)
>  }
>  EXPORT_SYMBOL_GPL(crypto_mod_put);
>
> -static inline int crypto_is_test_larval(struct crypto_larval *larval)
> -{
> -       return larval->alg.cra_driver_name[0];
> -}
> -
>  static struct crypto_alg *__crypto_alg_lookup(const char *name, u32 type,
>                                               u32 mask)
>  {
> diff --git a/crypto/internal.h b/crypto/internal.h
> index ff06a3bd1ca10c..ba744ac2ee1f09 100644
> --- a/crypto/internal.h
> +++ b/crypto/internal.h
> @@ -110,6 +110,11 @@ static inline int crypto_is_larval(struct crypto_alg *alg)
>         return alg->cra_flags & CRYPTO_ALG_LARVAL;
>  }
>
> +static inline int crypto_is_test_larval(struct crypto_larval *larval)
> +{
> +       return larval->alg.cra_driver_name[0];
> +}
> +
>  static inline int crypto_is_dead(struct crypto_alg *alg)
>  {
>         return alg->cra_flags & CRYPTO_ALG_DEAD;
> --
> 2.24.0.393.g34dc348eaf-goog
>
