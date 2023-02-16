Return-Path: <linux-crypto-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E97F0C636D6
	for <linux-crypto@archiver.kernel.org>; Thu, 16 Feb 2023 14:19:18 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229885AbjBPOTR (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 16 Feb 2023 09:19:17 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56914 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229811AbjBPOTQ (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 16 Feb 2023 09:19:16 -0500
Received: from mail-lf1-x129.google.com (mail-lf1-x129.google.com [IPv6:2a00:1450:4864:20::129])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CCF4F4AFD6
        for <linux-crypto@vger.kernel.org>; Thu, 16 Feb 2023 06:19:10 -0800 (PST)
Received: by mail-lf1-x129.google.com with SMTP id h38so984584lfv.7
        for <linux-crypto@vger.kernel.org>; Thu, 16 Feb 2023 06:19:10 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=GxTGD03obauPpwowDNWVaAqc6zJSxkIOx+vWTE0ZGWc=;
        b=ioT50KfL2v2ZGczCYrYam4vv9r38LafB0yPYgqxhE/AVoKHMUBUue/zcDbiM/LbZO1
         Ys+b9JoyAbT82AsAcG8vqXWIe4tD4zAKp0zj+7jvGOCwAFLAECV/eIzcTeESGTrSnkyd
         gHAZ9o3o1QgtBI1j+oWcNsAp1z3E8VaCOFK4SNU9wUifXYHlfu8B0ePlQgyDiF8JXsBA
         JyNACezoNt4eXHkBjw93dVAJ2KB4Rw7unu/zcU2mD8Z5SgkYE7jY+pAeuttsk8NspEID
         YGQDKxkWQDkpxIDu1vEUx3JxASKgvxPOOlLawgulLlcPm90D3SzmANe37fXVvu9SbRNb
         02lg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=GxTGD03obauPpwowDNWVaAqc6zJSxkIOx+vWTE0ZGWc=;
        b=3KYK604ZeVyxl6tuFb0em2TYh7tA6QdrswraENH44MIwDHoOlvMmSnsxftBeLlGYfa
         1WSoyk5PofUZXzoTb0XMaYqAL2sJykdYf7q/NqlAeNIrZ471KGNrdbRzjYeJtdLCy+wd
         oe0fpiMrqZ+2I5MNc4zTDCBaL9hdHGBl1jnf7XBK8uQtaG90aDK/sgxXk+tChc2Cj/Em
         BUHPvc2r36qhRBraiTcT1CotGJeDGBRBgA0ci19ArOwI0KigNE9SZ0iZcUUpcKZ2kYxW
         /f+WPiGtBDQQhKBY1j1LThFOgp1/HyjquHPhaiX7HgPDIG9y6KDjWcrAmWiAIZOfBjLh
         yujg==
X-Gm-Message-State: AO0yUKUd22bKnO3c6hqpPkNH8Qzbua79AjHkWwlCYPjMaV4WyYoKBvdu
        XGk/nYTH48MrwDHhAePxwBTYcg==
X-Google-Smtp-Source: AK7set/luZwL1YyDPx/x8pAcIL8TjZWGGzKs1pIi0y2GYmBhjYX69LgYeoXWrxqa2gGSDDdtBsJ3cA==
X-Received: by 2002:a05:6512:491:b0:4b6:e4c8:8a4e with SMTP id v17-20020a056512049100b004b6e4c88a4emr1683189lfq.0.1676557148977;
        Thu, 16 Feb 2023 06:19:08 -0800 (PST)
Received: from [192.168.1.102] (88-112-131-206.elisa-laajakaista.fi. [88.112.131.206])
        by smtp.gmail.com with ESMTPSA id q28-20020ac2515c000000b004d8580b2470sm311445lfd.225.2023.02.16.06.19.07
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 16 Feb 2023 06:19:08 -0800 (PST)
Message-ID: <a5b6255c-7282-32ed-8031-a4b841a78db7@linaro.org>
Date:   Thu, 16 Feb 2023 16:18:57 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.0.2
Subject: Re: [PATCH v7 1/1] dma: qcom: bam_dma: Add support to initialize
 interconnect path
Content-Language: en-US
To:     Bhupesh Sharma <bhupesh.sharma@linaro.org>,
        dmaengine@vger.kernel.org
Cc:     agross@kernel.org, linux-crypto@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-arm-msm@vger.kernel.org,
        thara.gopinath@gmail.com, devicetree@vger.kernel.org,
        andersson@kernel.org, bhupesh.linux@gmail.com, vkoul@kernel.org,
        Rob Herring <robh@kernel.org>
References: <20220921030649.1436434-1-bhupesh.sharma@linaro.org>
 <20220921030649.1436434-2-bhupesh.sharma@linaro.org>
From:   Vladimir Zapolskiy <vladimir.zapolskiy@linaro.org>
In-Reply-To: <20220921030649.1436434-2-bhupesh.sharma@linaro.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On 9/21/22 06:06, Bhupesh Sharma wrote:
> From: Thara Gopinath <thara.gopinath@gmail.com>
> 
> BAM dma engine associated with certain hardware blocks could require
> relevant interconnect pieces be initialized prior to the dma engine
> initialization. For e.g. crypto bam dma engine on sm8250. Such requirement

Apparently it's proven that the change description is incorrect, Qualcomm
crypto engine is working fine on SM8250 and even more recent platforms,
so far there is no obvious necessity in this change.

> is passed on to the bam dma driver from dt via the "interconnects"
> property. Add support in bam_dma driver to check whether the interconnect
> path is accessible/enabled prior to attempting driver intializations.
> 
> If interconnects are not yet setup, defer the BAM DMA driver probe().
> 
> Cc: Bjorn Andersson <andersson@kernel.org>
> Cc: Rob Herring <robh@kernel.org>
> Signed-off-by: Thara Gopinath <thara.gopinath@gmail.com>
> Signed-off-by: Bhupesh Sharma <bhupesh.sharma@linaro.org>
> [Bhupesh: Make header file inclusion alphabetical and use 'devm_of_icc_get()']
> ---
>   drivers/dma/qcom/bam_dma.c | 10 ++++++++++
>   1 file changed, 10 insertions(+)
> 
> diff --git a/drivers/dma/qcom/bam_dma.c b/drivers/dma/qcom/bam_dma.c
> index 2ff787df513e..a5b0cf28ffb7 100644
> --- a/drivers/dma/qcom/bam_dma.c
> +++ b/drivers/dma/qcom/bam_dma.c
> @@ -26,6 +26,7 @@
>   #include <linux/kernel.h>
>   #include <linux/io.h>
>   #include <linux/init.h>
> +#include <linux/interconnect.h>
>   #include <linux/slab.h>
>   #include <linux/module.h>
>   #include <linux/interrupt.h>
> @@ -394,6 +395,7 @@ struct bam_device {
>   	const struct reg_offset_data *layout;
>   
>   	struct clk *bamclk;
> +	struct icc_path *mem_path;
>   	int irq;
>   
>   	/* dma start transaction tasklet */
> @@ -1294,6 +1296,14 @@ static int bam_dma_probe(struct platform_device *pdev)
>   	if (IS_ERR(bdev->bamclk))
>   		return PTR_ERR(bdev->bamclk);
>   
> +	/* Ensure that interconnects are initialized */
> +	bdev->mem_path = devm_of_icc_get(bdev->dev, "memory");
> +	if (IS_ERR(bdev->mem_path)) {
> +		ret = dev_err_probe(bdev->dev, PTR_ERR(bdev->mem_path),
> +				    "failed to acquire icc path\n");
> +		return ret;
> +	}
> +
>   	ret = clk_prepare_enable(bdev->bamclk);
>   	if (ret) {
>   		dev_err(bdev->dev, "failed to prepare/enable clock\n");

I'm resurrecting the comments on this change to emphasize the observation
that the change is not needed at all to run QCE.

--
Best wishes,
Vladimir
