Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-19.2 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1F9E6C4338F
	for <linux-crypto@archiver.kernel.org>; Tue, 17 Aug 2021 10:06:45 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id E8A0860EFE
	for <linux-crypto@archiver.kernel.org>; Tue, 17 Aug 2021 10:06:44 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239515AbhHQKGn (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Tue, 17 Aug 2021 06:06:43 -0400
Received: from smtp-relay-canonical-0.canonical.com ([185.125.188.120]:38134
        "EHLO smtp-relay-canonical-0.canonical.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S239157AbhHQKF4 (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 17 Aug 2021 06:05:56 -0400
Received: from mail-ej1-f70.google.com (mail-ej1-f70.google.com [209.85.218.70])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
        (No client certificate requested)
        by smtp-relay-canonical-0.canonical.com (Postfix) with ESMTPS id 79CDB40C9C
        for <linux-crypto@vger.kernel.org>; Tue, 17 Aug 2021 10:05:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=canonical.com;
        s=20210705; t=1629194722;
        bh=GOIsTUQ+gJL63rEPiNcOFHz6lWCZ7WtQFp4xSBwe2Ag=;
        h=Subject:To:Cc:References:From:Message-ID:Date:MIME-Version:
         In-Reply-To:Content-Type;
        b=rUTrnVSLcvn8D+lLUN1kPdO0WD68yYVAKLO7at8vuuS1uqsyWcezZWCFV66rmY2nD
         hvHeLzVQn1i/T7labJJu4uvVHT1WHK8hyXvCae/hlcQi5PG8D2GXyxeFtP+JnRrdtA
         dNmnRIlw66Pdu4C9yofPtHCmnFf31JIQJxTfn6DFrWkuvX4oyTgMRVxK3iKBV9L+62
         T1jbC4h+XBbc/0GXRSR9A1dMD+y4jsFx6XWniNwVZ53YKnCcGVS5jeT69+fj0oDrWa
         Z0MaXerNeqwKqlCtJ4GKuUBXtWWBJsqlO6lthauDmIuMF+R+Tfl/hMbpTrm7hULiM4
         GF1vy34/Kvt6A==
Received: by mail-ej1-f70.google.com with SMTP id ja25-20020a1709079899b02905b2a2bf1a62so5805423ejc.4
        for <linux-crypto@vger.kernel.org>; Tue, 17 Aug 2021 03:05:22 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=GOIsTUQ+gJL63rEPiNcOFHz6lWCZ7WtQFp4xSBwe2Ag=;
        b=fMtUdSfnxl/Aj/ljfpiT3ueflRYXSWFpOcNSCEulyf8pWLuMS+O/iT7JrZl2BLf3+6
         1+h3bPRu4KZkYASAmc/qgL2FIuaPCsFSreGV4r8lBOFk4RltOYdlr6xlxwh23tzIyoEp
         DilGt4zB+Knh2zpppEtSVq0qMmRo2GscCLqyBs6el6J5BDvKkS9m3htveMF7SBBV6fVA
         4ST+n22b2tKzZGdcmGApJxpXR4CZOimGx07eM66Okk+DSJNpdfBt/OOZgavwkOWwfBY1
         OHLoYo81AZFmB72DMNNNNQ2cTP0pPyoOU0Bmv7s+cmac8I+cpd78leDdEtjZHEZJq4H/
         QF9g==
X-Gm-Message-State: AOAM53361lcQ0E5mw06R16Fd3c3JDwe6g96JZ3p0pzw3P+Xzq5E4Fbvi
        nec0+u5EcWieZOi8LCsGaoDncF4HP6Az+eeEbLpLUINSI/bZa3j4tTwEH4e9fsXmKxvzn4bO91u
        TKnsmNStYXV+t9ngsgPkb6kcsnLAx4JSyCVrrziccpQ==
X-Received: by 2002:a05:6402:214d:: with SMTP id bq13mr3229745edb.263.1629194722042;
        Tue, 17 Aug 2021 03:05:22 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJzC3ptiEqOWsybRDl1sa+LgQ0zWpCdCEsdKyWGPcbPrtTBHxez2xHpr+Za6aNluTlhnkIYe4g==
X-Received: by 2002:a05:6402:214d:: with SMTP id bq13mr3229732edb.263.1629194721860;
        Tue, 17 Aug 2021 03:05:21 -0700 (PDT)
Received: from [192.168.8.102] ([86.32.42.198])
        by smtp.gmail.com with ESMTPSA id p23sm559903ejc.19.2021.08.17.03.05.20
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 17 Aug 2021 03:05:21 -0700 (PDT)
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
References: <20210811084306.28740-2-krzysztof.kozlowski@canonical.com>
 <CGME20210817095553eucas1p174e68fc6d7cfad9c2fd34f729272b01a@eucas1p1.samsung.com>
 <dleftjeeasfl9b.fsf%l.stelmach@samsung.com>
From:   Krzysztof Kozlowski <krzysztof.kozlowski@canonical.com>
Message-ID: <c3a1d7d2-7b32-b7eb-4647-f86e22f5e5ff@canonical.com>
Date:   Tue, 17 Aug 2021 12:05:20 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.11.0
MIME-Version: 1.0
In-Reply-To: <dleftjeeasfl9b.fsf%l.stelmach@samsung.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On 17/08/2021 11:55, Lukasz Stelmach wrote:
> It was <2021-08-11 śro 10:43>, when Krzysztof Kozlowski wrote:
>> Convert Samsung Exynos SoC True Random Number Generator bindings to DT
>> schema format using json-schema.
>>
>> Signed-off-by: Krzysztof Kozlowski <krzysztof.kozlowski@canonical.com>
>> ---
>>  .../bindings/rng/samsung,exynos5250-trng.txt  | 17 -------
>>  .../bindings/rng/samsung,exynos5250-trng.yaml | 44 +++++++++++++++++++
>>  MAINTAINERS                                   |  2 +-
>>  3 files changed, 45 insertions(+), 18 deletions(-)
>>  delete mode 100644 Documentation/devicetree/bindings/rng/samsung,exynos5250-trng.txt
>>  create mode 100644 Documentation/devicetree/bindings/rng/samsung,exynos5250-trng.yaml
>>
>> diff --git
>> a/Documentation/devicetree/bindings/rng/samsung,exynos5250-trng.txt
>> b/Documentation/devicetree/bindings/rng/samsung,exynos5250-trng.txt
>> deleted file mode 100644
>> index 5a613a4ec780..000000000000
>> --- a/Documentation/devicetree/bindings/rng/samsung,exynos5250-trng.txt
>> +++ /dev/null
>> @@ -1,17 +0,0 @@
>> -Exynos True Random Number Generator
>> -
>> -Required properties:
>> -
>> -- compatible  : Should be "samsung,exynos5250-trng".
>> -- reg         : Specifies base physical address and size of the registers map.
>> -- clocks      : Phandle to clock-controller plus clock-specifier pair.
>> -- clock-names : "secss" as a clock name.
>> -
>> -Example:
>> -
>> -	rng@10830600 {
>> -		compatible = "samsung,exynos5250-trng";
>> -		reg = <0x10830600 0x100>;
>> -		clocks = <&clock CLK_SSS>;
>> -		clock-names = "secss";
>> -	};
>> diff --git
>> a/Documentation/devicetree/bindings/rng/samsung,exynos5250-trng.yaml
>> b/Documentation/devicetree/bindings/rng/samsung,exynos5250-trng.yaml
>> new file mode 100644
>> index 000000000000..a50c34d5d199
>> --- /dev/null
>> +++ b/Documentation/devicetree/bindings/rng/samsung,exynos5250-trng.yaml
>> @@ -0,0 +1,44 @@
>> +# SPDX-License-Identifier: (GPL-2.0 OR BSD-2-Clause)
>> +%YAML 1.2
>> +---
>> +$id:
>> https://protect2.fireeye.com/v1/url?k=f38ca35b-ac179a0d-f38d2814-0cc47a31ce52-1faa1ecb65482b8a&q=1&e=8b3490f9-a5fc-4da0-b2ee-7b0aec781403&u=http%3A%2F%2Fdevicetree.org%2Fschemas%2Frng%2Fsamsung%2Cexynos5250-trng.yaml%23
>> +$schema:
>> https://protect2.fireeye.com/v1/url?k=9409519d-cb9268cb-9408dad2-0cc47a31ce52-12394c4409905980&q=1&e=8b3490f9-a5fc-4da0-b2ee-7b0aec781403&u=http%3A%2F%2Fdevicetree.org%2Fmeta-schemas%2Fcore.yaml%23
>> +
>> +title: Samsung Exynos SoC True Random Number Generator
>> +
>> +maintainers:
>> +  - Krzysztof Kozlowski <krzysztof.kozlowski@canonical.com>
>> +  - Łukasz Stelmach <l.stelmach@samsung.com>
>> +
>> +properties:
>> +  compatible:
>> +    const: samsung,exynos5250-trng
>> +
>> +  clocks:
>> +    maxItems: 1
> 
> How about copying description from above into the description: property?

But what to copy? There is no description except generic clock bindings.

> 
>> +
>> +  clock-names:
>> +    items:
>> +      - const: secss
>> +
>> +  reg:
>> +    maxItems: 1
> 
> ditto.

The same, I have no clue what to copy. It's obvious that reg contains
"physical address and size of the registers map".


Best regards,
Krzysztof
