Received: from mail.loongson.cn (mail.loongson.cn [114.242.206.163])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 959243CFF5E;
	Mon, 29 Jun 2026 07:24:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=114.242.206.163
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782717890; cv=none; b=ZjYrgl4/dn4TKMYJQMRB5/BjT2XNlFjkeRfHu4KVrborstxtEbbKCBGomBND+UJ0FK9qzT/qkXq9CMcxlwOZQ3zXVGeYVlKEZCkTzySj9jX51zty+SvxU27F2n9b7aVQufjwTID/KU3oMnlqsqgF6DxC3l1j2PSNSGZwW7h7Ly4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782717890; c=relaxed/simple;
	bh=t2j4x1tQzO6lUJC1qpDcM57ofV7QdQ0+xWJs3H/v980=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Ecp7SlqTtTPaOQSW26VmLEB5NCXWrrHFIMLKHumSU1iRAsUgGYH+WCaqAxxt7DsosASgBQcBHh1pQ5ZOfhHsg3U6Qp3keD30a0chz9ntxi7+Ko8Jip9dEDWgdT0m0qpRi2LV5pfpAZn2d4MtMZsSGcTFS6yWVAuwddW5tMa1lpQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=loongson.cn; spf=pass smtp.mailfrom=loongson.cn; arc=none smtp.client-ip=114.242.206.163
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=loongson.cn
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=loongson.cn
Received: from loongson.cn (unknown [10.40.54.123])
	by gateway (Coremail) with SMTP id _____8Cx3sC8HUJqmBMZAA--.40589S3;
	Mon, 29 Jun 2026 15:24:44 +0800 (CST)
Received: from localhost.localdomain (unknown [10.40.54.123])
	by front1 (Coremail) with SMTP id qMiowJDxhcCxHUJqJl63AA--.61324S3;
	Mon, 29 Jun 2026 15:24:42 +0800 (CST)
From: Qunqin Zhao <zhaoqunqin@loongson.cn>
To: lee@kernel.org
Cc: chenhuacai@kernel.org,
	xry111@xry111.site,
	linux-kernel@vger.kernel.org,
	loongarch@lists.linux.dev,
	linux-crypto@vger.kernel.org,
	Qunqin Zhao <zhaoqunqin@loongson.cn>
Subject: [PATCH v4 1/2] mfd: loongson-se: Fix miscellaneous issues
Date: Mon, 29 Jun 2026 15:11:08 +0800
Message-ID: <20260629071109.7341-2-zhaoqunqin@loongson.cn>
X-Mailer: git-send-email 2.47.2
In-Reply-To: <20260629071109.7341-1-zhaoqunqin@loongson.cn>
References: <20260629071109.7341-1-zhaoqunqin@loongson.cn>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:qMiowJDxhcCxHUJqJl63AA--.61324S3
X-CM-SenderInfo: 52kd01pxqtx0o6or00hjvr0hdfq/
X-Coremail-Antispam: 1Uk129KBj93XoWxZw4xCr48KFWDuF47Kw13Jrc_yoWrCw1fpF
	43ua4Ykr45CF48u398J398uFWa93yrtr9rCa9Fgw4xZFyDJw15WFy5KF1UGr4rArWvqr1U
	ZrykGrWfuF4rCabCm3ZEXasCq-sJn29KB7ZKAUJUUUUU529EdanIXcx71UUUUU7KY7ZEXa
	sCq-sGcSsGvfJ3Ic02F40EFcxC0VAKzVAqx4xG6I80ebIjqfuFe4nvWSU5nxnvy29KBjDU
	0xBIdaVrnRJUUUkFb4IE77IF4wAFF20E14v26r1j6r4UM7CY07I20VC2zVCF04k26cxKx2
	IYs7xG6rWj6s0DM7CIcVAFz4kK6r1Y6r17M28lY4IEw2IIxxk0rwA2F7IY1VAKz4vEj48v
	e4kI8wA2z4x0Y4vE2Ix0cI8IcVAFwI0_JFI_Gr1l84ACjcxK6xIIjxv20xvEc7CjxVAFwI
	0_Gr0_Cr1l84ACjcxK6I8E87Iv67AKxVW8Jr0_Cr1UM28EF7xvwVC2z280aVCY1x0267AK
	xVW8Jr0_Cr1UM2AIxVAIcxkEcVAq07x20xvEncxIr21l57IF6xkI12xvs2x26I8E6xACxx
	1l5I8CrVACY4xI64kE6c02F40Ex7xfMcIj6xIIjxv20xvE14v26r126r1DMcIj6I8E87Iv
	67AKxVWUJVW8JwAm72CE4IkC6x0Yz7v_Jr0_Gr1lF7xvr2IYc2Ij64vIr41l42xK82IYc2
	Ij64vIr41l4I8I3I0E4IkC6x0Yz7v_Jr0_Gr1lx2IqxVAqx4xG67AKxVWUJVWUGwC20s02
	6x8GjcxK67AKxVWUGVWUWwC2zVAF1VAY17CE14v26r126r1DMIIYrxkI7VAKI48JMIIF0x
	vE2Ix0cI8IcVAFwI0_Jr0_JF4lIxAIcVC0I7IYx2IY6xkF7I0E14v26r1j6r4UMIIF0xvE
	42xK8VAvwI8IcIk0rVWUJVWUCwCI42IY6I8E87Iv67AKxVWUJVW8JwCI42IY6I8E87Iv6x
	kF7I0E14v26r1j6r4UYxBIdaVFxhVjvjDU0xZFpf9x07j83kZUUUUU=

Address multiple historical driver issues discovered by the Sashiko
Automation system within the loongson_se_probe() initialization flow
and the driver's interrupt service routines [1].

- Add an explicit bounds check for 'id' before accessing the fixed-size
  'engines' array in se_irq_handler() to prevent potential out-of-bounds
  memory writes.

- Switch the allocations from devm_kmalloc() to devm_kzalloc() to
  guarantee the descriptor structures are properly zero-initialized.

- Return an error code from loongson_se_probe() if devm_request_irq()
  fails, preventing an indefinite hang during completion waits.

- Add a reinit_completion() before waiting on the completions to ensure
  proper hardware synchronization.

- Prevent writing uninitialized stack memory to device registers in
  loongson_se_init() by properly initializing local command structures.

- Add a .remove callback to the platform driver to properly halt the
  hardware.

Link: https://lore.kernel.org/all/20260618095949.GB1672911@google.com/ [1]
Fixes: e551fa3159e3 ("mfd: Add support for Loongson Security Engine chip controller")
Signed-off-by: Qunqin Zhao <zhaoqunqin@loongson.cn>
---
 drivers/mfd/loongson-se.c       | 23 +++++++++++++++++++----
 include/linux/mfd/loongson-se.h |  1 +
 2 files changed, 20 insertions(+), 4 deletions(-)

diff --git a/drivers/mfd/loongson-se.c b/drivers/mfd/loongson-se.c
index 3902ba377d..aa34e663c4 100644
--- a/drivers/mfd/loongson-se.c
+++ b/drivers/mfd/loongson-se.c
@@ -85,6 +85,8 @@ int loongson_se_send_engine_cmd(struct loongson_se_engine *engine)
 	if (err)
 		return err;
 
+	reinit_completion(&engine->completion);
+
 	return wait_for_completion_interruptible(&engine->completion);
 }
 EXPORT_SYMBOL_GPL(loongson_se_send_engine_cmd);
@@ -150,7 +152,8 @@ static irqreturn_t se_irq_handler(int irq, void *dev_id)
 	/* For engines */
 	while (int_status) {
 		id = __ffs(int_status);
-		complete(&se->engines[id].completion);
+		if (id < SE_ENGINE_MAX)
+			complete(&se->engines[id].completion);
 		int_status &= ~BIT(id);
 		writel(BIT(id), se->base + SE_S2LINT_CL);
 	}
@@ -162,7 +165,7 @@ static irqreturn_t se_irq_handler(int irq, void *dev_id)
 
 static int loongson_se_init(struct loongson_se *se, dma_addr_t addr, int size)
 {
-	struct loongson_se_controller_cmd cmd;
+	struct loongson_se_controller_cmd cmd = {0};
 	int err;
 
 	cmd.command_id = SE_CMD_START;
@@ -190,7 +193,7 @@ static int loongson_se_probe(struct platform_device *pdev)
 	int nr_irq, irq, err, i;
 	dma_addr_t paddr;
 
-	se = devm_kmalloc(dev, sizeof(*se), GFP_KERNEL);
+	se = devm_kzalloc(dev, sizeof(*se), GFP_KERNEL);
 	if (!se)
 		return -ENOMEM;
 
@@ -220,8 +223,10 @@ static int loongson_se_probe(struct platform_device *pdev)
 	for (i = 0; i < nr_irq; i++) {
 		irq = platform_get_irq(pdev, i);
 		err = devm_request_irq(dev, irq, se_irq_handler, 0, "loongson-se", se);
-		if (err)
+		if (err) {
 			dev_err(dev, "failed to request IRQ: %d\n", irq);
+			return err;
+		}
 	}
 
 	err = loongson_se_init(se, paddr, se->dmam_size);
@@ -232,6 +237,15 @@ static int loongson_se_probe(struct platform_device *pdev)
 				    ARRAY_SIZE(engines), NULL, 0, NULL);
 }
 
+static void loongson_se_remove(struct platform_device *pdev)
+{
+	struct loongson_se *se = dev_get_drvdata(&pdev->dev);
+	struct loongson_se_controller_cmd cmd = {0};
+
+	cmd.command_id = SE_CMD_STOP;
+	loongson_se_send_controller_cmd(se, &cmd);
+}
+
 static const struct acpi_device_id loongson_se_acpi_match[] = {
 	{ "LOON0011", 0 },
 	{ }
@@ -240,6 +254,7 @@ MODULE_DEVICE_TABLE(acpi, loongson_se_acpi_match);
 
 static struct platform_driver loongson_se_driver = {
 	.probe   = loongson_se_probe,
+	.remove  = loongson_se_remove,
 	.driver  = {
 		.name  = "loongson-se",
 		.acpi_match_table = loongson_se_acpi_match,
diff --git a/include/linux/mfd/loongson-se.h b/include/linux/mfd/loongson-se.h
index 07afa0c252..8237ccab7b 100644
--- a/include/linux/mfd/loongson-se.h
+++ b/include/linux/mfd/loongson-se.h
@@ -9,6 +9,7 @@
 #define SE_SEND_CMD_REG_LEN		0x8
 /* Controller command ID */
 #define SE_CMD_START			0x0
+#define SE_CMD_STOP			0x1
 #define SE_CMD_SET_DMA			0x3
 #define SE_CMD_SET_ENGINE_CMDBUF	0x4
 
-- 
2.47.2

