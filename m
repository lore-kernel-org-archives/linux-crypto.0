Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-14.0 required=3.0 tests=BAYES_00,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2F46EC433EF
	for <linux-crypto@archiver.kernel.org>; Tue, 21 Sep 2021 23:31:05 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 17F1B61242
	for <linux-crypto@archiver.kernel.org>; Tue, 21 Sep 2021 23:31:05 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230227AbhIUXcc (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Tue, 21 Sep 2021 19:32:32 -0400
Received: from mail-oi1-f171.google.com ([209.85.167.171]:37676 "EHLO
        mail-oi1-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230233AbhIUXcc (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 21 Sep 2021 19:32:32 -0400
Received: by mail-oi1-f171.google.com with SMTP id w206so1672576oiw.4;
        Tue, 21 Sep 2021 16:31:03 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=91XjStUm9Mm7b+X7wWYnPdiNJWHmz77cGzi9d45AgQ4=;
        b=1Qme9P/HFjqzEBthG1iSsPJUdr5sk13kwg9Rl7yLjuyv3IsC/nNGeKxe5WLnanyuxw
         SVIXErYfVqxSEjAMvRw3DR1qzQheaa6AR5zu9g1GFlfD83gSdgpjfyDAIYpWAkUwuexO
         k8jv2+Zl6ai2KGAvOckJVT2TzQH/VF6SxROFjWgB84alDZsxsZt5xxQXIFPEa82ya9sM
         uTvVkEEPynZCRzmc9WlaQwtia1NfMjtL6pJJU8WkGTvGWpzuh1Xw3jKCo0TWO1ClPR0K
         5koYeKtX/28M5G5RYu4dG/U6mE7lrT0vZGhXZ4QZpQnwW2ntkSQFYemT3L8NUqwvTddx
         UfMQ==
X-Gm-Message-State: AOAM531Nid/k8tNqzY63ZSYf3HDoZuiM6kpH5UWh+plTFkh2an5an0zU
        PhGl3hy+OjOfgJRqrIDcqRs8PZJj/A==
X-Google-Smtp-Source: ABdhPJwi51R0O2WHxOG1+y7tiXHZwEPtrB0Wn4R5YqLt7MlciaKdW4ovO/cXJhdK8Q3qEq2T82QjoA==
X-Received: by 2002:aca:2318:: with SMTP id e24mr5910510oie.173.1632267062982;
        Tue, 21 Sep 2021 16:31:02 -0700 (PDT)
Received: from robh.at.kernel.org (66-90-148-213.dyn.grandenetworks.net. [66.90.148.213])
        by smtp.gmail.com with ESMTPSA id w14sm110894oth.5.2021.09.21.16.31.01
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 21 Sep 2021 16:31:02 -0700 (PDT)
Received: (nullmailer pid 3493875 invoked by uid 1000);
        Tue, 21 Sep 2021 23:31:01 -0000
Date:   Tue, 21 Sep 2021 18:31:01 -0500
From:   Rob Herring <robh@kernel.org>
To:     Jayesh Choudhary <j-choudhary@ti.com>
Cc:     devicetree@vger.kernel.org, mpm@selenic.com,
        herbert@gondor.apana.org.au, linux-crypto@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] dt-bindings: rng: convert OMAP and Inside-Secure HWRNG
 to yaml schema
Message-ID: <YUprNTzmTdZJOCLY@robh.at.kernel.org>
References: <20210916185352.7919-1-j-choudhary@ti.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210916185352.7919-1-j-choudhary@ti.com>
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Fri, Sep 17, 2021 at 12:23:52AM +0530, Jayesh Choudhary wrote:
> Converts the RNG bindings for OMAP SoCs and Inside-Secure
> HWRNG modules to YAML schema.
> 
> Signed-off-by: Jayesh Choudhary <j-choudhary@ti.com>
> ---
>  .../devicetree/bindings/rng/omap_rng.txt      | 38 --------
>  .../devicetree/bindings/rng/omap_rng.yaml     | 94 +++++++++++++++++++
>  2 files changed, 94 insertions(+), 38 deletions(-)
>  delete mode 100644 Documentation/devicetree/bindings/rng/omap_rng.txt
>  create mode 100644 Documentation/devicetree/bindings/rng/omap_rng.yaml
> 
> diff --git a/Documentation/devicetree/bindings/rng/omap_rng.txt b/Documentation/devicetree/bindings/rng/omap_rng.txt
> deleted file mode 100644
> index ea434ce50f36..000000000000
> --- a/Documentation/devicetree/bindings/rng/omap_rng.txt
> +++ /dev/null
> @@ -1,38 +0,0 @@
> -OMAP SoC and Inside-Secure HWRNG Module
> -
> -Required properties:
> -
> -- compatible : Should contain entries for this and backward compatible
> -  RNG versions:
> -  - "ti,omap2-rng" for OMAP2.
> -  - "ti,omap4-rng" for OMAP4, OMAP5 and AM33XX.
> -  - "inside-secure,safexcel-eip76" for SoCs with EIP76 IP block
> -  Note that these two versions are incompatible.
> -- ti,hwmods: Name of the hwmod associated with the RNG module
> -- reg : Offset and length of the register set for the module
> -- interrupts : the interrupt number for the RNG module.
> -		Used for "ti,omap4-rng" and "inside-secure,safexcel-eip76"
> -- clocks: the trng clock source. Only mandatory for the
> -  "inside-secure,safexcel-eip76" compatible, the second clock is
> -  needed for the Armada 7K/8K SoCs
> -- clock-names: mandatory if there is a second clock, in this case the
> -  name must be "core" for the first clock and "reg" for the second
> -  one
> -
> -
> -Example:
> -/* AM335x */
> -rng: rng@48310000 {
> -	compatible = "ti,omap4-rng";
> -	ti,hwmods = "rng";
> -	reg = <0x48310000 0x2000>;
> -	interrupts = <111>;
> -};
> -
> -/* SafeXcel IP-76 */
> -trng: rng@f2760000 {
> -	compatible = "inside-secure,safexcel-eip76";
> -	reg = <0xf2760000 0x7d>;
> -	interrupts = <GIC_SPI 59 IRQ_TYPE_LEVEL_HIGH>;
> -	clocks = <&cpm_syscon0 1 25>;
> -};
> diff --git a/Documentation/devicetree/bindings/rng/omap_rng.yaml b/Documentation/devicetree/bindings/rng/omap_rng.yaml
> new file mode 100644
> index 000000000000..86bbc2c53e7d
> --- /dev/null
> +++ b/Documentation/devicetree/bindings/rng/omap_rng.yaml
> @@ -0,0 +1,94 @@
> +# SPDX-License-Identifier: (GPL-2.0+ OR BSD-2-Clause)

GPL-2.0-only OR BSD-2-Clause

> +%YAML 1.2
> +---
> +$id: http://devicetree.org/schemas/rng/omap_rng.yaml#
> +$schema: http://devicetree.org/meta-schemas/core.yaml#
> +
> +title: OMAP SoC and Inside-Secure HWRNG Module
> +
> +maintainers:
> +  - Jayesh Choudhary <j-choudhary@ti.com>
> +
> +properties:
> +  compatible:
> +    enum:
> +      - ti,omap2-rng
> +      - ti,omap4-rng
> +      - inside-secure,safexcel-eip76
> +
> +  ti,hwmods:
> +    const: rng
> +    deprecated: true
> +    description: Name of the hwmod associated with the RNG module
> +
> +  reg:
> +    maxItems: 1
> +
> +  interrupts:
> +    maxItems: 1
> +
> +  clocks:
> +    minItems: 1
> +    maxItems: 2
> +    items:
> +      - description: EIP150 gatable clock
> +      - description: Main gatable clock
> +
> +  clock-names:
> +    oneOf:
> +      - items:
> +          - const: core
> +          - const: reg
> +      - const: core

This is better expressed as:

minItems: 1
items:
  - const: core
  - const: reg

> +
> +
> +allOf:
> +  - if:
> +      properties:
> +        compatible:
> +          contains:
> +            enum:
> +              - ti,omap4-rng
> +              - inside-secure,safexcel-eip76
> +
> +    then:
> +      required:
> +        - interrupts
> +
> +  - if:
> +      properties:
> +        compatible:
> +          contains:
> +            enum:
> +              - inside-secure,safexcel-eip76
> +
> +    then:
> +      required:
> +        - clocks
> +
> +
> +required:
> +  - compatible
> +  - reg
> +
> +additionalProperties: false
> +
> +examples:
> +  - |
> +    /* AM335x */
> +    rng: rng@48310000 {
> +            compatible = "ti,omap4-rng";
> +            ti,hwmods = "rng";
> +            reg = <0x48310000 0x2000>;
> +            interrupts = <111>;
> +    };
> +  - |
> +    /* SafeXcel IP-76 */
> +    trng: rng@f2760000 {
> +            compatible = "inside-secure,safexcel-eip76";
> +            reg = <0xf2760000 0x7d>;
> +            interrupts = <0 59 4>;
> +            clocks = <&cpm_syscon0 1 25>;
> +    };
> +
> +...
> -- 
> 2.17.1
> 
> 
