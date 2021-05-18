Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-17.3 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5BE3BC43462
	for <linux-crypto@archiver.kernel.org>; Tue, 18 May 2021 15:38:14 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 3ECE4611BF
	for <linux-crypto@archiver.kernel.org>; Tue, 18 May 2021 15:38:14 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1350246AbhERPja (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Tue, 18 May 2021 11:39:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42784 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1350247AbhERPja (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 18 May 2021 11:39:30 -0400
Received: from mail-qk1-x734.google.com (mail-qk1-x734.google.com [IPv6:2607:f8b0:4864:20::734])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2B778C061573
        for <linux-crypto@vger.kernel.org>; Tue, 18 May 2021 08:38:11 -0700 (PDT)
Received: by mail-qk1-x734.google.com with SMTP id l129so9656003qke.8
        for <linux-crypto@vger.kernel.org>; Tue, 18 May 2021 08:38:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=fHk8jTLjGRhBkosG/Y9mmV4IXiwYJNJWhiEHtFbYDBE=;
        b=KL8aoq2dBknGdwjLoxfcvrplt+zbdX4cbam2aZQNX1/s4a3hyLLKwCL570ng4FkciW
         caehR6MGKn8Jz6XiEa5lcmt+/9BX+B8mJBcgl9LSiD4UWG9UsnzX40ErxOeUnaNbBQQz
         9Y+Yn83CBn0i8D/AH4OsAwGCEsDLShH9uzUevV2+AaHC95xUJhgGsC2oKcfNpDuUSgaI
         beZF5lY9Ga/E97/OoUd/G77UkrnKBseOWRBsnr0zWAAriMrqSanKC/a1+uT5Yg5yU0L2
         A/eSTy4mgkHx9KiTf9AuQQ/HqD7RhNspwhPF0DL7BG2jCf+hfgvX3nAFk8xWUkd7POrf
         PJxw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=fHk8jTLjGRhBkosG/Y9mmV4IXiwYJNJWhiEHtFbYDBE=;
        b=cUOvRiuj+k6JBvhsDfTmpkKeWdsdTwzxRbJe9JK/aLkhyez0AoDZPMtlosdSEsVdoN
         1QdK50o7xQPKXAtM3Svagu66sleZmn0o6VpIY5Grp+KQHIysqsTEP5gwbUpYnUcIBLKE
         tOG2iOq7Tnqj5MAHKqYES4dFj2zGMIih0WSleEYsDYc+Yqkn8YHec8k7yq+u8cDFrNLV
         Afrpa9e0SMMhDG+F5ixQkiFD2pZ4jwPRdzUutL9h/2+XNuzJWECcSCO3+9XYhnnZ6Qtd
         7ggAmuCfAgFCrqlHVpAh7I3CrQ3jUhjcsArR4FO6L07LUCvunvHjKNNUnrRODo4e3b0O
         50/A==
X-Gm-Message-State: AOAM532qijh9hZd1E62lkb8dBlUpSbM/aS8bZ2YC3Lz2q1iGI3H/BLPl
        Rzf6F/HTF/xJPebNqm8n0ehIqA==
X-Google-Smtp-Source: ABdhPJzDZ3tqdXRScQz088nvn5Uj75hTZPqJ2TQAAvPz7G51zpOw4SlYxu/1Iko+aKuPUXfhFo0aCQ==
X-Received: by 2002:a05:620a:2291:: with SMTP id o17mr6071185qkh.150.1621352290394;
        Tue, 18 May 2021 08:38:10 -0700 (PDT)
Received: from [192.168.1.93] (pool-71-163-245-5.washdc.fios.verizon.net. [71.163.245.5])
        by smtp.gmail.com with ESMTPSA id o4sm7155973qkb.29.2021.05.18.08.38.08
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 18 May 2021 08:38:09 -0700 (PDT)
Subject: Re: [PATCH v2 09/17] crypto: qce: core: Add support to initialize
 interconnect path
To:     Bjorn Andersson <bjorn.andersson@linaro.org>,
        Bhupesh Sharma <bhupesh.sharma@linaro.org>
Cc:     linux-arm-msm@vger.kernel.org, Rob Herring <robh+dt@kernel.org>,
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
 <20210505213731.538612-10-bhupesh.sharma@linaro.org>
 <20210518150702.GW2484@yoga>
From:   Thara Gopinath <thara.gopinath@linaro.org>
Message-ID: <180046b9-35fb-f7c1-fc92-a0fb5eecace5@linaro.org>
Date:   Tue, 18 May 2021 11:38:08 -0400
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <20210518150702.GW2484@yoga>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org



On 5/18/21 11:07 AM, Bjorn Andersson wrote:
> On Wed 05 May 16:37 CDT 2021, Bhupesh Sharma wrote:
> 
>> From: Thara Gopinath <thara.gopinath@linaro.org>
>>
>> Crypto engine on certain Snapdragon processors like sm8150, sm8250, sm8350
>> etc. requires interconnect path between the engine and memory to be
>> explicitly enabled and bandwidth set prior to any operations. Add support
>> in the qce core to enable the interconnect path appropriately.
>>
>> Cc: Bjorn Andersson <bjorn.andersson@linaro.org>
>> Cc: Rob Herring <robh+dt@kernel.org>
>> Cc: Andy Gross <agross@kernel.org>
>> Cc: Herbert Xu <herbert@gondor.apana.org.au>
>> Cc: David S. Miller <davem@davemloft.net>
>> Cc: Stephen Boyd <sboyd@kernel.org>
>> Cc: Michael Turquette <mturquette@baylibre.com>
>> Cc: Vinod Koul <vkoul@kernel.org>
>> Cc: dmaengine@vger.kernel.org
>> Cc: linux-clk@vger.kernel.org
>> Cc: linux-crypto@vger.kernel.org
>> Cc: devicetree@vger.kernel.org
>> Cc: linux-kernel@vger.kernel.org
>> Cc: bhupesh.linux@gmail.com
>> Signed-off-by: Bhupesh Sharma <bhupesh.sharma@linaro.org>
>> [Make header file inclusion alphabetical]
>> Signed-off-by: Thara Gopinath <thara.gopinath@linaro.org>
> 
> This says that you prepared the patch, then Thara picked up the patch
> and sorted the includes. But somehow you then sent the patch.
> 
> I.e. you name should be the last - unless you jointly wrote the path, in
> which case you should also add a "Co-developed-by: Thara".
> 
>> ---
>>   drivers/crypto/qce/core.c | 35 ++++++++++++++++++++++++++++-------
>>   drivers/crypto/qce/core.h |  1 +
>>   2 files changed, 29 insertions(+), 7 deletions(-)
>>
>> diff --git a/drivers/crypto/qce/core.c b/drivers/crypto/qce/core.c
>> index 80b75085c265..92a0ff1d357e 100644
>> --- a/drivers/crypto/qce/core.c
>> +++ b/drivers/crypto/qce/core.c
>> @@ -5,6 +5,7 @@
>>   
>>   #include <linux/clk.h>
>>   #include <linux/dma-mapping.h>
>> +#include <linux/interconnect.h>
>>   #include <linux/interrupt.h>
>>   #include <linux/module.h>
>>   #include <linux/mod_devicetable.h>
>> @@ -21,6 +22,8 @@
>>   #define QCE_MAJOR_VERSION5	0x05
>>   #define QCE_QUEUE_LENGTH	1
>>   
>> +#define QCE_DEFAULT_MEM_BANDWIDTH	393600
> 
> Do we know what this rate is?
> 
>> +
>>   static const struct qce_algo_ops *qce_ops[] = {
>>   #ifdef CONFIG_CRYPTO_DEV_QCE_SKCIPHER
>>   	&skcipher_ops,
>> @@ -202,21 +205,35 @@ static int qce_crypto_probe(struct platform_device *pdev)
>>   	if (ret < 0)
>>   		return ret;
>>   
>> +	qce->mem_path = of_icc_get(qce->dev, "memory");
> 
> Using devm_of_icc_get() would save you some changes to the error path.

Right. I keep forgetting to use the devm_ version! Bhupesh, will you do 
these changes or do you want me to ?

-- 
Warm Regards
Thara



