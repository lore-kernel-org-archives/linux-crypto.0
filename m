Return-Path: <linux-crypto-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DF542C76196
	for <linux-crypto@archiver.kernel.org>; Mon,  3 Apr 2023 10:48:34 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231744AbjDCKsd (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Mon, 3 Apr 2023 06:48:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38508 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231310AbjDCKsc (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 3 Apr 2023 06:48:32 -0400
Received: from mail-lj1-x229.google.com (mail-lj1-x229.google.com [IPv6:2a00:1450:4864:20::229])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D889C7ED8
        for <linux-crypto@vger.kernel.org>; Mon,  3 Apr 2023 03:48:30 -0700 (PDT)
Received: by mail-lj1-x229.google.com with SMTP id a11so29851172lji.6
        for <linux-crypto@vger.kernel.org>; Mon, 03 Apr 2023 03:48:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1680518909;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=4n9yhzm1Rmk8D25FTiH0wOJ+GO4nCT0aVo2ehKd/0bI=;
        b=c0uJzu1LiPBut0N7W8zNzlAV9wmMrZZZpbLe/3ycBlOFIuMn0P5nX3QLN31VNxOVps
         ppMd6IWf3/FQ99ALwIPjufG53hlW0NOaO9kfCdzuagDp3o5/4+wANyp0vWasLbujmCmA
         PUvisxJBeLuctt5Y/FnhZ1VbuudXDFYUEwRKj0D1wkz/T09+BkHogFOcvQ7ErrrcDrY2
         v4SjUKlP9XTkcXhdPM1OlC6kXUqiP4jNSbb+TP4rZOeqN9z12ks8VP3Wa80F83Hbe3zC
         cTXQhrN5dRWJ7ox445WJftUWLlFDLHPraL+HlIrf9bVUvCGKNGbsMqUOPa6fhkHCjLSM
         f3uQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1680518909;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=4n9yhzm1Rmk8D25FTiH0wOJ+GO4nCT0aVo2ehKd/0bI=;
        b=4IjP3YqontMkoM1Df/gaZbwDwGncdQaSGDobCc9DuMYh8Iojif++aUMI0ACXq7920O
         7uWumMA4jjTnkVrK/0yBmTG7kWFNI3GQmrpFOz0BiY8K2sbrJkhe1NqxiIfit3+Uggsl
         P7kUAETPRHMG9hGfIG8ezqL4naZPLRr8Nprf171roub4dcL86MjmsggBSHVG3O9LRv7+
         TelVSaqpI0sd6AT48f6gE+y+zxsK7yetB+pzoNrwcELqcVrQ6C77goqMf496BqKcfAZi
         z0aecD6liOY6DAFg+/AF6SM5zhiYVXbrxVs8PNZ98qdzVjJXiNgzWBjSGw3hLg8YrR61
         X7Wg==
X-Gm-Message-State: AAQBX9clZtOCZskZzQg8EBACmCkh6/Y0UWJOvjlyFLJamLNeeTQmT19F
        GsaWNi0C6zHghxEc3gIrAZbbqA==
X-Google-Smtp-Source: AKy350b9py/sij6PkWPceiL0IU5yAJ5hg6zA+et/1jOZ9VZhnEZINtiQQwxVTa7ptGeT1rQVEva9GQ==
X-Received: by 2002:a2e:b043:0:b0:295:c491:3b16 with SMTP id d3-20020a2eb043000000b00295c4913b16mr4737035ljl.7.1680518909142;
        Mon, 03 Apr 2023 03:48:29 -0700 (PDT)
Received: from [192.168.1.101] (abxj135.neoplus.adsl.tpnet.pl. [83.9.3.135])
        by smtp.gmail.com with ESMTPSA id g25-20020a2e9cd9000000b00298a8527806sm1688302ljj.93.2023.04.03.03.48.27
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 03 Apr 2023 03:48:28 -0700 (PDT)
Message-ID: <463a9885-741e-a44a-c6c2-7cf5b0560d2d@linaro.org>
Date:   Mon, 3 Apr 2023 12:48:27 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.9.1
Subject: Re: [PATCH v5 05/11] dt-bindings: qcom-qce: Fix compatible
 combinations for SM8150 and IPQ4019 SoCs
Content-Language: en-US
To:     Bhupesh Sharma <bhupesh.sharma@linaro.org>,
        Vladimir Zapolskiy <vladimir.zapolskiy@linaro.org>
Cc:     linux-arm-msm@vger.kernel.org, devicetree@vger.kernel.org,
        agross@kernel.org, linux-kernel@vger.kernel.org,
        linux-crypto@vger.kernel.org, andersson@kernel.org,
        bhupesh.linux@gmail.com, krzysztof.kozlowski@linaro.org,
        robh+dt@kernel.org, rfoss@kernel.org, neil.armstrong@linaro.org
References: <20230402100509.1154220-1-bhupesh.sharma@linaro.org>
 <20230402100509.1154220-6-bhupesh.sharma@linaro.org>
 <21eaeea4-4f2e-5ce5-c75b-d74ded8e6e4c@linaro.org>
 <CAH=2NtzKGxzmCq2JTajxWoeRFR+mPnFY3YF5mn0tGt30T7SJoQ@mail.gmail.com>
From:   Konrad Dybcio <konrad.dybcio@linaro.org>
In-Reply-To: <CAH=2NtzKGxzmCq2JTajxWoeRFR+mPnFY3YF5mn0tGt30T7SJoQ@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org



On 3.04.2023 08:15, Bhupesh Sharma wrote:
> On Mon, 3 Apr 2023 at 11:06, Vladimir Zapolskiy
> <vladimir.zapolskiy@linaro.org> wrote:
>>
>> On 4/2/23 13:05, Bhupesh Sharma wrote:
>>> Currently the compatible list available in 'qce' dt-bindings does not
>>> support SM8150 and IPQ4019 SoCs directly which may lead to potential
>>> 'dtbs_check' error(s).
>>>
>>> Fix the same.
>>>
>>> Signed-off-by: Bhupesh Sharma <bhupesh.sharma@linaro.org>
>>> ---
>>>   Documentation/devicetree/bindings/crypto/qcom-qce.yaml | 6 ++++++
>>>   1 file changed, 6 insertions(+)
>>>
>>> diff --git a/Documentation/devicetree/bindings/crypto/qcom-qce.yaml b/Documentation/devicetree/bindings/crypto/qcom-qce.yaml
>>> index e375bd981300..90ddf98a6df9 100644
>>> --- a/Documentation/devicetree/bindings/crypto/qcom-qce.yaml
>>> +++ b/Documentation/devicetree/bindings/crypto/qcom-qce.yaml
>>> @@ -24,6 +24,12 @@ properties:
>>>           deprecated: true
>>>           description: Kept only for ABI backward compatibility
>>>
>>> +      - items:
>>> +          - enum:
>>> +              - qcom,ipq4019-qce
>>> +              - qcom,sm8150-qce
>>> +          - const: qcom,qce
>>> +
>>>         - items:
>>>             - enum:
>>>                 - qcom,ipq6018-qce
>>
>> Two commit tags given for v2 are missing.
> 
> Cannot get your comment. Please be more descriptive.

https://lore.kernel.org/linux-arm-msm/333081a2-6b31-3fca-1a95-4273b5a46fb7@linaro.org/

Konrad
> 
> Thanks,
> Bhupesh
