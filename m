Return-Path: <SRS0=A9yi=EB=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.1 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 27090C55178
	for <linux-crypto@archiver.kernel.org>; Mon, 26 Oct 2020 13:17:29 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id E2BE322281
	for <linux-crypto@archiver.kernel.org>; Mon, 26 Oct 2020 13:17:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1603718248;
	bh=F/NyPkO4hTtNuNAcqwc4Ps9khbFBHHuUCIJhMxFVf0Q=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:List-ID:From;
	b=fcKPkfOkSereazzjPVEsU5lwvvpp8K5dlp7yDt27cIUye6Ll3lf7dffdqOUVyHT6c
	 vrTDXRJAvid0Rk/eN/cGwsQr28+G4Vf7fzQuxhrkOT6HaC6/7NlqpWpbNu77DEUnG4
	 LYXPU2JgNkLvyxWM0vhqptqw0OpHyV9vt18ZZaLU=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1774669AbgJZNR2 (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Mon, 26 Oct 2020 09:17:28 -0400
Received: from mail-ot1-f65.google.com ([209.85.210.65]:41168 "EHLO
        mail-ot1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1774652AbgJZNR1 (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 26 Oct 2020 09:17:27 -0400
Received: by mail-ot1-f65.google.com with SMTP id n15so7907494otl.8;
        Mon, 26 Oct 2020 06:17:25 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=q7bno1h46Vp/ABrcszACFHvC0m971ZjamxzKz5T7W8w=;
        b=n1HwqRp+vo35bGxx7a6HVxYu3d+6zD13jEB3J5xjI7nZFgC4X5n1iMLTHXb0gtdvNb
         /qTmEvVNm9AduScWTEcle1BzxI3lxAX1VLKOxa8/wm4Ov/H+B3D77geDHWliknAP2SL9
         dJV0nDwwA4qNbHRmHJScH/KoMN4orKtH+hWyLfGxJhoVFNQSvkrrzl3FzvC6mJHJkqzK
         yhwJSfZe2oYlQzb9QMhZwf+49CCcL6W3ohOTeyOwuJXWeQOl5Fv+OpT0Ca+fp57KSY6l
         I2dWUls3IHRQaRDa1UAqN8hcQaaIYFPZb7gyxVkD1nsot6vKAHUdyxmoWE8vblugqmhY
         SCQw==
X-Gm-Message-State: AOAM530OYSliE18n3DyzbTvFcfliy6fq0XR6Q8FU6ZCJEEjVwgeqnsGd
        J3BWoO1QoGVH0CxfNK54+w==
X-Google-Smtp-Source: ABdhPJy4sN2qYbTXX3u6wZrTXdNWO1mBD6AqzSOtNDudrry5jbCo/+zVNTMEV3bESDuJ2TmoBvLPvQ==
X-Received: by 2002:a05:6830:1347:: with SMTP id r7mr15232920otq.203.1603718245058;
        Mon, 26 Oct 2020 06:17:25 -0700 (PDT)
Received: from xps15 (24-155-109-49.dyn.grandenetworks.net. [24.155.109.49])
        by smtp.gmail.com with ESMTPSA id v17sm3486344ote.40.2020.10.26.06.17.24
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 26 Oct 2020 06:17:24 -0700 (PDT)
Received: (nullmailer pid 15580 invoked by uid 1000);
        Mon, 26 Oct 2020 13:17:23 -0000
Date:   Mon, 26 Oct 2020 08:17:23 -0500
From:   Rob Herring <robh@kernel.org>
To:     Daniele Alessandrelli <daniele.alessandrelli@linux.intel.com>
Cc:     Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>,
        linux-crypto@vger.kernel.org, devicetree@vger.kernel.org,
        Mark Gross <mgross@linux.intel.com>,
        Declan Murphy <declan.murphy@intel.com>,
        Daniele Alessandrelli <daniele.alessandrelli@intel.com>
Subject: Re: [PATCH 1/3] dt-bindings: crypto: Add Keem Bay OCS HCU bindings
Message-ID: <20201026131723.GA11033@bogus>
References: <20201016172759.1260407-1-daniele.alessandrelli@linux.intel.com>
 <20201016172759.1260407-2-daniele.alessandrelli@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201016172759.1260407-2-daniele.alessandrelli@linux.intel.com>
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Fri, Oct 16, 2020 at 06:27:57PM +0100, Daniele Alessandrelli wrote:
> From: Declan Murphy <declan.murphy@intel.com>
> 
> Add device-tree bindings for the Intel Keem Bay Offload Crypto Subsystem
> (OCS) Hashing Control Unit (HCU) crypto driver.
> 
> Signed-off-by: Declan Murphy <declan.murphy@intel.com>
> Signed-off-by: Daniele Alessandrelli <daniele.alessandrelli@intel.com>
> Acked-by: Mark Gross <mgross@linux.intel.com>
> ---
>  .../crypto/intel,keembay-ocs-hcu.yaml         | 52 +++++++++++++++++++
>  1 file changed, 52 insertions(+)
>  create mode 100644 Documentation/devicetree/bindings/crypto/intel,keembay-ocs-hcu.yaml
> 
> diff --git a/Documentation/devicetree/bindings/crypto/intel,keembay-ocs-hcu.yaml b/Documentation/devicetree/bindings/crypto/intel,keembay-ocs-hcu.yaml
> new file mode 100644
> index 000000000000..dd4b82ee872b
> --- /dev/null
> +++ b/Documentation/devicetree/bindings/crypto/intel,keembay-ocs-hcu.yaml
> @@ -0,0 +1,52 @@
> +# SPDX-License-Identifier: (GPL-2.0-only OR BSD-2-Clause)
> +%YAML 1.2
> +---
> +$id: http://devicetree.org/schemas/crypto/intel,keembay-ocs-hcu.yaml#
> +$schema: http://devicetree.org/meta-schemas/core.yaml#
> +
> +title: Intel Keem Bay OCS HCU Device Tree Bindings
> +
> +maintainers:
> +  - Declan Murphy <declan.murphy@intel.com>
> +  - Daniele Alessandrelli <deniele.alessandrelli@intel.com>

typo:                          ^?

> +
> +description: |

Can drop '|' if there's no formatting to preserve.

> +  The Intel Keem Bay Offload and Crypto Subsystem (OCS) Hash Control Unit (HCU)
> +  crypto driver enables use of the hardware accelerated hashing module embedded
> +  in the Intel Movidius SoC code name Keem Bay, via the kernel crypto API.

Don't put Linux details in bindings. Describe the h/w, not a driver.

> +
> +properties:
> +  compatible:
> +    const: intel,keembay-ocs-hcu
> +
> +  reg:
> +    items:
> +      - description: The OCS HCU base register address
> +
> +  interrupts:
> +    items:
> +      - description: OCS HCU interrupt
> +
> +  clocks:
> +    items:
> +      - description: OCS clock
> +
> +required:
> +  - compatible
> +  - reg
> +  - interrupts
> +  - clocks
> +
> +additionalProperties: false
> +
> +examples:
> +  - |
> +    #include <dt-bindings/interrupt-controller/arm-gic.h>
> +    hcu@3000b000 {

crypto@...

> +      compatible = "intel,keembay-ocs-hcu";
> +      reg = <0x3000b000 0x1000>;
> +      interrupts = <GIC_SPI 121 IRQ_TYPE_LEVEL_HIGH>;
> +      clocks = <&scmi_clk 94>;
> +    };
> +
> +...
> -- 
> 2.26.2
> 
