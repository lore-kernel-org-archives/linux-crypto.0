Received: from mail-qt1-f175.google.com (mail-qt1-f175.google.com [209.85.160.175])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8B7C634752F
	for <linux-crypto@vger.kernel.org>; Sat, 13 Jun 2026 23:46:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.160.175
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781394381; cv=none; b=SgII1fbG66EF3y1hZ0VBS8G5S4lkazyLQPPkBzuEPG4Dstk8fPR5CJjgE5zG8VtACr6cekUdhqOFck0Gh48YTUiG79snRHk+hQZ7CAGp5DxIsg2tP36z5VSeEnAarfEHXPJlLbbJaggLDlGm2WgDI/CM8DYlo/xg1H/VHO2abbg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781394381; c=relaxed/simple;
	bh=CfWJot3SKjXt8ceJZLe4hKTlf92dxoeuK2OvsyC3Frw=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=UIh8uNpr3IiBobccc107esG5JoA/yc9x48jlbsZYhnzwd1YoCkFV3zQsIipuu6dYse+GJB8bdS4kYHPe0w2PhSNlz5x3Tq/OfIvISA9Vsr7jtROKGUmeBXkHvByKhC3I9j2Pkg+Aoox4lXrEPxNFLFnv2hVhbqfnK7GmdfZIiP0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=aR4w9yPv; arc=none smtp.client-ip=209.85.160.175
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="aR4w9yPv"
Received: by mail-qt1-f175.google.com with SMTP id d75a77b69052e-51761d27612so26236161cf.3
        for <linux-crypto@vger.kernel.org>; Sat, 13 Jun 2026 16:46:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1781394379; x=1781999179; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=Ls3gEwpchKnksI5GGC5dUIm4pnSS/9GpJMm8LP9GAcI=;
        b=aR4w9yPvNy/a1460X52igemGR164nfPkglBLdNY98RMAoyC25hmEteSFUEfpzFPclY
         buva45BmRfiQxTH1fW8Ocmm/huKF0yM5nmo0ep59i9kMHZnGT/UPz6G+9YeoumuLqHls
         lRZBpuQ2PIaWVLfHyP4tVSsp1Azcnl8VQkbcAO3po9kbDpzZYp6Das8cBukShkX31c21
         2ewkLZMUwu5BAJd1uJMOcDVwb4Gt70oZZjE2+PNNhSVn4HvliVZ0EQ+KIeLZtvUBdHre
         Fz31aoDAgFXSUH9dqgyjwF7vu8/xVZJeaU+MYLFMQ2679e5lnbvxzILytRJ6vwxC5Vpt
         suAg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1781394379; x=1781999179;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Ls3gEwpchKnksI5GGC5dUIm4pnSS/9GpJMm8LP9GAcI=;
        b=pi5DrnQ+/GwpW9i+BFyPhEkxNbzy8olANPob+Np76BHchqMQxb5ouVTBd+tN88U2p+
         Diq4t34Tilv4j5H7Htw+mV87rE8808JgQt6vAR6M1/lttQu9xiqQMVHrhl/+xMzY1mTx
         wAONyRBe9ByvEDCEdJwENupb5yqc0XekhTIVANzqnhn1l4pBqTsBO33kin4tC5lWurwN
         iGHYkoYLa44+ivgJX4tJggKGMnxvwNvBKi88Yx4QStkNuq2YX82daYCJ42G9MueozRUv
         d63+H9wQJE+roPnfpTwLGxp9VBIxIQyCsJsOu3afmV1L5k7vwEoiIuCqF1oTSYl6ZHOo
         CcfA==
X-Gm-Message-State: AOJu0YxxxvJnsg1kz6oAOvkurkPEJmMLmho9jIngUrcDzex8yTy3ciBn
	JWrQECPjxaUHAfmxmfxc3LYwlrHHSXMMU6YaP4Jy9g5xHJF/JE6usNGAhZIhlQ==
X-Gm-Gg: Acq92OErmZsA/x5owDDs7CRhWvQkBhxBs+OYqUMP/eLRf4Hs9iarz+gJX9cwj3dmyLb
	VlDWyU0KxO8/FOy7Cdw554qWetsUvgbLzmR62hOqidljfSGcUVa409J5vpRgKbPtxgSVPl2krNP
	dmnmod/W/WI2HXDyOA8PHE7xnkLQF455Q4KMDzCWt8hH1j8C/L+094OGhVz4oMY0W4Tzi6/yHXH
	xRUyI6GdZLqKTtekQszlOvPQJBq3XxaPKpTOiRVesM77l14k4fahDMdtjHlCg/zprIx6sBsS3N7
	Zpb9m2X6MYwFa/sMXWucrbySMDb8s/i+KyKuMxm6Ui4AsRyBAd6KnCh9rumGU/6lPypCeJD48HX
	CSgp4jPuq9Z5EVd7krZ5Ei2mbjmnOTBkuPkfIPx3aYwRdeDF+J1KtEZs5RjNvNqCojM13IH10+I
	U//u5u8fE6aryFzMhRtvGYuOceLh5Vlb4zAdGfU7Uqknw6oivziXQF5VONUhj/om1TjoNz+twIX
	kt+dyb0vkunZXoHDUPb05f+mRuZ9zcrOyA=
X-Received: by 2002:ac8:5f11:0:b0:517:61d5:2f85 with SMTP id d75a77b69052e-517fe5cbddfmr129673881cf.33.1781394379444;
        Sat, 13 Jun 2026 16:46:19 -0700 (PDT)
Received: from ryzen ([2601:644:8000:5b5d:6e63:e53e:e773:8f84])
        by smtp.gmail.com with ESMTPSA id d75a77b69052e-517fb81697asm62069361cf.26.2026.06.13.16.46.16
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 13 Jun 2026 16:46:18 -0700 (PDT)
From: Rosen Penev <rosenp@gmail.com>
To: linux-crypto@vger.kernel.org
Cc: Herbert Xu <herbert@gondor.apana.org.au>,
	"David S. Miller" <davem@davemloft.net>,
	linux-kernel@vger.kernel.org (open list)
Subject: [PATCH] crypto: amcc - embed pdr_uinfo as flexible array in crypto4xx_device
Date: Sat, 13 Jun 2026 16:45:59 -0700
Message-ID: <20260613234559.20934-1-rosenp@gmail.com>
X-Mailer: git-send-email 2.54.0
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

No need to allocate and free separately.

This keeps crypto4xx_destroy_pdr dedicated to dma freeing only.

Assisted-by: opencode:big-pickle
Signed-off-by: Rosen Penev <rosenp@gmail.com>
---
 drivers/crypto/amcc/crypto4xx_core.c | 12 +-----------
 drivers/crypto/amcc/crypto4xx_core.h |  3 ++-
 2 files changed, 3 insertions(+), 12 deletions(-)

diff --git a/drivers/crypto/amcc/crypto4xx_core.c b/drivers/crypto/amcc/crypto4xx_core.c
index 001da785af07..ea1e40b3184b 100644
--- a/drivers/crypto/amcc/crypto4xx_core.c
+++ b/drivers/crypto/amcc/crypto4xx_core.c
@@ -171,14 +171,6 @@ static u32 crypto4xx_build_pdr(struct crypto4xx_device *dev)
 	if (!dev->pdr)
 		return -ENOMEM;
 
-	dev->pdr_uinfo = kzalloc_objs(struct pd_uinfo, PPC4XX_NUM_PD);
-	if (!dev->pdr_uinfo) {
-		dma_free_coherent(dev->core_dev->device,
-				  sizeof(struct ce_pd) * PPC4XX_NUM_PD,
-				  dev->pdr,
-				  dev->pdr_pa);
-		return -ENOMEM;
-	}
 	dev->shadow_sa_pool = dma_alloc_coherent(dev->core_dev->device,
 				   sizeof(union shadow_sa_buf) * PPC4XX_NUM_PD,
 				   &dev->shadow_sa_pool_pa,
@@ -226,8 +218,6 @@ static void crypto4xx_destroy_pdr(struct crypto4xx_device *dev)
 		dma_free_coherent(dev->core_dev->device,
 			sizeof(struct sa_state_record) * PPC4XX_NUM_PD,
 			dev->shadow_sr_pool, dev->shadow_sr_pool_pa);
-
-	kfree(dev->pdr_uinfo);
 }
 
 static u32 crypto4xx_get_pd_from_pdr_nolock(struct crypto4xx_device *dev)
@@ -1247,7 +1237,7 @@ static int crypto4xx_probe(struct platform_device *ofdev)
 	dev_set_drvdata(dev, core_dev);
 	core_dev->ofdev = ofdev;
 	core_dev->dev = devm_kzalloc(
-		&ofdev->dev, sizeof(struct crypto4xx_device), GFP_KERNEL);
+		&ofdev->dev, struct_size(core_dev->dev, pdr_uinfo, PPC4XX_NUM_PD), GFP_KERNEL);
 	if (!core_dev->dev)
 		return -ENOMEM;
 
diff --git a/drivers/crypto/amcc/crypto4xx_core.h b/drivers/crypto/amcc/crypto4xx_core.h
index 66a95733c86d..bd4a286514a4 100644
--- a/drivers/crypto/amcc/crypto4xx_core.h
+++ b/drivers/crypto/amcc/crypto4xx_core.h
@@ -93,11 +93,12 @@ struct crypto4xx_device {
 	u32 gdr_head;
 	u32 sdr_tail;
 	u32 sdr_head;
-	struct pd_uinfo *pdr_uinfo;
 	struct list_head alg_list;	/* List of algorithm supported
 					by this device */
 	struct ratelimit_state aead_ratelimit;
 	bool is_revb;
+
+	struct pd_uinfo pdr_uinfo[];
 };
 
 struct crypto4xx_core_device {
-- 
2.54.0

