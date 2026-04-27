Received: from mail.loongson.cn (mail.loongson.cn [114.242.206.163])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C59843537FF;
	Mon, 27 Apr 2026 08:55:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=114.242.206.163
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777280151; cv=none; b=WTyyYBuyEf4H3c9pjeXucxixE3p5B1NnhPf0R+yhSPfXmJ3nTxkxHMPfbSz+aA/FpNFe6PCwf6L6vvhqSO4uyQBo3fwEZsxaA0zOAnlhI+vV6vxJYxNKE17ov8PKfE7jreoJZB2VkUUvuGtvluP2xyNsCP/WKGX07N5m2+TZpzc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777280151; c=relaxed/simple;
	bh=3h6KE49s5na7FVqF/JgPMHtxUXHsdU4YsryRRiVX8og=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=sfp8/xikQvkqdddGzl9zlh1gVJYS5MlrRvy4Z6JyKoIP8DQ8FwjPgkNH/2nUKNamhCH/5JyUt3mMzgwLLUoF8eLkpF2WlyItc5N5X2BWXRXKA3ft9k1xghNsbRKUC/T5oxTO+m8VD21/8J7JLljhxDXFnWZ9f8SK8UB4UBwHiEk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=loongson.cn; spf=pass smtp.mailfrom=loongson.cn; arc=none smtp.client-ip=114.242.206.163
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=loongson.cn
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=loongson.cn
Received: from loongson.cn (unknown [10.40.54.15])
	by gateway (Coremail) with SMTP id _____8BxzemSJO9plU0EAA--.12910S3;
	Mon, 27 Apr 2026 16:55:46 +0800 (CST)
Received: from localhost.localdomain (unknown [10.40.54.15])
	by front1 (Coremail) with SMTP id qMiowJCxHOGRJO9pmaB1AA--.26788S2;
	Mon, 27 Apr 2026 16:55:45 +0800 (CST)
From: Qunqin Zhao <zhaoqunqin@loongson.cn>
To: lee@kernel.org
Cc: linux-kernel@vger.kernel.org,
	loongarch@lists.linux.dev,
	linux-crypto@vger.kernel.org,
	Qunqin Zhao <zhaoqunqin@loongson.cn>
Subject: [PATCH v2] mfd: loongson-se: Add multi-node support
Date: Tue, 28 Apr 2026 00:51:33 +0800
Message-Id: <20260427165133.23350-1-zhaoqunqin@loongson.cn>
X-Mailer: git-send-email 2.20.1
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:qMiowJCxHOGRJO9pmaB1AA--.26788S2
X-CM-SenderInfo: 52kd01pxqtx0o6or00hjvr0hdfq/
X-Coremail-Antispam: 1Uk129KBj93XoWxXry5Jw4rAF4rWrWxZFWUtrc_yoWrGFy5pF
	WDCayFvF4UCF47CwsYy398Cry3u3yrt39rGFZFgr4xAas8twn7WrWrKFyjgF45CFWUJF42
	qrZ5GFW8CF48CabCm3ZEXasCq-sJn29KB7ZKAUJUUUUU529EdanIXcx71UUUUU7KY7ZEXa
	sCq-sGcSsGvfJ3Ic02F40EFcxC0VAKzVAqx4xG6I80ebIjqfuFe4nvWSU5nxnvy29KBjDU
	0xBIdaVrnRJUUUvqb4IE77IF4wAFF20E14v26r1j6r4UM7CY07I20VC2zVCF04k26cxKx2
	IYs7xG6rWj6s0DM7CIcVAFz4kK6r106r15M280x2IEY4vEnII2IxkI6r1a6r45M28lY4IE
	w2IIxxk0rwA2F7IY1VAKz4vEj48ve4kI8wA2z4x0Y4vE2Ix0cI8IcVAFwI0_JFI_Gr1l84
	ACjcxK6xIIjxv20xvEc7CjxVAFwI0_Gr0_Cr1l84ACjcxK6I8E87Iv67AKxVW8Jr0_Cr1U
	M28EF7xvwVC2z280aVCY1x0267AKxVW8Jr0_Cr1UM2AIxVAIcxkEcVAq07x20xvEncxIr2
	1l57IF6xkI12xvs2x26I8E6xACxx1l5I8CrVACY4xI64kE6c02F40Ex7xfMcIj6xIIjxv2
	0xvE14v26r1j6r18McIj6I8E87Iv67AKxVWUJVW8JwAm72CE4IkC6x0Yz7v_Jr0_Gr1lF7
	xvr2IYc2Ij64vIr41l42xK82IYc2Ij64vIr41l4I8I3I0E4IkC6x0Yz7v_Jr0_Gr1lx2Iq
	xVAqx4xG67AKxVWUJVWUGwC20s026x8GjcxK67AKxVWUGVWUWwC2zVAF1VAY17CE14v26r
	126r1DMIIYrxkI7VAKI48JMIIF0xvE2Ix0cI8IcVAFwI0_Jr0_JF4lIxAIcVC0I7IYx2IY
	6xkF7I0E14v26r1j6r4UMIIF0xvE42xK8VAvwI8IcIk0rVWUJVWUCwCI42IY6I8E87Iv67
	AKxVWUJVW8JwCI42IY6I8E87Iv6xkF7I0E14v26r1j6r4UYxBIdaVFxhVjvjDU0xZFpf9x
	07jDsqAUUUUU=

On the Loongson platform, each node is equipped with a security engine
device. However, due to a hardware flaw, only the device on node 0 can
trigger interrupts. Therefore, interrupts from other nodes are forwarded
by node 0. We need to check in the interrupt handler of node 0 whether
this interrupt is intended for other nodes.

Signed-off-by: Qunqin Zhao <zhaoqunqin@loongson.cn>
---
Changes in v2:
	-Resending due to no feedback for one month.
	-Rebased on top of latest mainline (7.1-rc1) to ensure the patch
	 applies cleanly.
	-No functional changes since the previous submission.

Link to v1:
https://lore.kernel.org/all/20260226102225.19516-1-zhaoqunqin@loongson.cn/#t

 drivers/mfd/loongson-se.c       | 38 +++++++++++++++++++++++++++------
 include/linux/mfd/loongson-se.h |  3 +++
 2 files changed, 35 insertions(+), 6 deletions(-)

diff --git a/drivers/mfd/loongson-se.c b/drivers/mfd/loongson-se.c
index 3902ba377d6..40e18c21268 100644
--- a/drivers/mfd/loongson-se.c
+++ b/drivers/mfd/loongson-se.c
@@ -37,6 +37,9 @@ struct loongson_se_controller_cmd {
 	u32 info[7];
 };
 
+static DECLARE_COMPLETION(node0);
+static struct loongson_se *se_node[SE_MAX_NODES];
+
 static int loongson_se_poll(struct loongson_se *se, u32 int_bit)
 {
 	u32 status;
@@ -133,8 +136,8 @@ EXPORT_SYMBOL_GPL(loongson_se_init_engine);
 static irqreturn_t se_irq_handler(int irq, void *dev_id)
 {
 	struct loongson_se *se = dev_id;
-	u32 int_status;
-	int id;
+	u32 int_status, node_irq = 0;
+	int id, node;
 
 	spin_lock(&se->dev_lock);
 
@@ -147,6 +150,11 @@ static irqreturn_t se_irq_handler(int irq, void *dev_id)
 		writel(SE_INT_CONTROLLER, se->base + SE_S2LINT_CL);
 	}
 
+	if (int_status & SE_INT_OTHER_NODE) {
+		int_status &= ~SE_INT_OTHER_NODE;
+		node_irq = 1;
+	}
+
 	/* For engines */
 	while (int_status) {
 		id = __ffs(int_status);
@@ -157,6 +165,14 @@ static irqreturn_t se_irq_handler(int irq, void *dev_id)
 
 	spin_unlock(&se->dev_lock);
 
+	if (node_irq) {
+		writel(SE_INT_OTHER_NODE, se->base + SE_S2LINT_CL);
+		for (node = 1; node < SE_MAX_NODES; node++) {
+			if (se_node[node])
+				se_irq_handler(irq, se_node[node]);
+		}
+	}
+
 	return IRQ_HANDLED;
 }
 
@@ -189,6 +205,7 @@ static int loongson_se_probe(struct platform_device *pdev)
 	struct loongson_se *se;
 	int nr_irq, irq, err, i;
 	dma_addr_t paddr;
+	int node = dev_to_node(dev);
 
 	se = devm_kmalloc(dev, sizeof(*se), GFP_KERNEL);
 	if (!se)
@@ -213,9 +230,16 @@ static int loongson_se_probe(struct platform_device *pdev)
 
 	writel(SE_INT_ALL, se->base + SE_S2LINT_EN);
 
-	nr_irq = platform_irq_count(pdev);
-	if (nr_irq <= 0)
-		return -ENODEV;
+	if (node == 0 || node == NUMA_NO_NODE) {
+		nr_irq = platform_irq_count(pdev);
+		if (nr_irq <= 0)
+			return -ENODEV;
+	} else {
+		/* Only the device on node 0 can trigger interrupts */
+		nr_irq = 0;
+		wait_for_completion_interruptible(&node0);
+		se_node[node] = se;
+	}
 
 	for (i = 0; i < nr_irq; i++) {
 		irq = platform_get_irq(pdev, i);
@@ -228,7 +252,9 @@ static int loongson_se_probe(struct platform_device *pdev)
 	if (err)
 		return err;
 
-	return devm_mfd_add_devices(dev, PLATFORM_DEVID_NONE, engines,
+	complete_all(&node0);
+
+	return devm_mfd_add_devices(dev, PLATFORM_DEVID_AUTO, engines,
 				    ARRAY_SIZE(engines), NULL, 0, NULL);
 }
 
diff --git a/include/linux/mfd/loongson-se.h b/include/linux/mfd/loongson-se.h
index 07afa0c2524..a80e06eb017 100644
--- a/include/linux/mfd/loongson-se.h
+++ b/include/linux/mfd/loongson-se.h
@@ -20,6 +20,9 @@
 
 #define SE_INT_ALL			0xffffffff
 #define SE_INT_CONTROLLER		BIT(0)
+#define SE_INT_OTHER_NODE		BIT(31)
+
+#define SE_MAX_NODES			8
 
 #define SE_ENGINE_MAX			16
 #define SE_ENGINE_RNG			1

base-commit: 254f49634ee16a731174d2ae34bc50bd5f45e731
-- 
2.47.2

