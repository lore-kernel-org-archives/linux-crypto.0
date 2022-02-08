Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 75576C433F5
	for <linux-crypto@archiver.kernel.org>; Tue,  8 Feb 2022 08:59:35 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1352694AbiBHI7d (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Tue, 8 Feb 2022 03:59:33 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49854 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1351081AbiBHI7b (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 8 Feb 2022 03:59:31 -0500
Received: from smtp-relay-internal-1.canonical.com (smtp-relay-internal-1.canonical.com [185.125.188.123])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AA011C03FEC3
        for <linux-crypto@vger.kernel.org>; Tue,  8 Feb 2022 00:59:30 -0800 (PST)
Received: from mail-ed1-f71.google.com (mail-ed1-f71.google.com [209.85.208.71])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
        (No client certificate requested)
        by smtp-relay-internal-1.canonical.com (Postfix) with ESMTPS id 53E833F203
        for <linux-crypto@vger.kernel.org>; Tue,  8 Feb 2022 08:59:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=canonical.com;
        s=20210705; t=1644310769;
        bh=5BAaisfFdzHM2Ej8w1LBO0wtundXTJbEqkB562uWwIw=;
        h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
         In-Reply-To:Content-Type;
        b=Ruj09oubI9PdoxK62S8stjtYXrbwr3yAnoduQfxAucJFuXyNnQrFelSf41sOInSxQ
         BMZ3GJ4+yJm5emW5N3TOwF9vd2sGCHMyzdixklQOhsOQ3sLMFAjI5dHup2rNheQ3UB
         iZsVzSXd9o/NXKB+gOS6TxzviYe01LPXlxQbj3+enWLXGyggRCZ5QRMy7eRqp/IUgE
         5ppKTVRJJKMVC6YQD9V6mGDn7fX6tJ3ZAelivAydyUT6FL+UI9cAd9fgqYNjoMPtGG
         wQzWuOu4gbqo59LQBhSWiO49JSvZD4kD7OxGaYsJUwLzOpckU0SVEpcQI/d5j40eLh
         2WbyZAoqp4BIg==
Received: by mail-ed1-f71.google.com with SMTP id l14-20020aa7cace000000b003f7f8e1cbbdso9319844edt.20
        for <linux-crypto@vger.kernel.org>; Tue, 08 Feb 2022 00:59:29 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=5BAaisfFdzHM2Ej8w1LBO0wtundXTJbEqkB562uWwIw=;
        b=lrfmW8+TbLyKPCo76oiijN2CIjKN9HdRfGVpLvqwH+7GkiXqfy4SEENbvcFQBTgypX
         pa581lG+YyAWyuMgqRGcc4NVTNawCzxadc/doHtFzt1VqxcnWfpWnfTY7o3TozOI1h84
         5hJ1t90piVYRMuS9dI2QhU8L1KUO9/W9JabT9jM7+XsfJX2YSZ5LGpJAQrKaGR/yi0aG
         p9V38eCvLpk8asY9hjE0EU9grEkAAdlPn80ZOQ4VkGKQvfMPkaSoLlscTNf5vjgmwXxU
         wWgd+v1GUnM0r08V1j4rfqMHCDln3Zxo6ijvYh1zKICD/fqmxPRIpg5QW1x7KN7S9xta
         xavA==
X-Gm-Message-State: AOAM532zrZEQP6i79qhK4VaaNMbeTCF9F/gQaBGT99CIrBE4fXmk8vG3
        XtUE9ojtK2cFqhx4vZbVJKMgqhjpPSFCNyZtdk2GiH63H4NUg+OM34RwGnuirk3xdHOmP4lQIPf
        2FwMS9GDM9nYwi/GRvkz/dgKbznrIPrY1dtl5mzaFqw==
X-Received: by 2002:a17:907:724c:: with SMTP id ds12mr2794448ejc.203.1644310768630;
        Tue, 08 Feb 2022 00:59:28 -0800 (PST)
X-Google-Smtp-Source: ABdhPJw8tPROloPqm9ioypm8COf+zuHFCcc0iwDjz584JUVDhpmreWZwcurlewohl71zVfFFpTKOZg==
X-Received: by 2002:a17:907:724c:: with SMTP id ds12mr2794429ejc.203.1644310768388;
        Tue, 08 Feb 2022 00:59:28 -0800 (PST)
Received: from [192.168.0.92] (xdsl-188-155-168-84.adslplus.ch. [188.155.168.84])
        by smtp.gmail.com with ESMTPSA id k14sm2187785ejg.78.2022.02.08.00.59.27
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 08 Feb 2022 00:59:27 -0800 (PST)
Message-ID: <7b787aee-ceea-d035-38b1-02ba0bcd3f21@canonical.com>
Date:   Tue, 8 Feb 2022 09:59:27 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.5.0
Subject: Re: [PATCH 1/3] dt-bindings: crypto: Convert Atmel AES to yaml
Content-Language: en-US
To:     Tudor.Ambarus@microchip.com, herbert@gondor.apana.org.au,
        robh+dt@kernel.org
Cc:     davem@davemloft.net, Nicolas.Ferre@microchip.com,
        Claudiu.Beznea@microchip.com, alexandre.belloni@bootlin.com,
        linux-crypto@vger.kernel.org, devicetree@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
References: <20220207032405.70733-1-tudor.ambarus@microchip.com>
 <20220207032405.70733-2-tudor.ambarus@microchip.com>
 <f8387f12-24f9-4a39-e9b8-3b83f1de078d@canonical.com>
 <ec358f0f-e3e2-a97b-e09a-d397edc65c72@microchip.com>
From:   Krzysztof Kozlowski <krzysztof.kozlowski@canonical.com>
In-Reply-To: <ec358f0f-e3e2-a97b-e09a-d397edc65c72@microchip.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On 08/02/2022 05:10, Tudor.Ambarus@microchip.com wrote:
> Hi, Krzysztof,
> 
> On 2/7/22 17:56, Krzysztof Kozlowski wrote:
>> EXTERNAL EMAIL: Do not click links or open attachments unless you know the content is safe
>>
>> On 07/02/2022 04:24, Tudor Ambarus wrote:
>>> Convert Atmel AES documentation to yaml format. With the conversion the
>>> clock and clock-names properties are made mandatory. The driver returns
>>> -EINVAL if "aes_clk" is not found, reflect that in the bindings and make
>>> the clock and clock-names properties mandatory. Update the example to
>>> better describe how one should define the dt node.
>>>
>>> Signed-off-by: Tudor Ambarus <tudor.ambarus@microchip.com>
>>> ---
>>>  .../devicetree/bindings/crypto/atmel,aes.yaml | 65 +++++++++++++++++++
>>>  .../bindings/crypto/atmel-crypto.txt          | 20 ------
>>>  2 files changed, 65 insertions(+), 20 deletions(-)
>>>  create mode 100644 Documentation/devicetree/bindings/crypto/atmel,aes.yaml
>>>
>>> diff --git a/Documentation/devicetree/bindings/crypto/atmel,aes.yaml b/Documentation/devicetree/bindings/crypto/atmel,aes.yaml
>>> new file mode 100644
>>> index 000000000000..f77ec04dbabe
>>> --- /dev/null
>>> +++ b/Documentation/devicetree/bindings/crypto/atmel,aes.yaml
>>> @@ -0,0 +1,65 @@
>>> +# SPDX-License-Identifier: GPL-2.0-only
>>> +%YAML 1.2
>>> +---
>>> +$id: http://devicetree.org/schemas/crypto/atmel,aes.yaml#
>>> +$schema: http://devicetree.org/meta-schemas/core.yaml#
>>> +
>>> +title: Atmel Advanced Encryption Standard (AES) HW cryptographic accelerator
>>> +
>>> +maintainers:
>>> +  - Tudor Ambarus <tudor.ambarus@microchip.com>
>>> +
>>> +properties:
>>> +  compatible:
>>> +    const: atmel,at91sam9g46-aes
>>> +
>>> +  reg:
>>> +    maxItems: 1
>>> +
>>> +  interrupts:
>>> +    maxItems: 1
>>> +
>>> +  clocks:
>>> +    maxItems: 1
>>> +
>>> +  clock-names:
>>> +    const: aes_clk
>>> +
>>> +  dmas:
>>> +    items:
>>> +      - description: TX DMA Channel
>>> +      - description: RX DMA Channel
>>> +
>>> +  dma-names:
>>> +    items:
>>> +      - const: tx
>>> +      - const: rx
>>> +
>>> +required:
>>> +  - compatible
>>> +  - reg
>>> +  - interrupts
>>> +  - clocks
>>> +  - clock-names
>>> +  - dmas
>>> +  - dma-names
>>> +
>>> +additionalProperties: false
>>> +
>>> +examples:
>>> +  - |
>>> +    #include <dt-bindings/interrupt-controller/irq.h>
>>> +    #include <dt-bindings/interrupt-controller/arm-gic.h>
>>> +    #include <dt-bindings/clock/at91.h>
>>> +    #include <dt-bindings/dma/at91.h>
>>
>> One empty line for readability.
> 
> Ok.
> 
>>
>>> +    aes: aes@f8038000 {
>>
>> Generic node name, so "crypto".
> 
> Hm, I'm not convinced why, would you please give more details about this
> requirement? This IP is capable of doing just AES operations, I find it
> generic enough. We use the "aes" name on all our SoCs that have a version
> of this IP, that would be quite a change. So I would prefer to keep the
> "aes" name if possible.
> 

The requirement comes from DT specification.
"The name of a node should be somewhat generic, reflecting the function
of the device and not its precise programming
 model. If appropriate, the name should be one of the following choice"
AES is not generic. AES is specific crypto operation. The spec gives
example - "crypto", so use this one just like others are using. Atmel is
not special in that matter.


Best regards,
Krzysztof
