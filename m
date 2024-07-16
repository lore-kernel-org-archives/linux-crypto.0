Received: from pidgin.makrotopia.org (pidgin.makrotopia.org [185.142.180.65])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 419B019AD4F;
	Tue, 16 Jul 2024 13:28:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=185.142.180.65
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1721136502; cv=none; b=Berwlq94ARz/IlFu5hsKY856Qn9Y6j5sXqphvg8QlGDxYirkondMF/XXnjYXQTHZ6St0CvvbCZcaf+jgaTLyBN3VMoFtw2hslb8a5O194fmHoJ35wYhb0HcK3dkUODhMtefAwcm3k54n8QjnpWGM9I7HgHQrilG1RXdGTcmuUNo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1721136502; c=relaxed/simple;
	bh=TF815M0MHPBYp/3TtLytnCXOCoWe3Z5Pimkt2dlp1GI=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=slmoB5Xqryj9TfVvY/P4D5/9SSFADGBKZW52FUkm/2Jz+KGz6h+r79O9rtHwM6FiZaLTv8sfmw7aYvAOcboqbk52mlg43LKmEDuARbFqbVb+06T9HDFW9qSRWDzI0WJROvQ7uYOtP7w0a+qwFNlvEXQv6sTTs7DzePyhbnS+esM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=makrotopia.org; spf=pass smtp.mailfrom=makrotopia.org; arc=none smtp.client-ip=185.142.180.65
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=makrotopia.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=makrotopia.org
Received: from local
	by pidgin.makrotopia.org with esmtpsa (TLS1.3:TLS_AES_256_GCM_SHA384:256)
	 (Exim 4.97.1)
	(envelope-from <daniel@makrotopia.org>)
	id 1sTiDR-000000003jW-40cV;
	Tue, 16 Jul 2024 13:27:38 +0000
Date: Tue, 16 Jul 2024 14:27:33 +0100
From: Daniel Golle <daniel@makrotopia.org>
To: Diederik de Haas <didi.debian@cknow.org>
Cc: Chen-Yu Tsai <wens@kernel.org>, Aurelien Jarno <aurelien@aurel32.net>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	Heiko Stuebner <heiko@sntech.de>,
	linux-rockchip@lists.infradead.org,
	Olivia Mackall <olivia@selenic.com>, Rob Herring <robh@kernel.org>,
	Krzysztof Kozlowski <krzk+dt@kernel.org>,
	Conor Dooley <conor+dt@kernel.org>,
	Philipp Zabel <p.zabel@pengutronix.de>,
	Dragan Simic <dsimic@manjaro.org>,
	Uwe =?iso-8859-1?Q?Kleine-K=F6nig?= <ukleinek@debian.org>,
	Sebastian Reichel <sebastian.reichel@collabora.com>,
	Cristian Ciocaltea <cristian.ciocaltea@collabora.com>,
	Sascha Hauer <s.hauer@pengutronix.de>,
	Martin Kaiser <martin@kaiser.cx>, Ard Biesheuvel <ardb@kernel.org>,
	linux-crypto@vger.kernel.org, devicetree@vger.kernel.org,
	linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v7 0/3] hwrng: add hwrng support for Rockchip RK3568
Message-ID: <ZpZ1RSSYaLo45kUI@makrotopia.org>
References: <cover.1720969799.git.daniel@makrotopia.org>
 <6425788.NZdkxuyfQg@bagend>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
	protocol="application/pgp-signature"; boundary="tknJYtWE5EdE/uFK"
Content-Disposition: inline
In-Reply-To: <6425788.NZdkxuyfQg@bagend>


--tknJYtWE5EdE/uFK
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Diederik,

On Tue, Jul 16, 2024 at 02:34:40PM +0200, Diederik de Haas wrote:
> [...]
> rngtest: starting FIPS tests...
> rngtest: bits received from input: 20000032
> rngtest: FIPS 140-2 successes: 362
> rngtest: FIPS 140-2 failures: 638
> rngtest: FIPS 140-2(2001-10-10) Monobit: 634
> rngtest: FIPS 140-2(2001-10-10) Poker: 106
> rngtest: FIPS 140-2(2001-10-10) Runs: 43
> rngtest: FIPS 140-2(2001-10-10) Long run: 0
> rngtest: FIPS 140-2(2001-10-10) Continuous run: 0
> rngtest: input channel speed: (min=3D2.638; avg=3D139.351; max=3D9765625.=
000)Kibits/s
> rngtest: FIPS tests speed: (min=3D21.169; avg=3D36.158; max=3D68.610)Mibi=
ts/s
> rngtest: Program run time: 148109761 microseconds
> =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
>=20
> That's almost twice as many failures as successes ...

That's bad news, and apparently different from Aurelien's initial
testing of the driver.

Can you try if the result is also that bad when using his version of
the driver:

https://patchwork.kernel.org/project/linux-arm-kernel/patch/20221128184718.=
1963353-3-aurelien@aurel32.net/

If so, we can try to increase RK_RNG_SAMPLE_CNT, and we may need
different values depending on the SoC...

--tknJYtWE5EdE/uFK
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iHUEABEIAB0WIQQ8WXOkSQLJP/KOu5qX7zeyq+FyywUCZpZ1PgAKCRCX7zeyq+Fy
y7a0AQCE/4d3YLgHabbloqz9iyKoj0GdIFZwjHK3KL4968XEDQD/ajA3gjz4QmH0
pQJAwVHNMGK6A9q8yQ6Rq+ZWpqvwmLM=
=3OSJ
-----END PGP SIGNATURE-----

--tknJYtWE5EdE/uFK--
