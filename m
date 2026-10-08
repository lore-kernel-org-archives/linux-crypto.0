Received: from m16.mail.163.com (m16.mail.163.com [117.135.210.3])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8C6D342123B;
	Thu,  8 Oct 2026 07:32:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=117.135.210.3
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791444778; cv=none; b=Yr/OjvVaJkU5EWzpT+8XetM8WvPlS6SlHU+Ej+f5J1XgoObEMIO2mIkWbzypyPcqyj2QqGtQ4vr3hVy0tiQ9QT8juhaFnXX801t30UR2RO0gCibXxwZSiSq8ALIvCVgzbkI/ZE3odGwtKFXianPTIdVWu32atKlPDFvx+joW1kI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791444778; c=relaxed/simple;
	bh=m0vtgVQMJDqWwBFFJ3teewOuydjipuEfH3+0jVNF4eY=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=lPuQdUujcso1yNdZBzbPQ4Zz7Mcm9d6QBp3Uq8GnpN1vKRI7vJ5hQ5LHEAVVRaRTiQH4qq34SNGPRuYeWBsHIRHNhmEQlen+aM7hQ6PvkpXmgh6DnA3NP5iFIVCglJD+ZEiAd58Zy1gomnzEcW0DhlNSnOzjBFQcQX+/+ZCB4WY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=163.com; spf=pass smtp.mailfrom=163.com; dkim=pass (1024-bit key) header.d=163.com header.i=@163.com header.b=SeLlkhmJ; arc=none smtp.client-ip=117.135.210.3
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=163.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=163.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=163.com header.i=@163.com header.b="SeLlkhmJ"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=163.com;
	s=s110527; h=From:To:Subject:Date:Message-Id:MIME-Version; bh=xj
	CQJ6zw60AJvAYBz016rNs4Ilh9koiA4J0p+PZWDdg=; b=SeLlkhmJ9jNVGDEJky
	7jkwa/1rW4CFkR9RWSIy9eqF00W3NKl8V14fKTZYdeJGs4HqFMSF13fKNxfGhYWF
	FmJsGXVIWEzU1j+tg905+Ph0V5QU9OKUqOZUVksPoeuj5/A4jhQTCBOkW5a9ZgQn
	C7gQe0mta0IZAhKCEj08d428I=
Received: from localhost.localdomain (unknown [])
	by gzga-smtp-mtada-g1-1 (Coremail) with SMTP id _____wD3v07tRsdqtq9hDA--.12178S4;
	Thu, 08 Oct 2026 15:32:06 +0800 (CST)
From: Qunqin Zhao <zhaoqunqin@163.com>
To: lee@kernel.org,
	zhaoqunqin@loongson.cn
Cc: chenhuacai@kernel.org,
	linux-kernel@vger.kernel.org,
	loongarch@lists.linux.dev,
	linux-crypto@vger.kernel.org,
	mfd@lists.linux.dev,
	Huacai Chen <chenhuacai@loongson.cn>
Subject: [PATCH v9 2/2] mfd: loongson-se: Fix miscellaneous issues
Date: Thu,  8 Oct 2026 15:31:51 +0800
Message-Id: <20261008073151.15808-3-zhaoqunqin@163.com>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20261008073151.15808-1-zhaoqunqin@163.com>
References: <20261008073151.15808-1-zhaoqunqin@163.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:_____wD3v07tRsdqtq9hDA--.12178S4
X-Coremail-Antispam: 1Uf129KBjvJXoW3tw1rur17tw1xKw47JFWrZrb_yoWDWw1fpF
	45CayYkr4jqr48CwsxJr98ZFy3ZrZ5tF9rCa93tw4xAFykJ34rWFW5KFy8WayfurWDtF17
	XFWkKFWru3WrC3DanT9S1TB71UUUUU7qnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
	9KBjDUYxBIdaVFxhVjvjDU0xZFpf9x07jezuAUUUUU=
X-CM-SenderInfo: 52kd01pxqtx0i6rwjhhfrp/xtbC7hdbmmrHRveiLAAA3q

From: Qunqin Zhao <zhaoqunqin@loongson.cn>

Address multiple historical driver issues discovered by the Sashiko
Automation system within the loongson_se_probe() initialization flow
and the driver's interrupt service routines [1].

- Add an explicit bounds check in se_irq_handler() before accessing
  the engines array to prevent an out-of-bounds memory access.

- Validate the id argument in loongson_se_init_engine() and reject
  engine 0, whose data buffer is reused for the command buffers of all
  other engines, to prevent out-of-bounds accesses and overlapping DMA
  buffers.

- Switch from devm_kmalloc() to devm_kzalloc() and initialize all
  engine completion structures in probe(), dropping the redundant
  init_completion() in loongson_se_init_engine().

- Introduce loongson_se_reinit_completion() to mask the target
  interrupt, clear any pending status, and reset the completion under
  dev_lock before a command is issued, then re-enable the interrupt
  under the same lock after the command has been triggered.  This
  closes the race where a stale interrupt from a previously
  interrupted command could complete the current command's completion.

- Wait for controller command completion with a bounded
  non-interruptible wait so a pending signal cannot leave the
  controller running while its DMA buffers are being torn down, and a
  wedged controller cannot hang the kernel indefinitely.

- Fix EPROBE_DEFER handling: propagate the error directly from
  platform_irq_count() instead of overwriting it with ENODEV so that
  probe deferral works when the interrupt provider is not yet ready.

- Validate dmam_size from firmware against the minimum required size
  to keep the command buffers of all engines within engine 0's data
  region and prevent overlapping DMA buffers.

- Return the error code from devm_request_irq() instead of silently
  continuing to prevent an indefinite hang.

- Add a loongson_se_stop() cleanup handler registered with
  devm_add_action_or_reset() before loongson_se_init() so that a
  failed init still stops the controller and masks all interrupts via
  devres, preventing DMA access to freed memory.

- Zero-initialize the local controller command structures in
  loongson_se_init() and loongson_se_init_engine() to prevent
  uninitialized stack data from being written to device registers.

- Add the SE_CMD_STOP command definition.

Link: https://lore.kernel.org/all/20260618095949.GB1672911@google.com/ [1]
Fixes: e551fa3159e3 ("mfd: Add support for Loongson Security Engine chip controller")
Signed-off-by: Qunqin Zhao <zhaoqunqin@loongson.cn>
Reviewed-by: Huacai Chen <chenhuacai@loongson.cn>
---
 drivers/mfd/loongson-se.c       | 105 ++++++++++++++++++++++++++++----
 include/linux/mfd/loongson-se.h |   1 +
 2 files changed, 95 insertions(+), 11 deletions(-)

diff --git a/drivers/mfd/loongson-se.c b/drivers/mfd/loongson-se.c
index 969378518..2fb5da85b 100644
--- a/drivers/mfd/loongson-se.c
+++ b/drivers/mfd/loongson-se.c
@@ -52,17 +52,48 @@ static int loongson_se_poll(struct loongson_se *se, u32 int_bit)
 						!(status & int_bit),
 						1, LOONGSON_ENGINE_CMD_TIMEOUT_US);
 
+	/*
+	 * Re-enable the interrupt that loongson_se_reinit_completion() masked.
+	 * The hardware guarantees that once the interrupt is re-enabled, only
+	 * interrupts for the command just issued can arrive, so a stale
+	 * interrupt from a previously interrupted command can never complete
+	 * this command's completion.
+	 */
+	writel(int_bit | readl(se->base + SE_S2LINT_EN), se->base + SE_S2LINT_EN);
+
 	spin_unlock_irq(&se->dev_lock);
 
 	return err;
 }
 
+/*
+ * Prepare a completion for a new command: mask the corresponding interrupt,
+ * clear any pending interrupt status, and reset the completion.  This runs
+ * under dev_lock so that the IRQ handler cannot race with it.  The interrupt
+ * is re-enabled in loongson_se_poll() after the command has been issued.
+ */
+static void loongson_se_reinit_completion(struct loongson_se *se,
+					  struct completion *completion, u32 int_bit)
+{
+	spin_lock_irq(&se->dev_lock);
+
+	writel(readl(se->base + SE_S2LINT_EN) & ~int_bit, se->base + SE_S2LINT_EN);
+
+	writel(int_bit, se->base + SE_S2LINT_CL);
+
+	reinit_completion(completion);
+
+	spin_unlock_irq(&se->dev_lock);
+}
+
 static int loongson_se_send_controller_cmd(struct loongson_se *se,
 					   struct loongson_se_controller_cmd *cmd)
 {
 	u32 *send_cmd = (u32 *)cmd;
 	int err, i;
 
+	loongson_se_reinit_completion(se, &se->cmd_completion, SE_INT_CONTROLLER);
+
 	for (i = 0; i < SE_SEND_CMD_REG_LEN; i++)
 		writel(send_cmd[i], se->base + SE_SEND_CMD_REG + i * 4);
 
@@ -70,18 +101,31 @@ static int loongson_se_send_controller_cmd(struct loongson_se *se,
 	if (err)
 		return err;
 
-	return wait_for_completion_interruptible(&se->cmd_completion);
+	/*
+	 * Wait for the controller to complete the command.  Use a bounded
+	 * non-interruptible wait: a pending signal must not leave the
+	 * controller running while its DMA buffers are being torn down.
+	 * One second is far more than any controller command should take,
+	 * while still bounding the wait if the hardware wedges.
+	 */
+	if (!wait_for_completion_timeout(&se->cmd_completion, HZ))
+		return -ETIMEDOUT;
+
+	return 0;
 }
 
 int loongson_se_send_engine_cmd(struct loongson_se_engine *engine)
 {
+	int err;
+
+	loongson_se_reinit_completion(engine->se, &engine->completion, BIT(engine->id));
+
 	/*
 	 * After engine initialization, the controller already knows
 	 * where to obtain engine commands from. Now all we need to
 	 * do is notify the controller that the engine needs to be started.
 	 */
-	int err = loongson_se_poll(engine->se, BIT(engine->id));
-
+	err = loongson_se_poll(engine->se, BIT(engine->id));
 	if (err)
 		return err;
 
@@ -92,12 +136,17 @@ EXPORT_SYMBOL_GPL(loongson_se_send_engine_cmd);
 struct loongson_se_engine *loongson_se_init_engine(struct device *dev, int id)
 {
 	struct loongson_se *se = dev_get_drvdata(dev);
-	struct loongson_se_engine *engine = &se->engines[id];
-	struct loongson_se_controller_cmd cmd;
+	struct loongson_se_engine *engine;
+	struct loongson_se_controller_cmd cmd = {0};
+
+	/* Engine 0 does not exist and its data buffer is reused for commands */
+	if (id <= 0 || id >= SE_ENGINE_MAX)
+		return NULL;
+
+	engine = &se->engines[id];
 
 	engine->se = se;
 	engine->id = id;
-	init_completion(&engine->completion);
 
 	/* Divide DMA memory equally among all engines */
 	engine->buffer_size = se->dmam_size / SE_ENGINE_MAX;
@@ -154,7 +203,8 @@ static irqreturn_t se_irq_handler(int irq, void *dev_id)
 	/* For engines */
 	while (int_status) {
 		id = __ffs(int_status);
-		complete(&se->engines[id].completion);
+		if (id < SE_ENGINE_MAX)
+			complete(&se->engines[id].completion);
 		int_status &= ~BIT(id);
 		writel(BIT(id), se->base + SE_S2LINT_CL);
 	}
@@ -166,7 +216,7 @@ static irqreturn_t se_irq_handler(int irq, void *dev_id)
 
 static int loongson_se_init(struct loongson_se *se, dma_addr_t addr, int size)
 {
-	struct loongson_se_controller_cmd cmd;
+	struct loongson_se_controller_cmd cmd = {0};
 	int err;
 
 	cmd.command_id = SE_CMD_START;
@@ -187,6 +237,17 @@ static const struct mfd_cell engines[] = {
 	{ .name = "tpm_loongson" },
 };
 
+static void loongson_se_stop(void *data)
+{
+	struct loongson_se *se = data;
+	struct loongson_se_controller_cmd cmd = {0};
+
+	cmd.command_id = SE_CMD_STOP;
+	loongson_se_send_controller_cmd(se, &cmd);
+
+	writel(0, se->base + SE_S2LINT_EN);
+}
+
 static int loongson_se_probe(struct platform_device *pdev)
 {
 	struct device *dev = &pdev->dev;
@@ -194,7 +255,7 @@ static int loongson_se_probe(struct platform_device *pdev)
 	int nr_irq, irq, err, i;
 	dma_addr_t paddr;
 
-	se = devm_kmalloc(dev, sizeof(*se), GFP_KERNEL);
+	se = devm_kzalloc(dev, sizeof(*se), GFP_KERNEL);
 	if (!se)
 		return -ENOMEM;
 
@@ -203,10 +264,24 @@ static int loongson_se_probe(struct platform_device *pdev)
 	spin_lock_init(&se->dev_lock);
 	mutex_init(&se->engine_init_lock);
 
+	for (i = 0; i < SE_ENGINE_MAX; i++)
+		init_completion(&se->engines[i].completion);
+
 	dma_set_mask_and_coherent(dev, DMA_BIT_MASK(64));
 	if (device_property_read_u32(dev, "dmam_size", &se->dmam_size))
 		return -ENODEV;
 
+	/*
+	 * Engine 0 does not exist and its data buffer is reused as the command
+	 * buffer for the other engines.  The command buffers of all engines
+	 * therefore must fit within engine 0's data region, i.e.
+	 * dmam_size / SE_ENGINE_MAX >= SE_ENGINE_MAX * 2 * SE_ENGINE_CMD_SIZE.
+	 * Enforce this to keep each engine's data and command buffers from
+	 * overlapping.
+	 */
+	if ((se->dmam_size / SE_ENGINE_MAX) < (SE_ENGINE_MAX * 2 * SE_ENGINE_CMD_SIZE))
+		return -EINVAL;
+
 	se->dmam_base = dmam_alloc_coherent(dev, se->dmam_size, &paddr, GFP_KERNEL);
 	if (!se->dmam_base)
 		return -ENOMEM;
@@ -216,20 +291,28 @@ static int loongson_se_probe(struct platform_device *pdev)
 		return PTR_ERR(se->base);
 
 	nr_irq = platform_irq_count(pdev);
-	if (nr_irq <= 0)
+	if (nr_irq == 0)
 		return -ENODEV;
+	if (nr_irq < 0)
+		return nr_irq;
 
 	writel(SE_INT_ALL, se->base + SE_S2LINT_CL);
 
 	for (i = 0; i < nr_irq; i++) {
 		irq = platform_get_irq(pdev, i);
 		err = devm_request_irq(dev, irq, se_irq_handler, IRQF_SHARED, "loongson-se", se);
-		if (err)
+		if (err) {
 			dev_err(dev, "failed to request IRQ: %d\n", irq);
+			return err;
+		}
 	}
 
 	writel(SE_INT_ALL, se->base + SE_S2LINT_EN);
 
+	err = devm_add_action_or_reset(dev, loongson_se_stop, se);
+	if (err)
+		return err;
+
 	err = loongson_se_init(se, paddr, se->dmam_size);
 	if (err)
 		return err;
diff --git a/include/linux/mfd/loongson-se.h b/include/linux/mfd/loongson-se.h
index 07afa0c25..8237ccab7 100644
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

