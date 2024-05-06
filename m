Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 719171553BC;
	Mon,  6 May 2024 15:47:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715010455; cv=none; b=MQob6i1BEfXi9i8G3xQKY/A0fT2exFtQuq0WROVkcZEgA42gKGLF0qscHxCtRL4jl1xbCNhFg0gZJmV5KCkB7Af6g0e7IBaQ0MA0Bj2b1OkLVT+1C4LFE3V/7dCPMgZSpr8jh8jpdQVwHbuOd+dVZyVtzP2+zJkVu2SbaNbIo7U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715010455; c=relaxed/simple;
	bh=h5Zn71IG11xUlo/JirQepQ3NK+G0HDNvWXGwp8rEKRk=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=RYjXeEwHp/8vkNprXQSx9gulIAiHHwSANs66VlJ7LWwPgGrCbdFEfhnPTU3MoIZKkjIPj9d/uUbLfL7eWhCspNXsJUiOeTVhX59bGWGyX3/Z/RyAKKGdLjgly9XzIRzlB4vLxd1AGlxjDggqsYEG/WEOU+CrK6zEUpZkw17Do5o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=OrWbB8pL; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="OrWbB8pL"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 763DAC116B1;
	Mon,  6 May 2024 15:47:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1715010454;
	bh=h5Zn71IG11xUlo/JirQepQ3NK+G0HDNvWXGwp8rEKRk=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=OrWbB8pLnQpbuok8zaRSW4weeZre/pSDnn9c2tYySH9JX9kJWrE37F6x7eT2huT80
	 Clrv1urIZSjstPQ8XCIxfUzJvo3I4G+YNz07kK2Q2LNZO+E4WUmEUTEVjrrlrabWGA
	 uJXyfwMLyE7RBgPfsxl6jnkvCsg5uo9vzWmnAoERrFehCcA8F+MJYPIcPN3QJ8BuMM
	 wZBcZpG7MUPRR+IeNpa/gzXd3wbQpMHB7W/q8Lrc/bMzsxJIz7NK/sipNbfBz3Re2Q
	 ZDX22+oOMwUrSP9ByqPsyJBNaU1SoROcrYHcxWU/wT8XC/5jFEhewp0wnBv9cTPPwW
	 q/jQ8zTQfv7EQ==
Date: Mon, 6 May 2024 16:47:29 +0100
From: Conor Dooley <conor@kernel.org>
To: Alexey Romanov <avromanov@salutedevices.com>
Cc: "neil.armstrong@linaro.org" <neil.armstrong@linaro.org>,
	"clabbe@baylibre.com" <clabbe@baylibre.com>,
	"herbert@gondor.apana.org.au" <herbert@gondor.apana.org.au>,
	"davem@davemloft.net" <davem@davemloft.net>,
	"robh+dt@kernel.org" <robh+dt@kernel.org>,
	"krzysztof.kozlowski+dt@linaro.org" <krzysztof.kozlowski+dt@linaro.org>,
	"conor+dt@kernel.org" <conor+dt@kernel.org>,
	"khilman@baylibre.com" <khilman@baylibre.com>,
	"jbrunet@baylibre.com" <jbrunet@baylibre.com>,
	"martin.blumenstingl@googlemail.com" <martin.blumenstingl@googlemail.com>,
	"vadim.fedorenko@linux.dev" <vadim.fedorenko@linux.dev>,
	"linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>,
	"linux-amlogic@lists.infradead.org" <linux-amlogic@lists.infradead.org>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	"devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
	"linux-arm-kernel@lists.infradead.org" <linux-arm-kernel@lists.infradead.org>,
	kernel <kernel@sberdevices.ru>
Subject: Re: [PATCH v7 17/23] dt-bindings: crypto: meson: remove clk and
 second interrupt line for GXL
Message-ID: <20240506-distrust-famine-6848f75dd3fe@spud>
References: <20240411133832.2896463-1-avromanov@salutedevices.com>
 <20240411133832.2896463-18-avromanov@salutedevices.com>
 <20240415-schnapps-plating-eb0895459004@spud>
 <20240506134754.jl633ncne7ct6szo@cab-wsm-0029881>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
	protocol="application/pgp-signature"; boundary="GdrLK7VTJWvHWU47"
Content-Disposition: inline
In-Reply-To: <20240506134754.jl633ncne7ct6szo@cab-wsm-0029881>


--GdrLK7VTJWvHWU47
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Mon, May 06, 2024 at 01:48:01PM +0000, Alexey Romanov wrote:
> On Mon, Apr 15, 2024 at 05:43:15PM +0100, Conor Dooley wrote:
> > On Thu, Apr 11, 2024 at 04:38:26PM +0300, Alexey Romanov wrote:
> > > GXL crypto IP isn't connected to clk and seconnd interrput line,
> > > so we must remove them from dt-bindings.
> >=20
> > How does the device work without a clock?
>=20
> It's clocked by a common clock, the vendor didn't provide more
> information. It doesn't have any special clock domains.

So the hardware block does have a clock, which, even if it is a clock
shared with other hardware blocks, makes your patch incorrect.

Is the "blkmv" clock the shared clock?

Cheers,
Conor.

> > > Fixes: 7f7d115dfb51 ("dt-bindings: crypto: Add DT bindings
> > > documentation for amlogic-crypto")
> > >=20
> > > Signed-off-by: Alexey Romanov <avromanov@salutedevices.com>
> > > ---
> > >  .../bindings/crypto/amlogic,gxl-crypto.yaml         | 13 +----------=
--
> > >  1 file changed, 1 insertion(+), 12 deletions(-)
> > >=20
> > > diff --git a/Documentation/devicetree/bindings/crypto/amlogic,gxl-cry=
pto.yaml b/Documentation/devicetree/bindings/crypto/amlogic,gxl-crypto.yaml
> > > index 948e11ebe4ee..d3af7b4d5f39 100644
> > > --- a/Documentation/devicetree/bindings/crypto/amlogic,gxl-crypto.yaml
> > > +++ b/Documentation/devicetree/bindings/crypto/amlogic,gxl-crypto.yaml
> > > @@ -20,20 +20,11 @@ properties:
> > >    interrupts:
> > >      items:
> > >        - description: Interrupt for flow 0
> > > -      - description: Interrupt for flow 1
> > > -
> > > -  clocks:
> > > -    maxItems: 1
> > > -
> > > -  clock-names:
> > > -    const: blkmv
> > > =20
> > >  required:
> > >    - compatible
> > >    - reg
> > >    - interrupts
> > > -  - clocks
> > > -  - clock-names
> > > =20
> > >  additionalProperties: false
> > > =20
> > > @@ -46,7 +37,5 @@ examples:
> > >      crypto: crypto-engine@c883e000 {
> > >          compatible =3D "amlogic,gxl-crypto";
> > >          reg =3D <0xc883e000 0x36>;
> > > -        interrupts =3D <GIC_SPI 188 IRQ_TYPE_EDGE_RISING>, <GIC_SPI =
189 IRQ_TYPE_EDGE_RISING>;
> > > -        clocks =3D <&clkc CLKID_BLKMV>;
> > > -        clock-names =3D "blkmv";
> > > +        interrupts =3D <GIC_SPI 188 IRQ_TYPE_EDGE_RISING>;
> > >      };
> > > --=20
> > > 2.34.1
> > >=20
>=20
>=20
>=20
>=20
> --=20
> Thank you,
> Alexey

--GdrLK7VTJWvHWU47
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iHUEABYIAB0WIQRh246EGq/8RLhDjO14tDGHoIJi0gUCZjj7kQAKCRB4tDGHoIJi
0l3kAQD5POkxdd7Ibsf2owlwltjfQ8u5NyntENYzmmppOVoEcQD+Jv1hTUFpdYX1
AIEdvzcVlt1l4S5vs5DnQz3ZOI72Uw4=
=nXAR
-----END PGP SIGNATURE-----

--GdrLK7VTJWvHWU47--
