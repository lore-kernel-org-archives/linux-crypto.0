Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-14.0 required=3.0 tests=BAYES_00,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D8CD7C4707C
	for <linux-crypto@archiver.kernel.org>; Fri, 21 May 2021 17:27:52 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id B28EB61168
	for <linux-crypto@archiver.kernel.org>; Fri, 21 May 2021 17:27:52 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231948AbhEUR3O (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 21 May 2021 13:29:14 -0400
Received: from mail-ot1-f46.google.com ([209.85.210.46]:44889 "EHLO
        mail-ot1-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230048AbhEUR3O (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 21 May 2021 13:29:14 -0400
Received: by mail-ot1-f46.google.com with SMTP id r26-20020a056830121ab02902a5ff1c9b81so18688091otp.11;
        Fri, 21 May 2021 10:27:51 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=LMRIKwF8sfn6ggOmBatYMiKJaKRdHHfkAB2nXDbZPcM=;
        b=nbZo6HNvSGJZwPZ2B/4+V+9t8xIU2i19YvuWRfyum3+TP7PQuyOojMZS/qA2BMpt40
         S4m/C4s6AhP1bcp7vGlN7ZzqUMRFPYmdzH3DcHSdjlqaX9hZm6oOKHY8vYjBsTAXwAL4
         nY820oAX41zBaRB4nwoYCPogxrP31O116fkfq6PkPJBLBLEUxb3z97+Zw8CAsFhQXIaw
         oNE5JNLyWfTwT7af4akrnWR5wIuCVpJxl04yZKqbI/Rn9/dNwJ9TrCaHTDehzdqCwfrg
         XXfbCSpUSEwIBK4GbOvOsvUBgfrw85DBfwp8xnq5F80Jv14B3SmQpfHQaEWxBLQap3Vk
         6IJg==
X-Gm-Message-State: AOAM533OugNe9Uxx4OgmiipPY+CIAEcR1kBIF8372LI3vHjex15AbtGM
        3XQ7bGzg7Bq/4nsbzZHauQ==
X-Google-Smtp-Source: ABdhPJxg6Yj+G38ieYnK1K6yYg1HrjjDK2nARduNYJNcbkSpDMg3P/Mn6MJ0TdL+WmK5NrvlCM0gtw==
X-Received: by 2002:a05:6830:1e70:: with SMTP id m16mr9260414otr.340.1621618070625;
        Fri, 21 May 2021 10:27:50 -0700 (PDT)
Received: from robh.at.kernel.org (24-155-109-49.dyn.grandenetworks.net. [24.155.109.49])
        by smtp.gmail.com with ESMTPSA id a18sm1011839oiy.24.2021.05.21.10.27.49
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 21 May 2021 10:27:50 -0700 (PDT)
Received: (nullmailer pid 49888 invoked by uid 1000);
        Fri, 21 May 2021 17:27:49 -0000
Date:   Fri, 21 May 2021 12:27:49 -0500
From:   Rob Herring <robh@kernel.org>
To:     Linus Walleij <linus.walleij@linaro.org>
Cc:     linux-crypto@vger.kernel.org,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "David S . Miller" <davem@davemloft.net>,
        Corentin Labbe <clabbe@baylibre.com>,
        linux-arm-kernel@lists.infradead.org,
        Imre Kaloz <kaloz@openwrt.org>,
        Krzysztof Halasa <khalasa@piap.pl>,
        Arnd Bergmann <arnd@arndb.de>, devicetree@vger.kernel.org
Subject: Re: [PATCH 2/3 v2] crypto: ixp4xx: Add DT bindings
Message-ID: <20210521172749.GA33272@robh.at.kernel.org>
References: <20210520223020.731925-1-linus.walleij@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210520223020.731925-1-linus.walleij@linaro.org>
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Fri, May 21, 2021 at 12:30:20AM +0200, Linus Walleij wrote:
> This adds device tree bindings for the ixp4xx crypto engine.
> 
> Cc: Corentin Labbe <clabbe@baylibre.com>
> Cc: devicetree@vger.kernel.org
> Signed-off-by: Linus Walleij <linus.walleij@linaro.org>
> ---
> ChangeLog v1->v2:
> - Drop the phandle to self, just add an NPE instance number
>   instead.
> - Add the crypto node to the NPE binding.
> - Move the example over to the NPE binding where it appears
>   in context.
> ---
>  .../bindings/crypto/intel,ixp4xx-crypto.yaml  | 46 +++++++++++++++++++
>  ...ntel,ixp4xx-network-processing-engine.yaml | 13 +++++-
>  2 files changed, 58 insertions(+), 1 deletion(-)
>  create mode 100644 Documentation/devicetree/bindings/crypto/intel,ixp4xx-crypto.yaml
> 
> diff --git a/Documentation/devicetree/bindings/crypto/intel,ixp4xx-crypto.yaml b/Documentation/devicetree/bindings/crypto/intel,ixp4xx-crypto.yaml
> new file mode 100644
> index 000000000000..79e9d23be1f4
> --- /dev/null
> +++ b/Documentation/devicetree/bindings/crypto/intel,ixp4xx-crypto.yaml
> @@ -0,0 +1,46 @@
> +# SPDX-License-Identifier: (GPL-2.0 OR BSD-2-Clause)
> +# Copyright 2018 Linaro Ltd.
> +%YAML 1.2
> +---
> +$id: "http://devicetree.org/schemas/crypto/intel,ixp4xx-crypto.yaml#"
> +$schema: "http://devicetree.org/meta-schemas/core.yaml#"
> +
> +title: Intel IXP4xx cryptographic engine
> +
> +maintainers:
> +  - Linus Walleij <linus.walleij@linaro.org>
> +
> +description: |
> +  The Intel IXP4xx cryptographic engine makes use of the IXP4xx NPE
> +  (Network Processing Engine). Since it is not a device on its own
> +  it is defined as a subnode of the NPE, if crypto support is
> +  available on the platform.
> +
> +properties:
> +  compatible:
> +    const: intel,ixp4xx-crypto
> +
> +  intel,npe:
> +    $ref: /schemas/types.yaml#/definitions/uint32
> +    minimum: 0
> +    maximum: 3
> +    description: phandle to the NPE this ethernet instance is using

Not a phandle now.

> +      and the instance to use in the second cell

Maybe 'reg' works here? You can only have 1 thing you address though if 
you use reg here.

How are other NPE instances used? Are you going to need to have a 
reference to them?

> +
> +  queue-rx:
> +    $ref: /schemas/types.yaml#/definitions/phandle-array
> +    maxItems: 1
> +    description: phandle to the RX queue on the NPE

Plus a cell value. What's it for?

> +
> +  queue-txready:
> +    $ref: /schemas/types.yaml#/definitions/phandle-array
> +    maxItems: 1
> +    description: phandle to the TX READY queue on the NPE

And here.

> +
> +required:
> +  - compatible
> +  - intel,npe
> +  - queue-rx
> +  - queue-txready
> +
> +additionalProperties: false
> diff --git a/Documentation/devicetree/bindings/firmware/intel,ixp4xx-network-processing-engine.yaml b/Documentation/devicetree/bindings/firmware/intel,ixp4xx-network-processing-engine.yaml
> index 1bd2870c3a9c..add46ae6c461 100644
> --- a/Documentation/devicetree/bindings/firmware/intel,ixp4xx-network-processing-engine.yaml
> +++ b/Documentation/devicetree/bindings/firmware/intel,ixp4xx-network-processing-engine.yaml
> @@ -30,6 +30,10 @@ properties:
>        - description: NPE1 register range
>        - description: NPE2 register range
>  
> +  crypto:
> +    type: object
> +    description: optional node for the embedded crypto engine

$ref: /schemas/crypto/intel,ixp4xx-crypto.yaml#

> +
>  required:
>    - compatible
>    - reg
> @@ -38,8 +42,15 @@ additionalProperties: false
>  
>  examples:
>    - |
> -    npe@c8006000 {
> +    npe: npe@c8006000 {
>           compatible = "intel,ixp4xx-network-processing-engine";
>           reg = <0xc8006000 0x1000>, <0xc8007000 0x1000>, <0xc8008000 0x1000>;
> +
> +         crypto {
> +             compatible = "intel,ixp4xx-crypto";
> +             intel,npe = <2>;
> +             queue-rx = <&qmgr 30>;
> +             queue-txready = <&qmgr 29>;
> +         };
>      };
>  ...
> -- 
> 2.31.1
> 
