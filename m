Return-Path: <SRS0=pM9r=EC=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,
	SPF_PASS,URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 63987C388F9
	for <linux-crypto@archiver.kernel.org>; Tue, 27 Oct 2020 17:21:49 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 1064921D24
	for <linux-crypto@archiver.kernel.org>; Tue, 27 Oct 2020 17:21:49 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1781960AbgJ0RQg (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Tue, 27 Oct 2020 13:16:36 -0400
Received: from mga09.intel.com ([134.134.136.24]:40076 "EHLO mga09.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1817247AbgJ0RPD (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 27 Oct 2020 13:15:03 -0400
IronPort-SDR: IhiYhhQ10uS9WstVwYP7/uh855un7g8SddWGjeM86hVesgpZbk3OH2ozbUHhbQcdB8u2xL3rwc
 36HDlPrmEbVg==
X-IronPort-AV: E=McAfee;i="6000,8403,9787"; a="168253594"
X-IronPort-AV: E=Sophos;i="5.77,424,1596524400"; 
   d="scan'208";a="168253594"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga005.jf.intel.com ([10.7.209.41])
  by orsmga102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 27 Oct 2020 10:14:57 -0700
IronPort-SDR: 0OZa4gjRtP6tQyPd26QTkZcDuXzoDUeLn3w1ZtNV20ycCdYCynV+zmfyBxN9JX3fi1NXN6oGn7
 a7ZKjvyUrYxg==
X-IronPort-AV: E=Sophos;i="5.77,424,1596524400"; 
   d="scan'208";a="535879022"
Received: from malgor1x-mobl.ger.corp.intel.com ([10.252.4.211])
  by orsmga005-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 27 Oct 2020 10:14:55 -0700
Message-ID: <05c9018e2ded63dce52663c2e7103583b39b461d.camel@linux.intel.com>
Subject: Re: [PATCH 1/3] dt-bindings: crypto: Add Keem Bay OCS HCU bindings
From:   Daniele Alessandrelli <daniele.alessandrelli@linux.intel.com>
To:     Rob Herring <robh@kernel.org>
Cc:     Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>,
        linux-crypto@vger.kernel.org, devicetree@vger.kernel.org,
        Mark Gross <mgross@linux.intel.com>,
        Declan Murphy <declan.murphy@intel.com>,
        Daniele Alessandrelli <daniele.alessandrelli@intel.com>
Date:   Tue, 27 Oct 2020 17:14:43 +0000
In-Reply-To: <20201026131723.GA11033@bogus>
References: <20201016172759.1260407-1-daniele.alessandrelli@linux.intel.com>
         <20201016172759.1260407-2-daniele.alessandrelli@linux.intel.com>
         <20201026131723.GA11033@bogus>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.36.5 (3.36.5-1.fc32) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Hi Rob,

Thanks for reviewing the patch.

On Mon, 2020-10-26 at 08:17 -0500, Rob Herring wrote:
> On Fri, Oct 16, 2020 at 06:27:57PM +0100, Daniele Alessandrelli
> wrote:
> > From: Declan Murphy <declan.murphy@intel.com>
> > 
> > Add device-tree bindings for the Intel Keem Bay Offload Crypto
> > Subsystem
> > (OCS) Hashing Control Unit (HCU) crypto driver.
> > 
> > Signed-off-by: Declan Murphy <declan.murphy@intel.com>
> > Signed-off-by: Daniele Alessandrelli <
> > daniele.alessandrelli@intel.com>
> > Acked-by: Mark Gross <mgross@linux.intel.com>
> > ---
> >  .../crypto/intel,keembay-ocs-hcu.yaml         | 52
> > +++++++++++++++++++
> >  1 file changed, 52 insertions(+)
> >  create mode 100644
> > Documentation/devicetree/bindings/crypto/intel,keembay-ocs-hcu.yaml
> > 
> > diff --git
> > a/Documentation/devicetree/bindings/crypto/intel,keembay-ocs-
> > hcu.yaml b/Documentation/devicetree/bindings/crypto/intel,keembay-
> > ocs-hcu.yaml
> > new file mode 100644
> > index 000000000000..dd4b82ee872b
> > --- /dev/null
> > +++ b/Documentation/devicetree/bindings/crypto/intel,keembay-ocs-
> > hcu.yaml
> > @@ -0,0 +1,52 @@
> > +# SPDX-License-Identifier: (GPL-2.0-only OR BSD-2-Clause)
> > +%YAML 1.2
> > +---
> > +$id: 
> > http://devicetree.org/schemas/crypto/intel,keembay-ocs-hcu.yaml#
> > +$schema: http://devicetree.org/meta-schemas/core.yaml#
> > +
> > +title: Intel Keem Bay OCS HCU Device Tree Bindings
> > +
> > +maintainers:
> > +  - Declan Murphy <declan.murphy@intel.com>
> > +  - Daniele Alessandrelli <deniele.alessandrelli@intel.com>
> 
> typo:                          ^?

How embarrassing :/

> 
> > +
> > +description: |
> 
> Can drop '|' if there's no formatting to preserve.

Thanks, I'll fix that.

> 
> > +  The Intel Keem Bay Offload and Crypto Subsystem (OCS) Hash
> > Control Unit (HCU)
> > +  crypto driver enables use of the hardware accelerated hashing
> > module embedded
> > +  in the Intel Movidius SoC code name Keem Bay, via the kernel
> > crypto API.
> 
> Don't put Linux details in bindings. Describe the h/w, not a driver.

I'll fix that.

> 
> > +
> > +properties:
> > +  compatible:
> > +    const: intel,keembay-ocs-hcu
> > +
> > +  reg:
> > +    items:
> > +      - description: The OCS HCU base register address
> > +
> > +  interrupts:
> > +    items:
> > +      - description: OCS HCU interrupt
> > +
> > +  clocks:
> > +    items:
> > +      - description: OCS clock
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
> > +    hcu@3000b000 {
> 
> crypto@...

I'll change it to crypto@3000b000, but I wonder: we are going to
upstream other Keem Bay crypto drivers (an AES driver and an ECC one,
in addition to this hash one), so, would it make sense to use something
like crypto-hash@ (and then in future crypto-aes@ and crypto-ecc@)? Or
should I use crypto@<reg> (with different reg vals) for all of them?

> 
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

