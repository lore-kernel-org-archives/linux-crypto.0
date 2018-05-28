From: Antoine Tenart <antoine.tenart@bootlin.com>
Subject: [PATCH] crypto: inside-secure - increase minimum transfer size
Date: Mon, 28 May 2018 11:03:27 +0200
Message-ID: <20180528090327.16844-1-antoine.tenart@bootlin.com>
Cc: Ofer Heifetz <oferh@marvell.com>, linux-crypto@vger.kernel.org,
        linux-kernel@vger.kernel.org, thomas.petazzoni@bootlin.com,
        maxime.chevallier@bootlin.com, gregory.clement@bootlin.com,
        miquel.raynal@bootlin.com, nadavh@marvell.com, igall@marvell.com,
        Antoine Tenart <antoine.tenart@bootlin.com>
To: herbert@gondor.apana.org.au, davem@davemloft.net
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

From: Ofer Heifetz <oferh@marvell.com>

The token size was increased for AEAD support. Occasional authentication
fails arise since the result descriptor overflows. This is because the
token size and the engine minimal thresholds must be in sync.

Signed-off-by: Ofer Heifetz <oferh@marvell.com>
Signed-off-by: Antoine Tenart <antoine.tenart@bootlin.com>
---

Hi Herbert,

This patch fixes/improves the AEAD support in the SafeXcel driver. As
the AEAD support (which introduces the issue) was only merge a few days
ago, this patch is not flagged as being a fix.

Thanks!
Antoine

 drivers/crypto/inside-secure/safexcel.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/crypto/inside-secure/safexcel.c b/drivers/crypto/inside-secure/safexcel.c
index 4e86f864a952..8691f6369a13 100644
--- a/drivers/crypto/inside-secure/safexcel.c
+++ b/drivers/crypto/inside-secure/safexcel.c
@@ -296,8 +296,8 @@ static int safexcel_hw_init(struct safexcel_crypto_priv *priv)
 
 	/* DMA transfer size to use */
 	val = EIP197_HIA_DFE_CFG_DIS_DEBUG;
-	val |= EIP197_HIA_DxE_CFG_MIN_DATA_SIZE(5) | EIP197_HIA_DxE_CFG_MAX_DATA_SIZE(9);
-	val |= EIP197_HIA_DxE_CFG_MIN_CTRL_SIZE(5) | EIP197_HIA_DxE_CFG_MAX_CTRL_SIZE(7);
+	val |= EIP197_HIA_DxE_CFG_MIN_DATA_SIZE(6) | EIP197_HIA_DxE_CFG_MAX_DATA_SIZE(9);
+	val |= EIP197_HIA_DxE_CFG_MIN_CTRL_SIZE(6) | EIP197_HIA_DxE_CFG_MAX_CTRL_SIZE(7);
 	val |= EIP197_HIA_DxE_CFG_DATA_CACHE_CTRL(RD_CACHE_3BITS);
 	val |= EIP197_HIA_DxE_CFG_CTRL_CACHE_CTRL(RD_CACHE_3BITS);
 	writel(val, EIP197_HIA_DFE(priv) + EIP197_HIA_DFE_CFG);
@@ -306,9 +306,9 @@ static int safexcel_hw_init(struct safexcel_crypto_priv *priv)
 	writel(0, EIP197_HIA_DFE_THR(priv) + EIP197_HIA_DFE_THR_CTRL);
 
 	/* Configure the procesing engine thresholds */
-	writel(EIP197_PE_IN_xBUF_THRES_MIN(5) | EIP197_PE_IN_xBUF_THRES_MAX(9),
+	writel(EIP197_PE_IN_xBUF_THRES_MIN(6) | EIP197_PE_IN_xBUF_THRES_MAX(9),
 	       EIP197_PE(priv) + EIP197_PE_IN_DBUF_THRES);
-	writel(EIP197_PE_IN_xBUF_THRES_MIN(5) | EIP197_PE_IN_xBUF_THRES_MAX(7),
+	writel(EIP197_PE_IN_xBUF_THRES_MIN(6) | EIP197_PE_IN_xBUF_THRES_MAX(7),
 	       EIP197_PE(priv) + EIP197_PE_IN_TBUF_THRES);
 
 	if (priv->version == EIP197) {
-- 
2.17.0
