Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.7 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=unavailable autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AC7C5C388F7
	for <linux-crypto@archiver.kernel.org>; Tue, 10 Nov 2020 17:36:55 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 62C1F207D3
	for <linux-crypto@archiver.kernel.org>; Tue, 10 Nov 2020 17:36:55 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731050AbgKJRgy (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Tue, 10 Nov 2020 12:36:54 -0500
Received: from mga06.intel.com ([134.134.136.31]:37254 "EHLO mga06.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730299AbgKJRgy (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 10 Nov 2020 12:36:54 -0500
IronPort-SDR: y/BlxRnqVcOLnrCyt83Z+8t9Vt15asWzgReZdYqtVwpyYz+y2A7TtWLU29G3FRyL6TVHufOW7i
 m/XylgFFCJrA==
X-IronPort-AV: E=McAfee;i="6000,8403,9801"; a="231645371"
X-IronPort-AV: E=Sophos;i="5.77,466,1596524400"; 
   d="scan'208";a="231645371"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga005.jf.intel.com ([10.7.209.41])
  by orsmga104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 10 Nov 2020 09:36:52 -0800
IronPort-SDR: F53sb+0lbYh1DQwyXVc27+eYvsELjCPWmvyKuGIYgvp3oxR00zOLNI1fxiWi2DyErePBLSAmLA
 KWQ9cx3hSDBA==
X-IronPort-AV: E=Sophos;i="5.77,466,1596524400"; 
   d="scan'208";a="541418650"
Received: from bmaguire-mobl1.ger.corp.intel.com ([10.252.16.241])
  by orsmga005-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 10 Nov 2020 09:36:49 -0800
Message-ID: <89bb5cd49a61d00c2d2f08a4b9273aaecd972ef8.camel@linux.intel.com>
Subject: Re: [PATCH v2 1/3] dt-bindings: crypto: Add Keem Bay OCS HCU
 bindings
From:   Daniele Alessandrelli <daniele.alessandrelli@linux.intel.com>
To:     Rob Herring <robh@kernel.org>
Cc:     Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>,
        linux-crypto@vger.kernel.org, devicetree@vger.kernel.org,
        Mark Gross <mgross@linux.intel.com>,
        Declan Murphy <declan.murphy@intel.com>,
        daniele.alessandrelli@intel.com
Date:   Tue, 10 Nov 2020 17:36:43 +0000
In-Reply-To: <20201109161532.GA1382203@bogus>
References: <20201103184925.294456-1-daniele.alessandrelli@linux.intel.com>
         <20201103184925.294456-2-daniele.alessandrelli@linux.intel.com>
         <20201109161532.GA1382203@bogus>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.36.5 (3.36.5-1.fc32) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Mon, 2020-11-09 at 10:15 -0600, Rob Herring wrote:
> On Tue, Nov 03, 2020 at 06:49:23PM +0000, Daniele Alessandrelli wrote:
> > From: Declan Murphy <declan.murphy@intel.com>
> > 
> > Add device-tree bindings for the Intel Keem Bay Offload Crypto Subsystem
> > (OCS) Hashing Control Unit (HCU) crypto driver.
> > 
> > Signed-off-by: Declan Murphy <declan.murphy@intel.com>
> > Signed-off-by: Daniele Alessandrelli <daniele.alessandrelli@intel.com>
> > Acked-by: Mark Gross <mgross@linux.intel.com>
> > ---
> >  .../crypto/intel,keembay-ocs-hcu.yaml         | 51 +++++++++++++++++++
> >  1 file changed, 51 insertions(+)
> >  create mode 100644 Documentation/devicetree/bindings/crypto/intel,keembay-ocs-hcu.yaml
> > 
> > diff --git a/Documentation/devicetree/bindings/crypto/intel,keembay-ocs-hcu.yaml b/Documentation/devicetree/bindings/crypto/intel,keembay-ocs-hcu.yaml
> > new file mode 100644
> > index 000000000000..cc03e2b66d5a
> > --- /dev/null
> > +++ b/Documentation/devicetree/bindings/crypto/intel,keembay-ocs-hcu.yaml
> > @@ -0,0 +1,51 @@
> > +# SPDX-License-Identifier: (GPL-2.0-only OR BSD-2-Clause)
> > +%YAML 1.2
> > +---
> > +$id: http://devicetree.org/schemas/crypto/intel,keembay-ocs-hcu.yaml#
> > +$schema: http://devicetree.org/meta-schemas/core.yaml#
> > +
> > +title: Intel Keem Bay OCS HCU Device Tree Bindings
> > +
> > +maintainers:
> > +  - Declan Murphy <declan.murphy@intel.com>
> > +  - Daniele Alessandrelli <daniele.alessandrelli@intel.com>
> > +
> > +description:
> > +  The Intel Keem Bay Offload and Crypto Subsystem (OCS) Hash Control Unit (HCU)
> > +  provides hardware-accelerated hashing and HMAC.
> > +
> > +properties:
> > +  compatible:
> > +    const: intel,keembay-ocs-hcu
> > +
> > +  reg:
> > +    items:
> > +      - description: The OCS HCU base register address
> 
> Just need 'maxItems: 1' if there's only 1. The description doesn't add 
> anything.

Thanks for the review. I will change this and the ones below.

> 
> > +
> > +  interrupts:
> > +    items:
> > +      - description: OCS HCU interrupt
> 
> Same here
> 
> > +
> > +  clocks:
> > +    items:
> > +      - description: OCS clock
> 
> And here.
> 
> > +
> > +required:
> > +  - compatible
> > +  - reg
> > +  - interrupts
> > +  - clocks
> > +
> > +additionalProperties: false
> > +
> > +examples:
> > +  - |
> > +    #include <dt-bindings/interrupt-controller/arm-gic.h>
> > +    crypto@3000b000 {
> > +      compatible = "intel,keembay-ocs-hcu";
> > +      reg = <0x3000b000 0x1000>;
> > +      interrupts = <GIC_SPI 121 IRQ_TYPE_LEVEL_HIGH>;
> > +      clocks = <&scmi_clk 94>;
> > +    };
> > +
> > +...
> > -- 
> > 2.26.2
> > 

