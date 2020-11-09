Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.1 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0099AC4741F
	for <linux-crypto@archiver.kernel.org>; Mon,  9 Nov 2020 16:15:37 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id B082921D7F
	for <linux-crypto@archiver.kernel.org>; Mon,  9 Nov 2020 16:15:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1604938536;
	bh=flNF4HhVxU6I2Za0RrqFmPCiLvluW75dhZplbi2FG8Q=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:List-ID:From;
	b=b7fq+S23FYVkGgF+Uw9/3bkfMl9GgVpSWJk1kbpUzzLbxN3jRTOx5ohWGkKDQy4VH
	 vbfiO57v4VIHOddQnXUzA9+h3/cGEomcVA2ZxW8LO7YSRaCCVoLDkZevLLmTvMGGls
	 76Fl/C5wcxTv8z0t2Cqe1I+RDGRDeWMyozVeyg5g=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730119AbgKIQPf (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Mon, 9 Nov 2020 11:15:35 -0500
Received: from mail-ot1-f65.google.com ([209.85.210.65]:35964 "EHLO
        mail-ot1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730042AbgKIQPf (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 9 Nov 2020 11:15:35 -0500
Received: by mail-ot1-f65.google.com with SMTP id 32so9459654otm.3;
        Mon, 09 Nov 2020 08:15:34 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=dw1LoUSagFZvFxmHtKuli9nM6y3eYFUgBQWTpjd/9t0=;
        b=GT7IgtVKkVSklGfoqWqg2tGlS2R3OeZay6AO6X7sFYRVOS3HUZ09qV2S0S03RxMiug
         taWlB7OVKF3DUNr6YWMVb4irDAbVAzeuGFYYVKPpV9dB/hg7XRPH8LuONj1fSJkb9K21
         +kQ0VNUYGnRlfqY7C/semriO1f6cXg52sto93K2dl9GcK6/l6UOsOyoMAMahU/SQ0z+d
         mxv5OJEJavqL2/1E3+1uQ5TinDYrPZKMUbn4U4fzEA1Dqb21VX0hh5cXlROhBzIYjxEo
         sznFA6QVJxjz+tnxyBOHq4sBIH4JOgGwg0mZNWnvQbL2UhyRktZVZyYVG1ZF4cwAMeu7
         7uYA==
X-Gm-Message-State: AOAM530EAHSvz+Swyk8WFNF0/iY/4e2YuhvEp0UMZjpYBFUg18xqOLXp
        o6Fz+SzDFA5Qe6V3004LNbd+tERpyQ==
X-Google-Smtp-Source: ABdhPJy3kOFSoxW7kvlcW8rQkOhB46y1hPxnXX3WDV8eUVkFDiHyBR9NWxWHiR0YOTCLyNw12vGyyA==
X-Received: by 2002:a9d:bec:: with SMTP id 99mr11477689oth.103.1604938534032;
        Mon, 09 Nov 2020 08:15:34 -0800 (PST)
Received: from xps15 (24-155-109-49.dyn.grandenetworks.net. [24.155.109.49])
        by smtp.gmail.com with ESMTPSA id m3sm558145oim.36.2020.11.09.08.15.33
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 09 Nov 2020 08:15:33 -0800 (PST)
Received: (nullmailer pid 1384738 invoked by uid 1000);
        Mon, 09 Nov 2020 16:15:32 -0000
Date:   Mon, 9 Nov 2020 10:15:32 -0600
From:   Rob Herring <robh@kernel.org>
To:     Daniele Alessandrelli <daniele.alessandrelli@linux.intel.com>
Cc:     Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>,
        linux-crypto@vger.kernel.org, devicetree@vger.kernel.org,
        Mark Gross <mgross@linux.intel.com>,
        Declan Murphy <declan.murphy@intel.com>,
        Daniele Alessandrelli <daniele.alessandrelli@intel.com>
Subject: Re: [PATCH v2 1/3] dt-bindings: crypto: Add Keem Bay OCS HCU bindings
Message-ID: <20201109161532.GA1382203@bogus>
References: <20201103184925.294456-1-daniele.alessandrelli@linux.intel.com>
 <20201103184925.294456-2-daniele.alessandrelli@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201103184925.294456-2-daniele.alessandrelli@linux.intel.com>
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Tue, Nov 03, 2020 at 06:49:23PM +0000, Daniele Alessandrelli wrote:
> From: Declan Murphy <declan.murphy@intel.com>
> 
> Add device-tree bindings for the Intel Keem Bay Offload Crypto Subsystem
> (OCS) Hashing Control Unit (HCU) crypto driver.
> 
> Signed-off-by: Declan Murphy <declan.murphy@intel.com>
> Signed-off-by: Daniele Alessandrelli <daniele.alessandrelli@intel.com>
> Acked-by: Mark Gross <mgross@linux.intel.com>
> ---
>  .../crypto/intel,keembay-ocs-hcu.yaml         | 51 +++++++++++++++++++
>  1 file changed, 51 insertions(+)
>  create mode 100644 Documentation/devicetree/bindings/crypto/intel,keembay-ocs-hcu.yaml
> 
> diff --git a/Documentation/devicetree/bindings/crypto/intel,keembay-ocs-hcu.yaml b/Documentation/devicetree/bindings/crypto/intel,keembay-ocs-hcu.yaml
> new file mode 100644
> index 000000000000..cc03e2b66d5a
> --- /dev/null
> +++ b/Documentation/devicetree/bindings/crypto/intel,keembay-ocs-hcu.yaml
> @@ -0,0 +1,51 @@
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
> +  - Daniele Alessandrelli <daniele.alessandrelli@intel.com>
> +
> +description:
> +  The Intel Keem Bay Offload and Crypto Subsystem (OCS) Hash Control Unit (HCU)
> +  provides hardware-accelerated hashing and HMAC.
> +
> +properties:
> +  compatible:
> +    const: intel,keembay-ocs-hcu
> +
> +  reg:
> +    items:
> +      - description: The OCS HCU base register address

Just need 'maxItems: 1' if there's only 1. The description doesn't add 
anything.

> +
> +  interrupts:
> +    items:
> +      - description: OCS HCU interrupt

Same here

> +
> +  clocks:
> +    items:
> +      - description: OCS clock

And here.

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
> +    crypto@3000b000 {
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
