Return-Path: <SRS0=JhmS=XC=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.6 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B10A6C43331
	for <linux-crypto@archiver.kernel.org>; Sat,  7 Sep 2019 04:01:25 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 8F1D621848
	for <linux-crypto@archiver.kernel.org>; Sat,  7 Sep 2019 04:01:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1567828885;
	bh=iu+lz+zqRz/+ZH/PPEzbT7toVzrtFnm5HGdE4wWlvRo=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:List-ID:From;
	b=uGtpX7YMVLfI1pFN1rw+88VzMzRnaDHBblPDKT7Q6zVwUxxnR2H4tVOQ2RV0WlzJ4
	 UaIonYi8QmI/CEQ54QQV8coIF49qXbOO13HXrFYvNK2LDKNQwwKRgM+R6Vev083S6N
	 QeNoJDHpKH2DH/hAuyjpe8jaNUnu/iHEa54URQWg=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727744AbfIGEBY (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Sat, 7 Sep 2019 00:01:24 -0400
Received: from mail.kernel.org ([198.145.29.99]:48574 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726229AbfIGEBX (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Sat, 7 Sep 2019 00:01:23 -0400
Received: from localhost (unknown [194.251.198.105])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 6B81520854;
        Sat,  7 Sep 2019 04:01:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1567828883;
        bh=iu+lz+zqRz/+ZH/PPEzbT7toVzrtFnm5HGdE4wWlvRo=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=XkZG4FLkpMuUlfykl/s2Cjtw2sN2NURmDBBPEpjYtpByLcMJ7uUc25IwecXQHXmUA
         bXWD2DoHkX3EMLNtKOBWAIE6u0TohVtD+T/XI45WydWqeIihnPfQF2j71VPG1oEpsB
         ZlxEkT6RF0Y7LBx34lvC1oF5lXbcy0vm3D0Fuxhs=
Date:   Sat, 7 Sep 2019 07:01:16 +0300
From:   Maxime Ripard <mripard@kernel.org>
To:     Corentin Labbe <clabbe.montjoie@gmail.com>
Cc:     davem@davemloft.net, herbert@gondor.apana.org.au,
        linux@armlinux.org.uk, mark.rutland@arm.com, robh+dt@kernel.org,
        wens@csie.org, devicetree@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-crypto@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-sunxi@googlegroups.com
Subject: Re: [PATCH 3/9] dt-bindings: crypto: Add DT bindings documentation
 for sun8i-ce Crypto Engine
Message-ID: <20190907040116.lib532o2eqt4qnvv@flea>
References: <20190906184551.17858-1-clabbe.montjoie@gmail.com>
 <20190906184551.17858-4-clabbe.montjoie@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190906184551.17858-4-clabbe.montjoie@gmail.com>
User-Agent: NeoMutt/20180716
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Fri, Sep 06, 2019 at 08:45:45PM +0200, Corentin Labbe wrote:
> This patch adds documentation for Device-Tree bindings for the
> Crypto Engine cryptographic accelerator driver.
>
> Signed-off-by: Corentin Labbe <clabbe.montjoie@gmail.com>
> ---
>  .../bindings/crypto/allwinner,sun8i-ce.yaml   | 84 +++++++++++++++++++
>  1 file changed, 84 insertions(+)
>  create mode 100644 Documentation/devicetree/bindings/crypto/allwinner,sun8i-ce.yaml
>
> diff --git a/Documentation/devicetree/bindings/crypto/allwinner,sun8i-ce.yaml b/Documentation/devicetree/bindings/crypto/allwinner,sun8i-ce.yaml
> new file mode 100644
> index 000000000000..bd8ccedd6059
> --- /dev/null
> +++ b/Documentation/devicetree/bindings/crypto/allwinner,sun8i-ce.yaml

So, usually we're using the first compatible supported here as the
name.

> @@ -0,0 +1,84 @@
> +# SPDX-License-Identifier: GPL-2.0
> +%YAML 1.2
> +---
> +$id: http://devicetree.org/schemas/crypto/allwinner,sun8i-ce.yaml#
> +$schema: http://devicetree.org/meta-schemas/core.yaml#
> +
> +title: Allwinner Crypto Engine driver
> +
> +maintainers:
> +  - Corentin Labbe <clabbe@baylibre.com>
> +
> +properties:
> +  compatible:
> +    oneOf:
> +      - const: allwinner,sun8i-h3-crypto
> +      - const: allwinner,sun8i-r40-crypto
> +      - const: allwinner,sun50i-a64-crypto
> +      - const: allwinner,sun50i-h5-crypto
> +      - const: allwinner,sun50i-h6-crypto

An enum would be better here, it provides a more obvious error
message.

> +
> +  reg:
> +    maxItems: 1
> +
> +  interrupts:
> +    maxItems: 1
> +
> +if:
> +  properties:
> +    compatible:
> +      contains:
> +        const: allwinner,sun50i-h6-crypto
> +then:
> +  clocks:
> +    items:
> +      - description: Bus clock
> +      - description: Module clock
> +      - description: MBus clock
> +
> +  clock-names:
> +    items:
> +      - const: ahb
> +      - const: mod
> +      - const: mbus

It looks like there's a reset line on the H6 as well for that
controller (register 0x68c of the CCU, "CE_BGR_REG").

> +else:
> +  clocks:
> +    items:
> +      - description: Bus clock
> +      - description: Module clock
> +
> +  clock-names:
> +    items:
> +      - const: ahb
> +      - const: mod
> +
> +  resets:
> +    maxItems: 1
> +
> +  reset-names:
> +    const: ahb

This prevents the usage of the additionalProperties property, which
you should really use.

What you can do instead is moving the clocks and clock-names
description under properties, with a minItems of 2 and a maxItems of
3. Then you can restrict the length of that property to either 2 or 3
depending on the case here.

Maxime

--
Maxime Ripard, Bootlin
Embedded Linux and Kernel engineering
https://bootlin.com
