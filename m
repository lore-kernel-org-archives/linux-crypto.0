Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E0D013CB2D4;
	Tue, 11 Aug 2026 16:06:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786464405; cv=none; b=h5jNatKUYb/WSGq6xcKgcLU/xgYtdEty13J6Ec7PguQWuZNgST3NL57A7O/jkcDFL3EnU+ea3UV3xPRipS2CStxbUoN7AjYLxUEiNsf5+02bOtNCez7Rv5Gi3/b34vmlOQNlrCwRlf1QdZXqMoNiMoqM2E9Rc+UbRdAClzYUeDw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786464405; c=relaxed/simple;
	bh=l6y6SBQuraQkb5VQ3z8ukPOghHgP1nT1Wtp4BjufNz0=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=T4g8F33OE0+fDacb3ecmG1sfp9zP0ORMIb+IeH8HqxSsPFWB26q2IhBEDylktjaYU0//lD7WO1/bCGvWNIaMQM4a/DBLkOclwn17je86XKkdL5kNfju0C/h1BHNv+1DdjATJn7XKx/Dpp+8UApKqt73CR7irXU8zmaSR8WPcr8U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=TYwtWdMZ; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="TYwtWdMZ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 00B111F000E9;
	Tue, 11 Aug 2026 16:06:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1786464403;
	bh=bsFrD+8bsJ8zTcQSeMYM7e3hb54WciAWCpQseABIlqk=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=TYwtWdMZ8Ao51ww1bhZblT18MUr7qDxkwcAcEbYPHbrC9TY069ydowFfdIi4cZ0Lv
	 ERS1UVOj9x3CsUP3r4umtrc1DF47emrHnID7XpG/ci5cVHd5IDDaSRmEJpHiVJDSyH
	 vUuQDBfUIX6WfjufpcE/0Gn8Bd0HaeK2cgvDMkxjyp3uK3tiT+Pw/tdqKkOJ9jtUNl
	 fwhqizf9b6nF61KCY8HGWkMJ7SKUjqwc2i2Os0BSGcDJ2jrNIWtKrwprSH2lDz7DSg
	 OzuRy9uqldfzfdgP9fiG6WWT7yuDL31/Ms1hpXehzZVDaIa8uIG5WJj4YWY5LAqds6
	 qlHnUwAcPLFqQ==
Date: Tue, 11 Aug 2026 17:06:33 +0100
From: Mark Brown <broonie@kernel.org>
To: Uwe =?iso-8859-1?Q?Kleine-K=F6nig?= <ukleinek@kernel.org>
Cc: Jakub Kicinski <kuba@kernel.org>, Vladislav Leonov <vlad@zlab.su>,
	linux-rockchip@lists.infradead.org,
	linux-arm-kernel@lists.infradead.org,
	Simon Glass <sjg@chromium.org>, linux-clk@vger.kernel.org,
	devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
	Alexandre Torgue <alexandre.torgue@foss.st.com>,
	Andi Shyti <andi.shyti@kernel.org>,
	Andrew Lunn <andrew+netdev@lunn.ch>,
	Aurelien Jarno <aurelien@aurel32.net>,
	Brian Masney <bmasney@redhat.com>,
	Conor Dooley <conor+dt@kernel.org>,
	Daniel Golle <daniel@makrotopia.org>,
	"David S. Miller" <davem@davemloft.net>,
	David Wu <david.wu@rock-chips.com>,
	Eric Dumazet <edumazet@google.com>,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	Heiko Stuebner <heiko@sntech.de>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	Krzysztof Kozlowski <krzk+dt@kernel.org>,
	Maxime Chevallier <maxime.chevallier@bootlin.com>,
	Maxime Coquelin <mcoquelin.stm32@gmail.com>,
	Michael Turquette <mturquette@baylibre.com>,
	Neil Armstrong <neil.armstrong@linaro.org>,
	Nicolas Frattaroli <nicolas.frattaroli@collabora.com>,
	Olivia Mackall <olivia@selenic.com>,
	Paolo Abeni <pabeni@redhat.com>,
	Philipp Zabel <p.zabel@pengutronix.de>,
	Rob Herring <robh@kernel.org>, Stephen Boyd <sboyd@kernel.org>,
	Vinod Koul <vkoul@kernel.org>, linux-crypto@vger.kernel.org,
	linux-i2c@vger.kernel.org, linux-phy@lists.infradead.org,
	linux-pwm@vger.kernel.org, linux-spi@vger.kernel.org,
	linux-stm32@st-md-mailman.stormreply.com, linux-usb@vger.kernel.org,
	netdev@vger.kernel.org
Subject: Re: [PATCH 00/25] ARM: rockchip: Add peripheral support for RV1106
Message-ID: <5842f89b-ef11-41fd-a5c6-f07d4110b65a@sirena.org.uk>
References: <20260810121121.210040-1-vlad@zlab.su>
 <20260810113548.7fd24d56@kernel.org>
 <anq1ouUnKA02Eauj@monoceros>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="0rdiv1roUnHM6tDX"
Content-Disposition: inline
In-Reply-To: <anq1ouUnKA02Eauj@monoceros>
X-Cookie: Now, let's SEND OUT for QUICHE!!


--0rdiv1roUnHM6tDX
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue, Aug 11, 2026 at 07:43:16AM +0200, Uwe Kleine-K=F6nig wrote:
> On Mon, Aug 10, 2026 at 11:35:48AM -0700, Jakub Kicinski wrote:

> > Don't expect maintainers to dig out patches for their subsystems
> > from a big series. This is not how upstream development works.

> I see this from time to time and I personally think it's fine to have
> these patches together. Also the only the patch that affects my
> subsystem was Cc:d to me which is how I like it (but I think opinions
> differ on that one, too).

Any cross tree thing is just always going to be more effort, at a
minimum you need to figure out if there are actually any dependencies or
if it's just a lot of tangentially related stuff bundled together.  Plus
the larger CC lists and whatever.

> `b4 am -P _` is great!

OTOH b4 won't ingest serieses unless it can commit them to git and I
have *no* idea what the base is supposed to be here, it's not my tree,
Linus' tree or -next.

Please resend the spi bits as a separate series.

--0rdiv1roUnHM6tDX
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCgAdFiEEreZoqmdXGLWf4p/qJNaLcl1Uh9AFAmp7SIgACgkQJNaLcl1U
h9CgzAf+Mfyz8kncpmkuFsip4V/KEWeY/74EiaopCxYZu9ER12XWRS+3hpvAP06t
FzE4FyJ4b5uGDeBclT3D4mSAIoI1xT63Br7sqmOlocnv85dq3wqcimH5FwpoisgP
5o7v5A2Bw9BkYeZW7XsKzJ2raxgqYKgQcbvIffN77mT78KVu2yBG3hkiD+PvJWLA
Kv2uKKzxmBely9BaCFeZ7M/N5D6vGZMhGDL+seRSttR6Xn+3sA1AAi3RKObAWLya
ZorJCLDgynNI5VEU2Jkv+oT3n0y9sdMToX9eDXrAI3JP8Vt4xncCBw2lhPerORRx
ULbQrEoR959v7lubt5ZIQdwdztM4uw==
=gZCM
-----END PGP SIGNATURE-----

--0rdiv1roUnHM6tDX--
