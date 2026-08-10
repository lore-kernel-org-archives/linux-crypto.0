Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 642F743746C;
	Mon, 10 Aug 2026 18:35:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786386952; cv=none; b=D6iWgQmEfRfg9lI1tIxImAmuRtvm/zJ3LyL/eMq4+Fkd+lyv+00swpZGI/n2NCTBsvPaIrsH0Vw36hvvxnWg245VM7R/PT+RrNLzRNEVY6dkofXz4/0DCikOdPZDkSX3ShkHxeBqfs9ft9WLF8gsJsyTQXZHs+7mG5Jvj+wTlVk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786386952; c=relaxed/simple;
	bh=J+7Qf4C+BCkphTM5Iv8Y9G8botn3Z1MPiWmfqLgbhk8=;
	h=Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=OcFiD7n8A4t3lBbYy9CYrOGVTrSDiqIDXZNeRb1a8rkze0SXN1baSughLM8gu8U+D6EQT3ZuhrlVtofl9M1b+lmOI810y4uSNhl1iG4jxC4OU9MA2vP1GzkU1iG9whPqhCqyMD9vd3oMv982AAl5E0KGhMXxRokJsF4HwMq4xb8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=HlzpUbYz; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="HlzpUbYz"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 02FA21F000E9;
	Mon, 10 Aug 2026 18:35:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1786386950;
	bh=J+7Qf4C+BCkphTM5Iv8Y9G8botn3Z1MPiWmfqLgbhk8=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References;
	b=HlzpUbYzcJ3KMfPEvXyW3Fdt/nE5/mxqLTwgQd16JMs1HWaHaTGufcH6czd6tgMZ3
	 q5k786zQ4Zphisf702b1r/G+BCt2fll3h81IcQ/S7RBIcdpBCzVhVl3q9xYVFRN2Vz
	 0GGN5j1vEs1t6jvao2VddGT+ws7pP6d+v2bHKphI1pn1tTPDEqyUsOX+KFYWVffcO0
	 KcPlP0Kgse5B/lTHtocl0cfyMJ+M/6J6ri+2vdoc/Av1RK3s5Sjfya7g2NycTE7g9y
	 gW0gdlCAV7+3XC0Z/bokVCVPUn6q4uJA4xXHDEl8ujcjS5IbLCpjdH5z2Aa43Yh0wB
	 d1O782y0QFKdw==
Date: Mon, 10 Aug 2026 11:35:48 -0700
From: Jakub Kicinski <kuba@kernel.org>
To: Vladislav Leonov <vlad@zlab.su>
Cc: linux-rockchip@lists.infradead.org,
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
 Rob Herring <robh@kernel.org>, Stephen Boyd <sboyd@kernel.org>, Uwe
 =?UTF-8?B?S2xlaW5lLUvDtm5pZw==?= <ukleinek@kernel.org>, Vinod Koul
 <vkoul@kernel.org>, linux-crypto@vger.kernel.org,
 linux-i2c@vger.kernel.org, linux-phy@lists.infradead.org,
 linux-pwm@vger.kernel.org, linux-spi@vger.kernel.org,
 linux-stm32@st-md-mailman.stormreply.com, linux-usb@vger.kernel.org,
 netdev@vger.kernel.org
Subject: Re: [PATCH 00/25] ARM: rockchip: Add peripheral support for RV1106
Message-ID: <20260810113548.7fd24d56@kernel.org>
In-Reply-To: <20260810121121.210040-1-vlad@zlab.su>
References: <20260810121121.210040-1-vlad@zlab.su>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Mon, 10 Aug 2026 15:10:51 +0300 Vladislav Leonov wrote:
> Basic support for the Rockchip RV1106/RV1103 SoCs currently under review.
> This series builds on top of that and enables the peripherals needed to
> bring up a board beyond a serial console:

Don't expect maintainers to dig out patches for their subsystems
from a big series. This is not how upstream development works.
Repost 4+5 as a separate series to networking..
