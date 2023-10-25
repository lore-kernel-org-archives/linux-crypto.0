Return-Path: <linux-crypto-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 93510C0032E
	for <linux-crypto@archiver.kernel.org>; Wed, 25 Oct 2023 13:30:40 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344548AbjJYNaj (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Wed, 25 Oct 2023 09:30:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38488 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344553AbjJYNah (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 25 Oct 2023 09:30:37 -0400
Received: from mail-wm1-x32b.google.com (mail-wm1-x32b.google.com [IPv6:2a00:1450:4864:20::32b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 46073138
        for <linux-crypto@vger.kernel.org>; Wed, 25 Oct 2023 06:30:34 -0700 (PDT)
Received: by mail-wm1-x32b.google.com with SMTP id 5b1f17b1804b1-4083f61322fso44918815e9.1
        for <linux-crypto@vger.kernel.org>; Wed, 25 Oct 2023 06:30:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=baylibre-com.20230601.gappssmtp.com; s=20230601; t=1698240632; x=1698845432; darn=vger.kernel.org;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date:from:to
         :cc:subject:date:message-id:reply-to;
        bh=Qc3B3MR651658a+IS4oxOuyfK9TAfTIo7Wzkmg44LJo=;
        b=AvjWNWkWxRm61QbpYfBhp2bOzezSvOfinInYX0CkzonkWXnjm0f0ZWLycHVvEElIOC
         JA3A1TLDAE7q1e8tZSg8vxw0QiVQRBjGnoCMqj99Sq0negBYJd9w8Vno2bEVa479/5XL
         OLl/7YrJIAGbyR5dDa6OXV7tUGa0AGZ7hcLi0z01MB/q14jW4nEBj/x5LtrGV7NMjP1J
         Ud6c1ORrQyATn9iF5mJGaLMHGGNfob2Y+o2/4zryhtIF72oveO9QNUqdV/9ZV43GZFJw
         3tVsiOs7suFJ5xGoABAMOYPRL1GwOuhdtfHyu3acrwa6rXJ32tP41wY1vlU8sm+/wFee
         nuSw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1698240632; x=1698845432;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=Qc3B3MR651658a+IS4oxOuyfK9TAfTIo7Wzkmg44LJo=;
        b=uHjQvOkaQp2Sre0fu82bH6LJUK6swC+AQH3mVqjEYJE9fX2GnUUYbIN9nvUEqjhaEw
         wbmarrYYA7wpOoB/eRB91MIdS5h96DNjsYepu4gHiNcPE4KHGLmgFcZ13YPh/CkTVRWi
         h06reu9RG11ITJaww/epUuZtWyURJZDny7pg8FSFlqhV7Odckt9Hkf6zpDA+N9LWKH3y
         7pARPMgzbuHpfrWYV6m0xEkqXHf4wKfY4IYGTskcnh/2UR41vjtKx/eBfqltLGBbkLkO
         8RCzkCYk+RJaNa7p2TYq4ocmxlRPXVbNpcnGNw4mH1BCoW/odMsCHBwAsIYOoTuc98JC
         fitg==
X-Gm-Message-State: AOJu0Yx0ZlaDNQd+vHzC7OgqPfcMpSYRWVX1fD4vo1N0VaNBDJj3bzWl
        jWNlZRLem6eHvmv/wU1aMswpQWs/B//mKUuaubA=
X-Google-Smtp-Source: AGHT+IFu+w3osoX+yY1js+KvkKlRPdJPihfR6ey606N4UPL18NXlj4qIi9my+j9HZFy0hyRjvR8aKA==
X-Received: by 2002:a05:600c:1910:b0:401:b2c7:34a8 with SMTP id j16-20020a05600c191000b00401b2c734a8mr11982343wmq.7.1698240632431;
        Wed, 25 Oct 2023 06:30:32 -0700 (PDT)
Received: from Red ([2a01:cb1d:3d5:a100:4a02:2aff:fe07:1efc])
        by smtp.googlemail.com with ESMTPSA id j15-20020a05600c1c0f00b003fefb94ccc9sm14797439wms.11.2023.10.25.06.30.31
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 25 Oct 2023 06:30:31 -0700 (PDT)
Date:   Wed, 25 Oct 2023 15:30:30 +0200
From:   Corentin LABBE <clabbe@baylibre.com>
To:     Uwe =?iso-8859-1?Q?Kleine-K=F6nig?= 
        <u.kleine-koenig@pengutronix.de>
Cc:     Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>,
        linux-crypto@vger.kernel.org, linux-amlogic@lists.infradead.org,
        kernel@pengutronix.de
Subject: Re: [PATCH 05/42] crypto: amlogic-gxl-core - Convert to platform
 remove callback returning void
Message-ID: <ZTkYdqL6Vb07cCjo@Red>
References: <20231020075521.2121571-44-u.kleine-koenig@pengutronix.de>
 <20231020075521.2121571-49-u.kleine-koenig@pengutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20231020075521.2121571-49-u.kleine-koenig@pengutronix.de>
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Le Fri, Oct 20, 2023 at 09:55:27AM +0200, Uwe Kleine-König a écrit :
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
>  drivers/crypto/amlogic/amlogic-gxl-core.c | 5 ++---
>  1 file changed, 2 insertions(+), 3 deletions(-)
> 
> diff --git a/drivers/crypto/amlogic/amlogic-gxl-core.c b/drivers/crypto/amlogic/amlogic-gxl-core.c
> index da6dfe0f9ac3..f54ab0d0b1e8 100644
> --- a/drivers/crypto/amlogic/amlogic-gxl-core.c
> +++ b/drivers/crypto/amlogic/amlogic-gxl-core.c
> @@ -299,7 +299,7 @@ static int meson_crypto_probe(struct platform_device *pdev)
>  	return err;
>  }
>  
> -static int meson_crypto_remove(struct platform_device *pdev)
> +static void meson_crypto_remove(struct platform_device *pdev)
>  {
>  	struct meson_dev *mc = platform_get_drvdata(pdev);
>  
> @@ -312,7 +312,6 @@ static int meson_crypto_remove(struct platform_device *pdev)
>  	meson_free_chanlist(mc, MAXFLOW - 1);
>  
>  	clk_disable_unprepare(mc->busclk);
> -	return 0;
>  }
>  
>  static const struct of_device_id meson_crypto_of_match_table[] = {
> @@ -323,7 +322,7 @@ MODULE_DEVICE_TABLE(of, meson_crypto_of_match_table);
>  
>  static struct platform_driver meson_crypto_driver = {
>  	.probe		 = meson_crypto_probe,
> -	.remove		 = meson_crypto_remove,
> +	.remove_new	 = meson_crypto_remove,
>  	.driver		 = {
>  		.name		   = "gxl-crypto",
>  		.of_match_table	= meson_crypto_of_match_table,
> -- 
> 2.42.0
> 

Acked-by: Corentin Labbe <clabbe@baylibre.com>

Thanks
