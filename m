Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 580EC382298;
	Tue, 11 Aug 2026 15:53:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786463596; cv=none; b=mHqiZjwQ7sLj21sOtjVkK3mD6lLaLUbvUsU1HY3Xy0tgXcvQ7p5WD/QKlkI+VbXIkivpf6Mn79WeBKg3clO+SqwzzUfqJM5SSAXJqD9EweY9tw6vdu6Vq0dIjnBVmmKjN+5O1XJHDJ6uyiWKrgHj7YfmDGtPDnxnPiUQReeUiec=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786463596; c=relaxed/simple;
	bh=DnF3aQdkXNx4oU+Fl+i9D15DW8KRXhFLW9FERxBFTB4=;
	h=Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=pf0KHz/HXir6hiHBh8EQCYWLAmM8nsnYEGLmNyDcgHNfqyeCodvDvwO/njwpYbgWBULQpwXgu9exwh9igBJ/qqfVIfDh712ck7FpyJ/bOj2+p9R7Bmy/hyN7tAos0ndRCmamC2CJYhNiY2NwgGrlafHXlIoBxzvHLrIZHfgUKqg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=AnBX8YUZ; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="AnBX8YUZ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B16171F000E9;
	Tue, 11 Aug 2026 15:53:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1786463595;
	bh=DnF3aQdkXNx4oU+Fl+i9D15DW8KRXhFLW9FERxBFTB4=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References;
	b=AnBX8YUZAaCz4DWFbJVo8gwN0rMr0SQ87izcGiOCA8nKHT0RqjFPMsRZojovf1ARD
	 R5XkNTvGzeFQAU5mg2idWrFbIwVVzAD9RSLBSFdfsCWYwNHz4H+gjbsAPn88kJWRk+
	 wveagclyOQ7huxROaH9sdj2yv6rNO1qXpteNII8BFYSFExL2MDPOcYxWHR7f3mm5LR
	 /jU41Z3dF5zhd1omvwkQVRIy5/zaud7PaVIy3tHMqxf3jNtOXwVGNc/ZXUC3X6uwqq
	 DjWjoFk+g0u02Vd8xPFPyxWH/V95eAmH0jPD/oqP3vkmOrLhHgrclkzlhC5O0382d6
	 uCdkZ/wtPpeJA==
Date: Tue, 11 Aug 2026 08:53:13 -0700
From: Jakub Kicinski <kuba@kernel.org>
To: Uwe =?UTF-8?B?S2xlaW5lLUvDtm5pZw==?= <ukleinek@kernel.org>
Cc: Vladislav Leonov <vlad@zlab.su>, linux-rockchip@lists.infradead.org,
 linux-arm-kernel@lists.infradead.org, Simon Glass <sjg@chromium.org>,
 linux-clk@vger.kernel.org, devicetree@vger.kernel.org,
 linux-kernel@vger.kernel.org, Alexandre Torgue
 <alexandre.torgue@foss.st.com>, Andi Shyti <andi.shyti@kernel.org>, Andrew
 Lunn <andrew+netdev@lunn.ch>, Aurelien Jarno <aurelien@aurel32.net>, Brian
 Masney <bmasney@redhat.com>, Conor Dooley <conor+dt@kernel.org>, Daniel
 Golle <daniel@makrotopia.org>, "David S. Miller" <davem@davemloft.net>,
 David Wu <david.wu@rock-chips.com>, Eric Dumazet <edumazet@google.com>,
 Greg Kroah-Hartman <gregkh@linuxfoundation.org>, Heiko Stuebner
 <heiko@sntech.de>, Herbert Xu <herbert@gondor.apana.org.au>, Krzysztof
 Kozlowski <krzk+dt@kernel.org>, Mark Brown <broonie@kernel.org>, Maxime
 Chevallier <maxime.chevallier@bootlin.com>, Maxime Coquelin
 <mcoquelin.stm32@gmail.com>, Michael Turquette <mturquette@baylibre.com>,
 Neil Armstrong <neil.armstrong@linaro.org>, Nicolas Frattaroli
 <nicolas.frattaroli@collabora.com>, Olivia Mackall <olivia@selenic.com>,
 Paolo Abeni <pabeni@redhat.com>, Philipp Zabel <p.zabel@pengutronix.de>,
 Rob Herring <robh@kernel.org>, Stephen Boyd <sboyd@kernel.org>, Vinod Koul
 <vkoul@kernel.org>, linux-crypto@vger.kernel.org,
 linux-i2c@vger.kernel.org, linux-phy@lists.infradead.org,
 linux-pwm@vger.kernel.org, linux-spi@vger.kernel.org,
 linux-stm32@st-md-mailman.stormreply.com, linux-usb@vger.kernel.org,
 netdev@vger.kernel.org
Subject: Re: [PATCH 00/25] ARM: rockchip: Add peripheral support for RV1106
Message-ID: <20260811085313.379ac489@kernel.org>
In-Reply-To: <anq1ouUnKA02Eauj@monoceros>
References: <20260810121121.210040-1-vlad@zlab.su>
	<20260810113548.7fd24d56@kernel.org>
	<anq1ouUnKA02Eauj@monoceros>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

On Tue, 11 Aug 2026 07:43:16 +0200 Uwe Kleine-K=C3=B6nig wrote:
> On Mon, Aug 10, 2026 at 11:35:48AM -0700, Jakub Kicinski wrote:
> > On Mon, 10 Aug 2026 15:10:51 +0300 Vladislav Leonov wrote: =20
> > > Basic support for the Rockchip RV1106/RV1103 SoCs currently under rev=
iew.
> > > This series builds on top of that and enables the peripherals needed =
to
> > > bring up a board beyond a serial console: =20
> >=20
> > Don't expect maintainers to dig out patches for their subsystems
> > from a big series. This is not how upstream development works. =20
>=20
> I see this from time to time and I personally think it's fine to have
> these patches together. Also the only the patch that affects my
> subsystem was Cc:d to me which is how I like it (but I think opinions
> differ on that one, too).
>=20
> `b4 am -P _` is great!

We have automation and CI systems which ignore anything that isn't
scoped to networking to save cost. Not sure if there's a polite way=20
to say this but the smaller the subsystem the more flexibility can=20
be afforded? Let's stick to the existing process, please.
