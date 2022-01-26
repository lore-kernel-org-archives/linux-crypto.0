Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EECDBC4332F
	for <linux-crypto@archiver.kernel.org>; Wed, 26 Jan 2022 21:04:59 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231719AbiAZVE7 (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Wed, 26 Jan 2022 16:04:59 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38332 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231748AbiAZVE4 (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 26 Jan 2022 16:04:56 -0500
Received: from mail-wm1-x32d.google.com (mail-wm1-x32d.google.com [IPv6:2a00:1450:4864:20::32d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2BBA9C061753
        for <linux-crypto@vger.kernel.org>; Wed, 26 Jan 2022 13:04:55 -0800 (PST)
Received: by mail-wm1-x32d.google.com with SMTP id l12-20020a7bc34c000000b003467c58cbdfso4568950wmj.2
        for <linux-crypto@vger.kernel.org>; Wed, 26 Jan 2022 13:04:55 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=baylibre-com.20210112.gappssmtp.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=ktDMlL8iZ2/3sijREuAuM+dmCDydSQ7poFBUP0oLczo=;
        b=Bcf1/J/JmjcL2kH4RMGo+wEKEkU7RNdbp/dUD/SMq9d16A9F3ZxfzpBe/WGhw5LKwS
         B6I6jCDxKuAFG7oNxPtidy5p6ovVXSM+zTRcs04Hexy+8sp8jnmz8Df85wRVf2nXlkNh
         I8NZhayNkaYAQLU9bI221UwNcKkcHWEinCsaaaAWls1eNTeepzoqs4/OcGce/YUURmpD
         qLAq+9Sq8rNNEvOToeVcmutc25KNOe5KXw0nwVWPkBylM4+pQeVvX0hYKBhWeB/ED1zf
         IDmVhmC0q4hdu7usPsN/FX5ds8q5c2IvJWhfoNoc4pE4ame8maYzvc47+fmkBUB2EdQ9
         +lJg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=ktDMlL8iZ2/3sijREuAuM+dmCDydSQ7poFBUP0oLczo=;
        b=zhiBa6z2EANgKINWvpc/ZWjw39acnHA+Zyo30I0M+hRCzfLN2e4S0N54XBwWNR7nu/
         Fk1OCPvoei00N1ekuiqZ4csI5LQiriAFfN81T5wlRYfLyvghcgpaz8Gu6lD96SGv9S2y
         pHBm4QSSUOjMgLYyjqV0dIwZe+kl3IYSjQFOWmdm1KzhgnCqK3RpFpGVDKXQtVPh+HA9
         z3cqIRKYVEwRSD312vS2PLnVG526lJgHsZeu5reuQhLQQSGwv3dU6I7Ik062WOz+kf/7
         Vc+N/3e6wRY/gpcJwddDOLdNcTafK4SjoRWFEccyk1RrFBWW8aCLU+FN9yab6YS6bgbB
         LHeg==
X-Gm-Message-State: AOAM533+fCnj1koE8NIWSiACmYkhGgEikKFeNPURF1FxXX1PqkvJTOME
        z/kVERA9m6Kns3wD/N8DmO+kZw==
X-Google-Smtp-Source: ABdhPJxiNZGsixA/dP4HPSBuINQsxbgvdDaaxpjkQ5Ww1hZP2upy4QOmEl+72jz0ry9zZys6s8Wb5Q==
X-Received: by 2002:a7b:cb8c:: with SMTP id m12mr459302wmi.154.1643231093676;
        Wed, 26 Jan 2022 13:04:53 -0800 (PST)
Received: from localhost.localdomain (laubervilliers-658-1-213-31.w90-63.abo.wanadoo.fr. [90.63.244.31])
        by smtp.googlemail.com with ESMTPSA id j19sm4948611wmq.17.2022.01.26.13.04.52
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 26 Jan 2022 13:04:52 -0800 (PST)
From:   Corentin Labbe <clabbe@baylibre.com>
To:     davem@davemloft.net, herbert@gondor.apana.org.au,
        jernej.skrabec@gmail.com, mripard@kernel.org, wens@csie.org
Cc:     linux-arm-kernel@lists.infradead.org, linux-crypto@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-sunxi@lists.linux.dev,
        linux-sunxi@googlegroups.com, Corentin Labbe <clabbe@baylibre.com>
Subject: [PATCH 4/8] crypto: sun8i-ss: do not allocate memory when handling hash requests
Date:   Wed, 26 Jan 2022 21:04:37 +0000
Message-Id: <20220126210441.3661782-5-clabbe@baylibre.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20220126210441.3661782-1-clabbe@baylibre.com>
References: <20220126210441.3661782-1-clabbe@baylibre.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Instead of allocate memory on each requests, it is easier to
pre-allocate buffers.
This made error path easier.

Signed-off-by: Corentin Labbe <clabbe@baylibre.com>
---
 drivers/crypto/allwinner/sun8i-ss/sun8i-ss-core.c | 10 ++++++++++
 drivers/crypto/allwinner/sun8i-ss/sun8i-ss-hash.c | 15 +++------------
 drivers/crypto/allwinner/sun8i-ss/sun8i-ss.h      |  4 ++++
 3 files changed, 17 insertions(+), 12 deletions(-)

diff --git a/drivers/crypto/allwinner/sun8i-ss/sun8i-ss-core.c b/drivers/crypto/allwinner/sun8i-ss/sun8i-ss-core.c
index 319fe3279a71..084261d7899c 100644
--- a/drivers/crypto/allwinner/sun8i-ss/sun8i-ss-core.c
+++ b/drivers/crypto/allwinner/sun8i-ss/sun8i-ss-core.c
@@ -474,6 +474,16 @@ static int allocate_flows(struct sun8i_ss_dev *ss)
 	for (i = 0; i < MAXFLOW; i++) {
 		init_completion(&ss->flows[i].complete);
 
+		/* the padding could be up to two block. */
+		ss->flows[i].pad = devm_kmalloc(ss->dev, SHA256_BLOCK_SIZE * 2,
+						GFP_KERNEL | GFP_DMA);
+		if (!ss->flows[i].pad)
+			goto error_engine;
+		ss->flows[i].result = devm_kmalloc(ss->dev, SHA256_DIGEST_SIZE,
+						   GFP_KERNEL | GFP_DMA);
+		if (!ss->flows[i].result)
+			goto error_engine;
+
 		ss->flows[i].engine = crypto_engine_alloc_init(ss->dev, true);
 		if (!ss->flows[i].engine) {
 			dev_err(ss->dev, "Cannot allocate engine\n");
diff --git a/drivers/crypto/allwinner/sun8i-ss/sun8i-ss-hash.c b/drivers/crypto/allwinner/sun8i-ss/sun8i-ss-hash.c
index 2557bb3fe7aa..f7a9578e87f7 100644
--- a/drivers/crypto/allwinner/sun8i-ss/sun8i-ss-hash.c
+++ b/drivers/crypto/allwinner/sun8i-ss/sun8i-ss-hash.c
@@ -341,18 +341,11 @@ int sun8i_ss_hash_run(struct crypto_engine *engine, void *breq)
 	if (digestsize == SHA224_DIGEST_SIZE)
 		digestsize = SHA256_DIGEST_SIZE;
 
-	/* the padding could be up to two block. */
-	pad = kzalloc(algt->alg.hash.halg.base.cra_blocksize * 2, GFP_KERNEL | GFP_DMA);
-	if (!pad)
-		return -ENOMEM;
+	result = ss->flows[rctx->flow].result;
+	pad = ss->flows[rctx->flow].pad;
+	memset(pad, 0, algt->alg.hash.halg.base.cra_blocksize * 2);
 	bf = (__le32 *)pad;
 
-	result = kzalloc(digestsize, GFP_KERNEL | GFP_DMA);
-	if (!result) {
-		kfree(pad);
-		return -ENOMEM;
-	}
-
 	for (i = 0; i < MAX_SG; i++) {
 		rctx->t_dst[i].addr = 0;
 		rctx->t_dst[i].len = 0;
@@ -448,8 +441,6 @@ int sun8i_ss_hash_run(struct crypto_engine *engine, void *breq)
 
 	memcpy(areq->result, result, algt->alg.hash.halg.digestsize);
 theend:
-	kfree(pad);
-	kfree(result);
 	crypto_finalize_hash_request(engine, breq, err);
 	return 0;
 }
diff --git a/drivers/crypto/allwinner/sun8i-ss/sun8i-ss.h b/drivers/crypto/allwinner/sun8i-ss/sun8i-ss.h
index 28188685b910..f9f089ede934 100644
--- a/drivers/crypto/allwinner/sun8i-ss/sun8i-ss.h
+++ b/drivers/crypto/allwinner/sun8i-ss/sun8i-ss.h
@@ -121,11 +121,15 @@ struct sginfo {
  * @complete:	completion for the current task on this flow
  * @status:	set to 1 by interrupt if task is done
  * @stat_req:	number of request done by this flow
+ * @pad:	padding buffer for hash operations
+ * @result:	buffer for storing the result of hash operations
  */
 struct sun8i_ss_flow {
 	struct crypto_engine *engine;
 	struct completion complete;
 	int status;
+	void *pad;
+	void *result;
 #ifdef CONFIG_CRYPTO_DEV_SUN8I_SS_DEBUG
 	unsigned long stat_req;
 #endif
-- 
2.34.1

