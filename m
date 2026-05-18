Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2250948A2D1;
	Mon, 18 May 2026 16:42:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779122544; cv=none; b=Obju1NIk/VqZiTabRnHJNWmHrd1Y6RUvYPLz1rd/4pIaHxi1x2A5l3B2iKdgnsdmGAN3G+YdoR+LbOgxwyRXHVvmK1JFV2FGxrvTwY/qe3yvlF4gwFe4MNjjl8JfkQYCEeiqFGHABqH8MpoDU6KwVvFJsxvDCBuGP7CzQXPxYio=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779122544; c=relaxed/simple;
	bh=8jlbmHRiv6Q4k9uCO1g8WOW0Kyq+w472ceiKeQ5WnKI=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=hcMyJSV/5Gwa9WbnsPtSbw4Nc8ZEmUpDi4zq6ovLDEE40xcGo3ooK1MVFE4/69tWem0WBTT0CBRO5SzAs6z+XzXXErDu98FI/8C4y5vUYdqmPrDi9S7zveb3irCIQKcuKpzqxPkL6y+YTl3Tir2MtoU7sKR4wUz/Fl/slYW0pvI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=UUfE2YNw; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="UUfE2YNw"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C29E9C2BCB7;
	Mon, 18 May 2026 16:42:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1779122543;
	bh=8jlbmHRiv6Q4k9uCO1g8WOW0Kyq+w472ceiKeQ5WnKI=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=UUfE2YNwnixtFDmrhhKtnVbpqEjhI9C8j3Cw9POgq5GWUYLke8V7F2zlnHvI43blX
	 XDMY59MWbt5SvFiHHpSsglHNAurHvr6adUo4s86ri+Gvf28r2ZIjJ0LdsmA9e8CaMM
	 ujvwdkQS3vycBE071caobnV3UEtOezTI8qnnODdb57qQR/KYG4aD4ywf5FRNAI1OW+
	 LN/Y8APkhzn2hMGZDte92t19zkr3RQ95zFsSGXim2UHPwaya3i/qARQjHnBrGfN9UD
	 R7QpOOVQDmZ2EwfvOBX60XiKdzX1dyqiCAvMUmpdPZTsosWEZm5hX6dpeTP0p3CnJv
	 9RYZCj2gY0MlA==
Date: Mon, 18 May 2026 17:42:19 +0100
From: Conor Dooley <conor@kernel.org>
To: "lianfeng.ouyang" <lianfeng.ouyang@starfivetech.com>
Cc: Olivia Mackall <olivia@selenic.com>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	Rob Herring <robh@kernel.org>,
	Krzysztof Kozlowski <krzk+dt@kernel.org>,
	Conor Dooley <conor+dt@kernel.org>,
	Philipp Zabel <p.zabel@pengutronix.de>,
	linux-crypto@vger.kernel.org, devicetree@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 1/2] dt-bindings: Add bindings for StarFive JHB100 SoC
 trng controller
Message-ID: <20260518-sixteen-moaning-7e741628c20f@spud>
References: <20260518065243.20865-1-lianfeng.ouyang@starfivetech.com>
 <20260518065243.20865-2-lianfeng.ouyang@starfivetech.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="QM5KTRJyXWmV6uoZ"
Content-Disposition: inline
In-Reply-To: <20260518065243.20865-2-lianfeng.ouyang@starfivetech.com>


--QM5KTRJyXWmV6uoZ
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Mon, May 18, 2026 at 02:52:42PM +0800, lianfeng.ouyang wrote:
> From: Lianfeng Ouyang <lianfeng.ouyang@starfivetech.com>
>=20
> jh8100 is no longer supported
> Jia Jie Ho has resigned

Please put some effort into your commit messages. Look around on LKML,
where do you ever seen commit messages as perfunctory as this?
Please speak to the other developers at Starfive about what the commit
messages should look like.

The first "sentence" here isn't even really accurate, is it?
The jh8100 was never even released to customers, right?

pw-bot: changes-requested

Thanks,
Conor.

>=20
> Signed-off-by: Lianfeng Ouyang <lianfeng.ouyang@starfivetech.com>
> ---
>  .../devicetree/bindings/rng/starfive,jh7110-trng.yaml  | 10 ++++------
>  1 file changed, 4 insertions(+), 6 deletions(-)
>=20
> diff --git a/Documentation/devicetree/bindings/rng/starfive,jh7110-trng.y=
aml b/Documentation/devicetree/bindings/rng/starfive,jh7110-trng.yaml
> index 4639247e9e51..d21769b7d54e 100644
> --- a/Documentation/devicetree/bindings/rng/starfive,jh7110-trng.yaml
> +++ b/Documentation/devicetree/bindings/rng/starfive,jh7110-trng.yaml
> @@ -7,15 +7,13 @@ $schema: http://devicetree.org/meta-schemas/core.yaml#
>  title: StarFive SoC TRNG Module
>=20
>  maintainers:
> -  - Jia Jie Ho <jiajie.ho@starfivetech.com>
> +  - Lianfeng Ouyang <lianfeng.ouyang@starfivetech.com>
>=20
>  properties:
>    compatible:
> -    oneOf:
> -      - items:
> -          - const: starfive,jh8100-trng
> -          - const: starfive,jh7110-trng
> -      - const: starfive,jh7110-trng
> +    enum:
> +      - starfive,jh7110-trng
> +      - starfive,jhb100-trng
>=20
>    reg:
>      maxItems: 1
> --
> 2.43.0
>=20
>=20

--QM5KTRJyXWmV6uoZ
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iHUEABYKAB0WIQRh246EGq/8RLhDjO14tDGHoIJi0gUCagtBawAKCRB4tDGHoIJi
0qHWAP94OWjU9KzGg5I7JiQ2Hp0IkMGoDm/z9zpOmNUzOtA7gwEAnKcicMUHgCQv
0kZRPPsyaDF4TbQjGs4WuglvfUtvKgA=
=fR4o
-----END PGP SIGNATURE-----

--QM5KTRJyXWmV6uoZ--
