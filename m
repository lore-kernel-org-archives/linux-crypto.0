Return-Path: <SRS0=C62c=C3=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0551EC43464
	for <linux-crypto@archiver.kernel.org>; Fri, 18 Sep 2020 07:24:40 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id C058721D42
	for <linux-crypto@archiver.kernel.org>; Fri, 18 Sep 2020 07:24:39 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=baylibre-com.20150623.gappssmtp.com header.i=@baylibre-com.20150623.gappssmtp.com header.b="xxWvHISf"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726761AbgIRHYc (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 18 Sep 2020 03:24:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46274 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726470AbgIRHXh (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 18 Sep 2020 03:23:37 -0400
Received: from mail-wr1-x441.google.com (mail-wr1-x441.google.com [IPv6:2a00:1450:4864:20::441])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 82D4DC061352
        for <linux-crypto@vger.kernel.org>; Fri, 18 Sep 2020 00:23:35 -0700 (PDT)
Received: by mail-wr1-x441.google.com with SMTP id a17so4509850wrn.6
        for <linux-crypto@vger.kernel.org>; Fri, 18 Sep 2020 00:23:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=baylibre-com.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=Ds6HxnTNtu5m/JrQcsrg/mLcJSOWOvZ9q6npwKYcwqQ=;
        b=xxWvHISf9R/b7B6NfWT/en0tKPTu1nWiMjIW6SWF6jnjc1qzr6bxUUpNbeVit/ZWm2
         jWCpIR1kDlDSZuw8vyFM4fBKtkFq/o/ii53+NJC/RwyfBU0Q4lwDuzOO4U8W+GRdFi0L
         T5YJffQtAeTXmQF8a7cUU1B7ecSWrQKz1KloM3Cr8ah0R22/YCXS/7+xBDRjiWZovCZ0
         BfmPSytDc039DkfapBGRkScuGvgI/THAPQnUupAlRLy0Ao/9MpXX3Nig8A6ZdccglxXf
         e/Z1Y6XImGz/3IYIeGSpEXBWeHUUKMFT771w085tjcg9tvoY7lk03z07ho5QXyZFqPG/
         TGMg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=Ds6HxnTNtu5m/JrQcsrg/mLcJSOWOvZ9q6npwKYcwqQ=;
        b=dzJGrtigN/ptPvxUBYiyeU30conV6LO1+BvWioAN3osoa/Ib0DmVyakJjeBYIFVTov
         UppBKgmh3tKNnpim+sCkqbVDY51wx/hlmZ/Np/iPuN+JJvJ5CbloY8dPPAYWP0na7MHJ
         zj2psKhnd9cBLen2/0xEvrDbOnrQ/Hv6Ouumpi8flzSRHQdfGHATAxiBBjJFXWoCww83
         96zL3XAjUhCifneea3oEboSnh3yqR46Iw+KgLjuqH3AlNaIKeYDPuubZcEBGwysGmwFv
         IQ8x76cGX6WO+w6axkWbmaD+Rsk2q4/q78A64onwvAksumblqQTrA4gGvYvUBZOndXfn
         xMGw==
X-Gm-Message-State: AOAM532MYepcdhe7H4a3tJSkBg6CluwdS/mF8afAqka3twnEx53WKq0I
        qsX4TnhV/n3tlfDMIYv3By/a2A==
X-Google-Smtp-Source: ABdhPJwp5qQklv3u4wgL6ovYGSYdDOBAnCarUG/F6EglfOTZMuPqA2f/5TVVLPy68lceuHnpsoQhLw==
X-Received: by 2002:adf:f548:: with SMTP id j8mr37635681wrp.114.1600413814234;
        Fri, 18 Sep 2020 00:23:34 -0700 (PDT)
Received: from localhost.localdomain ([51.15.160.169])
        by smtp.googlemail.com with ESMTPSA id z19sm3349546wmi.3.2020.09.18.00.23.33
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Fri, 18 Sep 2020 00:23:33 -0700 (PDT)
From:   Corentin Labbe <clabbe@baylibre.com>
To:     davem@davemloft.net, herbert@gondor.apana.org.au,
        mripard@kernel.org, wens@csie.org
Cc:     linux-arm-kernel@lists.infradead.org, linux-crypto@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-sunxi@googlegroups.com,
        Corentin Labbe <clabbe@baylibre.com>
Subject: [PATCH v7 08/17] crypto: sun8i-ce: move iv data to request context
Date:   Fri, 18 Sep 2020 07:23:06 +0000
Message-Id: <1600413795-39256-9-git-send-email-clabbe@baylibre.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1600413795-39256-1-git-send-email-clabbe@baylibre.com>
References: <1600413795-39256-1-git-send-email-clabbe@baylibre.com>
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
index f996dc3d7dcc..f699b135de74 100644
--- a/drivers/crypto/allwinner/sun8i-ce/sun8i-ce-cipher.c
+++ b/drivers/crypto/allwinner/sun8i-ce/sun8i-ce-cipher.c
@@ -88,7 +88,6 @@ static int sun8i_ce_cipher(struct skcipher_request *areq)
 	struct scatterlist *sg;
 	unsigned int todo, len, offset, ivsize;
 	dma_addr_t addr_iv = 0, addr_key = 0;
-	void *backup_iv = NULL;
 	u32 common, sym;
 	int flow, i;
 	int nr_sgs = 0;
@@ -151,24 +150,24 @@ static int sun8i_ce_cipher(struct skcipher_request *areq)
 
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
@@ -249,17 +248,17 @@ static int sun8i_ce_cipher(struct skcipher_request *areq)
 theend_iv:
 	if (areq->iv && ivsize > 0) {
 		if (addr_iv)
-			dma_unmap_single(ce->dev, addr_iv, chan->ivlen,
+			dma_unmap_single(ce->dev, addr_iv, rctx->ivlen,
 					 DMA_TO_DEVICE);
 		offset = areq->cryptlen - ivsize;
 		if (rctx->op_dir & CE_DECRYPTION) {
-			memcpy(areq->iv, backup_iv, ivsize);
-			kfree_sensitive(backup_iv);
+			memcpy(areq->iv, rctx->backup_iv, ivsize);
+			kfree_sensitive(rctx->backup_iv);
 		} else {
 			scatterwalk_map_and_copy(areq->iv, areq->dst, offset,
 						 ivsize, 0);
 		}
-		kfree(chan->bounce_iv);
+		kfree(rctx->bounce_iv);
 	}
 
 theend_key:
diff --git a/drivers/crypto/allwinner/sun8i-ce/sun8i-ce.h b/drivers/crypto/allwinner/sun8i-ce/sun8i-ce.h
index 963645fe4adb..f5555c4800e8 100644
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
@@ -183,11 +179,17 @@ struct sun8i_ce_dev {
  * struct sun8i_cipher_req_ctx - context for a skcipher request
  * @op_dir:		direction (encrypt vs decrypt) for this request
  * @flow:		the flow to use for this request
+ * @backup_iv:		buffer which contain the next IV to store
+ * @bounce_iv:		buffer which contain the IV
+ * @ivlen:		size of bounce_iv
  * @fallback_req:	request struct for invoking the fallback skcipher TFM
  */
 struct sun8i_cipher_req_ctx {
 	u32 op_dir;
 	int flow;
+	void *backup_iv;
+	void *bounce_iv;
+	unsigned int ivlen;
 	struct skcipher_request fallback_req;   // keep at the end
 };
 
-- 
2.26.2

