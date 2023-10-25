Return-Path: <linux-crypto-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4FCBEC0032E
	for <linux-crypto@archiver.kernel.org>; Wed, 25 Oct 2023 13:32:00 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344716AbjJYNcA (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Wed, 25 Oct 2023 09:32:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42294 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235018AbjJYNbc (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 25 Oct 2023 09:31:32 -0400
Received: from mail-wm1-x32d.google.com (mail-wm1-x32d.google.com [IPv6:2a00:1450:4864:20::32d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5D56710D0
        for <linux-crypto@vger.kernel.org>; Wed, 25 Oct 2023 06:31:13 -0700 (PDT)
Received: by mail-wm1-x32d.google.com with SMTP id 5b1f17b1804b1-4079ed65582so44321535e9.1
        for <linux-crypto@vger.kernel.org>; Wed, 25 Oct 2023 06:31:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=baylibre-com.20230601.gappssmtp.com; s=20230601; t=1698240672; x=1698845472; darn=vger.kernel.org;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date:from:to
         :cc:subject:date:message-id:reply-to;
        bh=WJHhodEo9Mg5Sb1D06HbWzBXmtfErODVASwmg4rpCew=;
        b=ThrkpWW6DcHqv6j3ND/GS9JQtqTItxY8GLOtAVhCW9RrwDEN7Js7tUCgKZ60/D8E0Z
         oif5nfKlqZzTRFyBW3jQmUUdweDc1tFJzC5sRg3+YJTdvETa9i+HTvBPmkFZDxYFcN4Y
         Q5r0DHYmqac1erbgJCotv1qVgPRRdmxumH+3rE9Zd3ryZXv7Re+P4b3olYl5PsFN3g+A
         uheGwtaw4lLp5CSaLhkH32aV1ejEooptbR4iYH48Fk5aoLAqrSxpTvRN5GQ2jcdobu3M
         WMqEJ4AyEXwN4EQPDyjWj7j92fNNAjws+d1suqeEMx+N49Lg53B4YLWyeB3zNkUqAeyB
         wppA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1698240672; x=1698845472;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=WJHhodEo9Mg5Sb1D06HbWzBXmtfErODVASwmg4rpCew=;
        b=ul5d8qijJWCZaOKCXgdUf/dxQUktSthKCFoZOsCGZDUax1NIlPQWA1Yn413qaP3Pp8
         4JfUALJ4BFVT8i8hDY/Ml5XA6QT4ZEWyUCflSOAJ1N1j12Q+yeP8SPeCtrwE5SyBFwxL
         qbCtAGb8YZBXr5QLxdMyJ8thQ6+kwzWQlCOVqpQpMYYvLuZCT7stuozHpNZjthQyQCXL
         apATDHPnaHhoxEPMGKXlfCV1P0Jfudavn3eHxq9uE9U9svORqOFszxiO47rjrKNPOMt3
         jQhvYrrU1xkQLfoHSdhMpMB4vpLafgx7l5NpIV7r5AOO8+a45J/MnVnDkc2egETmgfe+
         e9iQ==
X-Gm-Message-State: AOJu0YxA4NvgUrt7F7YAOUP2CqnZwTJAQhw3lEeM5mx95GTwsL9GNusb
        akuQXIGJynJ25Y1kBQhjAAQYUQ==
X-Google-Smtp-Source: AGHT+IG5TmoQSWagYVZDYEFtA3xQyjVPh4wRtdL4nDgviNvJdR54Bqa+t6mU4jxmEiLEOP/aqcQnpg==
X-Received: by 2002:adf:e943:0:b0:329:6bdc:5a60 with SMTP id m3-20020adfe943000000b003296bdc5a60mr10530917wrn.12.1698240671827;
        Wed, 25 Oct 2023 06:31:11 -0700 (PDT)
Received: from Red ([2a01:cb1d:3d5:a100:4a02:2aff:fe07:1efc])
        by smtp.googlemail.com with ESMTPSA id f4-20020a5d50c4000000b0032da319a27asm12213088wrt.9.2023.10.25.06.31.10
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 25 Oct 2023 06:31:11 -0700 (PDT)
Date:   Wed, 25 Oct 2023 15:31:09 +0200
From:   Corentin LABBE <clabbe@baylibre.com>
To:     Uwe =?iso-8859-1?Q?Kleine-K=F6nig?= 
        <u.kleine-koenig@pengutronix.de>
Cc:     Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>,
        Heiko Stuebner <heiko@sntech.de>, linux-crypto@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        linux-rockchip@lists.infradead.org, kernel@pengutronix.de
Subject: Re: [PATCH 34/42] crypto: rockchip/rk3288 - Convert to platform
 remove callback returning void
Message-ID: <ZTkYnTY7VxIaIUak@Red>
References: <20231020075521.2121571-44-u.kleine-koenig@pengutronix.de>
 <20231020075521.2121571-78-u.kleine-koenig@pengutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20231020075521.2121571-78-u.kleine-koenig@pengutronix.de>
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Le Fri, Oct 20, 2023 at 09:55:56AM +0200, Uwe Kleine-König a écrit :
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
>  drivers/crypto/rockchip/rk3288_crypto.c | 5 ++---
>  1 file changed, 2 insertions(+), 3 deletions(-)
> 
> diff --git a/drivers/crypto/rockchip/rk3288_crypto.c b/drivers/crypto/rockchip/rk3288_crypto.c
> index 77d5705a5d96..70edf40bc523 100644
> --- a/drivers/crypto/rockchip/rk3288_crypto.c
> +++ b/drivers/crypto/rockchip/rk3288_crypto.c
> @@ -405,7 +405,7 @@ static int rk_crypto_probe(struct platform_device *pdev)
>  	return err;
>  }
>  
> -static int rk_crypto_remove(struct platform_device *pdev)
> +static void rk_crypto_remove(struct platform_device *pdev)
>  {
>  	struct rk_crypto_info *crypto_tmp = platform_get_drvdata(pdev);
>  	struct rk_crypto_info *first;
> @@ -424,12 +424,11 @@ static int rk_crypto_remove(struct platform_device *pdev)
>  	}
>  	rk_crypto_pm_exit(crypto_tmp);
>  	crypto_engine_exit(crypto_tmp->engine);
> -	return 0;
>  }
>  
>  static struct platform_driver crypto_driver = {
>  	.probe		= rk_crypto_probe,
> -	.remove		= rk_crypto_remove,
> +	.remove_new	= rk_crypto_remove,
>  	.driver		= {
>  		.name	= "rk3288-crypto",
>  		.pm		= &rk_crypto_pm_ops,
> -- 
> 2.42.0
> 

Acked-by: Corentin Labbe <clabbe@baylibre.com>

Thanks
