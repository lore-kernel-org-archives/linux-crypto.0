From: Steffen Trumtrar <s.trumtrar@pengutronix.de>
Subject: [BUG?] crypto: caam: little/big endianness on ARM vs PPC
Date: Mon, 15 Jun 2015 17:59:07 +0200
Message-ID: <20150615155907.GC7947@pengutronix.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-arm-kernel@lists.infradead.org, linux-crypto@vger.kernel.org,
	Ruchika Gupta <ruchika.gupta@freescale.com>,
	Herbert Xu <herbert@gondor.apana.org.au>, kernel@pengutronix.de
To: linux-kernel@vger.kernel.org
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from metis.ext.pengutronix.de ([92.198.50.35]:33688 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752083AbbFOP7N (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Mon, 15 Jun 2015 11:59:13 -0400
Content-Disposition: inline
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Hi!

I'm working on CAAM support for the ARM-based i.MX6 SoCs. The current
drivers/crypto/caam driver only works for PowerPC AFAIK.
Actually, there isn't that much to do, to get support for the i.MX6 but
one patch breaks the driver severely:

	commit ef94b1d834aace7101de77c3a7c2631b9ae9c5f6
	crypto: caam - Add definition of rd/wr_reg64 for little endian platform

This patch adds

+#ifdef __LITTLE_ENDIAN
+static inline void wr_reg64(u64 __iomem *reg, u64 data)
+{
+	wr_reg32((u32 __iomem *)reg + 1, (data & 0xffffffff00000000ull) >> 32);
+	wr_reg32((u32 __iomem *)reg, data & 0x00000000ffffffffull);
+}

The wr_reg64 function is only used in one place in the drivers/crypto/caam/jr.c
driver: to write the dma_addr_t to the register. Without that patch everything
works fine on ARM (little endian, 32bit), with that patch the driver will write
0's into the register that holds the DMA address (the numerically-higher) -> kernel hangs.
Also, from my understanding, the comment above the defines, stating that you
have to first write the numerically-lower and then the numerically-higher address
on 32bit systems doesn't match with the implementation.

What I don't know/understand is if this makes any sense for any PowerPC implementation.

So, the question is, how to fix this? I'd prefer to do it directly in the jr driver
instead of the ifdef-ery.

Something like
	if (sizeof(dma_addr_t) == sizeof(u32))
		wr_reg32(&jrp->rregs->inpring_base + 1, inpbusaddr);
	else if (sizeof(dma_addr_t) == sizeof(u64))
		wr_reg64(...)

or just go by DT compatible and then remove the inline function definitions.

As far as I can tell, the compatible wouldn't be needed for anything else in the
jr driver, so maybe that is not optimal. On the other hand the sizeof(..)
solution would only catch little endian on 32bit and not big endian (?!)
I however don't know what combinations actually *have* to be caught, as I don't
know, which exist.

So, what do you think people?

Thanks,
Steffen Trumtrar

-- 
Pengutronix e.K.                           |                             |
Industrial Linux Solutions                 | http://www.pengutronix.de/  |
Peiner Str. 6-8, 31137 Hildesheim, Germany | Phone: +49-5121-206917-0    |
Amtsgericht Hildesheim, HRA 2686           | Fax:   +49-5121-206917-5555 |
