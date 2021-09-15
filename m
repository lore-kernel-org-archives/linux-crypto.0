Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.9 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 21BFEC433F5
	for <linux-crypto@archiver.kernel.org>; Wed, 15 Sep 2021 08:13:59 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 062EB61179
	for <linux-crypto@archiver.kernel.org>; Wed, 15 Sep 2021 08:13:59 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236887AbhIOIPQ (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Wed, 15 Sep 2021 04:15:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57628 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236721AbhIOIPP (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 15 Sep 2021 04:15:15 -0400
Received: from mail-wr1-x42b.google.com (mail-wr1-x42b.google.com [IPv6:2a00:1450:4864:20::42b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BC6E6C061574
        for <linux-crypto@vger.kernel.org>; Wed, 15 Sep 2021 01:13:56 -0700 (PDT)
Received: by mail-wr1-x42b.google.com with SMTP id q11so2422641wrr.9
        for <linux-crypto@vger.kernel.org>; Wed, 15 Sep 2021 01:13:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=baylibre-com.20150623.gappssmtp.com; s=20150623;
        h=subject:to:cc:references:from:organization:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=ZVEQkAxDMKOzrfhEy+02V5t0PQYVTOvMQsfZO862NZ4=;
        b=NIb52wkyb63W7nS/n7zUfgWHLeEY95gpU6CHyYhSEPMVHflp24xG5CSL/PtJ0vM1z7
         jrd5tHOEjlTUoZZGMTmaS1ZIAvesG94Ln4M1QjbQeQXmFH3+K60mAlxzILrXniWEmwaX
         53a0loc7mqmUGQOOlRychMWnmCfpCxv1eVEbrG9ASbSyGD7/2X5IRjKusigN9uGYNeqI
         b1l5bT0XclBJzPv+HRHxL+OwO+iNOgbgf7JC8mydOTTODmtvqzDoB1t44RLHX9VNsLL5
         b5RFtGZZ5a8+YRbgPVFgd9WtIAsGq1H4Zst+g69RNYUU4yl+vFJc6uea9Wma8dAzvsCg
         3jZw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:subject:to:cc:references:from:organization
         :message-id:date:user-agent:mime-version:in-reply-to
         :content-language:content-transfer-encoding;
        bh=ZVEQkAxDMKOzrfhEy+02V5t0PQYVTOvMQsfZO862NZ4=;
        b=PHqjcAdhiEK4NkNA679kkh5IKTqX6AAVKHt/8dR2mXZBYDyJHIIwDh6aNMw7XAbqtS
         F3LFKkj23hq4Ld9locbaAU8lKagbogYzBtFSdj2ahasVowcpaLa53L/zLcZdsfSL1Vig
         BVlLFJMM4SBKIrdnv1Y6VfQeMSe2OS5taeRPjN6/3Iwy2MIkQAd5pYmhAd0oc7FIUbDY
         8J2JkOxSURIQtnIzpjRh2vbQcT0tffBMaTI5SjQHx7SN2O1/0HbgOSFv0lxPWy2D7ylW
         FwkrIWsoUA1iIQMOZIXj4O7QL8rQFtqtF9Ne6NIT01aHGEPRNUVbY0V55Ky2xHjUPS1O
         10ag==
X-Gm-Message-State: AOAM532S7X7GxA4szygh0xF38NgYW5BmoqAMoqNiXDztuaXVNDF1pNJY
        U7JpQ+75RkBYfgXM1yC1lrF9TQ==
X-Google-Smtp-Source: ABdhPJzwRA0TKa9jdINdtle9VV7hKHDLxy6rVGv7xrGO84QUCgs1I+5BZDBmMuIXlrpdifqz6IDYtw==
X-Received: by 2002:adf:fb07:: with SMTP id c7mr3387573wrr.399.1631693635280;
        Wed, 15 Sep 2021 01:13:55 -0700 (PDT)
Received: from ?IPv6:2001:861:44c0:66c0:e510:7c15:5de3:6849? ([2001:861:44c0:66c0:e510:7c15:5de3:6849])
        by smtp.gmail.com with ESMTPSA id n3sm3596037wmi.0.2021.09.15.01.13.54
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 15 Sep 2021 01:13:54 -0700 (PDT)
Subject: Re: [PATCH] hwrng: meson - Improve error handling for core clock
To:     =?UTF-8?Q?Uwe_Kleine-K=c3=b6nig?= <u.kleine-koenig@pengutronix.de>,
        Matt Mackall <mpm@selenic.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Kevin Hilman <khilman@baylibre.com>
Cc:     Jerome Brunet <jbrunet@baylibre.com>,
        Martin Blumenstingl <martin.blumenstingl@googlemail.com>,
        linux-crypto@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-amlogic@lists.infradead.org, kernel@pengutronix.de
References: <20210914142428.57099-1-u.kleine-koenig@pengutronix.de>
From:   Neil Armstrong <narmstrong@baylibre.com>
Organization: Baylibre
Message-ID: <07a4f824-5a80-7c0b-d8c9-82e89446bd87@baylibre.com>
Date:   Wed, 15 Sep 2021 10:13:54 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.11.0
MIME-Version: 1.0
In-Reply-To: <20210914142428.57099-1-u.kleine-koenig@pengutronix.de>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On 14/09/2021 16:24, Uwe Kleine-König wrote:
> -ENOENT (ie. "there is no clock") is fine to ignore for an optional
> clock, other values are not supposed to be ignored and should be
> escalated to the caller (e.g. -EPROBE_DEFER). Ignore -ENOENT by using
> devm_clk_get_optional().
> 
> While touching this code also add an error message for the fatal errors.
> 
> Signed-off-by: Uwe Kleine-König <u.kleine-koenig@pengutronix.de>
> ---
>  drivers/char/hw_random/meson-rng.c | 12 +++++++++---
>  1 file changed, 9 insertions(+), 3 deletions(-)
> 
> diff --git a/drivers/char/hw_random/meson-rng.c b/drivers/char/hw_random/meson-rng.c
> index e446236e81f2..9f3e2eb8011d 100644
> --- a/drivers/char/hw_random/meson-rng.c
> +++ b/drivers/char/hw_random/meson-rng.c
> @@ -54,9 +54,15 @@ static int meson_rng_probe(struct platform_device *pdev)
>  	if (IS_ERR(data->base))
>  		return PTR_ERR(data->base);
>  
> -	data->core_clk = devm_clk_get(dev, "core");
> -	if (IS_ERR(data->core_clk))
> -		data->core_clk = NULL;
> +	data->core_clk = devm_clk_get_optional(dev, "core");
> +	if (IS_ERR(data->core_clk)) {
> +		ret = PTR_ERR(data->core_clk);
> +		if (ret != -EPROBE_DEFER)
> +			dev_err(dev, "Failed to get core clock: %pe\n",
> +				data->core_clk);
> +
> +		return ret;
> +	}
>  
>  	if (data->core_clk) {
>  		ret = clk_prepare_enable(data->core_clk);
> 

Reviewed-by: Neil Armstrong <narmstrong@baylibre.com>

Thanks,
Neil
