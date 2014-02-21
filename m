From: Dan Carpenter <dan.carpenter@oracle.com>
Subject: [patch] crypto: caam - writel() arguments are swapped
Date: Fri, 21 Feb 2014 11:51:31 +0300
Message-ID: <20140221085131.GB13078@elgon.mountain>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Alex Porosanu <alexandru.porosanu@freescale.com>,
	Ruchika Gupta <ruchika.gupta@freescale.com>,
	Vakul Garg <vakul@freescale.com>,
	Andy Fleming <afleming@freescale.com>,
	linux-crypto@vger.kernel.org, Steve Cornelius <sec@pobox.com>,
	Kim Phillips <kim.phillips@freescale.com>,
	kernel-janitors@vger.kernel.org
To: Herbert Xu <herbert@gondor.apana.org.au>
Return-path: <kernel-janitors-owner@vger.kernel.org>
Content-Disposition: inline
Sender: kernel-janitors-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

My guess is that this little endian configuration is never found in real
life, but if it were then the writel() arguments are in the wrong order
so the driver would crash immediately.

Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
---
I can't compile this code.

diff --git a/drivers/crypto/caam/regs.h b/drivers/crypto/caam/regs.h
index d50174f45b21..cbde8b95a6f8 100644
--- a/drivers/crypto/caam/regs.h
+++ b/drivers/crypto/caam/regs.h
@@ -74,10 +74,10 @@
 #endif
 #else
 #ifdef __LITTLE_ENDIAN
-#define wr_reg32(reg, data) __raw_writel(reg, data)
+#define wr_reg32(reg, data) __raw_writel(data, reg)
 #define rd_reg32(reg) __raw_readl(reg)
 #ifdef CONFIG_64BIT
-#define wr_reg64(reg, data) __raw_writeq(reg, data)
+#define wr_reg64(reg, data) __raw_writeq(data, reg)
 #define rd_reg64(reg) __raw_readq(reg)
 #endif
 #endif
