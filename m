From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH] crypto: caam - fix non-64-bit write/read access
Date: Thu, 18 Jun 2015 14:49:44 +0800
Message-ID: <20150618064944.GA28799@gondor.apana.org.au>
References: <1434452347-27177-1-git-send-email-s.trumtrar@pengutronix.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Ruchika Gupta <ruchika.gupta@freescale.com>,
	Victoria Milhoan <Vicki.Milhoan@freescale.com>,
	Russell King <linux@arm.linux.org.uk>,
	Jon Nettleton <jon.nettleton@gmail.com>,
	linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
	kernel@pengutronix.de
To: Steffen Trumtrar <s.trumtrar@pengutronix.de>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from helcar.hengli.com.au ([209.40.204.226]:40032 "EHLO
	helcar.hengli.com.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751887AbbFRGt4 (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Thu, 18 Jun 2015 02:49:56 -0400
Content-Disposition: inline
In-Reply-To: <1434452347-27177-1-git-send-email-s.trumtrar@pengutronix.de>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Tue, Jun 16, 2015 at 12:59:07PM +0200, Steffen Trumtrar wrote:
> The patch
> 
> 	crypto: caam - Add definition of rd/wr_reg64 for little endian platform
> 
> added support for little endian platforms to the CAAM driver. Namely a
> write and read function for 64 bit registers.
> The only user of this functions is the Job Ring driver (drivers/crypto/caam/jr.c).
> It uses the functions to set the DMA addresses for the input/output rings.
> However, at least in the default configuration, the least significant 32 bits are
> always in the base+0x0004 address; independent of the endianness of the bytes itself.
> That means the addresses do not change with the system endianness.
> 
> DMA addresses are only 32 bits wide on non-64-bit systems, writing the upper 32 bits
> of this value to the register for the least significant bits results in the DMA address
> being set to 0.
> 
> Fix this by always writing the registers in the same way.
> 
> Suggested-by: Russell King <linux@arm.linux.org.uk>
> Signed-off-by: Steffen Trumtrar <s.trumtrar@pengutronix.de>

Patch applied.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
