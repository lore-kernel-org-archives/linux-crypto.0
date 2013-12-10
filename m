From: Marek Vasut <marex@denx.de>
Subject: Re: [PATCH V2 3/5] ARM: mxs: crypto: Add Freescale MXS DCP driver
Date: Tue, 10 Dec 2013 20:19:22 +0100
Message-ID: <201312102019.22473.marex@denx.de>
References: <1385932823-3860-1-git-send-email-marex@denx.de> <1385932823-3860-3-git-send-email-marex@denx.de> <20131203110958.GF13726@S2101-09.ap.freescale.net>
Mime-Version: 1.0
Content-Type: Text/Plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Cc: linux-arm-kernel@lists.infradead.org,
	Herbert Xu <herbert@gondor.apana.org.au>,
	"David S. Miller" <davem@davemloft.net>,
	Fabio Estevam <fabio.estevam@freescale.com>,
	linux-crypto@vger.kernel.org, devicetree@vger.kernel.org
To: Shawn Guo <shawn.guo@linaro.org>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-out.m-online.net ([212.18.0.9]:49412 "EHLO
	mail-out.m-online.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753334Ab3LJT05 (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Tue, 10 Dec 2013 14:26:57 -0500
In-Reply-To: <20131203110958.GF13726@S2101-09.ap.freescale.net>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Tuesday, December 03, 2013 at 12:10:02 PM, Shawn Guo wrote:
> On Sun, Dec 01, 2013 at 10:20:21PM +0100, Marek Vasut wrote:
> > Add support for the MXS DCP block. The driver currently supports
> > SHA-1/SHA-256 hashing and AES-128 CBC/ECB modes. The non-standard
> > CRC32 is not yet supported.
> > 
> > Signed-off-by: Marek Vasut <marex@denx.de>
> > Cc: Herbert Xu <herbert@gondor.apana.org.au>
> > Cc: David S. Miller <davem@davemloft.net>
> > Cc: Fabio Estevam <fabio.estevam@freescale.com>
> > Cc: Shawn Guo <shawn.guo@linaro.org>
> > Cc: linux-crypto@vger.kernel.org
> > ---
> > 
> >  .../devicetree/bindings/crypto/fsl-dcp.txt         |   18 +
> >  drivers/crypto/Kconfig                             |   17 +
> >  drivers/crypto/Makefile                            |    1 +
> >  drivers/crypto/mxs-dcp.c                           | 1100
> >  ++++++++++++++++++++ 4 files changed, 1136 insertions(+)
> >  create mode 100644 Documentation/devicetree/bindings/crypto/fsl-dcp.txt
> 
> Since it creates new device tree bindings, please copy
> devicetree@vger.kernel.org, so that DT experts can have a chance to
> review the bindings.

OK, makes sense.
 
> Shawn
> 
> >  create mode 100644 drivers/crypto/mxs-dcp.c
> > 
> > V2: Use dma_{un,}map_single instead of large coherent chunk
> > 
> >       Use the DMA mapping function on DCP buffers instead of the large
> >       coherent chunk. This reduces the amount of cache
> >       flushes/invalidations and write buffer drains as we do not need to
> >       do this every time we operate with the coherent memory chunk, but
> >       only when really needed.
> >     
> >     Make sure rctx is always inited
> >     
> >       The crypto request context is not zeroed out by the crypto API.
> >       While this is not documented anywhere, it will produce arcane and
> >       hard to debug problems. Fix the DCP code so that the request
> >       context is always properly initialized.
> >     
> >     Minor code and coding-style fixes.
> > 
> > diff --git a/Documentation/devicetree/bindings/crypto/fsl-dcp.txt
> > b/Documentation/devicetree/bindings/crypto/fsl-dcp.txt new file mode
> > 100644
> > index 0000000..ee8fbf9
> > --- /dev/null
> > +++ b/Documentation/devicetree/bindings/crypto/fsl-dcp.txt
> > @@ -0,0 +1,18 @@
> > +Freescale DCP (Data Co-Processor) found on i.MX23/i.MX28 .
> > +
> > +Required properties:
> > +- compatible : Should be "fsl,<soc>-dcp"
> > +- reg : Should contain MXS DCP registers location and length
> > +- interrupts : Should contain MXS DCP interrupt numbers, VMI IRQ and DCP
> > IRQ +               must be supplied, optionally Secure IRQ can be
> > present, but +	       is currently not implemented and not used.
> > +
> > +Example:
> > +
> > +dcp@80028000 {
> > +	compatible = "fsl,imx28-dcp", "fsl,imx23-dcp";
> > +	reg = <0x80028000 0x2000>;
> > +	interrupts = <52 53>;
> > +	status = "okay";
> > +};

[...]
