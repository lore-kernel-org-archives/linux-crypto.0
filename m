Return-Path: <SRS0=vV99=6Z=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.8 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A0EE2C54E8D
	for <linux-crypto@archiver.kernel.org>; Mon, 11 May 2020 21:54:00 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 77E242075E
	for <linux-crypto@archiver.kernel.org>; Mon, 11 May 2020 21:54:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1589234040;
	bh=NybVwlbZAgihutmTRbk9zfGmqRkOobx2M2Ug4CviCbA=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:List-ID:From;
	b=JQAwQfqLKyOQ9sxFMLGXKEnGi1vxpOjzAtOX47ub15Oz9oVaD08OGZ2L0eiJlScmU
	 hVK9VQO1bEPwMggiVgyeU2opqr/XYbT8Lv5MdJUdJAcFKo8YrDaR1lofqX1djjzRbu
	 qnJgakzaWWAWrUDPMPHZkPWOGkQFXtXo83TX1B80=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725904AbgEKVx7 (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Mon, 11 May 2020 17:53:59 -0400
Received: from mail-oi1-f193.google.com ([209.85.167.193]:39870 "EHLO
        mail-oi1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725860AbgEKVx7 (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 11 May 2020 17:53:59 -0400
Received: by mail-oi1-f193.google.com with SMTP id b18so16488172oic.6;
        Mon, 11 May 2020 14:53:58 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=0ubMO0r62e5onOySJqGesT8p9B144ksRv5675Ou87bY=;
        b=Sdy9+dPhsO7BIn7P1zUyAGHyjZ5QSUXQktOC0zFz/w1xcqXp65LqzEIVmBT1qTRe3k
         pjYC8A4czZXbZeGjNkLyAwvv9D7/XTjAbb9LxbaCz6hzv3R55fsSfZsAbyj8BaJfn6lB
         IfPP6VzGMm15QddsG5ruWE2gygUk/8p4jkm+AFQufpouwPRIXiZHpURUHAgWXwYW5/81
         /x/KGGL0KOi2Xwc65MyrIAg4SwL28O/9S2pfaWB2VDHY29d9nxfJ4iUn0vcQvbSmUmRb
         +FurjC49yPAhl2e2rf5Cc/qX/koC3ZCkR2LjHpEUJx/oJ6CZ+WIIx3A6ZV8eKy+M7bU4
         +BGA==
X-Gm-Message-State: AGi0PuYXo9yXXC5VYBjQV219dycFObJGqApJaX3O0y+qone1aDmwKaLi
        bQ+GfQSdipgRQKx4Cc8k7A==
X-Google-Smtp-Source: APiQypKTWYog9AvtQJGmnBIzegGaPpE9c3rLxOtAgfNAuYpid5nsuXMu9KfWZd9qeFqn0mDIYG0vlg==
X-Received: by 2002:aca:d585:: with SMTP id m127mr21345315oig.27.1589234038378;
        Mon, 11 May 2020 14:53:58 -0700 (PDT)
Received: from rob-hp-laptop (24-155-109-49.dyn.grandenetworks.net. [24.155.109.49])
        by smtp.gmail.com with ESMTPSA id s69sm2974728otb.4.2020.05.11.14.53.44
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 11 May 2020 14:53:45 -0700 (PDT)
Received: (nullmailer pid 13339 invoked by uid 1000);
        Mon, 11 May 2020 21:53:43 -0000
Date:   Mon, 11 May 2020 16:53:43 -0500
From:   Rob Herring <robh@kernel.org>
To:     Tero Kristo <t-kristo@ti.com>
Cc:     herbert@gondor.apana.org.au, davem@davemloft.net,
        linux-crypto@vger.kernel.org, Keerthy <j-keerthy@ti.com>,
        devicetree@vger.kernel.org
Subject: Re: [PATCHv2 1/7] dt-bindings: crypto: Add TI SA2UL crypto
 accelerator documentation
Message-ID: <20200511215343.GA10123@bogus>
References: <20200424164430.3288-1-t-kristo@ti.com>
 <20200424164430.3288-2-t-kristo@ti.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200424164430.3288-2-t-kristo@ti.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Fri, Apr 24, 2020 at 07:44:24PM +0300, Tero Kristo wrote:
> From: Keerthy <j-keerthy@ti.com>
> 
> The Security Accelerator Ultra Lite (SA2UL) subsystem provides hardware
> cryptographic acceleration for the following use cases:
> 
> * Encryption and authentication for secure boot
> * Encryption and authentication of content in applications
>   requiring DRM (digital rights management) and
>   content/asset protection
> 
> SA2UL provides support for number of different cryptographic algorithms
> including SHA1, SHA256, SHA512, AES, 3DES, and various combinations of
> the previous for AEAD use.
> 
> Cc: Rob Herring <robh@kernel.org>
> Cc: devicetree@vger.kernel.org
> Signed-off-by: Keerthy <j-keerthy@ti.com>
> [t-kristo@ti.com: converted documentation to yaml]
> Signed-off-by: Tero Kristo <t-kristo@ti.com>
> ---
>  .../devicetree/bindings/crypto/ti,sa2ul.yaml  | 76 +++++++++++++++++++
>  1 file changed, 76 insertions(+)
>  create mode 100644 Documentation/devicetree/bindings/crypto/ti,sa2ul.yaml
> 
> diff --git a/Documentation/devicetree/bindings/crypto/ti,sa2ul.yaml b/Documentation/devicetree/bindings/crypto/ti,sa2ul.yaml
> new file mode 100644
> index 000000000000..27bb3a7e2b87
> --- /dev/null
> +++ b/Documentation/devicetree/bindings/crypto/ti,sa2ul.yaml
> @@ -0,0 +1,76 @@
> +# SPDX-License-Identifier: (GPL-2.0-only or BSD-2-Clause)
> +%YAML 1.2
> +---
> +$id: http://devicetree.org/schemas/crypto/ti,sa2ul.yaml#
> +$schema: http://devicetree.org/meta-schemas/core.yaml#
> +
> +title: K3 SoC SA2UL crypto module
> +
> +maintainers:
> +  - Tero Kristo <t-kristo@ti.com>
> +
> +properties:
> +  compatible:
> +    enum:
> +      - ti,j721e-sa2ul
> +      - ti,am654-sa2ul
> +
> +  reg:
> +    maxItems: 1
> +
> +  power-domains:
> +    maxItems: 1
> +
> +  dmas:
> +    items:
> +      - description: TX DMA Channel
> +      - description: RX DMA Channel #1
> +      - description: RX DMA Channel #2
> +
> +  dma-names:
> +    items:
> +      - const: tx
> +      - const: rx1
> +      - const: rx2
> +
> +  dma-coherent: true
> +
> +  "#address-cells":
> +    const: 2
> +
> +  "#size-cells":
> +    const: 2
> +
> +  ranges:
> +    description:
> +      Address translation for the possible RNG child node for SA2UL
> +
> +patternProperties:
> +  "^rng@[a-lf0-9]+$":

a-l?

> +    type: object
> +    description:
> +      Child RNG node for SA2UL

Does this child node have a binding?

> +
> +required:
> +  - compatible
> +  - reg
> +  - power-domains
> +  - dmas
> +  - dma-names
> +  - dma-coherent
> +
> +additionalProperties: false
> +
> +examples:
> +  - |
> +    #include <dt-bindings/soc/ti,sci_pm_domain.h>
> +
> +    main_crypto: crypto@4e00000 {
> +        compatible = "ti,j721-sa2ul";
> +        reg = <0x0 0x4e00000 0x0 0x1200>;
> +        power-domains = <&k3_pds 264 TI_SCI_PD_EXCLUSIVE>;
> +        dmas = <&main_udmap 0xc000>, <&main_udmap 0x4000>,
> +               <&main_udmap 0x4001>;
> +        dma-names = "tx", "rx1", "rx2";
> +        dma-coherent;
> +    };
> -- 
> 2.17.1
> 
> --
> Texas Instruments Finland Oy, Porkkalankatu 22, 00180 Helsinki. Y-tunnus/Business ID: 0615521-4. Kotipaikka/Domicile: Helsinki
