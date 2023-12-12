Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B056D28E6;
	Tue, 12 Dec 2023 16:35:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="EGoV0FXb"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 60FC4C433CA;
	Tue, 12 Dec 2023 16:35:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1702398911;
	bh=mMmJmC+q52Hml5ofl8CP4lRLUI3hn5sN9ppbWyRuzNQ=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=EGoV0FXbAwukl1l0MwB7ef/rsDx1WCzrP4ggfOmlRwwdxSkUnuZh6YzYwzUSbHYE/
	 BqAR5kZoq7vFg+i7G3qIVF5ytIOTXKgj/TAVssnIRm7pdCp8C1h2lgbggJiJSPvrBJ
	 K4qvuJFQQhJ+Z2+u1XNuaSvXgx0c6zgJusk+foLwo1KqNoJgd4e8jCUa1DfJDni3xm
	 wlu+HGThEnNQ0wai/MuSA9lkd+l4gJ05UHRHNmpYB0l7wr0T6tkJzHx1R6EW9NDOLG
	 IA38nd1lLu4lAJ+DjyG8M0apsLG19cPwN5KE09/hY2pJnSvbvUiXkdCnmhAXUIKY4U
	 tQizSL2wR2KLA==
Date: Tue, 12 Dec 2023 16:35:07 +0000
From: Conor Dooley <conor@kernel.org>
To: Jia Jie Ho <jiajie.ho@starfivetech.com>
Cc: Olivia Mackall <olivia@selenic.com>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	Rob Herring <robh+dt@kernel.org>,
	Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>,
	Conor Dooley <conor+dt@kernel.org>, linux-crypto@vger.kernel.org,
	devicetree@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 1/2] dt-bindings: rng: starfive: Add jh8100 compatible
 string
Message-ID: <20231212-freely-familiar-f19c2e14c417@spud>
References: <20231212032527.1250617-1-jiajie.ho@starfivetech.com>
 <20231212032527.1250617-2-jiajie.ho@starfivetech.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
	protocol="application/pgp-signature"; boundary="wKaAqqtx0HcURug5"
Content-Disposition: inline
In-Reply-To: <20231212032527.1250617-2-jiajie.ho@starfivetech.com>


--wKaAqqtx0HcURug5
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue, Dec 12, 2023 at 11:25:26AM +0800, Jia Jie Ho wrote:
> Add compatible string for StarFive JH8100 trng.
>=20
> Signed-off-by: Jia Jie Ho <jiajie.ho@starfivetech.com>

Acked-by: Conor Dooley <conor.dooley@microchip.com>

Cheers,
Conor.

> ---
>  .../devicetree/bindings/rng/starfive,jh7110-trng.yaml       | 6 +++++-
>  1 file changed, 5 insertions(+), 1 deletion(-)
>=20
> diff --git a/Documentation/devicetree/bindings/rng/starfive,jh7110-trng.y=
aml b/Documentation/devicetree/bindings/rng/starfive,jh7110-trng.yaml
> index 2b76ce25acc4..4639247e9e51 100644
> --- a/Documentation/devicetree/bindings/rng/starfive,jh7110-trng.yaml
> +++ b/Documentation/devicetree/bindings/rng/starfive,jh7110-trng.yaml
> @@ -11,7 +11,11 @@ maintainers:
> =20
>  properties:
>    compatible:
> -    const: starfive,jh7110-trng
> +    oneOf:
> +      - items:
> +          - const: starfive,jh8100-trng
> +          - const: starfive,jh7110-trng
> +      - const: starfive,jh7110-trng
> =20
>    reg:
>      maxItems: 1
> --=20
> 2.34.1
>=20

--wKaAqqtx0HcURug5
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iHUEABYIAB0WIQRh246EGq/8RLhDjO14tDGHoIJi0gUCZXiLuwAKCRB4tDGHoIJi
0uEMAP49L1RqAzELTRn4hY+Ff+rzCrdw6w5GIjrpiqAIxF4yyAEA3Aq4Vbym8J2L
4Z/yc6Qm/2bLhA2ICyLVlC/hCPfDTQo=
=0CMW
-----END PGP SIGNATURE-----

--wKaAqqtx0HcURug5--
