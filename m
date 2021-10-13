Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E5A09C433FE
	for <linux-crypto@archiver.kernel.org>; Wed, 13 Oct 2021 19:22:13 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id CD3F061105
	for <linux-crypto@archiver.kernel.org>; Wed, 13 Oct 2021 19:22:13 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235232AbhJMTYQ (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Wed, 13 Oct 2021 15:24:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33920 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231522AbhJMTYP (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 13 Oct 2021 15:24:15 -0400
Received: from mail-lf1-x133.google.com (mail-lf1-x133.google.com [IPv6:2a00:1450:4864:20::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 03E5DC061749
        for <linux-crypto@vger.kernel.org>; Wed, 13 Oct 2021 12:22:12 -0700 (PDT)
Received: by mail-lf1-x133.google.com with SMTP id x27so16213025lfa.9
        for <linux-crypto@vger.kernel.org>; Wed, 13 Oct 2021 12:22:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=ZNqvGfSDUhWxqhwP01MEB8XD1JZ1GH8Z2KHDHZM3Nx8=;
        b=fiWDlabKcldvXhcH1LFJPBkt7hgjyPu5PaNx7z1jti+e6SONQMaWpq+NAFB9F/h9/7
         B4NBPeHtxciXGRas3IGykPvvbivLLmu9rxgJvPGYMnJaRdNmw/ArMLdAQSIpaJsYeEQx
         jgMmSTOCiJSteDCxb4BaisolDhnGl0GQELLCvAMuYPBXmiVFSIevT6MyfT+0nSN7BUzv
         Obtwd3NrsRs7UpIRAQSxm/jCT8jyLxnv4CL4Q6iXdVJ+C14S0SLCWzydhHQ6zxXPwa7/
         uh3xnmid7ZC9fQuH1q2MCAJ1GClQNk6rZLa+h0nXuAPxxv+yjy6AbAa+XMXUjLZ2XwtY
         ntMg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=ZNqvGfSDUhWxqhwP01MEB8XD1JZ1GH8Z2KHDHZM3Nx8=;
        b=AJIdPkCXcDom7z+gum05nQstJvUbR1Edv2kW7LQeXKyQ4wMgwIZ0P9TSbNX2hIUrj/
         UQSVXzObVoBEBgzQiHO1ybo55Th46pPsfZEFS6ips/sr3r77rKMRMrZQyv9Ni9eTHZOn
         eyMtRifgKf0M5rQNc2LHb4Vvlk3bi4h8DDbWgKQ0azDWCJBo4fseHjWwZLhuwm6m8udz
         vswN6JzPbn5V9+nhrZBpOSAhg1YuexW0TWjf9Qr33EXS6SFB5CCE2xptgvs5kZHNqvjp
         Dggn6zaiEPLry2dvgkb3eXhKF+5zeFqkASFaNktiULwPKg69eDmTH8g5q/4IQEhdJpHY
         Sedg==
X-Gm-Message-State: AOAM532KnLmXkEQFyxsRBcVbiKKbMngpqk2gMapCcXibv1lXgzDCiEmt
        YwMpgQMTnXCDk8+foYa97xutHQ==
X-Google-Smtp-Source: ABdhPJwhQ0Tvi/hWYE2LBkCBSI8GIIWzqEWtNLi+uzns0CmK3K0UJx76rHorqw7uZBMTj8/VSw60pA==
X-Received: by 2002:a05:651c:a05:: with SMTP id k5mr1273338ljq.288.1634152930415;
        Wed, 13 Oct 2021 12:22:10 -0700 (PDT)
Received: from [192.168.1.102] (62-248-207-242.elisa-laajakaista.fi. [62.248.207.242])
        by smtp.gmail.com with ESMTPSA id m3sm32470lfh.2.2021.10.13.12.22.09
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 13 Oct 2021 12:22:10 -0700 (PDT)
Subject: Re: [PATCH v4 15/20] crypto: qce: Add new compatibles for qce crypto
 driver
To:     Bhupesh Sharma <bhupesh.sharma@linaro.org>,
        linux-arm-msm@vger.kernel.org, linux-crypto@vger.kernel.org
Cc:     bhupesh.linux@gmail.com, linux-kernel@vger.kernel.org,
        devicetree@vger.kernel.org, robh+dt@kernel.org, agross@kernel.org,
        herbert@gondor.apana.org.au, davem@davemloft.net,
        Thara Gopinath <thara.gopinath@linaro.org>,
        Bjorn Andersson <bjorn.andersson@linaro.org>
References: <20211013105541.68045-1-bhupesh.sharma@linaro.org>
 <20211013105541.68045-16-bhupesh.sharma@linaro.org>
From:   Vladimir Zapolskiy <vladimir.zapolskiy@linaro.org>
Message-ID: <793685ac-332b-2dbb-ad61-3a31debc2c77@linaro.org>
Date:   Wed, 13 Oct 2021 22:22:09 +0300
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.6.1
MIME-Version: 1.0
In-Reply-To: <20211013105541.68045-16-bhupesh.sharma@linaro.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Hi Bhupesh,

On 10/13/21 1:55 PM, Bhupesh Sharma wrote:
> Since we decided to use soc specific compatibles for describing
> the qce crypto IP nodes in the device-trees, adapt the driver
> now to handle the same.
> 
> Cc: Thara Gopinath <thara.gopinath@linaro.org>
> Cc: Bjorn Andersson <bjorn.andersson@linaro.org>
> Cc: Rob Herring <robh+dt@kernel.org>
> Signed-off-by: Bhupesh Sharma <bhupesh.sharma@linaro.org>
> ---
>   drivers/crypto/qce/core.c | 4 ++--
>   1 file changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/crypto/qce/core.c b/drivers/crypto/qce/core.c
> index 033c7278aa5d..2ab0b97d718c 100644
> --- a/drivers/crypto/qce/core.c
> +++ b/drivers/crypto/qce/core.c
> @@ -298,8 +298,8 @@ static int qce_crypto_remove(struct platform_device *pdev)
>   }
>   
>   static const struct of_device_id qce_crypto_of_match[] = {
> -	{ .compatible = "qcom,crypto-v5.1", },
> -	{ .compatible = "qcom,crypto-v5.4", },

This breaks backward compatibility with old/not updated dtbs, I'm not sure, if
that common rule has to be kept here, but at least it's worth to be mentioned.

> +	{ .compatible = "qcom,ipq6018-qce", },
> +	{ .compatible = "qcom,sdm845-qce", },
>   	{}
>   };
>   MODULE_DEVICE_TABLE(of, qce_crypto_of_match);
> 

--
Best wishes,
Vladimir
