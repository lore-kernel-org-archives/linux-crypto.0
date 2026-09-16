Received: from mail-pj2-f13.google.com (mail-pj2-f13.google.com [74.125.227.141])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 790D143DA38
	for <linux-crypto@vger.kernel.org>; Wed, 16 Sep 2026 23:05:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=74.125.227.141
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789599930; cv=none; b=sGJR54ppiLA8lOZ+0SxVuXoWgxNfHYxQ7HX3NJ4YDbsrhd0JP+xkyEKl/I+5fIYTWxbj6ZMo1OEFlIll9Ms2MfvLLSMsCyB8zyC9NmQcsLxDLevfXkNhzbJQJSyvSXLxJmEo/OCRX0u6Gf6xtNZjiO8I77TW8Il55oxqnt14VWY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789599930; c=relaxed/simple;
	bh=Z6PcnsznE6aBA3m7fse5WL9XUU+DUmRIKh/4fcjvkIU=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=cFIA5t7MEHV4EZ/uXJNXAC8ARPlR7U2U5iJZm+7CvXbo7NXi+dVp7SieCde1zcqNl90RuEpHa8eRpPwschs7MifbnJfoGYnTGrr9a/6jyElgsdgV+qPpFapbBwZOX5S1rTMtBE2btBVmGtBcv15JSUwsvwflDQhTD9Aq/ITaA3A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=J33nf6yG; arc=none smtp.client-ip=74.125.227.141
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="J33nf6yG"
Received: by mail-pj2-f13.google.com with SMTP id 98e67ed59e1d1-396ccc02279so175076a91.1
        for <linux-crypto@vger.kernel.org>; Wed, 16 Sep 2026 16:05:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1789599929; x=1790204729; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=QOMIwZQbx5+TuflTXtQ2GHARtOa9+XMsOBCfGbZ4teI=;
        b=J33nf6yGvVZSLVfcdmVBXk74IoKYL/6HoUxOskj6TVeW74T477SBHo8WTb+YTIM+yt
         1PgRrxC3mgqOy4WPZNcOpBdaU0AhehzouqIfuSQ5d7fsmElKJhgbCHAtBWzGK1syFrPX
         yeayP1FZHwjTbF+LoBGtigGXbFkk0/DDGR0xmHH0pO4eYcZw1LRjUnBkoJgDvHVvlu/n
         PJWXoEiijx/AKLtAR2iLcyHYU8ZsNvWMlfmRIuMKlAyNlVlCA4yY0vSp3EOiyA0PPIUF
         plhRt3/L21aEsiojrD9xfBOnQT4VCF6+eBT6ddJZuWb9hIyLbMRbtEHQTzqm5BB01MRh
         oKEA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1789599929; x=1790204729;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=QOMIwZQbx5+TuflTXtQ2GHARtOa9+XMsOBCfGbZ4teI=;
        b=DaQ+PjfuTUKA8moefIPJnDxKVUFQufnVhHGfSDpxnL91j+cDtqNopK5CmgVJTWVgql
         VVPwhJDd5MI8ZIFiRdiEvbulttHJcVkEMV26xBP4telGIlD8m06awyKhVXst+tJOb3Iu
         Qp/NhjqRWeKkw5ur6yKHEp5X7BnIdyzZanAacgNWOMg70XbNy+etbSoXZdKrFVOc5HuP
         SK6RO0ae6RNjEI69gYwrT33N/zC4BXqczRnY1b2CE1tXxBDq8zMPtnR/NRDZQLanWC0q
         eDU7kdyP+JgM2y2KUVd4k9Ig6K5qIvzFjQB7o18ZlzGp8WFqhmrauZE5NNB/utD7Hsgi
         re1g==
X-Gm-Message-State: AFuF++nCFNLUv8fOLsRpaRxGu5MrL9EX3R+QAeAAHdkOd9r7cfQQ+uG+
	CtWDUFx0X++UR6blrpIDzOgXpBp0l5u1HZcPrKveNDajgBuajz29Phu/weYYWY8O
X-Gm-Gg: AYBFou1kdOVr94oafTZJjIzhNce4vzNpmJA8OmhK+zVbH5ZPVtphUJlVY6e7ikcXwjc
	HzjQMioLVUxkvdKOa0ai/i1GQSwSZ9wJF+sVPbHVxvogFK3c+76gPD0O/OTwGwwcqS65HydHEVi
	0bWPSwge+x1bZWIx0nQA0MmrUjeSvpleTFeiw6iLTNpEkb5vfgR+xc41JJsyZMYoVUQ4RlUeRy8
	w1kX4rda9I8NoHzY58yFLL2bjFaPXcF2bYJl1uekPevKBCIAjCuMjpRhErZxlgkPCteK4lHX6av
	aa1PLS6FJxtVVePVW0ADUft9tD2W+gXTCvRA197yTLyJoAg3Gxrt5mJAHhRQYOyUwW3FYlanQhB
	Dz78R5+rek15LJ5rp6Datc8dvXim6WB4oYOZgQPBRaH0oWbIywW55NorkFeu5+4GLQz3Uq5Rdjn
	T82Jkx8BRjqgtewWsXYMkjpx1uWaWKxQ0Zt04d0Gv8Nwqgnyruc7PvrUyAnC4g598RhsJsMW99W
	NARGw+Uvabm/spvnJWPn+BpzV8lfvJ/moazpgD5EjpGNRJ+I7JgSaVP5erbuuHixR9S1Ug6y/AN
	vVBxSD1g4zOgmR6fH/V4lV+8u6iFrEXatcjHCq/Mjw2lKMmK
X-Received: by 2002:a17:90b:5445:b0:39d:f4a8:75ef with SMTP id 98e67ed59e1d1-39e1e23d60dmr9633703a91.1.1789599928755;
        Wed, 16 Sep 2026 16:05:28 -0700 (PDT)
Received: from ryzen.lan ([2601:644:8000:7a86::e35])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-39e35daaa93sm1707990a91.2.2026.09.16.16.05.27
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 16 Sep 2026 16:05:28 -0700 (PDT)
From: Rosen Penev <rosenp@gmail.com>
To: linux-crypto@vger.kernel.org
Cc: Srujana Challa <schalla@marvell.com>,
	Bharat Bhushan <bbhushan2@marvell.com>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	"David S. Miller" <davem@davemloft.net>,
	linux-kernel@vger.kernel.org (open list)
Subject: [PATCH] crypto: cesa: complete pending requests on device remove
Date: Wed, 16 Sep 2026 16:05:26 -0700
Message-ID: <20260916230526.284982-1-rosenp@gmail.com>
X-Mailer: git-send-email 2.55.0
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

mv_cesa_remove() unregisters the algorithms and frees the IRQs but never
drains the engine queues. Each engine can still hold outstanding requests
in three places: engine->req (currently in flight), engine->queue (queued
but not started), and engine->complete_queue (processed but not yet
reported). The latter two are only completed from the IRQ handler, which
is torn down before they are flushed.

If the device is unbound via sysfs while requests are outstanding, those
waiters never receive their completion callback and block indefinitely,
leaking the request and its scatterlist buffers.

Drain all three queues in mv_cesa_remove() and complete each remaining
request with -ENOENT before freeing the IRQ, so bound tasks are released.

Assisted-by: LLM
Signed-off-by: Rosen Penev <rosenp@gmail.com>
---
 drivers/crypto/marvell/cesa/cesa.c | 46 ++++++++++++++++++++++++++++++
 1 file changed, 46 insertions(+)

diff --git a/drivers/crypto/marvell/cesa/cesa.c b/drivers/crypto/marvell/cesa/cesa.c
index 564b09773507..25a30deca4c5 100644
--- a/drivers/crypto/marvell/cesa/cesa.c
+++ b/drivers/crypto/marvell/cesa/cesa.c
@@ -546,6 +546,52 @@ static void mv_cesa_remove(struct platform_device *pdev)
 	mv_cesa_remove_algs(cesa);
 
 	cesa_dev = NULL;
+
+	for (int i = 0; i < cesa->caps->nengines; i++) {
+		struct mv_cesa_engine *engine = &cesa->engines[i];
+		struct crypto_async_request *req;
+
+		/*
+		 * Stop the engine before releasing resources so it no longer
+		 * issues DMA to the SRAM region or to request scatterlists
+		 * that are about to be unmapped.
+		 */
+		writel(0, engine->regs + CESA_SA_INT_MSK);
+		writel(0, engine->regs + CESA_SA_CMD);
+		writel(0, engine->regs + CESA_TDMA_CONTROL);
+
+		spin_lock_bh(&engine->lock);
+		/*
+		 * Complete the request currently in flight and drain the
+		 * pending and already-processed queues with an error so that
+		 * waiters do not block indefinitely when the device is unbound
+		 * while requests are still outstanding.
+		 */
+		if (engine->req) {
+			req = engine->req;
+			engine->req = NULL;
+			spin_unlock_bh(&engine->lock);
+			mv_cesa_complete_req(crypto_tfm_ctx(req->tfm), req,
+					     -ENOENT);
+			spin_lock_bh(&engine->lock);
+		}
+
+		while ((req = crypto_dequeue_request(&engine->queue)) != NULL) {
+			spin_unlock_bh(&engine->lock);
+			mv_cesa_complete_req(crypto_tfm_ctx(req->tfm), req,
+					     -ENOENT);
+			spin_lock_bh(&engine->lock);
+		}
+
+		while ((req = mv_cesa_engine_dequeue_complete_request(engine))
+		       != NULL) {
+			spin_unlock_bh(&engine->lock);
+			mv_cesa_complete_req(crypto_tfm_ctx(req->tfm), req,
+					     -ENOENT);
+			spin_lock_bh(&engine->lock);
+		}
+		spin_unlock_bh(&engine->lock);
+	}
 }
 
 static const struct platform_device_id mv_cesa_plat_id_table[] = {
-- 
2.55.0

