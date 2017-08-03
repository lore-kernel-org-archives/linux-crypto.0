From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH v6 3/3] hwrng: add a driver for Freescale RNGC
Date: Thu, 3 Aug 2017 14:26:00 +0800
Message-ID: <20170803062600.GM12039@gondor.apana.org.au>
References: <1457705200-16951-1-git-send-email-s.trumtrar@pengutronix.de>
 <1500832146-8660-1-git-send-email-martin@kaiser.cx>
 <1500832146-8660-3-git-send-email-martin@kaiser.cx>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Steffen Trumtrar <s.trumtrar@pengutronix.de>,
        Shawn Guo <shawnguo@kernel.org>,
        PrasannaKumar Muralidharan <prasannatsmkumar@gmail.com>,
        Mark Rutland <mark.rutland@arm.com>,
        devicetree@vger.kernel.org, Rob Herring <robh+dt@kernel.org>,
        linux-crypto@vger.kernel.org, kernel@pengutronix.de,
        Fabio Estevam <festevam@gmail.com>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
To: Martin Kaiser <martin@kaiser.cx>
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1500832146-8660-3-git-send-email-martin@kaiser.cx>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

On Sun, Jul 23, 2017 at 07:49:06PM +0200, Martin Kaiser wrote:
> The driver is ported from Freescale's Linux git and can be
> found in the
> 
> 	vendor/freescale/imx_2.6.35_maintain
> 
> branch.
> 
> The driver supports both RNG version C that's part of some Freescale
> i.MX3 SoCs and version B that is available on i.MX2x chipsets.
> 
> Signed-off-by: Steffen Trumtrar <s.trumtrar@pengutronix.de>
> Signed-off-by: Martin Kaiser <martin@kaiser.cx>
> Reviewed-by: PrasannaKumar Muralidharan <prasannatsmkumar@gmail.com>

Patch applied.  Thanks.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
