From: Gregory CLEMENT <gregory.clement@bootlin.com>
Subject: [PATCH 3/3] crypto: inside-secure - fix clock resource by adding a
 register clock
Date: Tue, 13 Mar 2018 17:48:42 +0100
Message-ID: <20180313164842.20042-4-gregory.clement@bootlin.com>
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

On Armada 7K/8K we need to explicitly enable the register clock. This
clock is optional because not all the SoCs using this IP need it but at
least for Armada 7K/8K it is actually mandatory.

The binding documentation is updated accordingly.

Signed-off-by: Gregory CLEMENT <gregory.clement@bootlin.com>
---
 .../bindings/crypto/inside-secure-safexcel.txt     |  6 +++-
 drivers/crypto/inside-secure/safexcel.c            | 34 ++++++++++++++++------
 drivers/crypto/inside-secure/safexcel.h            |  1 +
 3 files changed, 31 insertions(+), 10 deletions(-)

diff --git a/Documentation/devicetree/bindings/crypto/inside-secure-safexcel.txt b/Documentation/devicetree/bindings/crypto/inside-secure-safexcel.txt
index 30c3ce6b502e..5dba55cdfa63 100644
--- a/Documentation/devicetree/bindings/crypto/inside-secure-safexcel.txt
+++ b/Documentation/devicetree/bindings/crypto/inside-secure-safexcel.txt
@@ -8,7 +8,11 @@ Required properties:
 - interrupt-names: Should be "ring0", "ring1", "ring2", "ring3", "eip", "mem".
 
 Optional properties:
-- clocks: Reference to the crypto engine clock.
+- clocks: Reference to the crypto engine clocks, the second clock is
+          needed for the Armada 7K/8K SoCs.
+- clock-names: mandatory if there is a second clock, in this case the
+               name must be "core" for the first clock and "reg" for
+               the second one.
 
 Example:
 
diff --git a/drivers/crypto/inside-secure/safexcel.c b/drivers/crypto/inside-secure/safexcel.c
index cbcb5d9f17bd..2f68b4ed5500 100644
--- a/drivers/crypto/inside-secure/safexcel.c
+++ b/drivers/crypto/inside-secure/safexcel.c
@@ -895,16 +895,30 @@ static int safexcel_probe(struct platform_device *pdev)
 		}
 	}
 
+	priv->reg_clk = devm_clk_get(&pdev->dev, "reg");
+	ret = PTR_ERR_OR_ZERO(priv->reg_clk);
+	/* The clock isn't mandatory */
+	if  (ret != -ENOENT) {
+		if (ret)
+			goto err_core_clk;
+
+		ret = clk_prepare_enable(priv->reg_clk);
+		if (ret) {
+			dev_err(dev, "unable to enable reg clk (%d)\n", ret);
+			goto err_core_clk;
+		}
+	}
+
 	ret = dma_set_mask_and_coherent(dev, DMA_BIT_MASK(64));
 	if (ret)
-		goto err_clk;
+		goto err_reg_clk;
 
 	priv->context_pool = dmam_pool_create("safexcel-context", dev,
 					      sizeof(struct safexcel_context_record),
 					      1, 0);
 	if (!priv->context_pool) {
 		ret = -ENOMEM;
-		goto err_clk;
+		goto err_reg_clk;
 	}
 
 	safexcel_configure(priv);
@@ -919,12 +933,12 @@ static int safexcel_probe(struct platform_device *pdev)
 						     &priv->ring[i].cdr,
 						     &priv->ring[i].rdr);
 		if (ret)
-			goto err_clk;
+			goto err_reg_clk;
 
 		ring_irq = devm_kzalloc(dev, sizeof(*ring_irq), GFP_KERNEL);
 		if (!ring_irq) {
 			ret = -ENOMEM;
-			goto err_clk;
+			goto err_reg_clk;
 		}
 
 		ring_irq->priv = priv;
@@ -936,7 +950,7 @@ static int safexcel_probe(struct platform_device *pdev)
 						ring_irq);
 		if (irq < 0) {
 			ret = irq;
-			goto err_clk;
+			goto err_reg_clk;
 		}
 
 		priv->ring[i].work_data.priv = priv;
@@ -947,7 +961,7 @@ static int safexcel_probe(struct platform_device *pdev)
 		priv->ring[i].workqueue = create_singlethread_workqueue(wq_name);
 		if (!priv->ring[i].workqueue) {
 			ret = -ENOMEM;
-			goto err_clk;
+			goto err_reg_clk;
 		}
 
 		priv->ring[i].requests = 0;
@@ -968,18 +982,20 @@ static int safexcel_probe(struct platform_device *pdev)
 	ret = safexcel_hw_init(priv);
 	if (ret) {
 		dev_err(dev, "EIP h/w init failed (%d)\n", ret);
-		goto err_clk;
+		goto err_reg_clk;
 	}
 
 	ret = safexcel_register_algorithms(priv);
 	if (ret) {
 		dev_err(dev, "Failed to register algorithms (%d)\n", ret);
-		goto err_clk;
+		goto err_reg_clk;
 	}
 
 	return 0;
 
-err_clk:
+err_reg_clk:
+	clk_disable_unprepare(priv->reg_clk);
+err_core_clk:
 	clk_disable_unprepare(priv->clk);
 	return ret;
 }
diff --git a/drivers/crypto/inside-secure/safexcel.h b/drivers/crypto/inside-secure/safexcel.h
index d8dff65fc311..4efeb0251daf 100644
--- a/drivers/crypto/inside-secure/safexcel.h
+++ b/drivers/crypto/inside-secure/safexcel.h
@@ -525,6 +525,7 @@ struct safexcel_crypto_priv {
 	void __iomem *base;
 	struct device *dev;
 	struct clk *clk;
+	struct clk *reg_clk;
 	struct safexcel_config config;
 
 	enum safexcel_eip_version version;
-- 
2.16.1
