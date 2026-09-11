Received: from m16.mail.163.com (m16.mail.163.com [220.197.31.3])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B5B9846AA91;
	Fri, 11 Sep 2026 09:03:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=220.197.31.3
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789117414; cv=none; b=qTgHyAe2sxmFIAFk8wmLFkJeeZgLuVtyHPr89SPS4ZHoNiHJ/wFOwa37KupfjYqJ9xNBIzyJhDlsiTp2sgEH/KDl8rA27gvR/k+hVBFKIdSo25zFD1nRR2x45FzapDeIJqmyWjL6ydA9f4FuL8UjWfMiNxRNw0e1JY/GuRJmf0U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789117414; c=relaxed/simple;
	bh=TcKWNaNhN0+I5VPpUJNE+2tROXpzxpbBZkauphfRpnc=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=gexziIgm1jIif/ZQEPPy9dyz93zofUUwQVrURIy8jftdeRUzZRdlJXYj5ZLVEt3w/xcM0FQ0IFkVqAuDrj9v3wmDniT7lTlLjOsQh0BPiqX8D2pRirYRz/ysKj95SzU5sIMZku8c1xP4iATBPQ3lKPIrIKxzOz801vEkMGQ/x2M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=163.com; spf=pass smtp.mailfrom=163.com; dkim=pass (1024-bit key) header.d=163.com header.i=@163.com header.b=P5ptKNtq; arc=none smtp.client-ip=220.197.31.3
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=163.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=163.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=163.com header.i=@163.com header.b="P5ptKNtq"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=163.com;
	s=s110527; h=From:To:Subject:Date:Message-Id:MIME-Version; bh=1Y
	4zU6kUUQR4F1ihZt2fHR04+NDuRyDO2tsD8y6dyVg=; b=P5ptKNtq5CH/kJyqZ7
	85GKU2JsLgFAjq0i6stpslL1g5h96pV+MhHPEUA7kTTDOE5YbxV/Kruw7JePTMez
	fNZRhj8ZyDPgTo6sVjPpSdDKcqHGpvoFkJjnNaezj3UOwBqwKhIR7/S+lTE9otm5
	ICaJOZN234c9V4IS41BTwXx9E=
Received: from localhost.localdomain (unknown [])
	by gzsmtp5 (Coremail) with SMTP id QCgvCgDnjyvCw6Nq5PUqRA--.58051S4;
	Fri, 11 Sep 2026 17:03:04 +0800 (CST)
From: Qunqin Zhao <zhaoqunqin@163.com>
To: lee@kernel.org,
	zhaoqunqin@loongson.cn
Cc: chenhuacai@kernel.org,
	linux-kernel@vger.kernel.org,
	loongarch@lists.linux.dev,
	linux-crypto@vger.kernel.org,
	mfd@lists.linux.dev
Subject: [PATCH v7 2/2] mfd: loongson-se: Fix miscellaneous issues
Date: Fri, 11 Sep 2026 17:02:56 +0800
Message-Id: <20260911090256.7834-3-zhaoqunqin@163.com>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20260911090256.7834-1-zhaoqunqin@163.com>
References: <20260911090256.7834-1-zhaoqunqin@163.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:QCgvCgDnjyvCw6Nq5PUqRA--.58051S4
X-Coremail-Antispam: 1Uf129KBjvJXoW3tw1rur48Zw1DWrWrZr1DKFg_yoWDKF1fpF
	4YkayYkr4qqr48CwsxJr98ZFy3ZrZ5tr9rCa93tw4xAF1kJ34rWFy5KFyUWayrurWDtF17
	XFWkKFWru3WrC3DanT9S1TB71UUUUU7qnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
	9KBjDUYxBIdaVFxhVjvjDU0xZFpf9x07b0KsbUUUUU=
X-CM-SenderInfo: 52kd01pxqtx0i6rwjhhfrp/xtbC7gmm5Wqjw8mlfAAA3+

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
  A new poll_lock serializes the trigger and poll busy-wait so
  interrupts are not disabled for up to 10 ms.

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
---
 drivers/mfd/loongson-se.c       | 112 ++++++++++++++++++++++++++++----
 include/linux/mfd/loongson-se.h |   1 +
 2 files changed, 102 insertions(+), 11 deletions(-)

diff --git a/drivers/mfd/loongson-se.c b/drivers/mfd/loongson-se.c
index 7f552a8ee..18075d4fa 100644
--- a/drivers/mfd/loongson-se.c
+++ b/drivers/mfd/loongson-se.c
@@ -23,6 +23,8 @@
 struct loongson_se {
 	void __iomem *base;
 	spinlock_t dev_lock;
+	/* Synchronizes command submission between users of different engines */
+	spinlock_t poll_lock;
 	struct completion cmd_completion;
 
 	void *dmam_base;
@@ -42,7 +44,7 @@ static int loongson_se_poll(struct loongson_se *se, u32 int_bit)
 	u32 status;
 	int err;
 
-	spin_lock_irq(&se->dev_lock);
+	spin_lock(&se->poll_lock);
 
 	/* Notify the controller that the engine needs to be started */
 	writel(int_bit, se->base + SE_L2SINT_SET);
@@ -52,17 +54,51 @@ static int loongson_se_poll(struct loongson_se *se, u32 int_bit)
 						!(status & int_bit),
 						1, LOONGSON_ENGINE_CMD_TIMEOUT_US);
 
+	spin_unlock(&se->poll_lock);
+
+	spin_lock_irq(&se->dev_lock);
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
 
@@ -70,17 +106,31 @@ static int loongson_se_send_controller_cmd(struct loongson_se *se,
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
+	err = loongson_se_poll(engine->se, BIT(engine->id));
 
 	if (err)
 		return err;
@@ -92,12 +142,17 @@ EXPORT_SYMBOL_GPL(loongson_se_send_engine_cmd);
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
@@ -155,7 +210,8 @@ static irqreturn_t se_irq_handler(int irq, void *dev_id)
 	/* For engines */
 	while (int_status) {
 		id = __ffs(int_status);
-		complete(&se->engines[id].completion);
+		if (id < SE_ENGINE_MAX)
+			complete(&se->engines[id].completion);
 		int_status &= ~BIT(id);
 		writel(BIT(id), se->base + SE_S2LINT_CL);
 	}
@@ -167,7 +223,7 @@ static irqreturn_t se_irq_handler(int irq, void *dev_id)
 
 static int loongson_se_init(struct loongson_se *se, dma_addr_t addr, int size)
 {
-	struct loongson_se_controller_cmd cmd;
+	struct loongson_se_controller_cmd cmd = {0};
 	int err;
 
 	cmd.command_id = SE_CMD_START;
@@ -188,6 +244,17 @@ static const struct mfd_cell engines[] = {
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
@@ -195,19 +262,34 @@ static int loongson_se_probe(struct platform_device *pdev)
 	int nr_irq, irq, err, i;
 	dma_addr_t paddr;
 
-	se = devm_kmalloc(dev, sizeof(*se), GFP_KERNEL);
+	se = devm_kzalloc(dev, sizeof(*se), GFP_KERNEL);
 	if (!se)
 		return -ENOMEM;
 
 	dev_set_drvdata(dev, se);
 	init_completion(&se->cmd_completion);
 	spin_lock_init(&se->dev_lock);
+	spin_lock_init(&se->poll_lock);
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
@@ -217,20 +299,28 @@ static int loongson_se_probe(struct platform_device *pdev)
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

