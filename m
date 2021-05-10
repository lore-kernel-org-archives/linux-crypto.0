Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-17.3 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1FFBAC433B4
	for <linux-crypto@archiver.kernel.org>; Mon, 10 May 2021 13:30:52 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id F26D4613C0
	for <linux-crypto@archiver.kernel.org>; Mon, 10 May 2021 13:30:51 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232851AbhEJNbz (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Mon, 10 May 2021 09:31:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49598 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1352523AbhEJN01 (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 10 May 2021 09:26:27 -0400
Received: from mail-qt1-x82c.google.com (mail-qt1-x82c.google.com [IPv6:2607:f8b0:4864:20::82c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5DA7DC061354
        for <linux-crypto@vger.kernel.org>; Mon, 10 May 2021 06:23:42 -0700 (PDT)
Received: by mail-qt1-x82c.google.com with SMTP id h21so8092007qtu.5
        for <linux-crypto@vger.kernel.org>; Mon, 10 May 2021 06:23:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=krXqQz2y6UCds8IrOuLeIkvxgS9HOKdz+LADfeWMxlg=;
        b=w+uU4qZpXraSKHIyJ7iQNdD3lzs+CFCAllsw+3pbBq3UdShVBzKWKejjh8jijt42HU
         v4pdRD3+x7DZiGHS9vlL5axp5UQZ0CGGBC8pmTuuk6g0UBEqz2bwzp2NNYXHD4Qa9tUh
         gYHzpc6WjANKCUHZ3FViJbQklPT1vlqsaamR8NYntMr3tsJdLvUMw0So1SnZwkrpYOXV
         ZCYRKxIwSfq72PQsGNEBr1SbXWkjsKq1e25G1xXsPiipMGodFsvWUJSAZIrugKj0KkP9
         oF+8lLzYcx5mKP7ZAvtM3/pEmt24DCPNop08WOntNENV2PfmxZg1RD7EfPkxQmLL/Mas
         DN7w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=krXqQz2y6UCds8IrOuLeIkvxgS9HOKdz+LADfeWMxlg=;
        b=TvQOyMn0Vq5KnUPqBuBAl70v+JqRoRZKrecioKXBaV7DacN+rPF2WUZYqZa03Dc97h
         TWK/azsvywFItb/Sgy9VbfTlQLQgUR5mlmm2wjyLTsmY5ah0ipm2LBXgeW4l27ZcCrqm
         T7NXW8xHE1mqVY6Z9sdRZIEBqUb3yrOusgAPzW1BtDO6hOO10237IgR+yPRRiq0zv1U2
         FT+sp7GvcqtddiqCc48KN9wWSS8wwRaSNdPJdxb73q7qr1gWdhSF+/EeLpwR2TWMdd3R
         yO7gyAwOVaKQ8d7J9BZteb6iHHYuELNaIG1C1aH8GddpJO1e208Hmy6oQkGJUqHT/lY9
         ZWmw==
X-Gm-Message-State: AOAM531kLlT0MMBha7DPCYPaJacW2fkaFkTww4Fl6D18xVD9BnmMEBxO
        dY2flBiJXWse4g6G//9qHo3zLw==
X-Google-Smtp-Source: ABdhPJwfRIs0onofwqErno7eqHaC3LIzOMd7FaTEt2t8U3wHaXxAIWgy3i9kaImw9xh3CUJ5BlYmKg==
X-Received: by 2002:a05:622a:1044:: with SMTP id f4mr7041878qte.181.1620653021581;
        Mon, 10 May 2021 06:23:41 -0700 (PDT)
Received: from [192.168.1.93] (pool-71-163-245-5.washdc.fios.verizon.net. [71.163.245.5])
        by smtp.gmail.com with ESMTPSA id u3sm496449qtg.16.2021.05.10.06.23.40
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 10 May 2021 06:23:41 -0700 (PDT)
Subject: Re: [PATCH v2 16/17] crypto: qce: Defer probe in case interconnect is
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
References: <20210505213731.538612-1-bhupesh.sharma@linaro.org>
 <20210505213731.538612-17-bhupesh.sharma@linaro.org>
From:   Thara Gopinath <thara.gopinath@linaro.org>
Message-ID: <d809f290-ed94-7e35-bc4d-bd695965fa04@linaro.org>
Date:   Mon, 10 May 2021 09:23:39 -0400
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <20210505213731.538612-17-bhupesh.sharma@linaro.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org



On 5/5/21 5:37 PM, Bhupesh Sharma wrote:
> On some Qualcomm parts the qce crypto driver needs the interconnect between
> the crypto block and main memory to be initialized first before the crypto
> registers can be accessed. So it makes sense to defer the qce crypto driver
> probing in case the interconnect driver is not yet probed.
> 
> This fixes the qce probe failure issues when both qce and
> interconnect drivers are compiled as static part of the kernel.
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
>   drivers/crypto/qce/core.c | 14 ++++++++++++++
>   1 file changed, 14 insertions(+)
> 
> diff --git a/drivers/crypto/qce/core.c b/drivers/crypto/qce/core.c
> index 3e742e9911fa..9915b184f780 100644
> --- a/drivers/crypto/qce/core.c
> +++ b/drivers/crypto/qce/core.c
> @@ -222,6 +222,20 @@ static int qce_crypto_probe(struct platform_device *pdev)
>   		return ret;
>   
>   	qce->mem_path = of_icc_get(qce->dev, "memory");
> +
> +	/* Check for NULL return path, which indicates
> +	 * interconnect API is disabled or the "interconnects"
> +	 * DT property is missing.
> +	 */
> +	if (!qce->mem_path)
> +		/* On some qcom parts, the qce crypto block needs interconnect
> +		 * paths to be configured before the registers can be accessed.
> +		 * Check here for the same.
> +		 */
> +		if (!strcmp(of_id->compatible, "qcom,ipq6018-qce") ||
> +		    !strcmp(of_id->compatible, "qcom,sdm845-qce"))
> +			return -EPROBE_DEFER;
> +

Hi Bhupesh,

You don't need this here. of_icc_get returns -EPROBE_DEFER if the 
interconnect provider is not initialized yet.

-- 
Warm Regards
Thara

>   	if (IS_ERR(qce->mem_path))
>   		return PTR_ERR(qce->mem_path);
>   
> 

