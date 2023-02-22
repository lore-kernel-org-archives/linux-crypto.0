Return-Path: <linux-crypto-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B4110C64EC7
	for <linux-crypto@archiver.kernel.org>; Wed, 22 Feb 2023 17:34:07 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232358AbjBVReG (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Wed, 22 Feb 2023 12:34:06 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49372 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230291AbjBVReB (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 22 Feb 2023 12:34:01 -0500
Received: from mail-lj1-x231.google.com (mail-lj1-x231.google.com [IPv6:2a00:1450:4864:20::231])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3A315360A4
        for <linux-crypto@vger.kernel.org>; Wed, 22 Feb 2023 09:34:00 -0800 (PST)
Received: by mail-lj1-x231.google.com with SMTP id h9so8532617ljq.2
        for <linux-crypto@vger.kernel.org>; Wed, 22 Feb 2023 09:34:00 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=cJBr8YB3OM34mLukoxWr1SKyIdWTD8W49YRj0Tiv4tE=;
        b=Pv/nv+HJCKiISFqkf7iQvzI8FXlFqSTYKDXC8KhEnBdyFLidgYLKt7Proy3pmo2tfy
         wD8ytRT+CbdZ+rbQRirdYFtH5YYnn+NDjjdMNe4dA+5OlwpqeWcIHxIsHsaQKeT3bvOY
         g+/RoVvb3UHTZxjVozjoBsPLavDE0ztEgEYNOEf+vwtruDTeWbUmVRGVs2GJ12/nobVe
         xtSEaQ7h16H01HdyUMA/Der1J46DWPQyeqvpNlazInxqzOmbNQN3I378oCtd8AgVdJBA
         gd5tB3wVd1NjfujumS7mnAvVHS4rBLODdIp/7v8sn64I2LXFm+4C4G/Yb/Wq3Idcsjrm
         8G/w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=cJBr8YB3OM34mLukoxWr1SKyIdWTD8W49YRj0Tiv4tE=;
        b=Ma/tP8/gf4xlU75Tqh9x94fOxFifB9yHIBvxaq5+BI+hmPUYCrGMtK5WkaUwqEmCRD
         XqfkgdF6pDnlPigiggI+tbHXoLe9bx3PIYXVJE44sC82HPG57yUZ/ONwBiJjl4i2C+Da
         ouuNFGgmka2tuQj5lTxct4rptHl8giB9QmIYqH1JOW8FsO1QS6wGdUO1mDFiLJ3aZ0q9
         eyDCRb6Tb3+VwtdklSrZYuhNUOospYMoVpxEhJTZqH6MumY7ZRhaQwIdIpF+zghy8Mo+
         soJntRLbdpcmn0x6e/gNQzgOp3fn20iNC8Wk16G01ONsPiy5Za38r24WzQD7ir6rcLIq
         K42w==
X-Gm-Message-State: AO0yUKWpi0P9EGs/1hIhM3DMmPFtHDgCzfnDcIdLTYfZzcmipQmBx2ff
        +gOlXpVDmyuFBUKwbgR65Ltn5w==
X-Google-Smtp-Source: AK7set9jmFEGxMks65RUMuFD474au2Pb8TS8JTPZJjHb0lwnudD/hgyPfxdf9DnQ5T69coUlHxGhhA==
X-Received: by 2002:a05:651c:a08:b0:290:7149:757b with SMTP id k8-20020a05651c0a0800b002907149757bmr5014777ljq.31.1677087238512;
        Wed, 22 Feb 2023 09:33:58 -0800 (PST)
Received: from [192.168.1.101] (abxi151.neoplus.adsl.tpnet.pl. [83.9.2.151])
        by smtp.gmail.com with ESMTPSA id l22-20020a2e7016000000b0029473d0e416sm214793ljc.25.2023.02.22.09.33.57
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 22 Feb 2023 09:33:58 -0800 (PST)
Message-ID: <cdc87c95-a845-904b-1a57-0895b9f93d9f@linaro.org>
Date:   Wed, 22 Feb 2023 18:33:56 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.8.0
Subject: Re: [PATCH v11 09/10] crypto: qce: core: Make clocks optional
Content-Language: en-US
To:     Vladimir Zapolskiy <vladimir.zapolskiy@linaro.org>,
        Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>,
        Bjorn Andersson <andersson@kernel.org>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Thara Gopinath <thara.gopinath@gmail.com>,
        Bhupesh Sharma <bhupesh.sharma@linaro.org>
Cc:     Rob Herring <robh+dt@kernel.org>, Andy Gross <agross@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        devicetree@vger.kernel.org, linux-arm-msm@vger.kernel.org,
        linux-crypto@vger.kernel.org, Jordan Crouse <jorcrous@amazon.com>
References: <20230222172240.3235972-1-vladimir.zapolskiy@linaro.org>
 <20230222172240.3235972-10-vladimir.zapolskiy@linaro.org>
From:   Konrad Dybcio <konrad.dybcio@linaro.org>
In-Reply-To: <20230222172240.3235972-10-vladimir.zapolskiy@linaro.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org



On 22.02.2023 18:22, Vladimir Zapolskiy wrote:
> From: Thara Gopinath <thara.gopinath@gmail.com>
> 
> On certain Snapdragon processors, the crypto engine clocks are enabled by
> default by security firmware and the driver should not handle the clocks.
> Make acquiring of all the clocks optional in crypto engine driver, so that
> the driver initializes properly even if no clocks are specified in the dt.
> 
> Tested-by: Jordan Crouse <jorcrous@amazon.com>
> Signed-off-by: Thara Gopinath <thara.gopinath@gmail.com>
> Signed-off-by: Bhupesh Sharma <bhupesh.sharma@linaro.org>
> [Bhupesh: Massage the commit log]
> Signed-off-by: Vladimir Zapolskiy <vladimir.zapolskiy@linaro.org>
> ---
I'm not sure which is the preferred approach, but generally I'd
stick with keeping them non-optional for the SoCs that need them..
So perhaps introducing a flag in of_match_data for qcom,sm8150-qce
(which was created solely to take care of the no-HLOS-clocks cases)
and then skipping the clock operations based on that would be a
good idea.

Konrad

>  drivers/crypto/qce/core.c | 6 +++---
>  1 file changed, 3 insertions(+), 3 deletions(-)
> 
> diff --git a/drivers/crypto/qce/core.c b/drivers/crypto/qce/core.c
> index 0654b94cfb95..5bb2128c95ca 100644
> --- a/drivers/crypto/qce/core.c
> +++ b/drivers/crypto/qce/core.c
> @@ -209,15 +209,15 @@ static int qce_crypto_probe(struct platform_device *pdev)
>  	if (ret < 0)
>  		return ret;
>  
> -	qce->core = devm_clk_get(qce->dev, "core");
> +	qce->core = devm_clk_get_optional(qce->dev, "core");
>  	if (IS_ERR(qce->core))
>  		return PTR_ERR(qce->core);
>  
> -	qce->iface = devm_clk_get(qce->dev, "iface");
> +	qce->iface = devm_clk_get_optional(qce->dev, "iface");
>  	if (IS_ERR(qce->iface))
>  		return PTR_ERR(qce->iface);
>  
> -	qce->bus = devm_clk_get(qce->dev, "bus");
> +	qce->bus = devm_clk_get_optional(qce->dev, "bus");
>  	if (IS_ERR(qce->bus))
>  		return PTR_ERR(qce->bus);
>  
 
