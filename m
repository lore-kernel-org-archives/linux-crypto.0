From: Rob Herring <robh@kernel.org>
Subject: Re: [PATCH v2 1/3] Documentation: devicetree: add Freescale RNGC
 binding
Date: Fri, 18 Mar 2016 14:42:13 -0500
Message-ID: <20160318194213.GA10766@rob-hp-laptop>
References: <1457705200-16951-1-git-send-email-s.trumtrar@pengutronix.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Shawn Guo <shawnguo@kernel.org>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	Matt Mackall <mpm@selenic.com>,
	Pawel Moll <pawel.moll@arm.com>,
	Mark Rutland <mark.rutland@arm.com>,
	Ian Campbell <ijc+devicetree@hellion.org.uk>,
	Kumar Gala <galak@codeaurora.org>, devicetree@vger.kernel.org,
	linux-arm-kernel@lists.infradead.org, linux-crypto@vger.kernel.org,
	kernel@pengutronix.de
To: Steffen Trumtrar <s.trumtrar@pengutronix.de>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.136]:53073 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751016AbcCRTmS (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Fri, 18 Mar 2016 15:42:18 -0400
Content-Disposition: inline
In-Reply-To: <1457705200-16951-1-git-send-email-s.trumtrar@pengutronix.de>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Fri, Mar 11, 2016 at 03:06:38PM +0100, Steffen Trumtrar wrote:
> Add binding documentation for the Freescale RNGC found on
> some i.MX2/3/5 SoCs.
> 
> Signed-off-by: Steffen Trumtrar <s.trumtrar@pengutronix.de>
> ---
>  Documentation/devicetree/bindings/rng/mxc_rngc.txt | 16 ++++++++++++++++

The MXC name is still not dead?

>  1 file changed, 16 insertions(+)
>  create mode 100644 Documentation/devicetree/bindings/rng/mxc_rngc.txt
> 
> diff --git a/Documentation/devicetree/bindings/rng/mxc_rngc.txt b/Documentation/devicetree/bindings/rng/mxc_rngc.txt
> new file mode 100644
> index 000000000000..e147a6dde40a
> --- /dev/null
> +++ b/Documentation/devicetree/bindings/rng/mxc_rngc.txt
> @@ -0,0 +1,16 @@
> +Freescale RNGC (Random Number Generator Version C)
> +
> +Required properties:
> +- compatible : Should be "fsl,imx25-rng"

What about i.MX3/5 compatible strings?

> +- reg : Offset and length of the register set of this block
> +- interrupts : the interrupt number for the RNG block
> +- clocks: should contain the RNG clk source
> +
> +Example:
> +
> +rng@53fb0000 {
> +	compatible = "fsl,imx25-rng";
> +	reg = <0x53fb0000 0x4000>;
> +	interrupts = <22>;
> +	clocks = <&trng_clk>;
> +};
> -- 
> 2.7.0
> 
