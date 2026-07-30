Received: from mail.loongson.cn (mail.loongson.cn [114.242.206.163])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0A1663D34B1;
	Thu, 30 Jul 2026 08:40:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=114.242.206.163
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785400862; cv=none; b=TDz9Io/BFAErAyGy+Aspm5QcXn/eG8byRqw1Kp0/ZeVbFIOqxakyiB4tJ1uanBQOiRZ5Bc8yEhNtXOp4nw6rOOYoUPCEw70v8/Foo3N20BXg3oe5JkD6SC0YSkVusGTlbhp9oUIB1Qirwfpntqv6PogYqDJwxjhIrnfrXPlCoc4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785400862; c=relaxed/simple;
	bh=9bYnK7Lrhqbih1LeaBhp06hhsWEebkhR4HhD87C4eoM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=SonwO1q3xqL63zY6Xjua2OeOIYxxY4ojHnx/q3nt+8CnPHarlyTg6eKmMHKSVLSXMeTOtOy47fHaT84/txXyTdgBFd9AOZXhQS/gqrUdhyMWi4/0heSLggZseWao6b9vrDSfuCGKQbl5m7DOcoqnZqll7JiK5TH5WcNqc967SkY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=loongson.cn; spf=pass smtp.mailfrom=loongson.cn; arc=none smtp.client-ip=114.242.206.163
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=loongson.cn
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=loongson.cn
Received: from loongson.cn (unknown [10.40.54.123])
	by gateway (Coremail) with SMTP id _____8AxFOgYDmtqHM0IAA--.6751S3;
	Thu, 30 Jul 2026 16:40:56 +0800 (CST)
Received: from localhost.localdomain (unknown [10.40.54.123])
	by front1 (Coremail) with SMTP id qMiowJAxTsUNDmtqc50dAA--.27500S4;
	Thu, 30 Jul 2026 16:40:55 +0800 (CST)
From: Qunqin Zhao <zhaoqunqin@loongson.cn>
To: lee@kernel.org
Cc: chenhuacai@kernel.org,
	linux-kernel@vger.kernel.org,
	loongarch@lists.linux.dev,
	linux-crypto@vger.kernel.org,
	Qunqin Zhao <zhaoqunqin@loongson.cn>
Subject: [PATCH v5 2/2] mfd: loongson-se: Fix miscellaneous issues
Date: Thu, 30 Jul 2026 16:26:08 +0800
Message-ID: <20260730082608.1929-3-zhaoqunqin@loongson.cn>
X-Mailer: git-send-email 2.47.2
In-Reply-To: <20260730082608.1929-1-zhaoqunqin@loongson.cn>
References: <20260730082608.1929-1-zhaoqunqin@loongson.cn>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:qMiowJAxTsUNDmtqc50dAA--.27500S4
X-CM-SenderInfo: 52kd01pxqtx0o6or00hjvr0hdfq/
X-Coremail-Antispam: 1Uk129KBj93XoWxtrWDtw1xWFW7CrW7ZF13trc_yoWftFy5pF
	45C3yYkr4jqr48Cws8J3s8uF4avr95trZrCa9Iqa1xAF1DJ34rWFy5tFyUWayfCrWqqF17
	XFZ5KFWruF1rA3gCm3ZEXasCq-sJn29KB7ZKAUJUUUU5529EdanIXcx71UUUUU7KY7ZEXa
	sCq-sGcSsGvfJ3Ic02F40EFcxC0VAKzVAqx4xG6I80ebIjqfuFe4nvWSU5nxnvy29KBjDU
	0xBIdaVrnRJUUUk2b4IE77IF4wAFF20E14v26r1j6r4UM7CY07I20VC2zVCF04k26cxKx2
	IYs7xG6rWj6s0DM7CIcVAFz4kK6r1Y6r17M28lY4IEw2IIxxk0rwA2F7IY1VAKz4vEj48v
	e4kI8wA2z4x0Y4vE2Ix0cI8IcVAFwI0_JFI_Gr1l84ACjcxK6xIIjxv20xvEc7CjxVAFwI
	0_Gr0_Cr1l84ACjcxK6I8E87Iv67AKxVW8Jr0_Cr1UM28EF7xvwVC2z280aVCY1x0267AK
	xVW8Jr0_Cr1UM2AIxVAIcxkEcVAq07x20xvEncxIr21l57IF6xkI12xvs2x26I8E6xACxx
	1l5I8CrVACY4xI64kE6c02F40Ex7xfMcIj6xIIjxv20xvE14v26r1q6rW5McIj6I8E87Iv
	67AKxVW8JVWxJwAm72CE4IkC6x0Yz7v_Jr0_Gr1lF7xvr2IYc2Ij64vIr41l42xK82IYc2
	Ij64vIr41l4I8I3I0E4IkC6x0Yz7v_Jr0_Gr1lx2IqxVAqx4xG67AKxVWUJVWUGwC20s02
	6x8GjcxK67AKxVWUGVWUWwC2zVAF1VAY17CE14v26r126r1DMIIYrxkI7VAKI48JMIIF0x
	vE2Ix0cI8IcVAFwI0_JFI_Gr1lIxAIcVC0I7IYx2IY6xkF7I0E14v26r4j6F4UMIIF0xvE
	42xK8VAvwI8IcIk0rVWUJVWUCwCI42IY6I8E87Iv67AKxVW8JVWxJwCI42IY6I8E87Iv6x
	kF7I0E14v26r4j6r4UJbIYCTnIWIevJa73UjIFyTuYvjxUcCD7UUUUU

Address multiple historical driver issues discovered by the Sashiko
Automation system within the loongson_se_probe() initialization flow
and the driver's interrupt service routines [1].

- Add an explicit bounds check in se_irq_handler() before accessing
  the engines array to prevent out-of-bounds memory writes.

- Switch from devm_kmalloc() to devm_kzalloc() and explicitly
  initialize all engine completion structures in probe() to avoid a
  kernel panic from complete() dereferencing a NULL wait head when a
  spurious interrupt fires before child drivers call
  loongson_se_init_engine().

- Replace engine_init_lock with a broader cmd_lock mutex that
  serializes all command submissions, and move the lock into
  loongson_se_send_controller_cmd() and
  loongson_se_send_engine_cmd() to cover the full register write +
  poll + wait sequence.

- Drop the spin_lock_irq from loongson_se_poll() so that interrupts
  are not disabled for up to 10 ms during the poll.  Keep the
  readl_relaxed_poll_timeout_atomic() busy-wait to avoid scheduling
  latency for fast hardware completions.

- Add reinit_completion() to loongson_se_send_controller_cmd() and
  loongson_se_send_engine_cmd() before waiting to prevent stale
  completions from falsely returning success after a signal
  interruption.

- Fix EPROBE_DEFER handling: propagate the error directly from
  platform_irq_count() instead of overwriting it with ENODEV so that
  probe deferral works when the interrupt provider is not yet ready.

- Validate dmam_size from firmware against the minimum required size
  to prevent command buffers from pointing outside the allocated
  DMA region.

- Return the error code from devm_request_irq() instead of silently
  continuing to prevent an indefinite hang.

- Disable hardware interrupts in the probe error path when
  loongson_se_init() fails to prevent an unhandled interrupt storm.

- Add a loongson_se_stop() cleanup handler registered with
  devm_add_action_or_reset() to send SE_CMD_STOP to the controller
  and mask all interrupts during device removal.  Using devres
  ensures that child MFD devices are unbound before the controller
  is stopped.  The STOP command uses a non-interruptible wait to
  avoid leaving hardware running while DMA buffers are freed.

- Zero-initialize the local controller command structure in
  loongson_se_init() to prevent uninitialized stack memory from
  being written to device registers.

- Add the SE_CMD_STOP command definition.

Link: https://lore.kernel.org/all/20260618095949.GB1672911@google.com/ [1]
Fixes: e551fa3159e3 ("mfd: Add support for Loongson Security Engine chip controller")
Signed-off-by: Qunqin Zhao <zhaoqunqin@loongson.cn>
---
 drivers/mfd/loongson-se.c       | 87 ++++++++++++++++++++++++++-------
 include/linux/mfd/loongson-se.h |  1 +
 2 files changed, 69 insertions(+), 19 deletions(-)

diff --git a/drivers/mfd/loongson-se.c b/drivers/mfd/loongson-se.c
index 7f552a8ee6..2c8afad1b0 100644
--- a/drivers/mfd/loongson-se.c
+++ b/drivers/mfd/loongson-se.c
@@ -28,7 +28,7 @@ struct loongson_se {
 	void *dmam_base;
 	int dmam_size;
 
-	struct mutex engine_init_lock;
+	struct mutex cmd_lock;
 	struct loongson_se_engine engines[SE_ENGINE_MAX];
 };
 
@@ -42,8 +42,6 @@ static int loongson_se_poll(struct loongson_se *se, u32 int_bit)
 	u32 status;
 	int err;
 
-	spin_lock_irq(&se->dev_lock);
-
 	/* Notify the controller that the engine needs to be started */
 	writel(int_bit, se->base + SE_L2SINT_SET);
 
@@ -52,8 +50,6 @@ static int loongson_se_poll(struct loongson_se *se, u32 int_bit)
 						!(status & int_bit),
 						1, LOONGSON_ENGINE_CMD_TIMEOUT_US);
 
-	spin_unlock_irq(&se->dev_lock);
-
 	return err;
 }
 
@@ -63,24 +59,40 @@ static int loongson_se_send_controller_cmd(struct loongson_se *se,
 	u32 *send_cmd = (u32 *)cmd;
 	int err, i;
 
+	mutex_lock(&se->cmd_lock);
+
+	reinit_completion(&se->cmd_completion);
+
 	for (i = 0; i < SE_SEND_CMD_REG_LEN; i++)
 		writel(send_cmd[i], se->base + SE_SEND_CMD_REG + i * 4);
 
 	err = loongson_se_poll(se, SE_INT_CONTROLLER);
 	if (err)
-		return err;
+		goto out;
+
+	err = wait_for_completion_interruptible(&se->cmd_completion);
 
-	return wait_for_completion_interruptible(&se->cmd_completion);
+out:
+	mutex_unlock(&se->cmd_lock);
+	return err;
 }
 
 int loongson_se_send_engine_cmd(struct loongson_se_engine *engine)
 {
+	int err;
+
+	mutex_lock(&engine->se->cmd_lock);
+
+	reinit_completion(&engine->completion);
+
 	/*
 	 * After engine initialization, the controller already knows
 	 * where to obtain engine commands from. Now all we need to
 	 * do is notify the controller that the engine needs to be started.
 	 */
-	int err = loongson_se_poll(engine->se, BIT(engine->id));
+	err = loongson_se_poll(engine->se, BIT(engine->id));
+
+	mutex_unlock(&engine->se->cmd_lock);
 
 	if (err)
 		return err;
@@ -97,7 +109,7 @@ struct loongson_se_engine *loongson_se_init_engine(struct device *dev, int id)
 
 	engine->se = se;
 	engine->id = id;
-	init_completion(&engine->completion);
+	reinit_completion(&engine->completion);
 
 	/* Divide DMA memory equally among all engines */
 	engine->buffer_size = se->dmam_size / SE_ENGINE_MAX;
@@ -113,8 +125,6 @@ struct loongson_se_engine *loongson_se_init_engine(struct device *dev, int id)
 	engine->command = se->dmam_base + id * (2 * SE_ENGINE_CMD_SIZE);
 	engine->command_ret = engine->command + SE_ENGINE_CMD_SIZE;
 
-	mutex_lock(&se->engine_init_lock);
-
 	/* Tell the controller where to find engine command */
 	cmd.command_id = SE_CMD_SET_ENGINE_CMDBUF;
 	cmd.info[0] = id;
@@ -124,8 +134,6 @@ struct loongson_se_engine *loongson_se_init_engine(struct device *dev, int id)
 	if (loongson_se_send_controller_cmd(se, &cmd))
 		engine = NULL;
 
-	mutex_unlock(&se->engine_init_lock);
-
 	return engine;
 }
 EXPORT_SYMBOL_GPL(loongson_se_init_engine);
@@ -155,7 +163,8 @@ static irqreturn_t se_irq_handler(int irq, void *dev_id)
 	/* For engines */
 	while (int_status) {
 		id = __ffs(int_status);
-		complete(&se->engines[id].completion);
+		if (id < SE_ENGINE_MAX)
+			complete(&se->engines[id].completion);
 		int_status &= ~BIT(id);
 		writel(BIT(id), se->base + SE_S2LINT_CL);
 	}
@@ -167,7 +176,7 @@ static irqreturn_t se_irq_handler(int irq, void *dev_id)
 
 static int loongson_se_init(struct loongson_se *se, dma_addr_t addr, int size)
 {
-	struct loongson_se_controller_cmd cmd;
+	struct loongson_se_controller_cmd cmd = {0};
 	int err;
 
 	cmd.command_id = SE_CMD_START;
@@ -188,6 +197,30 @@ static const struct mfd_cell engines[] = {
 	{ .name = "tpm_loongson" },
 };
 
+static void loongson_se_stop(void *data)
+{
+	struct loongson_se *se = data;
+	struct loongson_se_controller_cmd cmd = {0};
+	u32 *send_cmd = (u32 *)&cmd;
+	int i;
+
+	mutex_lock(&se->cmd_lock);
+
+	cmd.command_id = SE_CMD_STOP;
+
+	reinit_completion(&se->cmd_completion);
+
+	for (i = 0; i < SE_SEND_CMD_REG_LEN; i++)
+		writel(send_cmd[i], se->base + SE_SEND_CMD_REG + i * 4);
+
+	if (!loongson_se_poll(se, SE_INT_CONTROLLER))
+		wait_for_completion(&se->cmd_completion);
+
+	writel(0, se->base + SE_S2LINT_EN);
+
+	mutex_unlock(&se->cmd_lock);
+}
+
 static int loongson_se_probe(struct platform_device *pdev)
 {
 	struct device *dev = &pdev->dev;
@@ -195,19 +228,25 @@ static int loongson_se_probe(struct platform_device *pdev)
 	int nr_irq, irq, err, i;
 	dma_addr_t paddr;
 
-	se = devm_kmalloc(dev, sizeof(*se), GFP_KERNEL);
+	se = devm_kzalloc(dev, sizeof(*se), GFP_KERNEL);
 	if (!se)
 		return -ENOMEM;
 
 	dev_set_drvdata(dev, se);
 	init_completion(&se->cmd_completion);
 	spin_lock_init(&se->dev_lock);
-	mutex_init(&se->engine_init_lock);
+	mutex_init(&se->cmd_lock);
+
+	for (i = 0; i < SE_ENGINE_MAX; i++)
+		init_completion(&se->engines[i].completion);
 
 	dma_set_mask_and_coherent(dev, DMA_BIT_MASK(64));
 	if (device_property_read_u32(dev, "dmam_size", &se->dmam_size))
 		return -ENODEV;
 
+	if (se->dmam_size < (SE_ENGINE_MAX * 2 * SE_ENGINE_CMD_SIZE))
+		return -EINVAL;
+
 	se->dmam_base = dmam_alloc_coherent(dev, se->dmam_size, &paddr, GFP_KERNEL);
 	if (!se->dmam_base)
 		return -ENOMEM;
@@ -217,21 +256,31 @@ static int loongson_se_probe(struct platform_device *pdev)
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
 
 	err = loongson_se_init(se, paddr, se->dmam_size);
+	if (err) {
+		writel(0, se->base + SE_S2LINT_EN);
+		return err;
+	}
+
+	err = devm_add_action_or_reset(dev, loongson_se_stop, se);
 	if (err)
 		return err;
 
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
2.47.3

