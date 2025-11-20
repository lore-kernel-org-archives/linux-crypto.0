Received: from canpmsgout08.his.huawei.com (canpmsgout08.his.huawei.com [113.46.200.223])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6C83132FA16;
	Thu, 20 Nov 2025 13:58:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=113.46.200.223
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763647100; cv=none; b=jykM8WECVM6nEjSw/YOptFoL4GWXttpioFZbvTiKd0/Jca3i2StTtPuaDnktU16cV6a0L+/5BrUzPEYiWjOf+4t8E1APdS+7zWNEXw1akdn2+cKNyJLGHpAioJJLpBfSAkBGE6ck/aroXlfA4WnVRRhBSfpdOoJFqtwu882/+FA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763647100; c=relaxed/simple;
	bh=/7tuEZLmnzvlhkwWeK1maNDWP7S8pXHUBUG0bkWAL28=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=iCCY2pYH4xSgmiiSvo3t3QsnXnCDHCauT7cGh8fmiMgvjvHNCsgp3CeicU4GiSrJ+RLbr7skJIKzkbEyZhnRHHcIH21ZIJYQ6sK+fobyUxlh8UTTZyXz9Xqo2pPP0rQww2YZH0WGfISbOmUA2FOyP2AfD4BZfWJXT+65k4Gsii8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com; spf=pass smtp.mailfrom=huawei.com; dkim=pass (1024-bit key) header.d=huawei.com header.i=@huawei.com header.b=dJLTn4xU; arc=none smtp.client-ip=113.46.200.223
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huawei.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=huawei.com header.i=@huawei.com header.b="dJLTn4xU"
dkim-signature: v=1; a=rsa-sha256; d=huawei.com; s=dkim;
	c=relaxed/relaxed; q=dns/txt;
	h=From;
	bh=+HcWhgPXtR7D8JcBEJZDe9j2C8W06P1QKnc0m/hTd+4=;
	b=dJLTn4xUvA8t1w9XK/bFpJK8h2LZp1wDdioJKg3iyAPuJm6FOAWTg0HpWAAILg6rO92PwIwIL
	0socxBLRLvJQTfxZ0ZKJ4/nOvRyOijI2+SOh5ieFyDmhneFJIN9MZnKJIHBYdn8Bw2LJrJUjS6y
	FMfx4eMqTpmj4/w2r4x18Gw=
Received: from mail.maildlp.com (unknown [172.19.88.163])
	by canpmsgout08.his.huawei.com (SkyGuard) with ESMTPS id 4dC0JG1pD2zmV6R;
	Thu, 20 Nov 2025 21:56:30 +0800 (CST)
Received: from dggemv705-chm.china.huawei.com (unknown [10.3.19.32])
	by mail.maildlp.com (Postfix) with ESMTPS id D9A551800B2;
	Thu, 20 Nov 2025 21:58:14 +0800 (CST)
Received: from kwepemq200001.china.huawei.com (7.202.195.16) by
 dggemv705-chm.china.huawei.com (10.3.19.32) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.11; Thu, 20 Nov 2025 21:58:14 +0800
Received: from localhost.huawei.com (10.90.31.46) by
 kwepemq200001.china.huawei.com (7.202.195.16) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.11; Thu, 20 Nov 2025 21:58:14 +0800
From: Chenghai Huang <huangchenghai2@huawei.com>
To: <herbert@gondor.apana.org.au>, <davem@davemloft.net>
CC: <linux-kernel@vger.kernel.org>, <linux-crypto@vger.kernel.org>,
	<fanghao11@huawei.com>, <liulongfang@huawei.com>, <qianweili@huawei.com>,
	<linwenkai6@hisilicon.com>, <wangzhou1@hisilicon.com>
Subject: [PATCH 2/2] crypto: hisilicon/trng - support tfms sharing the device
Date: Thu, 20 Nov 2025 21:58:12 +0800
Message-ID: <20251120135812.1814923-3-huangchenghai2@huawei.com>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20251120135812.1814923-1-huangchenghai2@huawei.com>
References: <20251120135812.1814923-1-huangchenghai2@huawei.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: kwepems200001.china.huawei.com (7.221.188.67) To
 kwepemq200001.china.huawei.com (7.202.195.16)

From: Weili Qian <qianweili@huawei.com>

Since the number of devices is limited, and the number
of tfms may exceed the number of devices, to ensure that
tfms can be successfully allocated, support tfms
sharing the same device.

Fixes: e4d9d10ef4be ("crypto: hisilicon/trng - add support for PRNG")
Signed-off-by: Weili Qian <qianweili@huawei.com>
Signed-off-by: Chenghai Huang <huangchenghai2@huawei.com>
---
 drivers/crypto/hisilicon/trng/trng.c | 98 ++++++++++++++++++++--------
 1 file changed, 69 insertions(+), 29 deletions(-)

diff --git a/drivers/crypto/hisilicon/trng/trng.c b/drivers/crypto/hisilicon/trng/trng.c
index dae81b6f43e3..4dcb3398e020 100644
--- a/drivers/crypto/hisilicon/trng/trng.c
+++ b/drivers/crypto/hisilicon/trng/trng.c
@@ -41,14 +41,16 @@
 #define SEED_SHIFT_16		16
 #define SEED_SHIFT_8		8
 #define WAIT_PERIOD		20
+#define SW_MAX_RANDOM_BYTES	65520
 
 struct hisi_trng {
 	void __iomem *base;
 	struct list_head list;
 	struct hwrng rng;
 	u32 ver;
-	bool is_used;
-	struct mutex mutex;
+	u32 ctx_num;
+	u32 random_bytes;
+	struct mutex lock;
 };
 
 struct hisi_trng_ctx {
@@ -57,10 +59,14 @@ struct hisi_trng_ctx {
 
 static LIST_HEAD(trng_devices_list);
 static DEFINE_MUTEX(trng_device_lock);
+static int hisi_trng_read(struct hwrng *rng, void *buf, size_t max, bool wait);
 
-static void hisi_trng_set_seed(struct hisi_trng *trng, const u8 *seed)
+static int hisi_trng_set_seed(struct hisi_trng *trng, const u8 *seed)
 {
 	u32 val, seed_reg, i;
+	int ret;
+
+	writel(0x0, trng->base + SW_DRBG_BLOCKS);
 
 	for (i = 0; i < SW_DRBG_SEED_SIZE;
 	     i += SW_DRBG_SEED_SIZE / SW_DRBG_SEED_REGS_NUM) {
@@ -72,6 +78,20 @@ static void hisi_trng_set_seed(struct hisi_trng *trng, const u8 *seed)
 		seed_reg = (i >> SW_DRBG_NUM_SHIFT) % SW_DRBG_SEED_REGS_NUM;
 		writel(val, trng->base + SW_DRBG_SEED(seed_reg));
 	}
+
+	writel(SW_DRBG_BLOCKS_NUM | (0x1 << SW_DRBG_ENABLE_SHIFT),
+	       trng->base + SW_DRBG_BLOCKS);
+	writel(0x1, trng->base + SW_DRBG_INIT);
+	ret = readl_relaxed_poll_timeout(trng->base + SW_DRBG_STATUS,
+					 val, val & BIT(0), SLEEP_US, TIMEOUT_US);
+	if (ret) {
+		pr_err("failed to init trng(%d)\n", ret);
+		return -EIO;
+	}
+
+	trng->random_bytes = 0;
+
+	return 0;
 }
 
 static int hisi_trng_seed(struct crypto_rng *tfm, const u8 *seed,
@@ -79,8 +99,7 @@ static int hisi_trng_seed(struct crypto_rng *tfm, const u8 *seed,
 {
 	struct hisi_trng_ctx *ctx = crypto_rng_ctx(tfm);
 	struct hisi_trng *trng = ctx->trng;
-	u32 val = 0;
-	int ret = 0;
+	int ret;
 
 	if (slen < SW_DRBG_SEED_SIZE) {
 		pr_err("slen(%u) is not matched with trng(%d)\n", slen,
@@ -88,19 +107,30 @@ static int hisi_trng_seed(struct crypto_rng *tfm, const u8 *seed,
 		return -EINVAL;
 	}
 
-	writel(0x0, trng->base + SW_DRBG_BLOCKS);
-	hisi_trng_set_seed(trng, seed);
+	mutex_lock(&trng->lock);
+	ret = hisi_trng_set_seed(trng, seed);
+	mutex_unlock(&trng->lock);
 
-	writel(SW_DRBG_BLOCKS_NUM | (0x1 << SW_DRBG_ENABLE_SHIFT),
-	       trng->base + SW_DRBG_BLOCKS);
-	writel(0x1, trng->base + SW_DRBG_INIT);
+	return ret;
+}
 
-	ret = readl_relaxed_poll_timeout(trng->base + SW_DRBG_STATUS,
-					val, val & BIT(0), SLEEP_US, TIMEOUT_US);
-	if (ret)
-		pr_err("fail to init trng(%d)\n", ret);
+static int hisi_trng_reseed(struct hisi_trng *trng)
+{
+	u8 seed[SW_DRBG_SEED_SIZE];
+	int size;
 
-	return ret;
+	/* Allow other threads to acquire the lock and execute their jobs. */
+	mutex_unlock(&trng->lock);
+	mutex_lock(&trng->lock);
+
+	if (trng->random_bytes < SW_MAX_RANDOM_BYTES)
+		return 0;
+
+	size = hisi_trng_read(&trng->rng, seed, SW_DRBG_SEED_SIZE, false);
+	if (size != SW_DRBG_SEED_SIZE)
+		return -EIO;
+
+	return hisi_trng_set_seed(trng, seed);
 }
 
 static int hisi_trng_generate(struct crypto_rng *tfm, const u8 *src,
@@ -114,17 +144,23 @@ static int hisi_trng_generate(struct crypto_rng *tfm, const u8 *src,
 	int ret;
 	u32 i;
 
-	if (dlen > SW_DRBG_BLOCKS_NUM * SW_DRBG_BYTES || dlen == 0) {
-		pr_err("dlen(%u) exceeds limit(%d)!\n", dlen,
-			SW_DRBG_BLOCKS_NUM * SW_DRBG_BYTES);
+	if (!dstn || !dlen) {
+		pr_err("output is error, dlen %u !\n", dlen);
 		return -EINVAL;
 	}
 
+	mutex_lock(&trng->lock);
 	do {
+		if (trng->random_bytes >= SW_MAX_RANDOM_BYTES) {
+			ret = hisi_trng_reseed(trng);
+			if (ret)
+				break;
+		}
+
 		ret = readl_relaxed_poll_timeout(trng->base + SW_DRBG_STATUS,
-		     val, val & BIT(1), SLEEP_US, TIMEOUT_US);
+						 val, val & BIT(1), SLEEP_US, TIMEOUT_US);
 		if (ret) {
-			pr_err("fail to generate random number(%d)!\n", ret);
+			pr_err("failed to generate random number(%d)!\n", ret);
 			break;
 		}
 
@@ -139,9 +175,12 @@ static int hisi_trng_generate(struct crypto_rng *tfm, const u8 *src,
 			currsize = dlen;
 		}
 
+		trng->random_bytes += SW_DRBG_BYTES;
 		writel(0x1, trng->base + SW_DRBG_GEN);
 	} while (currsize < dlen);
 
+	mutex_unlock(&trng->lock);
+
 	return ret;
 }
 
@@ -149,20 +188,19 @@ static int hisi_trng_init(struct crypto_tfm *tfm)
 {
 	struct hisi_trng_ctx *ctx = crypto_tfm_ctx(tfm);
 	struct hisi_trng *trng;
-	int ret = -EBUSY;
+	u32 ctx_num = ~0;
 
 	mutex_lock(&trng_device_lock);
 	list_for_each_entry(trng, &trng_devices_list, list) {
-		if (!trng->is_used) {
-			trng->is_used = true;
+		if (trng->ctx_num < ctx_num) {
+			ctx_num = trng->ctx_num;
 			ctx->trng = trng;
-			ret = 0;
-			break;
 		}
 	}
+	ctx->trng->ctx_num++;
 	mutex_unlock(&trng_device_lock);
 
-	return ret;
+	return 0;
 }
 
 static void hisi_trng_exit(struct crypto_tfm *tfm)
@@ -170,7 +208,7 @@ static void hisi_trng_exit(struct crypto_tfm *tfm)
 	struct hisi_trng_ctx *ctx = crypto_tfm_ctx(tfm);
 
 	mutex_lock(&trng_device_lock);
-	ctx->trng->is_used = false;
+	ctx->trng->ctx_num--;
 	mutex_unlock(&trng_device_lock);
 }
 
@@ -245,7 +283,7 @@ static int hisi_trng_crypto_unregister(struct hisi_trng *trng)
 	int ret = -EBUSY;
 
 	mutex_lock(&trng_device_lock);
-	if (trng->is_used)
+	if (trng->ctx_num)
 		goto unlock;
 
 	list_del(&trng->list);
@@ -275,7 +313,9 @@ static int hisi_trng_probe(struct platform_device *pdev)
 	if (IS_ERR(trng->base))
 		return PTR_ERR(trng->base);
 
-	trng->is_used = false;
+	trng->ctx_num = 0;
+	trng->random_bytes = SW_MAX_RANDOM_BYTES;
+	mutex_init(&trng->lock);
 	trng->ver = readl(trng->base + HISI_TRNG_VERSION);
 	ret = hisi_trng_crypto_register(trng);
 	if (ret)
-- 
2.33.0

