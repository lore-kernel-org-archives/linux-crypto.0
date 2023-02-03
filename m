Return-Path: <linux-crypto-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 85990C636D6
	for <linux-crypto@archiver.kernel.org>; Fri,  3 Feb 2023 09:22:21 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232644AbjBCJWU (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 3 Feb 2023 04:22:20 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41260 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232618AbjBCJVw (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 3 Feb 2023 04:21:52 -0500
Received: from mail-wr1-x434.google.com (mail-wr1-x434.google.com [IPv6:2a00:1450:4864:20::434])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AC89820D2A
        for <linux-crypto@vger.kernel.org>; Fri,  3 Feb 2023 01:20:54 -0800 (PST)
Received: by mail-wr1-x434.google.com with SMTP id t7so4055474wrp.5
        for <linux-crypto@vger.kernel.org>; Fri, 03 Feb 2023 01:20:54 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=QfC6pEbMd/VZyBMJGdZdsvGci7Xk2fl2ldZkEBmQmOE=;
        b=MSt6aMcl4MNY+lvfWMI9rTwlkkbVSGfNR+hjXr8E//er4cN0w2cc9bnB6l/KZqjMtV
         FUBZ1tjj4e+PWBSa6KN7LGA9t9KtpyEv7Ys4ap1CBP7t641xklhPyV+RBgUFHBRm7wLO
         C8KSwjvyBDjABrCJ5uJND+PHFhWgvkRQIRKKJZcDSCidScWQcOC4QgTVg18IDvC0yR9D
         vUqlVoe2UbGlt6WcdTIaRDu33cwEvA++EC3Vr2TSkR7c0vhgdaO6gDQ99RNUCoLSj57v
         9jkHZ2ZBD72fMAt++IozhYw2wJ+ejdCz/17wzMhzO/WgmE9tecU/Rep7dppVKzVzR1pg
         Yb5w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=QfC6pEbMd/VZyBMJGdZdsvGci7Xk2fl2ldZkEBmQmOE=;
        b=5umMHVxGqHLtLz49cpddh4hODcdhhi4TnLwtKVfW7Wz0GjTTshoOmehy2n+GpH1NQ7
         mQSVd7jjd1cXetXw/OQYklxlCmfcyKDHqqq5QIsNdxv6AAf1mCMGWrCW820uMxupRbqR
         jFa/bo9c954dRGpo2Sjnd9jVric2QX3RWBwjq86s5W5fhpX8dFp6NtH1DRNrzlVNNBCU
         9UnNm9YMmUspeo2ORZ+oKFwtJJErtp/P8/C0TPacGLwlMO6mpt23ia3L92ZHatxH4ZhY
         rZh4MZu9/X0ame24Cuz74aa3n+34Lzy9szp7HyV/Y9WE85LG0pfrTo2yuert++FmaG6j
         0o1w==
X-Gm-Message-State: AO0yUKVVRmSSb7Um0HOfQV7PQxUhbd+j3FfpX7WsXq9m2PebaiQxqfj8
        51Eb8LgBhr78+kVQJFEqZot3bQ==
X-Google-Smtp-Source: AK7set/OjUmTUEHH5ItXKqQ0QI4ZSsgB0iOh0f9IFinixJvKHGhZqeK7MPJ9qJvLWTJxcscBIhGJOg==
X-Received: by 2002:a5d:62cd:0:b0:2bf:be0f:b016 with SMTP id o13-20020a5d62cd000000b002bfbe0fb016mr7893445wrv.23.1675416053192;
        Fri, 03 Feb 2023 01:20:53 -0800 (PST)
Received: from [192.168.1.109] ([178.197.216.144])
        by smtp.gmail.com with ESMTPSA id w5-20020a5d6085000000b0029100e8dedasm1506283wrt.28.2023.02.03.01.20.51
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 03 Feb 2023 01:20:52 -0800 (PST)
Message-ID: <53af5fdd-149b-272e-902a-6961975f1071@linaro.org>
Date:   Fri, 3 Feb 2023 10:20:51 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.7.1
Subject: Re: [PATCH v8 9/9] crypto: qce: core: Add new compatibles for qce
 crypto driver
Content-Language: en-US
To:     neil.armstrong@linaro.org,
        Vladimir Zapolskiy <vladimir.zapolskiy@linaro.org>,
        Bjorn Andersson <andersson@kernel.org>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Thara Gopinath <thara.gopinath@gmail.com>,
        Bhupesh Sharma <bhupesh.sharma@linaro.org>
Cc:     Rob Herring <robh+dt@kernel.org>,
        Konrad Dybcio <konrad.dybcio@linaro.org>,
        Andy Gross <agross@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        devicetree@vger.kernel.org, linux-arm-msm@vger.kernel.org,
        linux-crypto@vger.kernel.org, Rob Herring <robh@kernel.org>,
        Jordan Crouse <jorcrous@amazon.com>
References: <20230202135036.2635376-1-vladimir.zapolskiy@linaro.org>
 <20230202135036.2635376-10-vladimir.zapolskiy@linaro.org>
 <6577abf2-7717-b952-13d7-9143200f24fc@linaro.org>
 <397bcc25-dd5e-808f-a38b-15e6c18db669@linaro.org>
 <8cf36a4b-2070-2e79-c06d-b0ec06d8b9f7@linaro.org>
 <261fb8cd-5043-3b2d-2c9a-2e602678517c@linaro.org>
From:   Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
In-Reply-To: <261fb8cd-5043-3b2d-2c9a-2e602678517c@linaro.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On 03/02/2023 10:19, Neil Armstrong wrote:
> On 02/02/2023 15:20, Krzysztof Kozlowski wrote:
>> On 02/02/2023 15:15, Vladimir Zapolskiy wrote:
>>> Hi Krzysztof,
>>>
>>> On 2/2/23 16:01, Krzysztof Kozlowski wrote:
>>>> On 02/02/2023 14:50, Vladimir Zapolskiy wrote:
>>>>> From: Bhupesh Sharma <bhupesh.sharma@linaro.org>
>>>>>
>>>>> Since we decided to use soc specific compatibles for describing
>>>>> the qce crypto IP nodes in the device-trees, adapt the driver
>>>>> now to handle the same.
>>>>>
>>>>> Keep the old deprecated compatible strings still in the driver,
>>>>> to ensure backward compatibility.
>>>>>
>>>>> Cc: Bjorn Andersson <andersson@kernel.org>
>>>>> Cc: Rob Herring <robh@kernel.org>
>>>>> Cc: herbert@gondor.apana.org.au
>>>>> Tested-by: Jordan Crouse <jorcrous@amazon.com>
>>>>> Signed-off-by: Bhupesh Sharma <bhupesh.sharma@linaro.org>
>>>>> [vladimir: added more SoC specfic compatibles]
>>>>> Signed-off-by: Vladimir Zapolskiy <vladimir.zapolskiy@linaro.org>
>>>>> ---
>>>>>    drivers/crypto/qce/core.c | 12 ++++++++++++
>>>>>    1 file changed, 12 insertions(+)
>>>>>
>>>>> diff --git a/drivers/crypto/qce/core.c b/drivers/crypto/qce/core.c
>>>>> index 8e496fb2d5e2..2420a5ff44d1 100644
>>>>> --- a/drivers/crypto/qce/core.c
>>>>> +++ b/drivers/crypto/qce/core.c
>>>>> @@ -291,8 +291,20 @@ static int qce_crypto_remove(struct platform_device *pdev)
>>>>>    }
>>>>>    
>>>>>    static const struct of_device_id qce_crypto_of_match[] = {
>>>>> +	/* Following two entries are deprecated (kept only for backward compatibility) */
>>>>>    	{ .compatible = "qcom,crypto-v5.1", },
>>>>>    	{ .compatible = "qcom,crypto-v5.4", },
>>>>> +	/* Add compatible strings as per updated dt-bindings, here: */
>>>>> +	{ .compatible = "qcom,ipq4019-qce", },
>>>>> +	{ .compatible = "qcom,ipq6018-qce", },
>>>>> +	{ .compatible = "qcom,ipq8074-qce", },
>>>>> +	{ .compatible = "qcom,msm8996-qce", },
>>>>> +	{ .compatible = "qcom,sdm845-qce", },
>>>>> +	{ .compatible = "qcom,sm8150-qce", },
>>>>> +	{ .compatible = "qcom,sm8250-qce", },
>>>>> +	{ .compatible = "qcom,sm8350-qce", },
>>>>> +	{ .compatible = "qcom,sm8450-qce", },
>>>>> +	{ .compatible = "qcom,sm8550-qce", },
>>>> I did not agree with this at v7 and I still do not agree. We already did
>>>> some effort to clean this pattern in other drivers, so to make it clear
>>>> - driver does not need 10 compatibles because they are the same.
>>>
>>> Here is a misunderstanding, the compatibles are not the same and it shall
>>> not be assumed this way, only the current support of the IP on different SoCs
>>> in the driver is the same.
> 
> It seems the IP version is discoverable, in this case it's perfectly valid
> to have a generic compatible along a soc specific compatible.
> 
> It has been done and validated multiple times, like for the ARM Mali Bifrost [1]
> 
> I'll propose then to add a generic "qcom,crypto" as fallback to
> all of those new compatibles and clearly document that this is only
> for crypto IP cores versions that have the runtime version discoverable.

Yes, this is good idea.

> 
> We could even add a major version generic fallback compatible like "qcom,crypto-v5" or "qcom,crypto-v5.x"
> to differentiate from older crypto devices.

Since we have mapping of versions to SoC, it's also fine.


Best regards,
Krzysztof

