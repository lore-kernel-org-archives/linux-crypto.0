Return-Path: <SRS0=gV+R=BS=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.1 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 54889C433E3
	for <linux-crypto@archiver.kernel.org>; Sat,  8 Aug 2020 23:51:09 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 3337B206B5
	for <linux-crypto@archiver.kernel.org>; Sat,  8 Aug 2020 23:51:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1596930669;
	bh=+sEfMOMLHGs7h/0AYlLu4SUxfOejMe/f4lp3oYV0P3c=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:List-ID:From;
	b=A3jSWKV+t96KA1xuPRmANLpx+7BFh7XKMB8NkfYgoZg6X0VWBOL1VzICmWzGZ/tAR
	 BIuc+63aQZg7pQmDddo403CWRGGvJonHkCzBqtxIDzZfBxlWYZquBlG8FyspGjzBv9
	 O18Pi/dRqLMRjS8CoTWceKqEQ3f2pqqBThekh/Mk=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727888AbgHHXvI (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Sat, 8 Aug 2020 19:51:08 -0400
Received: from mail.kernel.org ([198.145.29.99]:48484 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726645AbgHHXgJ (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Sat, 8 Aug 2020 19:36:09 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 59F18206E9;
        Sat,  8 Aug 2020 23:36:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1596929768;
        bh=+sEfMOMLHGs7h/0AYlLu4SUxfOejMe/f4lp3oYV0P3c=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=BwzA0et6Vs7u75DpsIZ7qpX3KzlPorp1LtoTyyffkclBIv1Ihxxeiv9DzlvHkbEQX
         VzxhpSXmTKYL9OSQ+f1pVO/7K+YBewK+W4oaOMbNLQ1lqffGy4rw4MnW+UBJJfDl2D
         Ru5Q4g9ocYczkPMtomYvlXd/NFpec/Dm1V9NJv2w=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Gilad Ben-Yossef <gilad@benyossef.com>,
        Markus Elfring <Markus.Elfring@web.de>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Sasha Levin <sashal@kernel.org>, linux-crypto@vger.kernel.org
Subject: [PATCH AUTOSEL 5.8 19/72] crypto: ccree - fix resource leak on error path
Date:   Sat,  8 Aug 2020 19:34:48 -0400
Message-Id: <20200808233542.3617339-19-sashal@kernel.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200808233542.3617339-1-sashal@kernel.org>
References: <20200808233542.3617339-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

From: Gilad Ben-Yossef <gilad@benyossef.com>

[ Upstream commit 9bc6165d608d676f05d8bf156a2c9923ee38d05b ]

Fix a small resource leak on the error path of cipher processing.

Signed-off-by: Gilad Ben-Yossef <gilad@benyossef.com>
Fixes: 63ee04c8b491e ("crypto: ccree - add skcipher support")
Cc: Markus Elfring <Markus.Elfring@web.de>
Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/crypto/ccree/cc_cipher.c | 30 ++++++++++++++++++------------
 1 file changed, 18 insertions(+), 12 deletions(-)

diff --git a/drivers/crypto/ccree/cc_cipher.c b/drivers/crypto/ccree/cc_cipher.c
index 872ea3ff1c6ba..f144fe04748b0 100644
--- a/drivers/crypto/ccree/cc_cipher.c
+++ b/drivers/crypto/ccree/cc_cipher.c
@@ -159,7 +159,6 @@ static int cc_cipher_init(struct crypto_tfm *tfm)
 				     skcipher_alg.base);
 	struct device *dev = drvdata_to_dev(cc_alg->drvdata);
 	unsigned int max_key_buf_size = cc_alg->skcipher_alg.max_keysize;
-	int rc = 0;
 
 	dev_dbg(dev, "Initializing context @%p for %s\n", ctx_p,
 		crypto_tfm_alg_name(tfm));
@@ -171,10 +170,19 @@ static int cc_cipher_init(struct crypto_tfm *tfm)
 	ctx_p->flow_mode = cc_alg->flow_mode;
 	ctx_p->drvdata = cc_alg->drvdata;
 
+	if (ctx_p->cipher_mode == DRV_CIPHER_ESSIV) {
+		/* Alloc hash tfm for essiv */
+		ctx_p->shash_tfm = crypto_alloc_shash("sha256-generic", 0, 0);
+		if (IS_ERR(ctx_p->shash_tfm)) {
+			dev_err(dev, "Error allocating hash tfm for ESSIV.\n");
+			return PTR_ERR(ctx_p->shash_tfm);
+		}
+	}
+
 	/* Allocate key buffer, cache line aligned */
 	ctx_p->user.key = kmalloc(max_key_buf_size, GFP_KERNEL);
 	if (!ctx_p->user.key)
-		return -ENOMEM;
+		goto free_shash;
 
 	dev_dbg(dev, "Allocated key buffer in context. key=@%p\n",
 		ctx_p->user.key);
@@ -186,21 +194,19 @@ static int cc_cipher_init(struct crypto_tfm *tfm)
 	if (dma_mapping_error(dev, ctx_p->user.key_dma_addr)) {
 		dev_err(dev, "Mapping Key %u B at va=%pK for DMA failed\n",
 			max_key_buf_size, ctx_p->user.key);
-		return -ENOMEM;
+		goto free_key;
 	}
 	dev_dbg(dev, "Mapped key %u B at va=%pK to dma=%pad\n",
 		max_key_buf_size, ctx_p->user.key, &ctx_p->user.key_dma_addr);
 
-	if (ctx_p->cipher_mode == DRV_CIPHER_ESSIV) {
-		/* Alloc hash tfm for essiv */
-		ctx_p->shash_tfm = crypto_alloc_shash("sha256-generic", 0, 0);
-		if (IS_ERR(ctx_p->shash_tfm)) {
-			dev_err(dev, "Error allocating hash tfm for ESSIV.\n");
-			return PTR_ERR(ctx_p->shash_tfm);
-		}
-	}
+	return 0;
 
-	return rc;
+free_key:
+	kfree(ctx_p->user.key);
+free_shash:
+	crypto_free_shash(ctx_p->shash_tfm);
+
+	return -ENOMEM;
 }
 
 static void cc_cipher_exit(struct crypto_tfm *tfm)
-- 
2.25.1

