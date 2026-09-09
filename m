Received: from mail-pg1-f180.google.com (mail-pg1-f180.google.com [209.85.215.180])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0BE0E395ACB
	for <linux-crypto@vger.kernel.org>; Wed,  9 Sep 2026 21:12:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.180
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788988343; cv=none; b=uvqGOdc8tKdKdjAqkzq8DYA19oo/yTM1gZ1lTfbCDa3p2x7VjAVrbskLsxt/zAaVmJLrSg1kUEB9emH+zOdyu1mMw9Ak1HpKuHs2f7E36m2d9C6VRkaqsBD/yFsAhq6fmr2P4QoClpWnEwD7X4QIT/pLXlvL6JgrWnQCX0DMR8c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788988343; c=relaxed/simple;
	bh=lsJH/m1wwMGY3Tdn1zmWxqy3WlMlbk6ChjZYpxUGVoY=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=XjcY988UksNjvhcwJvzNraGYRRlbYdUJDe1HV8ufZ6mYKLl3w4H0n6QEDYEQmednVhpNE4fTmGw4g6Ba/Jr+wZHrAVUE3xPPkGmY+RXZGG+2CXqxScKilRV4bxGYoMgrrEIDw/noXdKc4DKIiEuz5uD/BqyjcEF4MbU0ve5CV6A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=s5Trg4VS; arc=none smtp.client-ip=209.85.215.180
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="s5Trg4VS"
Received: by mail-pg1-f180.google.com with SMTP id 41be03b00d2f7-cc147d86bebso387813a12.0
        for <linux-crypto@vger.kernel.org>; Wed, 09 Sep 2026 14:12:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1788988341; x=1789593141; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=u495ibL0ejeSjktkIJ/W4ElwT//FuX3YHoHh4p8PAXg=;
        b=s5Trg4VSzO5/hVmDqRO/N5qJpuYhhB7yql21kib/w71oEqY8cHVZ0s3rqgW1MmoSoI
         q5OqM9mc8vS9xA2r26zrp0+l/FBTvi86xw7L0OFV1JFR2dn71vXVmSUXJedyvOI3pGXk
         CX/PgLPu+/J+CAjqhc9DCzPiVoB6oD4QRrg9zKIAScgfwHsznUxxhmLG4PFkELkYm5Az
         xQcEQJ/qb/oQK5u4AcmWTjoZzRl5Z3oNCewBz0cMFRE/gDgVxzvO/ETq8tyNGhMp/7R+
         bsKoL/ALutNci89O5QzyoTKOavAuzYvehlps0metk8CqVfKoGS/f2WYrlRovt58AP0J8
         fxkQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1788988341; x=1789593141;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=u495ibL0ejeSjktkIJ/W4ElwT//FuX3YHoHh4p8PAXg=;
        b=nKO/zqWNufEJ8nFl+vfbhRLZvEOSBK0jyppDL+Ug+MI9jEg668ws3jevvmuJPZUa74
         8DoFOv+UXzqy2K8UmFqtq7aMZFnKbxI7kFvq2Rc2rMKHf+PQouwKs/Sm1SsSv+amFk/x
         ihtHcYnkIT33FpYogAumB4uiHRO6DIlNqjht5lT0N6gylb80+0n3qMX3x76JHHxsaXu8
         7ZKvD42jafCBheNNOrdbmsFwWNBFIAUioj7D4FQIPuOZoS3MZK+7qjHi42NC8ZbuNVR/
         PuCSFDQVwL5D1hccy2vLG94FO4kI1YzFpLUB/5SU+IRelcndmVoUlJzXPo2D2h2ounOk
         H8Jw==
X-Gm-Message-State: AFuF++nCAacREQOcIiyj5Fep7j5cPnVXhRfaSTWWs/OdkuOLhXPm0Mke
	u2zzAO+hBHjMJFbsFbV44qK2ema+ArRhppX2lv8Oq9N7ea1ZM/4XhMKDR5FhEA==
X-Gm-Gg: AYBFou2QwqEWAmpa4N9us9Wjw8jnE+sMQZSrSDf4dKOqSghhUoYvB4IhM3CCXS5noAi
	bcYVfylzXGzOSApLd1VreG9TpV9vV3wCz9eaPkdREdB+yFKdxEzHCJFobYaRHV2Dsm7q880URSO
	5GXtHdnkvxH4Tq4P4eeuS2ftub2oQzSmVJouvomM5Xt3WYXbJ3FFekdf6rhgWsdoyc77yFP7xMe
	QfGOk/tKyQb3nhlPWnCEO5C49qeyqKvROOxofJHMaBtzTrjUVT4iqOnW4w1oMRtQFXkcRHfiHJf
	RhqCcly5jgyk9b2qCSHhw2YYjYCXfLFo1uwhBY2N6gGte5SEJOfbm65EbNrrhxcIdxIlk1MWe6f
	ItC6D47a+QxEDL9dX3jVLdIWoYky7EdLqywDMvShT75S+8a/mcm7X4VdmmSiv2Xwu66RwmLQ5zr
	7NO7jEo8twyFdvWex9poeEITwksKTPjgai4p1tIK1RpmTU3hD0eRb0I267RI+Gl4TJ+O8UJgT3w
	CvnY6RALVWRmeFriGdapf1l904z1M8gG7Mdz5RbrJUrSo178T5Ynx4dSigZabTrXDGuBXuKFKOQ
	vf4Avg6U9Yrsu+TL8MLvxo4Bp8JssPb753IZPRW7SX+xxOkT
X-Received: by 2002:a05:6a20:258b:b0:3bf:b7e8:68ab with SMTP id adf61e73a8af0-3dad26bda32mr1323463637.2.1788988341177;
        Wed, 09 Sep 2026 14:12:21 -0700 (PDT)
Received: from ryzen.lan ([2601:644:8000:7a86::e35])
        by smtp.gmail.com with ESMTPSA id 41be03b00d2f7-cc46b4cd51esm6000615a12.2.2026.09.09.14.12.19
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 09 Sep 2026 14:12:20 -0700 (PDT)
From: Rosen Penev <rosenp@gmail.com>
To: linux-crypto@vger.kernel.org
Cc: Christian Marangi <ansuelsmth@gmail.com>,
	Antoine Tenart <atenart@kernel.org>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	"David S. Miller" <davem@davemloft.net>,
	linux-kernel@vger.kernel.org (open list)
Subject: [PATCH] crypto: eip93: fix IRQ teardown ordering in remove path
Date: Wed,  9 Sep 2026 14:12:18 -0700
Message-ID: <20260909211218.15388-1-rosenp@gmail.com>
X-Mailer: git-send-email 2.55.0
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Switch from devm_request_threaded_irq() to request_threaded_irq() so
that free_irq() can be called at the correct position in the remove
path.  Move the IRQ registration after tasklet_init() in probe to
ensure the tasklet is ready before the handler can fire.

Reorder eip93_cleanup() to:
  1. disable device interrupts (HW)
  2. free_irq() - synchronizes and removes the handler
  3. tasklet_kill() - safe, no new IRQs can arrive

The previous order (tasklet_kill before interrupt disable) could race:
an IRQ arriving after tasklet_kill() would schedule the already-killed
tasklet.  With devm_request_threaded_irq(), free_irq() ran after the
remove callback returned, leaving the handler registered while device
state was being torn down.

Assisted-by: opencode:big-pickle
Signed-off-by: Rosen Penev <rosenp@gmail.com>
---
 .../crypto/inside-secure/eip93/eip93-main.c   | 27 ++++++++++++-------
 1 file changed, 18 insertions(+), 9 deletions(-)

diff --git a/drivers/crypto/inside-secure/eip93/eip93-main.c b/drivers/crypto/inside-secure/eip93/eip93-main.c
index e62785952b0d..4cfddfd1935b 100644
--- a/drivers/crypto/inside-secure/eip93/eip93-main.c
+++ b/drivers/crypto/inside-secure/eip93/eip93-main.c
@@ -395,12 +395,16 @@ static int eip93_desc_init(struct eip93_device *eip93)
 
 static void eip93_cleanup(struct eip93_device *eip93)
 {
-	tasklet_kill(&eip93->ring->done_task);
-
-	/* Clear/ack all interrupts before disable all */
+	/* Stop HW from asserting IRQ first */
 	eip93_irq_clear(eip93, EIP93_INT_ALL);
 	eip93_irq_disable(eip93, EIP93_INT_ALL);
 
+	/* Synchronize and unregister the IRQ handler */
+	free_irq(eip93->irq, eip93);
+
+	/* No new IRQs can arrive - safe to kill the tasklet */
+	tasklet_kill(&eip93->ring->done_task);
+
 	writel(0, eip93->base + EIP93_REG_PE_CLOCK_CTRL);
 
 	eip93_desc_free(eip93);
@@ -430,12 +434,6 @@ static int eip93_crypto_probe(struct platform_device *pdev)
 	if (eip93->irq < 0)
 		return eip93->irq;
 
-	ret = devm_request_threaded_irq(eip93->dev, eip93->irq, eip93_irq_handler,
-					NULL, IRQF_ONESHOT,
-					dev_name(eip93->dev), eip93);
-	if (ret)
-		return ret;
-
 	ret = eip93_desc_init(eip93);
 	if (ret)
 		return ret;
@@ -448,6 +446,11 @@ static int eip93_crypto_probe(struct platform_device *pdev)
 	spin_lock_init(&eip93->ring->idr_lock);
 	idr_init(&eip93->ring->crypto_async_idr);
 
+	ret = request_threaded_irq(eip93->irq, eip93_irq_handler, NULL,
+				   IRQF_ONESHOT, dev_name(eip93->dev), eip93);
+	if (ret)
+		goto err_free_tasklet;
+
 	algo_flags = readl(eip93->base + EIP93_REG_PE_OPTION_1);
 
 	eip93_initialize(eip93, algo_flags);
@@ -472,6 +475,12 @@ static int eip93_crypto_probe(struct platform_device *pdev)
 		 readl(eip93->base + EIP93_REG_PE_OPTION_0));
 
 	return 0;
+
+err_free_tasklet:
+	idr_destroy(&eip93->ring->crypto_async_idr);
+	tasklet_kill(&eip93->ring->done_task);
+	eip93_desc_free(eip93);
+	return ret;
 }
 
 static void eip93_crypto_remove(struct platform_device *pdev)
-- 
2.55.0

