From: Victoria Milhoan <vicki.milhoan@freescale.com>
Subject: Re: [PATCH] crypto: caam - fix non-64-bit write/read access
Date: Wed, 17 Jun 2015 07:30:53 -0700
Message-ID: <20150617073053.c52be013e710e8a79363dd9d@freescale.com>
References: <1434452347-27177-1-git-send-email-s.trumtrar@pengutronix.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
Cc: Herbert Xu <herbert@gondor.apana.org.au>,
	Ruchika Gupta <ruchika.gupta@freescale.com>,
	Victoria Milhoan <Vicki.Milhoan@freescale.com>,
	Russell King <linux@arm.linux.org.uk>,
	"Jon Nettleton" <jon.nettleton@gmail.com>,
	<linux-crypto@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
	<kernel@pengutronix.de>
To: Steffen Trumtrar <s.trumtrar@pengutronix.de>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-by2on0131.outbound.protection.outlook.com ([207.46.100.131]:51328
	"EHLO na01-by2-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1755368AbbFQObM (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Wed, 17 Jun 2015 10:31:12 -0400
In-Reply-To: <1434452347-27177-1-git-send-email-s.trumtrar@pengutronix.de>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Tue, 16 Jun 2015 12:59:07 +0200
Steffen Trumtrar <s.trumtrar@pengutronix.de> wrote:

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
> ---
> 
> This patch is only compile-tested for PowerPC and tested on ARM.
> According to the datasheets for i.MX6 and P1010 this should be correct, though.

I can confirm that this patch works on both QorIQ/PowerPC and ARM devices.
