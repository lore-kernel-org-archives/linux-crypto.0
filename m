Return-Path: <SRS0=GLFy=62=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.5 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_SANE_1 autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A2B77C54E8D
	for <linux-crypto@archiver.kernel.org>; Tue, 12 May 2020 04:47:15 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 7C7C12072B
	for <linux-crypto@archiver.kernel.org>; Tue, 12 May 2020 04:47:15 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=ti.com header.i=@ti.com header.b="UW+7t1lQ"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725816AbgELErO (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Tue, 12 May 2020 00:47:14 -0400
Received: from lelv0142.ext.ti.com ([198.47.23.249]:50348 "EHLO
        lelv0142.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725814AbgELErO (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 12 May 2020 00:47:14 -0400
Received: from lelv0265.itg.ti.com ([10.180.67.224])
        by lelv0142.ext.ti.com (8.15.2/8.15.2) with ESMTP id 04C4l64K097041;
        Mon, 11 May 2020 23:47:06 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ti.com;
        s=ti-com-17Q1; t=1589258826;
        bh=F2po6cA8J2YoKFQUHOGkUFydfctsX1xseR/bWF+m5+k=;
        h=Subject:To:CC:References:From:Date:In-Reply-To;
        b=UW+7t1lQMZmzsTZ/Rg2C8DGHJkg9uCRI3zwSxB4mSbIpavbbpJXXX3R6Ny6ETM8lf
         qhcpaKhQb9X+k0a5gXAxh3wY8fy/98Pdg7AaHuTID3p5bZPomCQ+eFafCJBahNV6X8
         o2DJXs8DcAmuGNxjJy7X7557i8HyQBWZjl4TXltw=
Received: from DLEE102.ent.ti.com (dlee102.ent.ti.com [157.170.170.32])
        by lelv0265.itg.ti.com (8.15.2/8.15.2) with ESMTPS id 04C4l5rU082372
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=FAIL);
        Mon, 11 May 2020 23:47:05 -0500
Received: from DLEE111.ent.ti.com (157.170.170.22) by DLEE102.ent.ti.com
 (157.170.170.32) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.1979.3; Mon, 11
 May 2020 23:47:05 -0500
Received: from lelv0326.itg.ti.com (10.180.67.84) by DLEE111.ent.ti.com
 (157.170.170.22) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.1979.3 via
 Frontend Transport; Mon, 11 May 2020 23:47:05 -0500
Received: from [127.0.0.1] (ileax41-snat.itg.ti.com [10.172.224.153])
        by lelv0326.itg.ti.com (8.15.2/8.15.2) with ESMTP id 04C4l2YK121221;
        Mon, 11 May 2020 23:47:04 -0500
Subject: Re: [PATCHv2 1/7] dt-bindings: crypto: Add TI SA2UL crypto
 accelerator documentation
To:     Rob Herring <robh@kernel.org>
CC:     <herbert@gondor.apana.org.au>, <davem@davemloft.net>,
        <linux-crypto@vger.kernel.org>, Keerthy <j-keerthy@ti.com>,
        <devicetree@vger.kernel.org>
References: <20200424164430.3288-1-t-kristo@ti.com>
 <20200424164430.3288-2-t-kristo@ti.com> <20200511215343.GA10123@bogus>
From:   Tero Kristo <t-kristo@ti.com>
Message-ID: <53c7c7db-9357-c2fa-c792-64261489d32c@ti.com>
Date:   Tue, 12 May 2020 07:47:02 +0300
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.4.1
MIME-Version: 1.0
In-Reply-To: <20200511215343.GA10123@bogus>
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-EXCLAIMER-MD-CONFIG: e1e8a2fd-e40a-4ac6-ac9b-f7e9cc9ee180
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On 12/05/2020 00:53, Rob Herring wrote:
> On Fri, Apr 24, 2020 at 07:44:24PM +0300, Tero Kristo wrote:
>> From: Keerthy <j-keerthy@ti.com>
>>
>> The Security Accelerator Ultra Lite (SA2UL) subsystem provides hardware
>> cryptographic acceleration for the following use cases:
>>
>> * Encryption and authentication for secure boot
>> * Encryption and authentication of content in applications
>>    requiring DRM (digital rights management) and
>>    content/asset protection
>>
>> SA2UL provides support for number of different cryptographic algorithms
>> including SHA1, SHA256, SHA512, AES, 3DES, and various combinations of
>> the previous for AEAD use.
>>
>> Cc: Rob Herring <robh@kernel.org>
>> Cc: devicetree@vger.kernel.org
>> Signed-off-by: Keerthy <j-keerthy@ti.com>
>> [t-kristo@ti.com: converted documentation to yaml]
>> Signed-off-by: Tero Kristo <t-kristo@ti.com>
>> ---
>>   .../devicetree/bindings/crypto/ti,sa2ul.yaml  | 76 +++++++++++++++++++
>>   1 file changed, 76 insertions(+)
>>   create mode 100644 Documentation/devicetree/bindings/crypto/ti,sa2ul.yaml
>>
>> diff --git a/Documentation/devicetree/bindings/crypto/ti,sa2ul.yaml b/Documentation/devicetree/bindings/crypto/ti,sa2ul.yaml
>> new file mode 100644
>> index 000000000000..27bb3a7e2b87
>> --- /dev/null
>> +++ b/Documentation/devicetree/bindings/crypto/ti,sa2ul.yaml
>> @@ -0,0 +1,76 @@
>> +# SPDX-License-Identifier: (GPL-2.0-only or BSD-2-Clause)
>> +%YAML 1.2
>> +---
>> +$id: http://devicetree.org/schemas/crypto/ti,sa2ul.yaml#
>> +$schema: http://devicetree.org/meta-schemas/core.yaml#
>> +
>> +title: K3 SoC SA2UL crypto module
>> +
>> +maintainers:
>> +  - Tero Kristo <t-kristo@ti.com>
>> +
>> +properties:
>> +  compatible:
>> +    enum:
>> +      - ti,j721e-sa2ul
>> +      - ti,am654-sa2ul
>> +
>> +  reg:
>> +    maxItems: 1
>> +
>> +  power-domains:
>> +    maxItems: 1
>> +
>> +  dmas:
>> +    items:
>> +      - description: TX DMA Channel
>> +      - description: RX DMA Channel #1
>> +      - description: RX DMA Channel #2
>> +
>> +  dma-names:
>> +    items:
>> +      - const: tx
>> +      - const: rx1
>> +      - const: rx2
>> +
>> +  dma-coherent: true
>> +
>> +  "#address-cells":
>> +    const: 2
>> +
>> +  "#size-cells":
>> +    const: 2
>> +
>> +  ranges:
>> +    description:
>> +      Address translation for the possible RNG child node for SA2UL
>> +
>> +patternProperties:
>> +  "^rng@[a-lf0-9]+$":
> 
> a-l?

Ooops, thats a typo right here. Will fix that.

> 
>> +    type: object
>> +    description:
>> +      Child RNG node for SA2UL
> 
> Does this child node have a binding?

Yes, it is here:

Documentation/devicetree/bindings/rng/omap_rng.txt.

It is an old one so not converted to yaml yet though.

-Tero

> 
>> +
>> +required:
>> +  - compatible
>> +  - reg
>> +  - power-domains
>> +  - dmas
>> +  - dma-names
>> +  - dma-coherent
>> +
>> +additionalProperties: false
>> +
>> +examples:
>> +  - |
>> +    #include <dt-bindings/soc/ti,sci_pm_domain.h>
>> +
>> +    main_crypto: crypto@4e00000 {
>> +        compatible = "ti,j721-sa2ul";
>> +        reg = <0x0 0x4e00000 0x0 0x1200>;
>> +        power-domains = <&k3_pds 264 TI_SCI_PD_EXCLUSIVE>;
>> +        dmas = <&main_udmap 0xc000>, <&main_udmap 0x4000>,
>> +               <&main_udmap 0x4001>;
>> +        dma-names = "tx", "rx1", "rx2";
>> +        dma-coherent;
>> +    };
>> -- 
>> 2.17.1
>>
>> --

--
Texas Instruments Finland Oy, Porkkalankatu 22, 00180 Helsinki. Y-tunnus/Business ID: 0615521-4. Kotipaikka/Domicile: Helsinki
