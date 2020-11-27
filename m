Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-14.0 required=3.0 tests=BAYES_00,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 67C84C64E7C
	for <linux-crypto@archiver.kernel.org>; Fri, 27 Nov 2020 09:44:33 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 3A955221F7
	for <linux-crypto@archiver.kernel.org>; Fri, 27 Nov 2020 09:44:33 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726952AbgK0JoU (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 27 Nov 2020 04:44:20 -0500
Received: from mail-wm1-f68.google.com ([209.85.128.68]:33542 "EHLO
        mail-wm1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725989AbgK0JoT (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 27 Nov 2020 04:44:19 -0500
Received: by mail-wm1-f68.google.com with SMTP id u10so1331195wmm.0;
        Fri, 27 Nov 2020 01:44:17 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=0rcaXN0DZqE7YXIm9z0wb34aVoGoLqt6Pi2bXEDuuYM=;
        b=dB3RawjokfsPRLTP29G3EU4Ngjw3pnL3yXZTnbUCiR0hDNQoqMo9yJh9aTmy2w+VZv
         1dsfx4dMf3R4ybMsrbsS7y4p+y5v8BcxkPpiJ/0yJKO+609kM052YrOE25EpFIZ0n5qo
         XEXF60HrZ7v0kAKNC+B5zN+N0WiJjU8VTci3wYPzPp549a+n41tA6zHEFFTc+s5ip8ck
         PI3ZkPft0SFUqGcgTPLaIazMPD56WM4FQV4HXOLJEuGiZO9AD8YjkKEOCw7u59CCOMiu
         UV/oiGmcKOIejXjdaIVowqEsYxvlf6kUm5PRqtvk1kylz7ZqbVUqBySE+5QbiM4h35Sb
         GB7g==
X-Gm-Message-State: AOAM53021ZbUd51uwsWo4w2PNMGp5J3wfJn4pYV63zeguMev3+tI5XUK
        amqukWSpIvGrl6/nz/8CfG8=
X-Google-Smtp-Source: ABdhPJzpw84z6c9Q6BcltT41XlX4adRZ0eiDKEb26LyiIg2prGdDUJwUQfyb5jqSAJL7qmnxzepTrg==
X-Received: by 2002:a1c:9dd7:: with SMTP id g206mr8199701wme.49.1606470256949;
        Fri, 27 Nov 2020 01:44:16 -0800 (PST)
Received: from kozik-lap (adsl-84-226-167-205.adslplus.ch. [84.226.167.205])
        by smtp.googlemail.com with ESMTPSA id o13sm12131106wmc.44.2020.11.27.01.44.15
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 27 Nov 2020 01:44:15 -0800 (PST)
Date:   Fri, 27 Nov 2020 10:44:14 +0100
From:   Krzysztof Kozlowski <krzk@kernel.org>
To:     Qinglang Miao <miaoqinglang@huawei.com>
Cc:     =?utf-8?Q?=C5=81ukasz?= Stelmach <l.stelmach@samsung.com>,
        linux-samsung-soc@vger.kernel.org, linux-crypto@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] hwrng: exynos - fix reference leak in exynos_trng_probe
Message-ID: <20201127094414.GA10679@kozik-lap>
References: <20201127094446.121277-1-miaoqinglang@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20201127094446.121277-1-miaoqinglang@huawei.com>
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Fri, Nov 27, 2020 at 05:44:46PM +0800, Qinglang Miao wrote:
> pm_runtime_get_sync will increment pm usage counter even it
> failed. Forgetting to putting operation will result in a
> reference leak here.
> 
> A new function pm_runtime_resume_and_get is introduced in
> [0] to keep usage counter balanced. So We fix the reference
> leak by replacing it with new funtion.
> 
> [0] dd8088d5a896 ("PM: runtime: Add  pm_runtime_resume_and_get to deal with usage counter")

Do not put such dependencies into the commit message - it does not bring
useful information to the history. Store it under '---' separator.

> 
> Fixes: 6cd225cc5d8a ("hwrng: exynos - add Samsung Exynos True RNG driver")
> Reported-by: Hulk Robot <hulkci@huawei.com>
> Signed-off-by: Qinglang Miao <miaoqinglang@huawei.com>
> ---
>  drivers/char/hw_random/exynos-trng.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/char/hw_random/exynos-trng.c b/drivers/char/hw_random/exynos-trng.c
> index 8e1fe3f8d..666246bc8 100644
> --- a/drivers/char/hw_random/exynos-trng.c
> +++ b/drivers/char/hw_random/exynos-trng.c
> @@ -132,7 +132,7 @@ static int exynos_trng_probe(struct platform_device *pdev)
>  		return PTR_ERR(trng->mem);
>  
>  	pm_runtime_enable(&pdev->dev);
> -	ret = pm_runtime_get_sync(&pdev->dev);
> +	ret = pm_runtime_resume_and_get(&pdev->dev);

This cannot be applied. Fix it by replacing err_clock label with this
one.

Best regards,
Krzysztof

