Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 024B9C433EF
	for <linux-crypto@archiver.kernel.org>; Mon,  7 Feb 2022 16:08:21 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231192AbiBGQGj (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Mon, 7 Feb 2022 11:06:39 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43862 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1391852AbiBGQEN (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 7 Feb 2022 11:04:13 -0500
Received: from smtp-relay-internal-1.canonical.com (smtp-relay-internal-1.canonical.com [185.125.188.123])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 584DAC0401DB
        for <linux-crypto@vger.kernel.org>; Mon,  7 Feb 2022 08:04:08 -0800 (PST)
Received: from mail-ej1-f69.google.com (mail-ej1-f69.google.com [209.85.218.69])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
        (No client certificate requested)
        by smtp-relay-internal-1.canonical.com (Postfix) with ESMTPS id 187F63F203
        for <linux-crypto@vger.kernel.org>; Mon,  7 Feb 2022 16:04:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=canonical.com;
        s=20210705; t=1644249847;
        bh=wWFN/kYmy9qogqxR7Mh7jeBKCVIaVeKo6j328DRFO5U=;
        h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
         In-Reply-To:Content-Type;
        b=rhTkA/xBwPaz9wH/5KTJdDAmdUSp8XMvNoMNzIL62XYoWeINEtHNTjLNdfqr5jEpP
         Pls4VsjFLC0iIG44HcwfegBgvioj5DM02xAxMiWMujTU6TYsM40N4FO9retiDd4Ba4
         PqYwXYAmojvTGo8AatZMPKNqjmPjeQa96RraNJ11ppEXrOLe0m8Hb1Ei/q6fsO5os1
         NQTBhUb5dX/Fy6D8xliAjPNSGRBOAGfSXRFhIAEkO2Va/K68KIMt7amNpSUoVcJLY6
         229eBiZRkc4LqEVJT5wW2DGY6y9hj19ossY87yylGeRhst1dnrLbq8oxDLp3ED3cQN
         D6vuMm/Nie2KQ==
Received: by mail-ej1-f69.google.com with SMTP id la22-20020a170907781600b006a7884de505so4500613ejc.7
        for <linux-crypto@vger.kernel.org>; Mon, 07 Feb 2022 08:04:07 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=wWFN/kYmy9qogqxR7Mh7jeBKCVIaVeKo6j328DRFO5U=;
        b=qJHdNNFQ+ADs1ExDaWTAZGAr0SpYlUSKrKhhw8ulVhDUAbIR4OrzM6j7L53jzw7k8g
         v+7HIBw1p2XwLZj8r0/UfEwIO8Oaov44Mo7tJn8ZBdEOqSSkkqG11ze063Q/bfPVqIP4
         fOkqajoffzRENjOt6FYz0P7PNtSz2+OGmFDPOoD7+/glUl20JVfI2ODZ9BjevW/nP6d5
         cT60oD6AIIDIPjRNhd2QUWz/JZ0X9/O293xAxzuSdIm6F53oJD64VwE9omwJP/NHzH4R
         YAO6U4uYWlHTo7ZEr2Fa/7r+dMHJq7juo+7xOx07S+XGATt7BS6TmTZkJ5l7tuASNfI6
         +KrQ==
X-Gm-Message-State: AOAM5337h0B3ACCQLeJUwbe1EUV1PxG1ZQEYM5Q7ym3NoY0ydfGH79rB
        vGXi7tWyijXgJYa/EPCpx7knQMtnTS2WThPx4flJyrrHrg3JESIxzYAwwp/+Y9dw+Gc60ACR8+v
        HA6FKk/R920ie5wvXOftO8eKIITmYQbRlyjQvLOg8oQ==
X-Received: by 2002:a17:907:7b85:: with SMTP id ne5mr329324ejc.572.1644249846680;
        Mon, 07 Feb 2022 08:04:06 -0800 (PST)
X-Google-Smtp-Source: ABdhPJzBm6rX0lrrq+gqVsXaiIiWLV1F3mitDpLqrcgHMbY6Jqelej9PiIrbQrRZpHU2vQlcmagUOw==
X-Received: by 2002:a17:907:7b85:: with SMTP id ne5mr329281ejc.572.1644249846145;
        Mon, 07 Feb 2022 08:04:06 -0800 (PST)
Received: from [192.168.0.90] (xdsl-188-155-168-84.adslplus.ch. [188.155.168.84])
        by smtp.gmail.com with ESMTPSA id i1sm1602107ejv.183.2022.02.07.08.04.05
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 07 Feb 2022 08:04:05 -0800 (PST)
Message-ID: <c7e160b0-16fb-79ca-c291-05571bbe8341@canonical.com>
Date:   Mon, 7 Feb 2022 17:04:04 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.5.0
Subject: Re: [PATCH 2/3] dt-bindings: crypto: Convert Atmel TDES to yaml
Content-Language: en-US
To:     Tudor Ambarus <tudor.ambarus@microchip.com>,
        herbert@gondor.apana.org.au, robh+dt@kernel.org
Cc:     davem@davemloft.net, nicolas.ferre@microchip.com,
        claudiu.beznea@microchip.com, alexandre.belloni@bootlin.com,
        linux-crypto@vger.kernel.org, devicetree@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
References: <20220207032405.70733-1-tudor.ambarus@microchip.com>
 <20220207032405.70733-3-tudor.ambarus@microchip.com>
From:   Krzysztof Kozlowski <krzysztof.kozlowski@canonical.com>
In-Reply-To: <20220207032405.70733-3-tudor.ambarus@microchip.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On 07/02/2022 04:24, Tudor Ambarus wrote:
> Convert Atmel TDES documentation to yaml format. With the conversion the
> clock and clock-names properties are made mandatory. The driver returns
> -EINVAL if "tdes_clk" is not found, reflect that in the bindings and make
> the clock and clock-names properties mandatory. Update the example to
> better describe how one should define the dt node.
> 
> Signed-off-by: Tudor Ambarus <tudor.ambarus@microchip.com>
> ---
>  .../bindings/crypto/atmel,tdes.yaml           | 63 +++++++++++++++++++
>  .../bindings/crypto/atmel-crypto.txt          | 23 -------
>  2 files changed, 63 insertions(+), 23 deletions(-)
>  create mode 100644 Documentation/devicetree/bindings/crypto/atmel,tdes.yaml
> 
> diff --git a/Documentation/devicetree/bindings/crypto/atmel,tdes.yaml b/Documentation/devicetree/bindings/crypto/atmel,tdes.yaml
> new file mode 100644
> index 000000000000..7efa5e4acaa1
> --- /dev/null
> +++ b/Documentation/devicetree/bindings/crypto/atmel,tdes.yaml
> @@ -0,0 +1,63 @@
> +# SPDX-License-Identifier: GPL-2.0-only
> +%YAML 1.2
> +---
> +$id: http://devicetree.org/schemas/crypto/atmel,tdes.yaml#
> +$schema: http://devicetree.org/meta-schemas/core.yaml#
> +
> +title: Atmel Triple Data Encryption Standard (TDES) HW cryptographic accelerator
> +
> +maintainers:
> +  - Tudor Ambarus <tudor.ambarus@microchip.com>
> +
> +properties:
> +  compatible:
> +    const: atmel,at91sam9g46-tdes
> +

Same comments as for patch 1 plus one new (also applying to previous
one). You named the file quite generic "atmel,tdes" or "atmel,aes", but
what if something newer comes for at91? Maybe name it instead
"atmel,at91sam9-aes"?


Best regards,
Krzysztof
