Return-Path: <SRS0=UbUg=X3=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.6 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 140E7ECE58B
	for <linux-crypto@archiver.kernel.org>; Wed,  2 Oct 2019 06:02:19 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id DAFAA21D7B
	for <linux-crypto@archiver.kernel.org>; Wed,  2 Oct 2019 06:02:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1569996138;
	bh=CV+keQnc3oa8IaO1/T0MBCxfFNAt5NtFUuPy7+FcG18=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:List-ID:From;
	b=MoXv83abO2hiQIiz0Qzfo67bAvUQjK/ut53HZ0KDwfUbyMNKeCDGJ6F8GjW5QQYiH
	 eOMgH8h7qCB0vlLMF4rWUvupSAOI+G0slivzmLXnv8MENXXpx0KX9fgkQHLycvxszF
	 M+w3Rae/S+/V+npwiNcXjiwgFcdBp+X2NPbAUnFg=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727347AbfJBGCR (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Wed, 2 Oct 2019 02:02:17 -0400
Received: from mail.kernel.org ([198.145.29.99]:45850 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726806AbfJBGCR (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 2 Oct 2019 02:02:17 -0400
Received: from localhost (lfbn-1-10718-76.w90-89.abo.wanadoo.fr [90.89.68.76])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 4E3BA215EA;
        Wed,  2 Oct 2019 06:02:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1569996136;
        bh=CV+keQnc3oa8IaO1/T0MBCxfFNAt5NtFUuPy7+FcG18=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=hM22mscs+qhQMk/S8W5R5oSgacgTbDnofWaJ7YLQekxJSLH6QWK+qdm+Vm9b/JlGM
         4yCkFlqv+jnEFzQQRrzWH5IHcQkgylDWQJ28A8ABAsMFMWVjZXmIc0rzgJ8pWc3VZ6
         lTiKwomFwZqq7ruUfUbgXv7Ddax/LbAqjDaorWgA=
Date:   Wed, 2 Oct 2019 08:02:14 +0200
From:   Maxime Ripard <mripard@kernel.org>
To:     Corentin Labbe <clabbe.montjoie@gmail.com>
Cc:     catalin.marinas@arm.com, davem@davemloft.net,
        herbert@gondor.apana.org.au, linux@armlinux.org.uk,
        mark.rutland@arm.com, robh+dt@kernel.org, wens@csie.org,
        will@kernel.org, devicetree@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-crypto@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-sunxi@googlegroups.com
Subject: Re: [PATCH v2 05/11] ARM: dts: sun8i: H3: Add Crypto Engine node
Message-ID: <20191002060214.bu67nkd3y6puknrb@gilmour>
References: <20191001184141.27956-1-clabbe.montjoie@gmail.com>
 <20191001184141.27956-6-clabbe.montjoie@gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="m5s3egvksjuih2k6"
Content-Disposition: inline
In-Reply-To: <20191001184141.27956-6-clabbe.montjoie@gmail.com>
User-Agent: NeoMutt/20180716
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org


--m5s3egvksjuih2k6
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Tue, Oct 01, 2019 at 08:41:35PM +0200, Corentin Labbe wrote:
> The Crypto Engine is a hardware cryptographic accelerator that supports
> many algorithms.
> It could be found on most Allwinner SoCs.
>
> This patch enables the Crypto Engine on the Allwinner H3 SoC Device-tree.
>
> Signed-off-by: Corentin Labbe <clabbe.montjoie@gmail.com>
> ---
>  arch/arm/boot/dts/sun8i-h3.dtsi | 11 +++++++++++
>  1 file changed, 11 insertions(+)
>
> diff --git a/arch/arm/boot/dts/sun8i-h3.dtsi b/arch/arm/boot/dts/sun8i-h3.dtsi
> index e37c30e811d3..778a23a794c9 100644
> --- a/arch/arm/boot/dts/sun8i-h3.dtsi
> +++ b/arch/arm/boot/dts/sun8i-h3.dtsi
> @@ -153,6 +153,17 @@
>  			allwinner,sram = <&ve_sram 1>;
>  		};
>
> +		crypto: crypto@1c15000 {
> +			compatible = "allwinner,sun8i-h3-crypto";
> +			reg = <0x01c15000 0x1000>;
> +			interrupts = <GIC_SPI 94 IRQ_TYPE_LEVEL_HIGH>;
> +			interrupt-names = "ce_ns";

That's not documented in the binding (and I guess unnecessary)

> +			resets = <&ccu RST_BUS_CE>;
> +			reset-names = "bus";
> +			clocks = <&ccu CLK_BUS_CE>, <&ccu CLK_CE>;
> +			clock-names = "bus", "mod";

Nit: we put the clocks before the resets usually

Maxime

--m5s3egvksjuih2k6
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iHUEABYIAB0WIQRcEzekXsqa64kGDp7j7w1vZxhRxQUCXZQ9ZQAKCRDj7w1vZxhR
xQ12AP4v8ngYjx24mlHXpcMOKB1UPEpZ7nVs0R3Z429dTd6YiwD+I2L/8Esrt1co
O1jvbqC8meSjGLU39z/Mr3MOweUa+Q8=
=RT92
-----END PGP SIGNATURE-----

--m5s3egvksjuih2k6--
