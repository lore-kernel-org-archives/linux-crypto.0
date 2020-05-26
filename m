Return-Path: <SRS0=zQvQ=7I=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.4 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 839CCC433DF
	for <linux-crypto@archiver.kernel.org>; Tue, 26 May 2020 13:16:19 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 5AABF208A7
	for <linux-crypto@archiver.kernel.org>; Tue, 26 May 2020 13:16:19 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=ti.com header.i=@ti.com header.b="vAAQRH4G"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728930AbgEZNQS (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Tue, 26 May 2020 09:16:18 -0400
Received: from lelv0142.ext.ti.com ([198.47.23.249]:48124 "EHLO
        lelv0142.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727009AbgEZNQS (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 26 May 2020 09:16:18 -0400
Received: from fllv0035.itg.ti.com ([10.64.41.0])
        by lelv0142.ext.ti.com (8.15.2/8.15.2) with ESMTP id 04QDGDwJ006901;
        Tue, 26 May 2020 08:16:13 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ti.com;
        s=ti-com-17Q1; t=1590498973;
        bh=eqGhzMDtI1ZxYG/zUvjhuAYLtAp8+AxdQqxcet91B1E=;
        h=Subject:From:To:CC:References:Date:In-Reply-To;
        b=vAAQRH4G0xAWHCaDAE+NVGmezreS/rZUpFPZvcURf8eTHMldyguffUQSYspAkY5wi
         6GICLR/PQRHyB2Xtcv/PbxQrqWK2YwRUkfVcn8qeJzrIYix1QDO7LeKp2s+yy9lJ3Q
         jXvPPvmhUdg6fqfniNtlIyWxx6rGyVvlrKScvf+w=
Received: from DFLE104.ent.ti.com (dfle104.ent.ti.com [10.64.6.25])
        by fllv0035.itg.ti.com (8.15.2/8.15.2) with ESMTP id 04QDGDlq085703;
        Tue, 26 May 2020 08:16:13 -0500
Received: from DFLE108.ent.ti.com (10.64.6.29) by DFLE104.ent.ti.com
 (10.64.6.25) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.1979.3; Tue, 26
 May 2020 08:16:12 -0500
Received: from fllv0039.itg.ti.com (10.64.41.19) by DFLE108.ent.ti.com
 (10.64.6.29) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.1979.3 via
 Frontend Transport; Tue, 26 May 2020 08:16:12 -0500
Received: from [127.0.0.1] (ileax41-snat.itg.ti.com [10.172.224.153])
        by fllv0039.itg.ti.com (8.15.2/8.15.2) with ESMTP id 04QDG9rf128095;
        Tue, 26 May 2020 08:16:11 -0500
Subject: Re: [PATCHv3 1/7] dt-bindings: crypto: Add TI SA2UL crypto
 accelerator documentation
From:   Tero Kristo <t-kristo@ti.com>
To:     <herbert@gondor.apana.org.au>, <davem@davemloft.net>,
        <linux-crypto@vger.kernel.org>
CC:     Keerthy <j-keerthy@ti.com>, Rob Herring <robh@kernel.org>,
        <devicetree@vger.kernel.org>
References: <20200511215343.GA10123@bogus>
 <20200514125005.23641-1-t-kristo@ti.com>
Message-ID: <ca7e30a4-111c-71f9-42cd-45ff0c9f951d@ti.com>
Date:   Tue, 26 May 2020 16:16:08 +0300
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.4.1
MIME-Version: 1.0
In-Reply-To: <20200514125005.23641-1-t-kristo@ti.com>
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-EXCLAIMER-MD-CONFIG: e1e8a2fd-e40a-4ac6-ac9b-f7e9cc9ee180
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On 14/05/2020 15:50, Tero Kristo wrote:
> From: Keerthy <j-keerthy@ti.com>
> 
> The Security Accelerator Ultra Lite (SA2UL) subsystem provides hardware
> cryptographic acceleration for the following use cases:
> 
> * Encryption and authentication for secure boot
> * Encryption and authentication of content in applications
>    requiring DRM (digital rights management) and
>    content/asset protection
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
> v3:
>    - fixed a typo in rng child node regex

Rob, any comments on this one?

I did post the patch for converting omap-rng (the child node) to schema 
also.

-Tero

> 
>   .../devicetree/bindings/crypto/ti,sa2ul.yaml  | 76 +++++++++++++++++++
>   1 file changed, 76 insertions(+)
>   create mode 100644 Documentation/devicetree/bindings/crypto/ti,sa2ul.yaml
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
> +  "^rng@[a-f0-9]+$":
> +    type: object
> +    description:
> +      Child RNG node for SA2UL
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
> 

--
Texas Instruments Finland Oy, Porkkalankatu 22, 00180 Helsinki. Y-tunnus/Business ID: 0615521-4. Kotipaikka/Domicile: Helsinki
