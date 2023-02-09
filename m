Return-Path: <linux-crypto-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0A6E6C61DA4
	for <linux-crypto@archiver.kernel.org>; Thu,  9 Feb 2023 09:21:11 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230285AbjBIJVI (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 9 Feb 2023 04:21:08 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53744 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230108AbjBIJUt (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 9 Feb 2023 04:20:49 -0500
Received: from mail-wm1-x32b.google.com (mail-wm1-x32b.google.com [IPv6:2a00:1450:4864:20::32b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 810D36186F
        for <linux-crypto@vger.kernel.org>; Thu,  9 Feb 2023 01:19:43 -0800 (PST)
Received: by mail-wm1-x32b.google.com with SMTP id o36so977320wms.1
        for <linux-crypto@vger.kernel.org>; Thu, 09 Feb 2023 01:19:43 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=content-transfer-encoding:in-reply-to:references:cc:to:from
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=+lf8QLPCcyDvpw7oAginkoSV3mAKj3y/9VzlqPF8+0U=;
        b=V6UTmWV3UklUG+BCKfVbpD51PLxvQjUgRckjuijCqks573cOtprivY/CE341/dRA3v
         NxjFR8dLkFGCVDNDL00gCoMurLeBPxUHxBwVkcLbLVbR5dOcixpxl5nMtjq3383RW6bc
         xNzHeTYsh25RNmAoIIS6X1WYg3beRHXhBNGpfSCPh5QvHEW2ghaMecMtmkhYwjFWe+i7
         U2Lo6LzfXzkPYsqiSKK884KWfJOrWJq8sma892RLZ7PC0VZ3Rcwjp5eKX7E+AdWSzaZb
         TwxBfnVrwBjcBYZ9hiHVOLu0NV9zXV47CFjALkBPotjd9tYzuhIc9fgw/3iBFgx/xDT/
         nQ9Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:references:cc:to:from
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=+lf8QLPCcyDvpw7oAginkoSV3mAKj3y/9VzlqPF8+0U=;
        b=7gnq1l4xXzRe5S0DFSuqT4M/yRsGXfkfzN9nZ1x++G9UhEBATV/q3N4AtRzvbYIYVG
         f5dpaN4JDPhD38EJAL/3GlOFmnPxV3iWIUIJYYezu/i+HqtEBk/rwAPbI1UJgg6ah9DX
         /gsMzhc2CfiXILNULKA2AgdIybdLnvdbhae/lYZjUy1VZ/6Gh2EVcx0tlIu/mWLzXfkF
         5aTkFCEwXiJ+snc0bM4POarrDYvRIdCuY9PHQ6CEDONHMZJgd718nMXWNx86JCqE4Y0E
         fjAK5OSpGPKSlPfDvOmTMJmiI1LdunsjOKcADkl4dF8KN4PMjXQwRJ+KAe4oy8ES8qo1
         gdZw==
X-Gm-Message-State: AO0yUKXeu337pWyANBuiaoi0+TD/+scIWLNWvPqamwwsWOcHcyoVao84
        ZvIiLvlbLG9PQhnFQxydT+ZnPg==
X-Google-Smtp-Source: AK7set8uToABk3UaRvkBw8DeoFe9DRIQaKr2AnU5CSys7VDnbZYgBchuU1hSCnSy3xb7kGjg2GKSwg==
X-Received: by 2002:a05:600c:43d2:b0:3da:fc07:5e80 with SMTP id f18-20020a05600c43d200b003dafc075e80mr3817799wmn.12.1675934381973;
        Thu, 09 Feb 2023 01:19:41 -0800 (PST)
Received: from [192.168.1.109] ([178.197.216.144])
        by smtp.gmail.com with ESMTPSA id az10-20020a05600c600a00b003dc3f07c876sm4527444wmb.46.2023.02.09.01.19.40
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 09 Feb 2023 01:19:41 -0800 (PST)
Message-ID: <a5c8355c-4181-d106-2f6b-a48126cb2b70@linaro.org>
Date:   Thu, 9 Feb 2023 10:19:39 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.7.1
Subject: Re: [PATCH v9 05/14] dt-bindings: qcom-qce: Add new SoC compatible
 strings for qcom-qce
Content-Language: en-US
From:   Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
To:     Vladimir Zapolskiy <vladimir.zapolskiy@linaro.org>,
        Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>,
        Bjorn Andersson <andersson@kernel.org>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Thara Gopinath <thara.gopinath@gmail.com>,
        Bhupesh Sharma <bhupesh.sharma@linaro.org>
Cc:     Rob Herring <robh+dt@kernel.org>,
        Konrad Dybcio <konrad.dybcio@linaro.org>,
        Andy Gross <agross@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        devicetree@vger.kernel.org, linux-arm-msm@vger.kernel.org,
        linux-crypto@vger.kernel.org
References: <20230208183755.2907771-1-vladimir.zapolskiy@linaro.org>
 <20230208183755.2907771-6-vladimir.zapolskiy@linaro.org>
 <bc088534-ac1d-0504-9961-d3cd3740e2f3@linaro.org>
In-Reply-To: <bc088534-ac1d-0504-9961-d3cd3740e2f3@linaro.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On 09/02/2023 10:18, Krzysztof Kozlowski wrote:
> On 08/02/2023 19:37, Vladimir Zapolskiy wrote:
>> Change QCE IP version specific compatible to two QCE IP family compatibles
>> based on SoC name and populate these two IP families with particular SoC
>> specific IP compatible names, which are known at the moment.
>>
>> Keep the old compatible 'qcom,crypto-v5.1' for backward compatibility
>> of DTB ABI, but mark it as deprecated.
>>
>> The change is based on the original one written by Bhupesh Sharma.
>>
>> Cc: Bhupesh Sharma <bhupesh.sharma@linaro.org>
>> Signed-off-by: Vladimir Zapolskiy <vladimir.zapolskiy@linaro.org>
>> ---
>>  .../devicetree/bindings/crypto/qcom-qce.yaml  | 24 +++++++++++++++++--
>>  1 file changed, 22 insertions(+), 2 deletions(-)
>>
>> diff --git a/Documentation/devicetree/bindings/crypto/qcom-qce.yaml b/Documentation/devicetree/bindings/crypto/qcom-qce.yaml
>> index 4e00e7925fed..f6f1759a2f6e 100644
>> --- a/Documentation/devicetree/bindings/crypto/qcom-qce.yaml
>> +++ b/Documentation/devicetree/bindings/crypto/qcom-qce.yaml
>> @@ -15,7 +15,27 @@ description:
>>  
>>  properties:
>>    compatible:
>> -    const: qcom,crypto-v5.1
>> +    oneOf:
>> +      - const: qcom,crypto-v5.1
>> +        deprecated: true
>> +        description: Kept only for ABI backward compatibility
>> +      - const: qcom,crypto-v5.4
> 
> You should mention in commit msg that you document existing compatible
> v5.4. Otherwise it looks unrelated/unexplained. Especially adding
> deprecated compatible is unexpected.
> 

With commit msg adjustement for v5.4 compatible:

Reviewed-by: Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>

Best regards,
Krzysztof

