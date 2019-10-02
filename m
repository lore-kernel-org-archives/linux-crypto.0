Return-Path: <SRS0=UbUg=X3=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.6 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 09A2BC352AA
	for <linux-crypto@archiver.kernel.org>; Wed,  2 Oct 2019 05:55:07 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id C430B218DE
	for <linux-crypto@archiver.kernel.org>; Wed,  2 Oct 2019 05:55:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1569995706;
	bh=wtOtOFphvhIR12Sw79063XbPCHTzfD6ZAz0An0TI4w4=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:List-ID:From;
	b=kCDxaOaI7Lfe9F39VeE+pTGm8U+KBIkdHAmh1a28C2bBQZNAwLU+TsyqkgLTPhorG
	 ceWTOsDz8HhlfN5kgerBhK5aFoju2ko6D6erkR2vnxuQ+ol1wM0M3k4JUvgiflzSD0
	 RfsWa/05Prt2sa1X9teetJq8hYzSE8uRKx+ld/SM=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726392AbfJBFzD (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Wed, 2 Oct 2019 01:55:03 -0400
Received: from mail.kernel.org ([198.145.29.99]:42624 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726152AbfJBFzD (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 2 Oct 2019 01:55:03 -0400
Received: from localhost (lfbn-1-10718-76.w90-89.abo.wanadoo.fr [90.89.68.76])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 365D72086A;
        Wed,  2 Oct 2019 05:55:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1569995701;
        bh=wtOtOFphvhIR12Sw79063XbPCHTzfD6ZAz0An0TI4w4=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=H8MbhzvorA/X5IA8IvWZUg8Jo9It3tP9Ey+rxONzf2AMfBEYoE9UM9XWcUGsueedk
         jgNVjcYcMR3b59MBRVqs+vqqIYPsxYXTC9dsWvVM5SwrQiHY6am21me7k4nGzNxytC
         j13KLlST3J5UYFqYRYmY6saU0znZuEOvYeB+qpX0=
Date:   Wed, 2 Oct 2019 07:54:58 +0200
From:   Maxime Ripard <mripard@kernel.org>
To:     Corentin Labbe <clabbe.montjoie@gmail.com>
Cc:     catalin.marinas@arm.com, davem@davemloft.net,
        herbert@gondor.apana.org.au, linux@armlinux.org.uk,
        mark.rutland@arm.com, robh+dt@kernel.org, wens@csie.org,
        will@kernel.org, devicetree@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-crypto@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-sunxi@googlegroups.com
Subject: Re: [PATCH v2 03/11] dt-bindings: crypto: Add DT bindings
 documentation for sun8i-ce Crypto Engine
Message-ID: <20191002055458.zo2vdbxodj3ch53g@gilmour>
References: <20191001184141.27956-1-clabbe.montjoie@gmail.com>
 <20191001184141.27956-4-clabbe.montjoie@gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="2fgyg66uvun6eeak"
Content-Disposition: inline
In-Reply-To: <20191001184141.27956-4-clabbe.montjoie@gmail.com>
User-Agent: NeoMutt/20180716
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org


--2fgyg66uvun6eeak
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Tue, Oct 01, 2019 at 08:41:33PM +0200, Corentin Labbe wrote:
> This patch adds documentation for Device-Tree bindings for the
> Crypto Engine cryptographic accelerator driver.
>
> Signed-off-by: Corentin Labbe <clabbe.montjoie@gmail.com>
> ---
>  .../bindings/crypto/allwinner,sun8i-ce.yaml   | 92 +++++++++++++++++++
>  1 file changed, 92 insertions(+)
>  create mode 100644 Documentation/devicetree/bindings/crypto/allwinner,sun8i-ce.yaml
>
> diff --git a/Documentation/devicetree/bindings/crypto/allwinner,sun8i-ce.yaml b/Documentation/devicetree/bindings/crypto/allwinner,sun8i-ce.yaml
> new file mode 100644
> index 000000000000..9bd26a2eff33
> --- /dev/null
> +++ b/Documentation/devicetree/bindings/crypto/allwinner,sun8i-ce.yaml
> @@ -0,0 +1,92 @@
> +# SPDX-License-Identifier: GPL-2.0
> +%YAML 1.2
> +---
> +$id: http://devicetree.org/schemas/crypto/allwinner,sun8i-ce.yaml#
> +$schema: http://devicetree.org/meta-schemas/core.yaml#
> +
> +title: Allwinner Crypto Engine driver
> +
> +maintainers:
> +  - Corentin Labbe <clabbe.montjoie@gmail.com>
> +
> +properties:
> +  compatible:
> +    enum:
> +      - allwinner,sun8i-h3-crypto
> +      - allwinner,sun8i-r40-crypto
> +      - allwinner,sun50i-a64-crypto
> +      - allwinner,sun50i-h5-crypto
> +      - allwinner,sun50i-h6-crypto
> +
> +  reg:
> +    maxItems: 1
> +
> +  interrupts:
> +    maxItems: 1
> +
> +  clocks:
> +    items:
> +      - description: Bus clock
> +      - description: Module clock
> +      - description: MBus clock
> +    minItems: 2
> +    maxItems: 3
> +
> +  clock-names:
> +    items:
> +      - const: bus
> +      - const: mod
> +      - const: ram
> +    minItems: 2
> +    maxItems: 3
> +
> +  resets:
> +    maxItems: 1
> +
> +  reset-names:
> +    const: bus
> +
> +if:
> +  properties:
> +    compatible:
> +      items:
> +        const: allwinner,sun50i-h6-crypto
> +then:
> +  properties:
> +      clocks:
> +        minItems: 3
> +      clock-names:
> +        minItems: 3
> +else:
> +  properties:
> +      clocks:
> +        maxItems: 2
> +      clock-names:
> +        maxItems: 2
> +
> +required:
> +  - compatible
> +  - reg
> +  - interrupts
> +  - clocks
> +  - clock-names
> +  - resets
> +
> +additionalProperties: true

I guess you meant false here?

Maxime

--2fgyg66uvun6eeak
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iHUEABYIAB0WIQRcEzekXsqa64kGDp7j7w1vZxhRxQUCXZQ7rQAKCRDj7w1vZxhR
xdFbAQCEkUlhME2ax9rLhbr3MrlsTcoOQtlq/F3s52pxJLaI3QD+OMbHPPV//HCY
MPqSdqIOu1r5jzZjtXPgjsZTo4VsqAo=
=m0Hw
-----END PGP SIGNATURE-----

--2fgyg66uvun6eeak--
