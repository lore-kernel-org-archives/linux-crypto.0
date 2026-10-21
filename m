Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792584974;
	b=pFM5CTwVQirTKHPFmcOu9+PXUFpRltAmzY+mm8uJa2Y0DLhzHAVI5w/XPHmTKNuX8ygV
	 ddwPXwMVbZtglv7fYT4s2ErQCRk+rWGiTOzgla43h/SMNSjjGz/pp7aeX4vGExW+o+C4l
	 wdtHHHh0wsUZNY/RDlfwB7AfaAQTcU2v1G662JmDsL+qag3tE4ifsSUJT7P6obAAKu8cK
	 rGLd5QahIjYBlxWS9ZBnPiD0f5yD4hYG1vLCMUtUzAmVQxxij3swJ7it43m9fDkI9kqRU
	 Lni3FN4B5DnNo6rsWog7v80a8w8TdGK3WaHmZ3xkyzQuGjSiypz/dvLYAKRVQ/Z2qLQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792584974;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:MIME-Version:Content-Transfer-Encoding;
	bh=14xqRJbBwPSTUwMpLNaEdMOdsXigfG/PZ5Nys6W811A=;
	b=aCf5v13oFtLb/427Wfg6QEmfX6Z1Jx7+KQ8Q1DHFdLIdmKB/c4QaJs8FzzdbX7JOuaS0
	 D3FcFmSaSvkWKNdbg0v/S/SghH/1QW1W/cv1CZXx5MrreCHzKFOH2MriVowG843RUqlGM
	 GopY8KaPveZNwwslaD8H+qhUg6oiIQNNZvjU/yy9VojE8tEgEOad7wyn9E7CxRBe4LQdP
	 TPlVl1DTzLkOGnPY1IiZonplHKu+og0MuuiP0IWQdCV8WilsqdE4MrvLZVWaSISlAITdo
	 stE6kqHPJMYklnUOv8OT0d6YdK4lUEnYj09BrvONu4AKfLteMa2B7AkU7s+upmVjaUg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=CySbTGku;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 31A2860A2612;
	Wed, 21 Oct 2026 12:16:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=CySbTGku
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 518441F000C4;
	Wed, 21 Oct 2026 12:16:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792584973;
	bh=14xqRJbBwPSTUwMpLNaEdMOdsXigfG/PZ5Nys6W811A=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=CySbTGku/p1XXOGUiHGHB2To7Jn1H2F49N+Nti9JYAJP5peQg75qm+Ctp4yZRi5Yl
	 l0f2pw9KKz2xjhPLYMrTkdDQbUUFVoz3CXroH39JvnUs5IhBeMp5WqiyUmQDnRgpCr
	 hbvpqF/R2/IYF/CjQWTY91k1EOblZM2XC+xMR+lcfK/GxVSaAXMuLqw1kLyVu6PnCq
	 +kCXkIGbXoNBtuhQMxgWOZ4UqTILrEfeOrHVAmWW3j7YpGDQG2Dw9Jg/rUn90EgD36
	 jtx9o9pSd3FGGGD/j3W9VhEJOE2xjtpOdXL2lbQTZEpNOqeYtf7m9oMzObrW2WhjA9
	 pcN/0ooGXDRyw==
From: Lee Jones <lee@kernel.org>
To: lee@kernel.org,
	Qunqin Zhao <zhaoqunqin@loongson.cn>,
	Yinggang Gu <guyinggang@loongson.cn>,
	Huacai Chen <chenhuacai@kernel.org>,
	linux-crypto@vger.kernel.org,
	mfd@lists.linux.dev,
	linux-kernel@vger.kernel.org
Cc: stable@vger.kernel.org
Subject: [PATCH 21/28] mfd: loongson-se: Validate engine ID, DMA buffer size, and IRQ registration
Date: Wed, 21 Oct 2026 12:09:43 +0000
Message-ID: <20261021121245.3111563-21-lee@kernel.org>
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
2.56.0.218.g1ec904b173-goog

