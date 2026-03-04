Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 29F3D3CD8BD;
	Wed,  4 Mar 2026 19:09:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772651345; cv=none; b=OYe1EbzO+MmVlCXgHsJwVIkvMXv6pWvNRtk9/TSApuDUiu4+J5o3C4A14YhYOW/KUcF3urYrMkfY4Q18O+xrbmPIWrzPvB8O0ol/BE5rW/JI+R/kGs+ZPdXkNlj4z4zSX+6ti3pwOsT2ZxfWXuP9sT9ULAcX4kGfzmVqlYN2EaM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772651345; c=relaxed/simple;
	bh=+qb4Y2WkmElXR9Cy7wmVw2lZ111N906ZQK11dhQZq+w=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=L0/PW1ebTRdoIa1IKUDhHeRL3q52rqPa0mIv1JZ8QDL3j0/K+NFch1arUeaMRPyli6057TRH8NepUPOV/ItQZQk7GMT5XYu2H73aqJFlDSIyYkLE671D7fG8Cpn6PHdwogeFKslQE/sF1GcCk9L4oIPPKJvCtDZ7ifHWTEfxSHY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=QvO5DLuz; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="QvO5DLuz"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D0D4BC4CEF7;
	Wed,  4 Mar 2026 19:09:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772651344;
	bh=+qb4Y2WkmElXR9Cy7wmVw2lZ111N906ZQK11dhQZq+w=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=QvO5DLuzqQwEZhr4I89jFVDl6g07LdFrOEAFT99e6LVcLGMXYzYfJVjkwgPawfWGA
	 GtvyhOM+HdbZBfDcqKVwTvIUVW5zoYkRy/dhsU8FZxVwV8ryqvZdUDQvT+6ag+F2vx
	 iMI5SBC7F25IcY852UxhxMShCS7tcw5YBnfhQkrTNMOUev+VOhsmjtkr5COq5/MSlh
	 hARMN1XOuslc/VKZNywt24+QOwcUNGAQA242LEuJBhemjA5RjvgaLiuRQQNhafSxfF
	 H4haXmbP7VTk93FvVhDsxXXgLblVzJtvckmE3DezOUAr4kYwc4ItwP4wHWetmQpQO2
	 x0gkV8g6tvqtA==
Date: Wed, 4 Mar 2026 19:08:59 +0000
From: Conor Dooley <conor@kernel.org>
To: Aleksander Jan Bajkowski <olek2@wp.pl>
Cc: ansuelsmth@gmail.com, herbert@gondor.apana.org.au, davem@davemloft.net,
	matthias.bgg@gmail.com, angelogioacchino.delregno@collabora.com,
	robh@kernel.org, krzk+dt@kernel.org, conor+dt@kernel.org,
	lorenzo@kernel.org, linux-arm-kernel@lists.infradead.org,
	linux-mediatek@lists.infradead.org, linux-crypto@vger.kernel.org,
	devicetree@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/2] dt-bindings: crypto: eip93: add clock gate and reset
 line
Message-ID: <20260304-hardship-abreast-7a2d58cbe446@spud>
References: <20260303193923.85242-1-olek2@wp.pl>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="XxcjsSvyQL4G5pyd"
Content-Disposition: inline
In-Reply-To: <20260303193923.85242-1-olek2@wp.pl>


--XxcjsSvyQL4G5pyd
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue, Mar 03, 2026 at 08:39:17PM +0100, Aleksander Jan Bajkowski wrote:
> Add the clock gate and reset line, both of which are available
> on the Airoha AN7581. Both properties are optional.

Why are they optional?

>=20
> Signed-off-by: Aleksander Jan Bajkowski <olek2@wp.pl>
> ---
>  .../crypto/inside-secure,safexcel-eip93.yaml         | 12 ++++++++++++
>  1 file changed, 12 insertions(+)
>=20
> diff --git a/Documentation/devicetree/bindings/crypto/inside-secure,safex=
cel-eip93.yaml b/Documentation/devicetree/bindings/crypto/inside-secure,saf=
excel-eip93.yaml
> index 997bf9717f9e..058454b679b4 100644
> --- a/Documentation/devicetree/bindings/crypto/inside-secure,safexcel-eip=
93.yaml
> +++ b/Documentation/devicetree/bindings/crypto/inside-secure,safexcel-eip=
93.yaml
> @@ -48,6 +48,12 @@ properties:
>    interrupts:
>      maxItems: 1
> =20
> +  clocks:
> +    maxItems: 1
> +
> +  resets:
> +    maxItems: 1
> +
>  required:
>    - compatible
>    - reg
> @@ -57,11 +63,17 @@ additionalProperties: false
> =20
>  examples:
>    - |
> +    #include <dt-bindings/clock/en7523-clk.h>
>      #include <dt-bindings/interrupt-controller/arm-gic.h>
> +    #include <dt-bindings/reset/airoha,en7581-reset.h>
> =20
>      crypto@1e004000 {
>        compatible =3D "airoha,en7581-eip93", "inside-secure,safexcel-eip9=
3ies";
>        reg =3D <0x1fb70000 0x1000>;
> =20
> +      clocks =3D <&scuclk EN7523_CLK_CRYPTO>;
> +
>        interrupts =3D <GIC_SPI 44 IRQ_TYPE_LEVEL_HIGH>;
> +
> +      resets =3D <&scuclk EN7581_CRYPTO_RST>;
>      };
> --=20
> 2.47.3
>=20

--XxcjsSvyQL4G5pyd
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iHUEABYKAB0WIQRh246EGq/8RLhDjO14tDGHoIJi0gUCaaiDSwAKCRB4tDGHoIJi
0kFdAQDa2xGAEXWTcsZnWZ+DqPQeS9mrnJ5G8gdZkyafZYSJmAD/Vur2DZEbjjta
PQB3sWJGJCz1S70yK3n9JmMjSmGN9gk=
=5r04
-----END PGP SIGNATURE-----

--XxcjsSvyQL4G5pyd--
