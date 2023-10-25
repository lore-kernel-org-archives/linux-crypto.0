Return-Path: <linux-crypto-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0273EC07545
	for <linux-crypto@archiver.kernel.org>; Wed, 25 Oct 2023 13:14:00 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234971AbjJYNOB (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Wed, 25 Oct 2023 09:14:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42900 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234959AbjJYNOA (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 25 Oct 2023 09:14:00 -0400
Received: from mail-wr1-x42e.google.com (mail-wr1-x42e.google.com [IPv6:2a00:1450:4864:20::42e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6098E182
        for <linux-crypto@vger.kernel.org>; Wed, 25 Oct 2023 06:13:58 -0700 (PDT)
Received: by mail-wr1-x42e.google.com with SMTP id ffacd0b85a97d-32dbbf3c782so523012f8f.1
        for <linux-crypto@vger.kernel.org>; Wed, 25 Oct 2023 06:13:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1698239637; x=1698844437; darn=vger.kernel.org;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date:from:to
         :cc:subject:date:message-id:reply-to;
        bh=0snOBFDkNxaQ8hqvYUXLFUigtIsrarAvrFjX75PwbE4=;
        b=jlsD405u+1igXi+c3Ipxkcg6syDJ99XUDtBUcC7J/oLOTUCTqvoNkG5QtSrlvCTebE
         GoQrZxDEgANntXuQRNvzU1IK+JSGOlluUIBj89uL+OvXU8tk2rHaAQT2+duyaGlPDsOZ
         TDT+gLe44klmASSvAIPuB1TeTkWeKbZ/GiAWoKIpSpPmAoEdzEsAIS1xBPM215nTEhPI
         3hFXsDKt7TW9ixLH2zYtG3SO98GQAoEkwvQuS9ZHpUivkdGlC9eyoe7EAj6ngSFNESHV
         A1tCOUeGNu9a2ZOm0AijqA9ivqFUVkCmU3dU2199R4Ed8+PQgPB+ZliWG5u8Fh5ZGT2A
         9s+A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1698239637; x=1698844437;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=0snOBFDkNxaQ8hqvYUXLFUigtIsrarAvrFjX75PwbE4=;
        b=eD404f4AfdWuRKllA+/YnN2eyum6d/GDukvthdZ7soT7McUTV+/mi25ruNyEoq0/pc
         mXiMWMU9FSA3hfz5QVCIBJjcIEvnXQsRDx1NwIWwc4TL1wcOunrCIIyaYADhYB8kHcJX
         CbzwX/Iv8on7bT3J8f11Okw29l6+iukAE59aZF2vbLJSXpYzZGThS8MHYR9COTUERKTn
         1JlqnF2pG4TkKz+m+aOuyQTvhz5vUfsmSR5KIHFr6qnWI6x6ztbWf5CuAFUVKTv2i4GY
         lqnvmhg0L1rCgmuV7ZQ40WoFI1dYchky9YshMX6o0+OfNRt9tqkdNmp+HIcLRnXpK1el
         aJEw==
X-Gm-Message-State: AOJu0Yzlt54rO5iOQuqbhSB2USqm9EJ7LiKJtGIoU6Oa+ihIj5a9dEHq
        DxCW78zFnbxRKGXTp8QjLzA=
X-Google-Smtp-Source: AGHT+IErz0EQGvLQbRef9SN5Vh8Xo+GHXjPBuT+skFgyEYLw4/yqaK0Z8I+UnZVewsLLXzAzENPDgg==
X-Received: by 2002:adf:ecd1:0:b0:31d:caae:982d with SMTP id s17-20020adfecd1000000b0031dcaae982dmr13700694wro.12.1698239636579;
        Wed, 25 Oct 2023 06:13:56 -0700 (PDT)
Received: from Red ([2a01:cb1d:3d5:a100:4a02:2aff:fe07:1efc])
        by smtp.googlemail.com with ESMTPSA id x12-20020a5d650c000000b0032d9a1f2ec3sm12019266wru.27.2023.10.25.06.13.55
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 25 Oct 2023 06:13:56 -0700 (PDT)
Date:   Wed, 25 Oct 2023 15:13:54 +0200
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
Subject: Re: [PATCH 01/42] crypto: sun4i-ss - Convert to platform remove
 callback returning void
Message-ID: <ZTkUkp3NPpX0blk0@Red>
References: <20231020075521.2121571-44-u.kleine-koenig@pengutronix.de>
 <20231020075521.2121571-45-u.kleine-koenig@pengutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20231020075521.2121571-45-u.kleine-koenig@pengutronix.de>
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Le Fri, Oct 20, 2023 at 09:55:23AM +0200, Uwe Kleine-König a écrit :
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
>  drivers/crypto/allwinner/sun4i-ss/sun4i-ss-core.c | 5 ++---
>  1 file changed, 2 insertions(+), 3 deletions(-)
> 
> diff --git a/drivers/crypto/allwinner/sun4i-ss/sun4i-ss-core.c b/drivers/crypto/allwinner/sun4i-ss/sun4i-ss-core.c
> index 3bcfcfc37084..ba80878e2df5 100644
> --- a/drivers/crypto/allwinner/sun4i-ss/sun4i-ss-core.c
> +++ b/drivers/crypto/allwinner/sun4i-ss/sun4i-ss-core.c
> @@ -509,7 +509,7 @@ static int sun4i_ss_probe(struct platform_device *pdev)
>  	return err;
>  }
>  
> -static int sun4i_ss_remove(struct platform_device *pdev)
> +static void sun4i_ss_remove(struct platform_device *pdev)
>  {
>  	int i;
>  	struct sun4i_ss_ctx *ss = platform_get_drvdata(pdev);
> @@ -529,7 +529,6 @@ static int sun4i_ss_remove(struct platform_device *pdev)
>  	}
>  
>  	sun4i_ss_pm_exit(ss);
> -	return 0;
>  }
>  
>  static const struct of_device_id a20ss_crypto_of_match_table[] = {
> @@ -545,7 +544,7 @@ MODULE_DEVICE_TABLE(of, a20ss_crypto_of_match_table);
>  
>  static struct platform_driver sun4i_ss_driver = {
>  	.probe          = sun4i_ss_probe,
> -	.remove         = sun4i_ss_remove,
> +	.remove_new     = sun4i_ss_remove,
>  	.driver         = {
>  		.name           = "sun4i-ss",
>  		.pm		= &sun4i_ss_pm_ops,
> -- 
> 2.42.0
> 

Acked-by: Corentin Labbe <clabbe.montjoie@gmail.com>

Thanks
