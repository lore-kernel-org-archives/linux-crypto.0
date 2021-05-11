Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.7 required=3.0 tests=BAYES_00,DATE_IN_PAST_24_48,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 68E36C4363F
	for <linux-crypto@archiver.kernel.org>; Wed, 12 May 2021 21:08:11 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 430C86143A
	for <linux-crypto@archiver.kernel.org>; Wed, 12 May 2021 21:08:11 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243238AbhELVII (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Wed, 12 May 2021 17:08:08 -0400
Received: from mail-oo1-f46.google.com ([209.85.161.46]:34510 "EHLO
        mail-oo1-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1385221AbhELUHV (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 12 May 2021 16:07:21 -0400
Received: by mail-oo1-f46.google.com with SMTP id i8-20020a4aa1080000b0290201edd785e7so5222353ool.1;
        Wed, 12 May 2021 13:06:12 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=jo6Dz46BspHZ5QKYcvfVJgbPf+bpiO7/FDHcJz0o1TI=;
        b=uXtOda6Qec9S90mCBHObhMdMpTp6fURNfmMK5WKDhJLp68KqDRy+X2SfcxN5OkccrA
         mXhFlrlKFb0HHfq6JxbQUzG0PehhANpB0l/k9rIV4n5fyXA980WFQ4lvZazyFZCmiM6H
         ngEo+ndBb/B44RoJhKHg7EnN/WPPeLvJ/LPRvszizHmvy5E5EpTjAadfCJYv2MfpsP3Z
         +fj0gKxuUfSL7H/G3wUFRblzigD8EutH+SuwLDRQ0uRHQNC8TIgn/c0oDzK/fb/XT6kC
         GLxEbUlxRTWEAghtZHDLTcAFkKF9NdukvZ9nmd+4DonLc+cpeZvPy9/cO6QlH2a++M6P
         9SzA==
X-Gm-Message-State: AOAM533o5ktTp4tHcBF4hUaVjY1QBiNc8Qeb0pvOyZN4fsVexmTO4JfH
        90csMkwTrikd1To632/lGg==
X-Google-Smtp-Source: ABdhPJxDFSQVxLClkJTg+b6TFZAy9l8JrP9W5GwVfM62sQew6UGxQEpVQ1d+msGrVdPqxIQ5m7el5A==
X-Received: by 2002:a4a:a3c3:: with SMTP id t3mr18346160ool.50.1620849972488;
        Wed, 12 May 2021 13:06:12 -0700 (PDT)
Received: from robh.at.kernel.org (24-155-109-49.dyn.grandenetworks.net. [24.155.109.49])
        by smtp.gmail.com with ESMTPSA id r10sm192474oic.4.2021.05.12.13.06.11
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 12 May 2021 13:06:11 -0700 (PDT)
Received: (nullmailer pid 2214054 invoked by uid 1000);
        Tue, 11 May 2021 16:16:48 -0000
Date:   Tue, 11 May 2021 11:16:48 -0500
From:   Rob Herring <robh@kernel.org>
To:     Linus Walleij <linus.walleij@linaro.org>
Cc:     linux-crypto@vger.kernel.org,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "David S . Miller" <davem@davemloft.net>,
        linux-arm-kernel@lists.infradead.org,
        Imre Kaloz <kaloz@openwrt.org>,
        Krzysztof Halasa <khalasa@piap.pl>,
        Arnd Bergmann <arnd@arndb.de>, devicetree@vger.kernel.org
Subject: Re: [PATCH 2/3] crypto: ixp4xx: Add DT bindings
Message-ID: <20210511161648.GA2209918@robh.at.kernel.org>
References: <20210510213634.600866-1-linus.walleij@linaro.org>
 <20210510213634.600866-2-linus.walleij@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210510213634.600866-2-linus.walleij@linaro.org>
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Mon, May 10, 2021 at 11:36:33PM +0200, Linus Walleij wrote:
> This adds device tree bindings for the ixp4xx crypto engine.
> 
> Cc: devicetree@vger.kernel.org
> Signed-off-by: Linus Walleij <linus.walleij@linaro.org>
> ---
> Herbert, David: This can be applied separately once we are
> happy with the bindings, alternatively it can be merged
> with the support code into ARM SoC.
> ---
>  .../bindings/crypto/intel,ixp4xx-crypto.yaml  | 59 +++++++++++++++++++
>  1 file changed, 59 insertions(+)
>  create mode 100644 Documentation/devicetree/bindings/crypto/intel,ixp4xx-crypto.yaml
> 
> diff --git a/Documentation/devicetree/bindings/crypto/intel,ixp4xx-crypto.yaml b/Documentation/devicetree/bindings/crypto/intel,ixp4xx-crypto.yaml
> new file mode 100644
> index 000000000000..28d75f4f9a76
> --- /dev/null
> +++ b/Documentation/devicetree/bindings/crypto/intel,ixp4xx-crypto.yaml
> @@ -0,0 +1,59 @@
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
> +  intel,npe-handle:
> +    $ref: '/schemas/types.yaml#/definitions/phandle-array'
> +    maxItems: 1
> +    description: phandle to the NPE this ethernet instance is using
> +      and the instance to use in the second cell
> +
> +  queue-rx:
> +    $ref: '/schemas/types.yaml#/definitions/phandle-array'
> +    maxItems: 1
> +    description: phandle to the RX queue on the NPE
> +
> +  queue-txready:
> +    $ref: '/schemas/types.yaml#/definitions/phandle-array'
> +    maxItems: 1
> +    description: phandle to the TX READY queue on the NPE
> +
> +required:
> +  - compatible
> +  - intel,npe-handle
> +  - queue-rx
> +  - queue-txready
> +
> +additionalProperties: false
> +
> +examples:
> +  - |
> +    npe: npe@c8006000 {
> +         compatible = "intel,ixp4xx-network-processing-engine";
> +         reg = <0xc8006000 0x1000>, <0xc8007000 0x1000>, <0xc8008000 0x1000>;
> +
> +         crypto {

The parent schema needs to define 'crypto' and have a ref to this 
schema. I'd put the example there rather than piecemeal.

> +             compatible = "intel,ixp4xx-crypto";
> +             intel,npe-handle = <&npe 2>;

A bit redundant to have a phandle to the parent.

> +             queue-rx = <&qmgr 30>;
> +             queue-txready = <&qmgr 29>;
> +         };
> +    };
> -- 
> 2.30.2
> 
