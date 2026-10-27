Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793097497;
	b=XGBewQa5d61pnS54QCBECamA6XLLbANrUIp2Dz8wAr7YwKkZqHkmFVkOXYg7ClnZ0fSH
	 cyZOIHPOCQPA+I6/SsOD0CrSP93wTkYHcI8wTyjdKmcz7XQiC7p4gUs8HZh+kc+Ei30KL
	 3NwdcEGFElmt0NLmK2SLPOacln4fyd/EwpvswbMPvXD5yz5cGPsOu8/H9Rq/c4pgRzi+W
	 R+abWX/pcQ/soOyJjihYq3tjqlGDeW0cAAF0ugvnVF6S3gVboETEJbBKbUm0J3Ki2UQWA
	 LPo3IRTq5aw+FtaEEI6gxSQRkJ5gqahkJmNN0zC2BE5ds1CVu90My+HltOl6tXMlzZQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793097497;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:MIME-Version:Content-Transfer-Encoding;
	bh=VHwOQc4xd1c5yDav45N4nzLOr45k0+6M1trrosK72YI=;
	b=2+Ub0nTEVGnGuhlxfKaUIticnp25mVNzyLc2mnOfSVOwWntbEc2OYOowb9Mg7Cbvuqt1
	 z0fFOhzsfe2TrU7fxmJj+D6yq9XUgq439CgA21CSg/sfN2A6RU+0/o9HGzJy+4dMVLUpn
	 0Xntz25pImT89Xsx5Shx5QT2fBQ10v/JeQID0UYFfmwyDaVTP1pZZfgKmo8xrSOiWplcR
	 l0Vdw2e5Z9+FJYPWJcf0x1rBtSWQJqXan264KcXWC/AtRV+RVEBCD2i2TFYMlAEZitbjU
	 N9aV7lAR4PnjUodkTTnF4cjaKKQa7/jzHW4LtZ+r9JEr5cQq1NiDrWG+gHY9bqUsxCQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=VmGK8jg3;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2C4D5606A31D;
	Tue, 27 Oct 2026 10:38:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=VmGK8jg3
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6ABDB1F01829;
	Tue, 27 Oct 2026 10:38:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793097496;
	bh=VHwOQc4xd1c5yDav45N4nzLOr45k0+6M1trrosK72YI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=VmGK8jg34t3Q5QNkDhAN6K6XFUB6OOUAfA0rccFRqTQ3+2RmYsNSTgu9KBFqGtJwI
	 ZUmAZGlsvDnzNkVNJ7/L9gDFnoFEXleoXYn9u0v+tGa8UQxqejQowDVTv7qNisBJN4
	 FwKT2hk+QxNT3LxzkXTKZuCNHChi8jbjqSUTy7UaAnj2XCyCkVJ0M3YjtitjuixxW6
	 DG4Y0pG2NKqZkkAASZX08P4QIGXEXBb6vxIaKToUAlDuN2pjkm+mkaSc4dLBS6vPZU
	 hfFESYiC91X13Kf/PWEuAkd7u6CfuXrP63n0HeRrBEuodjS/6HcNJVwFDzTi1TiLuc
	 3MrWfxOYwNWtg==
From: Lee Jones <lee@kernel.org>
To: lee@kernel.org,
	Qunqin Zhao <zhaoqunqin@loongson.cn>,
	Yinggang Gu <guyinggang@loongson.cn>,
	Huacai Chen <chenhuacai@kernel.org>,
	linux-crypto@vger.kernel.org,
	mfd@lists.linux.dev,
	linux-kernel@vger.kernel.org
Cc: stable@vger.kernel.org
Subject: [PATCH v2 20/27] mfd: loongson-se: Validate engine ID, DMA buffer size, and IRQ registration
Date: Tue, 27 Oct 2026 09:30:49 +0000
Message-ID: <20261027093306.2812695-21-lee@kernel.org>
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

Harden input and error checking in loongson_se_init_engine() and
loongson_se_probe():

- Reject out-of-bounds engine IDs and engine 0 in
  loongson_se_init_engine() before indexing se->engines.
- Store dmam_size as u32 to match device_property_read_u32() and verify
  that it is large enough to hold the command buffers of all engines
  within engine 0's data region.
- Propagate negative error codes from platform_irq_count(),
  platform_get_irq(), and devm_request_irq() instead of ignoring IRQ
  registration failures or masking -EPROBE_DEFER.

Fixes: e551fa3159e3 ("mfd: Add support for Loongson Security Engine chip controller")
Closes: https://sashiko.dev/#/bug/linux-89bf25f5-ecd9-40e3-bb4c-bd26d07c53a1
Cc: stable@vger.kernel.org
Reviewed-by: Qunqin Zhao <zhaoqunqin@loongson.cn>
Signed-off-by: Lee Jones <lee@kernel.org>
---
 drivers/mfd/loongson-se.c | 23 ++++++++++++++++++-----
 1 file changed, 18 insertions(+), 5 deletions(-)

diff --git a/drivers/mfd/loongson-se.c b/drivers/mfd/loongson-se.c
index bdbab4b91729..23af05d388aa 100644
--- a/drivers/mfd/loongson-se.c
+++ b/drivers/mfd/loongson-se.c
@@ -26,7 +26,7 @@ struct loongson_se {
 	struct completion cmd_completion;
 
 	void *dmam_base;
-	int dmam_size;
+	u32 dmam_size;
 
 	struct mutex engine_init_lock;
 	struct loongson_se_engine engines[SE_ENGINE_MAX];
@@ -101,8 +101,13 @@ EXPORT_SYMBOL_GPL(loongson_se_send_engine_cmd);
 struct loongson_se_engine *loongson_se_init_engine(struct device *dev, int id)
 {
 	struct loongson_se *se = dev_get_drvdata(dev);
-	struct loongson_se_engine *engine = &se->engines[id];
 	struct loongson_se_controller_cmd cmd = {};
+	struct loongson_se_engine *engine;
+
+	if (id <= 0 || id >= SE_ENGINE_MAX)
+		return NULL;
+
+	engine = &se->engines[id];
 
 	engine->se = se;
 	engine->id = id;
@@ -186,7 +191,7 @@ static void loongson_se_stop(void *data)
 	mutex_unlock(&se->engine_init_lock);
 }
 
-static int loongson_se_init(struct loongson_se *se, dma_addr_t addr, int size)
+static int loongson_se_init(struct loongson_se *se, dma_addr_t addr, u32 size)
 {
 	struct loongson_se_controller_cmd cmd = {};
 	int err;
@@ -249,6 +254,9 @@ static int loongson_se_probe(struct platform_device *pdev)
 	if (device_property_read_u32(dev, "dmam_size", &se->dmam_size))
 		return -ENODEV;
 
+	if ((se->dmam_size / SE_ENGINE_MAX) < (SE_ENGINE_MAX * 2 * SE_ENGINE_CMD_SIZE))
+		return -EINVAL;
+
 	se->dmam_base = dmam_alloc_coherent(dev, se->dmam_size, &paddr, GFP_KERNEL);
 	if (!se->dmam_base)
 		return -ENOMEM;
@@ -258,16 +266,21 @@ static int loongson_se_probe(struct platform_device *pdev)
 		return PTR_ERR(se->base);
 
 	nr_irq = platform_irq_count(pdev);
-	if (nr_irq <= 0)
+	if (!nr_irq)
 		return -ENODEV;
+	if (nr_irq < 0)
+		return nr_irq;
 
 	writel(SE_INT_ALL, se->base + SE_S2LINT_CL);
 
 	for (i = 0; i < nr_irq; i++) {
 		irq = platform_get_irq(pdev, i);
+		if (irq < 0)
+			return irq;
+
 		err = devm_request_irq(dev, irq, se_irq_handler, 0, "loongson-se", se);
 		if (err)
-			dev_err(dev, "failed to request IRQ: %d\n", irq);
+			return dev_err_probe(dev, err, "Failed to request IRQ: %d\n", irq);
 	}
 
 	writel(SE_INT_ALL, se->base + SE_S2LINT_EN);
-- 
2.56.0.307.g5fe7bd680c-goog

