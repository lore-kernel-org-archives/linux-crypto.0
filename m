Received: from canpmsgout03.his.huawei.com (canpmsgout03.his.huawei.com [113.46.200.218])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 084DC345CB1;
	Thu, 20 Nov 2025 13:58:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=113.46.200.218
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763647116; cv=none; b=DSoLfs+OSlKTxYCnR1rNl9JkJ8RJVdj3RsdTDkGr3OtnhdQhri87yVVbpHJoJG7wxi/VqBq3f2/nLyMPb5Gpi+ELV1Vbvhvpcp7+xjLhv3D8mVBWQR/wA/b+g6lM/pTldQI0YW0WVvFMIvyCjhKFaJSTFzqkZqUUsiQcx4xwNHs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763647116; c=relaxed/simple;
	bh=0BzFpp/AjXyzPaiI73qdjVHGf2Lh/9FbsHIJNtrf7B4=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=qiNQpff44xvxdFuZnaC5d/flL1urg77dX8mrHCmhtBXSLNBa4gptByecgSjk0Ub6kHe5ciuBGDvQa+52NlJSOAcRHcxx5kZRNWS0Nc3NWad/9vlYV4jXNF12ChJqlwv+NHm3eC5PCgPueNBILGfotCqW+3SWOLKwDgpuJni+/Yk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com; spf=pass smtp.mailfrom=huawei.com; dkim=pass (1024-bit key) header.d=huawei.com header.i=@huawei.com header.b=xIA6Q8pz; arc=none smtp.client-ip=113.46.200.218
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huawei.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=huawei.com header.i=@huawei.com header.b="xIA6Q8pz"
dkim-signature: v=1; a=rsa-sha256; d=huawei.com; s=dkim;
	c=relaxed/relaxed; q=dns/txt;
	h=From;
	bh=DZf+O5qJ0V6Yjg3qBBK9Tx120w3wgIPbtRLvX4AGG8I=;
	b=xIA6Q8pzkYb3/wQCul79eZXWswUJJKGIAHu89QK8d/gGU9eLgW6yYGO68cIs9hwji6oY/ZVnJ
	IRvUtvvyTYY+UzCocmaMZNqdEfYP6hW4typ7VseEiAyZEoT06oisQ/X/XH9kHI/4eq54037QDfX
	b8gXR4Klf5gLqwlzjhlV8hc=
Received: from mail.maildlp.com (unknown [172.19.163.252])
	by canpmsgout03.his.huawei.com (SkyGuard) with ESMTPS id 4dC0J95YTwzpSv2;
	Thu, 20 Nov 2025 21:56:25 +0800 (CST)
Received: from dggemv712-chm.china.huawei.com (unknown [10.1.198.32])
	by mail.maildlp.com (Postfix) with ESMTPS id E9B6E180BD1;
	Thu, 20 Nov 2025 21:58:22 +0800 (CST)
Received: from kwepemq200001.china.huawei.com (7.202.195.16) by
 dggemv712-chm.china.huawei.com (10.1.198.32) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.11; Thu, 20 Nov 2025 21:58:14 +0800
Received: from localhost.huawei.com (10.90.31.46) by
 kwepemq200001.china.huawei.com (7.202.195.16) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.11; Thu, 20 Nov 2025 21:58:13 +0800
From: Chenghai Huang <huangchenghai2@huawei.com>
To: <herbert@gondor.apana.org.au>, <davem@davemloft.net>
CC: <linux-kernel@vger.kernel.org>, <linux-crypto@vger.kernel.org>,
	<fanghao11@huawei.com>, <liulongfang@huawei.com>, <qianweili@huawei.com>,
	<linwenkai6@hisilicon.com>, <wangzhou1@hisilicon.com>
Subject: [PATCH 1/2] crypto: hisilicon/trng - use DEFINE_MUTEX() and LIST_HEAD()
Date: Thu, 20 Nov 2025 21:58:11 +0800
Message-ID: <20251120135812.1814923-2-huangchenghai2@huawei.com>
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

Runtime initialization of lock and list head is not
reliable in a concurrent environment. Therefore, use
DEFINE_MUTEX() and LIST_HEAD() for automatic initialization.
And decide whether to register the algorithm to the crypto
subsystem based on whether the list is empty, instead of
using atomic operations.

Fixes: e4d9d10ef4be ("crypto: hisilicon/trng - add support for PRNG")
Signed-off-by: Weili Qian <qianweili@huawei.com>
Signed-off-by: Chenghai Huang <huangchenghai2@huawei.com>
---
 drivers/crypto/hisilicon/trng/trng.c | 104 +++++++++++++--------------
 1 file changed, 48 insertions(+), 56 deletions(-)

diff --git a/drivers/crypto/hisilicon/trng/trng.c b/drivers/crypto/hisilicon/trng/trng.c
index ac74df4a9471..dae81b6f43e3 100644
--- a/drivers/crypto/hisilicon/trng/trng.c
+++ b/drivers/crypto/hisilicon/trng/trng.c
@@ -40,16 +40,10 @@
 #define SEED_SHIFT_24		24
 #define SEED_SHIFT_16		16
 #define SEED_SHIFT_8		8
-
-struct hisi_trng_list {
-	struct mutex lock;
-	struct list_head list;
-	bool is_init;
-};
+#define WAIT_PERIOD		20
 
 struct hisi_trng {
 	void __iomem *base;
-	struct hisi_trng_list *trng_list;
 	struct list_head list;
 	struct hwrng rng;
 	u32 ver;
@@ -61,8 +55,8 @@ struct hisi_trng_ctx {
 	struct hisi_trng *trng;
 };
 
-static atomic_t trng_active_devs;
-static struct hisi_trng_list trng_devices;
+static LIST_HEAD(trng_devices_list);
+static DEFINE_MUTEX(trng_device_lock);
 
 static void hisi_trng_set_seed(struct hisi_trng *trng, const u8 *seed)
 {
@@ -157,8 +151,8 @@ static int hisi_trng_init(struct crypto_tfm *tfm)
 	struct hisi_trng *trng;
 	int ret = -EBUSY;
 
-	mutex_lock(&trng_devices.lock);
-	list_for_each_entry(trng, &trng_devices.list, list) {
+	mutex_lock(&trng_device_lock);
+	list_for_each_entry(trng, &trng_devices_list, list) {
 		if (!trng->is_used) {
 			trng->is_used = true;
 			ctx->trng = trng;
@@ -166,7 +160,7 @@ static int hisi_trng_init(struct crypto_tfm *tfm)
 			break;
 		}
 	}
-	mutex_unlock(&trng_devices.lock);
+	mutex_unlock(&trng_device_lock);
 
 	return ret;
 }
@@ -175,9 +169,9 @@ static void hisi_trng_exit(struct crypto_tfm *tfm)
 {
 	struct hisi_trng_ctx *ctx = crypto_tfm_ctx(tfm);
 
-	mutex_lock(&trng_devices.lock);
+	mutex_lock(&trng_device_lock);
 	ctx->trng->is_used = false;
-	mutex_unlock(&trng_devices.lock);
+	mutex_unlock(&trng_device_lock);
 }
 
 static int hisi_trng_read(struct hwrng *rng, void *buf, size_t max, bool wait)
@@ -226,24 +220,43 @@ static struct rng_alg hisi_trng_alg = {
 	},
 };
 
-static void hisi_trng_add_to_list(struct hisi_trng *trng)
+static int hisi_trng_crypto_register(struct hisi_trng *trng)
 {
-	mutex_lock(&trng_devices.lock);
-	list_add_tail(&trng->list, &trng_devices.list);
-	mutex_unlock(&trng_devices.lock);
+	int ret = 0;
+
+	mutex_lock(&trng_device_lock);
+	if (trng->ver != HISI_TRNG_VER_V1 &&
+	    list_empty(&trng_devices_list)) {
+		ret = crypto_register_rng(&hisi_trng_alg);
+		if (ret) {
+			pr_err("failed to register crypto(%d)\n", ret);
+			goto unlock;
+		}
+	}
+
+	list_add_tail(&trng->list, &trng_devices_list);
+unlock:
+	mutex_unlock(&trng_device_lock);
+	return ret;
 }
 
-static int hisi_trng_del_from_list(struct hisi_trng *trng)
+static int hisi_trng_crypto_unregister(struct hisi_trng *trng)
 {
 	int ret = -EBUSY;
 
-	mutex_lock(&trng_devices.lock);
-	if (!trng->is_used) {
-		list_del(&trng->list);
-		ret = 0;
-	}
-	mutex_unlock(&trng_devices.lock);
+	mutex_lock(&trng_device_lock);
+	if (trng->is_used)
+		goto unlock;
+
+	list_del(&trng->list);
+	if (trng->ver != HISI_TRNG_VER_V1 &&
+	    list_empty(&trng_devices_list))
+		crypto_unregister_rng(&hisi_trng_alg);
 
+	ret = 0;
+
+unlock:
+	mutex_unlock(&trng_device_lock);
 	return ret;
 }
 
@@ -264,23 +277,9 @@ static int hisi_trng_probe(struct platform_device *pdev)
 
 	trng->is_used = false;
 	trng->ver = readl(trng->base + HISI_TRNG_VERSION);
-	if (!trng_devices.is_init) {
-		INIT_LIST_HEAD(&trng_devices.list);
-		mutex_init(&trng_devices.lock);
-		trng_devices.is_init = true;
-	}
-
-	hisi_trng_add_to_list(trng);
-	if (trng->ver != HISI_TRNG_VER_V1 &&
-	    atomic_inc_return(&trng_active_devs) == 1) {
-		ret = crypto_register_rng(&hisi_trng_alg);
-		if (ret) {
-			dev_err(&pdev->dev,
-				"failed to register crypto(%d)\n", ret);
-			atomic_dec_return(&trng_active_devs);
-			goto err_remove_from_list;
-		}
-	}
+	ret = hisi_trng_crypto_register(trng);
+	if (ret)
+		return ret;
 
 	trng->rng.name = pdev->name;
 	trng->rng.read = hisi_trng_read;
@@ -288,18 +287,13 @@ static int hisi_trng_probe(struct platform_device *pdev)
 	ret = devm_hwrng_register(&pdev->dev, &trng->rng);
 	if (ret) {
 		dev_err(&pdev->dev, "failed to register hwrng: %d!\n", ret);
-		goto err_crypto_unregister;
+		goto unregister_crypto;
 	}
 
 	return ret;
 
-err_crypto_unregister:
-	if (trng->ver != HISI_TRNG_VER_V1 &&
-	    atomic_dec_return(&trng_active_devs) == 0)
-		crypto_unregister_rng(&hisi_trng_alg);
-
-err_remove_from_list:
-	hisi_trng_del_from_list(trng);
+unregister_crypto:
+	hisi_trng_crypto_unregister(trng);
 	return ret;
 }
 
@@ -308,12 +302,10 @@ static void hisi_trng_remove(struct platform_device *pdev)
 	struct hisi_trng *trng = platform_get_drvdata(pdev);
 
 	/* Wait until the task is finished */
-	while (hisi_trng_del_from_list(trng))
-		;
-
-	if (trng->ver != HISI_TRNG_VER_V1 &&
-	    atomic_dec_return(&trng_active_devs) == 0)
-		crypto_unregister_rng(&hisi_trng_alg);
+	while (hisi_trng_crypto_unregister(trng)) {
+		dev_info(&pdev->dev, "trng is in using!\n");
+		msleep(WAIT_PERIOD);
+	}
 }
 
 static const struct acpi_device_id hisi_trng_acpi_match[] = {
-- 
2.33.0

