Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.2 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_SANE_1 autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 02B91C43460
	for <linux-crypto@archiver.kernel.org>; Fri, 21 May 2021 11:24:11 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id D7B29613CE
	for <linux-crypto@archiver.kernel.org>; Fri, 21 May 2021 11:24:10 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230504AbhEULZc (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 21 May 2021 07:25:32 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:41938 "EHLO
        youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230119AbhEULZc (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 21 May 2021 07:25:32 -0400
Received: from mail-vk1-f199.google.com ([209.85.221.199])
        by youngberry.canonical.com with esmtps  (TLS1.2) tls TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256
        (Exim 4.93)
        (envelope-from <krzysztof.kozlowski@canonical.com>)
        id 1lk3GC-0004Yk-Vn
        for linux-crypto@vger.kernel.org; Fri, 21 May 2021 11:24:09 +0000
Received: by mail-vk1-f199.google.com with SMTP id w127-20020a1f62850000b0290200994bf3c9so1027428vkb.13
        for <linux-crypto@vger.kernel.org>; Fri, 21 May 2021 04:24:08 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=x9QeAuKPtkUv6ZpvmdpqQaHgtAYj6ktz1zWOx4dEWL0=;
        b=TEsz4EjDPdkeA5rsank362NgxtOFXKlfUVhuXN8IxnEuf28S8zUBXXH0s/b3Sv9rgk
         fw2SkP3oCIaUYhpaheZg+R5AE1pPDodEYXrnYVKDfvIClvM/6sdwADzUTHxlvYmynqqd
         96kfgbThWfUxhGOf3A2XCmTqMv08Qkn2hgaXh/QGYcY7SwSNnuUnzotUSHQxFUJbGw68
         dSzHhVbX/nMvPGIOlppcwhTmyEdA9rBtssCzY+0UJl6xJTfyS+/jODHQyRAWUVpPPTM/
         +smRkym2p2wpkf2rVYe90KULerJ+zrxt1hsDzitok1SNm36gIGSJ7/exhCU1z6RpNVYm
         Ybpw==
X-Gm-Message-State: AOAM532+ChERvz7NNHetLRezTbXndZt0UjDecZxCBhnMaOXSzHxwlFni
        MIEGq558mX9uEIqPqcdyNruVNmhPiFCCeDuoY82AHFq5OrYW4/AMVFERDFoyBgR3oGTMpeL/WQ8
        nqzyayFG+SgaSX7OI9AfBYC4/vJbibqIiAwFekMgFIg==
X-Received: by 2002:a67:f702:: with SMTP id m2mr10248178vso.40.1621596247800;
        Fri, 21 May 2021 04:24:07 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJzMIaL2fbD4ztzQzkhA3Qt2SO7PIKsWJ2O3/gGpl22g79xSoPiJVsXsKVtbzeY9cq+6RwC+Bw==
X-Received: by 2002:a67:f702:: with SMTP id m2mr10248173vso.40.1621596247673;
        Fri, 21 May 2021 04:24:07 -0700 (PDT)
Received: from [192.168.1.4] ([45.237.48.2])
        by smtp.gmail.com with ESMTPSA id t18sm896471vke.3.2021.05.21.04.24.06
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 21 May 2021 04:24:07 -0700 (PDT)
Subject: Re: [PATCH] hwrng: exynos: Use pm_runtime_resume_and_get() to replace
 open coding
To:     Tian Tao <tiantao6@hisilicon.com>, l.stelmach@samsung.com
Cc:     linux-samsung-soc@vger.kernel.org, linux-crypto@vger.kernel.org
References: <1621569489-20554-1-git-send-email-tiantao6@hisilicon.com>
From:   Krzysztof Kozlowski <krzysztof.kozlowski@canonical.com>
Message-ID: <d871c39a-2592-d50d-9a8d-69dc54b3fd55@canonical.com>
Date:   Fri, 21 May 2021 07:24:05 -0400
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.8.1
MIME-Version: 1.0
In-Reply-To: <1621569489-20554-1-git-send-email-tiantao6@hisilicon.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On 20/05/2021 23:58, Tian Tao wrote:
> use pm_runtime_resume_and_get() to replace pm_runtime_get_sync and
> pm_runtime_put_noidle. this change is just to simplify the code, no
> actual functional changes.
> 
> Signed-off-by: Tian Tao <tiantao6@hisilicon.com>
> ---
>  drivers/char/hw_random/exynos-trng.c | 5 ++---
>  1 file changed, 2 insertions(+), 3 deletions(-)
> 
> diff --git a/drivers/char/hw_random/exynos-trng.c b/drivers/char/hw_random/exynos-trng.c
> index 8e1fe3f..d71ef3c 100644
> --- a/drivers/char/hw_random/exynos-trng.c
> +++ b/drivers/char/hw_random/exynos-trng.c
> @@ -196,10 +196,9 @@ static int __maybe_unused exynos_trng_resume(struct device *dev)
>  {
>  	int ret;
>  
> -	ret = pm_runtime_get_sync(dev);
> -	if (ret < 0) {
> +	ret = pm_runtime_resume_and_get(dev);
> +	if (ret) {
>  		dev_err(dev, "Could not get runtime PM.\n");
> -		pm_runtime_put_noidle(dev);
>  		return ret;

Reviewed-by: Krzysztof Kozlowski <krzysztof.kozlowski@canonical.com>


Best regards,
Krzysztof
