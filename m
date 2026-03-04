Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4968E384244;
	Wed,  4 Mar 2026 22:29:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772663347; cv=none; b=cEtvn7jnCGOHDZU7Paz8wmP5f/f2zaAHjpv7hTyvhAOd9XkxI9oZaiT6P6Bk+3t9Mb0L1hfeM3wI7jMVL/oM1GxdUxfVqHPxbcCTxhD8MQ0Si1SCkR55HEDs0yZ02RI2gBv0Afu8ZVxb5f4PzcoDgRDyZa6NYCXj+ghmwCvPKpU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772663347; c=relaxed/simple;
	bh=ORYQQGNYlwnQgy888AgkqY1bU5sv3cRTXo0nb+aOkbU=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Sj69HTKAlBonuf6FpM28xFL6DT2ADmfxD08S35ZfPcs6wE9+WaN1HJW3mvCQ99Cx9k36d0w7WSv4QLG3AtVH+PdnoIHs6uUvUVz4/XezrQUuBQ4od73oMvNpAjvUCfh7sGm9QRUEjGsqYtDsZ9u2/zljWN+U6ZWKLcomnYk2+HU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=OU3WRITI; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="OU3WRITI"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 55AD0C4CEF7;
	Wed,  4 Mar 2026 22:29:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772663347;
	bh=ORYQQGNYlwnQgy888AgkqY1bU5sv3cRTXo0nb+aOkbU=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=OU3WRITIa8Au08wJ1jU2p9dBP01IwGSkDOCxNBL7XgBg6trhBqfW4Ma4uATYqAA9L
	 3ejgoDmg66mLFvZab4yEK1JF5QHuEDe6vcg7cH290T7LdhLrtp0LXXstY9WgkQK1b3
	 bIOThJ+xB6KrTCwwKCZuYoZ7vSuqGoCCm+7RvlXw1X+/XnXsNYE1FLGAKIxNGStdXa
	 P5MrB9tsMPJuk6qnOJNV0luFGZa0zafeMF19a7WtioPcW1+SQzTzVbEU2Hk2qlxW9u
	 OJSOemr7f22VbMRG6Vk5xBjr2DVGzuDTBtkkdh1xpelWs1ohTyOWIlzo/7wYYGlnPR
	 GG4+tsXGtc+aQ==
Date: Wed, 4 Mar 2026 22:29:02 +0000
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
Message-ID: <20260304-thinner-ungraded-67d7472b6c0b@spud>
References: <20260303193923.85242-1-olek2@wp.pl>
 <20260304-hardship-abreast-7a2d58cbe446@spud>
 <f9b266d7-f545-4088-b6c5-a0cc8676d60c@wp.pl>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="RUXrRWyOYYwphHi5"
Content-Disposition: inline
In-Reply-To: <f9b266d7-f545-4088-b6c5-a0cc8676d60c@wp.pl>


--RUXrRWyOYYwphHi5
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed, Mar 04, 2026 at 10:46:41PM +0100, Aleksander Jan Bajkowski wrote:
> Hi Conor,
>=20
> On 3/4/26 20:08, Conor Dooley wrote:
> > On Tue, Mar 03, 2026 at 08:39:17PM +0100, Aleksander Jan Bajkowski wrot=
e:
> > > Add the clock gate and reset line, both of which are available
> > > on the Airoha AN7581. Both properties are optional.
> > Why are they optional?
>=20
> No reason. In theory, a hardware designer could connect the reset
> to a fixed input signal. In practice, all SoCs on the market have
> a built-in reset and clock controller. I can mark them as required
> in the next revision.

Right, the reset could be optional on some systems, but sounds like it
is always there on the an7581. The clock is probably mandatory always.
I think you should make it required in the binding, but not in the
driver since that needs to work with existing devicetrees.
Technically this is an ABI break (new required property), so at least
mention in the commit message that you're aware of this.


>=20
> > > Signed-off-by: Aleksander Jan Bajkowski <olek2@wp.pl>
> > > ---
> > >   .../crypto/inside-secure,safexcel-eip93.yaml         | 12 +++++++++=
+++
> > >   1 file changed, 12 insertions(+)
> > >=20
> > > diff --git a/Documentation/devicetree/bindings/crypto/inside-secure,s=
afexcel-eip93.yaml b/Documentation/devicetree/bindings/crypto/inside-secure=
,safexcel-eip93.yaml
> > > index 997bf9717f9e..058454b679b4 100644
> > > --- a/Documentation/devicetree/bindings/crypto/inside-secure,safexcel=
-eip93.yaml
> > > +++ b/Documentation/devicetree/bindings/crypto/inside-secure,safexcel=
-eip93.yaml
> > > @@ -48,6 +48,12 @@ properties:
> > >     interrupts:
> > >       maxItems: 1
> > > +  clocks:
> > > +    maxItems: 1
> > > +
> > > +  resets:
> > > +    maxItems: 1
> > > +
> > >   required:
> > >     - compatible
> > >     - reg
> > > @@ -57,11 +63,17 @@ additionalProperties: false
> > >   examples:
> > >     - |
> > > +    #include <dt-bindings/clock/en7523-clk.h>
> > >       #include <dt-bindings/interrupt-controller/arm-gic.h>
> > > +    #include <dt-bindings/reset/airoha,en7581-reset.h>
> > >       crypto@1e004000 {
> > >         compatible =3D "airoha,en7581-eip93", "inside-secure,safexcel=
-eip93ies";
> > >         reg =3D <0x1fb70000 0x1000>;
> > > +      clocks =3D <&scuclk EN7523_CLK_CRYPTO>;
> > > +
> > >         interrupts =3D <GIC_SPI 44 IRQ_TYPE_LEVEL_HIGH>;
> > > +
> > > +      resets =3D <&scuclk EN7581_CRYPTO_RST>;
> > >       };
> > > --=20
> > > 2.47.3
> > >=20
> Best regards,
> Aleksander
>=20
>=20

--RUXrRWyOYYwphHi5
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iHUEABYKAB0WIQRh246EGq/8RLhDjO14tDGHoIJi0gUCaaiyLQAKCRB4tDGHoIJi
0ibOAQCXhDFN8QSYrxF47Qb/oFi3wBnPBFiMdgbEvxrc67IdFAEAyO/3v3UV4NE5
KvSZXTUIkTs0eodNUYw8zdjOzJ0vQAE=
=6PiR
-----END PGP SIGNATURE-----

--RUXrRWyOYYwphHi5--
