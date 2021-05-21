Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-17.3 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 77ACFC433ED
	for <linux-crypto@archiver.kernel.org>; Fri, 21 May 2021 01:57:47 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 576B96138C
	for <linux-crypto@archiver.kernel.org>; Fri, 21 May 2021 01:57:47 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237980AbhEUB7I (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 20 May 2021 21:59:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41918 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237361AbhEUB7I (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 20 May 2021 21:59:08 -0400
Received: from mail-qt1-x82a.google.com (mail-qt1-x82a.google.com [IPv6:2607:f8b0:4864:20::82a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 47A91C061763
        for <linux-crypto@vger.kernel.org>; Thu, 20 May 2021 18:57:46 -0700 (PDT)
Received: by mail-qt1-x82a.google.com with SMTP id c10so14292986qtx.10
        for <linux-crypto@vger.kernel.org>; Thu, 20 May 2021 18:57:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=buMCqeHtuyOXGkkJdrNGUndmaHGXH2/Q3tPpeh7Q5cA=;
        b=hT2PUE9pbBqC/T2A7RTVjvJ1O766UgLwHeIEZJM8DBHFPqQBoZn8X4MrbGh2wDjIak
         tcQQyXqdxHneAQLSty9xqo4R7U3vAfuTcByWCRfTcpMwL+h+zgGhm6xhwOAmJKTspVh0
         +Jk+y2ArCyP5RdULKTjGO67uFJblHvxvZe34rNye+fxoYZhbqtvE3cl0VtF1Q66oPrHe
         DhfKfaugXta1FsdxFteRefQBZKm8Fdh1oQVMScrykfCe/oUgtkssJ0CjqaF3ad+AHMQb
         VLSPXzoMFg/1m3/Sx+8J+mJNiwPaVoZGETobFfr4tcJdCAn8u9NL7Hh1Max4vfPTsRLX
         oDug==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=buMCqeHtuyOXGkkJdrNGUndmaHGXH2/Q3tPpeh7Q5cA=;
        b=OFUp66my8erzQg4ZCmdprHah8CvDJotz+vwOD9rbrdHj6c7XeCNRzn6505lJDCGpd9
         6rVNF42VGNOhvCtaSABhl/fBMh8gMsPJKt6O4X3728GksUKGisr1YIe/xaSNUpN7E051
         HkHanzQk7/EPfqM7td7RPJ/MU7ZCrioUmW3Y5TvZWMU8tXaGxfba2MbvpfFZ9Jm7NE3U
         i6laqx/cQgRdUHPQJghAFEa5KOmtVhmWP3S65RXrKDpNNqg207O1zrBWbfuXo3WkjAx8
         pu0ZuwC/TsiPo7P3ZnrHi9pFzVaShM7mON8haBLjUvdKMDjJ1jygg9wyis7dmWb8qcrD
         VP+A==
X-Gm-Message-State: AOAM5319iaxE08GG9A6oHR6dlcCVgz8VWxQrU5x87XHYa7R9UnFMbfww
        2lHIXDbMsDrV1SYvtB3fPKxDWQ==
X-Google-Smtp-Source: ABdhPJxWquzOWfEHbrPOV1dhDOji1d36s6wy7ft8gWYN4OvhvNr2UmKZNm1DSRqV1XmS5MeSzLDKUg==
X-Received: by 2002:ac8:5396:: with SMTP id x22mr8556084qtp.170.1621562265469;
        Thu, 20 May 2021 18:57:45 -0700 (PDT)
Received: from [192.168.1.93] (pool-71-163-245-5.washdc.fios.verizon.net. [71.163.245.5])
        by smtp.gmail.com with ESMTPSA id p11sm3365920qtl.82.2021.05.20.18.57.39
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 20 May 2021 18:57:45 -0700 (PDT)
Subject: Re: [PATCH v3 16/17] crypto: qce: Defer probing if BAM dma channel is
 not yet initialized
To:     Bhupesh Sharma <bhupesh.sharma@linaro.org>,
        linux-arm-msm@vger.kernel.org
Cc:     Bjorn Andersson <bjorn.andersson@linaro.org>,
        Rob Herring <robh+dt@kernel.org>,
        Andy Gross <agross@kernel.org>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "David S . Miller" <davem@davemloft.net>,
        Stephen Boyd <sboyd@kernel.org>,
        Michael Turquette <mturquette@baylibre.com>,
        Vinod Koul <vkoul@kernel.org>, dmaengine@vger.kernel.org,
        linux-clk@vger.kernel.org, linux-crypto@vger.kernel.org,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        bhupesh.linux@gmail.com
References: <20210519143700.27392-1-bhupesh.sharma@linaro.org>
 <20210519143700.27392-17-bhupesh.sharma@linaro.org>
From:   Thara Gopinath <thara.gopinath@linaro.org>
Message-ID: <ca0e576d-0231-d1a8-06c5-e85f0706c993@linaro.org>
Date:   Thu, 20 May 2021 21:57:38 -0400
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <20210519143700.27392-17-bhupesh.sharma@linaro.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org



On 5/19/21 10:36 AM, Bhupesh Sharma wrote:
> Since the Qualcomm qce crypto driver needs the BAM dma driver to be
> setup first (to allow crypto operations), it makes sense to defer
> the qce crypto driver probing in case the BAM dma driver is not yet
> probed.
> 
> Move the code leg requesting dma channels earlier in the
> probe() flow. This fixes the qce probe failure issues when both qce
> and BMA dma are compiled as static part of the kernel.

So, I do not understand what issue you faced with the current code 
ordering. When bam dma is not initialized, qce_dma_request will fail and
rest the error path kicks in.
To me the correct ordering for enabling a driver is to turn on clocks 
and interconnect before requesting for dma. Unless, there is a specific 
issue, I will ask for that order to be maintained.

Warm Regards
Thara

> 
> Cc: Thara Gopinath <thara.gopinath@linaro.org>
> Cc: Bjorn Andersson <bjorn.andersson@linaro.org>
> Cc: Rob Herring <robh+dt@kernel.org>
> Cc: Andy Gross <agross@kernel.org>
> Cc: Herbert Xu <herbert@gondor.apana.org.au>
> Cc: David S. Miller <davem@davemloft.net>
> Cc: Stephen Boyd <sboyd@kernel.org>
> Cc: Michael Turquette <mturquette@baylibre.com>
> Cc: Vinod Koul <vkoul@kernel.org>
> Cc: dmaengine@vger.kernel.org
> Cc: linux-clk@vger.kernel.org
> Cc: linux-crypto@vger.kernel.org
> Cc: devicetree@vger.kernel.org
> Cc: linux-kernel@vger.kernel.org
> Cc: bhupesh.linux@gmail.com
> Signed-off-by: Bhupesh Sharma <bhupesh.sharma@linaro.org>
> ---
>   drivers/crypto/qce/core.c | 16 +++++++++-------
>   1 file changed, 9 insertions(+), 7 deletions(-)
> 
> diff --git a/drivers/crypto/qce/core.c b/drivers/crypto/qce/core.c
> index 8b3e2b4580c2..207221d5b996 100644
> --- a/drivers/crypto/qce/core.c
> +++ b/drivers/crypto/qce/core.c
> @@ -218,6 +218,14 @@ static int qce_crypto_probe(struct platform_device *pdev)
>   	if (ret < 0)
>   		goto err_out;
>   
> +	/* qce driver requires BAM dma driver to be setup first.
> +	 * In case the dma channel are not set yet, this check
> +	 * helps use to return -EPROBE_DEFER earlier.
> +	 */
> +	ret = qce_dma_request(qce->dev, &qce->dma);
> +	if (ret)
> +		return ret;
> +
>   	qce->mem_path = devm_of_icc_get(qce->dev, "memory");
>   	if (IS_ERR(qce->mem_path))
>   		return dev_err_probe(dev, PTR_ERR(qce->mem_path),
> @@ -269,10 +277,6 @@ static int qce_crypto_probe(struct platform_device *pdev)
>   			goto err_clks_iface;
>   	}
>   
> -	ret = qce_dma_request(qce->dev, &qce->dma);
> -	if (ret)
> -		goto err_clks;
> -
>   	ret = qce_check_version(qce);
>   	if (ret)
>   		goto err_clks;
> @@ -287,12 +291,10 @@ static int qce_crypto_probe(struct platform_device *pdev)
>   
>   	ret = qce_register_algs(qce);
>   	if (ret)
> -		goto err_dma;
> +		goto err_clks;
>   
>   	return 0;
>   
> -err_dma:
> -	qce_dma_release(&qce->dma);
>   err_clks:
>   	clk_disable_unprepare(qce->bus);
>   err_clks_iface:
> 


