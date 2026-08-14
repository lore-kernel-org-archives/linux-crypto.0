Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9999A3E9584;
	Fri, 14 Aug 2026 10:19:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786702753; cv=none; b=bRL00gk6/9efycoSqdxzeGA7T8Lt3e79wb09HEbOF7yQ332zMRxJdue4Lc/q8R6c4c4KjmsSokwmJKV8j89hFbMT2Zzs+dRU+fnkLdgIgPEWZC4YBoIlZx9yJkaLe33Z3oomsuV06NS/dmEQXIYE3HhIYHJiThwJofG6cisbJb0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786702753; c=relaxed/simple;
	bh=K/JybFN4RV/75dALSWrTrUgHeP544FPa/fH1D6v5AEQ=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=IReUELg9MbgRlxUK9xaQPLC43WFqYypJM1eCfxZ+gVBwp+7ShzFtFmJn/Em9F8XoD5qYJ7R+S8j+H6EJ4Ad2ixwlSDpXAdBZ5k2IxoqX3hoBNML37b9DIi5764pLbMtpUntx5okRqHfS464T7NnRGTFgdN92/In2ynw2QATYCt4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=E/QXCTjI; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="E/QXCTjI"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3B73A1F000E9;
	Fri, 14 Aug 2026 10:18:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1786702742;
	bh=NXdGXpEaeSzo6LucHd30eYR/GtpdrDPatB4CgfYUQF4=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=E/QXCTjI36E8mBXEr6GvChfoeqasCRqIBQhD+HHSxLkNy/ZkATKjNyVKWxSFnDy3R
	 o01xFHf7H63TWszeKcUx7lJTvk6qMIXPWPoBzJ0h+EbMzWr9dH+9Qd9GE1k7YFp2TH
	 1sPCvaVkqjB7uR5mqkCfGoaaqNsu7Ki3477kNdUXzrn8/OMane3Gl+7vb5UHmJAvyp
	 tFmN/agBMSAAgKSRAth53CIWXe/CE7KXsmUdELHOi4gIJnxwIpn0l1InPUPcP0IFW6
	 jVhFtxWsRp0/vyYrS8gXqIVkj88/r3e3OoAwlgujhMK+I00XX6qpxww0bQsGeAptdA
	 Of4GkzD49p0Dg==
Date: Fri, 14 Aug 2026 12:18:45 +0200
From: Krzysztof Kozlowski <krzk@kernel.org>
To: Uwe =?utf-8?Q?Kleine-K=C3=B6nig?= <ukleinek@kernel.org>
Cc: Jakub Kicinski <kuba@kernel.org>, Vladislav Leonov <vlad@zlab.su>, 
	linux-rockchip@lists.infradead.org, linux-arm-kernel@lists.infradead.org, 
	Simon Glass <sjg@chromium.org>, linux-clk@vger.kernel.org, devicetree@vger.kernel.org, 
	linux-kernel@vger.kernel.org, Alexandre Torgue <alexandre.torgue@foss.st.com>, 
	Andi Shyti <andi.shyti@kernel.org>, Andrew Lunn <andrew+netdev@lunn.ch>, 
	Aurelien Jarno <aurelien@aurel32.net>, Brian Masney <bmasney@redhat.com>, 
	Conor Dooley <conor+dt@kernel.org>, Daniel Golle <daniel@makrotopia.org>, 
	"David S. Miller" <davem@davemloft.net>, David Wu <david.wu@rock-chips.com>, 
	Eric Dumazet <edumazet@google.com>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, 
	Heiko Stuebner <heiko@sntech.de>, Herbert Xu <herbert@gondor.apana.org.au>, 
	Krzysztof Kozlowski <krzk+dt@kernel.org>, Mark Brown <broonie@kernel.org>, 
	Maxime Chevallier <maxime.chevallier@bootlin.com>, Maxime Coquelin <mcoquelin.stm32@gmail.com>, 
	Michael Turquette <mturquette@baylibre.com>, Neil Armstrong <neil.armstrong@linaro.org>, 
	Nicolas Frattaroli <nicolas.frattaroli@collabora.com>, Olivia Mackall <olivia@selenic.com>, 
	Paolo Abeni <pabeni@redhat.com>, Philipp Zabel <p.zabel@pengutronix.de>, 
	Rob Herring <robh@kernel.org>, Stephen Boyd <sboyd@kernel.org>, Vinod Koul <vkoul@kernel.org>, 
	linux-crypto@vger.kernel.org, linux-i2c@vger.kernel.org, linux-phy@lists.infradead.org, 
	linux-pwm@vger.kernel.org, linux-spi@vger.kernel.org, 
	linux-stm32@st-md-mailman.stormreply.com, linux-usb@vger.kernel.org, netdev@vger.kernel.org
Subject: Re: [PATCH 00/25] ARM: rockchip: Add peripheral support for RV1106
Message-ID: <20260814-vivacious-nickel-copperhead-c746f6@quoll>
References: <20260810121121.210040-1-vlad@zlab.su>
 <20260810113548.7fd24d56@kernel.org>
 <anq1ouUnKA02Eauj@monoceros>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable
In-Reply-To: <anq1ouUnKA02Eauj@monoceros>

On Tue, Aug 11, 2026 at 07:43:16AM +0200, Uwe Kleine-K=C3=B6nig wrote:
> On Mon, Aug 10, 2026 at 11:35:48AM -0700, Jakub Kicinski wrote:
> > On Mon, 10 Aug 2026 15:10:51 +0300 Vladislav Leonov wrote:
> > > Basic support for the Rockchip RV1106/RV1103 SoCs currently under rev=
iew.
> > > This series builds on top of that and enables the peripherals needed =
to
> > > bring up a board beyond a serial console:
> >=20
> > Don't expect maintainers to dig out patches for their subsystems
> > from a big series. This is not how upstream development works.
>=20
> I see this from time to time and I personally think it's fine to have
> these patches together. Also the only the patch that affects my
> subsystem was Cc:d to me which is how I like it (but I think opinions
> differ on that one, too).
>=20
> `b4 am -P _` is great!

Yeah, and with DTS being patch 3, patch 6, 10 ...  and so on, it is
every easy to review and pick up.

No, there is only one case of combining multiple subsystems together -
upstreaming new SoC vendor. All other cases are wrong and spreading DTS
all over is just proof that this is poorly readable and poorly
reviewable.

Not even mentioning the rules of dependency on DTS expressed in
submitting patches.

Best regards,
Krzysztof

