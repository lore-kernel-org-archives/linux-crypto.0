Received: from mail.loongson.cn (mail.loongson.cn [114.242.206.163])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id CBBE51ADC8C;
	Tue, 14 Jan 2025 09:56:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=114.242.206.163
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736848593; cv=none; b=WkMn3pA+ji6aOujweVc5FTT+x9zWNwr4z36sgxKhXMqPRA1UAXxHiElxyOKvo1bBlBGhTT/dO56GSEdn6fkhumbpygzyricsjBe2gLlLGTFx0iilgHRcJCxF2ftIlmPI44fqrhTQMECMOCDZlcfms6irzksOK726SNCdUkQZtd4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736848593; c=relaxed/simple;
	bh=jTuh1Ev5IZPcdkNdsy2IZdo8ZZhkoLL3jWd/jM68nnw=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=FaH3mjWoebyHkdc4UMBLX9Cfte6VeU7gSZwYwtcfuy2H/fGzXmSrOPRpv+BGacbAMwRd9OVnCw7nnqL7DW+wmMWws5xE5KZkcb2xjpdv96JqGiqgGqH1g10znCyrfbKPm3woDiSCNvgeUYfCz18Dpvt4hpbk2LT/pJJoq/U2qHw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=loongson.cn; spf=pass smtp.mailfrom=loongson.cn; arc=none smtp.client-ip=114.242.206.163
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=loongson.cn
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=loongson.cn
Received: from loongson.cn (unknown [10.40.54.90])
	by gateway (Coremail) with SMTP id _____8CxieDJNIZn_h9jAA--.62592S3;
	Tue, 14 Jan 2025 17:56:25 +0800 (CST)
Received: from localhost.localdomain (unknown [10.40.54.90])
	by front1 (Coremail) with SMTP id qMiowMBxReSoNIZnct0hAA--.2343S4;
	Tue, 14 Jan 2025 17:56:10 +0800 (CST)
From: Qunqin Zhao <zhaoqunqin@loongson.cn>
To: lee@kernel.org,
	herbert@gondor.apana.org.au,
	gregkh@linuxfoundation.org
Cc: linux-kernel@vger.kernel.org,
	loongarch@lists.linux.dev,
	davem@davemloft.net,
	linux-crypto@vger.kernel.org,
	arnd@arndb.de,
	derek.kiernan@amd.com,
	dragan.cvetic@amd.com,
	Qunqin Zhao <zhaoqunqin@loongson.cn>,
	Yinggang Gu <guyinggang@loongson.cn>
Subject: [PATCH v1 2/3] crypto: loongson - add Loongson RNG driver support
Date: Tue, 14 Jan 2025 17:55:26 +0800
Message-Id: <20250114095527.23722-3-zhaoqunqin@loongson.cn>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20250114095527.23722-1-zhaoqunqin@loongson.cn>
References: <20250114095527.23722-1-zhaoqunqin@loongson.cn>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:qMiowMBxReSoNIZnct0hAA--.2343S4
X-CM-SenderInfo: 52kd01pxqtx0o6or00hjvr0hdfq/
X-Coremail-Antispam: 1Uk129KBj93XoW3Jr15CFWktF1kZFWxCFyfGrX_yoW3JF1rpF
	4Fk3y8CrWUGFsrKFZ5JrWrCFW3Z3sa9a4agFW7Gwn09r92yFyDXayfAFyUAFWDAFWxWrWa
	gFZa9F4UKa1UJ3gCm3ZEXasCq-sJn29KB7ZKAUJUUUUf529EdanIXcx71UUUUU7KY7ZEXa
	sCq-sGcSsGvfJ3Ic02F40EFcxC0VAKzVAqx4xG6I80ebIjqfuFe4nvWSU5nxnvy29KBjDU
	0xBIdaVrnRJUUUB0b4IE77IF4wAFF20E14v26r1j6r4UM7CY07I20VC2zVCF04k26cxKx2
	IYs7xG6rWj6s0DM7CIcVAFz4kK6r1Y6r17M28lY4IEw2IIxxk0rwA2F7IY1VAKz4vEj48v
	e4kI8wA2z4x0Y4vE2Ix0cI8IcVAFwI0_Ar0_tr1l84ACjcxK6xIIjxv20xvEc7CjxVAFwI
	0_Gr0_Cr1l84ACjcxK6I8E87Iv67AKxVW0oVCq3wA2z4x0Y4vEx4A2jsIEc7CjxVAFwI0_
	GcCE3s1ln4kS14v26r126r1DM2AIxVAIcxkEcVAq07x20xvEncxIr21l57IF6xkI12xvs2
	x26I8E6xACxx1l5I8CrVACY4xI64kE6c02F40Ex7xfMcIj6xIIjxv20xvE14v26r1q6rW5
	McIj6I8E87Iv67AKxVW8JVWxJwAm72CE4IkC6x0Yz7v_Jr0_Gr1lF7xvr2IYc2Ij64vIr4
	1lc7CjxVAaw2AFwI0_JF0_Jw1l42xK82IYc2Ij64vIr41l4I8I3I0E4IkC6x0Yz7v_Jr0_
	Gr1l4IxYO2xFxVAFwI0_JF0_Jw1lx2IqxVAqx4xG67AKxVWUJVWUGwC20s026x8GjcxK67
	AKxVWUGVWUWwC2zVAF1VAY17CE14v26r1q6r43MIIYrxkI7VAKI48JMIIF0xvE2Ix0cI8I
	cVAFwI0_Xr0_Ar1lIxAIcVC0I7IYx2IY6xkF7I0E14v26r4j6F4UMIIF0xvE42xK8VAvwI
	8IcIk0rVWUJVWUCwCI42IY6I8E87Iv67AKxVW8JVWxJwCI42IY6I8E87Iv6xkF7I0E14v2
	6r4j6r4UJbIYCTnIWIevJa73UjIFyTuYvjxU4Xo7DUUUU

Loongson's Random Number Generator is found inside Loongson 6000SE.

Co-developed-by: Yinggang Gu <guyinggang@loongson.cn>
Signed-off-by: Yinggang Gu <guyinggang@loongson.cn>
Signed-off-by: Qunqin Zhao <zhaoqunqin@loongson.cn>
---
 MAINTAINERS                            |   6 +
 drivers/crypto/Kconfig                 |   1 +
 drivers/crypto/Makefile                |   1 +
 drivers/crypto/loongson/Kconfig        |   6 +
 drivers/crypto/loongson/Makefile       |   2 +
 drivers/crypto/loongson/ls6000se-rng.c | 190 +++++++++++++++++++++++++
 6 files changed, 206 insertions(+)
 create mode 100644 drivers/crypto/loongson/Kconfig
 create mode 100644 drivers/crypto/loongson/Makefile
 create mode 100644 drivers/crypto/loongson/ls6000se-rng.c

diff --git a/MAINTAINERS b/MAINTAINERS
index 3c8a9d6198..e65a7f4ea4 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -13480,6 +13480,12 @@ S:	Maintained
 F:	Documentation/devicetree/bindings/gpio/loongson,ls-gpio.yaml
 F:	drivers/gpio/gpio-loongson-64bit.c
 
+LOONGSON CRYPTO DRIVER
+M:	Qunqin Zhao <zhaoqunqin@loongson.com>
+L:	linux-crypto@vger.kernel.org
+S:	Maintained
+F:	drivers/crypto/loongson/
+
 LOONGSON-2 APB DMA DRIVER
 M:	Binbin Zhou <zhoubinbin@loongson.cn>
 L:	dmaengine@vger.kernel.org
diff --git a/drivers/crypto/Kconfig b/drivers/crypto/Kconfig
index 0a9cdd31cb..80caf6158e 100644
--- a/drivers/crypto/Kconfig
+++ b/drivers/crypto/Kconfig
@@ -872,5 +872,6 @@ config CRYPTO_DEV_SA2UL
 
 source "drivers/crypto/aspeed/Kconfig"
 source "drivers/crypto/starfive/Kconfig"
+source "drivers/crypto/loongson/Kconfig"
 
 endif # CRYPTO_HW
diff --git a/drivers/crypto/Makefile b/drivers/crypto/Makefile
index ad4ccef67d..a80e2586f7 100644
--- a/drivers/crypto/Makefile
+++ b/drivers/crypto/Makefile
@@ -52,3 +52,4 @@ obj-y += hisilicon/
 obj-$(CONFIG_CRYPTO_DEV_AMLOGIC_GXL) += amlogic/
 obj-y += intel/
 obj-y += starfive/
+obj-y += loongson/
diff --git a/drivers/crypto/loongson/Kconfig b/drivers/crypto/loongson/Kconfig
new file mode 100644
index 0000000000..2b0b8b3241
--- /dev/null
+++ b/drivers/crypto/loongson/Kconfig
@@ -0,0 +1,6 @@
+# SPDX-License-Identifier: GPL-2.0
+config CRYPTO_DEV_LS6000SE_RNG
+        tristate "Support for Loongson 6000SE RNG Driver"
+        depends on MFD_LS6000SE
+        help
+          Support for Loongson 6000SE RNG Driver.
diff --git a/drivers/crypto/loongson/Makefile b/drivers/crypto/loongson/Makefile
new file mode 100644
index 0000000000..17b0fa89e9
--- /dev/null
+++ b/drivers/crypto/loongson/Makefile
@@ -0,0 +1,2 @@
+# SPDX-License-Identifier: GPL-2.0
+obj-$(CONFIG_CRYPTO_DEV_LS6000SE_RNG)	+= ls6000se-rng.o
diff --git a/drivers/crypto/loongson/ls6000se-rng.c b/drivers/crypto/loongson/ls6000se-rng.c
new file mode 100644
index 0000000000..b366475782
--- /dev/null
+++ b/drivers/crypto/loongson/ls6000se-rng.c
@@ -0,0 +1,190 @@
+// SPDX-License-Identifier: GPL-2.0
+/* Copyright (c) 2019 HiSilicon Limited. */
+/* Copyright (c) 2025 Loongson Technology Corporation Limited. */
+
+#include <linux/crypto.h>
+#include <linux/err.h>
+#include <linux/hw_random.h>
+#include <linux/io.h>
+#include <linux/iopoll.h>
+#include <linux/kernel.h>
+#include <linux/list.h>
+#include <linux/mfd/ls6000se.h>
+#include <linux/module.h>
+#include <linux/mutex.h>
+#include <linux/platform_device.h>
+#include <linux/random.h>
+#include <crypto/internal/rng.h>
+
+struct lsrng_list {
+	struct mutex lock;
+	struct list_head list;
+	int is_init;
+};
+
+struct lsrng {
+	bool is_used;
+	struct lsse_ch *se_ch;
+	struct list_head list;
+	struct completion rng_completion;
+};
+
+struct lsrng_ctx {
+	struct lsrng *rng;
+};
+
+struct rng_msg {
+	u32 cmd;
+	union {
+		u32 len;
+		u32 ret;
+	} u;
+	u32 resved;
+	u32 out_off;
+	u32 pad[4];
+};
+
+static atomic_t rng_active_devs;
+static struct lsrng_list rng_devices;
+
+static void lsrng_complete(struct lsse_ch *ch)
+{
+	struct lsrng *rng = (struct lsrng *)ch->priv;
+
+	complete(&rng->rng_completion);
+}
+
+static int lsrng_generate(struct crypto_rng *tfm, const u8 *src,
+			  unsigned int slen, u8 *dstn, unsigned int dlen)
+{
+	struct lsrng_ctx *ctx = crypto_rng_ctx(tfm);
+	struct lsrng *rng = ctx->rng;
+	struct rng_msg *msg;
+	int err, len;
+
+	do {
+		len = min(dlen, PAGE_SIZE);
+		msg = rng->se_ch->smsg;
+		msg->u.len = len;
+		err = se_send_ch_requeset(rng->se_ch);
+		if (err)
+			return err;
+
+		wait_for_completion_interruptible(&rng->rng_completion);
+
+		msg = rng->se_ch->rmsg;
+		if (msg->u.ret)
+			return -EFAULT;
+
+		memcpy(dstn, rng->se_ch->data_buffer, len);
+		dlen -= len;
+		dstn += len;
+	} while (dlen > 0);
+
+	return 0;
+}
+
+static int lsrng_init(struct crypto_tfm *tfm)
+{
+	struct lsrng_ctx *ctx = crypto_tfm_ctx(tfm);
+	struct lsrng *rng;
+	int ret = -EBUSY;
+
+	mutex_lock(&rng_devices.lock);
+	list_for_each_entry(rng, &rng_devices.list, list) {
+		if (!rng->is_used) {
+			rng->is_used = true;
+			ctx->rng = rng;
+			ret = 0;
+			break;
+		}
+	}
+	mutex_unlock(&rng_devices.lock);
+
+	return ret;
+}
+
+static void lsrng_exit(struct crypto_tfm *tfm)
+{
+	struct lsrng_ctx *ctx = crypto_tfm_ctx(tfm);
+
+	mutex_lock(&rng_devices.lock);
+	ctx->rng->is_used = false;
+	mutex_unlock(&rng_devices.lock);
+}
+
+static int no_seed(struct crypto_rng *tfm, const u8 *seed, unsigned int slen)
+{
+	return 0;
+}
+
+static struct rng_alg lsrng_alg = {
+	.generate = lsrng_generate,
+	.seed =	no_seed,
+	.base = {
+		.cra_name = "stdrng",
+		.cra_driver_name = "loongson_stdrng",
+		.cra_priority = 300,
+		.cra_ctxsize = sizeof(struct lsrng_ctx),
+		.cra_module = THIS_MODULE,
+		.cra_init = lsrng_init,
+		.cra_exit = lsrng_exit,
+	},
+};
+
+static void lsrng_add_to_list(struct lsrng *rng)
+{
+	mutex_lock(&rng_devices.lock);
+	list_add_tail(&rng->list, &rng_devices.list);
+	mutex_unlock(&rng_devices.lock);
+}
+
+static int lsrng_probe(struct platform_device *pdev)
+{
+	struct rng_msg *msg;
+	struct lsrng *rng;
+	int ret;
+
+	rng = devm_kzalloc(&pdev->dev, sizeof(*rng), GFP_KERNEL);
+	if (!rng)
+		return -ENOMEM;
+
+	init_completion(&rng->rng_completion);
+	rng->se_ch = se_init_ch(pdev->dev.parent, SE_CH_RNG, PAGE_SIZE,
+				sizeof(struct rng_msg) * 2, rng, lsrng_complete);
+	if (!rng->se_ch)
+		return -ENODEV;
+	msg = rng->se_ch->smsg;
+	msg->cmd = SE_CMD_RNG;
+	msg->out_off = rng->se_ch->off;
+
+	if (!rng_devices.is_init) {
+		ret = crypto_register_rng(&lsrng_alg);
+		if (ret) {
+			dev_err(&pdev->dev, "failed to register crypto(%d)\n", ret);
+			return ret;
+		}
+		INIT_LIST_HEAD(&rng_devices.list);
+		mutex_init(&rng_devices.lock);
+		rng_devices.is_init = true;
+	}
+
+	lsrng_add_to_list(rng);
+	atomic_inc(&rng_active_devs);
+
+	return 0;
+}
+
+static struct platform_driver lsrng_driver = {
+	.probe		= lsrng_probe,
+	.driver		= {
+		.name	= "ls6000se-rng",
+	},
+};
+module_platform_driver(lsrng_driver);
+
+MODULE_ALIAS("platform:ls6000se-rng");
+MODULE_LICENSE("GPL");
+MODULE_AUTHOR("Yinggang Gu <guyinggang@loongson.cn>");
+MODULE_AUTHOR("Qunqin Zhao <zhaoqunqin@loongson.cn>");
+MODULE_DESCRIPTION("Loongson random number generator driver");
-- 
2.43.0

