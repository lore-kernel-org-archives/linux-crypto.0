Return-Path: <linux-crypto-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 62CFCC0032E
	for <linux-crypto@archiver.kernel.org>; Wed, 25 Oct 2023 13:14:39 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234959AbjJYNOj (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Wed, 25 Oct 2023 09:14:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38482 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232789AbjJYNOi (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 25 Oct 2023 09:14:38 -0400
Received: from mail-wm1-x331.google.com (mail-wm1-x331.google.com [IPv6:2a00:1450:4864:20::331])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A0F62111
        for <linux-crypto@vger.kernel.org>; Wed, 25 Oct 2023 06:14:36 -0700 (PDT)
Received: by mail-wm1-x331.google.com with SMTP id 5b1f17b1804b1-40842752c6eso44551405e9.1
        for <linux-crypto@vger.kernel.org>; Wed, 25 Oct 2023 06:14:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1698239675; x=1698844475; darn=vger.kernel.org;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date:from:to
         :cc:subject:date:message-id:reply-to;
        bh=dkwfkDFcx7Qd4lPxQDGJFr4+GYrnmCr3zCpgntOLtp4=;
        b=dehMfyUVMS0+7cqReY3U0Pr7zW3z1It6TkveSw6DHYhth8ND88nJZQo6la63UuZT5H
         uPsRWUf50Y3sr5jMbpL0TFw++yfRHfakmRExB1JtXWIfTk/ve3c7luyX1z7a94XwiF18
         s8VCTwVpy1MqC468uxeje5cBpybj9jDzvaD61H6vNdy6OP+eTZFuH74/nD9zAKGT1rHz
         kURAit3K22rtkaoFpeP1Qvlezg1F2pAJ5YOiqC9QOROLvq8Ml8FQEVktH2IaOu7YghcH
         f10ZxZW5X4gzXrq89MdTedr2No2zfdb9q6K3IUxGfvPPyqx4nv8mTXeguKb8m7y6UF7u
         +aYQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1698239675; x=1698844475;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=dkwfkDFcx7Qd4lPxQDGJFr4+GYrnmCr3zCpgntOLtp4=;
        b=sOgiAH3brYY0zBKwNA2n+OCjeu8DIo36bQIxs0IYN540QJzwl/UX5BTNPf6CrPd2YN
         PredXiL2UM1/B8NaXVl1+E8BdEHLwYl9qJDGQInm3SMCTz/vayOhntTNnZ3/NQPCw/KB
         3o1qDrok0zD1YFEBF/dzXH7gt2Lhjqx+oWafvzv4svBpB1JHOsT1WV0sdxbLOJJriZn7
         Cn7pxrw1bawqZ3b251xDPcRBUH5eyStvR96AisQ30lrEi868B0NMCYjfXKuuZ/4DV5lw
         DAIWZV3aPkhn61z0nolQGKAlRHdptOc4nQLGDUdWJkf4wyVji2CB/TgNMSLWxULIe8Vr
         3cWw==
X-Gm-Message-State: AOJu0YzAcx6v2HIESY1reMEvkNRctEMf2/7VM2fPOQDxXI9ZR1IvW1bp
        BncCLmrILoe2Bn4Raq0EacjsAYokb/E=
X-Google-Smtp-Source: AGHT+IFIiz0Gaa/L3N3mVvS6AZLsa1VCn8csfWCEXKdQ05Lj7wJli+7bRyrc7CgPva0DpaJiaRG8Mw==
X-Received: by 2002:a05:600c:4747:b0:405:359a:c950 with SMTP id w7-20020a05600c474700b00405359ac950mr11938669wmo.19.1698239674751;
        Wed, 25 Oct 2023 06:14:34 -0700 (PDT)
Received: from Red ([2a01:cb1d:3d5:a100:4a02:2aff:fe07:1efc])
        by smtp.googlemail.com with ESMTPSA id x22-20020a05600c189600b004083a105f27sm19036428wmp.26.2023.10.25.06.14.34
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 25 Oct 2023 06:14:34 -0700 (PDT)
Date:   Wed, 25 Oct 2023 15:14:33 +0200
From:   Corentin Labbe <clabbe.montjoie@gmail.com>
To:     Uwe =?iso-8859-1?Q?Kleine-K=F6nig?= 
        <u.kleine-koenig@pengutronix.de>
Cc:     Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>,
        Chen-Yu Tsai <wens@csie.org>,
        Jernej Skrabec <jernej.skrabec@gmail.com>,
        Samuel Holland <samuel@sholland.org>,
        Rob Herring <robh@kernel.org>,
        Jonathan Corbet <corbet@lwn.net>, linux-crypto@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-sunxi@lists.linux.dev,
        kernel@pengutronix.de
Subject: Re: [PATCH 02/42] crypto: sun8i-ce - Convert to platform remove
 callback returning void
Message-ID: <ZTkUuQ4cu-Z593_f@Red>
References: <20231020075521.2121571-44-u.kleine-koenig@pengutronix.de>
 <20231020075521.2121571-46-u.kleine-koenig@pengutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20231020075521.2121571-46-u.kleine-koenig@pengutronix.de>
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Le Fri, Oct 20, 2023 at 09:55:24AM +0200, Uwe Kleine-König a écrit :
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
>  drivers/crypto/allwinner/sun8i-ce/sun8i-ce-core.c | 5 ++---
>  1 file changed, 2 insertions(+), 3 deletions(-)
> 
> diff --git a/drivers/crypto/allwinner/sun8i-ce/sun8i-ce-core.c b/drivers/crypto/allwinner/sun8i-ce/sun8i-ce-core.c
> index d4ccd5254280..1741758e03eb 100644
> --- a/drivers/crypto/allwinner/sun8i-ce/sun8i-ce-core.c
> +++ b/drivers/crypto/allwinner/sun8i-ce/sun8i-ce-core.c
> @@ -1071,7 +1071,7 @@ static int sun8i_ce_probe(struct platform_device *pdev)
>  	return err;
>  }
>  
> -static int sun8i_ce_remove(struct platform_device *pdev)
> +static void sun8i_ce_remove(struct platform_device *pdev)
>  {
>  	struct sun8i_ce_dev *ce = platform_get_drvdata(pdev);
>  
> @@ -1088,7 +1088,6 @@ static int sun8i_ce_remove(struct platform_device *pdev)
>  	sun8i_ce_free_chanlist(ce, MAXFLOW - 1);
>  
>  	sun8i_ce_pm_exit(ce);
> -	return 0;
>  }
>  
>  static const struct of_device_id sun8i_ce_crypto_of_match_table[] = {
> @@ -1110,7 +1109,7 @@ MODULE_DEVICE_TABLE(of, sun8i_ce_crypto_of_match_table);
>  
>  static struct platform_driver sun8i_ce_driver = {
>  	.probe		 = sun8i_ce_probe,
> -	.remove		 = sun8i_ce_remove,
> +	.remove_new	 = sun8i_ce_remove,
>  	.driver		 = {
>  		.name		= "sun8i-ce",
>  		.pm		= &sun8i_ce_pm_ops,
> -- 
> 2.42.0
> 
Acked-by: Corentin Labbe <clabbe.montjoie@gmail.com>

Thanks
