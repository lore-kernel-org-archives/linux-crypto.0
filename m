Return-Path: <SRS0=veUY=7O=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7E366C433E1
	for <linux-crypto@archiver.kernel.org>; Mon,  1 Jun 2020 16:12:48 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 69D2E206C3
	for <linux-crypto@archiver.kernel.org>; Mon,  1 Jun 2020 16:12:48 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726128AbgFAQMq (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Mon, 1 Jun 2020 12:12:46 -0400
Received: from smtp01.tmcz.cz ([93.153.104.112]:37690 "EHLO smtp01.tmcz.cz"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726067AbgFAQMq (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 1 Jun 2020 12:12:46 -0400
Received: from smtp01.tmcz.cz (localhost [127.0.0.1])
        by sagator.hkvnode045 (Postfix) with ESMTP id D249C9401FF;
        Mon,  1 Jun 2020 18:04:22 +0200 (CEST)
X-Sagator-Scanner: 1.3.1-1 at hkvnode045;
        log(status(custom_action(quarantine(clamd()))),
        status(custom_action(quarantine(SpamAssassinD()))))
X-Sagator-ID: 20200601-180422-0001-94141-3Bfbin@hkvnode045
Received: from leontynka.twibright.com (109-183-129-149.customers.tmcz.cz [109.183.129.149])
        by smtp01.tmcz.cz (Postfix) with ESMTPS;
        Mon,  1 Jun 2020 18:04:22 +0200 (CEST)
Received: from debian-a64.vm ([192.168.208.2])
        by leontynka.twibright.com with smtp (Exim 4.92)
        (envelope-from <mpatocka@redhat.com>)
        id 1jfmvF-0001Vy-Gk; Mon, 01 Jun 2020 18:04:22 +0200
Received: by debian-a64.vm (sSMTP sendmail emulation); Mon, 01 Jun 2020 18:04:20 +0200
Message-Id: <20200601160420.666560920@debian-a64.vm>
User-Agent: quilt/0.65
Date:   Mon, 01 Jun 2020 18:03:35 +0200
From:   Mikulas Patocka <mpatocka@redhat.com>
To:     Mike Snitzer <msnitzer@redhat.com>,
        Giovanni Cabiddu <giovanni.cabiddu@intel.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>,
        Milan Broz <mbroz@redhat.com>, djeffery@redhat.com
Cc:     dm-devel@redhat.com, qat-linux@intel.com,
        linux-crypto@vger.kernel.org, guazhang@redhat.com,
        jpittman@redhat.com, Mikulas Patocka <mpatocka@redhat.com>
Subject: [PATCH 3/4] qat: use GFP_KERNEL allocations
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline; filename=qat-gfp-kernel.patch
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Use GFP_KERNEL when the flag CRYPTO_TFM_REQ_MAY_SLEEP is present.
Also, use GFP_KERNEL when setting a key.

Signed-off-by: Mikulas Patocka <mpatocka@redhat.com>
Cc: stable@vger.kernel.org

Index: linux-2.6/drivers/crypto/qat/qat_common/qat_algs.c
===================================================================
--- linux-2.6.orig/drivers/crypto/qat/qat_common/qat_algs.c
+++ linux-2.6/drivers/crypto/qat/qat_common/qat_algs.c
@@ -134,6 +134,11 @@ struct qat_alg_skcipher_ctx {
 	struct crypto_skcipher *tfm;
 };
 
+static int qat_gfp(u32 flags)
+{
+	return flags & CRYPTO_TFM_REQ_MAY_SLEEP ? GFP_KERNEL : GFP_ATOMIC;
+}
+
 static int qat_get_inter_state_size(enum icp_qat_hw_auth_algo qat_hash_alg)
 {
 	switch (qat_hash_alg) {
@@ -622,14 +627,14 @@ static int qat_alg_aead_newkey(struct cr
 	ctx->inst = inst;
 	ctx->enc_cd = dma_alloc_coherent(dev, sizeof(*ctx->enc_cd),
 					 &ctx->enc_cd_paddr,
-					 GFP_ATOMIC);
+					 GFP_KERNEL);
 	if (!ctx->enc_cd) {
 		ret = -ENOMEM;
 		goto out_free_inst;
 	}
 	ctx->dec_cd = dma_alloc_coherent(dev, sizeof(*ctx->dec_cd),
 					 &ctx->dec_cd_paddr,
-					 GFP_ATOMIC);
+					 GFP_KERNEL);
 	if (!ctx->dec_cd) {
 		ret = -ENOMEM;
 		goto out_free_enc;
@@ -704,7 +709,8 @@ static void qat_alg_free_bufl(struct qat
 static int qat_alg_sgl_to_bufl(struct qat_crypto_instance *inst,
 			       struct scatterlist *sgl,
 			       struct scatterlist *sglout,
-			       struct qat_crypto_request *qat_req)
+			       struct qat_crypto_request *qat_req,
+			       int gfp)
 {
 	struct device *dev = &GET_DEV(inst->accel_dev);
 	int i, sg_nctr = 0;
@@ -719,7 +725,7 @@ static int qat_alg_sgl_to_bufl(struct qa
 	if (unlikely(!n))
 		return -EINVAL;
 
-	bufl = kzalloc_node(sz, GFP_ATOMIC,
+	bufl = kzalloc_node(sz, gfp,
 			    dev_to_node(&GET_DEV(inst->accel_dev)));
 	if (unlikely(!bufl))
 		return -ENOMEM;
@@ -753,7 +759,7 @@ static int qat_alg_sgl_to_bufl(struct qa
 		n = sg_nents(sglout);
 		sz_out = struct_size(buflout, bufers, n + 1);
 		sg_nctr = 0;
-		buflout = kzalloc_node(sz_out, GFP_ATOMIC,
+		buflout = kzalloc_node(sz_out, gfp,
 				       dev_to_node(&GET_DEV(inst->accel_dev)));
 		if (unlikely(!buflout))
 			goto err_in;
@@ -876,7 +882,7 @@ static int qat_alg_aead_dec(struct aead_
 	int digst_size = crypto_aead_authsize(aead_tfm);
 	int ret, backed_off;
 
-	ret = qat_alg_sgl_to_bufl(ctx->inst, areq->src, areq->dst, qat_req);
+	ret = qat_alg_sgl_to_bufl(ctx->inst, areq->src, areq->dst, qat_req, qat_gfp(areq->base.flags));
 	if (unlikely(ret))
 		return ret;
 
@@ -919,7 +925,7 @@ static int qat_alg_aead_enc(struct aead_
 	uint8_t *iv = areq->iv;
 	int ret, backed_off;
 
-	ret = qat_alg_sgl_to_bufl(ctx->inst, areq->src, areq->dst, qat_req);
+	ret = qat_alg_sgl_to_bufl(ctx->inst, areq->src, areq->dst, qat_req, qat_gfp(areq->base.flags));
 	if (unlikely(ret))
 		return ret;
 
@@ -980,14 +986,14 @@ static int qat_alg_skcipher_newkey(struc
 	ctx->inst = inst;
 	ctx->enc_cd = dma_alloc_coherent(dev, sizeof(*ctx->enc_cd),
 					 &ctx->enc_cd_paddr,
-					 GFP_ATOMIC);
+					 GFP_KERNEL);
 	if (!ctx->enc_cd) {
 		ret = -ENOMEM;
 		goto out_free_instance;
 	}
 	ctx->dec_cd = dma_alloc_coherent(dev, sizeof(*ctx->dec_cd),
 					 &ctx->dec_cd_paddr,
-					 GFP_ATOMIC);
+					 GFP_KERNEL);
 	if (!ctx->dec_cd) {
 		ret = -ENOMEM;
 		goto out_free_enc;
@@ -1063,11 +1069,11 @@ static int qat_alg_skcipher_encrypt(stru
 		return 0;
 
 	qat_req->iv = dma_alloc_coherent(dev, AES_BLOCK_SIZE,
-					 &qat_req->iv_paddr, GFP_ATOMIC);
+					 &qat_req->iv_paddr, qat_gfp(req->base.flags));
 	if (!qat_req->iv)
 		return -ENOMEM;
 
-	ret = qat_alg_sgl_to_bufl(ctx->inst, req->src, req->dst, qat_req);
+	ret = qat_alg_sgl_to_bufl(ctx->inst, req->src, req->dst, qat_req, qat_gfp(req->base.flags));
 	if (unlikely(ret)) {
 		dma_free_coherent(dev, AES_BLOCK_SIZE, qat_req->iv,
 				  qat_req->iv_paddr);
@@ -1122,11 +1128,11 @@ static int qat_alg_skcipher_decrypt(stru
 		return 0;
 
 	qat_req->iv = dma_alloc_coherent(dev, AES_BLOCK_SIZE,
-					 &qat_req->iv_paddr, GFP_ATOMIC);
+					 &qat_req->iv_paddr, qat_gfp(req->base.flags));
 	if (!qat_req->iv)
 		return -ENOMEM;
 
-	ret = qat_alg_sgl_to_bufl(ctx->inst, req->src, req->dst, qat_req);
+	ret = qat_alg_sgl_to_bufl(ctx->inst, req->src, req->dst, qat_req, qat_gfp(req->base.flags));
 	if (unlikely(ret)) {
 		dma_free_coherent(dev, AES_BLOCK_SIZE, qat_req->iv,
 				  qat_req->iv_paddr);

