From: Boris Brezillon <boris.brezillon@free-electrons.com>
Subject: [PATCH v7 02/14] crypto: mv_cesa: use gen_pool to reserve the SRAM
 memory region
Date: Thu, 18 Jun 2015 15:46:18 +0200
Message-ID: <1434635190-27733-3-git-send-email-boris.brezillon@free-electrons.com>
References: <1434635190-27733-1-git-send-email-boris.brezillon@free-electrons.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Cc: Lior Amsalem <alior@marvell.com>, Andrew Lunn <andrew@lunn.ch>,
 Nadav Haklai <nadavh@marvell.com>, Mark Rutland <mark.rutland@arm.com>,
 Boris Brezillon <boris.brezillon@free-electrons.com>,
 Russell King - ARM Linux <linux@arm.linux.org.uk>,
 Tawfik Bayouk <tawfik@marvell.com>, Eran Ben-Avi <benavi@marvell.com>,
 Jason Gunthorpe <jgunthorpe@obsidianresearch.com>,
 Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>,
 devicetree@vger.kernel.org, Jason Cooper <jason@lakedaemon.net>,
 Pawel Moll <pawel.moll@arm.com>, Ian Campbell <ijc+devicetree@hellion.org.uk>,
 Arnaud Ebalard <arno@natisbad.org>, Rob Herring <robh+dt@kernel.org>,
 Gregory CLEMENT <gregory.clement@free-electrons.com>,
 linux-arm-kernel@lists.infradead.org,
 Thomas Petazzoni <thomas.petazzoni@free-electrons.com>,
 linux-kernel@vger.kernel.org, Kumar Gala <galak@codeaurora.org>,
 Imre Kaloz <kaloz@openwrt.org>
To: Herbert Xu <herbert@gondor.apana.org.au>,
 "David S. Miller" <davem@davemloft.net>, linux-crypto@vger.kernel.org
Return-path: <linux-arm-kernel-bounces+linux-arm-kernel=m.gmane.org@lists.infradead.org>
In-Reply-To: <1434635190-27733-1-git-send-email-boris.brezillon@free-electrons.com>
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

The mv_cesa driver currently expects the SRAM memory region to be passed
as a platform device resource.

This approach implies two drawbacks:
- the DT representation is wrong
- the only one that can access the SRAM is the crypto engine

The last point is particularly annoying in some cases: for example on
armada 370, a small region of the crypto SRAM is used to implement the
cpuidle, which means you would not be able to enable both cpuidle and the
CESA driver.

To address that problem, we explicitly define the SRAM device in the DT
and then reference the sram node from the crypto engine node.

Also note that the old way of retrieving the SRAM memory region is still
supported, or in other words, backward compatibility is preserved.

Signed-off-by: Boris Brezillon <boris.brezillon@free-electrons.com>
---
 .../devicetree/bindings/crypto/mv_cesa.txt         | 24 ++++++---
 drivers/crypto/Kconfig                             |  1 +
 drivers/crypto/mv_cesa.c                           | 58 ++++++++++++++++------
 3 files changed, 60 insertions(+), 23 deletions(-)

diff --git a/Documentation/devicetree/bindings/crypto/mv_cesa.txt b/Documentation/devicetree/bindings/crypto/mv_cesa.txt
index eaa2873..13b8fc5 100644
--- a/Documentation/devicetree/bindings/crypto/mv_cesa.txt
+++ b/Documentation/devicetree/bindings/crypto/mv_cesa.txt
@@ -2,21 +2,29 @@ Marvell Cryptographic Engines And Security Accelerator
 
 Required properties:
 - compatible : should be "marvell,orion-crypto"
-- reg : base physical address of the engine and length of memory mapped
-        region, followed by base physical address of sram and its memory
-        length
-- reg-names : "regs" , "sram";
-- interrupts : interrupt number
+- reg: base physical address of the engine and length of memory mapped
+       region. Can also contain an entry for the SRAM attached to the CESA,
+       but this representation is deprecated and marvell,crypto-srams should
+       be used instead
+- reg-names: "regs". Can contain an "sram" entry, but this representation
+	     is deprecated and marvell,crypto-srams should be used instead
+- interrupts: interrupt number
 - clocks: reference to the crypto engines clocks. This property is only
 	  required for Dove platforms
+- marvell,crypto-srams: phandle to crypto SRAM definitions
+
+Optional properties:
+- marvell,crypto-sram-size: SRAM size reserved for crypto operations, if not
+			    specified the whole SRAM is used (2KB)
 
 Examples:
 
 	crypto@30000 {
 		compatible = "marvell,orion-crypto";
-		reg = <0x30000 0x10000>,
-		      <0x4000000 0x800>;
-		reg-names = "regs" , "sram";
+		reg = <0x30000 0x10000>;
+		reg-names = "regs";
 		interrupts = <22>;
+		marvell,crypto-srams = <&crypto_sram>;
+		marvell,crypto-sram-size = <0x600>;
 		status = "okay";
 	};
diff --git a/drivers/crypto/Kconfig b/drivers/crypto/Kconfig
index 033c0c8..a6bbea8 100644
--- a/drivers/crypto/Kconfig
+++ b/drivers/crypto/Kconfig
@@ -166,6 +166,7 @@ config CRYPTO_DEV_MV_CESA
 	select CRYPTO_AES
 	select CRYPTO_BLKCIPHER2
 	select CRYPTO_HASH
+	select SRAM
 	help
 	  This driver allows you to utilize the Cryptographic Engines and
 	  Security Accelerator (CESA) which can be found on the Marvell Orion
diff --git a/drivers/crypto/mv_cesa.c b/drivers/crypto/mv_cesa.c
index 27b2373..a4c8637 100644
--- a/drivers/crypto/mv_cesa.c
+++ b/drivers/crypto/mv_cesa.c
@@ -9,6 +9,7 @@
 #include <crypto/aes.h>
 #include <crypto/algapi.h>
 #include <linux/crypto.h>
+#include <linux/genalloc.h>
 #include <linux/interrupt.h>
 #include <linux/io.h>
 #include <linux/kthread.h>
@@ -29,6 +30,8 @@
 #define MAX_HW_HASH_SIZE	0xFFFF
 #define MV_CESA_EXPIRE		500 /* msec */
 
+#define MV_CESA_DEFAULT_SRAM_SIZE	2048
+
 /*
  * STM:
  *   /---------------------------------------\
@@ -83,6 +86,8 @@ struct req_progress {
 struct crypto_priv {
 	void __iomem *reg;
 	void __iomem *sram;
+	struct gen_pool *sram_pool;
+	dma_addr_t sram_dma;
 	int irq;
 	struct clk *clk;
 	struct task_struct *queue_th;
@@ -1019,6 +1024,39 @@ static struct ahash_alg mv_hmac_sha1_alg = {
 		 }
 };
 
+static int mv_cesa_get_sram(struct platform_device *pdev,
+			    struct crypto_priv *cp)
+{
+	struct resource *res;
+	u32 sram_size = MV_CESA_DEFAULT_SRAM_SIZE;
+
+	of_property_read_u32(pdev->dev.of_node, "marvell,crypto-sram-size",
+			     &sram_size);
+
+	cp->sram_size = sram_size;
+	cp->sram_pool = of_get_named_gen_pool(&pdev->dev.of_node,
+					      "marvell,crypto-srams", 0);
+	if (cp->sram_pool) {
+		cp->sram = gen_pool_dma_alloc(cp->sram_pool, sram_size,
+					      &cp->sram_dma);
+		if (cp->sram)
+			return 0;
+
+		return -ENOMEM;
+	}
+
+	res = platform_get_resource_byname(pdev, IORESOURCE_MEM,
+					   "sram");
+	if (!res || resource_size(res) < cp->sram_size)
+		return -EINVAL;
+
+	cp->sram = devm_ioremap_resource(&pdev->dev, res);
+	if (IS_ERR(cp->sram))
+		return PTR_ERR(cp->sram);
+
+	return 0;
+}
+
 static int mv_probe(struct platform_device *pdev)
 {
 	struct crypto_priv *cp;
@@ -1047,18 +1085,11 @@ static int mv_probe(struct platform_device *pdev)
 		goto err;
 	}
 
-	res = platform_get_resource_byname(pdev, IORESOURCE_MEM, "sram");
-	if (!res) {
-		ret = -ENXIO;
+	ret = mv_cesa_get_sram(pdev, cp);
+	if (ret)
 		goto err;
-	}
-	cp->sram_size = resource_size(res);
+
 	cp->max_req_size = cp->sram_size - SRAM_CFG_SPACE;
-	cp->sram = ioremap(res->start, cp->sram_size);
-	if (!cp->sram) {
-		ret = -ENOMEM;
-		goto err;
-	}
 
 	if (pdev->dev.of_node)
 		irq = irq_of_parse_and_map(pdev->dev.of_node, 0);
@@ -1066,7 +1097,7 @@ static int mv_probe(struct platform_device *pdev)
 		irq = platform_get_irq(pdev, 0);
 	if (irq < 0 || irq == NO_IRQ) {
 		ret = irq;
-		goto err_unmap_sram;
+		goto err;
 	}
 	cp->irq = irq;
 
@@ -1076,7 +1107,7 @@ static int mv_probe(struct platform_device *pdev)
 	cp->queue_th = kthread_run(queue_manag, cp, "mv_crypto");
 	if (IS_ERR(cp->queue_th)) {
 		ret = PTR_ERR(cp->queue_th);
-		goto err_unmap_sram;
+		goto err;
 	}
 
 	ret = request_irq(irq, crypto_int, 0, dev_name(&pdev->dev),
@@ -1134,8 +1165,6 @@ err_irq:
 	}
 err_thread:
 	kthread_stop(cp->queue_th);
-err_unmap_sram:
-	iounmap(cp->sram);
 err:
 	kfree(cp);
 	cpg = NULL;
@@ -1155,7 +1184,6 @@ static int mv_remove(struct platform_device *pdev)
 	kthread_stop(cp->queue_th);
 	free_irq(cp->irq, cp);
 	memset(cp->sram, 0, cp->sram_size);
-	iounmap(cp->sram);
 
 	if (!IS_ERR(cp->clk)) {
 		clk_disable_unprepare(cp->clk);
-- 
1.9.1
