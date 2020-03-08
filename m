Return-Path: <SRS0=hwJD=4Z=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8A31DC10F28
	for <linux-crypto@archiver.kernel.org>; Sun,  8 Mar 2020 15:57:47 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 698E5208CD
	for <linux-crypto@archiver.kernel.org>; Sun,  8 Mar 2020 15:57:47 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726270AbgCHP5c (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Sun, 8 Mar 2020 11:57:32 -0400
Received: from foss.arm.com ([217.140.110.172]:45758 "EHLO foss.arm.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726330AbgCHP5a (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Sun, 8 Mar 2020 11:57:30 -0400
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id C32111FB;
        Sun,  8 Mar 2020 08:57:29 -0700 (PDT)
Received: from e110176-lin.kfn.arm.com (unknown [172.31.20.19])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 8B36B3F6CF;
        Sun,  8 Mar 2020 08:57:28 -0700 (PDT)
From:   Gilad Ben-Yossef <gilad@benyossef.com>
To:     Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>
Cc:     Ofir Drang <ofir.drang@arm.com>, linux-crypto@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH 3/6] crypto: ccree - remove ancient TODO remarks
Date:   Sun,  8 Mar 2020 17:57:06 +0200
Message-Id: <20200308155710.14546-4-gilad@benyossef.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200308155710.14546-1-gilad@benyossef.com>
References: <20200308155710.14546-1-gilad@benyossef.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Remove left over ancient and now misleading TODO remarks.

Signed-off-by: Gilad Ben-Yossef <gilad@benyossef.com>
---
 drivers/crypto/ccree/cc_aead.c        | 1 -
 drivers/crypto/ccree/cc_buffer_mgr.c  | 2 --
 drivers/crypto/ccree/cc_cipher.c      | 1 -
 drivers/crypto/ccree/cc_hash.c        | 3 ---
 drivers/crypto/ccree/cc_request_mgr.c | 1 -
 5 files changed, 8 deletions(-)

diff --git a/drivers/crypto/ccree/cc_aead.c b/drivers/crypto/ccree/cc_aead.c
index 904aa66752b3..1c5d927d632c 100644
--- a/drivers/crypto/ccree/cc_aead.c
+++ b/drivers/crypto/ccree/cc_aead.c
@@ -1990,7 +1990,6 @@ static int cc_proc_aead(struct aead_request *req,
 	/* Load MLLI tables to SRAM if necessary */
 	cc_mlli_to_sram(req, desc, &seq_len);
 
-	/*TODO: move seq len by reference */
 	switch (ctx->auth_mode) {
 	case DRV_HASH_SHA1:
 	case DRV_HASH_SHA256:
diff --git a/drivers/crypto/ccree/cc_buffer_mgr.c b/drivers/crypto/ccree/cc_buffer_mgr.c
index 1ea4812e9354..526da532a0a3 100644
--- a/drivers/crypto/ccree/cc_buffer_mgr.c
+++ b/drivers/crypto/ccree/cc_buffer_mgr.c
@@ -606,7 +606,6 @@ static int cc_aead_chain_iv(struct cc_drvdata *drvdata,
 
 	dev_dbg(dev, "Mapped iv %u B at va=%pK to dma=%pad\n",
 		hw_iv_size, req->iv, &areq_ctx->gen_ctx.iv_dma_addr);
-	// TODO: what about CTR?? ask Ron
 	if (do_chain && areq_ctx->plaintext_authenticate_only) {
 		struct crypto_aead *tfm = crypto_aead_reqtfm(req);
 		unsigned int iv_size_to_authenc = crypto_aead_ivsize(tfm);
@@ -1225,7 +1224,6 @@ int cc_map_hash_request_final(struct cc_drvdata *drvdata, void *ctx,
 		return 0;
 	}
 
-	/*TODO: copy data in case that buffer is enough for operation */
 	/* map the previous buffer */
 	if (*curr_buff_cnt) {
 		rc = cc_set_hash_buf(dev, areq_ctx, curr_buff, *curr_buff_cnt,
diff --git a/drivers/crypto/ccree/cc_cipher.c b/drivers/crypto/ccree/cc_cipher.c
index d8e6a103a637..a84335328f37 100644
--- a/drivers/crypto/ccree/cc_cipher.c
+++ b/drivers/crypto/ccree/cc_cipher.c
@@ -859,7 +859,6 @@ static int cc_cipher_process(struct skcipher_request *req,
 
 	/* STAT_PHASE_0: Init and sanity checks */
 
-	/* TODO: check data length according to mode */
 	if (validate_data_size(ctx_p, nbytes)) {
 		dev_dbg(dev, "Unsupported data size %d.\n", nbytes);
 		rc = -EINVAL;
diff --git a/drivers/crypto/ccree/cc_hash.c b/drivers/crypto/ccree/cc_hash.c
index 0c32aa2e6801..d5310783af15 100644
--- a/drivers/crypto/ccree/cc_hash.c
+++ b/drivers/crypto/ccree/cc_hash.c
@@ -349,7 +349,6 @@ static int cc_fin_result(struct cc_hw_desc *desc, struct ahash_request *req,
 	/* Get final MAC result */
 	hw_desc_init(&desc[idx]);
 	set_hash_cipher_mode(&desc[idx], ctx->hw_mode, ctx->hash_mode);
-	/* TODO */
 	set_dout_dlli(&desc[idx], state->digest_result_dma_addr, digestsize,
 		      NS_BIT, 1);
 	set_queue_last_ind(ctx->drvdata, &desc[idx]);
@@ -1319,7 +1318,6 @@ static int cc_mac_final(struct ahash_request *req)
 
 	/* Get final MAC result */
 	hw_desc_init(&desc[idx]);
-	/* TODO */
 	set_dout_dlli(&desc[idx], state->digest_result_dma_addr,
 		      digestsize, NS_BIT, 1);
 	set_queue_last_ind(ctx->drvdata, &desc[idx]);
@@ -1401,7 +1399,6 @@ static int cc_mac_finup(struct ahash_request *req)
 
 	/* Get final MAC result */
 	hw_desc_init(&desc[idx]);
-	/* TODO */
 	set_dout_dlli(&desc[idx], state->digest_result_dma_addr,
 		      digestsize, NS_BIT, 1);
 	set_queue_last_ind(ctx->drvdata, &desc[idx]);
diff --git a/drivers/crypto/ccree/cc_request_mgr.c b/drivers/crypto/ccree/cc_request_mgr.c
index 2671cffb3b58..1d7649ecf44e 100644
--- a/drivers/crypto/ccree/cc_request_mgr.c
+++ b/drivers/crypto/ccree/cc_request_mgr.c
@@ -296,7 +296,6 @@ static void cc_do_send_request(struct cc_drvdata *drvdata,
 	req_mgr_h->req_queue[req_mgr_h->req_queue_head] = *cc_req;
 	req_mgr_h->req_queue_head = (req_mgr_h->req_queue_head + 1) &
 				    (MAX_REQUEST_QUEUE_SIZE - 1);
-	/* TODO: Use circ_buf.h ? */
 
 	dev_dbg(dev, "Enqueue request head=%u\n", req_mgr_h->req_queue_head);
 
-- 
2.25.1

