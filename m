Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F200FC433F5
	for <linux-crypto@archiver.kernel.org>; Tue, 28 Dec 2021 13:08:17 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232086AbhL1NIQ (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Tue, 28 Dec 2021 08:08:16 -0500
Received: from smtp-relay-internal-1.canonical.com ([185.125.188.123]:45416
        "EHLO smtp-relay-internal-1.canonical.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231944AbhL1NIP (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 28 Dec 2021 08:08:15 -0500
Received: from mail-lj1-f198.google.com (mail-lj1-f198.google.com [209.85.208.198])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
        (No client certificate requested)
        by smtp-relay-internal-1.canonical.com (Postfix) with ESMTPS id F2C723FFDF
        for <linux-crypto@vger.kernel.org>; Tue, 28 Dec 2021 13:08:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=canonical.com;
        s=20210705; t=1640696886;
        bh=xibL3Er2RlJO3Lyq5bFLO5eoLWJoOakTjgo7xp1xbB4=;
        h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
         In-Reply-To:Content-Type;
        b=FMUVUydLOawU5wWWoU2NqpqhJUxKOW5XP1/W1ARTcOBlwieMiTWl7FAQyeg+mRuaI
         EM0uQPzpygTbbWhta3S3Ozo0FFn9KLmY1hh1zvOsnbFnFNsqbk/HRfu0KhNVQuol6B
         lBwM8vXDi+RfxCVGJoKppir5m8w93c+rUJ4ds8w1CcsXMgJvOO5MerteNwv8LHYsw0
         tRQGMuOk889wy8DCksM0oejyGxFiDheeSFiMujf26YzU9bGBqg2pbxamTMR4WUsRZl
         nIMQ41N1oHxdeuz4py5OFhoD4cOr0EyX/2SJc2oxNpAzqFc4tMWxcELCEkLiirRcnH
         Z7MpkYsxxbY2A==
Received: by mail-lj1-f198.google.com with SMTP id v19-20020a2e87d3000000b0022dbe4687f1so3234292ljj.7
        for <linux-crypto@vger.kernel.org>; Tue, 28 Dec 2021 05:08:06 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=xibL3Er2RlJO3Lyq5bFLO5eoLWJoOakTjgo7xp1xbB4=;
        b=Mvxb4seFgEcmRM5n6Q6tG0hbtVwddJ+VSHksAxwkSWt+E0gE4gMck7dW0I8/dIa2xn
         zLbBVerIMMunL6KRIQ1De9JpiY4zfCnR/1+E8b7n0cmlcX4ayQmtWst1AcSdvmxFCWhT
         pfb/95THN7Aqe2NQ36QXxix/FOH5e6eXQm9KIqKXZmZG1aAEZucv3UT/n20vcoNqPdFY
         CD1HgTrRVW3JZeG0M7JgsTjvZ2PjqbWQb5A7yjBq180oklZDd/tqJEF+HNVFghEMJNy+
         BVm5q7FpJlzU0GYa9UN3aGSQQHwPBBfeIDK6yazODV2R6Fe3RfOdOF9VsOTjXdEBDpfG
         OGow==
X-Gm-Message-State: AOAM531NCOziOJB8vWnqU9wodcWI+v2JDYr7f3mCOw48MpFi+OT4ZKbm
        VqaHpXBzUvJ6DezhDhMpfzspAzLfHFBpPHC8WrKK7Pwtm03UYuikXlvJK9SECIvDzzvJMr0SptH
        kCd9L+BmpyzdjyTp1lIlEFwJjZX0wKWzpIYVhBEzqZw==
X-Received: by 2002:a2e:a781:: with SMTP id c1mr4586650ljf.115.1640696886148;
        Tue, 28 Dec 2021 05:08:06 -0800 (PST)
X-Google-Smtp-Source: ABdhPJxFjwStqYRxpYpd5M+oo66/YQIJRdAQIrnEgPtyPnApN6cw5bAhO3y932dFaMY9Y2MWm/0NKg==
X-Received: by 2002:a2e:a781:: with SMTP id c1mr4586620ljf.115.1640696885915;
        Tue, 28 Dec 2021 05:08:05 -0800 (PST)
Received: from [192.168.3.67] (89-77-68-124.dynamic.chello.pl. [89.77.68.124])
        by smtp.gmail.com with ESMTPSA id bt9sm175878lfb.206.2021.12.28.05.08.03
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 28 Dec 2021 05:08:04 -0800 (PST)
Message-ID: <5a3d7233-8ce0-dbb5-aac4-393caadf2a6a@canonical.com>
Date:   Tue, 28 Dec 2021 14:07:59 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.3.1
Subject: Re: [PATCH 2/8] dt-bindings: rng: atmel,at91-trng: convert Atmel TRNG
 to dtschema
Content-Language: en-US
To:     Rob Herring <robh@kernel.org>
Cc:     Tony Lindgren <tony@atomide.com>, linux-kernel@vger.kernel.org,
        Tomer Maimon <tmaimon77@gmail.com>,
        Matt Mackall <mpm@selenic.com>,
        Avi Fishman <avifishman70@gmail.com>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        Nishanth Menon <nm@ti.com>,
        Patrick Venture <venture@google.com>, openbmc@lists.ozlabs.org,
        =?UTF-8?Q?Pali_Roh=c3=a1r?= <pali@kernel.org>,
        Khuong Dinh <khuong@os.amperecomputing.com>,
        linux-crypto@vger.kernel.org,
        Patrice Chotard <patrice.chotard@foss.st.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Tali Perry <tali.perry1@gmail.com>, devicetree@vger.kernel.org,
        Benjamin Fair <benjaminfair@google.com>,
        Rob Herring <robh+dt@kernel.org>,
        Nancy Yuen <yuenn@google.com>,
        Ludovic Desroches <ludovic.desroches@microchip.com>,
        Santosh Shilimkar <ssantosh@kernel.org>,
        linux-arm-kernel@lists.infradead.org,
        Nicolas Ferre <nicolas.ferre@microchip.com>
References: <20211227183251.132525-1-krzysztof.kozlowski@canonical.com>
 <20211227183251.132525-2-krzysztof.kozlowski@canonical.com>
 <1640696040.235226.685116.nullmailer@robh.at.kernel.org>
From:   Krzysztof Kozlowski <krzysztof.kozlowski@canonical.com>
In-Reply-To: <1640696040.235226.685116.nullmailer@robh.at.kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On 28/12/2021 13:54, Rob Herring wrote:
> On Mon, 27 Dec 2021 19:32:45 +0100, Krzysztof Kozlowski wrote:
>> Convert the Atmel TRNG bindings to DT schema.
>>
>> Signed-off-by: Krzysztof Kozlowski <krzysztof.kozlowski@canonical.com>
>> ---
>>  .../bindings/rng/atmel,at91-trng.yaml         | 46 +++++++++++++++++++
>>  .../devicetree/bindings/rng/atmel-trng.txt    | 16 -------
>>  2 files changed, 46 insertions(+), 16 deletions(-)
>>  create mode 100644 Documentation/devicetree/bindings/rng/atmel,at91-trng.yaml
>>  delete mode 100644 Documentation/devicetree/bindings/rng/atmel-trng.txt
>>
> 
> Running 'make dtbs_check' with the schema in this patch gives the
> following warnings. Consider if they are expected or the schema is
> incorrect. These may not be new warnings.
> 
> Note that it is not yet a requirement to have 0 warnings for dtbs_check.
> This will change in the future.
> 
> Full log is available here: https://patchwork.ozlabs.org/patch/1573492
> 
> 
> rng@e2010000: compatible:0: 'microchip,sama7g5-trng' is not one of ['atmel,at91sam9g45-trng', 'microchip,sam9x60-trng']
> 	arch/arm/boot/dts/at91-sama7g5ek.dt.yaml
> 
> rng@e2010000: compatible: Additional items are not allowed ('atmel,at91sam9g45-trng' was unexpected)
> 	arch/arm/boot/dts/at91-sama7g5ek.dt.yaml
> 
> rng@e2010000: compatible: ['microchip,sama7g5-trng', 'atmel,at91sam9g45-trng'] is too long
> 	arch/arm/boot/dts/at91-sama7g5ek.dt.yaml
> 

This patch is only converting the existing bindings, so new compatible
is not added. The issue reported here is being fixed in the next patch
(3/8).

Best regards,
Krzysztof
