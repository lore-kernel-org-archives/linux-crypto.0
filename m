Return-Path: <SRS0=sx3D=ZG=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.6 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 96592C43141
	for <linux-crypto@archiver.kernel.org>; Thu, 14 Nov 2019 18:27:36 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 713162071F
	for <linux-crypto@archiver.kernel.org>; Thu, 14 Nov 2019 18:27:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1573756056;
	bh=xJgVCsGCeJlqQIR9rutaR1puaE1j3XN4b41a8qZJfMM=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:List-ID:From;
	b=lR3pAoZgBEtyMIe40YQD4OWx4E34UXffHEFAxn5nUZMfibRTpCRWnMkQ8mMRdPZo/
	 89+wbnJMli3bKg+d5ekQrIY995zoYFqCAAsnDHruzRBFGJhJmhN4CnUg8O3vVwYZWE
	 4+frR8SE+dOmYNdgMx99bUKVxGhe8MuOBlZ74QS4=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726598AbfKNS1g (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 14 Nov 2019 13:27:36 -0500
Received: from mail-oi1-f194.google.com ([209.85.167.194]:38751 "EHLO
        mail-oi1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726528AbfKNS1f (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 14 Nov 2019 13:27:35 -0500
Received: by mail-oi1-f194.google.com with SMTP id a14so6190031oid.5;
        Thu, 14 Nov 2019 10:27:35 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=twe/TbVlMQqA0NWuHIJXSk1zCx0TbbBAWPGwk4fJz3k=;
        b=S2AG2Y9RbFfTkFJnJQ2RBTKFHy7sotBxLhYtwJ4ZnWuAIkceantdlYbzkNxUaE7sCQ
         tEmYkJY/LsvrKM3sohsm93Ba/ywjvh+DEB9nHLpI3CEvRWlBdI65w2I/HH9O4aU9QKdB
         iZ3c/nryT1V6o2lu7AowPe47CWYdocy0a4hMBKVhbWtmopw7pu4+GJb+S/fNt/xr7kJe
         AyKFdKWK8Jm0wnCSHl//xrNt70xkYzUQwd8s2EG0HfIdkbvI65QB5Aqit4J3PJfmJIpM
         2F4gJsnc9vIeiD2X4p498J0dDHb+Z1uESobE45FoVEWdYy2dlENsmSqeRR6FHZWYf1wJ
         fuqA==
X-Gm-Message-State: APjAAAW2nh/3HW92Al5e4Mjoffu/oG4bT9eY3fJX1FEwWCBuP+uKhXtD
        ap36mtAWw9Z5zJzFtXKgIQ==
X-Google-Smtp-Source: APXvYqxjHDltMccuMM6xqJnU+foScbYCONfgYx5qcm1q2S77o/X9u6AVwhK8Rqvkr5ZeEzckeIplDw==
X-Received: by 2002:a05:6808:352:: with SMTP id j18mr4809540oie.67.1573756054717;
        Thu, 14 Nov 2019 10:27:34 -0800 (PST)
Received: from localhost (24-155-109-49.dyn.grandenetworks.net. [24.155.109.49])
        by smtp.gmail.com with ESMTPSA id e19sm2020116otj.51.2019.11.14.10.27.33
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 14 Nov 2019 10:27:34 -0800 (PST)
Date:   Thu, 14 Nov 2019 12:27:33 -0600
From:   Rob Herring <robh@kernel.org>
To:     Benjamin Gaignard <benjamin.gaignard@st.com>
Cc:     herbert@gondor.apana.org.au, davem@davemloft.net,
        mark.rutland@arm.com, alexandre.torgue@st.com,
        lionel.debieve@st.com, linux-crypto@vger.kernel.org,
        devicetree@vger.kernel.org,
        linux-stm32@st-md-mailman.stormreply.com,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] dt-bindings: crypto: Convert stm32 HASH bindings to
 json-schema
Message-ID: <20191114182733.GA21785@bogus>
References: <20191108125244.23001-1-benjamin.gaignard@st.com>
 <20191108125244.23001-3-benjamin.gaignard@st.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191108125244.23001-3-benjamin.gaignard@st.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Fri, Nov 08, 2019 at 01:52:44PM +0100, Benjamin Gaignard wrote:
> Convert the STM32 HASH binding to DT schema format using json-schema
> 
> Signed-off-by: Benjamin Gaignard <benjamin.gaignard@st.com>
> ---
>  .../devicetree/bindings/crypto/st,stm32-hash.txt   | 30 ----------
>  .../devicetree/bindings/crypto/st,stm32-hash.yaml  | 64 ++++++++++++++++++++++
>  2 files changed, 64 insertions(+), 30 deletions(-)
>  delete mode 100644 Documentation/devicetree/bindings/crypto/st,stm32-hash.txt
>  create mode 100644 Documentation/devicetree/bindings/crypto/st,stm32-hash.yaml
> 
> diff --git a/Documentation/devicetree/bindings/crypto/st,stm32-hash.txt b/Documentation/devicetree/bindings/crypto/st,stm32-hash.txt
> deleted file mode 100644
> index 04fc246f02f7..000000000000
> --- a/Documentation/devicetree/bindings/crypto/st,stm32-hash.txt
> +++ /dev/null
> @@ -1,30 +0,0 @@
> -* STMicroelectronics STM32 HASH
> -
> -Required properties:
> -- compatible: Should contain entries for this and backward compatible
> -  HASH versions:
> -  - "st,stm32f456-hash" for stm32 F456.
> -  - "st,stm32f756-hash" for stm32 F756.
> -- reg: The address and length of the peripheral registers space
> -- interrupts: the interrupt specifier for the HASH
> -- clocks: The input clock of the HASH instance
> -
> -Optional properties:
> -- resets: The input reset of the HASH instance
> -- dmas: DMA specifiers for the HASH. See the DMA client binding,
> -	 Documentation/devicetree/bindings/dma/dma.txt
> -- dma-names: DMA request name. Should be "in" if a dma is present.
> -- dma-maxburst: Set number of maximum dma burst supported
> -
> -Example:
> -
> -hash1: hash@50060400 {
> -	compatible = "st,stm32f756-hash";
> -	reg = <0x50060400 0x400>;
> -	interrupts = <80>;
> -	clocks = <&rcc 0 STM32F7_AHB2_CLOCK(HASH)>;
> -	resets = <&rcc STM32F7_AHB2_RESET(HASH)>;
> -	dmas = <&dma2 7 2 0x400 0x0>;
> -	dma-names = "in";
> -	dma-maxburst = <0>;
> -};
> diff --git a/Documentation/devicetree/bindings/crypto/st,stm32-hash.yaml b/Documentation/devicetree/bindings/crypto/st,stm32-hash.yaml
> new file mode 100644
> index 000000000000..3c09c9899021
> --- /dev/null
> +++ b/Documentation/devicetree/bindings/crypto/st,stm32-hash.yaml
> @@ -0,0 +1,64 @@
> +# SPDX-License-Identifier: (GPL-2.0-only OR BSD-2-Clause)
> +%YAML 1.2
> +---
> +$id: http://devicetree.org/schemas/crypto/st,stm32-hash.yaml#
> +$schema: http://devicetree.org/meta-schemas/core.yaml#
> +
> +title: STMicroelectronics STM32 HASH bindings
> +
> +maintainers:
> +  - Lionel Debieve <lionel.debieve@st.com>
> +
> +properties:
> +  compatible:
> +    enum:
> +      - st,stm32f456-hash
> +      - st,stm32f756-hash
> +
> +  reg:
> +    maxItems: 1
> +
> +  clocks:
> +    maxItems: 1
> +
> +  interrupts:
> +    maxItems: 1
> +
> +  resets:
> +    maxItems: 1
> +
> +  dmas:
> +    maxItems: 1
> +
> +  dma-names:
> +    items:
> +      - const: in
> +
> +  dma-maxburst:
> +    description: Set number of maximum dma burst supported

Needs a type ref and some constraints. What's the default?

> +
> +required:
> +  - compatible
> +  - reg
> +  - clocks
> +  - interrupts
> +
> +additionalProperties: false
> +
> +examples:
> +  - |
> +    #include <dt-bindings/interrupt-controller/arm-gic.h>
> +    #include <dt-bindings/clock/stm32mp1-clks.h>
> +    #include <dt-bindings/reset/stm32mp1-resets.h>
> +    hash@54002000 {
> +      compatible = "st,stm32f756-hash";
> +      reg = <0x54002000 0x400>;
> +      interrupts = <GIC_SPI 80 IRQ_TYPE_LEVEL_HIGH>;
> +      clocks = <&rcc HASH1>;
> +      resets = <&rcc HASH1_R>;
> +      dmas = <&mdma1 31 0x10 0x1000A02 0x0 0x0>;
> +      dma-names = "in";
> +      dma-maxburst = <2>;
> +    };
> +
> +...
> -- 
> 2.15.0
> 
