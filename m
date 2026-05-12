Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C3515357CE8;
	Tue, 12 May 2026 19:35:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778614550; cv=none; b=T6zuIBlMxTwx6IAupsH4/HJnD4LZK+aV3tCx9uJ+JrZpMDyNwoYiuwe3A6Y1JjBHClG/kl9+LG4tY41Vn+V+U06jsCazHYFpVobKlwUKA3l6WNtdKV552TJgoXcufSXJfZcVkEs+hPgpLl0vL1mmRZeKkqeKZp8E2mI8uGrAllo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778614550; c=relaxed/simple;
	bh=7NVPzVRb0nY7beoHUKmklcrEYtRmy5vwDq7e4NZMy+8=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=b4QUOjapazGT8Z7mOJcWNYw/pSZrfThU7l3vKAzBLxxaqLgOfYN5C20aEH1Mv8dWt3fyZT3ZNkbw9oxa6h08WMyNAKgmsTAu9lTYgwWHplQEvSJUBdOvsd4/21sLcocjqllZkjirHpfG+Q4ipfsqrTEOxH5FRAK/9/cX99u8EnI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=hlogafxn; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="hlogafxn"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6B95AC2BCB0;
	Tue, 12 May 2026 19:35:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1778614550;
	bh=7NVPzVRb0nY7beoHUKmklcrEYtRmy5vwDq7e4NZMy+8=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=hlogafxntglbnLXGB0y5LuFx7G8O233LmrI3jjSNtkEZT4rMQ6i0+997Nr2pFcGMZ
	 DHnJyyDf3sx/WtKOt2QwYg/7JUdAysEv9cSQXy5NXfxRx62jVL8CJda9X4auMmvQhm
	 jRKyyYTeY0t2IGBTfUbbv277EWoqRIHyo3uIpz0Dzdr+9T6ZmJ5RCkfUqxHEpTMLGa
	 1jxU6bUe3tWh1p1O8i5j+VrGQXLD1gV+/mdpmy0n/1rmWPhYNVnVr6o5mCE0LEbKEq
	 ZNIwNuCv7ZLlDESzhQah63q4Q/Hu4ioGFBHEbKQ4xQw8eWOQErTxu/xTbrtu1iu2/s
	 WLdr8QeFIoeXg==
Date: Tue, 12 May 2026 20:35:46 +0100
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
Subject: Re: [PATCH v1 1/2] dt-bindings: Add bindings for StarFive JHB100 SoC
 trng controller.
Message-ID: <20260512-rifling-granny-a467a53ef289@spud>
References: <20260512062404.4540-1-lianfeng.ouyang@starfivetech.com>
 <20260512062404.4540-2-lianfeng.ouyang@starfivetech.com>
 <20260512-seventeen-deduct-fa7eead281ef@spud>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="n/I/LELljbV1+Pgt"
Content-Disposition: inline
In-Reply-To: <20260512-seventeen-deduct-fa7eead281ef@spud>


--n/I/LELljbV1+Pgt
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue, May 12, 2026 at 06:15:07PM +0100, Conor Dooley wrote:
> On Tue, May 12, 2026 at 02:24:03PM +0800, lianfeng.ouyang wrote:
> > From: Lianfeng Ouyang <lianfeng.ouyang@starfivetech.com>
> >=20
> > Signed-off-by: Lianfeng Ouyang <lianfeng.ouyang@starfivetech.com>
> > ---
> >  Documentation/devicetree/bindings/rng/starfive,jh7110-trng.yaml | 2 +-
> >  1 file changed, 1 insertion(+), 1 deletion(-)
> >=20
> > diff --git a/Documentation/devicetree/bindings/rng/starfive,jh7110-trng=
=2Eyaml b/Documentation/devicetree/bindings/rng/starfive,jh7110-trng.yaml
> > index 4639247e9e51..11346d77b2f6 100644
> > --- a/Documentation/devicetree/bindings/rng/starfive,jh7110-trng.yaml
> > +++ b/Documentation/devicetree/bindings/rng/starfive,jh7110-trng.yaml
> > @@ -13,8 +13,8 @@ properties:
> >    compatible:
> >      oneOf:
> >        - items:
> > -          - const: starfive,jh8100-trng
> >            - const: starfive,jh7110-trng
> > +          - const: starfive,jhb100-trng
>=20
> You need to add a commit message here explaining why removing the jh8100
> is okay.
> pw-bot: changes-requested

Additionally, given the driver changes, it looks like using a jh7110
fallback is invalid anyway.

>=20
> >        - const: starfive,jh7110-trng
> > =20
> >    reg:
> > --=20
> > 2.43.0
> >=20
> >=20



--n/I/LELljbV1+Pgt
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iHUEABYKAB0WIQRh246EGq/8RLhDjO14tDGHoIJi0gUCagOBEgAKCRB4tDGHoIJi
0ryHAQDH/C1ma7gWroAZs5dMsTChdj5rTvft8uSvhh+RXEnqzgEAgytZUs5yMUyk
hsx3BOvpe+PYO3K3t1WSfVKjYG9MfAM=
=AoJP
-----END PGP SIGNATURE-----

--n/I/LELljbV1+Pgt--
