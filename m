Received: from mail.loongson.cn (mail.loongson.cn [114.242.206.163])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D490D278753;
	Thu, 26 Feb 2026 02:24:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=114.242.206.163
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772072657; cv=none; b=tl9od6YHN6PuSzFV+FCwKH22Tp3eQzxxbZEeMf2RjGTy1p+orUlKkqw2dLyzQ0Z8dtK1WjR7oH5psu1S+eqcIr0hLYdF4uSKL4Dyxj8TG6vIZoRQ3EV3LS2AaWYHFBLStUPiAMiqwpjdpCpsStafPAC9n4rSbut+hre90wIil/E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772072657; c=relaxed/simple;
	bh=bKfT2sP3OZPx4EFpSptmKijNFOTmEnq4668yJBLVWQ0=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=gAHmRI0lZC1Ulrpl1AAJX+UNRnDAI2VIQ0S5K91D6f+32metWFVQzWhtZt/a5bRDfzuz8GzGiSFGCUb/L3MTWW5Pj7cIB1b+vLXg7g+dTzY42KLsc1/YXn8KoQT55Jed0L00tzKU4PiRIlmAjBGo+ppJu/dmkyah2fALM5mBHyg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=loongson.cn; spf=pass smtp.mailfrom=loongson.cn; arc=none smtp.client-ip=114.242.206.163
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=loongson.cn
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=loongson.cn
Received: from loongson.cn (unknown [10.40.54.15])
	by gateway (Coremail) with SMTP id _____8CxIMDNrp9pt08VAA--.5981S3;
	Thu, 26 Feb 2026 10:24:13 +0800 (CST)
Received: from localhost.localdomain (unknown [10.40.54.15])
	by front1 (Coremail) with SMTP id qMiowJDxzsLMrp9pXgxLAA--.10297S2;
	Thu, 26 Feb 2026 10:24:12 +0800 (CST)
From: Qunqin Zhao <zhaoqunqin@loongson.cn>
To: lee@kernel.org
Cc: linux-kernel@vger.kernel.org,
	linux-crypto@vger.kernel.org,
	Qunqin Zhao <zhaoqunqin@loongson.cn>
Subject: [PATCH] mfd: loongson-se: Add multi-node support
Date: Thu, 26 Feb 2026 18:22:25 +0800
Message-Id: <20260226102225.19516-1-zhaoqunqin@loongson.cn>
X-Mailer: git-send-email 2.20.1
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:qMiowJDxzsLMrp9pXgxLAA--.10297S2
X-CM-SenderInfo: 52kd01pxqtx0o6or00hjvr0hdfq/
X-Coremail-Antispam: 1Uk129KBj93XoWxXryrGF4fuw1kGr4kKr18Xrc_yoW5tF45pF
	WDCayFvF4UCF4xCwsYy398Crya9rWrt39rCFZFqr4xAas5twn3WrW5GFyUKF4rCFWUJF42
	qrWkGFW8CF48JFbCm3ZEXasCq-sJn29KB7ZKAUJUUUUU529EdanIXcx71UUUUU7KY7ZEXa
	sCq-sGcSsGvfJ3Ic02F40EFcxC0VAKzVAqx4xG6I80ebIjqfuFe4nvWSU5nxnvy29KBjDU
	0xBIdaVrnRJUUUvSb4IE77IF4wAFF20E14v26r1j6r4UM7CY07I20VC2zVCF04k26cxKx2
	IYs7xG6rWj6s0DM7CIcVAFz4kK6r1j6r18M280x2IEY4vEnII2IxkI6r1a6r45M28lY4IE
	w2IIxxk0rwA2F7IY1VAKz4vEj48ve4kI8wA2z4x0Y4vE2Ix0cI8IcVAFwI0_JFI_Gr1l84
	ACjcxK6xIIjxv20xvEc7CjxVAFwI0_Jr0_Gr1l84ACjcxK6I8E87Iv67AKxVWxJVW8Jr1l
	84ACjcxK6I8E87Iv6xkF7I0E14v26r4UJVWxJr1le2I262IYc4CY6c8Ij28IcVAaY2xG8w
	AqjxCEc2xF0cIa020Ex4CE44I27wAqx4xG64xvF2IEw4CE5I8CrVC2j2WlYx0E2Ix0cI8I
	cVAFwI0_Jr0_Jr4lYx0Ex4A2jsIE14v26r1j6r4UMcvjeVCFs4IE7xkEbVWUJVW8JwACjc
	xG0xvY0x0EwIxGrwCF04k20xvY0x0EwIxGrwCFx2IqxVCFs4IE7xkEbVWUJVW8JwC20s02
	6c02F40E14v26r1j6r18MI8I3I0E7480Y4vE14v26r106r1rMI8E67AF67kF1VAFwI0_JF
	0_Jw1lIxkGc2Ij64vIr41lIxAIcVC0I7IYx2IY67AKxVWUJVWUCwCI42IY6xIIjxv20xvE
	c7CjxVAFwI0_Jr0_Gr1lIxAIcVCF04k26cxKx2IYs7xG6r1j6r1xMIIF0xvEx4A2jsIE14
	v26r1j6r4UMIIF0xvEx4A2jsIEc7CjxVAFwI0_Jr0_GrUvcSsGvfC2KfnxnUUI43ZEXa7I
	U0miiDUUUUU==

On the Loongson platform, each node is equipped with a security engine
device. However, due to a hardware flaw, only the device on node 0 can
trigger interrupts. Therefore, interrupts from other nodes are forwarded
by node 0. We need to check in the interrupt handler of node 0 whether
this interrupt is intended for other nodes.

Signed-off-by: Qunqin Zhao <zhaoqunqin@loongson.cn>
---
 drivers/mfd/loongson-se.c       | 38 +++++++++++++++++++++++++++------
 include/linux/mfd/loongson-se.h |  3 +++
 2 files changed, 35 insertions(+), 6 deletions(-)

diff --git a/drivers/mfd/loongson-se.c b/drivers/mfd/loongson-se.c
index 3902ba377..40e18c212 100644
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
index 07afa0c25..a80e06eb0 100644
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
-- 
2.47.2

