Return-Path: <SRS0=+94A=AC=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.0 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5020CC433DF
	for <linux-crypto@archiver.kernel.org>; Sun, 21 Jun 2020 19:31:25 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 321C7208C9
	for <linux-crypto@archiver.kernel.org>; Sun, 21 Jun 2020 19:31:25 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=baylibre-com.20150623.gappssmtp.com header.i=@baylibre-com.20150623.gappssmtp.com header.b="BKRWVR01"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730519AbgFUTbY (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Sun, 21 Jun 2020 15:31:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51134 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730487AbgFUTbW (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Sun, 21 Jun 2020 15:31:22 -0400
Received: from mail-wm1-x343.google.com (mail-wm1-x343.google.com [IPv6:2a00:1450:4864:20::343])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0F6AFC061798
        for <linux-crypto@vger.kernel.org>; Sun, 21 Jun 2020 12:31:21 -0700 (PDT)
Received: by mail-wm1-x343.google.com with SMTP id g10so12965009wmh.4
        for <linux-crypto@vger.kernel.org>; Sun, 21 Jun 2020 12:31:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=baylibre-com.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=KSaVCb5R/kfhdtt9sMjPgwUadZUPmANMPo71JtvUH48=;
        b=BKRWVR01NZDnbf/v/M0EGA9FBYyAVZF8+BCT/zHuLZmIrRd9eoiXRQ6ilw9kdwmHbh
         tgAQoKJ9Z87xRw0PYKp6jIEgp1q40PXGvjjGPLg6UfaVORP03mRZXvTjND5l1Btt/2dd
         OEAnjYf4LzUTXuou+bElRTzrrghc0+EQa7OyMIWV0ZRGNjgtQuWknS7onHiD9ClrYkKM
         61BYc2g2w3Sz91nxOq/JT553nVsGByrM7LPYLxlee2mmX+bc99o/7HXPYFEItsMe7NIr
         GKFkf9RfQe0jnO+bZF1k4bvndlnL9bXjMjGa3u8bOMJmnKlkltyUwR92YTWj1+wX0dBo
         wTag==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=KSaVCb5R/kfhdtt9sMjPgwUadZUPmANMPo71JtvUH48=;
        b=stLOk3iXxzbAhXLYXmb+DjAp3KLWSZjqEnqsyJvPjakOm1D9w+PhzPUhCIQ7W72qCO
         lZCHkhF0BSRqvqfYlNR/934ACjKGUAs8vYtfR7g3z7upmzlkQIduEQpLAuyD0ETs2R1v
         2kCmw7fFyKBdQmzm0q+b5Yzn8WhBjfwK0/sV2RMJZXZHsHdas5icd72052Xxi6Jw+XtM
         g+RqzE4PkfSJm4doQiHA3sDQaCfZ2xGuFk4tWjipNkHdABWKuMAf8KuwEsAUMo+BTTWv
         rPSE8uIA9D+ZZXHoXefEdLB2B6Hfxqqq0qXZQruEAkbqAKcPsx+8juQjU6kdMLDnUh03
         XSYA==
X-Gm-Message-State: AOAM5314ey1SXLqimoVEtCqe1iPVTYEiD/6VeUdcqH9tT1LHNvtSgfeA
        SIM4ssSlztvrBJNQQTamZiG9fA==
X-Google-Smtp-Source: ABdhPJz/v6jt0JwTuYmYtQn8W3yRKEAcUg4V/e4ipBOq32pjilUn9eS/fdSeIQh2u8kdfmMgbiroBw==
X-Received: by 2002:a05:600c:21c2:: with SMTP id x2mr14873184wmj.33.1592767879748;
        Sun, 21 Jun 2020 12:31:19 -0700 (PDT)
Received: from localhost.localdomain ([51.15.160.169])
        by smtp.googlemail.com with ESMTPSA id e3sm16086924wrj.17.2020.06.21.12.31.18
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Sun, 21 Jun 2020 12:31:19 -0700 (PDT)
From:   Corentin Labbe <clabbe@baylibre.com>
To:     davem@davemloft.net, herbert@gondor.apana.org.au,
        mripard@kernel.org, wens@csie.org
Cc:     linux-arm-kernel@lists.infradead.org, linux-crypto@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-sunxi@googlegroups.com,
        Corentin Labbe <clabbe@baylibre.com>
Subject: [PATCH v3 07/14] crypto: sun8i-ce: move iv data to request context
Date:   Sun, 21 Jun 2020 19:31:00 +0000
Message-Id: <1592767867-35982-8-git-send-email-clabbe@baylibre.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1592767867-35982-1-git-send-email-clabbe@baylibre.com>
References: <1592767867-35982-1-git-send-email-clabbe@baylibre.com>
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Instead of storing IV data in the channel context, store them in the
request context.
Storing them in the channel structure was conceptualy wrong since they
are per request related.

Signed-off-by: Corentin Labbe <clabbe@baylibre.com>
---
 .../allwinner/sun8i-ce/sun8i-ce-cipher.c      | 27 +++++++++----------
 drivers/crypto/allwinner/sun8i-ce/sun8i-ce.h  | 10 ++++---
 2 files changed, 19 insertions(+), 18 deletions(-)

diff --git a/drivers/crypto/allwinner/sun8i-ce/sun8i-ce-cipher.c b/drivers/crypto/allwinner/sun8i-ce/sun8i-ce-cipher.c
index a6abb701bfc6..7716fa2d3250 100644
--- a/drivers/crypto/allwinner/sun8i-ce/sun8i-ce-cipher.c
+++ b/drivers/crypto/allwinner/sun8i-ce/sun8i-ce-cipher.c
@@ -91,7 +91,6 @@ static int sun8i_ce_cipher(struct skcipher_request *areq)
 	struct scatterlist *sg;
 	unsigned int todo, len, offset, ivsize;
 	dma_addr_t addr_iv = 0, addr_key = 0;
-	void *backup_iv = NULL;
 	u32 common, sym;
 	int flow, i;
 	int nr_sgs = 0;
@@ -154,24 +153,24 @@ static int sun8i_ce_cipher(struct skcipher_request *areq)
 
 	ivsize = crypto_skcipher_ivsize(tfm);
 	if (areq->iv && crypto_skcipher_ivsize(tfm) > 0) {
-		chan->ivlen = ivsize;
-		chan->bounce_iv = kzalloc(ivsize, GFP_KERNEL | GFP_DMA);
-		if (!chan->bounce_iv) {
+		rctx->ivlen = ivsize;
+		rctx->bounce_iv = kzalloc(ivsize, GFP_KERNEL | GFP_DMA);
+		if (!rctx->bounce_iv) {
 			err = -ENOMEM;
 			goto theend_key;
 		}
 		if (rctx->op_dir & CE_DECRYPTION) {
-			backup_iv = kzalloc(ivsize, GFP_KERNEL);
-			if (!backup_iv) {
+			rctx->backup_iv = kzalloc(ivsize, GFP_KERNEL);
+			if (!rctx->backup_iv) {
 				err = -ENOMEM;
 				goto theend_key;
 			}
 			offset = areq->cryptlen - ivsize;
-			scatterwalk_map_and_copy(backup_iv, areq->src, offset,
-						 ivsize, 0);
+			scatterwalk_map_and_copy(rctx->backup_iv, areq->src,
+						 offset, ivsize, 0);
 		}
-		memcpy(chan->bounce_iv, areq->iv, ivsize);
-		addr_iv = dma_map_single(ce->dev, chan->bounce_iv, chan->ivlen,
+		memcpy(rctx->bounce_iv, areq->iv, ivsize);
+		addr_iv = dma_map_single(ce->dev, rctx->bounce_iv, rctx->ivlen,
 					 DMA_TO_DEVICE);
 		cet->t_iv = cpu_to_le32(addr_iv);
 		if (dma_mapping_error(ce->dev, addr_iv)) {
@@ -252,17 +251,17 @@ static int sun8i_ce_cipher(struct skcipher_request *areq)
 theend_iv:
 	if (areq->iv && ivsize > 0) {
 		if (addr_iv)
-			dma_unmap_single(ce->dev, addr_iv, chan->ivlen,
+			dma_unmap_single(ce->dev, addr_iv, rctx->ivlen,
 					 DMA_TO_DEVICE);
 		offset = areq->cryptlen - ivsize;
 		if (rctx->op_dir & CE_DECRYPTION) {
-			memcpy(areq->iv, backup_iv, ivsize);
-			kzfree(backup_iv);
+			memcpy(areq->iv, rctx->backup_iv, ivsize);
+			kzfree(rctx->backup_iv);
 		} else {
 			scatterwalk_map_and_copy(areq->iv, areq->dst, offset,
 						 ivsize, 0);
 		}
-		kfree(chan->bounce_iv);
+		kfree(rctx->bounce_iv);
 	}
 
 theend_key:
diff --git a/drivers/crypto/allwinner/sun8i-ce/sun8i-ce.h b/drivers/crypto/allwinner/sun8i-ce/sun8i-ce.h
index 0e9eac397e1b..c9c7ef8299e2 100644
--- a/drivers/crypto/allwinner/sun8i-ce/sun8i-ce.h
+++ b/drivers/crypto/allwinner/sun8i-ce/sun8i-ce.h
@@ -129,8 +129,6 @@ struct ce_task {
 /*
  * struct sun8i_ce_flow - Information used by each flow
  * @engine:	ptr to the crypto_engine for this flow
- * @bounce_iv:	buffer which contain the IV
- * @ivlen:	size of bounce_iv
  * @complete:	completion for the current task on this flow
  * @status:	set to 1 by interrupt if task is done
  * @t_phy:	Physical address of task
@@ -139,8 +137,6 @@ struct ce_task {
  */
 struct sun8i_ce_flow {
 	struct crypto_engine *engine;
-	void *bounce_iv;
-	unsigned int ivlen;
 	struct completion complete;
 	int status;
 	dma_addr_t t_phy;
@@ -183,10 +179,16 @@ struct sun8i_ce_dev {
  * struct sun8i_cipher_req_ctx - context for a skcipher request
  * @op_dir:	direction (encrypt vs decrypt) for this request
  * @flow:	the flow to use for this request
+ * @backup_iv:	buffer which contain the next IV to store
+ * @bounce_iv:	buffer which contain a copy of IV
+ * @ivlen:	size of bounce_iv
  */
 struct sun8i_cipher_req_ctx {
 	u32 op_dir;
 	int flow;
+	void *backup_iv;
+	void *bounce_iv;
+	unsigned int ivlen;
 };
 
 /*
-- 
2.26.2

