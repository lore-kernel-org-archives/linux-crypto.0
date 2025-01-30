Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E11D31487E1;
	Thu, 30 Jan 2025 18:42:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738262536; cv=none; b=uk7teB42kurDzd4gbE9fUcLjL6Yx3d9n7pZ7nzlHXQzATJbvbJk1eQXltm5cJ3SLMaPYZIr8eH0J0g0wFahWrWjOPXu9xV2rPsnf+lTZsqnu6M+fc81+peqXI+L1BfExBpn1s/bqY1AHLtRbLJ0kFvToUA1wTteCifm9OL4HYsg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738262536; c=relaxed/simple;
	bh=7SyZ5zCEJ4aNJvlmHMl8pZTMFw6jNB5EeCSDItXKy7s=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=P4yJOfiHjZMHC/mZpv/trmq/CY398rr3yNdcaFY/3tpuJn9c1l80+hAEvFqETTDkA0yFT9OFLO+EzBqL9Qj2az9HCgd+4FptXQ13HVz+yfYd0ouxK0mFAH7sdMGBEnCY3tYB0RbQzdJUMqtVLEcx/btiQs/dokii0jsPsb7GX1k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=MP/S47nA; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="MP/S47nA"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4C3C8C4CED2;
	Thu, 30 Jan 2025 18:42:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1738262535;
	bh=7SyZ5zCEJ4aNJvlmHMl8pZTMFw6jNB5EeCSDItXKy7s=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=MP/S47nA8FE9AkuHWURw/yUclraFw1sFDgbUmalMDZV0/vbCb5U0HkRgrIxFDVQbR
	 jmTquZPkUs7UbzmAwoMc4DmXmNprefYqz2iiZfqflLMIIWSCHcE2hRIARNd4lneK7m
	 PawsARXf+YXzjgMryCAxyE6UcQQaUJPyr3VIxDkf6Exjpgxl2P8B8nW/c2fmUc4rE6
	 /hY1qrBH7jbokFST3GNofAdKQ4JRX3Wbzzv8OCwS0oL2+b7aIeFq7xLEcugnTFGnfk
	 tdXvdFKA/8jTj+TM0Pv/TsAQlqkSBJOKjpuiHhN/iZAiLO+epc56JaVm1vKuGGMtJ+
	 yFV9Ay6+9RgQg==
Date: Thu, 30 Jan 2025 18:42:09 +0000
From: Conor Dooley <conor@kernel.org>
To: Nicolas Frattaroli <nicolas.frattaroli@collabora.com>
Cc: Philipp Zabel <p.zabel@pengutronix.de>, Rob Herring <robh@kernel.org>,
	Krzysztof Kozlowski <krzk+dt@kernel.org>,
	Conor Dooley <conor+dt@kernel.org>,
	Heiko Stuebner <heiko@sntech.de>,
	Olivia Mackall <olivia@selenic.com>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	Daniel Golle <daniel@makrotopia.org>,
	Aurelien Jarno <aurelien@aurel32.net>,
	Sebastian Reichel <sebastian.reichel@collabora.com>,
	devicetree@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
	linux-rockchip@lists.infradead.org, linux-kernel@vger.kernel.org,
	linux-crypto@vger.kernel.org
Subject: Re: [PATCH 2/7] dt-bindings: rng: add binding for Rockchip RK3588 RNG
Message-ID: <20250130-anything-scholar-01f4c9145893@spud>
References: <20250130-rk3588-trng-submission-v1-0-97ff76568e49@collabora.com>
 <20250130-rk3588-trng-submission-v1-2-97ff76568e49@collabora.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
	protocol="application/pgp-signature"; boundary="hYobnhEFDnkdMhyO"
Content-Disposition: inline
In-Reply-To: <20250130-rk3588-trng-submission-v1-2-97ff76568e49@collabora.com>


--hYobnhEFDnkdMhyO
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Thu, Jan 30, 2025 at 05:31:16PM +0100, Nicolas Frattaroli wrote:
> The Rockchip RK3588 SoC has two hardware RNGs accessible to the
> non-secure world: an RNG in the Crypto IP, and a standalone RNG that is
> new to this SoC.
>=20
> Add a binding for this new standalone RNG.
>=20
> The RNG is capable of firing an interrupt when entropy is ready, but
> all known driver implementations choose to poll instead for performance
> reasons. Hence, make the interrupt optional, as it may disappear in
> future hardware revisions entirely and certainly isn't needed for the
> hardware to function.
>=20
> The reset is optional as well, as the RNG functions without an explicit
> reset. Rockchip's downstream driver does not use the reset at all,
> indicating that their engineers have deemed it unnecessary.
>=20
> Signed-off-by: Nicolas Frattaroli <nicolas.frattaroli@collabora.com>
> ---
>  .../bindings/rng/rockchip,rk3588-rng.yaml          | 61 ++++++++++++++++=
++++++
>  MAINTAINERS                                        |  2 +
>  2 files changed, 63 insertions(+)
>=20
> diff --git a/Documentation/devicetree/bindings/rng/rockchip,rk3588-rng.ya=
ml b/Documentation/devicetree/bindings/rng/rockchip,rk3588-rng.yaml
> new file mode 100644
> index 0000000000000000000000000000000000000000..dff843fa4bf9d5704bbcd1063=
98328588d80b02d
> --- /dev/null
> +++ b/Documentation/devicetree/bindings/rng/rockchip,rk3588-rng.yaml
> @@ -0,0 +1,61 @@
> +# SPDX-License-Identifier: (GPL-2.0-only OR BSD-2-Clause)
> +%YAML 1.2
> +---
> +$id: http://devicetree.org/schemas/rng/rockchip,rk3588-rng.yaml#
> +$schema: http://devicetree.org/meta-schemas/core.yaml#
> +
> +title: Rockchip RK3588 TRNG
> +
> +description: True Random Number Generator on Rockchip RK3588 SoC
> +
> +maintainers:
> +  - Nicolas Frattaroli <nicolas.frattaroli@collabora.com>
> +
> +properties:
> +  compatible:
> +    enum:
> +      - rockchip,rk3588-rng
> +
> +  reg:
> +    maxItems: 1
> +
> +  clocks:
> +    items:
> +      - description: TRNG AHB clock
> +
> +  # Optional, not used by some driver implementations
> +  interrupts:
> +    maxItems: 1
> +
> +  # Optional, hardware works without explicit reset

These sorts of comments are not needed, "required" conveys this
information.

> +  resets:
> +    maxItems: 1
> +
> +required:
> +  - compatible
> +  - reg
> +  - clocks
> +
> +additionalProperties: false
> +
> +examples:
> +  - |
> +    #include <dt-bindings/clock/rockchip,rk3588-cru.h>
> +    #include <dt-bindings/interrupt-controller/arm-gic.h>
> +    #include <dt-bindings/interrupt-controller/irq.h>
> +    #include <dt-bindings/reset/rockchip,rk3588-cru.h>
> +    bus {
> +      #address-cells =3D <2>;
> +      #size-cells =3D <2>;
> +
> +      rng@fe378000 {
> +        compatible =3D "rockchip,rk3588-rng";
> +        reg =3D <0x0 0xfe378000 0x0 0x200>;
> +        interrupts =3D <GIC_SPI 400 IRQ_TYPE_LEVEL_HIGH 0>;
> +        clocks =3D <&scmi_clk SCMI_HCLK_SECURE_NS>;
> +        resets =3D <&scmi_reset SCMI_SRST_H_TRNG_NS>;
> +        status =3D "disabled";
> +      };
> +    };
> +
> +...
> diff --git a/MAINTAINERS b/MAINTAINERS
> index bc8ce7af3303f747e0ef028e5a7b29b0bbba99f4..7daf9bfeb0cb4e9e594b80901=
2c7aa243b0558ae 100644
> --- a/MAINTAINERS
> +++ b/MAINTAINERS
> @@ -20420,8 +20420,10 @@ F:	include/uapi/linux/rkisp1-config.h
>  ROCKCHIP RK3568 RANDOM NUMBER GENERATOR SUPPORT
>  M:	Daniel Golle <daniel@makrotopia.org>
>  M:	Aurelien Jarno <aurelien@aurel32.net>

> +M:	Nicolas Frattaroli <nicolas.frattaroli@collabora.com>
^^
tbh, not really sure this part of the change should be in this patch

>  S:	Maintained
>  F:	Documentation/devicetree/bindings/rng/rockchip,rk3568-rng.yaml
> +F:	Documentation/devicetree/bindings/rng/rockchip,rk3588-rng.yaml
>  F:	drivers/char/hw_random/rockchip-rng.c
> =20
>  ROCKCHIP RASTER 2D GRAPHIC ACCELERATION UNIT DRIVER
>=20
> --=20
> 2.48.1
>=20

--hYobnhEFDnkdMhyO
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iHUEABYIAB0WIQRh246EGq/8RLhDjO14tDGHoIJi0gUCZ5vIAQAKCRB4tDGHoIJi
0qgrAQCzakFSQyHjHTH6QESUz0gqsobwUVK1Lds0RZkRNrR/OAD/dXxihZAQuiUY
9ILx114VGQkUr92cCeWnQD49v7U/hwQ=
=wfH8
-----END PGP SIGNATURE-----

--hYobnhEFDnkdMhyO--
