Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DAAB07263B;
	Tue, 11 Aug 2026 05:43:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786427000; cv=none; b=gf34OlNCjk+Ti8MmFIFEAxDLypWWzc78qOz+Q4pXoDPLaXi2un8AXktNth/luIgtfDl9KotB/dj+rZTExK9Pp7C+D8xj8AdON9BuZxSgy8cmy5BTrCZYYI4EXM6Sq/QncLxps6zL/gFPhUNQquu26+/C0SbK/drVUmDiQ73EJuQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786427000; c=relaxed/simple;
	bh=YMGTU+vf49B9TdnxXNYL8pil652GojAXCJRKNGBLc/w=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=mqE+GcKqSRmJsYL+wWDuTn2PjCu3I0R+lvcbuBU1YZSkPZ5++BFPjcSPACemX51bu0KSFqEPE8J+KyaNPSEBhWxlE7UGAtSGLuqZ0A4+fvsrcc96Wz61a62xRdRqsNit54ngLDfwdV9rBD09OwPviLMgwOeNx2463IW7q+VGrYQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Extm0du5; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Extm0du5"
Received: by smtp.kernel.org (Postfix) with UTF8SMTPSA id 8BDE61F000E9;
	Tue, 11 Aug 2026 05:43:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1786426999;
	bh=YMGTU+vf49B9TdnxXNYL8pil652GojAXCJRKNGBLc/w=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=Extm0du5n7L50sNNJpgM5PNYO8U2aUnoW7xIcOy0qQq1OG+1JkcD9nqWitFPDpd78
	 zEP9WTJzYlRiVkhXGneXd5MLP0weKKeXtrjhGf+qJEXM7FbBi8Tv0GD3gqvlHrnjE3
	 N2Y6gqBZFEg5bWlrxHDJ9OefwDnjT50hKkSOdhwkk+77PzQxfGq1Fjzc9pk9ZQF9K+
	 woDxKQOwqTW1icqSssV3Mco9Tt9eceuABCXQx17oS67EuQI2ZVs9e96J96yMjPCZbl
	 cXiTDwylteCFXODDBZu806lj45mQs0ju0rJw5A/MiCmL7AbL5iTHf6PRFiR/punGj+
	 heRkFRnTFpxqg==
Date: Tue, 11 Aug 2026 07:43:16 +0200
From: Uwe =?utf-8?Q?Kleine-K=C3=B6nig?= <ukleinek@kernel.org>
To: Jakub Kicinski <kuba@kernel.org>
Cc: Vladislav Leonov <vlad@zlab.su>, linux-rockchip@lists.infradead.org, 
	linux-arm-kernel@lists.infradead.org, Simon Glass <sjg@chromium.org>, linux-clk@vger.kernel.org, 
	devicetree@vger.kernel.org, linux-kernel@vger.kernel.org, 
	Alexandre Torgue <alexandre.torgue@foss.st.com>, Andi Shyti <andi.shyti@kernel.org>, 
	Andrew Lunn <andrew+netdev@lunn.ch>, Aurelien Jarno <aurelien@aurel32.net>, 
	Brian Masney <bmasney@redhat.com>, Conor Dooley <conor+dt@kernel.org>, 
	Daniel Golle <daniel@makrotopia.org>, "David S. Miller" <davem@davemloft.net>, 
	David Wu <david.wu@rock-chips.com>, Eric Dumazet <edumazet@google.com>, 
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>, Heiko Stuebner <heiko@sntech.de>, 
	Herbert Xu <herbert@gondor.apana.org.au>, Krzysztof Kozlowski <krzk+dt@kernel.org>, 
	Mark Brown <broonie@kernel.org>, Maxime Chevallier <maxime.chevallier@bootlin.com>, 
	Maxime Coquelin <mcoquelin.stm32@gmail.com>, Michael Turquette <mturquette@baylibre.com>, 
	Neil Armstrong <neil.armstrong@linaro.org>, Nicolas Frattaroli <nicolas.frattaroli@collabora.com>, 
	Olivia Mackall <olivia@selenic.com>, Paolo Abeni <pabeni@redhat.com>, 
	Philipp Zabel <p.zabel@pengutronix.de>, Rob Herring <robh@kernel.org>, Stephen Boyd <sboyd@kernel.org>, 
	Vinod Koul <vkoul@kernel.org>, linux-crypto@vger.kernel.org, linux-i2c@vger.kernel.org, 
	linux-phy@lists.infradead.org, linux-pwm@vger.kernel.org, linux-spi@vger.kernel.org, 
	linux-stm32@st-md-mailman.stormreply.com, linux-usb@vger.kernel.org, netdev@vger.kernel.org
Subject: Re: [PATCH 00/25] ARM: rockchip: Add peripheral support for RV1106
Message-ID: <anq1ouUnKA02Eauj@monoceros>
References: <20260810121121.210040-1-vlad@zlab.su>
 <20260810113548.7fd24d56@kernel.org>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="l56ppkyuc6yjydul"
Content-Disposition: inline
In-Reply-To: <20260810113548.7fd24d56@kernel.org>


--l56ppkyuc6yjydul
Content-Type: text/plain; protected-headers=v1; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable
Subject: Re: [PATCH 00/25] ARM: rockchip: Add peripheral support for RV1106
MIME-Version: 1.0

On Mon, Aug 10, 2026 at 11:35:48AM -0700, Jakub Kicinski wrote:
> On Mon, 10 Aug 2026 15:10:51 +0300 Vladislav Leonov wrote:
> > Basic support for the Rockchip RV1106/RV1103 SoCs currently under revie=
w.
> > This series builds on top of that and enables the peripherals needed to
> > bring up a board beyond a serial console:
>=20
> Don't expect maintainers to dig out patches for their subsystems
> from a big series. This is not how upstream development works.

I see this from time to time and I personally think it's fine to have
these patches together. Also the only the patch that affects my
subsystem was Cc:d to me which is how I like it (but I think opinions
differ on that one, too).

`b4 am -P _` is great!

> Repost 4+5 as a separate series to networking..

=2E.ooOO(It worked! :-)

Best regards
Uwe

--l56ppkyuc6yjydul
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCgAdFiEEP4GsaTp6HlmJrf7Tj4D7WH0S/k4FAmp6tnIACgkQj4D7WH0S
/k4zEQf+MYRctJ734gymTU2g5TLMo295bcq0j0eEePOAdI6qDQPd95D0hAtgUEkt
4cke2U6VUYvUyjrFyYBRIGUYGXlEBi8gWY+OEGO3fIZxlGHuQx78Dc6DP7G1Fwft
Ss7cDBRXPd6Rz4yUkuh8gv1ajvzZbP93qgNy+PYkPVurLQoBKMEckIJ62+Beltca
0+MG5Pptj/qnZAlIefzdk51PPWtMMzIUTP5PmOCIfE5HlxTcfLWKGiS01H0OIip6
q4Mj5mEEySKrAaGz9TBfGv0T1AJA6/Dbzqn8X9BKcuOQ4C0VxJ8T1nFhQzEBtCqw
f6yJy4qiT12FVPcrMFlEBIfbUoLrEg==
=aKZl
-----END PGP SIGNATURE-----

--l56ppkyuc6yjydul--
