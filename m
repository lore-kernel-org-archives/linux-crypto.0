Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5FC54C433FE
	for <linux-crypto@archiver.kernel.org>; Tue,  8 Feb 2022 09:01:53 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1352761AbiBHJBw (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Tue, 8 Feb 2022 04:01:52 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50820 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1352732AbiBHJBv (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 8 Feb 2022 04:01:51 -0500
Received: from smtp-relay-internal-1.canonical.com (smtp-relay-internal-1.canonical.com [185.125.188.123])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2D7E2C03FECC
        for <linux-crypto@vger.kernel.org>; Tue,  8 Feb 2022 01:01:50 -0800 (PST)
Received: from mail-ej1-f70.google.com (mail-ej1-f70.google.com [209.85.218.70])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
        (No client certificate requested)
        by smtp-relay-internal-1.canonical.com (Postfix) with ESMTPS id 0D74D4004B
        for <linux-crypto@vger.kernel.org>; Tue,  8 Feb 2022 09:01:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=canonical.com;
        s=20210705; t=1644310909;
        bh=6X3Cd7CM1Wrr8f+z4sbuv+5q5Ur8HKLsDoDl3wbmedI=;
        h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
         In-Reply-To:Content-Type;
        b=ZsP6c5+5Mwk1uBcLqP3+QAWaf3QTqy82mXefJyAd5JUwof4QkcDsCafIveFSzVq0w
         KHxAygsSaFOiaBdBxHZbbWXDjVPmBb0Adob71EvQLIjrmWvuEr5hcfxQnB2hHKIygH
         NRHGyd5O3QphBXtgZDLaMPWk5Ab4aDu6L+QBvH9eM7/5+SzWklml0SMNS9VSZKJhRm
         hXuzOosd3uxJH8TkLZ/nuNFuSiFP8UlnaFb1tPlBJ4Yg+4qfUvaURY/qWGZp2FtX7U
         RwwG5SF0DyDhc+GkVBR4T3mJsqUlK/OSRYp6jD9/r+4NVVgVKdJimQj6BzdxgRHxli
         0aLSl8ImiOLww==
Received: by mail-ej1-f70.google.com with SMTP id vj1-20020a170907130100b006ccc4f41d03so1664343ejb.3
        for <linux-crypto@vger.kernel.org>; Tue, 08 Feb 2022 01:01:49 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=6X3Cd7CM1Wrr8f+z4sbuv+5q5Ur8HKLsDoDl3wbmedI=;
        b=OriLIcTNiD0yt+DcY7t/juG3DWnA4Fp3beBGZG3jt7Um67RSedbbKgdQ2WMBgQxFWv
         f5xzMsCXs+udNVfNFPHyMgF+jc/0Bcmob//zTDLLrOlLk1KPrm/BDS4EZKMVx8QE6GVR
         U06StO1n3lcgKit8UPo8hNv3GUR28tdH7cJILrxpAmah605uKuTsQTMcYiElLtg3w3/K
         KIe7qkv2RLWnUpgqTawsRiOuPux777hyzKGkQaKuOKjVQhXeuB1YjRiXUnVEnCy20kBz
         dleradsU2jQgnCyCRBqx5dbZQIIJG85tJZutEetsGXY6Faryy6N1ZsQVb+0BsJKcLcel
         FIRw==
X-Gm-Message-State: AOAM530CcPC2OjNOSmjdf+Jf+PAlJW26CSHSLRtZXjiLF/g2kOaNozaa
        PZA5K0ZnDNeWKCdTEhfalVk0lRtrYeyTLoiC7Qlip87a+Mvxwk8iIisKReZfRY1wI6TRJ/36j5d
        hWcPumWLYxBCyvb/FzQcAB5UgbMDpTEBsFjUvUJPu6Q==
X-Received: by 2002:a17:906:ecf1:: with SMTP id qt17mr2816859ejb.481.1644310908541;
        Tue, 08 Feb 2022 01:01:48 -0800 (PST)
X-Google-Smtp-Source: ABdhPJwnTepgwgfhWKl1j7F8MsIf3A3OvU3tKzyXvM3N6w/vnMOP+3rf4FCufkCqQPpyX8yWdotahg==
X-Received: by 2002:a17:906:ecf1:: with SMTP id qt17mr2816841ejb.481.1644310908352;
        Tue, 08 Feb 2022 01:01:48 -0800 (PST)
Received: from [192.168.0.92] (xdsl-188-155-168-84.adslplus.ch. [188.155.168.84])
        by smtp.gmail.com with ESMTPSA id pj22sm2710423ejb.192.2022.02.08.01.01.47
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 08 Feb 2022 01:01:47 -0800 (PST)
Message-ID: <e353cec3-9839-7274-d244-5b80b5a3fe55@canonical.com>
Date:   Tue, 8 Feb 2022 10:01:47 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.5.0
Subject: Re: [PATCH 2/3] dt-bindings: crypto: Convert Atmel TDES to yaml
Content-Language: en-US
To:     Tudor.Ambarus@microchip.com, herbert@gondor.apana.org.au,
        robh+dt@kernel.org
Cc:     davem@davemloft.net, Nicolas.Ferre@microchip.com,
        Claudiu.Beznea@microchip.com, alexandre.belloni@bootlin.com,
        linux-crypto@vger.kernel.org, devicetree@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
References: <20220207032405.70733-1-tudor.ambarus@microchip.com>
 <20220207032405.70733-3-tudor.ambarus@microchip.com>
 <c7e160b0-16fb-79ca-c291-05571bbe8341@canonical.com>
 <6aa72f5a-e9c2-cd8e-ab26-fc8b4ad5cc25@microchip.com>
From:   Krzysztof Kozlowski <krzysztof.kozlowski@canonical.com>
In-Reply-To: <6aa72f5a-e9c2-cd8e-ab26-fc8b4ad5cc25@microchip.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On 08/02/2022 05:04, Tudor.Ambarus@microchip.com wrote:
> Hi, Krzysztof,
> 
> On 2/7/22 18:04, Krzysztof Kozlowski wrote:
>> EXTERNAL EMAIL: Do not click links or open attachments unless you know the content is safe
>>
>> On 07/02/2022 04:24, Tudor Ambarus wrote:
>>> Convert Atmel TDES documentation to yaml format. With the conversion the
>>> clock and clock-names properties are made mandatory. The driver returns
>>> -EINVAL if "tdes_clk" is not found, reflect that in the bindings and make
>>> the clock and clock-names properties mandatory. Update the example to
>>> better describe how one should define the dt node.
>>>
>>> Signed-off-by: Tudor Ambarus <tudor.ambarus@microchip.com>
>>> ---
>>>  .../bindings/crypto/atmel,tdes.yaml           | 63 +++++++++++++++++++
>>>  .../bindings/crypto/atmel-crypto.txt          | 23 -------
>>>  2 files changed, 63 insertions(+), 23 deletions(-)
>>>  create mode 100644 Documentation/devicetree/bindings/crypto/atmel,tdes.yaml
>>>
>>> diff --git a/Documentation/devicetree/bindings/crypto/atmel,tdes.yaml b/Documentation/devicetree/bindings/crypto/atmel,tdes.yaml
>>> new file mode 100644
>>> index 000000000000..7efa5e4acaa1
>>> --- /dev/null
>>> +++ b/Documentation/devicetree/bindings/crypto/atmel,tdes.yaml
>>> @@ -0,0 +1,63 @@
>>> +# SPDX-License-Identifier: GPL-2.0-only
>>> +%YAML 1.2
>>> +---
>>> +$id: http://devicetree.org/schemas/crypto/atmel,tdes.yaml#
>>> +$schema: http://devicetree.org/meta-schemas/core.yaml#
>>> +
>>> +title: Atmel Triple Data Encryption Standard (TDES) HW cryptographic accelerator
>>> +
>>> +maintainers:
>>> +  - Tudor Ambarus <tudor.ambarus@microchip.com>
>>> +
>>> +properties:
>>> +  compatible:
>>> +    const: atmel,at91sam9g46-tdes
>>> +
>>
>> Same comments as for patch 1 plus one new (also applying to previous
>> one). You named the file quite generic "atmel,tdes" or "atmel,aes", but
>> what if something newer comes for at91? Maybe name it instead
>> "atmel,at91sam9-aes"?
>>
> 
> For historical reasons, the atmel-{aes,tdes,sha} drivers use their own
> fixed compatible. The differentiation between the versions of the same IP
> and their capabilities is done at run-time, by interrogating a version
> register. Thus I expect that no new compatible will be added for neither of
> these IPs.

I was not talking about compatibles. I was talking about file name. You
called it "atmel,tdes" which is quite generic. If Microchip (not
Atmel...) comes with a new type of AES/TDES/SHA block for new line of
architectures, how are you going to name the bindings?

Best regards,
Krzysztof
