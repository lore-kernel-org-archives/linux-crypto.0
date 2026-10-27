Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793097492;
	b=P+5VWPFc4n72yhastAeEyGcAHMdEXcQ7aGeXd9JcqNtlhs87KxMJj7/qcLql0MK5zLvF
	 IxyMpn5J43YeGFWRxcdH3hF4j9m7OmQEAwuK0hJvZiIugpTmMa5CjJYxjaBT5eplbpffE
	 nBfklbUgHYfuw2V/6n2m2XtQU7tSdS7Gk+8maudDhz5wEsp3KUyFJg70NOkZxXw7FDJaB
	 9zAC/Cd4JjOFA5yff724ZzpTg3QMH6VQT35ZkmVhoI04J00TYCZU3za+kuavn8dtBamqv
	 cIeYd5Fr+b4qCSq+wU36SzaYcBp+mDFnMFXt2FHC87atc8BrID447EYrU43PFEXD/2Q==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793097492;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:MIME-Version:Content-Transfer-Encoding;
	bh=6ZqnaHaUS4JVuYK4+S2laGLI8DaJ0zLPxhW7BuLfhYQ=;
	b=KcvhIlwGkUEKu/xbHVWG59C6b/E/mNFeU4AdWjWkBuKXeGW6ZtAXNto5RJKk6uKFlAs8
	 smrTZ0+T69HST4wFuxRDR9kzuB4+fo4hgK25BdRmM4vRjV8iqIAUd6L8S4if5qj8XDN3y
	 UZOq6V+zjpzznJJYHPs1LPDkG5sNbBYfTSrUsMyCS2EQ5cd6ledv+4rdROawIDUhWuAUf
	 osdTWds/EWXF6b9ZqLwdRflh7CjVw9TAt09oGW5Do1Ey2+xsKI0lmsGS/Rne2DJ8GG6OD
	 bohLXCeEcTjBFd12LlSsmYUmE8utv3jFEwag1o123kvCq4L1Fx4bx7O3JFlmxOpfqYQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=KQqhyX1w;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B7961606A31A;
	Tue, 27 Oct 2026 10:38:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=KQqhyX1w
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EB6B11F01825;
	Tue, 27 Oct 2026 10:38:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793097491;
	bh=6ZqnaHaUS4JVuYK4+S2laGLI8DaJ0zLPxhW7BuLfhYQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=KQqhyX1wiz6R4rIaGGbBzKwiQss+QP2CmiUcMM4nk3YV554fOSIjtwoNbw004fqOH
	 iMld+tkAVYqJ4XRikgsLoZunVxzU2Te+EQ4F4+vCZhaJA/rQfy8mZfQNFY/MCtgCeX
	 CuV1hBR/pKKG7fo2inzoRr6+TUhAWNprq+uSJiJnK0uOf19ZAZj0X3yjI91ZOwdikj
	 6GmcWXn0Pg+QqDKrelTXM8/iAdhg2grCphIkfUgzMeIC1PbBGQDkUtaHKGnMnt0yFi
	 gdJC6RCyPx93koLsxBUCdJ8DiwF1Hc/fAvKNu3QFXD6shCtk4pannUzlR/S5pEUEnO
	 PjxptKVC7mirQ==
From: Lee Jones <lee@kernel.org>
To: lee@kernel.org,
	Qunqin Zhao <zhaoqunqin@loongson.cn>,
	Yinggang Gu <guyinggang@loongson.cn>,
	Huacai Chen <chenhuacai@kernel.org>,
	linux-crypto@vger.kernel.org,
	mfd@lists.linux.dev,
	linux-kernel@vger.kernel.org
Cc: stable@vger.kernel.org
Subject: [PATCH v2 19/27] mfd: loongson-se: Stop controller and mask interrupts on teardown and shutdown
Date: Tue, 27 Oct 2026 09:30:48 +0000
Message-ID: <20261027093306.2812695-20-lee@kernel.org>
X-Mailer: git-send-email 2.56.0.307.g5fe7bd680c-goog
In-Reply-To: <20261027093306.2812695-1-lee@kernel.org>
References: <20261027093306.2812695-1-lee@kernel.org>
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
Reviewed-by: Qunqin Zhao <zhaoqunqin@loongson.cn>
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
2.56.0.307.g5fe7bd680c-goog

