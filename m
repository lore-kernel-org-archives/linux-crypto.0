Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-17.3 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BB6A1C4361B
	for <linux-crypto@archiver.kernel.org>; Sat, 12 Dec 2020 15:26:06 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 7F57822795
	for <linux-crypto@archiver.kernel.org>; Sat, 12 Dec 2020 15:26:06 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730371AbgLLPZ7 (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Sat, 12 Dec 2020 10:25:59 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35800 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728234AbgLLPZ7 (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Sat, 12 Dec 2020 10:25:59 -0500
Received: from mail-qt1-x843.google.com (mail-qt1-x843.google.com [IPv6:2607:f8b0:4864:20::843])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5D764C0613CF
        for <linux-crypto@vger.kernel.org>; Sat, 12 Dec 2020 07:25:19 -0800 (PST)
Received: by mail-qt1-x843.google.com with SMTP id h19so8735427qtq.13
        for <linux-crypto@vger.kernel.org>; Sat, 12 Dec 2020 07:25:19 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=Dd5IDMk6HdEREYAjvJvG5jiNGlnVzol4x0feAnkRhko=;
        b=KHc7AYqhfFVLFwrn+eDW5521F5NUnXutf1Ope0Jsb1IBwZTIuBiIOQRFxjEP2TkSJt
         wLRhwVXNI6i/ylMShHXMJSp5N8YwROF6m/vLotUy/6PzCoVV1lzjg4L9ODgpbOzIBQgY
         Uvgn+t/c1+ZgjKHisaL+DkFa5APpmleSHPjAaIBQOjAdCLP1JxwtbNeW3TDVnQtMS7Ff
         Qc7nR/6t+We9nhAq3rFRnXQ8FX/64uJZITvq4hIiIVxtMhwTsiFtoxSbCArly5us+7wW
         lvYEhGynIEtS+/1qvajonUNnZx0p8YGDpjQ1J5cosU4LTxKO3Z8u08Bc8LQqxHEW/sMv
         OTmQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=Dd5IDMk6HdEREYAjvJvG5jiNGlnVzol4x0feAnkRhko=;
        b=YjqWM4gUxJ8kJu+9nfNWtz4tGyBvvEiZwLD6ERFna3RP7a5Dnmbbfe4NJkA2Itxlia
         OvUcxmYTJrBfAUB+sHgyrxbjQKKYqpXXOIpROFGAdPI/ZVymOhe94JDsqtUAADYgJ4nI
         nX59M1+/2wREi7mkx27p5R3Jp/oYGZXRS7nqH6xuQgxmQA0RcauAFFbyh6JEUUiuC5SY
         wKcVABDsw0fQRcBFvz+bpO3nsUX+Pb/CEnblnRJqXFN1TuYZmvGfcUxv/xBINp8MZ8VU
         Cv/IJUou+EEyf+TXGvhYUpEf4NPDilR4OUcn4FOENMiefGXF7JZqsSJ6z5bSi2crIqHx
         5gig==
X-Gm-Message-State: AOAM530828V3r2un0WT2tic3rE4a9mbpgu6+kKXNJkaZoYByPjymWiFk
        1/CdpOYCP3U6xTX9CAmzJFi1WA==
X-Google-Smtp-Source: ABdhPJz4Xc1cCp3qMWuscQSL/Y19MJx0C5m1nmu4gAsk5Tm5+LxeTXzhqTZGG49VCiqpruutfweJhA==
X-Received: by 2002:ac8:5286:: with SMTP id s6mr22799733qtn.22.1607786718459;
        Sat, 12 Dec 2020 07:25:18 -0800 (PST)
Received: from [192.168.1.93] (pool-71-163-245-5.washdc.fios.verizon.net. [71.163.245.5])
        by smtp.gmail.com with ESMTPSA id z10sm9925448qtm.54.2020.12.12.07.25.17
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 12 Dec 2020 07:25:17 -0800 (PST)
Subject: Re: [Patch v2 6/6] dt-bindings: crypto: qcom-qce: Add v5.4 to binding
To:     Rob Herring <robh@kernel.org>
Cc:     agross@kernel.org, bjorn.andersson@linaro.org,
        herbert@gondor.apana.org.au, davem@davemloft.net, sboyd@kernel.org,
        mturquette@baylibre.com, linux-arm-msm@vger.kernel.org,
        linux-crypto@vger.kernel.org, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-clk@vger.kernel.org
References: <20201119155233.3974286-1-thara.gopinath@linaro.org>
 <20201119155233.3974286-7-thara.gopinath@linaro.org>
 <20201207220909.GA918596@robh.at.kernel.org>
From:   Thara Gopinath <thara.gopinath@linaro.org>
Message-ID: <f1babcb8-6017-dd3b-cbb6-9b4334037069@linaro.org>
Date:   Sat, 12 Dec 2020 10:25:16 -0500
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <20201207220909.GA918596@robh.at.kernel.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org



On 12/7/20 5:09 PM, Rob Herring wrote:
> On Thu, Nov 19, 2020 at 10:52:33AM -0500, Thara Gopinath wrote:
>> Add compatible string to support v5.4 crypto engine.
>>
>> Signed-off-by: Thara Gopinath <thara.gopinath@linaro.org>
>> Reviewed-by: Bjorn Andersson <bjorn.andersson@linaro.org>
>> ---
>>   Documentation/devicetree/bindings/crypto/qcom-qce.txt | 4 +++-
>>   1 file changed, 3 insertions(+), 1 deletion(-)
>>
>> diff --git a/Documentation/devicetree/bindings/crypto/qcom-qce.txt b/Documentation/devicetree/bindings/crypto/qcom-qce.txt
>> index fdd53b184ba8..ed1ede9c0acc 100644
>> --- a/Documentation/devicetree/bindings/crypto/qcom-qce.txt
>> +++ b/Documentation/devicetree/bindings/crypto/qcom-qce.txt
>> @@ -2,7 +2,9 @@ Qualcomm crypto engine driver
>>   
>>   Required properties:
>>   
>> -- compatible  : should be "qcom,crypto-v5.1"
>> +- compatible  : should be
>> +		"qcom,crypto-v5.1" for ipq6018
>> +		"qcom,crypto-v5.4" for sdm845
> 
> An outstanding example of why to use SoC specific compatibles rather
> than versions. Keep v5.1, but use SoC compatibles going forward.

Hi Rob,

Thanks for the review. We have different Soc's using the same version of
the ip. Is it okay to have "qcom,sdm845-crypto", "qcom,crypto-v5.4" amd 
have only "qcom,crypto-<version>" in the driver ?

> 
>>   - reg         : specifies base physical address and size of the registers map
>>   - clocks      : phandle to clock-controller plus clock-specifier pair
>>   - clock-names : "iface" clocks register interface
>> -- 
>> 2.25.1
>>

-- 
Warm Regards
Thara
