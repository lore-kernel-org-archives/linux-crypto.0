Return-Path: <SRS0=gkSk=CZ=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.6 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CE502C43461
	for <linux-crypto@archiver.kernel.org>; Wed, 16 Sep 2020 09:33:16 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 917F022207
	for <linux-crypto@archiver.kernel.org>; Wed, 16 Sep 2020 09:33:16 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="A+yh78E6"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726570AbgIPJdP (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Wed, 16 Sep 2020 05:33:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42544 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726425AbgIPJdO (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 16 Sep 2020 05:33:14 -0400
Received: from mail-wm1-x344.google.com (mail-wm1-x344.google.com [IPv6:2a00:1450:4864:20::344])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1A109C06174A;
        Wed, 16 Sep 2020 02:33:14 -0700 (PDT)
Received: by mail-wm1-x344.google.com with SMTP id e11so1817902wme.0;
        Wed, 16 Sep 2020 02:33:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=YjecuPhauQHL4j4Z2a9keky4ajO3faW/VO0iw9ZMsyw=;
        b=A+yh78E6fm9DBZfbdqzQH+qzcsEGu6J4+jBTWy2YENyyyt2Zbq0S/OFMY+YMWluCW8
         z8t3xi+iP90JmyDxktlPvCO+1T3U3hFBPr8qrN+yRgMmJ0GM2L7qRI0Eo3AOZ7RMkQPe
         LWE3uzHR7S4jsQzPTnyioG1nqAXIH9Jsv1zZo5fzHTOi1paYswkOFIvKmndmutMHCR0b
         y7j++ofj0gze7dcveAmPNZVSNVJ8f7dc9HkoqOY5StLB4q0UsS53QODCjO0b8LP6kuiJ
         8vHisP+2YnnZzbQCZ5tRX2F0md65KbL3npfLcO72aSz6q9hmrXsAZ2AjIqklFE2qGRqP
         eeXA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=YjecuPhauQHL4j4Z2a9keky4ajO3faW/VO0iw9ZMsyw=;
        b=DD3rdSDtqTIWqRQM9vg+LtAgbYXATRxYYPW1fg+f8mAsYcaMqIrs10gJyvfl5MLKnJ
         dkM17lKEggN/R6ZmcHh3H8iCFnNgnEm3u6VTkcN9o95KfIjxsqEWmH6uxUP8L9mMHW3f
         yh49oXBkVdN/BEIRCGk7QYqxcqCPajJSvnel/XHkhfFITNZsyA1P7vbKDO3UHwqm0sdr
         geWFEeSkk1PYqhNHdVBzugBqifjlaGMWvcYIlcPseqmznjjmSu511u3HnGM1rcyRv3sG
         rqkgApHJhSA9hBgdDStlpzPxuNfCs2fG43dYDrPTY5dEhuPvUu0vSKXXh9XvMBkeGXiF
         7KuQ==
X-Gm-Message-State: AOAM5307yMWX1cOViO3Fyjxx/FPl5O6YHzByNAXNnq7QdxZSEymaia0x
        YtWb9c1EftKrWrKe5/U57p4=
X-Google-Smtp-Source: ABdhPJxBZS9ztI4xvrbGTpOSw6c/HLSysA8VOVuU/1daXUC/dE1jO2LoC/ZzlHwtXxsbSfmuJA8jmA==
X-Received: by 2002:a05:600c:2047:: with SMTP id p7mr4017341wmg.168.1600248792836;
        Wed, 16 Sep 2020 02:33:12 -0700 (PDT)
Received: from Red ([2a01:cb1d:3d5:a100:264b:feff:fe03:2806])
        by smtp.googlemail.com with ESMTPSA id u8sm4171183wmj.45.2020.09.16.02.33.10
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 16 Sep 2020 02:33:11 -0700 (PDT)
Date:   Wed, 16 Sep 2020 11:33:09 +0200
From:   Corentin Labbe <clabbe.montjoie@gmail.com>
To:     Krzysztof Kozlowski <krzk@kernel.org>
Cc:     Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>,
        Maxime Ripard <mripard@kernel.org>,
        Chen-Yu Tsai <wens@csie.org>,
        Horia =?utf-8?Q?Geant=C4=83?= <horia.geanta@nxp.com>,
        Aymen Sghaier <aymen.sghaier@nxp.com>,
        Maxime Coquelin <mcoquelin.stm32@gmail.com>,
        Alexandre Torgue <alexandre.torgue@st.com>,
        linux-crypto@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org,
        linux-stm32@st-md-mailman.stormreply.com,
        Iuliana Prodan <iuliana.prodan@nxp.com>
Subject: Re: [PATCH v2 4/4] crypto: allwinner/sun8i - Simplify with
 dev_err_probe()
Message-ID: <20200916093309.GA11483@Red>
References: <20200910192919.12503-1-krzk@kernel.org>
 <20200910192919.12503-4-krzk@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200910192919.12503-4-krzk@kernel.org>
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Thu, Sep 10, 2020 at 09:29:19PM +0200, Krzysztof Kozlowski wrote:
> Common pattern of handling deferred probe can be simplified with
> dev_err_probe().  Less code and the error value gets printed.
> 
> Signed-off-by: Krzysztof Kozlowski <krzk@kernel.org>
> 
> ---
> 
> Changes since v1:
> 1. None
> ---
>  drivers/crypto/allwinner/sun8i-ce/sun8i-ce-core.c | 9 +++------
>  drivers/crypto/allwinner/sun8i-ss/sun8i-ss-core.c | 9 +++------
>  2 files changed, 6 insertions(+), 12 deletions(-)
> 
> diff --git a/drivers/crypto/allwinner/sun8i-ce/sun8i-ce-core.c b/drivers/crypto/allwinner/sun8i-ce/sun8i-ce-core.c
> index 138759dc8190..e3c62051c595 100644
> --- a/drivers/crypto/allwinner/sun8i-ce/sun8i-ce-core.c
> +++ b/drivers/crypto/allwinner/sun8i-ce/sun8i-ce-core.c
> @@ -573,12 +573,9 @@ static int sun8i_ce_probe(struct platform_device *pdev)
>  		return irq;
>  
>  	ce->reset = devm_reset_control_get(&pdev->dev, NULL);
> -	if (IS_ERR(ce->reset)) {
> -		if (PTR_ERR(ce->reset) == -EPROBE_DEFER)
> -			return PTR_ERR(ce->reset);
> -		dev_err(&pdev->dev, "No reset control found\n");
> -		return PTR_ERR(ce->reset);
> -	}
> +	if (IS_ERR(ce->reset))
> +		return dev_err_probe(&pdev->dev, PTR_ERR(ce->reset),
> +				     "No reset control found\n");
>  
>  	mutex_init(&ce->mlock);
>  
> diff --git a/drivers/crypto/allwinner/sun8i-ss/sun8i-ss-core.c b/drivers/crypto/allwinner/sun8i-ss/sun8i-ss-core.c
> index 9a23515783a6..576df8c8df51 100644
> --- a/drivers/crypto/allwinner/sun8i-ss/sun8i-ss-core.c
> +++ b/drivers/crypto/allwinner/sun8i-ss/sun8i-ss-core.c
> @@ -545,12 +545,9 @@ static int sun8i_ss_probe(struct platform_device *pdev)
>  		return irq;
>  
>  	ss->reset = devm_reset_control_get(&pdev->dev, NULL);
> -	if (IS_ERR(ss->reset)) {
> -		if (PTR_ERR(ss->reset) == -EPROBE_DEFER)
> -			return PTR_ERR(ss->reset);
> -		dev_err(&pdev->dev, "No reset control found\n");
> -		return PTR_ERR(ss->reset);
> -	}
> +	if (IS_ERR(ss->reset))
> +		return dev_err_probe(&pdev->dev, PTR_ERR(ss->reset),
> +				     "No reset control found\n");
>  
>  	mutex_init(&ss->mlock);
>  
> -- 
> 2.17.1
> 

Hello

Acked-by: Corentin Labbe <clabbe.montjoie@gmail.com>
Tested-by: Corentin Labbe <clabbe.montjoie@gmail.com>

Thanks
