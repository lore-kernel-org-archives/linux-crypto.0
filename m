Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-17.3 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=unavailable autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 530BDC43461
	for <linux-crypto@archiver.kernel.org>; Fri, 21 May 2021 02:11:58 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 3074B6138C
	for <linux-crypto@archiver.kernel.org>; Fri, 21 May 2021 02:11:58 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238034AbhEUCNT (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 20 May 2021 22:13:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45150 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233997AbhEUCNS (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 20 May 2021 22:13:18 -0400
Received: from mail-qk1-x72c.google.com (mail-qk1-x72c.google.com [IPv6:2607:f8b0:4864:20::72c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A035BC061763
        for <linux-crypto@vger.kernel.org>; Thu, 20 May 2021 19:11:56 -0700 (PDT)
Received: by mail-qk1-x72c.google.com with SMTP id o27so18330748qkj.9
        for <linux-crypto@vger.kernel.org>; Thu, 20 May 2021 19:11:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=aBM+iI0qSzAgR4v/IlJ1mhN5B469z/KN8UZgQ8XD1ec=;
        b=Pd8QHT9I9ZzCAyXCQOGSN4z8Qrt29+k82+Pq2c7Er2DGM07zP8Se/eYuazzBGmSVUX
         EEWdiRc4S/oVJeokMqAqgrhUzt/xk29XlDocVXV2VK3x2N3wPoN3GtEnjqjE8hNnA3Ut
         G5uvdBTSwLEqu8qdkV8vQj/GnOyuyQjKvA57egZgiuFhn++8QSDqQS03Lbf3xTd4VTVn
         IyzO3GhNv01zS2W+en7umdXccMKj18VVo+dIiYqBDE6AA3danMD38Ig8Untp/YyRzl7o
         Xx+tMco1pQ+MhYtM/LbTEYlU9Dv9j8RmVYLNhNe4y6DdTMV5t/Ai4oWUJ4IEmFdT7nfh
         61Ig==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=aBM+iI0qSzAgR4v/IlJ1mhN5B469z/KN8UZgQ8XD1ec=;
        b=h/geH50vHXL/QFU0s/MTQGXaxH3OU5vYQjuss99MT1267E8CWSUWlSHEZGUS0Tibh6
         tb2RRu+ascS67MvDEzu39IlV7Gue/1bHwS+tbnAxYwPgaZ6pz7ImstDiH3WAlV7ix0Hl
         S9HjWRVgnIhd7qQtvHXS085PB89r1YQjbHg7m4NpH2z1aHf1rsMutUZmMH5inQGJ7lNZ
         cPi8BjvuBi+dJDU0pNz1uSC3xeQ4gdOA/wuslA4aV7f5jtdj7UWVMO0hjVNJ8qlIf5tf
         B7uiMlTF+YlmBtKXOpVIy8x+xxYXDx5MrAVxzkq+hxxpVHcQNNbM5OuD4achvl+phVjw
         No4Q==
X-Gm-Message-State: AOAM533bhw2IvY12y4d7KrjqN6si/3Aa13xkF5RjRs08KQhcR4xhp3mq
        gR9sacRHhxx+USa0fW6xWl1rDQ==
X-Google-Smtp-Source: ABdhPJwUF9ChpTwtKJPB8FzviVnCFCgvQeNTzJZjYLfqL7nUynVm01d3MiGRwFGjo4Zm+uQ9n9RZWQ==
X-Received: by 2002:a05:620a:4043:: with SMTP id i3mr8772288qko.380.1621563115682;
        Thu, 20 May 2021 19:11:55 -0700 (PDT)
Received: from [192.168.1.93] (pool-71-163-245-5.washdc.fios.verizon.net. [71.163.245.5])
        by smtp.gmail.com with ESMTPSA id m22sm3780687qkk.65.2021.05.20.19.11.54
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 20 May 2021 19:11:55 -0700 (PDT)
Subject: Re: [PATCH v3 13/17] crypto: qce: core: Make clocks optional
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
 <20210519143700.27392-14-bhupesh.sharma@linaro.org>
From:   Thara Gopinath <thara.gopinath@linaro.org>
Message-ID: <125e1f83-e340-9cd3-91a8-cd1ee3ee8b7f@linaro.org>
Date:   Thu, 20 May 2021 22:11:53 -0400
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <20210519143700.27392-14-bhupesh.sharma@linaro.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Hi Bhupesh,

On 5/19/21 10:36 AM, Bhupesh Sharma wrote:
> From: Thara Gopinath <thara.gopinath@linaro.org>
> 
> On certain Snapdragon processors, the crypto engine clocks are enabled by
> default by security firmware and the driver need not handle the
> clocks. Make acquiring of all the clocks optional in crypto enginer driver
> so that the driver intializes properly even if no clocks are specified in
> the dt.
> 
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
> Signed-off-by: Thara Gopinath <thara.gopinath@linaro.org>
> [ bhupesh.sharma@linaro.org: Make clock enablement optional only for qcom parts where
>    firmware has already initialized them, using a bool variable and fix
>    error paths ]
> Signed-off-by: Bhupesh Sharma <bhupesh.sharma@linaro.org>
> ---
>   drivers/crypto/qce/core.c | 89 +++++++++++++++++++++++++--------------
>   drivers/crypto/qce/core.h |  2 +
>   2 files changed, 59 insertions(+), 32 deletions(-)
> 
> diff --git a/drivers/crypto/qce/core.c b/drivers/crypto/qce/core.c
> index 905378906ac7..8c3c68ba579e 100644
> --- a/drivers/crypto/qce/core.c
> +++ b/drivers/crypto/qce/core.c
> @@ -9,6 +9,7 @@
>   #include <linux/interrupt.h>
>   #include <linux/module.h>
>   #include <linux/mod_devicetable.h>
> +#include <linux/of_device.h>
>   #include <linux/platform_device.h>
>   #include <linux/spinlock.h>
>   #include <linux/types.h>
> @@ -184,10 +185,20 @@ static int qce_check_version(struct qce_device *qce)
>   	return 0;
>   }
>   
> +static const struct of_device_id qce_crypto_of_match[] = {
> +	{ .compatible = "qcom,ipq6018-qce", },
> +	{ .compatible = "qcom,sdm845-qce", },
> +	{ .compatible = "qcom,sm8250-qce", },

Adding qcom,sm8250-qce does not belong in this patch. It deserves a 
separate patch of it's own.

> +	{}
> +};
> +MODULE_DEVICE_TABLE(of, qce_crypto_of_match);
> +
>   static int qce_crypto_probe(struct platform_device *pdev)
>   {
>   	struct device *dev = &pdev->dev;
>   	struct qce_device *qce;
> +	const struct of_device_id *of_id =
> +			of_match_device(qce_crypto_of_match, &pdev->dev);
>   	int ret;
>   
>   	qce = devm_kzalloc(dev, sizeof(*qce), GFP_KERNEL);
> @@ -198,45 +209,65 @@ static int qce_crypto_probe(struct platform_device *pdev)
>   	platform_set_drvdata(pdev, qce);
>   
>   	qce->base = devm_platform_ioremap_resource(pdev, 0);
> -	if (IS_ERR(qce->base))
> -		return PTR_ERR(qce->base);
> +	if (IS_ERR(qce->base)) {
> +		ret = PTR_ERR(qce->base);
> +		goto err_out;
> +	}

I don't see the reason for change in error handling here or below. But 
,for whatever reason this is changed, it has to be a separate patch.

>   
>   	ret = dma_set_mask_and_coherent(dev, DMA_BIT_MASK(32));
>   	if (ret < 0)
> -		return ret;
> +		goto err_out;
>   
>   	qce->mem_path = devm_of_icc_get(qce->dev, "memory");
>   	if (IS_ERR(qce->mem_path))
>   		return dev_err_probe(dev, PTR_ERR(qce->mem_path),
>   				     "Failed to get mem path\n");
>   
> -	qce->core = devm_clk_get(qce->dev, "core");
> -	if (IS_ERR(qce->core))
> -		return PTR_ERR(qce->core);
> -
> -	qce->iface = devm_clk_get(qce->dev, "iface");
> -	if (IS_ERR(qce->iface))
> -		return PTR_ERR(qce->iface);
> -
> -	qce->bus = devm_clk_get(qce->dev, "bus");
> -	if (IS_ERR(qce->bus))
> -		return PTR_ERR(qce->bus);
> -
>   	ret = icc_set_bw(qce->mem_path, QCE_DEFAULT_MEM_BANDWIDTH, QCE_DEFAULT_MEM_BANDWIDTH);
>   	if (ret)
> -		return ret;
> +		goto err_out;
>   
> -	ret = clk_prepare_enable(qce->core);
> -	if (ret)
> -		return ret;
> +	/* On some qcom parts the crypto clocks are already configured by
> +	 * the firmware running before linux. In such cases we don't need to
> +	 * enable/configure them again. Check here for the same.
> +	 */
> +	if (!strcmp(of_id->compatible, "qcom,ipq6018-qce") ||
> +	    !strcmp(of_id->compatible, "qcom,sdm845-qce"))

You can avoid this and most of this patch by using 
devm_clk_get_optional. This patch can be like just three lines of code 
change. clk_prepare_enable returns 0 if the clock is null. There is no 
need to check for the compatibles above. Use devm_clk_get_optional 
instead of devm_clk_get and everything else can be left as is.

Warm Regards
Thara

> +		qce->clks_configured_by_fw = false;
> +	else
> +		qce->clks_configured_by_fw = true;
> +
> +	if (!qce->clks_configured_by_fw) {
> +		qce->core = devm_clk_get(qce->dev, "core");
> +		if (IS_ERR(qce->core)) {
> +			ret = PTR_ERR(qce->core);
> +			goto err_out;
> +		}
> +
> +		qce->iface = devm_clk_get(qce->dev, "iface");
> +		if (IS_ERR(qce->iface)) {
> +			ret = PTR_ERR(qce->iface);
> +			goto err_out;
> +		}
> +
> +		qce->bus = devm_clk_get(qce->dev, "bus");
> +		if (IS_ERR(qce->bus)) {
> +			ret = PTR_ERR(qce->bus);
> +			goto err_out;
> +		}
> +
> +		ret = clk_prepare_enable(qce->core);
> +		if (ret)
> +			goto err_out;
>   
> -	ret = clk_prepare_enable(qce->iface);
> -	if (ret)
> -		goto err_clks_core;
> +		ret = clk_prepare_enable(qce->iface);
> +		if (ret)
> +			goto err_clks_core;
>   
> -	ret = clk_prepare_enable(qce->bus);
> -	if (ret)
> -		goto err_clks_iface;
> +		ret = clk_prepare_enable(qce->bus);
> +		if (ret)
> +			goto err_clks_iface;
> +	}
>   
>   	ret = qce_dma_request(qce->dev, &qce->dma);
>   	if (ret)
> @@ -268,6 +299,7 @@ static int qce_crypto_probe(struct platform_device *pdev)
>   	clk_disable_unprepare(qce->iface);
>   err_clks_core:
>   	clk_disable_unprepare(qce->core);
> +err_out:
>   	return ret;
>   }
>   
> @@ -284,13 +316,6 @@ static int qce_crypto_remove(struct platform_device *pdev)
>   	return 0;
>   }
>   
> -static const struct of_device_id qce_crypto_of_match[] = {
> -	{ .compatible = "qcom,ipq6018-qce", },
> -	{ .compatible = "qcom,sdm845-qce", },
> -	{}
> -};
> -MODULE_DEVICE_TABLE(of, qce_crypto_of_match);
> -
>   static struct platform_driver qce_crypto_driver = {
>   	.probe = qce_crypto_probe,
>   	.remove = qce_crypto_remove,
> diff --git a/drivers/crypto/qce/core.h b/drivers/crypto/qce/core.h
> index 228fcd69ec51..d9bf05babecc 100644
> --- a/drivers/crypto/qce/core.h
> +++ b/drivers/crypto/qce/core.h
> @@ -23,6 +23,7 @@
>    * @dma: pointer to dma data
>    * @burst_size: the crypto burst size
>    * @pipe_pair_id: which pipe pair id the device using
> + * @clks_configured_by_fw: clocks are already configured by fw
>    * @async_req_enqueue: invoked by every algorithm to enqueue a request
>    * @async_req_done: invoked by every algorithm to finish its request
>    */
> @@ -39,6 +40,7 @@ struct qce_device {
>   	struct qce_dma_data dma;
>   	int burst_size;
>   	unsigned int pipe_pair_id;
> +	bool clks_configured_by_fw;
>   	int (*async_req_enqueue)(struct qce_device *qce,
>   				 struct crypto_async_request *req);
>   	void (*async_req_done)(struct qce_device *qce, int ret);
> 


