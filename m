Return-Path: <linux-crypto-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3EF8BC4708D
	for <linux-crypto@archiver.kernel.org>; Wed, 28 Dec 2022 16:17:46 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234461AbiL1QRl (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Wed, 28 Dec 2022 11:17:41 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36744 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234687AbiL1QRO (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 28 Dec 2022 11:17:14 -0500
Received: from mail-lj1-x229.google.com (mail-lj1-x229.google.com [IPv6:2a00:1450:4864:20::229])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 59AD71AD85
        for <linux-crypto@vger.kernel.org>; Wed, 28 Dec 2022 08:15:22 -0800 (PST)
Received: by mail-lj1-x229.google.com with SMTP id x37so10050947ljq.1
        for <linux-crypto@vger.kernel.org>; Wed, 28 Dec 2022 08:15:22 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=yDZvkBvSrq1P74c4ojvaQa9MsowatpZHUMPzWldA71g=;
        b=PvScfYgvO3aKt+TMrMAphrHdT1QPEOwJ934NeEOIEm/AIH7IDlhU+biY4NyGOaTmHJ
         RJ/7qRlSvn9OVXYjsO3PIkSSoU3MAY46ACg3CyyymURWTyKvuypz8YTPvsIll6C5lQO/
         btXjEww9oaYKWMoiPJeYYwU8aKc3h+m6bdf3RrElHoOgH+0Udzhs+x6AwVoxm2B1WmaS
         B7iXQdJ/S95Pfy3i2Qlsl9LNuGKspn+SS2w3OlYqXFD/aImEb2HQPaSz+jzwpVPw4hNP
         2hCSMAYwi6dNaFHyKQp/2X001ibstnXadYYNFHTMMF2lVQWf8mtIOWWJiSisxlkqIyvE
         jB8g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=yDZvkBvSrq1P74c4ojvaQa9MsowatpZHUMPzWldA71g=;
        b=fponMwvVfqoBma4cZW+Huot//2DU4M1ZHGGVPA7H4VfQ5VWiZpgQauzPgG5aHyw3ic
         +tNhGUL6tf4Hv1PjGJckWdsoJ2HMdWweZAZSlgAO15fEcAUau7Zq7RHQ9Sh+rRqnVaIE
         WQMFOdmg3Di6svTnxrb7ZIPZfwYnlxG3VdPObmoKM5e0pQRTAO3XmuYwOfDAjZDlutbJ
         SleK9kglka0w616ES4ho6bXOMvV+nVGpobE6k9Qf/jaNbn/R+8e1v05Th5Y55g7+ZR+9
         e4q+bAgKEhEFyqMbvWTMDCw6+O8w99St0uNspF+6NlS5z38d2Bnt9TQfbUCYmCYEA2XW
         ipZw==
X-Gm-Message-State: AFqh2kqUjWpnpwKWjpKhTD8za4FRQlpwvihGT93SwWLiqIHyPyhyafdo
        hMhBIqLSmzs12g0aJHParuKf9Q==
X-Google-Smtp-Source: AMrXdXsbQOkbDqKHCQD2ADOuTnn+8YWAjm92yxG1SkLaJfYWlVgau/fn51IQ0uv+YLr0mjQ81EAHdA==
X-Received: by 2002:a2e:8e2e:0:b0:27f:bcad:a770 with SMTP id r14-20020a2e8e2e000000b0027fbcada770mr3379097ljk.52.1672244120567;
        Wed, 28 Dec 2022 08:15:20 -0800 (PST)
Received: from ?IPV6:2001:14ba:a085:4d00::8a5? (dzccz6yyyyyyyyyyybcwt-3.rev.dnainternet.fi. [2001:14ba:a085:4d00::8a5])
        by smtp.gmail.com with ESMTPSA id r18-20020a2e8e32000000b0027cf0ecab3fsm1995465ljk.138.2022.12.28.08.15.19
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 28 Dec 2022 08:15:19 -0800 (PST)
Message-ID: <7a145132-181b-cf52-18f4-4fd1b8a565d8@linaro.org>
Date:   Wed, 28 Dec 2022 18:15:19 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.6.0
Subject: Re: [PATCH v7 1/1] dma: qcom: bam_dma: Add support to initialize
 interconnect path
Content-Language: en-GB
To:     Vinod Koul <vkoul@kernel.org>,
        Bhupesh Sharma <bhupesh.sharma@linaro.org>
Cc:     dmaengine@vger.kernel.org, agross@kernel.org,
        linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-msm@vger.kernel.org, thara.gopinath@gmail.com,
        devicetree@vger.kernel.org, andersson@kernel.org,
        bhupesh.linux@gmail.com, Rob Herring <robh@kernel.org>
References: <20220921030649.1436434-1-bhupesh.sharma@linaro.org>
 <20220921030649.1436434-2-bhupesh.sharma@linaro.org>
 <YyvKlWgaPVV3su8f@matsya>
From:   Dmitry Baryshkov <dmitry.baryshkov@linaro.org>
In-Reply-To: <YyvKlWgaPVV3su8f@matsya>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On 22/09/2022 05:38, Vinod Koul wrote:
> On 21-09-22, 08:36, Bhupesh Sharma wrote:
>> From: Thara Gopinath <thara.gopinath@gmail.com>
>>
>> BAM dma engine associated with certain hardware blocks could require
>> relevant interconnect pieces be initialized prior to the dma engine
>> initialization. For e.g. crypto bam dma engine on sm8250. Such requirement
>> is passed on to the bam dma driver from dt via the "interconnects"
>> property. Add support in bam_dma driver to check whether the interconnect
>> path is accessible/enabled prior to attempting driver intializations.
>>
>> If interconnects are not yet setup, defer the BAM DMA driver probe().
>>
>> Cc: Bjorn Andersson <andersson@kernel.org>
>> Cc: Rob Herring <robh@kernel.org>
>> Signed-off-by: Thara Gopinath <thara.gopinath@gmail.com>
>> Signed-off-by: Bhupesh Sharma <bhupesh.sharma@linaro.org>
>> [Bhupesh: Make header file inclusion alphabetical and use 'devm_of_icc_get()']
>> ---
>>   drivers/dma/qcom/bam_dma.c | 10 ++++++++++
>>   1 file changed, 10 insertions(+)
>>
>> diff --git a/drivers/dma/qcom/bam_dma.c b/drivers/dma/qcom/bam_dma.c
>> index 2ff787df513e..a5b0cf28ffb7 100644
>> --- a/drivers/dma/qcom/bam_dma.c
>> +++ b/drivers/dma/qcom/bam_dma.c
>> @@ -26,6 +26,7 @@
>>   #include <linux/kernel.h>
>>   #include <linux/io.h>
>>   #include <linux/init.h>
>> +#include <linux/interconnect.h>
>>   #include <linux/slab.h>
>>   #include <linux/module.h>
>>   #include <linux/interrupt.h>
>> @@ -394,6 +395,7 @@ struct bam_device {
>>   	const struct reg_offset_data *layout;
>>   
>>   	struct clk *bamclk;
>> +	struct icc_path *mem_path;
>>   	int irq;
>>   
>>   	/* dma start transaction tasklet */
>> @@ -1294,6 +1296,14 @@ static int bam_dma_probe(struct platform_device *pdev)
>>   	if (IS_ERR(bdev->bamclk))
>>   		return PTR_ERR(bdev->bamclk);
>>   
>> +	/* Ensure that interconnects are initialized */
>> +	bdev->mem_path = devm_of_icc_get(bdev->dev, "memory");
>> +	if (IS_ERR(bdev->mem_path)) {
>> +		ret = dev_err_probe(bdev->dev, PTR_ERR(bdev->mem_path),
>> +				    "failed to acquire icc path\n");
>> +		return ret;
>> +	}
> 
> So this makes us fail on older DT where icc path may not be present.
> Should this not be an optional thing?

If "interconnects" property is not present, of_icc_get() returns NULL. 
So the driver will not err out (correct). All ICC functions will treat 
NULL path correctly (by doing nothing). So this patch is correct.

However we'd need v8 anyway, there needs to be a bindings update.

Bhupesh, this has been lingering for some time. We need this for several 
platforms. Any chance for the v8?

> 
>> +
>>   	ret = clk_prepare_enable(bdev->bamclk);
>>   	if (ret) {
>>   		dev_err(bdev->dev, "failed to prepare/enable clock\n");
>> -- 
>> 2.37.1
> 

-- 
With best wishes
Dmitry

