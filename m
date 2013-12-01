From: Marek Vasut <marex@denx.de>
Subject: [PATCH 5/5] crypto: Sort drivers/crypto/Makefile
Date: Sun,  1 Dec 2013 22:20:23 +0100
Message-ID: <1385932823-3860-5-git-send-email-marex@denx.de>
References: <1385932823-3860-1-git-send-email-marex@denx.de>
Cc: Marek Vasut <marex@denx.de>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	"David S. Miller" <davem@davemloft.net>,
	Fabio Estevam <fabio.estevam@freescale.com>,
	Shawn Guo <shawn.guo@linaro.org>, linux-crypto@vger.kernel.org
To: linux-arm-kernel@lists.infradead.org
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-out.m-online.net ([212.18.0.9]:35217 "EHLO
	mail-out.m-online.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751412Ab3LAVWe (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Sun, 1 Dec 2013 16:22:34 -0500
In-Reply-To: <1385932823-3860-1-git-send-email-marex@denx.de>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

The order in the Makefile was a mess, sort it.

Signed-off-by: Marek Vasut <marex@denx.de>
Cc: Herbert Xu <herbert@gondor.apana.org.au>
Cc: David S. Miller <davem@davemloft.net>
Cc: Fabio Estevam <fabio.estevam@freescale.com>
Cc: Shawn Guo <shawn.guo@linaro.org>
Cc: linux-crypto@vger.kernel.org
---
 drivers/crypto/Makefile | 32 ++++++++++++++++----------------
 1 file changed, 16 insertions(+), 16 deletions(-)

diff --git a/drivers/crypto/Makefile b/drivers/crypto/Makefile
index c7be214..98458f6 100644
--- a/drivers/crypto/Makefile
+++ b/drivers/crypto/Makefile
@@ -1,24 +1,24 @@
-obj-$(CONFIG_CRYPTO_DEV_PADLOCK_AES) += padlock-aes.o
-obj-$(CONFIG_CRYPTO_DEV_PADLOCK_SHA) += padlock-sha.o
+obj-$(CONFIG_CRYPTO_DEV_ATMEL_AES) += atmel-aes.o
+obj-$(CONFIG_CRYPTO_DEV_ATMEL_SHA) += atmel-sha.o
+obj-$(CONFIG_CRYPTO_DEV_ATMEL_TDES) += atmel-tdes.o
+obj-$(CONFIG_CRYPTO_DEV_BFIN_CRC) += bfin_crc.o
+obj-$(CONFIG_CRYPTO_DEV_FSL_CAAM) += caam/
 obj-$(CONFIG_CRYPTO_DEV_GEODE) += geode-aes.o
-obj-$(CONFIG_CRYPTO_DEV_NIAGARA2) += n2_crypto.o
-n2_crypto-y := n2_core.o n2_asm.o
 obj-$(CONFIG_CRYPTO_DEV_HIFN_795X) += hifn_795x.o
-obj-$(CONFIG_CRYPTO_DEV_MV_CESA) += mv_cesa.o
-obj-$(CONFIG_CRYPTO_DEV_TALITOS) += talitos.o
-obj-$(CONFIG_CRYPTO_DEV_FSL_CAAM) += caam/
 obj-$(CONFIG_CRYPTO_DEV_IXP4XX) += ixp4xx_crypto.o
-obj-$(CONFIG_CRYPTO_DEV_PPC4XX) += amcc/
-obj-$(CONFIG_CRYPTO_DEV_OMAP_SHAM) += omap-sham.o
+obj-$(CONFIG_CRYPTO_DEV_MV_CESA) += mv_cesa.o
+obj-$(CONFIG_CRYPTO_DEV_MXS_DCP) += mxs-dcp.o
+obj-$(CONFIG_CRYPTO_DEV_NIAGARA2) += n2_crypto.o
+n2_crypto-y := n2_core.o n2_asm.o
+obj-$(CONFIG_CRYPTO_DEV_NX) += nx/
 obj-$(CONFIG_CRYPTO_DEV_OMAP_AES) += omap-aes.o
+obj-$(CONFIG_CRYPTO_DEV_OMAP_SHAM) += omap-sham.o
+obj-$(CONFIG_CRYPTO_DEV_PADLOCK_AES) += padlock-aes.o
+obj-$(CONFIG_CRYPTO_DEV_PADLOCK_SHA) += padlock-sha.o
 obj-$(CONFIG_CRYPTO_DEV_PICOXCELL) += picoxcell_crypto.o
-obj-$(CONFIG_CRYPTO_DEV_SAHARA) += sahara.o
+obj-$(CONFIG_CRYPTO_DEV_PPC4XX) += amcc/
 obj-$(CONFIG_CRYPTO_DEV_S5P) += s5p-sss.o
+obj-$(CONFIG_CRYPTO_DEV_SAHARA) += sahara.o
+obj-$(CONFIG_CRYPTO_DEV_TALITOS) += talitos.o
 obj-$(CONFIG_CRYPTO_DEV_TEGRA_AES) += tegra-aes.o
 obj-$(CONFIG_CRYPTO_DEV_UX500) += ux500/
-obj-$(CONFIG_CRYPTO_DEV_BFIN_CRC) += bfin_crc.o
-obj-$(CONFIG_CRYPTO_DEV_NX) += nx/
-obj-$(CONFIG_CRYPTO_DEV_ATMEL_AES) += atmel-aes.o
-obj-$(CONFIG_CRYPTO_DEV_ATMEL_TDES) += atmel-tdes.o
-obj-$(CONFIG_CRYPTO_DEV_ATMEL_SHA) += atmel-sha.o
-obj-$(CONFIG_CRYPTO_DEV_MXS_DCP) += mxs-dcp.o
-- 
1.8.4.2
