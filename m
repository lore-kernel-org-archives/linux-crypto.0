Return-Path: <linux-crypto-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3D358C001E0
	for <linux-crypto@archiver.kernel.org>; Fri, 28 Jul 2023 11:17:25 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233956AbjG1LRY (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 28 Jul 2023 07:17:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59966 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229894AbjG1LRX (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 28 Jul 2023 07:17:23 -0400
Received: from mail-lj1-x234.google.com (mail-lj1-x234.google.com [IPv6:2a00:1450:4864:20::234])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 28D84271D
        for <linux-crypto@vger.kernel.org>; Fri, 28 Jul 2023 04:17:22 -0700 (PDT)
Received: by mail-lj1-x234.google.com with SMTP id 38308e7fff4ca-2b9cdbf682eso11214001fa.2
        for <linux-crypto@vger.kernel.org>; Fri, 28 Jul 2023 04:17:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1690543040; x=1691147840;
        h=content-transfer-encoding:in-reply-to:from:references:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=Fz/NwOEGvoEXeHec7Dn/tTFzvf8PDVcmnAqz2okxdfQ=;
        b=o+FM6iZcNqY02VJGheQIIq85BF0x3fxTHBjjVDqzSVJ2GVhrPBlgxACFdapbvCmRC9
         pWLyU4RFJsYa9Y8BiU3VngWPgUBvOaqxNVZK57HAHHcftO31KvbzTnXVe7XzfNdDyJm6
         tkpZLVcibUiau+NC2m4RhJgEsF0YkUD0oGXLbUTBFRJ22MDSZ/rUf0eA2xu0pR+IN3dS
         +WPXDCigoIZFjlcRJAuoPGEEU+lZo8YXsd9Zwr+due11HzLIHg5k2qxdDmJnRGdhOxUJ
         DTN1VpccuCBJMy9lh6cUBQH5vACYI9qhxN8ipL3hT6ZKUvhzbWmKnzLzipAnltFn7qAu
         n80g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1690543040; x=1691147840;
        h=content-transfer-encoding:in-reply-to:from:references:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=Fz/NwOEGvoEXeHec7Dn/tTFzvf8PDVcmnAqz2okxdfQ=;
        b=mAPoxwI4AOE4K2PYvrD2Pc6dpQJL+EuvIyxvKE3AuxNFcdgEccjzoFvTM42F0+V3wU
         rLuLgSBduVHhllXnYqb/XbmQ8H/KIJ40UZ2nV9pfJ2GbFQlL8ogqf/A3wTIgEyFyQROW
         gqM8fZL/YqXXdBGm9p5bfwPcqzMxmMLco1cg/N0Numx4szJ4ZKRGMpi4oBwc3Lml2KGG
         gcA76sTwqxV3nU99KQ9PMrTrHHB0TVMwHjYBaMzYS5MA3Hji/WE7l6YSYZNVSKNTMCb/
         Zmm5bH3PXGnH5mb0uhnHVCyhCi0q8PC7cDM5d/Fg567vCdFJELoYj3CcUzgIna9mw4z3
         oaWw==
X-Gm-Message-State: ABy/qLZtfLKM6sIMABzei+hNoEeJe6baAbFZHrn/YKdirRs4ktahyZuW
        2zSUUoeSDE+5DH5o3smmJofmzw==
X-Google-Smtp-Source: APBJJlGcKt9YarNcmQba12qMNWlX+E2xMBdlBA6De4k3HK38WARpy+705DNFcUbk29OfrrJOU5EVsQ==
X-Received: by 2002:a2e:9995:0:b0:2b7:ae29:88fd with SMTP id w21-20020a2e9995000000b002b7ae2988fdmr1493624lji.48.1690543040359;
        Fri, 28 Jul 2023 04:17:20 -0700 (PDT)
Received: from [192.168.2.107] ([79.115.63.48])
        by smtp.gmail.com with ESMTPSA id m22-20020a7bcb96000000b003f91e32b1ebsm6852738wmi.17.2023.07.28.04.17.18
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 28 Jul 2023 04:17:19 -0700 (PDT)
Message-ID: <09bd1388-02aa-32c7-319e-d7150a0f3e9c@linaro.org>
Date:   Fri, 28 Jul 2023 12:17:18 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.13.0
Subject: Re: [PATCH v3 11/50] dt-bindings: crypto: add sam9x7 in Atmel TDES
Content-Language: en-US
To:     Varshini Rajendran <varshini.rajendran@microchip.com>,
        herbert@gondor.apana.org.au, davem@davemloft.net,
        robh+dt@kernel.org, krzysztof.kozlowski+dt@linaro.org,
        conor+dt@kernel.org, nicolas.ferre@microchip.com,
        alexandre.belloni@bootlin.com, claudiu.beznea@microchip.com,
        linux-crypto@vger.kernel.org, devicetree@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
References: <20230728102442.265820-1-varshini.rajendran@microchip.com>
From:   Tudor Ambarus <tudor.ambarus@linaro.org>
In-Reply-To: <20230728102442.265820-1-varshini.rajendran@microchip.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Hi,

On 7/28/23 11:24, Varshini Rajendran wrote:
> Add DT bindings for atmel TDES.

NACK. The atmel crypto drivers check the version at runtime and
fill a capabilities structure based on the version identified.
There's a single compatible regardless of the version of the IP
used until now, why do you want to change it?

Please describe what motivated you to write this patch. Some people
can't take seriously a patch if it misses a proper description and
they just ignore it. Maybe it is worth re-reading:
https://www.kernel.org/doc/html/latest/process/submitting-patches.html#describe-your-changes

Cheers,
ta
> 
> Signed-off-by: Varshini Rajendran <varshini.rajendran@microchip.com>
> ---
>  .../devicetree/bindings/crypto/atmel,at91sam9g46-tdes.yaml  | 6 +++++-
>  1 file changed, 5 insertions(+), 1 deletion(-)
> 
> diff --git a/Documentation/devicetree/bindings/crypto/atmel,at91sam9g46-tdes.yaml b/Documentation/devicetree/bindings/crypto/atmel,at91sam9g46-tdes.yaml
> index 3d6ed24b1b00..6a441f79efea 100644
> --- a/Documentation/devicetree/bindings/crypto/atmel,at91sam9g46-tdes.yaml
> +++ b/Documentation/devicetree/bindings/crypto/atmel,at91sam9g46-tdes.yaml
> @@ -12,7 +12,11 @@ maintainers:
>  
>  properties:
>    compatible:
> -    const: atmel,at91sam9g46-tdes
> +    oneOf:
> +      - const: atmel,at91sam9g46-tdes
> +      - items:
> +          - const: microchip,sam9x7-tdes
> +          - const: atmel,at91sam9g46-tdes
>  
>    reg:
>      maxItems: 1
