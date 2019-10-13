Return-Path: <SRS0=mRc+=YG=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 43BA3C4360C
	for <linux-crypto@archiver.kernel.org>; Sun, 13 Oct 2019 04:40:35 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 1D382207FF
	for <linux-crypto@archiver.kernel.org>; Sun, 13 Oct 2019 04:40:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1570941635;
	bh=iZG7Gnbw2qUdkWy1v/vH8dVeIQZnN6PwmAd99agXqxY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:List-ID:From;
	b=lyGC76MppaF+Er7RSWcgPG/dzrBz1reppOpYwAtUiNuQd74UEdOddcaO9qIw9vWgu
	 BjhqUoB/W3uxuEIxKRJku5epuwBvJn3HFa+2QmaAohX0q/UDN5uFGKUiyVtrj6C6fR
	 BKlGByOQ7aWmgNBgs1PlCmNkidRw5MTtr+3GZNc8=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727141AbfJMEke (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Sun, 13 Oct 2019 00:40:34 -0400
Received: from mail.kernel.org ([198.145.29.99]:51712 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726085AbfJMEkc (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Sun, 13 Oct 2019 00:40:32 -0400
Received: from sol.localdomain (c-24-5-143-220.hsd1.ca.comcast.net [24.5.143.220])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 5CDB52082F;
        Sun, 13 Oct 2019 04:40:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1570941630;
        bh=iZG7Gnbw2qUdkWy1v/vH8dVeIQZnN6PwmAd99agXqxY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=RGAZKRvme0NJbcNUejHTswqSwJonAUVvQkrCQ6l+S67QjYqqgh3tYzOwjm0uD+3/K
         k4XlVR1D8iVngJXfFN/H8/sIw27cqo1gNt3G2tHN+2MLqNPwBx1BJ/v9WhXwe3zywG
         oXlArqWTQcOxgeK5iVHhk5zoFzM4il0zPhquvwO4=
From:   Eric Biggers <ebiggers@kernel.org>
To:     linux-crypto@vger.kernel.org,
        Herbert Xu <herbert@gondor.apana.org.au>
Cc:     linuxppc-dev@lists.ozlabs.org,
        =?UTF-8?q?Breno=20Leit=C3=A3o?= <leitao@debian.org>,
        Nayna Jain <nayna@linux.ibm.com>,
        Paulo Flabiano Smorigo <pfsmorigo@gmail.com>
Subject: [PATCH 2/4] crypto: nx - convert AES-ECB to skcipher API
Date:   Sat, 12 Oct 2019 21:39:16 -0700
Message-Id: <20191013043918.337113-3-ebiggers@kernel.org>
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

Convert the PowerPC Nest (NX) implementation of AES-ECB from the
deprecated "blkcipher" API to the "skcipher" API.  This is needed in
order for the blkcipher API to be removed.

Signed-off-by: Eric Biggers <ebiggers@google.com>
---
 drivers/crypto/nx/nx-aes-ecb.c | 76 ++++++++++++++--------------------
 drivers/crypto/nx/nx.c         | 28 ++++++++++---
 drivers/crypto/nx/nx.h         |  5 ++-
 3 files changed, 58 insertions(+), 51 deletions(-)

diff --git a/drivers/crypto/nx/nx-aes-ecb.c b/drivers/crypto/nx/nx-aes-ecb.c
index 87183890d1ab..77e338dc33f1 100644
--- a/drivers/crypto/nx/nx-aes-ecb.c
+++ b/drivers/crypto/nx/nx-aes-ecb.c
@@ -18,11 +18,11 @@
 #include "nx.h"
 
 
-static int ecb_aes_nx_set_key(struct crypto_tfm *tfm,
-			      const u8          *in_key,
-			      unsigned int       key_len)
+static int ecb_aes_nx_set_key(struct crypto_skcipher *tfm,
+			      const u8               *in_key,
+			      unsigned int            key_len)
 {
-	struct nx_crypto_ctx *nx_ctx = crypto_tfm_ctx(tfm);
+	struct nx_crypto_ctx *nx_ctx = crypto_skcipher_ctx(tfm);
 	struct nx_csbcpb *csbcpb = (struct nx_csbcpb *)nx_ctx->csbcpb;
 
 	nx_ctx_init(nx_ctx, HCOP_FC_AES);
@@ -50,13 +50,11 @@ static int ecb_aes_nx_set_key(struct crypto_tfm *tfm,
 	return 0;
 }
 
-static int ecb_aes_nx_crypt(struct blkcipher_desc *desc,
-			    struct scatterlist    *dst,
-			    struct scatterlist    *src,
-			    unsigned int           nbytes,
-			    int                    enc)
+static int ecb_aes_nx_crypt(struct skcipher_request *req,
+			    int                      enc)
 {
-	struct nx_crypto_ctx *nx_ctx = crypto_blkcipher_ctx(desc->tfm);
+	struct crypto_skcipher *tfm = crypto_skcipher_reqtfm(req);
+	struct nx_crypto_ctx *nx_ctx = crypto_skcipher_ctx(tfm);
 	struct nx_csbcpb *csbcpb = nx_ctx->csbcpb;
 	unsigned long irq_flags;
 	unsigned int processed = 0, to_process;
@@ -70,10 +68,10 @@ static int ecb_aes_nx_crypt(struct blkcipher_desc *desc,
 		NX_CPB_FDM(csbcpb) &= ~NX_FDM_ENDE_ENCRYPT;
 
 	do {
-		to_process = nbytes - processed;
+		to_process = req->cryptlen - processed;
 
-		rc = nx_build_sg_lists(nx_ctx, NULL, dst, src, &to_process,
-				       processed, NULL);
+		rc = nx_build_sg_lists(nx_ctx, NULL, req->dst, req->src,
+				       &to_process, processed, NULL);
 		if (rc)
 			goto out;
 
@@ -83,7 +81,7 @@ static int ecb_aes_nx_crypt(struct blkcipher_desc *desc,
 		}
 
 		rc = nx_hcall_sync(nx_ctx, &nx_ctx->op,
-				   desc->flags & CRYPTO_TFM_REQ_MAY_SLEEP);
+				   req->base.flags & CRYPTO_TFM_REQ_MAY_SLEEP);
 		if (rc)
 			goto out;
 
@@ -92,46 +90,36 @@ static int ecb_aes_nx_crypt(struct blkcipher_desc *desc,
 			     &(nx_ctx->stats->aes_bytes));
 
 		processed += to_process;
-	} while (processed < nbytes);
+	} while (processed < req->cryptlen);
 
 out:
 	spin_unlock_irqrestore(&nx_ctx->lock, irq_flags);
 	return rc;
 }
 
-static int ecb_aes_nx_encrypt(struct blkcipher_desc *desc,
-			      struct scatterlist    *dst,
-			      struct scatterlist    *src,
-			      unsigned int           nbytes)
+static int ecb_aes_nx_encrypt(struct skcipher_request *req)
 {
-	return ecb_aes_nx_crypt(desc, dst, src, nbytes, 1);
+	return ecb_aes_nx_crypt(req, 1);
 }
 
-static int ecb_aes_nx_decrypt(struct blkcipher_desc *desc,
-			      struct scatterlist    *dst,
-			      struct scatterlist    *src,
-			      unsigned int           nbytes)
+static int ecb_aes_nx_decrypt(struct skcipher_request *req)
 {
-	return ecb_aes_nx_crypt(desc, dst, src, nbytes, 0);
+	return ecb_aes_nx_crypt(req, 0);
 }
 
-struct crypto_alg nx_ecb_aes_alg = {
-	.cra_name        = "ecb(aes)",
-	.cra_driver_name = "ecb-aes-nx",
-	.cra_priority    = 300,
-	.cra_flags       = CRYPTO_ALG_TYPE_BLKCIPHER,
-	.cra_blocksize   = AES_BLOCK_SIZE,
-	.cra_alignmask   = 0xf,
-	.cra_ctxsize     = sizeof(struct nx_crypto_ctx),
-	.cra_type        = &crypto_blkcipher_type,
-	.cra_module      = THIS_MODULE,
-	.cra_init        = nx_crypto_ctx_aes_ecb_init,
-	.cra_exit        = nx_crypto_ctx_exit,
-	.cra_blkcipher = {
-		.min_keysize = AES_MIN_KEY_SIZE,
-		.max_keysize = AES_MAX_KEY_SIZE,
-		.setkey      = ecb_aes_nx_set_key,
-		.encrypt     = ecb_aes_nx_encrypt,
-		.decrypt     = ecb_aes_nx_decrypt,
-	}
+struct skcipher_alg nx_ecb_aes_alg = {
+	.base.cra_name		= "ecb(aes)",
+	.base.cra_driver_name	= "ecb-aes-nx",
+	.base.cra_priority	= 300,
+	.base.cra_blocksize	= AES_BLOCK_SIZE,
+	.base.cra_alignmask	= 0xf,
+	.base.cra_ctxsize	= sizeof(struct nx_crypto_ctx),
+	.base.cra_module	= THIS_MODULE,
+	.init			= nx_crypto_ctx_aes_ecb_init,
+	.exit			= nx_crypto_ctx_skcipher_exit,
+	.min_keysize		= AES_MIN_KEY_SIZE,
+	.max_keysize		= AES_MAX_KEY_SIZE,
+	.setkey			= ecb_aes_nx_set_key,
+	.encrypt		= ecb_aes_nx_encrypt,
+	.decrypt		= ecb_aes_nx_decrypt,
 };
diff --git a/drivers/crypto/nx/nx.c b/drivers/crypto/nx/nx.c
index 1202a00715ac..4b97081e7486 100644
--- a/drivers/crypto/nx/nx.c
+++ b/drivers/crypto/nx/nx.c
@@ -517,6 +517,12 @@ static int nx_register_alg(struct crypto_alg *alg, u32 fc, u32 mode)
 	       crypto_register_alg(alg) : 0;
 }
 
+static int nx_register_skcipher(struct skcipher_alg *alg, u32 fc, u32 mode)
+{
+	return nx_check_props(&nx_driver.viodev->dev, fc, mode) ?
+	       crypto_register_skcipher(alg) : 0;
+}
+
 static int nx_register_aead(struct aead_alg *alg, u32 fc, u32 mode)
 {
 	return nx_check_props(&nx_driver.viodev->dev, fc, mode) ?
@@ -537,6 +543,12 @@ static void nx_unregister_alg(struct crypto_alg *alg, u32 fc, u32 mode)
 		crypto_unregister_alg(alg);
 }
 
+static void nx_unregister_skcipher(struct skcipher_alg *alg, u32 fc, u32 mode)
+{
+	if (nx_check_props(NULL, fc, mode))
+		crypto_unregister_skcipher(alg);
+}
+
 static void nx_unregister_aead(struct aead_alg *alg, u32 fc, u32 mode)
 {
 	if (nx_check_props(NULL, fc, mode))
@@ -573,7 +585,7 @@ static int nx_register_algs(void)
 
 	nx_driver.of.status = NX_OKAY;
 
-	rc = nx_register_alg(&nx_ecb_aes_alg, NX_FC_AES, NX_MODE_AES_ECB);
+	rc = nx_register_skcipher(&nx_ecb_aes_alg, NX_FC_AES, NX_MODE_AES_ECB);
 	if (rc)
 		goto out;
 
@@ -637,7 +649,7 @@ static int nx_register_algs(void)
 out_unreg_cbc:
 	nx_unregister_alg(&nx_cbc_aes_alg, NX_FC_AES, NX_MODE_AES_CBC);
 out_unreg_ecb:
-	nx_unregister_alg(&nx_ecb_aes_alg, NX_FC_AES, NX_MODE_AES_ECB);
+	nx_unregister_skcipher(&nx_ecb_aes_alg, NX_FC_AES, NX_MODE_AES_ECB);
 out:
 	return rc;
 }
@@ -716,9 +728,9 @@ int nx_crypto_ctx_aes_cbc_init(struct crypto_tfm *tfm)
 				  NX_MODE_AES_CBC);
 }
 
-int nx_crypto_ctx_aes_ecb_init(struct crypto_tfm *tfm)
+int nx_crypto_ctx_aes_ecb_init(struct crypto_skcipher *tfm)
 {
-	return nx_crypto_ctx_init(crypto_tfm_ctx(tfm), NX_FC_AES,
+	return nx_crypto_ctx_init(crypto_skcipher_ctx(tfm), NX_FC_AES,
 				  NX_MODE_AES_ECB);
 }
 
@@ -752,6 +764,11 @@ void nx_crypto_ctx_exit(struct crypto_tfm *tfm)
 	nx_ctx->out_sg = NULL;
 }
 
+void nx_crypto_ctx_skcipher_exit(struct crypto_skcipher *tfm)
+{
+	nx_crypto_ctx_exit(crypto_skcipher_ctx(tfm));
+}
+
 void nx_crypto_ctx_aead_exit(struct crypto_aead *tfm)
 {
 	struct nx_crypto_ctx *nx_ctx = crypto_aead_ctx(tfm);
@@ -801,7 +818,8 @@ static int nx_remove(struct vio_dev *viodev)
 		nx_unregister_alg(&nx_ctr3686_aes_alg,
 				  NX_FC_AES, NX_MODE_AES_CTR);
 		nx_unregister_alg(&nx_cbc_aes_alg, NX_FC_AES, NX_MODE_AES_CBC);
-		nx_unregister_alg(&nx_ecb_aes_alg, NX_FC_AES, NX_MODE_AES_ECB);
+		nx_unregister_skcipher(&nx_ecb_aes_alg, NX_FC_AES,
+				       NX_MODE_AES_ECB);
 	}
 
 	return 0;
diff --git a/drivers/crypto/nx/nx.h b/drivers/crypto/nx/nx.h
index 768ebae9731e..1a839ef21c4f 100644
--- a/drivers/crypto/nx/nx.h
+++ b/drivers/crypto/nx/nx.h
@@ -147,9 +147,10 @@ int nx_crypto_ctx_aes_gcm_init(struct crypto_aead *tfm);
 int nx_crypto_ctx_aes_xcbc_init(struct crypto_tfm *tfm);
 int nx_crypto_ctx_aes_ctr_init(struct crypto_tfm *tfm);
 int nx_crypto_ctx_aes_cbc_init(struct crypto_tfm *tfm);
-int nx_crypto_ctx_aes_ecb_init(struct crypto_tfm *tfm);
+int nx_crypto_ctx_aes_ecb_init(struct crypto_skcipher *tfm);
 int nx_crypto_ctx_sha_init(struct crypto_tfm *tfm);
 void nx_crypto_ctx_exit(struct crypto_tfm *tfm);
+void nx_crypto_ctx_skcipher_exit(struct crypto_skcipher *tfm);
 void nx_crypto_ctx_aead_exit(struct crypto_aead *tfm);
 void nx_ctx_init(struct nx_crypto_ctx *nx_ctx, unsigned int function);
 int nx_hcall_sync(struct nx_crypto_ctx *ctx, struct vio_pfo_op *op,
@@ -176,7 +177,7 @@ void nx_debugfs_fini(struct nx_crypto_driver *);
 #define NX_PAGE_NUM(x)		((u64)(x) & 0xfffffffffffff000ULL)
 
 extern struct crypto_alg nx_cbc_aes_alg;
-extern struct crypto_alg nx_ecb_aes_alg;
+extern struct skcipher_alg nx_ecb_aes_alg;
 extern struct aead_alg nx_gcm_aes_alg;
 extern struct aead_alg nx_gcm4106_aes_alg;
 extern struct crypto_alg nx_ctr3686_aes_alg;
-- 
2.23.0

