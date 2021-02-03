Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 215D4C433DB
	for <linux-crypto@archiver.kernel.org>; Wed,  3 Feb 2021 12:18:52 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id D3D7B64F95
	for <linux-crypto@archiver.kernel.org>; Wed,  3 Feb 2021 12:18:51 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234118AbhBCMSv (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Wed, 3 Feb 2021 07:18:51 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55168 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234057AbhBCMSu (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 3 Feb 2021 07:18:50 -0500
Received: from mail-lf1-x12e.google.com (mail-lf1-x12e.google.com [IPv6:2a00:1450:4864:20::12e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 18A9AC061573
        for <linux-crypto@vger.kernel.org>; Wed,  3 Feb 2021 04:18:10 -0800 (PST)
Received: by mail-lf1-x12e.google.com with SMTP id i187so32977822lfd.4
        for <linux-crypto@vger.kernel.org>; Wed, 03 Feb 2021 04:18:10 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=MoPxYlztBMkUInx90I6MSDZW1GupbzFyQ7KEz/9vHUg=;
        b=XNt1A+FCURD8+kUH7QpgVVZxQHARWLl28d6lDb4blMt7QUhf2OPwUQBXQkY4Uo5Xea
         R4RcX/XZjkB7+R1Lc5eQP+deZHaLQTaGUWMB+UAQG7CiDTgE9v9U+FFup9HQwnjegwR1
         ghMyCs6E3iSd/t++E7kRbtlnsaZ6oXk6Fl7JEWxoEGAPpXP8Y+qHIGuUYRyepYvqDAIo
         6cm7yJbnBJk1ScAMPmrbgMPjue646PgqqaRpnfVekgHpDDck941pIOGOqtGscFsL4UeB
         RUGAKWRRCpB6mwsx7Lhk9YWYr2pKFjLzt+eRv7Sr2UQeIcO/39oLAMWX1MSE2sCgyNzA
         lkkw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=MoPxYlztBMkUInx90I6MSDZW1GupbzFyQ7KEz/9vHUg=;
        b=GQ5tD75Gl6Y6Ir5BBwVZgRmIgjEzalUjUdaIBRdaHZrW/642uYPoBEvumsTyickV9k
         gLMg/+IyHeBqOQ08Q5viBQ1PJi5tKm+oR52Z58kApetdwAq01xHSmwETMwdMZNG3b/Qk
         nmwT1jPSfvmuAU4rVmpXrW6uSyzjvGoWaBJpCOJ/i2WyBwles+EmQaqJ1uTe2XAIdYAH
         S2tHQe1XQ0mIx0TWzYaXygv3bRmB/H56e/TL3nU9yvqhrHo8YIHlvAppauW11oKDa+Uq
         upuzxPXfoyG2xr5RIvnIVrdkG2iTUD7km0vOrKocMHMj0EWDqcpgiyNpcftkJyUe5f8H
         VP8Q==
X-Gm-Message-State: AOAM533Cz3vlmON3F7FZWSbkBQzNZLAtjUiEqsH7SRVjEQJ8lfyWQv1z
        a/VebsW9LUb18VHbCzTo7jgjqp7cQLNY9ROoHpp3TA==
X-Google-Smtp-Source: ABdhPJxOp0ShQSyXEd20EUxPECkWvGmvVWeXRDVGQuMTbeTOeuppDYICdCYXGBVQtl50C5vO6TNiZvQm8M+vO+AZbjw=
X-Received: by 2002:a19:4b:: with SMTP id 72mr1622873lfa.302.1612354688510;
 Wed, 03 Feb 2021 04:18:08 -0800 (PST)
MIME-Version: 1.0
References: <1612344288-12201-1-git-send-email-tiantao6@hisilicon.com>
In-Reply-To: <1612344288-12201-1-git-send-email-tiantao6@hisilicon.com>
From:   Sumit Garg <sumit.garg@linaro.org>
Date:   Wed, 3 Feb 2021 17:47:57 +0530
Message-ID: <CAFA6WYPveMszfhnK7_BXWivBaQdS6Fye_yW5gL9ax-qvpjfcdw@mail.gmail.com>
Subject: Re: [PATCH] hwrng: optee -: Use device-managed registration API
To:     Tian Tao <tiantao6@hisilicon.com>
Cc:     Herbert Xu <herbert@gondor.apana.org.au>,
        op-tee@lists.trustedfirmware.org,
        "open list:HARDWARE RANDOM NUMBER GENERATOR CORE" 
        <linux-crypto@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Wed, 3 Feb 2021 at 14:55, Tian Tao <tiantao6@hisilicon.com> wrote:
>
> Use devm_hwrng_register to get rid of manual unregistration.
>
> Signed-off-by: Tian Tao <tiantao6@hisilicon.com>
> ---
>  drivers/char/hw_random/optee-rng.c | 3 +--
>  1 file changed, 1 insertion(+), 2 deletions(-)
>

Fix up subject line as s/hwrng: optee -:/hwrng: optee:/

With that fixed you can add:

Reviewed-by: Sumit Garg <sumit.garg@linaro.org>

-Sumit

> diff --git a/drivers/char/hw_random/optee-rng.c b/drivers/char/hw_random/optee-rng.c
> index a99d829..135a825 100644
> --- a/drivers/char/hw_random/optee-rng.c
> +++ b/drivers/char/hw_random/optee-rng.c
> @@ -243,7 +243,7 @@ static int optee_rng_probe(struct device *dev)
>         if (err)
>                 goto out_sess;
>
> -       err = hwrng_register(&pvt_data.optee_rng);
> +       err = devm_hwrng_register(dev, &pvt_data.optee_rng);
>         if (err) {
>                 dev_err(dev, "hwrng registration failed (%d)\n", err);
>                 goto out_sess;
> @@ -263,7 +263,6 @@ static int optee_rng_probe(struct device *dev)
>
>  static int optee_rng_remove(struct device *dev)
>  {
> -       hwrng_unregister(&pvt_data.optee_rng);
>         tee_client_close_session(pvt_data.ctx, pvt_data.session_id);
>         tee_client_close_context(pvt_data.ctx);
>
> --
> 2.7.4
>
