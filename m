Return-Path: <SRS0=mRc+=YG=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1FD28C4CECE
	for <linux-crypto@archiver.kernel.org>; Sun, 13 Oct 2019 04:40:35 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id E17F3206B7
	for <linux-crypto@archiver.kernel.org>; Sun, 13 Oct 2019 04:40:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1570941635;
	bh=W5Fp7YlbC0rhH0+OjHJyVT8XfABH4ToWxx4yYu1wDig=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:List-ID:From;
	b=fPIMzkoMjuMNPPtPMepQKxEVbD6mYIYJAlPrVykSqpbiNlnKe175oQThkeNAMNfQS
	 tQQcBai8RDjTMuBSFuqjCznjqNv40PRC1+IgLD67gjN3qdS6fc+br9ooraEO9Sc1YT
	 +Jo1wdV+sKSa/1DgFFm03FJHz3hHiQ1icW2K/tYQ=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726127AbfJMEke (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Sun, 13 Oct 2019 00:40:34 -0400
Received: from mail.kernel.org ([198.145.29.99]:51726 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727141AbfJMEkc (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Sun, 13 Oct 2019 00:40:32 -0400
Received: from sol.localdomain (c-24-5-143-220.hsd1.ca.comcast.net [24.5.143.220])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id AEA572085B;
        Sun, 13 Oct 2019 04:40:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1570941630;
        bh=W5Fp7YlbC0rhH0+OjHJyVT8XfABH4ToWxx4yYu1wDig=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=EvQnFSgmYkBCF8e8lDA49wOCVxHsF5/gEDrnAmx0CQdxMO8i9qIgaD7WRCKSqB3/x
         W/W9VA95Z/jrzki6G0hLny5aspsL4aiHMmkDMhw+yGiQwFbxNKPKUO6vZkyMK9R6e5
         zAnU9EC0lrdYrZECFFVUwncuHLpDi1Vhj149gIiA=
From:   Eric Biggers <ebiggers@kernel.org>
To:     linux-crypto@vger.kernel.org,
        Herbert Xu <herbert@gondor.apana.org.au>
Cc:     linuxppc-dev@lists.ozlabs.org,
        =?UTF-8?q?Breno=20Leit=C3=A3o?= <leitao@debian.org>,
        Nayna Jain <nayna@linux.ibm.com>,
        Paulo Flabiano Smorigo <pfsmorigo@gmail.com>
Subject: [PATCH 3/4] crypto: nx - convert AES-CBC to skcipher API
Date:   Sat, 12 Oct 2019 21:39:17 -0700
Message-Id: <20191013043918.337113-4-ebiggers@kernel.org>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20191013043918.337113-1-ebiggers@kernel.org>
References: <20191013043918.337113-1-ebiggers@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

From: Eric Biggers <ebiggers@google.com>

Convert the PowerPC Nest (NX) implementation of AES-CBC from the
deprecated "blkcipher" API to the "skcipher" API.  This is needed in
order for the blkcipher API to be removed.

Signed-off-by: Eric Biggers <ebiggers@google.com>
---
 drivers/crypto/nx/nx-aes-cbc.c | 78 ++++++++++++++--------------------
 drivers/crypto/nx/nx.c         | 11 ++---
 drivers/crypto/nx/nx.h         |  4 +-
 3 files changed, 41 insertions(+), 52 deletions(-)

diff --git a/drivers/crypto/nx/nx-aes-cbc.c b/drivers/crypto/nx/nx-aes-cbc.c
index 482a203a9260..92e921eceed7 100644
--- a/drivers/crypto/nx/nx-aes-cbc.c
+++ b/drivers/crypto/nx/nx-aes-cbc.c
@@ -18,11 +18,11 @@
 #include "nx.h"
 
 
-static int cbc_aes_nx_set_key(struct crypto_tfm *tfm,
-			      const u8          *in_key,
-			      unsigned int       key_len)
+static int cbc_aes_nx_set_key(struct crypto_skcipher *tfm,
+			      const u8               *in_key,
+			      unsigned int            key_len)
 {
-	struct nx_crypto_ctx *nx_ctx = crypto_tfm_ctx(tfm);
+	struct nx_crypto_ctx *nx_ctx = crypto_skcipher_ctx(tfm);
 	struct nx_csbcpb *csbcpb = nx_ctx->csbcpb;
 
 	nx_ctx_init(nx_ctx, HCOP_FC_AES);
@@ -50,13 +50,11 @@ static int cbc_aes_nx_set_key(struct crypto_tfm *tfm,
 	return 0;
 }
 
-static int cbc_aes_nx_crypt(struct blkcipher_desc *desc,
-			    struct scatterlist    *dst,
-			    struct scatterlist    *src,
-			    unsigned int           nbytes,
-			    int                    enc)
+static int cbc_aes_nx_crypt(struct skcipher_request *req,
+			    int                      enc)
 {
-	struct nx_crypto_ctx *nx_ctx = crypto_blkcipher_ctx(desc->tfm);
+	struct crypto_skcipher *tfm = crypto_skcipher_reqtfm(req);
+	struct nx_crypto_ctx *nx_ctx = crypto_skcipher_ctx(tfm);
 	struct nx_csbcpb *csbcpb = nx_ctx->csbcpb;
 	unsigned long irq_flags;
 	unsigned int processed = 0, to_process;
@@ -70,9 +68,9 @@ static int cbc_aes_nx_crypt(struct blkcipher_desc *desc,
 		NX_CPB_FDM(csbcpb) &= ~NX_FDM_ENDE_ENCRYPT;
 
 	do {
-		to_process = nbytes - processed;
+		to_process = req->cryptlen - processed;
 
-		rc = nx_build_sg_lists(nx_ctx, desc->info, dst, src,
+		rc = nx_build_sg_lists(nx_ctx, req->iv, req->dst, req->src,
 				       &to_process, processed,
 				       csbcpb->cpb.aes_cbc.iv);
 		if (rc)
@@ -84,56 +82,46 @@ static int cbc_aes_nx_crypt(struct blkcipher_desc *desc,
 		}
 
 		rc = nx_hcall_sync(nx_ctx, &nx_ctx->op,
-				   desc->flags & CRYPTO_TFM_REQ_MAY_SLEEP);
+				   req->base.flags & CRYPTO_TFM_REQ_MAY_SLEEP);
 		if (rc)
 			goto out;
 
-		memcpy(desc->info, csbcpb->cpb.aes_cbc.cv, AES_BLOCK_SIZE);
+		memcpy(req->iv, csbcpb->cpb.aes_cbc.cv, AES_BLOCK_SIZE);
 		atomic_inc(&(nx_ctx->stats->aes_ops));
 		atomic64_add(csbcpb->csb.processed_byte_count,
 			     &(nx_ctx->stats->aes_bytes));
 
 		processed += to_process;
-	} while (processed < nbytes);
+	} while (processed < req->cryptlen);
 out:
 	spin_unlock_irqrestore(&nx_ctx->lock, irq_flags);
 	return rc;
 }
 
-static int cbc_aes_nx_encrypt(struct blkcipher_desc *desc,
-			      struct scatterlist    *dst,
-			      struct scatterlist    *src,
-			      unsigned int           nbytes)
+static int cbc_aes_nx_encrypt(struct skcipher_request *req)
 {
-	return cbc_aes_nx_crypt(desc, dst, src, nbytes, 1);
+	return cbc_aes_nx_crypt(req, 1);
 }
 
-static int cbc_aes_nx_decrypt(struct blkcipher_desc *desc,
-			      struct scatterlist    *dst,
-			      struct scatterlist    *src,
-			      unsigned int           nbytes)
+static int cbc_aes_nx_decrypt(struct skcipher_request *req)
 {
-	return cbc_aes_nx_crypt(desc, dst, src, nbytes, 0);
+	return cbc_aes_nx_crypt(req, 0);
 }
 
-struct crypto_alg nx_cbc_aes_alg = {
-	.cra_name        = "cbc(aes)",
-	.cra_driver_name = "cbc-aes-nx",
-	.cra_priority    = 300,
-	.cra_flags       = CRYPTO_ALG_TYPE_BLKCIPHER,
-	.cra_blocksize   = AES_BLOCK_SIZE,
-	.cra_ctxsize     = sizeof(struct nx_crypto_ctx),
-	.cra_type        = &crypto_blkcipher_type,
-	.cra_alignmask   = 0xf,
-	.cra_module      = THIS_MODULE,
-	.cra_init        = nx_crypto_ctx_aes_cbc_init,
-	.cra_exit        = nx_crypto_ctx_exit,
-	.cra_blkcipher = {
-		.min_keysize = AES_MIN_KEY_SIZE,
-		.max_keysize = AES_MAX_KEY_SIZE,
-		.ivsize      = AES_BLOCK_SIZE,
-		.setkey      = cbc_aes_nx_set_key,
-		.encrypt     = cbc_aes_nx_encrypt,
-		.decrypt     = cbc_aes_nx_decrypt,
-	}
+struct skcipher_alg nx_cbc_aes_alg = {
+	.base.cra_name		= "cbc(aes)",
+	.base.cra_driver_name	= "cbc-aes-nx",
+	.base.cra_priority	= 300,
+	.base.cra_blocksize	= AES_BLOCK_SIZE,
+	.base.cra_ctxsize	= sizeof(struct nx_crypto_ctx),
+	.base.cra_alignmask	= 0xf,
+	.base.cra_module	= THIS_MODULE,
+	.init			= nx_crypto_ctx_aes_cbc_init,
+	.exit			= nx_crypto_ctx_skcipher_exit,
+	.min_keysize		= AES_MIN_KEY_SIZE,
+	.max_keysize		= AES_MAX_KEY_SIZE,
+	.ivsize			= AES_BLOCK_SIZE,
+	.setkey			= cbc_aes_nx_set_key,
+	.encrypt		= cbc_aes_nx_encrypt,
+	.decrypt		= cbc_aes_nx_decrypt,
 };
diff --git a/drivers/crypto/nx/nx.c b/drivers/crypto/nx/nx.c
index 4b97081e7486..8e5367776ca0 100644
--- a/drivers/crypto/nx/nx.c
+++ b/drivers/crypto/nx/nx.c
@@ -589,7 +589,7 @@ static int nx_register_algs(void)
 	if (rc)
 		goto out;
 
-	rc = nx_register_alg(&nx_cbc_aes_alg, NX_FC_AES, NX_MODE_AES_CBC);
+	rc = nx_register_skcipher(&nx_cbc_aes_alg, NX_FC_AES, NX_MODE_AES_CBC);
 	if (rc)
 		goto out_unreg_ecb;
 
@@ -647,7 +647,7 @@ static int nx_register_algs(void)
 out_unreg_ctr3686:
 	nx_unregister_alg(&nx_ctr3686_aes_alg, NX_FC_AES, NX_MODE_AES_CTR);
 out_unreg_cbc:
-	nx_unregister_alg(&nx_cbc_aes_alg, NX_FC_AES, NX_MODE_AES_CBC);
+	nx_unregister_skcipher(&nx_cbc_aes_alg, NX_FC_AES, NX_MODE_AES_CBC);
 out_unreg_ecb:
 	nx_unregister_skcipher(&nx_ecb_aes_alg, NX_FC_AES, NX_MODE_AES_ECB);
 out:
@@ -722,9 +722,9 @@ int nx_crypto_ctx_aes_ctr_init(struct crypto_tfm *tfm)
 				  NX_MODE_AES_CTR);
 }
 
-int nx_crypto_ctx_aes_cbc_init(struct crypto_tfm *tfm)
+int nx_crypto_ctx_aes_cbc_init(struct crypto_skcipher *tfm)
 {
-	return nx_crypto_ctx_init(crypto_tfm_ctx(tfm), NX_FC_AES,
+	return nx_crypto_ctx_init(crypto_skcipher_ctx(tfm), NX_FC_AES,
 				  NX_MODE_AES_CBC);
 }
 
@@ -817,7 +817,8 @@ static int nx_remove(struct vio_dev *viodev)
 				   NX_FC_AES, NX_MODE_AES_GCM);
 		nx_unregister_alg(&nx_ctr3686_aes_alg,
 				  NX_FC_AES, NX_MODE_AES_CTR);
-		nx_unregister_alg(&nx_cbc_aes_alg, NX_FC_AES, NX_MODE_AES_CBC);
+		nx_unregister_skcipher(&nx_cbc_aes_alg, NX_FC_AES,
+				       NX_MODE_AES_CBC);
 		nx_unregister_skcipher(&nx_ecb_aes_alg, NX_FC_AES,
 				       NX_MODE_AES_ECB);
 	}
diff --git a/drivers/crypto/nx/nx.h b/drivers/crypto/nx/nx.h
index 1a839ef21c4f..2e1a3e5e65cb 100644
--- a/drivers/crypto/nx/nx.h
+++ b/drivers/crypto/nx/nx.h
@@ -146,7 +146,7 @@ int nx_crypto_ctx_aes_ccm_init(struct crypto_aead *tfm);
 int nx_crypto_ctx_aes_gcm_init(struct crypto_aead *tfm);
 int nx_crypto_ctx_aes_xcbc_init(struct crypto_tfm *tfm);
 int nx_crypto_ctx_aes_ctr_init(struct crypto_tfm *tfm);
-int nx_crypto_ctx_aes_cbc_init(struct crypto_tfm *tfm);
+int nx_crypto_ctx_aes_cbc_init(struct crypto_skcipher *tfm);
 int nx_crypto_ctx_aes_ecb_init(struct crypto_skcipher *tfm);
 int nx_crypto_ctx_sha_init(struct crypto_tfm *tfm);
 void nx_crypto_ctx_exit(struct crypto_tfm *tfm);
@@ -176,7 +176,7 @@ void nx_debugfs_fini(struct nx_crypto_driver *);
 
 #define NX_PAGE_NUM(x)		((u64)(x) & 0xfffffffffffff000ULL)
 
-extern struct crypto_alg nx_cbc_aes_alg;
+extern struct skcipher_alg nx_cbc_aes_alg;
 extern struct skcipher_alg nx_ecb_aes_alg;
 extern struct aead_alg nx_gcm_aes_alg;
 extern struct aead_alg nx_gcm4106_aes_alg;
-- 
2.23.0

