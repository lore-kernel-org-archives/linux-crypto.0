Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C1E3CC64E69
	for <linux-crypto@archiver.kernel.org>; Fri, 20 Nov 2020 09:06:45 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 6A12D221F9
	for <linux-crypto@archiver.kernel.org>; Fri, 20 Nov 2020 09:06:45 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727042AbgKTJGE (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 20 Nov 2020 04:06:04 -0500
Received: from szxga04-in.huawei.com ([45.249.212.190]:7712 "EHLO
        szxga04-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725797AbgKTJF6 (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 20 Nov 2020 04:05:58 -0500
Received: from DGGEMS404-HUB.china.huawei.com (unknown [172.30.72.59])
        by szxga04-in.huawei.com (SkyGuard) with ESMTP id 4CcrHG6j4MzkcQ4;
        Fri, 20 Nov 2020 17:05:30 +0800 (CST)
Received: from localhost.localdomain (10.67.165.24) by
 DGGEMS404-HUB.china.huawei.com (10.3.19.204) with Microsoft SMTP Server id
 14.3.487.0; Fri, 20 Nov 2020 17:04:59 +0800
From:   Weili Qian <qianweili@huawei.com>
To:     <herbert@gondor.apana.org.au>, <davem@davemloft.net>,
        <mpm@selenic.com>
CC:     <linux-kernel@vger.kernel.org>, <linux-crypto@vger.kernel.org>,
        <xuzaibo@huawei.com>, <wangzhou1@hisilicon.com>,
        Weili Qian <qianweili@huawei.com>
Subject: [PATCH 3/4] crypto: hisilicon/trng - add support for PRNG
Date:   Fri, 20 Nov 2020 17:02:33 +0800
Message-ID: <1605862954-38300-3-git-send-email-qianweili@huawei.com>
X-Mailer: git-send-email 2.8.1
In-Reply-To: <1605862954-38300-1-git-send-email-qianweili@huawei.com>
References: <1605862954-38300-1-git-send-email-qianweili@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.67.165.24]
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

This patch adds support for pseudo random number generator(PRNG)
in Crypto subsystem.

Signed-off-by: Weili Qian <qianweili@huawei.com>
Reviewed-by: Zaibo Xu <xuzaibo@huawei.com>
---
 drivers/crypto/hisilicon/Kconfig     |   1 +
 drivers/crypto/hisilicon/trng/trng.c | 241 ++++++++++++++++++++++++++++++++++-
 2 files changed, 239 insertions(+), 3 deletions(-)

diff --git a/drivers/crypto/hisilicon/Kconfig b/drivers/crypto/hisilicon/Kconfig
index 2cd3298..8431926 100644
--- a/drivers/crypto/hisilicon/Kconfig
+++ b/drivers/crypto/hisilicon/Kconfig
@@ -76,5 +76,6 @@ config CRYPTO_DEV_HISI_TRNG
 	tristate "Support for HISI TRNG Driver"
 	depends on ARM64 && ACPI
 	select HW_RANDOM
+	select CRYPTO_RNG
 	help
 	  Support for HiSilicon TRNG Driver.
diff --git a/drivers/crypto/hisilicon/trng/trng.c b/drivers/crypto/hisilicon/trng/trng.c
index 6a65b82..a5033cf 100644
--- a/drivers/crypto/hisilicon/trng/trng.c
+++ b/drivers/crypto/hisilicon/trng/trng.c
@@ -2,26 +2,181 @@
 /* Copyright (c) 2019 HiSilicon Limited. */
 
 #include <linux/acpi.h>
+#include <linux/crypto.h>
 #include <linux/err.h>
 #include <linux/hw_random.h>
 #include <linux/io.h>
 #include <linux/iopoll.h>
 #include <linux/kernel.h>
+#include <linux/list.h>
 #include <linux/module.h>
+#include <linux/mutex.h>
 #include <linux/platform_device.h>
 #include <linux/random.h>
+#include <crypto/internal/rng.h>
 
 #define HISI_TRNG_REG		0x00F0
 #define HISI_TRNG_BYTES		4
 #define HISI_TRNG_QUALITY	512
 #define SLEEP_US		10
 #define TIMEOUT_US		10000
+#define SW_DRBG_NUM_SHIFT	2
+#define SW_DRBG_KEY_BASE	0x082C
+#define SW_DRBG_SEED(n)         (SW_DRBG_KEY_BASE - ((n) << SW_DRBG_NUM_SHIFT))
+#define SW_DRBG_SEED_REGS_NUM	12
+#define SW_DRBG_SEED_SIZE	48
+#define SW_DRBG_BLOCKS		0x0830
+#define SW_DRBG_INIT		0x0834
+#define SW_DRBG_GEN		0x083c
+#define SW_DRBG_STATUS		0x0840
+#define SW_DRBG_BLOCKS_NUM	4095
+#define SW_DRBG_DATA_BASE	0x0850
+#define SW_DRBG_DATA_NUM	4
+#define SW_DRBG_DATA(n)		(SW_DRBG_DATA_BASE - ((n) << SW_DRBG_NUM_SHIFT))
+#define SW_DRBG_BYTES		16
+#define SW_DRBG_ENABLE_SHIFT	12
+#define SEED_SHIFT_24		24
+#define SEED_SHIFT_16		16
+#define SEED_SHIFT_8		8
+
+struct hisi_trng_list {
+	struct mutex lock;
+	struct list_head list;
+	bool is_init;
+};
 
 struct hisi_trng {
 	void __iomem *base;
+	struct hisi_trng_list *trng_list;
+	struct list_head list;
 	struct hwrng rng;
+	bool is_used;
+	struct mutex mutex;
+};
+
+struct hisi_trng_ctx {
+	struct hisi_trng *trng;
 };
 
+static atomic_t trng_active_devs;
+static struct hisi_trng_list trng_devices;
+
+static void hisi_trng_set_seed(struct hisi_trng *trng, const u8 *seed)
+{
+	u32 val, seed_reg, i;
+
+	for (i = 0; i < SW_DRBG_SEED_SIZE;
+	     i += SW_DRBG_SEED_SIZE / SW_DRBG_SEED_REGS_NUM) {
+		val = seed[i] << SEED_SHIFT_24;
+		val |= seed[i + 1UL] << SEED_SHIFT_16;
+		val |= seed[i + 2UL] << SEED_SHIFT_8;
+		val |= seed[i + 3UL];
+
+		seed_reg = (i >> SW_DRBG_NUM_SHIFT) % SW_DRBG_SEED_REGS_NUM;
+		writel(val, trng->base + SW_DRBG_SEED(seed_reg));
+	}
+}
+
+static int hisi_trng_seed(struct crypto_rng *tfm, const u8 *seed,
+			  unsigned int slen)
+{
+	struct hisi_trng_ctx *ctx = crypto_rng_ctx(tfm);
+	struct hisi_trng *trng = ctx->trng;
+	u32 val = 0;
+	int ret = 0;
+
+	if (slen < SW_DRBG_SEED_SIZE) {
+		pr_err("slen(%u) is not matched with trng(%d)\n", slen,
+			SW_DRBG_SEED_SIZE);
+		return -EINVAL;
+	}
+
+	writel(0x0, trng->base + SW_DRBG_BLOCKS);
+	hisi_trng_set_seed(trng, seed);
+
+	writel(SW_DRBG_BLOCKS_NUM | (0x1 << SW_DRBG_ENABLE_SHIFT),
+	       trng->base + SW_DRBG_BLOCKS);
+	writel(0x1, trng->base + SW_DRBG_INIT);
+
+	ret = readl_relaxed_poll_timeout(trng->base + SW_DRBG_STATUS,
+					val, val & BIT(0), SLEEP_US, TIMEOUT_US);
+	if (ret)
+		pr_err("fail to init trng(%d)\n", ret);
+
+	return ret;
+}
+
+static int hisi_trng_generate(struct crypto_rng *tfm, const u8 *src,
+			      unsigned int slen, u8 *dstn, unsigned int dlen)
+{
+	struct hisi_trng_ctx *ctx = crypto_rng_ctx(tfm);
+	struct hisi_trng *trng = ctx->trng;
+	u32 data[SW_DRBG_DATA_NUM];
+	u32 currsize = 0;
+	u32 val = 0;
+	int ret;
+	u32 i;
+
+	if (dlen > SW_DRBG_BLOCKS_NUM * SW_DRBG_BYTES || dlen == 0) {
+		pr_err("dlen(%d) exceeds limit(%d)!\n", dlen,
+			SW_DRBG_BLOCKS_NUM * SW_DRBG_BYTES);
+		return -EINVAL;
+	}
+
+	do {
+		ret = readl_relaxed_poll_timeout(trng->base + SW_DRBG_STATUS,
+		     val, val & BIT(1), SLEEP_US, TIMEOUT_US);
+		if (ret) {
+			pr_err("fail to generate random number(%d)!\n", ret);
+			break;
+		}
+
+		for (i = 0; i < SW_DRBG_DATA_NUM; i++)
+			data[i] = readl(trng->base + SW_DRBG_DATA(i));
+
+		if (dlen - currsize >= SW_DRBG_BYTES) {
+			memcpy(dstn + currsize, data, SW_DRBG_BYTES);
+			currsize += SW_DRBG_BYTES;
+		} else {
+			memcpy(dstn + currsize, data, dlen - currsize);
+			currsize = dlen;
+		}
+
+		writel(0x1, trng->base + SW_DRBG_GEN);
+	} while (currsize < dlen);
+
+	return ret;
+}
+
+static int hisi_trng_init(struct crypto_tfm *tfm)
+{
+	struct hisi_trng_ctx *ctx = crypto_tfm_ctx(tfm);
+	struct hisi_trng *trng;
+	int ret = -EBUSY;
+
+	mutex_lock(&trng_devices.lock);
+	list_for_each_entry(trng, &trng_devices.list, list) {
+		if (!trng->is_used) {
+			trng->is_used = true;
+			ctx->trng = trng;
+			ret = 0;
+			break;
+		}
+	}
+	mutex_unlock(&trng_devices.lock);
+
+	return ret;
+}
+
+static void hisi_trng_exit(struct crypto_tfm *tfm)
+{
+	struct hisi_trng_ctx *ctx = crypto_tfm_ctx(tfm);
+
+	mutex_lock(&trng_devices.lock);
+	ctx->trng->is_used = false;
+	mutex_unlock(&trng_devices.lock);
+}
+
 static int hisi_trng_read(struct hwrng *rng, void *buf, size_t max, bool wait)
 {
 	struct hisi_trng *trng;
@@ -53,6 +208,42 @@ static int hisi_trng_read(struct hwrng *rng, void *buf, size_t max, bool wait)
 	return currsize;
 }
 
+static struct rng_alg hisi_trng_alg = {
+	.generate = hisi_trng_generate,
+	.seed =	hisi_trng_seed,
+	.seedsize = SW_DRBG_SEED_SIZE,
+	.base = {
+		.cra_name = "stdrng",
+		.cra_driver_name = "hisi_stdrng",
+		.cra_priority = 300,
+		.cra_ctxsize = sizeof(struct hisi_trng_ctx),
+		.cra_module = THIS_MODULE,
+		.cra_init = hisi_trng_init,
+		.cra_exit = hisi_trng_exit,
+	},
+};
+
+static void hisi_trng_add_to_list(struct hisi_trng *trng)
+{
+	mutex_lock(&trng_devices.lock);
+	list_add_tail(&trng->list, &trng_devices.list);
+	mutex_unlock(&trng_devices.lock);
+}
+
+static int hisi_trng_del_from_list(struct hisi_trng *trng)
+{
+	int ret = -EBUSY;
+
+	mutex_lock(&trng_devices.lock);
+	if (!trng->is_used) {
+		list_del(&trng->list);
+		ret = 0;
+	}
+	mutex_unlock(&trng_devices.lock);
+
+	return ret;
+}
+
 static int hisi_trng_probe(struct platform_device *pdev)
 {
 	struct hisi_trng *trng;
@@ -62,19 +253,62 @@ static int hisi_trng_probe(struct platform_device *pdev)
 	if (!trng)
 		return -ENOMEM;
 
+	platform_set_drvdata(pdev, trng);
+
 	trng->base = devm_platform_ioremap_resource(pdev, 0);
 	if (IS_ERR(trng->base))
 		return PTR_ERR(trng->base);
 
+	trng->is_used = false;
+	if (!trng_devices.is_init) {
+		INIT_LIST_HEAD(&trng_devices.list);
+		mutex_init(&trng_devices.lock);
+		trng_devices.is_init = true;
+	}
+
+	hisi_trng_add_to_list(trng);
+	if (atomic_add_return(1, &trng_active_devs) == 1) {
+		ret = crypto_register_rng(&hisi_trng_alg);
+		if (ret) {
+			dev_err(&pdev->dev,
+				"failed to register crypto(%d)\n", ret);
+			atomic_sub_return(1, &trng_active_devs);
+			goto err_remove_from_list;
+		}
+	}
+
 	trng->rng.name = pdev->name;
 	trng->rng.read = hisi_trng_read;
 	trng->rng.quality = HISI_TRNG_QUALITY;
-
 	ret = devm_hwrng_register(&pdev->dev, &trng->rng);
-	if (ret)
-		dev_err(&pdev->dev, "failed to register hwrng!\n");
+	if (ret) {
+		dev_err(&pdev->dev, "failed to register hwrng: %d!\n", ret);
+		goto err_crypto_unregister;
+	}
 
 	return ret;
+
+err_crypto_unregister:
+	if (atomic_sub_return(1, &trng_active_devs) == 0)
+		crypto_unregister_rng(&hisi_trng_alg);
+
+err_remove_from_list:
+	hisi_trng_del_from_list(trng);
+	return ret;
+}
+
+static int hisi_trng_remove(struct platform_device *pdev)
+{
+	struct hisi_trng *trng = platform_get_drvdata(pdev);
+
+	/* Wait until the task is finished */
+	while (hisi_trng_del_from_list(trng))
+		;
+
+	if (atomic_sub_return(1, &trng_active_devs) == 0)
+		crypto_unregister_rng(&hisi_trng_alg);
+
+	return 0;
 }
 
 static const struct acpi_device_id hisi_trng_acpi_match[] = {
@@ -85,6 +319,7 @@ MODULE_DEVICE_TABLE(acpi, hisi_trng_acpi_match);
 
 static struct platform_driver hisi_trng_driver = {
 	.probe		= hisi_trng_probe,
+	.remove         = hisi_trng_remove,
 	.driver		= {
 		.name	= "hisi-trng-v2",
 		.acpi_match_table = ACPI_PTR(hisi_trng_acpi_match),
-- 
2.8.1

