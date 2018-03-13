From: Gregory CLEMENT <gregory.clement@bootlin.com>
Subject: [PATCH 2/3] crypto: inside-secure - improve clock initialization
Date: Tue, 13 Mar 2018 17:48:41 +0100
Message-ID: <20180313164842.20042-3-gregory.clement@bootlin.com>
References: <20180313164842.20042-1-gregory.clement@bootlin.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Cc: Andrew Lunn <andrew@lunn.ch>, Jason Cooper <jason@lakedaemon.net>,
 Gregory CLEMENT <gregory.clement@bootlin.com>, Omri Itach <omrii@marvell.com>,
 Nadav Haklai <nadavh@marvell.com>, Shadi Ammouri <shadi@marvell.com>,
 Igal Liberman <igall@marvell.com>,
 Thomas Petazzoni <thomas.petazzoni@bootlin.com>,
 =?UTF-8?q?Miqu=C3=A8l=20Raynal?= <miquel.raynal@bootlin.com>,
 Marcin Wojtas <mw@semihalf.com>, Hanna Hawa <hannah@marvell.com>,
 linux-arm-kernel@lists.infradead.org,
 Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>
To: Herbert Xu <herbert@gondor.apana.org.au>, davem@davemloft.net,
 linux-crypto@vger.kernel.org, Antoine Tenart <antoine.tenart@bootlin.com>,
 oferh@marvell.com
Return-path: <linux-arm-kernel-bounces+linux-arm-kernel=m.gmane.org@lists.infradead.org>
In-Reply-To: <20180313164842.20042-1-gregory.clement@bootlin.com>
List-Unsubscribe: <http://lists.infradead.org/mailman/options/linux-arm-kernel>,
 <mailto:linux-arm-kernel-request@lists.infradead.org?subject=unsubscribe>
List-Archive: <http://lists.infradead.org/pipermail/linux-arm-kernel/>
List-Post: <mailto:linux-arm-kernel@lists.infradead.org>
List-Help: <mailto:linux-arm-kernel-request@lists.infradead.org?subject=help>
List-Subscribe: <http://lists.infradead.org/mailman/listinfo/linux-arm-kernel>,
 <mailto:linux-arm-kernel-request@lists.infradead.org?subject=subscribe>
Sender: "linux-arm-kernel" <linux-arm-kernel-bounces@lists.infradead.org>
Errors-To: linux-arm-kernel-bounces+linux-arm-kernel=m.gmane.org@lists.infradead.org
List-Id: linux-crypto.vger.kernel.org

The clock is optional, but if it is present we should managed it. If
there is an error while trying getting it, we should exit and report this
error.

So instead of returning an error only in the -EPROBE case, turn it in an
other way and ignore the clock only if it is not present (-ENOENT case).

Signed-off-by: Gregory CLEMENT <gregory.clement@bootlin.com>
---
 drivers/crypto/inside-secure/safexcel.c | 11 ++++++-----
 1 file changed, 6 insertions(+), 5 deletions(-)

diff --git a/drivers/crypto/inside-secure/safexcel.c b/drivers/crypto/inside-secure/safexcel.c
index 09adeaa0da6b..cbcb5d9f17bd 100644
--- a/drivers/crypto/inside-secure/safexcel.c
+++ b/drivers/crypto/inside-secure/safexcel.c
@@ -882,16 +882,17 @@ static int safexcel_probe(struct platform_device *pdev)
 	}
 
 	priv->clk = devm_clk_get(&pdev->dev, NULL);
-	if (!IS_ERR(priv->clk)) {
+	ret = PTR_ERR_OR_ZERO(priv->clk);
+	/* The clock isn't mandatory */
+	if  (ret != -ENOENT) {
+		if (ret)
+			return ret;
+
 		ret = clk_prepare_enable(priv->clk);
 		if (ret) {
 			dev_err(dev, "unable to enable clk (%d)\n", ret);
 			return ret;
 		}
-	} else {
-		/* The clock isn't mandatory */
-		if (PTR_ERR(priv->clk) == -EPROBE_DEFER)
-			return -EPROBE_DEFER;
 	}
 
 	ret = dma_set_mask_and_coherent(dev, DMA_BIT_MASK(64));
-- 
2.16.1
