Received: from mail-pg1-f172.google.com (mail-pg1-f172.google.com [209.85.215.172])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DCAA42652AF
	for <linux-crypto@vger.kernel.org>; Fri, 17 Jul 2026 23:17:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784330268; cv=none; b=MqiPJDi8YxsP7fTlTfBRibfTogENr8MwTCU3Ttxu6e6QcQnH7CIHyZ6wC9csmZkPeCJXYe6hJPDiQp8nSp8xV/DJuEhl5JZWjj0GWjyrz4XlQ/26cDdG7oA5N6XiCQiN8rSJGh7g7RFIvjaWttN2RYCcfHcebzfxYUqiTIVpzLw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784330268; c=relaxed/simple;
	bh=wZNaMtbtid3eLUcusV01lajp6MNRmf/12Sz/P9HXIBM=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=gSEtkb8ph5AzMm8MTWj2OeHqX7J+o0WXlDV9YPseFNY8QHPAsjyPLLauYIsFso/Vc7BClCcNx3gOyh5Kxpa112sA3gSZ0CQnbBOsx0/VsXDR3SF5Xh8KMjK6YwnxzQChRWZ+O+Sri4jst2Y0dPZA/+mc9x7jgrRFmH0x1OSxwXo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=adrm+S1E; arc=none smtp.client-ip=209.85.215.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="adrm+S1E"
Received: by mail-pg1-f172.google.com with SMTP id 41be03b00d2f7-c998fd549a8so5598611a12.2
        for <linux-crypto@vger.kernel.org>; Fri, 17 Jul 2026 16:17:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1784330265; x=1784935065; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=qzTGenpWHqW3MfAEWohsvcJM0Z+Hc8JZQUdY0v5X1yI=;
        b=adrm+S1E7vbPFvlpDiZC1od6DmyVMuJo0dh1aiH/b/TzzDbRc1Tru9wD5PpQFTGSuj
         Vz99BWt207IWMuSHlviqBEKN5gmcAQ1rR8NcjPsyoF88EsQ4Mj8Swk78jYGvVrGst1NG
         vN8lidIG3iyBcmPXCUYH+jH9P80pcyKvQAsLtEI2LrplBRpAoDY4xmnPeXjy3emJVvUV
         KBELl64VlXH38IBvZknmgvB41rDZ5aR7zrqqTEZZsqrUGaG+efjwkfCgi5SDrV7QuC+Y
         FWsmAHhUwFB6eG4xpcIUDatPYkSyjMFQV+6rskOdZrs01EiEVqSwO2LeRPR1vVJNGrtk
         oklg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1784330265; x=1784935065;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=qzTGenpWHqW3MfAEWohsvcJM0Z+Hc8JZQUdY0v5X1yI=;
        b=FDTEgOdpDcuEIA94/mOJ7utwJ6SerbHaXSQ4jnacIHdGLNbJSMGHQRDZgSZPaJhKXm
         f22gMl66Vvg2oyES7La17lt9/1+Gupuw0OCz9bMf7NqB/kebsvVqXhn9frzPY1cf7OO0
         +HE2Du0iyKeI1vFdQ6nqmaBeuXFjCwtWXTGhBFBfFXUBcKCicWgzsQehU1DQxwcOV66U
         WehiJQ/uUwAF/pRIIFhRMAatCXgzedMtPcdvBjIwUXH1hmlaRVgj9apuQTvr11jxx7dp
         0FFWL3wjbjgxQ6D+iHQlF+m+iTdNm+ODOsMbjt0v7Fumy+AG+jsndPMbNRwbUeXyjsHR
         SRmg==
X-Gm-Message-State: AOJu0YxMgZO8VAHmWy1F37FcOXCnIB3oOlDXqrdY0PCuxlHYL27aRdg/
	vcT2hd5833N6igOnYLl4cYUNt/CqK8LxKjUhMJxSjDV3EqNg++WFpqtktnls4w==
X-Gm-Gg: AfdE7cnvIbQnAtNO/Xra0HO9U/tGR9u62FDTrDxtjSXZ8r+JuKzUu0KqxYJHmKTRQYX
	i66QobD5hb5QDhY61EZ4/rCisjua6Jq8kGM44bQ5uOvXxGu30lAihtX76m/4tt8ijfrUyBxlwa2
	ItReKCQblolz+t/BhPJzdDApkWC/hIoNecNhCdrLgd8LsXxr58wnuNVfUs2aJy8G+0xNLQ70LWG
	qVGzxE2tk9hVxBtOkRR1DRWpy3TkaZtqKHMxBiHT5Pdz44VNH6aAENTVZHr9xjHNi4Aa38FKbga
	SIDRxPzHgULJkR016C88IqH1Eux+iHw5Nlz7aVIgC0tJ0lecugrvbSDqRhP6mVSDFchpqjZ5t6M
	1pAJditIzlXYe1vsBLlPD1ZciTJbcc1wDYQAuhzyrv00uIjsfveofWj0Ydy6/9y3aU3b08fFHi7
	uoB2cenYfOcbdODHhxv3E29thPdQq57adJ3G5NcTBW56uKZhgSwiZ6Wa4ZG8+cF8VkbjqW/8gWn
	KIzchQtwBjj6mQ0mffVN3bw6tHS4mSaL9GSfe1p2Izn2afRL4qFtyA=
X-Received: by 2002:a05:6a20:9397:b0:3c1:817:792e with SMTP id adf61e73a8af0-3c3ad9d04aamr4956486637.57.1784330265179;
        Fri, 17 Jul 2026 16:17:45 -0700 (PDT)
Received: from ryzen.lan ([2601:644:8000:7a86::e35])
        by smtp.gmail.com with ESMTPSA id 41be03b00d2f7-cb5159b11a5sm1452633a12.0.2026.07.17.16.17.43
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 17 Jul 2026 16:17:43 -0700 (PDT)
From: Rosen Penev <rosenp@gmail.com>
To: linux-crypto@vger.kernel.org
Cc: Srujana Challa <schalla@marvell.com>,
	Bharat Bhushan <bbhushan2@marvell.com>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	"David S. Miller" <davem@davemloft.net>,
	linux-kernel@vger.kernel.org (open list)
Subject: [PATCH] crypto: cesa: manage SRAM teardown with devm
Date: Fri, 17 Jul 2026 16:17:42 -0700
Message-ID: <20260717231742.1174221-1-rosenp@gmail.com>
X-Mailer: git-send-email 2.55.0
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

mv_cesa_put_sram() is called explicitly from both the probe error path
and mv_cesa_remove(). The non-pool ioremap is already devm-managed, but
dma_map_resource() and gen_pool_dma_alloc() have no devm helpers, so the
mapping is released by hand. This is error-prone: the error path iterates
over every engine and can dma_unmap_resource() an uninitialized/zero
address for engines that were never set up.

Convert the teardown into a devm_add_action_or_reset() callback registered
only after a mapping is successfully established. The callback fires
automatically on probe failure (devres rollback) and on device detach,
after mv_cesa_remove() has already stopped the engine and freed the IRQ,
so the unmap still happens in a safe order. This deletes the explicit
mv_cesa_put_sram() calls and the uninitialized-engine bug at once.

Add a struct mv_cesa_dev back-pointer to struct mv_cesa_engine so the
callback can reach cesa->dev and cesa->sram_size from the engine alone.

Assisted-by: opencode:hy3-free
Signed-off-by: Rosen Penev <rosenp@gmail.com>
---
 drivers/crypto/marvell/cesa/cesa.c | 55 ++++++++++++------------------
 drivers/crypto/marvell/cesa/cesa.h |  2 ++
 2 files changed, 24 insertions(+), 33 deletions(-)

diff --git a/drivers/crypto/marvell/cesa/cesa.c b/drivers/crypto/marvell/cesa/cesa.c
index 75d8ba23d9a2..4859ad2e86b4 100644
--- a/drivers/crypto/marvell/cesa/cesa.c
+++ b/drivers/crypto/marvell/cesa/cesa.c
@@ -366,6 +366,8 @@ static int mv_cesa_dev_dma_init(struct mv_cesa_dev *cesa)
 	return 0;
 }
 
+static void mv_cesa_release_sram(void *data);
+
 static int mv_cesa_get_sram(struct platform_device *pdev, int idx)
 {
 	struct mv_cesa_dev *cesa = platform_get_drvdata(pdev);
@@ -378,11 +380,13 @@ static int mv_cesa_get_sram(struct platform_device *pdev, int idx)
 		engine->sram_pool = gen_pool_dma_alloc(engine->pool,
 						       cesa->sram_size,
 						       &engine->sram_dma);
-		if (engine->sram_pool)
-			return 0;
+		if (!engine->sram_pool) {
+			engine->pool = NULL;
+			return -ENOMEM;
+		}
 
-		engine->pool = NULL;
-		return -ENOMEM;
+		return devm_add_action_or_reset(cesa->dev, mv_cesa_release_sram,
+					engine);
 	}
 
 	engine->sram = devm_platform_get_and_ioremap_resource(pdev, idx, &res);
@@ -395,13 +399,13 @@ static int mv_cesa_get_sram(struct platform_device *pdev, int idx)
 	if (dma_mapping_error(cesa->dev, engine->sram_dma))
 		return -ENOMEM;
 
-	return 0;
+	return devm_add_action_or_reset(cesa->dev, mv_cesa_release_sram, engine);
 }
 
-static void mv_cesa_put_sram(struct platform_device *pdev, int idx)
+static void mv_cesa_release_sram(void *data)
 {
-	struct mv_cesa_dev *cesa = platform_get_drvdata(pdev);
-	struct mv_cesa_engine *engine = &cesa->engines[idx];
+	struct mv_cesa_engine *engine = data;
+	struct mv_cesa_dev *cesa = engine->cesa;
 
 	if (engine->pool)
 		gen_pool_free(engine->pool, (unsigned long)engine->sram_pool,
@@ -465,17 +469,16 @@ static int mv_cesa_probe(struct platform_device *pdev)
 		char res_name[16];
 
 		engine->id = i;
+		engine->cesa = cesa;
 		spin_lock_init(&engine->lock);
 
 		ret = mv_cesa_get_sram(pdev, i);
 		if (ret)
-			goto err_cleanup;
+			return ret;
 
 		irq = platform_get_irq(pdev, i);
-		if (irq < 0) {
-			ret = irq;
-			goto err_cleanup;
-		}
+		if (irq < 0)
+			return irq;
 
 		engine->irq = irq;
 
@@ -487,18 +490,14 @@ static int mv_cesa_probe(struct platform_device *pdev)
 		engine->clk = devm_clk_get_optional_enabled(dev, res_name);
 		if (IS_ERR(engine->clk)) {
 			engine->clk = devm_clk_get_optional_enabled(dev, NULL);
-			if (IS_ERR(engine->clk)) {
-				ret = PTR_ERR(engine->clk);
-				goto err_cleanup;
-			}
+			if (IS_ERR(engine->clk))
+				return PTR_ERR(engine->clk);
 		}
 
 		snprintf(res_name, sizeof(res_name), "cesaz%u", i);
 		engine->zclk = devm_clk_get_optional_enabled(dev, res_name);
-		if (IS_ERR(engine->zclk)) {
-			ret = PTR_ERR(engine->zclk);
-			goto err_cleanup;
-		}
+		if (IS_ERR(engine->zclk))
+			return PTR_ERR(engine->zclk);
 
 		engine->regs = cesa->regs + CESA_ENGINE_OFF(i);
 
@@ -516,7 +515,7 @@ static int mv_cesa_probe(struct platform_device *pdev)
 						dev_name(&pdev->dev),
 						engine);
 		if (ret)
-			goto err_cleanup;
+			return ret;
 
 		/* Set affinity */
 		cpu = cpumask_local_spread(engine->id, NUMA_NO_NODE);
@@ -532,29 +531,19 @@ static int mv_cesa_probe(struct platform_device *pdev)
 	ret = mv_cesa_add_algs(cesa);
 	if (ret) {
 		cesa_dev = NULL;
-		goto err_cleanup;
+		return ret;
 	}
 
 	dev_info(dev, "CESA device successfully registered\n");
 
 	return 0;
-
-err_cleanup:
-	for (i = 0; i < caps->nengines; i++)
-		mv_cesa_put_sram(pdev, i);
-
-	return ret;
 }
 
 static void mv_cesa_remove(struct platform_device *pdev)
 {
 	struct mv_cesa_dev *cesa = platform_get_drvdata(pdev);
-	int i;
 
 	mv_cesa_remove_algs(cesa);
-
-	for (i = 0; i < cesa->caps->nengines; i++)
-		mv_cesa_put_sram(pdev, i);
 }
 
 static const struct platform_device_id mv_cesa_plat_id_table[] = {
diff --git a/drivers/crypto/marvell/cesa/cesa.h b/drivers/crypto/marvell/cesa/cesa.h
index 18f9f28040a6..44351b252861 100644
--- a/drivers/crypto/marvell/cesa/cesa.h
+++ b/drivers/crypto/marvell/cesa/cesa.h
@@ -415,6 +415,7 @@ struct mv_cesa_dev_dma {
  * @zclk:		engine zclk
  * @max_req_len:	maximum chunk length (useful to create the TDMA chain)
  * @int_mask:		interrupt mask cache
+ * @cesa:		back-pointer to the parent CESA device
  * @pool:		memory pool pointing to the memory region reserved in
  *			SRAM
  * @queue:		fifo of the pending crypto requests
@@ -441,6 +442,7 @@ struct mv_cesa_engine {
 	struct clk *zclk;
 	size_t max_req_len;
 	u32 int_mask;
+	struct mv_cesa_dev *cesa;
 	struct gen_pool *pool;
 	struct crypto_queue queue;
 	atomic_t load;
-- 
2.55.0

