From: Antoine Tenart <antoine.tenart@bootlin.com>
Subject: [PATCH 12/14] crypto: inside-secure - set tx_max_cmd_queue to 32
Date: Thu, 28 Jun 2018 17:15:42 +0200
Message-ID: <20180628151544.22134-13-antoine.tenart@bootlin.com>
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

The ORO bridge (connected to the EIP197 write channel) does not
generate back pressure towards the EIP197 when its internal FIFO is
full. It assumes that the EIP will not drive more write transactions
than the maximal supported outstanding (32).

Hence tx_max_cmd_queue must be configured to 5 (or less).

Signed-off-by: Ofer Heifetz <oferh@marvell.com>
Signed-off-by: Antoine Tenart <antoine.tenart@bootlin.com>
---
 drivers/crypto/inside-secure/safexcel.c | 4 ++++
 drivers/crypto/inside-secure/safexcel.h | 1 +
 2 files changed, 5 insertions(+)

diff --git a/drivers/crypto/inside-secure/safexcel.c b/drivers/crypto/inside-secure/safexcel.c
index 5feb83c6238b..9e5d2bf232eb 100644
--- a/drivers/crypto/inside-secure/safexcel.c
+++ b/drivers/crypto/inside-secure/safexcel.c
@@ -306,6 +306,10 @@ static int safexcel_hw_init(struct safexcel_crypto_priv *priv)
 	else if (((version >> 16) & 0xffff) == EIP197_HIA_VERSION_LE)
 		val |= (EIP197_MST_CTRL_NO_BYTE_SWAP >> 24);
 
+	/* For EIP197 set maximum number of TX commands to 2^5 = 32 */
+	if (priv->version == EIP197B || priv->version == EIP197D)
+		val |= EIP197_MST_CTRL_TX_MAX_CMD(5);
+
 	writel(val, EIP197_HIA_AIC(priv) + EIP197_HIA_MST_CTRL);
 
 	/* Configure wr/rd cache values */
diff --git a/drivers/crypto/inside-secure/safexcel.h b/drivers/crypto/inside-secure/safexcel.h
index 94a89664f3d0..95095cb95ba4 100644
--- a/drivers/crypto/inside-secure/safexcel.h
+++ b/drivers/crypto/inside-secure/safexcel.h
@@ -222,6 +222,7 @@
 #define WR_CACHE_4BITS				(WR_CACHE_3BITS << 1 | BIT(0))
 #define EIP197_MST_CTRL_RD_CACHE(n)		(((n) & 0xf) << 0)
 #define EIP197_MST_CTRL_WD_CACHE(n)		(((n) & 0xf) << 4)
+#define EIP197_MST_CTRL_TX_MAX_CMD(n)		(((n) & 0xf) << 20)
 #define EIP197_MST_CTRL_BYTE_SWAP		BIT(24)
 #define EIP197_MST_CTRL_NO_BYTE_SWAP		BIT(25)
 
-- 
2.17.1
