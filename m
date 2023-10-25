Return-Path: <linux-crypto-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2D18FC25B6D
	for <linux-crypto@archiver.kernel.org>; Wed, 25 Oct 2023 13:31:18 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344687AbjJYNbQ (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Wed, 25 Oct 2023 09:31:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42228 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344586AbjJYNbA (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 25 Oct 2023 09:31:00 -0400
Received: from mail-wm1-x329.google.com (mail-wm1-x329.google.com [IPv6:2a00:1450:4864:20::329])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DC3AF19B
        for <linux-crypto@vger.kernel.org>; Wed, 25 Oct 2023 06:30:54 -0700 (PDT)
Received: by mail-wm1-x329.google.com with SMTP id 5b1f17b1804b1-40839807e82so5500625e9.0
        for <linux-crypto@vger.kernel.org>; Wed, 25 Oct 2023 06:30:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=baylibre-com.20230601.gappssmtp.com; s=20230601; t=1698240653; x=1698845453; darn=vger.kernel.org;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date:from:to
         :cc:subject:date:message-id:reply-to;
        bh=RG2mfTqWbL3cxDA9gME5AJbCoVhfsJy6L44fFhUJ/WQ=;
        b=kEDXqe7UH8ClEgA/ECdoBeGnmPewZnnnCTcfK2qLu/1GUtWsLLnIAKpIk9x3jNs/E6
         tpGd4dfK7FGNUWp6mwYGhnDNAUsobbflSR34uEPXr+VGQVdtsIA179PIMtJYuZ0dupYc
         +cstDofbn4tnetBdoriYsDEnLVsZriioLkCrW4/hbUyZtF/iXXeKr7/5sd6b8qo8f1yh
         hYYrVDC4TrhTrTCyoyeVZPzH/dhu+M8VY/VEEOc+AljWDAII/7EjsAPuEeSA+llb18tm
         dBdlWtqxh2Ngl5l/6Vh25AOz9BCNORVul3z9nc5fzcHcB1GAQjx9HRbkT2gA4Wud+0NI
         VlFQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1698240653; x=1698845453;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=RG2mfTqWbL3cxDA9gME5AJbCoVhfsJy6L44fFhUJ/WQ=;
        b=ml8fz4BEIfq5DirOEy5Fw6W0CE5YAfkc0bPejbyercehc8xQqJ5l0rWFQAOBwpwdBz
         2vdttZEF77Ze5aenrcVAVBDymmPFjNtolHLp6cJaJ/ZGCvWl0jp08ve3+42evwhdZtK2
         34wXNhi3E6/mMTw9ZThiP6wHZtNoPNdCrjAqB3DfLNPziCoMrXgl/Y3tMozW9rP+r25g
         jY9eutwR6vwH05OqGqmvRJnFKsbgi4txb+ccboDjwvxUbXqvJewSkRes+gwt6ADCdwJx
         lAn+jWL71o6GZazmrsZVj36aI/KGdNxxgj4UJT1Um4HoaC6Q1EEOszyT2MIVVUSuIG4s
         2YXw==
X-Gm-Message-State: AOJu0YxMkRy7JGaj1C/Rf8/2AifD3Xc1JScw10Q5R7dh/t3cmg/5SNll
        D8TSWmzu85EUwxQ/uICJjs+6WQ==
X-Google-Smtp-Source: AGHT+IGFJqTIiUDn1kAQ1w139jUc3diI2ZBrCiD3gSHxz3gn9LbP0N0kaebCZoNwG1oK/xr18xG+eg==
X-Received: by 2002:a05:600c:310d:b0:406:44fc:65c9 with SMTP id g13-20020a05600c310d00b0040644fc65c9mr16195701wmo.8.1698240653281;
        Wed, 25 Oct 2023 06:30:53 -0700 (PDT)
Received: from Red ([2a01:cb1d:3d5:a100:4a02:2aff:fe07:1efc])
        by smtp.googlemail.com with ESMTPSA id je20-20020a05600c1f9400b004063ea92492sm14921894wmb.22.2023.10.25.06.30.52
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 25 Oct 2023 06:30:52 -0700 (PDT)
Date:   Wed, 25 Oct 2023 15:30:51 +0200
From:   Corentin LABBE <clabbe@baylibre.com>
To:     Uwe =?iso-8859-1?Q?Kleine-K=F6nig?= 
        <u.kleine-koenig@pengutronix.de>
Cc:     Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>,
        Linus Walleij <linusw@kernel.org>,
        Imre Kaloz <kaloz@openwrt.org>,
        linux-arm-kernel@lists.infradead.org, linux-crypto@vger.kernel.org,
        kernel@pengutronix.de
Subject: Re: [PATCH 22/42] crypto: intel/ixp4xx-crypto - Convert to platform
 remove callback returning void
Message-ID: <ZTkYi1Wdg_ZWOa5e@Red>
References: <20231020075521.2121571-44-u.kleine-koenig@pengutronix.de>
 <20231020075521.2121571-66-u.kleine-koenig@pengutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20231020075521.2121571-66-u.kleine-koenig@pengutronix.de>
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Le Fri, Oct 20, 2023 at 09:55:44AM +0200, Uwe Kleine-König a écrit :
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
>  drivers/crypto/intel/ixp4xx/ixp4xx_crypto.c | 6 ++----
>  1 file changed, 2 insertions(+), 4 deletions(-)
> 
> diff --git a/drivers/crypto/intel/ixp4xx/ixp4xx_crypto.c b/drivers/crypto/intel/ixp4xx/ixp4xx_crypto.c
> index 4a18095ae5d8..f8a77bff8844 100644
> --- a/drivers/crypto/intel/ixp4xx/ixp4xx_crypto.c
> +++ b/drivers/crypto/intel/ixp4xx/ixp4xx_crypto.c
> @@ -1563,7 +1563,7 @@ static int ixp_crypto_probe(struct platform_device *_pdev)
>  	return 0;
>  }
>  
> -static int ixp_crypto_remove(struct platform_device *pdev)
> +static void ixp_crypto_remove(struct platform_device *pdev)
>  {
>  	int num = ARRAY_SIZE(ixp4xx_algos);
>  	int i;
> @@ -1578,8 +1578,6 @@ static int ixp_crypto_remove(struct platform_device *pdev)
>  			crypto_unregister_skcipher(&ixp4xx_algos[i].crypto);
>  	}
>  	release_ixp_crypto(&pdev->dev);
> -
> -	return 0;
>  }
>  static const struct of_device_id ixp4xx_crypto_of_match[] = {
>  	{
> @@ -1590,7 +1588,7 @@ static const struct of_device_id ixp4xx_crypto_of_match[] = {
>  
>  static struct platform_driver ixp_crypto_driver = {
>  	.probe = ixp_crypto_probe,
> -	.remove = ixp_crypto_remove,
> +	.remove_new = ixp_crypto_remove,
>  	.driver = {
>  		.name = "ixp4xx_crypto",
>  		.of_match_table = ixp4xx_crypto_of_match,
> -- 
> 2.42.0
> 

Acked-by: Corentin Labbe <clabbe@baylibre.com>

Thanks
