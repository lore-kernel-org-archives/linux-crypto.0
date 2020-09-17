Return-Path: <SRS0=yTfj=C2=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B710EC433E2
	for <linux-crypto@archiver.kernel.org>; Thu, 17 Sep 2020 18:37:29 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 645E721973
	for <linux-crypto@archiver.kernel.org>; Thu, 17 Sep 2020 18:37:29 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=baylibre-com.20150623.gappssmtp.com header.i=@baylibre-com.20150623.gappssmtp.com header.b="JpjCYv5u"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726483AbgIQSgp (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 17 Sep 2020 14:36:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41106 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726640AbgIQSgN (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 17 Sep 2020 14:36:13 -0400
Received: from mail-wr1-x441.google.com (mail-wr1-x441.google.com [IPv6:2a00:1450:4864:20::441])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3CFE5C061756
        for <linux-crypto@vger.kernel.org>; Thu, 17 Sep 2020 11:36:12 -0700 (PDT)
Received: by mail-wr1-x441.google.com with SMTP id k15so3105442wrn.10
        for <linux-crypto@vger.kernel.org>; Thu, 17 Sep 2020 11:36:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=baylibre-com.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=huiz4hWuEDAzBaczeTBJaesBVDz4VU4ls/AvOgJWeOk=;
        b=JpjCYv5upp6XL8vZw/alieu2cpaOwfleOy/rzX2ojjNYlwSuBLG2jlL+2+UQAk3mmW
         3RfiYgv/kFFoG5lvbTqzYR7dY+MluotdcWjF7R3w9c7ozyM/dT0nt1blyP8CO3TpOa70
         YyeoWH8e58UflQPQN7VnSizaeKpooddmUBw9cyMgRv8FYllSdvtaXEPjBrL7rv4dWnun
         f7exonzOVT/cBza580v3FOwbMcsktLa7oH+dRP3FPi4TKZhKxpyL+3vPJjHI2xzSD6f5
         +YK+k97R2D7oMjJprQDPx5Jim0oq1XgwUTSlJAfX7bzURWSOTisdaEHtzm6HnJYb4uzR
         6ing==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=huiz4hWuEDAzBaczeTBJaesBVDz4VU4ls/AvOgJWeOk=;
        b=q+WIXl2NT89B0A5m+BM7qMsqYz7GQ6YycbzxIsmTX2neDc9TH1Dkp8lONo4YNjX9gu
         ZDgcOxxs+f6f7o/y8lLYdez9lBkSNITQHMgP3UUNbPTBKy355OzVLbS9fUe8/0Sd/9Fp
         rErb+2pteOvbAowg2dOjP5K9ghLdUwSnh0+aY3GrG8Og475JfZq5rmZ0j7XFRozzIc96
         DGzayoHsvJ/gMcfH0CrHFyaKWfP8mq5B/e7BleLMj/GzR2JPBbbsI6UvR6kGp/7Q8Uxo
         PyB7baRDZ9JFxJJhNReegsgwRL0TpQuVD9sIOOWINq5cO90LxdwpEgMGbpYZV0EzYOVW
         ixDg==
X-Gm-Message-State: AOAM531Sq6/4LMTGh14tmhaT7IDQfxgxuBOvF3i7bXb1ZfHTCtKNAsI8
        CB2WS/rmMtsWZC6wsf4JEFNrBOYqQ2XH2A==
X-Google-Smtp-Source: ABdhPJwEutMPermMhwz6o/ZA8isTCX7M2dtJokNUsR8uKvWZb3baKmYr/Mdbwerfm2Ba1S7xHFnLLQ==
X-Received: by 2002:adf:a3d4:: with SMTP id m20mr30378089wrb.29.1600367770621;
        Thu, 17 Sep 2020 11:36:10 -0700 (PDT)
Received: from localhost.localdomain ([51.15.160.169])
        by smtp.googlemail.com with ESMTPSA id x16sm571901wrq.62.2020.09.17.11.36.09
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 17 Sep 2020 11:36:10 -0700 (PDT)
From:   Corentin Labbe <clabbe@baylibre.com>
To:     arnd@arndb.de, davem@davemloft.net, herbert@gondor.apana.org.au,
        mripard@kernel.org, wens@csie.org
Cc:     linux-arm-kernel@lists.infradead.org, linux-crypto@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-sunxi@googlegroups.com,
        Corentin Labbe <clabbe@baylibre.com>, stable@vger.kernel.org
Subject: [PATCH 3/7] crypto: sun4i-ss: IV register does not work on A10 and A13
Date:   Thu, 17 Sep 2020 18:35:54 +0000
Message-Id: <1600367758-28589-4-git-send-email-clabbe@baylibre.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1600367758-28589-1-git-send-email-clabbe@baylibre.com>
References: <1600367758-28589-1-git-send-email-clabbe@baylibre.com>
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Allwinner A10 and A13 SoC have a version of the SS which produce
invalid IV in IVx register.

Instead of adding a variant for those, let's convert SS to produce IV
directly from data.
Fixes: 6298e948215f2 ("crypto: sunxi-ss - Add Allwinner Security System crypto accelerator")
Cc: <stable@vger.kernel.org>
Signed-off-by: Corentin Labbe <clabbe@baylibre.com>
---
 .../allwinner/sun4i-ss/sun4i-ss-cipher.c      | 34 +++++++++++++++----
 1 file changed, 28 insertions(+), 6 deletions(-)

diff --git a/drivers/crypto/allwinner/sun4i-ss/sun4i-ss-cipher.c b/drivers/crypto/allwinner/sun4i-ss/sun4i-ss-cipher.c
index 2614640231dc..c6c25204780d 100644
--- a/drivers/crypto/allwinner/sun4i-ss/sun4i-ss-cipher.c
+++ b/drivers/crypto/allwinner/sun4i-ss/sun4i-ss-cipher.c
@@ -20,6 +20,7 @@ static int noinline_for_stack sun4i_ss_opti_poll(struct skcipher_request *areq)
 	unsigned int ivsize = crypto_skcipher_ivsize(tfm);
 	struct sun4i_cipher_req_ctx *ctx = skcipher_request_ctx(areq);
 	u32 mode = ctx->mode;
+	void *backup_iv = NULL;
 	/* when activating SS, the default FIFO space is SS_RX_DEFAULT(32) */
 	u32 rx_cnt = SS_RX_DEFAULT;
 	u32 tx_cnt = 0;
@@ -42,6 +43,13 @@ static int noinline_for_stack sun4i_ss_opti_poll(struct skcipher_request *areq)
 		return -EINVAL;
 	}
 
+	if (areq->iv && ivsize > 0 && mode & SS_DECRYPTION) {
+		backup_iv = kzalloc(ivsize, GFP_KERNEL);
+		if (!backup_iv)
+			return -ENOMEM;
+		scatterwalk_map_and_copy(backup_iv, areq->src, areq->cryptlen - ivsize, ivsize, 0);
+	}
+
 	spin_lock_irqsave(&ss->slock, flags);
 
 	for (i = 0; i < op->keylen; i += 4)
@@ -102,9 +110,12 @@ static int noinline_for_stack sun4i_ss_opti_poll(struct skcipher_request *areq)
 	} while (oleft);
 
 	if (areq->iv) {
-		for (i = 0; i < 4 && i < ivsize / 4; i++) {
-			v = readl(ss->base + SS_IV0 + i * 4);
-			*(u32 *)(areq->iv + i * 4) = v;
+		if (mode & SS_DECRYPTION) {
+			memcpy(areq->iv, backup_iv, ivsize);
+			kfree_sensitive(backup_iv);
+		} else {
+			scatterwalk_map_and_copy(areq->iv, areq->dst, areq->cryptlen - ivsize,
+						 ivsize, 0);
 		}
 	}
 
@@ -161,6 +172,7 @@ static int sun4i_ss_cipher_poll(struct skcipher_request *areq)
 	unsigned int ileft = areq->cryptlen;
 	unsigned int oleft = areq->cryptlen;
 	unsigned int todo;
+	void *backup_iv = NULL;
 	struct sg_mapping_iter mi, mo;
 	unsigned int oi, oo;	/* offset for in and out */
 	char buf[4 * SS_RX_MAX];/* buffer for linearize SG src */
@@ -204,6 +216,13 @@ static int sun4i_ss_cipher_poll(struct skcipher_request *areq)
 	if (need_fallback)
 		return sun4i_ss_cipher_poll_fallback(areq);
 
+	if (areq->iv && ivsize > 0 && mode & SS_DECRYPTION) {
+		backup_iv = kzalloc(ivsize, GFP_KERNEL);
+		if (!backup_iv)
+			return -ENOMEM;
+		scatterwalk_map_and_copy(backup_iv, areq->src, areq->cryptlen - ivsize, ivsize, 0);
+	}
+
 	spin_lock_irqsave(&ss->slock, flags);
 
 	for (i = 0; i < op->keylen; i += 4)
@@ -324,9 +343,12 @@ static int sun4i_ss_cipher_poll(struct skcipher_request *areq)
 		}
 	}
 	if (areq->iv) {
-		for (i = 0; i < 4 && i < ivsize / 4; i++) {
-			v = readl(ss->base + SS_IV0 + i * 4);
-			*(u32 *)(areq->iv + i * 4) = v;
+		if (mode & SS_DECRYPTION) {
+			memcpy(areq->iv, backup_iv, ivsize);
+			kfree_sensitive(backup_iv);
+		} else {
+			scatterwalk_map_and_copy(areq->iv, areq->dst, areq->cryptlen - ivsize,
+						 ivsize, 0);
 		}
 	}
 
-- 
2.26.2

