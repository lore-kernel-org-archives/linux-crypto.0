Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F2E2612B171;
	Thu, 23 May 2024 14:37:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716475079; cv=none; b=k45eYa4f6bptQpT8jtLZ34r+0MQa4nciXD6LZvyeDDxxzQL4LSducFf2xdAoqa38NsDDMCNevj5V0cpRcnMbELbIj9uyN5tXQbJU+DDLeGWUNhkabmu28it3TqOZTPCJuNrNuJ4ZSzT5ok/YmF4iS09zWEYwiXRqA33LPERYTE0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716475079; c=relaxed/simple;
	bh=eT+HB+FXqP5lVZyAYj6JKHnhWvk/Ipdw9JdWIe8LzVM=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=O6JK2PS7GNs0ZgjMAeX6JDnTagRUO5fLedYubGp7d7sLA7StzVsmQO98U5C4NulryGmyymmobeMQXlIoBXok/iS2QOYS70TFuLGQxkdSctRf4oK6qBZsB5HtfMQ8FhOJrrSrjA/WLncDylCte41tV1x9SUw8pu09bPrLbYyejPw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=iGpvGW6a; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="iGpvGW6a"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0F929C2BD10;
	Thu, 23 May 2024 14:37:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1716475078;
	bh=eT+HB+FXqP5lVZyAYj6JKHnhWvk/Ipdw9JdWIe8LzVM=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=iGpvGW6a9yj3gWD7yyTWBWyh+7KuymQfmTC5VLzNGUETDnmwJO+vqyEup2aTcy1x1
	 v5+2jkf19i+w373ThyPSeHO9d0rLYRxZS2d5F53xFNhOr2JrIpZLCEvo9Kr6ZmXv50
	 3NNzg67yDi5QNGL2CJ6n2zsTvzkGIzpIsJaZ1haTVf2WYn9Q6tJ+PbjVHodEdmvjzJ
	 bjPz8XeRxfiznuHWYXGTwqzoNUxuEKq6sWfsOsBFUMvLfatQWrjvTFGYc/+BgVmMEe
	 Ybfm+/G9nXVsI+hCWBOhrluBHhkJUZe2NwH5vucQ75mnIY1Y+3GOXlPI87LCsVuN7A
	 E0tblaqOZHbrA==
Date: Thu, 23 May 2024 15:37:52 +0100
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
Message-ID: <20240523-snowiness-attain-75d415573b5a@spud>
References: <20240411133832.2896463-1-avromanov@salutedevices.com>
 <20240411133832.2896463-18-avromanov@salutedevices.com>
 <20240415-schnapps-plating-eb0895459004@spud>
 <20240506134754.jl633ncne7ct6szo@cab-wsm-0029881>
 <20240506-distrust-famine-6848f75dd3fe@spud>
 <20240523104624.tr5omyxnzxsjkpai@cab-wsm-0029881.sigma.sbrf.ru>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
	protocol="application/pgp-signature"; boundary="WTOLmlkXxsRP7sN+"
Content-Disposition: inline
In-Reply-To: <20240523104624.tr5omyxnzxsjkpai@cab-wsm-0029881.sigma.sbrf.ru>


--WTOLmlkXxsRP7sN+
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Thu, May 23, 2024 at 10:46:35AM +0000, Alexey Romanov wrote:
> Hi Conor,
>=20
> On Mon, May 06, 2024 at 04:47:29PM +0100, Conor Dooley wrote:
> > On Mon, May 06, 2024 at 01:48:01PM +0000, Alexey Romanov wrote:
> > > On Mon, Apr 15, 2024 at 05:43:15PM +0100, Conor Dooley wrote:
> > > > On Thu, Apr 11, 2024 at 04:38:26PM +0300, Alexey Romanov wrote:
> > > > > GXL crypto IP isn't connected to clk and seconnd interrput line,
> > > > > so we must remove them from dt-bindings.
> > > >=20
> > > > How does the device work without a clock?
> > >=20
> > > It's clocked by a common clock, the vendor didn't provide more
> > > information. It doesn't have any special clock domains.
> >=20
> > So the hardware block does have a clock, which, even if it is a clock
> > shared with other hardware blocks, makes your patch incorrect.
> >=20
> > Is the "blkmv" clock the shared clock?
>=20
> I received accurate information from the vendor. Starting from GXL,
> DMA engine is used for crypto HW and clock is hard weired to it (at RTL
> level).

> That's why we have to remove it from device tree, because we can't
> control it anyway.

That's not true, if the clock runs at a fixed frequency it should be
described as a fixed-clock in the devicetree.

--WTOLmlkXxsRP7sN+
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iHUEABYIAB0WIQRh246EGq/8RLhDjO14tDGHoIJi0gUCZk9UwAAKCRB4tDGHoIJi
0kgCAQCc036MitPTeOOqstfi4ri+q3xgSGemTaQQWCQjlD0qKAD+OwLXN5ySvreg
/MfIpImWvlSDrfrkLnC2nq4oV8AAmQg=
=NYsR
-----END PGP SIGNATURE-----

--WTOLmlkXxsRP7sN+--
