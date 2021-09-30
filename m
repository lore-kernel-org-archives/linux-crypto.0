Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4227CC43217
	for <linux-crypto@archiver.kernel.org>; Thu, 30 Sep 2021 19:41:03 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 24B2C61A0B
	for <linux-crypto@archiver.kernel.org>; Thu, 30 Sep 2021 19:41:03 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344889AbhI3Tmo (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 30 Sep 2021 15:42:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52784 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345855AbhI3Tmo (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 30 Sep 2021 15:42:44 -0400
Received: from mail-wr1-x42b.google.com (mail-wr1-x42b.google.com [IPv6:2a00:1450:4864:20::42b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D3388C06176A
        for <linux-crypto@vger.kernel.org>; Thu, 30 Sep 2021 12:41:00 -0700 (PDT)
Received: by mail-wr1-x42b.google.com with SMTP id q2so2000624wrc.4
        for <linux-crypto@vger.kernel.org>; Thu, 30 Sep 2021 12:41:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=baylibre-com.20210112.gappssmtp.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=Hx/tBsdkeGhZxG52QWJPz9Kz/HAe/yuuGxlrpK5+Bs0=;
        b=pGEwkWuKW4obTzm9tbCH+Qhm6GafqSky9gPfAPfj9/ZynrhBmRHqkwF+H9EGA74sZ+
         e65f5loIGlF2z9PQbnab4xRbb3yDQJ/km66crhkHwhTxN1awrIBZNo3u0ERqhPwovU9V
         kwegr6/GU7a9cg+KQ7u51n6TXjbYmROF3vCM4TlVy6iwZ60hnen/i7qJMO9rDoaz9kuJ
         TVZulsdDjJ+zcSoGoLkBHB6sLJrs862Qc2Lg43bki0ztoRX7zWsp7EDGcY5JubxtwWcq
         SBlIX2ZRI0c8idL5Vi1z3XNjCaSY1JOPkyx4pqHbKKIJJu94y6LGa5TWmR8Wb9mZLGSB
         MHgw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=Hx/tBsdkeGhZxG52QWJPz9Kz/HAe/yuuGxlrpK5+Bs0=;
        b=rM7CpmSfa34mR9MbX4qo00q4R7ZYuRoSIFYQHNgHhE7SorEMPIsPPcaVTpFbQ2CA7Q
         MO1P7ywByb7NGKQAjZ3gus9vOg+t0WcL0Rp5Xc7pwGU9dlwP2bwqRP+Syi32oUtVuMuf
         sUSea+5HOxgoILujJCJxussGl50DvsaEcbK4hzOWFFD7Gw1qzHbUaOY9j6pPYCTt6m+l
         1HESXrizkc6gCNEcWUbrihBLu3y3+rUPrQEYn6qf4H+vrpF1k8yFBUACy94OlQKMQqES
         ATNRmOe+QI8LnCGSGsHxbID8zuhgg9YbcGNF2bmLN7DVY5I5WNejiXTSxtL1+2R9zsXm
         kfHA==
X-Gm-Message-State: AOAM532C/a7RcC5kMkYL4oF5gBAj1hnG+1+cA2tmVAyxePY0MjFtZWYd
        PuaSkqR39RB84D9H7vzSHGpAhg==
X-Google-Smtp-Source: ABdhPJzTZR4PaIT012/kW9Ejx5+BIO/rLhQdspCqmIHaZLLOGMEi/OxAq8Ai70Wk9pA9FTsQaeEIBw==
X-Received: by 2002:adf:cf10:: with SMTP id o16mr8056065wrj.12.1633030859457;
        Thu, 30 Sep 2021 12:40:59 -0700 (PDT)
Received: from blmsp ([2a02:2454:3e6:c900::97e])
        by smtp.gmail.com with ESMTPSA id l124sm5576156wml.8.2021.09.30.12.40.58
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 30 Sep 2021 12:40:59 -0700 (PDT)
Date:   Thu, 30 Sep 2021 21:40:58 +0200
From:   Markus Schneider-Pargmann <msp@baylibre.com>
To:     Sean Wang <sean.wang@mediatek.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Matt Mackall <mpm@selenic.com>
Cc:     linux-mediatek@lists.infradead.org, linux-crypto@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH] hwrng: mediatek - Force runtime pm ops for sleep ops
Message-ID: <20210930194058.oe5vlqlelilekdde@blmsp>
References: <20210930191242.2542315-1-msp@baylibre.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20210930191242.2542315-1-msp@baylibre.com>
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Hi,

On Thu, Sep 30, 2021 at 09:12:42PM +0200, Markus Schneider-Pargmann wrote:
> Currently mtk_rng_runtime_suspend/resume is called for both runtime pm
> and system sleep operations.
> 
> This is wrong as these should only be runtime ops as the name already
> suggests. Currently freezing the system will lead to a call to
> mtk_rng_runtime_suspend even if the device currently isn't active. This
> leads to a clock warning because it is disabled/unprepared although it
> isn't enabled/prepared currently.
> 
> This patch fixes this by only setting the runtime pm ops and forces to
> call the runtime pm ops from the system sleep ops as well if active but
> not otherwise.
> 
> Signed-off-by: Markus Schneider-Pargmann <msp@baylibre.com>

Fixes: 81d2b34508c6 (hwrng: mtk - add runtime PM support)

Sorry, forgot to add this line in the commit message. I can add it for
the next version.

Best,
Markus

> ---
>  drivers/char/hw_random/mtk-rng.c | 9 +++++++--
>  1 file changed, 7 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/char/hw_random/mtk-rng.c b/drivers/char/hw_random/mtk-rng.c
> index 8ad7b515a51b..6c00ea008555 100644
> --- a/drivers/char/hw_random/mtk-rng.c
> +++ b/drivers/char/hw_random/mtk-rng.c
> @@ -166,8 +166,13 @@ static int mtk_rng_runtime_resume(struct device *dev)
>  	return mtk_rng_init(&priv->rng);
>  }
>  
> -static UNIVERSAL_DEV_PM_OPS(mtk_rng_pm_ops, mtk_rng_runtime_suspend,
> -			    mtk_rng_runtime_resume, NULL);
> +static const struct dev_pm_ops mtk_rng_pm_ops = {
> +	SET_RUNTIME_PM_OPS(mtk_rng_runtime_suspend,
> +			   mtk_rng_runtime_resume, NULL)
> +	SET_SYSTEM_SLEEP_PM_OPS(pm_runtime_force_suspend,
> +				pm_runtime_force_resume)
> +};
> +
>  #define MTK_RNG_PM_OPS (&mtk_rng_pm_ops)
>  #else	/* CONFIG_PM */
>  #define MTK_RNG_PM_OPS NULL
> -- 
> 2.33.0
> 
