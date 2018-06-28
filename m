From: Antoine Tenart <antoine.tenart@bootlin.com>
Subject: [PATCH 11/14] crypto: inside-secure - reset CDR and RDR rings on module removal
Date: Thu, 28 Jun 2018 17:15:41 +0200
Message-ID: <20180628151544.22134-12-antoine.tenart@bootlin.com>
References: <20180628151544.22134-1-antoine.tenart@bootlin.com>
Cc: Ofer Heifetz <oferh@marvell.com>, linux-crypto@vger.kernel.org,
        linux-kernel@vger.kernel.org, thomas.petazzoni@bootlin.com,
        maxime.chevallier@bootlin.com, miquel.raynal@bootlin.com,
        nadavh@marvell.com, igall@marvell.com,
        Antoine Tenart <antoine.tenart@bootlin.com>
To: herbert@gondor.apana.org.au, davem@davemloft.net,
        gregory.clement@bootlin.com, andrew@lunn.ch, jason@lakedaemon.net,
        sebastian.hesselbarth@gmail.com
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20180628151544.22134-1-antoine.tenart@bootlin.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

From: Ofer Heifetz <oferh@marvell.com>

This patch adds extra steps in the module removal path, to reset the
command and result rings. The corresponding interrupts are cleared, and
the ring address configuration is reset.

Signed-off-by: Ofer Heifetz <oferh@marvell.com>
[Antoine: small reworks, commit message]
Signed-off-by: Antoine Tenart <antoine.tenart@bootlin.com>
---
 drivers/crypto/inside-secure/safexcel.c | 20 ++++++++++++++++++++
 1 file changed, 20 insertions(+)

diff --git a/drivers/crypto/inside-secure/safexcel.c b/drivers/crypto/inside-secure/safexcel.c
index b70694090353..5feb83c6238b 100644
--- a/drivers/crypto/inside-secure/safexcel.c
+++ b/drivers/crypto/inside-secure/safexcel.c
@@ -1125,6 +1125,24 @@ static int safexcel_probe(struct platform_device *pdev)
 	return ret;
 }
 
+static void safexcel_hw_reset_rings(struct safexcel_crypto_priv *priv)
+{
+	int i;
+
+	for (i = 0; i < priv->config.rings; i++) {
+		/* clear any pending interrupt */
+		writel(GENMASK(5, 0), EIP197_HIA_CDR(priv, i) + EIP197_HIA_xDR_STAT);
+		writel(GENMASK(7, 0), EIP197_HIA_RDR(priv, i) + EIP197_HIA_xDR_STAT);
+
+		/* Reset the CDR base address */
+		writel(0, EIP197_HIA_CDR(priv, i) + EIP197_HIA_xDR_RING_BASE_ADDR_LO);
+		writel(0, EIP197_HIA_CDR(priv, i) + EIP197_HIA_xDR_RING_BASE_ADDR_HI);
+
+		/* Reset the RDR base address */
+		writel(0, EIP197_HIA_RDR(priv, i) + EIP197_HIA_xDR_RING_BASE_ADDR_LO);
+		writel(0, EIP197_HIA_RDR(priv, i) + EIP197_HIA_xDR_RING_BASE_ADDR_HI);
+	}
+}
 
 static int safexcel_remove(struct platform_device *pdev)
 {
@@ -1132,6 +1150,8 @@ static int safexcel_remove(struct platform_device *pdev)
 	int i;
 
 	safexcel_unregister_algorithms(priv);
+	safexcel_hw_reset_rings(priv);
+
 	clk_disable_unprepare(priv->clk);
 
 	for (i = 0; i < priv->config.rings; i++)
-- 
2.17.1
