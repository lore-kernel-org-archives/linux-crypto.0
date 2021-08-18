Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-19.2 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D8F50C4338F
	for <linux-crypto@archiver.kernel.org>; Wed, 18 Aug 2021 06:37:17 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id A7F3360EFE
	for <linux-crypto@archiver.kernel.org>; Wed, 18 Aug 2021 06:37:17 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238550AbhHRGht (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Wed, 18 Aug 2021 02:37:49 -0400
Received: from smtp-relay-canonical-1.canonical.com ([185.125.188.121]:52452
        "EHLO smtp-relay-canonical-1.canonical.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S238395AbhHRGhr (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 18 Aug 2021 02:37:47 -0400
Received: from mail-ed1-f70.google.com (mail-ed1-f70.google.com [209.85.208.70])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
        (No client certificate requested)
        by smtp-relay-canonical-1.canonical.com (Postfix) with ESMTPS id BA61E3FE71
        for <linux-crypto@vger.kernel.org>; Wed, 18 Aug 2021 06:37:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=canonical.com;
        s=20210705; t=1629268632;
        bh=PDa4Y8NlWc63JAE2k/U+xWg+/z+LRamng9vRqXzkmdA=;
        h=Subject:To:Cc:References:From:Message-ID:Date:MIME-Version:
         In-Reply-To:Content-Type;
        b=GTKD0bvz+E+2pVF/NUTjvZkfe0/QWMsZXaXZOrDT+j4kmjo7LsKE7IlLDMQnBcT6h
         L6+rVMQvwXhXwi4PNoFqtORz4yyJmwElCH9hwkJte2pSuJGh46pghDwGmfwXIWS/AI
         PWdvcna79GV+Y9LqtKVt6stUlvI3g+/oIYF5MpEw/+Gk+2poOXhpIbMpIltOmQnRcz
         XQxH3q6AfSOHOJ3foShvd0ctue/J5S0RqylhDkdhhgF2EcBUBA1/y2lx/e8z+J3bg3
         U1LCeq3UE/cT+cU46Jst5ZT1bdrdB/KMutie2MiBjz44oeXNkBZYvP5OQADFgG9HAq
         8P47xJzXMIxbQ==
Received: by mail-ed1-f70.google.com with SMTP id b25-20020a05640202d9b02903be7281a80cso527037edx.3
        for <linux-crypto@vger.kernel.org>; Tue, 17 Aug 2021 23:37:12 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=PDa4Y8NlWc63JAE2k/U+xWg+/z+LRamng9vRqXzkmdA=;
        b=AlHWpgwERO5tmGXuffAyJ19ZAYhbJ7kx9pTy95zjSaeBfzBvr1Da81ONgbTQLnPhwN
         UVS+5512YvlhfFeIQrfWOx+aqdL4ydNf1GzUSpp9OyFD3iSa3rDhfa0ssPU5ZxERux2Q
         RWsZPOUlfga00rObySFCFw+yhiN/Nv8SA04H4Wjy+tUHAVCQZ0IbAI3AdUYhoDb28G+4
         eiARjVQcIjLUDfMd1WfjAYw0+R0+jirHKzVSqV82eaElxL3yL01RY2aa2t45TqT+Cx+H
         0Dn7kE3I9o8XH342NSoNjqACG6483M2kp/FyDMrsmhjl+A6GQC5ghdpdJ3oxjnJR6yIn
         9cNg==
X-Gm-Message-State: AOAM533Pc6H9uiRR3Vy5F5UYFyYBUDYfPXU3n5mS4O28S2UvowORY7mm
        37RIJ6dWRUWSanKGcjvJ/WipZCBkU8bXuolUdIqYXkLf9G2YrPWBqIKh513Qj99GDs9Wng6qjQi
        Sym8VGT6Z9YOkqn8L0i84TsTMDQz2K9pI5NRxKBVm1Q==
X-Received: by 2002:a05:6402:754:: with SMTP id p20mr8667970edy.356.1629268632267;
        Tue, 17 Aug 2021 23:37:12 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJxfg/SuyOcY+aciBZsxSSWL3QxT/qTGK2gv6mTxMsNgzYjn9QNyBuTRbPIgXG6+QZzg4sd8bg==
X-Received: by 2002:a05:6402:754:: with SMTP id p20mr8667953edy.356.1629268632054;
        Tue, 17 Aug 2021 23:37:12 -0700 (PDT)
Received: from [192.168.8.102] ([86.32.42.198])
        by smtp.gmail.com with ESMTPSA id gl2sm1571286ejb.110.2021.08.17.23.37.10
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 17 Aug 2021 23:37:11 -0700 (PDT)
Subject: Re: [PATCH 2/2] dt-bindings: rng: convert Samsung Exynos TRNG to
 dtschema
To:     Lukasz Stelmach <l.stelmach@samsung.com>
Cc:     Thomas Gleixner <tglx@linutronix.de>,
        Marc Zyngier <maz@kernel.org>,
        Rob Herring <robh+dt@kernel.org>,
        Matt Mackall <mpm@selenic.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        linux-kernel@vger.kernel.org, devicetree@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        linux-samsung-soc@vger.kernel.org, linux-crypto@vger.kernel.org
References: <da43d243-35b0-2cc6-f8a0-a5d02c997301@canonical.com>
 <CGME20210817221734eucas1p2e4a0aa41406137b90e49230371b92ac6@eucas1p2.samsung.com>
 <dleftjtujnemx7.fsf%l.stelmach@samsung.com>
From:   Krzysztof Kozlowski <krzysztof.kozlowski@canonical.com>
Message-ID: <1960d499-1509-ad42-94d3-f668501fb30b@canonical.com>
Date:   Wed, 18 Aug 2021 08:37:09 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.11.0
MIME-Version: 1.0
In-Reply-To: <dleftjtujnemx7.fsf%l.stelmach@samsung.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On 18/08/2021 00:17, Lukasz Stelmach wrote:
> It was <2021-08-17 wto 16:07>, when Krzysztof Kozlowski wrote:
>> On 17/08/2021 14:34, Lukasz Stelmach wrote:
>>> It was <2021-08-17 wto 12:05>, when Krzysztof Kozlowski wrote:
>>>> On 17/08/2021 11:55, Lukasz Stelmach wrote:
>>>>> It was <2021-08-11 śro 10:43>, when Krzysztof Kozlowski wrote:
>>>>>> Convert Samsung Exynos SoC True Random Number Generator bindings to DT
>>>>>> schema format using json-schema.
>>>>>>
>>>>>> Signed-off-by: Krzysztof Kozlowski <krzysztof.kozlowski@canonical.com>
>>>>>> ---
>>>>>>  .../bindings/rng/samsung,exynos5250-trng.txt  | 17 -------
>>>>>>  .../bindings/rng/samsung,exynos5250-trng.yaml | 44 +++++++++++++++++++
>>>>>>  MAINTAINERS                                   |  2 +-
>>>>>>  3 files changed, 45 insertions(+), 18 deletions(-)
>>>>>>  delete mode 100644 Documentation/devicetree/bindings/rng/samsung,exynos5250-trng.txt
>>>>>>  create mode 100644 Documentation/devicetree/bindings/rng/samsung,exynos5250-trng.yaml
>>>>>>
>>>>>> diff --git
>>>>>> a/Documentation/devicetree/bindings/rng/samsung,exynos5250-trng.txt
>>>>>> b/Documentation/devicetree/bindings/rng/samsung,exynos5250-trng.txt
>>>>>> deleted file mode 100644
>>>>>> index 5a613a4ec780..000000000000
>>>>>> --- a/Documentation/devicetree/bindings/rng/samsung,exynos5250-trng.txt
>>>>>> +++ /dev/null
>>>>>> @@ -1,17 +0,0 @@
>>>>>> -Exynos True Random Number Generator
>>>>>> -
>>>>>> -Required properties:
>>>>>> -
>>>>>> -- compatible  : Should be "samsung,exynos5250-trng".
>>>>>> -- reg         : Specifies base physical address and size of the registers map.
>>>>>> -- clocks      : Phandle to clock-controller plus clock-specifier pair.
>>>>>> -- clock-names : "secss" as a clock name.
>>>>>> -
>>>>>> -Example:
>>>>>> -
>>>>>> -	rng@10830600 {
>>>>>> -		compatible = "samsung,exynos5250-trng";
>>>>>> -		reg = <0x10830600 0x100>;
>>>>>> -		clocks = <&clock CLK_SSS>;
>>>>>> -		clock-names = "secss";
>>>>>> -	};
>>>>>> diff --git
>>>>>> a/Documentation/devicetree/bindings/rng/samsung,exynos5250-trng.yaml
>>>>>> b/Documentation/devicetree/bindings/rng/samsung,exynos5250-trng.yaml
>>>>>> new file mode 100644
>>>>>> index 000000000000..a50c34d5d199
>>>>>> --- /dev/null
>>>>>> +++ b/Documentation/devicetree/bindings/rng/samsung,exynos5250-trng.yaml
>>>>>> @@ -0,0 +1,44 @@
>>>>>> +# SPDX-License-Identifier: (GPL-2.0 OR BSD-2-Clause)
>>>>>> +%YAML 1.2
>>>>>> +---
>>>>>> +$id:
>>>>>> https://protect2.fireeye.com/v1/url?k=f38ca35b-ac179a0d-f38d2814-0cc47a31ce52-1faa1ecb65482b8a&q=1&e=8b3490f9-a5fc-4da0-b2ee-7b0aec781403&u=http%3A%2F%2Fdevicetree.org%2Fschemas%2Frng%2Fsamsung%2Cexynos5250-trng.yaml%23
>>>>>> +$schema:
>>>>>> https://protect2.fireeye.com/v1/url?k=9409519d-cb9268cb-9408dad2-0cc47a31ce52-12394c4409905980&q=1&e=8b3490f9-a5fc-4da0-b2ee-7b0aec781403&u=http%3A%2F%2Fdevicetree.org%2Fmeta-schemas%2Fcore.yaml%23
>>>>>> +
>>>>>> +title: Samsung Exynos SoC True Random Number Generator
>>>>>> +
>>>>>> +maintainers:
>>>>>> +  - Krzysztof Kozlowski <krzysztof.kozlowski@canonical.com>
>>>>>> +  - Łukasz Stelmach <l.stelmach@samsung.com>
>>>>>> +
>>>>>> +properties:
>>>>>> +  compatible:
>>>>>> +    const: samsung,exynos5250-trng
>>>>>> +
>>>>>> +  clocks:
>>>>>> +    maxItems: 1
>>>>>
>>>>> How about copying description from above into the description: property?
>>>>
>>>> But what to copy? There is no description except generic clock bindings.
>>>>
>>>
>>> The description that "was" in the txt file.
>>
>> But there was no description of fields except copy&paste of the core
>> schema. Do you describe C code like:
>>
>> ...
>> /* unsigned int is a integer number greater or equal 0 */
>> unsigned int i;
>> ...
> 
> I believe having descriptions for reg and clocks
> 
>>>>>> -- reg         : Specifies base physical address and size of the registers map.
>>>>>> -- clocks      : Phandle to clock-controller plus clock-specifier pair.
> 
> right next to properties' formal definitions is beneficial for anyone
> browsing the YAML file. If you think otherwise, oh well, I am fine with
> that.

Useful descriptions would be beneficial. Descriptions which are copy of
schema, therefore equal to explaining unsigned int, are not beneficial.
Make the document just unnecessarily bigger, are irrelevant and hide
actual important information. One of the principles is to keep things
simple. Duplicating description from schema into specific bindings is
rather the opposite of such approach.


Best regards,
Krzysztof
