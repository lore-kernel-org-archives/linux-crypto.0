Return-Path: <linux-crypto-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 174D2C0032E
	for <linux-crypto@archiver.kernel.org>; Wed, 25 Oct 2023 13:14:51 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234992AbjJYNOu (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Wed, 25 Oct 2023 09:14:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38818 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234967AbjJYNOu (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 25 Oct 2023 09:14:50 -0400
Received: from mail-wm1-x32a.google.com (mail-wm1-x32a.google.com [IPv6:2a00:1450:4864:20::32a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 22FEF111
        for <linux-crypto@vger.kernel.org>; Wed, 25 Oct 2023 06:14:48 -0700 (PDT)
Received: by mail-wm1-x32a.google.com with SMTP id 5b1f17b1804b1-4081ccf69dcso5189685e9.0
        for <linux-crypto@vger.kernel.org>; Wed, 25 Oct 2023 06:14:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1698239686; x=1698844486; darn=vger.kernel.org;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date:from:to
         :cc:subject:date:message-id:reply-to;
        bh=Uh9NzWDOpOjBqAE2NxiRV75HtTvFEEfbyuq8HRzPj3o=;
        b=Vg6R9aq6DZfSUki59hwTyvYGcoDGSivl5wBGvRPJSaHKCnbNj22lYN38GJ+IDL2yr1
         uoHUuj7rtwYBA8zNXQnNycRNA5XlgSwY+4P+WcH4DADMASg6PZbw4uiVHqZt/E8HqvrN
         of25KuS66Xih2SfAJnXGsyxdAcntOk+cc9a3wlMeYvigbRMvMNd70bSNu1eji9bTn/Gi
         1I2JK9T8kvMHVUC3mEt0NRJGOMMCTtdI7jKCwI1fqxZI9GXnFfnTRK6HoZg6UJ3EY/Zt
         eSRxmOOJL7xQOoo3qDYfw8uG5uwgZhZiBgoAeU/XhV2ci1Un4jZM7+EnW5lgyAewUpUx
         wxog==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1698239686; x=1698844486;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=Uh9NzWDOpOjBqAE2NxiRV75HtTvFEEfbyuq8HRzPj3o=;
        b=NNYIFXEocihvQBNlPr9Y1KIbMBkW5fUYCSDlxsuKnJ6Bfo6zp79oz2NLq8KwbyUNuv
         h1qAeTvbEWW605KuLukukwpgyn5Sv+aDEbozkUGlow39FjaXbsnedqUj2xrZfA5t9oXQ
         EEEBIOSc40v92SEPt+Z1cOZ2CQEL/LQjsNSHjpBrCTqzGCJlFwGSS0uZtHgEaODzjPJR
         Pn7E3tU0lUXFJp3uZZ/lEa8/MYU8ed0rb2/quJ3nRxo9jUU9wKw92HrfmI6m96c1DGcU
         VvhkXMqSazzOlfci3sOcieLac5cswdEZbx/MzztXElxYqc1XOzYLc1GSfRMpKIgxgnun
         D0DA==
X-Gm-Message-State: AOJu0Yx1Luk7njiswr2jaEgKlJ1XMEwUKTlXhXcoI3PQlmhuLUPecDrI
        392fbISWrYPN0yj2oDSNlWE=
X-Google-Smtp-Source: AGHT+IEJFh8RrfOpsYHcP8SNWpaqchDATr5wPw2duU0ud3HztsU/+kp3ToqrWO5GiOcF98UISwZhVg==
X-Received: by 2002:a05:600c:450d:b0:405:409e:1fcb with SMTP id t13-20020a05600c450d00b00405409e1fcbmr15904488wmo.5.1698239686303;
        Wed, 25 Oct 2023 06:14:46 -0700 (PDT)
Received: from Red ([2a01:cb1d:3d5:a100:4a02:2aff:fe07:1efc])
        by smtp.googlemail.com with ESMTPSA id o27-20020a05600c511b00b004067e905f44sm14909072wms.9.2023.10.25.06.14.45
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 25 Oct 2023 06:14:46 -0700 (PDT)
Date:   Wed, 25 Oct 2023 15:14:44 +0200
From:   Corentin Labbe <clabbe.montjoie@gmail.com>
To:     Uwe =?iso-8859-1?Q?Kleine-K=F6nig?= 
        <u.kleine-koenig@pengutronix.de>
Cc:     Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>,
        Chen-Yu Tsai <wens@csie.org>,
        Jernej Skrabec <jernej.skrabec@gmail.com>,
        Samuel Holland <samuel@sholland.org>,
        Jonathan Corbet <corbet@lwn.net>,
        Rob Herring <robh@kernel.org>, linux-crypto@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-sunxi@lists.linux.dev,
        kernel@pengutronix.de
Subject: Re: [PATCH 03/42] crypto: sun8i-ss - Convert to platform remove
 callback returning void
Message-ID: <ZTkUxIdKwMrgdlyX@Red>
References: <20231020075521.2121571-44-u.kleine-koenig@pengutronix.de>
 <20231020075521.2121571-47-u.kleine-koenig@pengutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20231020075521.2121571-47-u.kleine-koenig@pengutronix.de>
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Le Fri, Oct 20, 2023 at 09:55:25AM +0200, Uwe Kleine-König a écrit :
> The .remove() callback for a platform driver returns an int which makes
> many driver authors wrongly assume it's possible to do error handling by
> returning an error code. However the value returned is ignored (apart
> from emitting a warning) and this typically results in resource leaks.
> 
> To improve here there is a quest to make the remove callback return
> void. In the first step of this quest all drivers are converted to
> .remove_new(), which already returns void. Eventually after all drivers
> are converted, .remove_new() will be renamed to .remove().
> 
> Trivially convert this driver from always returning zero in the remove
> callback to the void returning variant.
> 
> Signed-off-by: Uwe Kleine-König <u.kleine-koenig@pengutronix.de>
> ---
>  drivers/crypto/allwinner/sun8i-ss/sun8i-ss-core.c | 6 ++----
>  1 file changed, 2 insertions(+), 4 deletions(-)
> 
> diff --git a/drivers/crypto/allwinner/sun8i-ss/sun8i-ss-core.c b/drivers/crypto/allwinner/sun8i-ss/sun8i-ss-core.c
> index 4a9587285c04..f14c60359d19 100644
> --- a/drivers/crypto/allwinner/sun8i-ss/sun8i-ss-core.c
> +++ b/drivers/crypto/allwinner/sun8i-ss/sun8i-ss-core.c
> @@ -908,7 +908,7 @@ static int sun8i_ss_probe(struct platform_device *pdev)
>  	return err;
>  }
>  
> -static int sun8i_ss_remove(struct platform_device *pdev)
> +static void sun8i_ss_remove(struct platform_device *pdev)
>  {
>  	struct sun8i_ss_dev *ss = platform_get_drvdata(pdev);
>  
> @@ -921,8 +921,6 @@ static int sun8i_ss_remove(struct platform_device *pdev)
>  	sun8i_ss_free_flows(ss, MAXFLOW - 1);
>  
>  	sun8i_ss_pm_exit(ss);
> -
> -	return 0;
>  }
>  
>  static const struct of_device_id sun8i_ss_crypto_of_match_table[] = {
> @@ -936,7 +934,7 @@ MODULE_DEVICE_TABLE(of, sun8i_ss_crypto_of_match_table);
>  
>  static struct platform_driver sun8i_ss_driver = {
>  	.probe		 = sun8i_ss_probe,
> -	.remove		 = sun8i_ss_remove,
> +	.remove_new	 = sun8i_ss_remove,
>  	.driver		 = {
>  		.name		= "sun8i-ss",
>  		.pm             = &sun8i_ss_pm_ops,
> -- 
> 2.42.0
> 
Acked-by: Corentin Labbe <clabbe.montjoie@gmail.com>

Thanks
