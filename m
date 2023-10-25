Return-Path: <linux-crypto-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id ACBF0C25B47
	for <linux-crypto@archiver.kernel.org>; Wed, 25 Oct 2023 13:30:53 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235024AbjJYNax (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Wed, 25 Oct 2023 09:30:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51502 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235002AbjJYNau (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 25 Oct 2023 09:30:50 -0400
Received: from mail-lj1-x229.google.com (mail-lj1-x229.google.com [IPv6:2a00:1450:4864:20::229])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F036B13D
        for <linux-crypto@vger.kernel.org>; Wed, 25 Oct 2023 06:30:44 -0700 (PDT)
Received: by mail-lj1-x229.google.com with SMTP id 38308e7fff4ca-2c509d5ab43so86634031fa.0
        for <linux-crypto@vger.kernel.org>; Wed, 25 Oct 2023 06:30:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=baylibre-com.20230601.gappssmtp.com; s=20230601; t=1698240643; x=1698845443; darn=vger.kernel.org;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date:from:to
         :cc:subject:date:message-id:reply-to;
        bh=0ZH17l6JfmmIfOTgKCDriWdpZ0VqXYa+A6C7wL+m3E8=;
        b=vh0B3tHHEEdHkgPuT1mzoEmtjp1dm41PXH4MnSPNqXlBCICuMPmkolD6PSmrGG3Sft
         KSdG1XiRFtZHi+/b8Lkd6sfiIOBtScrcjkjpF2e6WEIWxbyIBCo0d9V5ya/UBwyne6ru
         CVTP3XQaTJsxqXdVjiQo8/F7/m9vwlV/CEucGMGFimzHhZIEyn0LVhG7ERwDrWIO849L
         y0fcXgzrsuQsQzeGCM7WasGe7OcbBATc5e3bybhe+1Y9u1j5oRQuNUOWM8SS3nQklPja
         rBvimyRKoAT55KtErhcPyjkBkn1EqgRrE2Fa7MIxD9ik93iD9hifo8WdA8ycAVNbGKZw
         Ramw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1698240643; x=1698845443;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=0ZH17l6JfmmIfOTgKCDriWdpZ0VqXYa+A6C7wL+m3E8=;
        b=iXAfMCIzu+OfEc+OJ3oOVU3+p5DZV/fAXo/CdCyFWfhuFpcCxHlSuZpLLrynrNPbPs
         ZTS36tFBhiDsmFyKixYiudP8fg0Shwe8lvHlkufsg92MpilLRovUUiUAEFwD3lqiykJv
         J5f+cag+d7sldnIPJFnMQ/TpgyU4RQmPi36uJwCMpfCd1bt3gc4n1o+cLo/P12LhnaHX
         njWJ0X2KyIiPa1Azu7faI5COQjBA1c96YdcCCcMx35dfkLI6ygrLzYeQwQvbq9qFlfMC
         HL0Rgs37tBqoZut55OC41MKqIlrJ3zwVy+bk+lMQWthSDCiVJRZO2v7CltlsT+r1BeOv
         /czw==
X-Gm-Message-State: AOJu0YzFHyvL2koznSSwDZhHiiXtr60yW8PvRhxvmtvzBzhyixngH7Z9
        h5oVrv6ZawM9WY+0RQjCPJ7LzQ==
X-Google-Smtp-Source: AGHT+IGZo6iDT1CA4AvNNgTcmn/zXM3EPbZ85Dap4S3WUMvTVsxabE0rDAp36X7juUzHFkcqhdEUeg==
X-Received: by 2002:a2e:bc22:0:b0:2c0:17bc:124e with SMTP id b34-20020a2ebc22000000b002c017bc124emr13053833ljf.38.1698240643124;
        Wed, 25 Oct 2023 06:30:43 -0700 (PDT)
Received: from Red ([2a01:cb1d:3d5:a100:4a02:2aff:fe07:1efc])
        by smtp.googlemail.com with ESMTPSA id i18-20020a05600c481200b00407b93d8085sm19072989wmo.27.2023.10.25.06.30.42
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 25 Oct 2023 06:30:42 -0700 (PDT)
Date:   Wed, 25 Oct 2023 15:30:41 +0200
From:   Corentin LABBE <clabbe@baylibre.com>
To:     Uwe =?iso-8859-1?Q?Kleine-K=F6nig?= 
        <u.kleine-koenig@pengutronix.de>
Cc:     Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>,
        Hans Ulli Kroll <ulli.kroll@googlemail.com>,
        Linus Walleij <linus.walleij@linaro.org>,
        linux-arm-kernel@lists.infradead.org, linux-crypto@vger.kernel.org,
        kernel@pengutronix.de
Subject: Re: [PATCH 17/42] crypto: gemini/sl3516-ce - Convert to platform
 remove callback returning void
Message-ID: <ZTkYgeOiNvuRgDxE@Red>
References: <20231020075521.2121571-44-u.kleine-koenig@pengutronix.de>
 <20231020075521.2121571-61-u.kleine-koenig@pengutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20231020075521.2121571-61-u.kleine-koenig@pengutronix.de>
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Le Fri, Oct 20, 2023 at 09:55:39AM +0200, Uwe Kleine-König a écrit :
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
>  drivers/crypto/gemini/sl3516-ce-core.c | 6 ++----
>  1 file changed, 2 insertions(+), 4 deletions(-)
> 
> diff --git a/drivers/crypto/gemini/sl3516-ce-core.c b/drivers/crypto/gemini/sl3516-ce-core.c
> index 0f43c6e39bb9..1d1a889599bb 100644
> --- a/drivers/crypto/gemini/sl3516-ce-core.c
> +++ b/drivers/crypto/gemini/sl3516-ce-core.c
> @@ -505,7 +505,7 @@ static int sl3516_ce_probe(struct platform_device *pdev)
>  	return err;
>  }
>  
> -static int sl3516_ce_remove(struct platform_device *pdev)
> +static void sl3516_ce_remove(struct platform_device *pdev)
>  {
>  	struct sl3516_ce_dev *ce = platform_get_drvdata(pdev);
>  
> @@ -518,8 +518,6 @@ static int sl3516_ce_remove(struct platform_device *pdev)
>  #ifdef CONFIG_CRYPTO_DEV_SL3516_DEBUG
>  	debugfs_remove_recursive(ce->dbgfs_dir);
>  #endif
> -
> -	return 0;
>  }
>  
>  static const struct of_device_id sl3516_ce_crypto_of_match_table[] = {
> @@ -530,7 +528,7 @@ MODULE_DEVICE_TABLE(of, sl3516_ce_crypto_of_match_table);
>  
>  static struct platform_driver sl3516_ce_driver = {
>  	.probe		 = sl3516_ce_probe,
> -	.remove		 = sl3516_ce_remove,
> +	.remove_new	 = sl3516_ce_remove,
>  	.driver		 = {
>  		.name		= "sl3516-crypto",
>  		.pm		= &sl3516_ce_pm_ops,
> -- 
> 2.42.0
> 

Acked-by: Corentin Labbe <clabbe@baylibre.com>

Thanks
