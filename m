Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4E1BEC433F5
	for <linux-crypto@archiver.kernel.org>; Thu, 12 May 2022 23:39:07 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1359530AbiELXjG (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 12 May 2022 19:39:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58906 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1346147AbiELXjE (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 12 May 2022 19:39:04 -0400
Received: from mail-lj1-x231.google.com (mail-lj1-x231.google.com [IPv6:2a00:1450:4864:20::231])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 72F80286FF5
        for <linux-crypto@vger.kernel.org>; Thu, 12 May 2022 16:39:03 -0700 (PDT)
Received: by mail-lj1-x231.google.com with SMTP id t25so8373853ljd.6
        for <linux-crypto@vger.kernel.org>; Thu, 12 May 2022 16:39:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=UxYHPKKpJ3gJqXFoP77Myjabfl2sbzgjV+P+sSNGRWw=;
        b=dntSTokMCD79xEtTvx5gvFLZ5kcRTVQvoV2VPYYERLJmmXiz8hnZSVDnP5IRfnKQUn
         ZRfwt04aYzGCx8etnz3Pt4PT37pe+yuK2lDiN0QvmVc3rdyKwtOBvwfFiFPDItgmHizs
         N21m6rv0vm5mQFGwV1g9g+u1qot7Raepaj9hn6j3Nhyuvgxfg6RnOmRpmQ3oc9WBr70Y
         SH1B3vHIoDr1PKZOmRqy5Va2boCmz0BaJ9P4FywUSRmsW1zkUrYabqM+ZG+/aGXYknOt
         rKDATdfV7mPz+Uxn7gKMo82OIsAo1XE631ID/Q0Kzv3fULwtFosMAoDi/Wqej469bHPh
         326A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=UxYHPKKpJ3gJqXFoP77Myjabfl2sbzgjV+P+sSNGRWw=;
        b=S/Tg4pGtYvIu8tRt0GSwnI7cxMidm6Y1i3ajsQHzzwT0Ecc4IERO9ZwKZsxk/7/xP2
         9s1wgp8KKjVlAbE/6BeinyynVcxEQLjRqWixQNg6oUxpxpM2L042SeAS85RiB5zAvjoo
         b1hbwIm3OI3QOYRmRYAuGxt8+6kT+bN+QksVnD9zy9c0XSwnDeXIJ835efImOFiJ8SpD
         J51AreNbMI3wtTKja1t5p/xC7uTXfmR92L5E/csL/XasvyZuYK1uFHSCMbBxY0PsG+YC
         Ihb1jYwMDQpJkeTnve6GvQCPKD4hIE67QmRfAtscdut6+XascEv009eU+nygbcC8/VcO
         oQPQ==
X-Gm-Message-State: AOAM530EEY9nlBHJyZsj1sF8AqRvyjLfN0BJkWcmi9FXhBlQ4THzOUwF
        serESrecvwYk9PEsWRL6bBHnHw==
X-Google-Smtp-Source: ABdhPJzphaFpAg//uJb252NsVwW6dzMlwlzQWV+PmeTT41q4QnXnwikeEwE0h9ga2evmVlZo3558Hg==
X-Received: by 2002:a05:651c:312:b0:251:f8b8:184e with SMTP id a18-20020a05651c031200b00251f8b8184emr1465068ljp.9.1652398741790;
        Thu, 12 May 2022 16:39:01 -0700 (PDT)
Received: from [192.168.1.211] ([37.153.55.125])
        by smtp.gmail.com with ESMTPSA id j18-20020a056512345200b004725b701c94sm135316lfr.42.2022.05.12.16.39.00
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 12 May 2022 16:39:01 -0700 (PDT)
Message-ID: <49615bc9-c7a4-09ed-c89f-39c50e1d90ba@linaro.org>
Date:   Fri, 13 May 2022 02:39:00 +0300
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.8.1
Subject: Re: [PATCH v5 13/22] dma: qcom: bam_dma: Add support to initialize
 interconnect path
Content-Language: en-GB
To:     Bhupesh Sharma <bhupesh.sharma@linaro.org>,
        linux-arm-msm@vger.kernel.org, linux-crypto@vger.kernel.org
Cc:     bhupesh.linux@gmail.com, linux-kernel@vger.kernel.org,
        devicetree@vger.kernel.org, robh+dt@kernel.org, agross@kernel.org,
        herbert@gondor.apana.org.au, davem@davemloft.net,
        stephan@gerhold.net, Thara Gopinath <thara.gopinath@linaro.org>,
        Bjorn Andersson <bjorn.andersson@linaro.org>
References: <20211110105922.217895-1-bhupesh.sharma@linaro.org>
 <20211110105922.217895-14-bhupesh.sharma@linaro.org>
From:   Dmitry Baryshkov <dmitry.baryshkov@linaro.org>
In-Reply-To: <20211110105922.217895-14-bhupesh.sharma@linaro.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On 10/11/2021 13:59, Bhupesh Sharma wrote:
> From: Thara Gopinath <thara.gopinath@linaro.org>
> 
> BAM dma engine associated with certain hardware blocks could require
> relevant interconnect pieces be initialized prior to the dma engine
> initialization. For e.g. crypto bam dma engine on sm8250. Such requirement
> is passed on to the bam dma driver from dt via the "interconnects"
> property.  Add support in bam_dma driver to check whether the interconnect
> path is accessible/enabled prior to attempting driver intializations.
> 
> Cc: Bjorn Andersson <bjorn.andersson@linaro.org>
> Cc: Rob Herring <robh+dt@kernel.org>
> Signed-off-by: Bhupesh Sharma <bhupesh.sharma@linaro.org>
> [Make header file inclusion alphabetical and use 'devm_of_icc_get()']
> Signed-off-by: Thara Gopinath <thara.gopinath@linaro.org>
> ---
>   drivers/dma/qcom/bam_dma.c | 11 +++++++++++
>   1 file changed, 11 insertions(+)
> 
> diff --git a/drivers/dma/qcom/bam_dma.c b/drivers/dma/qcom/bam_dma.c
> index c8a77b428b52..19fb17db467f 100644
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
> @@ -392,6 +393,7 @@ struct bam_device {
>   	const struct reg_offset_data *layout;
>   
>   	struct clk *bamclk;
> +	struct icc_path *mem_path;
>   	int irq;
>   
>   	/* dma start transaction tasklet */
> @@ -1284,6 +1286,15 @@ static int bam_dma_probe(struct platform_device *pdev)
>   		return ret;
>   	}
>   
> +	/* Ensure that interconnects are initialized */
> +	bdev->mem_path = devm_of_icc_get(bdev->dev, "memory");

Also, as a note, the "memory" is not a good name for the ICC path. 
Usually they take the form of "src-dst". However in this case you can 
probably use NULL for the first and the only icc path.

> +

Extra newline, not necessary.

> +	if (IS_ERR(bdev->mem_path)) {
> +		ret = PTR_ERR(bdev->mem_path);
> +		dev_err(bdev->dev, "failed to acquire icc path %d\n", ret);
> +		goto err_disable_clk;
> +	}
> +
>   	ret = bam_init(bdev);
>   	if (ret)
>   		goto err_disable_clk;


-- 
With best wishes
Dmitry
