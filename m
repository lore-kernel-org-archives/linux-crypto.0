From: Boris Brezillon <boris.brezillon-wi1+55ScJUtKEb57/3fJTNBPR1lH4CV8@public.gmane.org>
Subject: [PATCH v6 02/14] crypto: mv_cesa: use gen_pool to reserve the SRAM memory region
Date: Wed, 17 Jun 2015 09:45:30 +0200
Message-ID: <1434527142-3609-3-git-send-email-boris.brezillon@free-electrons.com>
References: <1434527142-3609-1-git-send-email-boris.brezillon@free-electrons.com>
Cc: Boris Brezillon <boris.brezillon-wi1+55ScJUtKEb57/3fJTNBPR1lH4CV8@public.gmane.org>,
	Arnaud Ebalard <arno-LkuqDEemtHBg9hUCZPvPmw@public.gmane.org>,
	Tawfik Bayouk <tawfik-eYqpPyKDWXRBDgjK7y7TUQ@public.gmane.org>,
	Lior Amsalem <alior-eYqpPyKDWXRBDgjK7y7TUQ@public.gmane.org>,
	Nadav Haklai <nadavh-eYqpPyKDWXRBDgjK7y7TUQ@public.gmane.org>,
	Eran Ben-Avi <benavi-eYqpPyKDWXRBDgjK7y7TUQ@public.gmane.org>,
	Thomas Petazzoni <thomas.petazzoni-wi1+55ScJUtKEb57/3fJTNBPR1lH4CV8@public.gmane.org>,
	Gregory CLEMENT <gregory.clement-wi1+55ScJUtKEb57/3fJTNBPR1lH4CV8@public.gmane.org>,
	Jason Cooper <jason-NLaQJdtUoK4Be96aLqz0jA@public.gmane.org>,
	Sebastian Hesselbarth <sebastian.hesselbarth-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>,
	Andrew Lunn <andrew-g2DYL2Zd6BY@public.gmane.org>, Rob Herring <robh+dt-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>,
	Pawel Moll <pawel.moll-5wv7dgnIgG8@public.gmane.org>,
	Mark Rutland <mark.rutland-5wv7dgnIgG8@public.gmane.org>,
	Ian Campbell <ijc+devicetree-KcIKpvwj1kUDXYZnReoRVg@public.gmane.org>,
	Kumar Gala <galak-sgV2jX0FEOL9JmXXK+q4OQ@public.gmane.org>, devicetree-u79uwXL29TY76Z2rM5mHXA@public.gmane.org,
	linux-arm-kernel-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org,
	Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>,
	"Imre Kaloz" <kaloz-p3rKhJxN3npAfugRpC6u6w@public.gmane.org>
To: Herbert Xu <herbert-lOAM2aK0SrRLBo1qDEOMRrpzq4S04n8Q@public.gmane.org>,
	"David S. Miller" <davem-fT/PcQaiUtIeIZ0/mPfg9Q@public.gmane.org>,
	linux-crypto-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Return-path: <devicetree-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1434527142-3609-1-git-send-email-boris.brezillon-wi1+55ScJUtKEb57/3fJTNBPR1lH4CV8@public.gmane.org>
Sender: devicetree-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
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

Signed-off-by: Boris Brezillon <boris.brezillon-wi1+55ScJUtKEb57/3fJTNBPR1lH4CV8@public.gmane.org>
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

--
To unsubscribe from this list: send the line "unsubscribe devicetree" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
