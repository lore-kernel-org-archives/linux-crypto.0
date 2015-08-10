From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH v2 00/14] crypto: caam - Add i.MX6 support to the
 Freescale CAAM driver
Date: Mon, 10 Aug 2015 23:40:27 +0800
Message-ID: <20150810154027.GA21143@gondor.apana.org.au>
References: <1438228709-27650-1-git-send-email-vicki.milhoan@freescale.com>
 <1438799328-10757-1-git-send-email-vicki.milhoan@freescale.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-crypto@vger.kernel.org, horia.geanta@freescale.com,
	ruchika.gupta@freescale.com, shawnguo@kernel.org,
	kernel@pengutronix.de, linux@arm.linux.org.uk, robh+dt@kernel.org
To: Victoria Milhoan <vicki.milhoan@freescale.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from helcar.hengli.com.au ([209.40.204.226]:50605 "EHLO
	helcar.hengli.com.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932307AbbHJPkf (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Mon, 10 Aug 2015 11:40:35 -0400
Content-Disposition: inline
In-Reply-To: <1438799328-10757-1-git-send-email-vicki.milhoan@freescale.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Wed, Aug 05, 2015 at 11:28:34AM -0700, Victoria Milhoan wrote:
> This patch series adds i.MX6 support to the Freescale CAAM driver.
> 
> Modifications include:
> 
> - explicit cache coherency support in the driver
> - register I/O primitive support
> - scatter/gather entry modifications
> - clocking support
> - i.MX6 device tree support for CAAM
> - DMA fixes
> - algorithm registration based on hardware capabilities
> 
> These patches have been tested on the i.MX6 and regression tested
> on QorIQ platforms.
> 
> Changes in v2:
>   - Clocking support:
>     - Minimized architecture differences
>     - Balanced clk_get and clk_put calls
>     - Removed display of clock values
>     - Renamed clock definitions to explicitly show "CLK"
>     - Removed unnecessary "caam_" prefixes to clock-names property in DTS files
>     - Added clocks and clock-names property descriptions to SEC 4.0
>       device tree bindings document
>   - Added check of hardware capabilities before algorithm registration
>   - Modified patches based on AEAD changes in caamalg.c

All applied with v3 for patch 11 and the order of patches 13 and
14 reversed.

Thanks!
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
