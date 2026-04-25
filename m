Received: from mail-pl1-f171.google.com (mail-pl1-f171.google.com [209.85.214.171])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4229454723
	for <linux-crypto@vger.kernel.org>; Sat, 25 Apr 2026 02:33:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.171
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777084387; cv=none; b=VTfsQEYpL5EBG34euE/u7AZSVaFJ0/AQfIW2pPNFTX7rhmzfDPZ6Xg5Mx2xt3FQo1xApsQzIZRqm6GLbV6t04f/NRZq6A3v77YnsbpDv3/j9CKUPGl1WnO1SaGI7vr0/bOsZcxfN+qOgrmf0s9alTfFJ4z+eBnlBWoOzQcczmcU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777084387; c=relaxed/simple;
	bh=8jjNobBH/xJYG5qzkVN8VrmgvRJKxZJp6h19nGipVfg=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=ffwtOACPxvN+PpOfNbhb6jLknVU3I8mDPvxWOX3HavwVQuV8Dq5nI/qNR9VwYDUZld8DkYqokgDM86/8YcTvrk3nv/NhCcNDD0uMiEqYqlbIQGlUWzOIE75DytiUE1cNta6P5XHeXtLLBe0Ytnf/iM5HPl4u8eL9/5xbsSq/yZk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=c6nGESC3; arc=none smtp.client-ip=209.85.214.171
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="c6nGESC3"
Received: by mail-pl1-f171.google.com with SMTP id d9443c01a7336-2addb31945aso54008335ad.1
        for <linux-crypto@vger.kernel.org>; Fri, 24 Apr 2026 19:33:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1777084385; x=1777689185; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=+b24Mt69TwuLf0I4MyKfERwYOm5QQa4t6DMlHUvjstE=;
        b=c6nGESC3zs0djHCFoTSlK1pX47WaGzhe324jMQo609Dyn3phRSzQssWJ4PayL1Wohy
         krUpX78LFqNQerMtqGS26wbMYaOG2dH9/ZwtBe0Gds7CoXaka4m+H5h4RwtBnAc/SZLw
         NurVRtfmf2ZJ/bM/a+kcNTwo5VsOcF0Kz50Zich6cSs5UMg4ejqFGD/fWfL3WG6rrHTT
         q1fkdJZgJOpPcPKwQHJLRLZOsatBb/xWthyL26vmSyL8uWUNy/pHJbWyjjGbu0rR2I+A
         pCfKlGyhQwDtRtDym811S9xpigrSM6ttCfTI8Kf59gBsXMNKosH+F6cjF2+3UNXzleMU
         gs5w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1777084385; x=1777689185;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=+b24Mt69TwuLf0I4MyKfERwYOm5QQa4t6DMlHUvjstE=;
        b=Vgvin7b7QpGBXhhlnaCs2Vh6n63q5YOYVgnxoV8FPPsp7Te/pt3F4qicMpcmzx8lns
         7fmL1w+dSZQ05sdLXWO+MhapKm+9Fbzk5kXF1NRosoqtGKDat5wdkxFFuZ82c72rnMOu
         6+z2+TXTEnGzXAgBTB8Gn2XCzAbIPLdBMu2HPfnzfQAAt63v+vDv0Y95vLoygMyFW37v
         Yv1MQkg9EmI30nDrx6n18zYabSWAON6/UsOL1H9F70qYvb3LWXlqMgczzES7I1CK0JUw
         +ivhEK3q0yDfJ7uWqz+W3uUm94KW8n9Q2Ca807WzZlC1vIH1aUNTDRCUnhH4cv5kmIXe
         /Kog==
X-Gm-Message-State: AOJu0YwOGiRzIu0FYTi6Si3oI7L4I1JNsKcjqqr0shypKLnFRKMyO+NW
	+nnk7Ifl30fEMzpKCbJGxuqNe77mY3KB0xhDKRCmicGctrmIyFdprSmf6skcMa9q
X-Gm-Gg: AeBDievjLdXgJMkbFGytfhaA6O4TyEV6MpGbydhW4G0w17cXWAQGpBKiWD2Vpx4vuAm
	5YatDLQTAKgh8TmYiE9JrgrDANrhenXMk2Nyxj0CrDd+Eu7CZbOA72X2rmpIn7dz1/D/869woIF
	pKPsEwvPqk3UbWjmfnp9P0EnLtcn7oSNeJO+kQcTaXB3jEZ/gHNYewEMFrd+ILlC4fQkNU5lg40
	sWUVHp2YXqnIvWzJU4/BBmpbBg2PGf/gjkmnrcxy+Ipl/uwJh7OSLn91nt6Zd/+Q6EJi7ykD7tc
	Ld4E2u0pgPRteFD525SbR+FVqNc85g9UQ2QzdGPfRHHgEQKta4UR6G/hQ3UoIBtS+qkGUzvf4lf
	CS9/CDtgTIFXgx9N8jPx2W8aAGFdND5vhi8CdoiZbAm/Ck/UPVX3uC+WXfgUMSTL1jfoEZgRfMS
	GcwgPAFngkP06DGe1tQFS1iVCHZSKuXnZcvld07WkdJwwS3qvMOPGdCLpIpiSOqRh7I7cS8ufPu
	3nAo+qLuppAI1kq3wlhNcpNJA==
X-Received: by 2002:a17:903:2acb:b0:2b4:5b9e:2f51 with SMTP id d9443c01a7336-2b5f9fb80demr383669195ad.34.1777084385208;
        Fri, 24 Apr 2026 19:33:05 -0700 (PDT)
Received: from ryzen ([2601:644:8000:5b5d::8bd])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2b5fab0cbaasm242312295ad.54.2026.04.24.19.33.03
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 24 Apr 2026 19:33:04 -0700 (PDT)
From: Rosen Penev <rosenp@gmail.com>
To: linux-crypto@vger.kernel.org
Cc: Srujana Challa <schalla@marvell.com>,
	Bharat Bhushan <bbhushan2@marvell.com>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	"David S. Miller" <davem@davemloft.net>,
	linux-kernel@vger.kernel.org (open list)
Subject: [PATCH] crypto: cesa: allocate engines with main struct
Date: Fri, 24 Apr 2026 19:32:47 -0700
Message-ID: <20260425023247.475233-1-rosenp@gmail.com>
X-Mailer: git-send-email 2.54.0
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Use a flexible array member to combine and simplify allocation.

Move struct mv_cesa_dev down as flexible array members require full
definitions.

Signed-off-by: Rosen Penev <rosenp@gmail.com>
---
 drivers/crypto/marvell/cesa/cesa.c | 11 +++-----
 drivers/crypto/marvell/cesa/cesa.h | 42 +++++++++++++++---------------
 2 files changed, 25 insertions(+), 28 deletions(-)

diff --git a/drivers/crypto/marvell/cesa/cesa.c b/drivers/crypto/marvell/cesa/cesa.c
index 8afa3a87e38d..687ed730174d 100644
--- a/drivers/crypto/marvell/cesa/cesa.c
+++ b/drivers/crypto/marvell/cesa/cesa.c
@@ -416,7 +416,7 @@ static int mv_cesa_probe(struct platform_device *pdev)
 	const struct mbus_dram_target_info *dram;
 	struct device *dev = &pdev->dev;
 	struct mv_cesa_dev *cesa;
-	struct mv_cesa_engine *engines;
+	struct mv_cesa_engine *engine;
 	int irq, ret, i, cpu;
 	u32 sram_size;
 
@@ -431,7 +431,8 @@ static int mv_cesa_probe(struct platform_device *pdev)
 			return -ENOTSUPP;
 	}
 
-	cesa = devm_kzalloc(dev, sizeof(*cesa), GFP_KERNEL);
+	cesa = devm_kzalloc(dev, struct_size(cesa, engines, caps->nengines),
+			GFP_KERNEL);
 	if (!cesa)
 		return -ENOMEM;
 
@@ -445,10 +446,6 @@ static int mv_cesa_probe(struct platform_device *pdev)
 		sram_size = CESA_SA_MIN_SRAM_SIZE;
 
 	cesa->sram_size = sram_size;
-	cesa->engines = devm_kcalloc(dev, caps->nengines, sizeof(*engines),
-				     GFP_KERNEL);
-	if (!cesa->engines)
-		return -ENOMEM;
 
 	spin_lock_init(&cesa->lock);
 
@@ -465,7 +462,7 @@ static int mv_cesa_probe(struct platform_device *pdev)
 	platform_set_drvdata(pdev, cesa);
 
 	for (i = 0; i < caps->nengines; i++) {
-		struct mv_cesa_engine *engine = &cesa->engines[i];
+		engine = &cesa->engines[i];
 		char res_name[16];
 
 		engine->id = i;
diff --git a/drivers/crypto/marvell/cesa/cesa.h b/drivers/crypto/marvell/cesa/cesa.h
index 50ca1039fdaa..18f9f28040a6 100644
--- a/drivers/crypto/marvell/cesa/cesa.h
+++ b/drivers/crypto/marvell/cesa/cesa.h
@@ -402,27 +402,6 @@ struct mv_cesa_dev_dma {
 	struct dma_pool *padding_pool;
 };
 
-/**
- * struct mv_cesa_dev - CESA device
- * @caps:	device capabilities
- * @regs:	device registers
- * @sram_size:	usable SRAM size
- * @lock:	device lock
- * @engines:	array of engines
- * @dma:	dma pools
- *
- * Structure storing CESA device information.
- */
-struct mv_cesa_dev {
-	const struct mv_cesa_caps *caps;
-	void __iomem *regs;
-	struct device *dev;
-	unsigned int sram_size;
-	spinlock_t lock;
-	struct mv_cesa_engine *engines;
-	struct mv_cesa_dev_dma *dma;
-};
-
 /**
  * struct mv_cesa_engine - CESA engine
  * @id:			engine id
@@ -471,6 +450,27 @@ struct mv_cesa_engine {
 	int irq;
 };
 
+/**
+ * struct mv_cesa_dev - CESA device
+ * @caps:	device capabilities
+ * @regs:	device registers
+ * @sram_size:	usable SRAM size
+ * @lock:	device lock
+ * @dma:	dma pools
+ * @engines:	array of engines
+ *
+ * Structure storing CESA device information.
+ */
+struct mv_cesa_dev {
+	const struct mv_cesa_caps *caps;
+	void __iomem *regs;
+	struct device *dev;
+	unsigned int sram_size;
+	spinlock_t lock;
+	struct mv_cesa_dev_dma *dma;
+	struct mv_cesa_engine engines[];
+};
+
 /**
  * struct mv_cesa_req_ops - CESA request operations
  * @process:	process a request chunk result (should return 0 if the
-- 
2.54.0

