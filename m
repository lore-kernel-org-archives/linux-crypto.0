From: Sascha Hauer <s.hauer@pengutronix.de>
Subject: Re: [PATCH v2 3/3] crypto: sahara: Add device tree binding for
 SAHARA2.
Date: Wed, 27 Feb 2013 21:05:30 +0100
Message-ID: <20130227200530.GN1906@pengutronix.de>
References: <1361961711-4603-1-git-send-email-javier.martin@vista-silicon.com>
 <1361961711-4603-4-git-send-email-javier.martin@vista-silicon.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-crypto@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
	linux-doc@vger.kernel.org, devicetree-discuss@lists.ozlabs.org,
	davem@davemloft.net, herbert@gondor.apana.org.au,
	kernel@pengutronix.de, gcembed@gmail.com, shawn.guo@linaro.org,
	arnd@arndb.de, swarren@nvidia.com
To: Javier Martin <javier.martin@vista-silicon.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from metis.ext.pengutronix.de ([92.198.50.35]:38023 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752559Ab3B0UG6 (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Wed, 27 Feb 2013 15:06:58 -0500
Content-Disposition: inline
In-Reply-To: <1361961711-4603-4-git-send-email-javier.martin@vista-silicon.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Hi Javier,

On Wed, Feb 27, 2013 at 11:41:51AM +0100, Javier Martin wrote:
> 
> Signed-off-by: Javier Martin <javier.martin@vista-silicon.com>
> ---
>  .../devicetree/bindings/crypto/fsl-imx-sahara.txt  |   14 ++++++++++++++
>  1 file changed, 14 insertions(+)
>  create mode 100644 Documentation/devicetree/bindings/crypto/fsl-imx-sahara.txt
> 
> diff --git a/Documentation/devicetree/bindings/crypto/fsl-imx-sahara.txt b/Documentation/devicetree/bindings/crypto/fsl-imx-sahara.txt
> new file mode 100644
> index 0000000..44abf11
> --- /dev/null
> +++ b/Documentation/devicetree/bindings/crypto/fsl-imx-sahara.txt
> @@ -0,0 +1,14 @@
> +* Freescale i.MX SAHARA Cryptographic Accelerator
> +
> +Required properties:
> +- compatible : Should be "fsl,<soc>-sahara"

Please add explicitly which SoCs are supported.

You can fold this patch into the driver patch. This way people reading
the commit history have a direct cross link between the driver and the
documentation.

Sascha

-- 
Pengutronix e.K.                           |                             |
Industrial Linux Solutions                 | http://www.pengutronix.de/  |
Peiner Str. 6-8, 31137 Hildesheim, Germany | Phone: +49-5121-206917-0    |
Amtsgericht Hildesheim, HRA 2686           | Fax:   +49-5121-206917-5555 |
