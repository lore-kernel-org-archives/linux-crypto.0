Return-Path: <linux-crypto-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BCA92C6379F
	for <linux-crypto@archiver.kernel.org>; Fri, 10 Feb 2023 11:17:53 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232324AbjBJLRw (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 10 Feb 2023 06:17:52 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58534 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232404AbjBJLRn (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 10 Feb 2023 06:17:43 -0500
Received: from mail-ej1-x62f.google.com (mail-ej1-x62f.google.com [IPv6:2a00:1450:4864:20::62f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 035DB39BAF
        for <linux-crypto@vger.kernel.org>; Fri, 10 Feb 2023 03:17:27 -0800 (PST)
Received: by mail-ej1-x62f.google.com with SMTP id qb15so12872049ejc.1
        for <linux-crypto@vger.kernel.org>; Fri, 10 Feb 2023 03:17:26 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1676027840;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=aezVSxJ46OjzjaqgPkeYoeGbwBe2zO4fLCrZB2BY/og=;
        b=ooO7l0hGVnz/F4hX+nsq/R15dmokH73APhqZAa7eFE6+UR+mEm0lSteXP+VzV1mkul
         NqbT799XeR2F26VyAX4CwYVrqJIn5rs5Gxtc0Tgf9hNN8cM16ikWY8q7sAccD0ZNyHUv
         qlJI2WzqpPkhrQ52oTsqupvrzn7T+luyQV2mcdStVEnbNGz5Iajc1wErji6ot2JHLbBB
         rOWok2ABJPiYNxsDjwBOxBhPlK09hXDVithExTM8z5MPT9Zy5qI7k9BhKMVMAWnnszXn
         0GFDr0j7uQWxzmpO9EPx2BqbRLKQw5zFs1g+utM1bN7kl+ncw+m78UMy3izOjqBQyCuE
         FBWQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1676027840;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=aezVSxJ46OjzjaqgPkeYoeGbwBe2zO4fLCrZB2BY/og=;
        b=Sn15hQITq4165yyIE7AQq+MClkyj79G+CLW4fmYPDjXwWjl4M0pHiKcoiFRYztW66i
         eRD2sy/QjGbXNUE0sg8bxhwXCcePNAmvu8q8S6NyYT8CbPcoprATXmHPXZv+cIDUW7bN
         GpcF2aS843NhdUlqtsPAKgyMpXbryHWAajUN8y80LZhyj4PufP/Vc1Ax/KVuPwqVF/9b
         B1ia22BGKocJTl/bZtvyxOzNpDGHPEV2TNaWbVVbtvrC08KtUd6PQr90ehH30OByDHiJ
         2L033sGcWRoyCoKSU2eMX9j0mPdXC8sNF0WtbdhTnJv/OMLXkSS8bNbli813okhMKaMp
         /7AA==
X-Gm-Message-State: AO0yUKUveOBLViiEgkyYWl/WIIgxTaLFlzdEo8JPph3CVykZMiAW1RTA
        SgZnw9796wqZaVpE5yAaj7yZIw==
X-Google-Smtp-Source: AK7set8NkHKvtt8ANyqJ3Y2tcUCj/pPJEHc8nsiYaAnl2rX6HI9NEO85ZQo3APey5JONQ5qv3hErcA==
X-Received: by 2002:a17:906:5349:b0:889:d24e:6017 with SMTP id j9-20020a170906534900b00889d24e6017mr13083721ejo.3.1676027840433;
        Fri, 10 Feb 2023 03:17:20 -0800 (PST)
Received: from [192.168.1.102] (88-112-131-206.elisa-laajakaista.fi. [88.112.131.206])
        by smtp.gmail.com with ESMTPSA id f13-20020a170906c08d00b00878003adeeesm2250686ejz.23.2023.02.10.03.17.18
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 10 Feb 2023 03:17:19 -0800 (PST)
Message-ID: <5e419feb-8219-61d5-8e4b-f96c5f382a64@linaro.org>
Date:   Fri, 10 Feb 2023 13:17:18 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.0.2
Subject: Re: [PATCH v9 06/14] dt-bindings: qcom-qce: document optional clocks
 and clock-names properties
Content-Language: en-US
To:     Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>,
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
        linux-crypto@vger.kernel.org,
        Neil Armstrong <neil.armstrong@linaro.org>
References: <20230208183755.2907771-1-vladimir.zapolskiy@linaro.org>
 <20230208183755.2907771-7-vladimir.zapolskiy@linaro.org>
 <b2d75c0a-a9f3-3d28-5e05-25fe3a18dcfb@linaro.org>
From:   Vladimir Zapolskiy <vladimir.zapolskiy@linaro.org>
In-Reply-To: <b2d75c0a-a9f3-3d28-5e05-25fe3a18dcfb@linaro.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On 2/9/23 11:20, Krzysztof Kozlowski wrote:
> On 08/02/2023 19:37, Vladimir Zapolskiy wrote:
>> On newer Qualcomm SoCs the crypto engine clocks are enabled by default
>> by security firmware. To drop clocks and clock-names from the list of
>> required properties use 'qcom,sm8150-qce' compatible name.
>>
>> The change is based on Neil Armstrong's observation and an original change.
>>
>> Cc: Neil Armstrong <neil.armstrong@linaro.org>
>> Signed-off-by: Vladimir Zapolskiy <vladimir.zapolskiy@linaro.org>
>> ---
>>   .../devicetree/bindings/crypto/qcom-qce.yaml      | 15 +++++++++++++--
>>   1 file changed, 13 insertions(+), 2 deletions(-)
>>
>> diff --git a/Documentation/devicetree/bindings/crypto/qcom-qce.yaml b/Documentation/devicetree/bindings/crypto/qcom-qce.yaml
>> index f6f1759a2f6e..d0f6b830a5dd 100644
>> --- a/Documentation/devicetree/bindings/crypto/qcom-qce.yaml
>> +++ b/Documentation/devicetree/bindings/crypto/qcom-qce.yaml
>> @@ -79,11 +79,22 @@ properties:
>>   required:
>>     - compatible
>>     - reg
>> -  - clocks
>> -  - clock-names
>>     - dmas
>>     - dma-names
>>   
>> +if:
> 
> This should be in allOf, like I wrote in last discussion.

In the last discussion you shared two options, and I got an impression
that adding a new "non-clock-requiring" compatible is a better option,
in this series it is "qcom,sm8150-qce".

So, do you wish to see an added allOf: on top of a single if: anyway?

--
Best wishes,
Vladimir
