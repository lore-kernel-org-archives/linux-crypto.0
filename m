Received: from abb.hmeau.com (abb.hmeau.com [144.6.53.87])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CD65819469;
	Fri, 15 Dec 2023 09:58:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gondor.apana.org.au
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.94.2 #2 (Debian))
	id 1rE4xN-00BCkx-Cl; Fri, 15 Dec 2023 17:58:10 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Fri, 15 Dec 2023 17:58:19 +0800
Date: Fri, 15 Dec 2023 17:58:19 +0800
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Uwe =?iso-8859-1?Q?Kleine-K=F6nig?= <u.kleine-koenig@pengutronix.de>
Cc: Olivia Mackall <olivia@selenic.com>,
	Nicolas Ferre <nicolas.ferre@microchip.com>,
	Alexandre Belloni <alexandre.belloni@bootlin.com>,
	Claudiu Beznea <claudiu.beznea@tuxon.dev>,
	Rob Herring <robh@kernel.org>, linux-crypto@vger.kernel.org,
	linux-arm-kernel@lists.infradead.org, kernel@pengutronix.de,
	Hadar Gat <hadar.gat@arm.com>,
	=?utf-8?Q?=C5=81ukasz?= Stelmach <l.stelmach@samsung.com>,
	Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>,
	Alim Akhtar <alim.akhtar@samsung.com>,
	linux-samsung-soc@vger.kernel.org, Martin Kaiser <martin@kaiser.cx>,
	Avi Fishman <avifishman70@gmail.com>,
	Tomer Maimon <tmaimon77@gmail.com>,
	Tali Perry <tali.perry1@gmail.com>,
	Patrick Venture <venture@google.com>, Nancy Yuen <yuenn@google.com>,
	Benjamin Fair <benjaminfair@google.com>, openbmc@lists.ozlabs.org,
	Deepak Saxena <dsaxena@plexity.net>,
	Maxime Coquelin <mcoquelin.stm32@gmail.com>,
	Alexandre Torgue <alexandre.torgue@foss.st.com>,
	Gatien Chevallier <gatien.chevallier@foss.st.com>,
	linux-stm32@st-md-mailman.stormreply.com,
	Yangtao Li <frank.li@vivo.com>, Yu Zhe <yuzhe@nfschina.com>,
	Alexandru Ardelean <alex@shruggie.ro>,
	Andrei Coardos <aboutphysycs@gmail.com>
Subject: Re: [PATCH 00/12] hwrng: Convert to platform remove callback
 returning
Message-ID: <ZXwjO8m/Jm6HX+De@gondor.apana.org.au>
References: <cover.1702245873.git.u.kleine-koenig@pengutronix.de>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <cover.1702245873.git.u.kleine-koenig@pengutronix.de>

On Sun, Dec 10, 2023 at 11:12:15PM +0100, Uwe Kleine-König wrote:
> Hello,
> 
> this series converts all hwrng platform drivers to use .remove_new.
> See commit 5c5a7680e67b ("platform: Provide a remove callback that
> returns no value") for details and the eventual goal.
> 
> All driver conversions are trivial as all their remove callbacks return
> 0 (as good drivers should do).
> 
> All patches are pairwise independant. These patches should go in via the
> usual hwrng tree. It's merge window material.
> 
> Best regards
> Uwe
> 
> Uwe Kleine-König (12):
>   hwrng: atmel - Convert to platform remove callback returning void
>   hwrng: cctrng - Convert to platform remove callback returning void
>   hwrng: exynos - Convert to platform remove callback returning void
>   hwrng: ingenic - Convert to platform remove callback returning void
>   hwrng: ks-sa - Convert to platform remove callback returning void
>   hwrng: mxc - Convert to platform remove callback returning void
>   hwrng: n2 - Convert to platform remove callback returning void
>   hwrng: npcm - Convert to platform remove callback returning void
>   hwrng: omap - Convert to platform remove callback returning void
>   hwrng: stm32 - Convert to platform remove callback returning void
>   hwrng: timeriomem - Convert to platform remove callback returning void
>   hwrng: xgene - Convert to platform remove callback returning void
> 
>  drivers/char/hw_random/atmel-rng.c      | 6 ++----
>  drivers/char/hw_random/cctrng.c         | 6 ++----
>  drivers/char/hw_random/exynos-trng.c    | 6 ++----
>  drivers/char/hw_random/ingenic-rng.c    | 6 ++----
>  drivers/char/hw_random/ks-sa-rng.c      | 6 ++----
>  drivers/char/hw_random/mxc-rnga.c       | 6 ++----
>  drivers/char/hw_random/n2-drv.c         | 6 ++----
>  drivers/char/hw_random/npcm-rng.c       | 6 ++----
>  drivers/char/hw_random/omap-rng.c       | 6 ++----
>  drivers/char/hw_random/stm32-rng.c      | 6 ++----
>  drivers/char/hw_random/timeriomem-rng.c | 6 ++----
>  drivers/char/hw_random/xgene-rng.c      | 6 ++----
>  12 files changed, 24 insertions(+), 48 deletions(-)
> 
> 
> base-commit: bc63de6e6ba0b16652c5fb4b9c9916b9e7ca1f23
> -- 
> 2.42.0

All applied.  Thanks.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
