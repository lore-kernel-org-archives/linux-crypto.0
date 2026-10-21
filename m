Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792584969;
	b=5RJ0BOzjgcPJs+nH6SrenXYjp3XoumSvfO+cU5JCwnl503HXtvYUVpXDV0/6yoxL0JTI
	 zf6yaK672hhm0mjIGYD/PAWkxuQBA1q14hsnERqjTqM/EmmZ6ATUDIKAGLuUm4o5q3SUt
	 wZsjMqCTwDttMFOEIEeQAlm2sb2T6U4H123EjdLsuY0pNxWC2NoEQ+ofR2vxgf0d2x3d5
	 sS58dje22y9b5Wa/l8FhagVKh/lypt21afVhnQA2X0vBQwML2HwNmYP9JmcKTtCGxRLFO
	 /Rh1GDhmvKALId7emT0ErSkiZ4CqVAk7D1Aw3FdvXrc65h3h1iwZ7G1qFcWu15Xby8w==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792584969;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:MIME-Version:Content-Transfer-Encoding;
	bh=Sf9fJdSyPeRmn/1W4deZFEkwuU0Kwy1ZCNgzXzfL19o=;
	b=5rxwqUgw7ABtS2oSGV6ZKdm4oUm0aHgj4ma/Qu8VJMbdcAhsfQ40bMpK+bnz4HYiig+d
	 AT/8uAGegTYGyb2WX7/hnKTH6hMUBpVACsJfUSmT7EAsvJLfA66k5FwIp4IJuGACQ6eu3
	 hc6flTjvjdeFVpj1e5r4JG+hLQ0Kd2YhR4+MkYDHk2rhiP5X6VblHfyNn617LeQOs76A6
	 f8pR73yJlPm8sVunyIobajs9Izxr9FvHDJpzIDTnZTvHLf9YJJrepheuX6x3ga+Di2ES6
	 N+QI1wm3NQCoC7aJoFatenVeY+rAv5BQrwDt/TCT/6pTtMFWcS4O/tW77r7JX6AWBjw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=cCtTa8Ae;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B6AC8606A33F;
	Wed, 21 Oct 2026 12:16:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=cCtTa8Ae
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 75F041F000C4;
	Wed, 21 Oct 2026 12:16:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792584968;
	bh=Sf9fJdSyPeRmn/1W4deZFEkwuU0Kwy1ZCNgzXzfL19o=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=cCtTa8Aear95HeH0E4hgjpI9jvlI+CTZtaksUKqFR9/BvJKBh0jNnmn6xD1shNQ5V
	 Yp3IFW3bWSOy40C0+odXwuVtp5f+iukJNSNNMihZ+QxeN48Mo0t3y+43D+/QGXfase
	 eEJ4dQYdxW0jlNlGHEODI4SSSDS5Bzso44SjHhZGh/ACsO72Fa+vsAUH4CKz4iG5EO
	 OIkWjpeWAMlGQmJd0Az0uBDKCcoy/7w/O+1Ue1BqvuM3t46/U/h4s930CycbzIc3wR
	 MbEA/BNKTroRPJWkb/uuy9fVDhRlXLY1Oh9y1D7ckQkXzjAlivVFTfMQqQ5aqVq4fr
	 qUw4zaeGLVwSg==
From: Lee Jones <lee@kernel.org>
To: lee@kernel.org,
	Qunqin Zhao <zhaoqunqin@loongson.cn>,
	Yinggang Gu <guyinggang@loongson.cn>,
	Huacai Chen <chenhuacai@kernel.org>,
	linux-crypto@vger.kernel.org,
	mfd@lists.linux.dev,
	linux-kernel@vger.kernel.org
Cc: stable@vger.kernel.org
Subject: [PATCH 20/28] mfd: loongson-se: Stop controller and mask interrupts on teardown and shutdown
Date: Wed, 21 Oct 2026 12:09:42 +0000
Message-ID: <20261021121245.3111563-20-lee@kernel.org>
X-Mailer: git-send-email 2.56.0.218.g1ec904b173-goog
In-Reply-To: <20261021121245.3111563-1-lee@kernel.org>
References: <20261021121245.3111563-1-lee@kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Post: <mailto:linux-crypto@vger.kernel.org>
List-Help: <mailto:linux-crypto+help@vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-crypto+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

loongson_se_probe() enables hardware interrupts before registering IRQ
handlers and starts the controller via loongson_se_init(), but provides
no teardown or shutdown handler to stop the controller and mask
interrupts.  If probe fails after loongson_se_init(), if the driver is
unbound, or during a system reboot or kexec transition, the controller
remains active with DMA configured to memory that is reclaimed.

Clear pending interrupts before requesting IRQs, unmask interrupts only
after IRQ handlers are registered, clean up on failure inside
loongson_se_init(), register a devres action after loongson_se_init()
succeeds to issue SE_CMD_STOP and mask interrupts on teardown, and wire
up the platform driver .shutdown callback.

Fixes: e551fa3159e3 ("mfd: Add support for Loongson Security Engine chip controller")
Closes: https://sashiko.dev/#/bug/linux-15511672-7569-4eac-96a0-c08581925710
Closes: https://sashiko.dev/#/bug/linux-e6ed8d33-d641-4969-a5ea-959f21ae3696
Cc: stable@vger.kernel.org
Signed-off-by: Lee Jones <lee@kernel.org>
---
 drivers/mfd/loongson-se.c       | 51 +++++++++++++++++++++++++++++----
 include/linux/mfd/loongson-se.h |  1 +
 2 files changed, 46 insertions(+), 6 deletions(-)

diff --git a/drivers/mfd/loongson-se.c b/drivers/mfd/loongson-se.c
index 10af13c3b7cc..bdbab4b91729 100644
--- a/drivers/mfd/loongson-se.c
+++ b/drivers/mfd/loongson-se.c
@@ -169,6 +169,23 @@ static irqreturn_t se_irq_handler(int irq, void *dev_id)
 	return IRQ_HANDLED;
 }
 
+static void loongson_se_stop(void *data)
+{
+	struct loongson_se *se = data;
+	struct loongson_se_controller_cmd cmd = {};
+
+	mutex_lock(&se->engine_init_lock);
+
+	cmd.command_id = SE_CMD_STOP;
+	loongson_se_send_controller_cmd(se, &cmd);
+
+	spin_lock_irq(&se->dev_lock);
+	writel(0, se->base + SE_S2LINT_EN);
+	spin_unlock_irq(&se->dev_lock);
+
+	mutex_unlock(&se->engine_init_lock);
+}
+
 static int loongson_se_init(struct loongson_se *se, dma_addr_t addr, int size)
 {
 	struct loongson_se_controller_cmd cmd = {};
@@ -176,15 +193,23 @@ static int loongson_se_init(struct loongson_se *se, dma_addr_t addr, int size)
 
 	cmd.command_id = SE_CMD_START;
 	err = loongson_se_send_controller_cmd(se, &cmd);
-	if (err)
+	if (err) {
+		writel(0, se->base + SE_S2LINT_EN);
 		return err;
+	}
 
 	cmd.command_id = SE_CMD_SET_DMA;
 	cmd.info[0] = lower_32_bits(addr);
 	cmd.info[1] = upper_32_bits(addr);
 	cmd.info[2] = size;
 
-	return loongson_se_send_controller_cmd(se, &cmd);
+	err = loongson_se_send_controller_cmd(se, &cmd);
+	if (err) {
+		loongson_se_stop(se);
+		return err;
+	}
+
+	return 0;
 }
 
 static const struct mfd_cell engines[] = {
@@ -192,6 +217,13 @@ static const struct mfd_cell engines[] = {
 	{ .name = "tpm_loongson" },
 };
 
+static void loongson_se_shutdown(struct platform_device *pdev)
+{
+	struct loongson_se *se = platform_get_drvdata(pdev);
+
+	loongson_se_stop(se);
+}
+
 static int loongson_se_probe(struct platform_device *pdev)
 {
 	struct device *dev = &pdev->dev;
@@ -225,12 +257,12 @@ static int loongson_se_probe(struct platform_device *pdev)
 	if (IS_ERR(se->base))
 		return PTR_ERR(se->base);
 
-	writel(SE_INT_ALL, se->base + SE_S2LINT_EN);
-
 	nr_irq = platform_irq_count(pdev);
 	if (nr_irq <= 0)
 		return -ENODEV;
 
+	writel(SE_INT_ALL, se->base + SE_S2LINT_CL);
+
 	for (i = 0; i < nr_irq; i++) {
 		irq = platform_get_irq(pdev, i);
 		err = devm_request_irq(dev, irq, se_irq_handler, 0, "loongson-se", se);
@@ -238,10 +270,16 @@ static int loongson_se_probe(struct platform_device *pdev)
 			dev_err(dev, "failed to request IRQ: %d\n", irq);
 	}
 
+	writel(SE_INT_ALL, se->base + SE_S2LINT_EN);
+
 	err = loongson_se_init(se, paddr, se->dmam_size);
 	if (err)
 		return err;
 
+	err = devm_add_action_or_reset(dev, loongson_se_stop, se);
+	if (err)
+		return err;
+
 	return devm_mfd_add_devices(dev, PLATFORM_DEVID_NONE, engines,
 				    ARRAY_SIZE(engines), NULL, 0, NULL);
 }
@@ -253,8 +291,9 @@ static const struct acpi_device_id loongson_se_acpi_match[] = {
 MODULE_DEVICE_TABLE(acpi, loongson_se_acpi_match);
 
 static struct platform_driver loongson_se_driver = {
-	.probe   = loongson_se_probe,
-	.driver  = {
+	.probe    = loongson_se_probe,
+	.shutdown = loongson_se_shutdown,
+	.driver   = {
 		.name  = "loongson-se",
 		.acpi_match_table = loongson_se_acpi_match,
 	},
diff --git a/include/linux/mfd/loongson-se.h b/include/linux/mfd/loongson-se.h
index 2d0a8b1e5c9e..dbe5992bd435 100644
--- a/include/linux/mfd/loongson-se.h
+++ b/include/linux/mfd/loongson-se.h
@@ -11,6 +11,7 @@
 #define SE_SEND_CMD_REG_LEN		0x8
 /* Controller command ID */
 #define SE_CMD_START			0x0
+#define SE_CMD_STOP			0x1
 #define SE_CMD_SET_DMA			0x3
 #define SE_CMD_SET_ENGINE_CMDBUF	0x4
 
-- 
2.56.0.218.g1ec904b173-goog

