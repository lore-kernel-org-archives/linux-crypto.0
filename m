From: Shawn Guo <shawnguo@kernel.org>
Subject: Re: [PATCH 1/3] Documentation: devicetree: add Freescale SCC bindings
Date: Sun, 14 Feb 2016 15:55:57 +0800
Message-ID: <20160214075557.GP6756@tiger>
References: <1455199485-24458-1-git-send-email-s.trumtrar@pengutronix.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Herbert Xu <herbert@gondor.apana.org.au>,
	Rob Herring <robh+dt@kernel.org>,
	Pawel Moll <pawel.moll@arm.com>,
	Mark Rutland <mark.rutland@arm.com>,
	Ian Campbell <ijc+devicetree@hellion.org.uk>,
	Kumar Gala <galak@codeaurora.org>, devicetree@vger.kernel.org,
	linux-arm-kernel@lists.infradead.org, linux-crypto@vger.kernel.org,
	kernel@pengutronix.de
To: Steffen Trumtrar <s.trumtrar@pengutronix.de>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.136]:50341 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751306AbcBNH4J (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Sun, 14 Feb 2016 02:56:09 -0500
Content-Disposition: inline
In-Reply-To: <1455199485-24458-1-git-send-email-s.trumtrar@pengutronix.de>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Thu, Feb 11, 2016 at 03:04:43PM +0100, Steffen Trumtrar wrote:
> Add documentation for the Freescale Security Controller (SCC)
> found on i.MX25 SoCs.
> 
> Signed-off-by: Steffen Trumtrar <s.trumtrar@pengutronix.de>
> ---
>  .../devicetree/bindings/crypto/fsl-imx-scc.txt          | 17 +++++++++++++++++
>  1 file changed, 17 insertions(+)
>  create mode 100644 Documentation/devicetree/bindings/crypto/fsl-imx-scc.txt
> 
> diff --git a/Documentation/devicetree/bindings/crypto/fsl-imx-scc.txt b/Documentation/devicetree/bindings/crypto/fsl-imx-scc.txt
> new file mode 100644
> index 000000000000..9a15ab8da94f
> --- /dev/null
> +++ b/Documentation/devicetree/bindings/crypto/fsl-imx-scc.txt
> @@ -0,0 +1,17 @@
> +Freescale Security Controller (SCC)
> +
> +Required properties:
> +- compatible : Should be "fsl,imx25-scc".
> +- reg : Should contain register location and length.
> +- interrupts : Should contain interrupt numbers for SCM IRQ and SMN IRQ.
> +
> +Example:
> +
> +	scc: crypto@53fac000 {
> +		compatible = "fsl,imx25-scc";
> +		reg = <0x53fac000 0x4000>;
> +		clocks = <&clks 111>;
> +		clock-names = "ipg";

Shouldn't these two be mentioned in properties list above too?

Shawn

> +		interrupts = <49>, <50>;
> +		interrupt-names = "scm", "smn";
> +	};
> -- 
> 2.7.0.rc3
> 
> 
