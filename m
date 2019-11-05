Return-Path: <SRS0=QWZk=Y5=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A9009C17461
	for <linux-crypto@archiver.kernel.org>; Tue,  5 Nov 2019 13:29:33 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 806ED21D71
	for <linux-crypto@archiver.kernel.org>; Tue,  5 Nov 2019 13:29:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1572960573;
	bh=1VWJ5fz8xzmVH93FNmZt4hERKVAWYIS2d6Esm0HnL7U=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:List-ID:From;
	b=qB1Cv32yZ1jPCV40KjvY04BZToRmUPRRWTDiQS8aJGOGka1GknjH6y9KzZ0I4Mh13
	 hj2S6NuWkJCc2zg5VDFT929bF13fNWKOeTbWeLnmZBoF11LfxKgXPpC5f/k2MrsVA/
	 Dj6pMQMMEplW6HhP14DAkWciHyGRatItDNBYmpH4=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389212AbfKEN3d (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Tue, 5 Nov 2019 08:29:33 -0500
Received: from mail.kernel.org ([198.145.29.99]:47692 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2389198AbfKEN3c (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 5 Nov 2019 08:29:32 -0500
Received: from localhost.localdomain (laubervilliers-657-1-83-120.w92-154.abo.wanadoo.fr [92.154.90.120])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id BB5E421882;
        Tue,  5 Nov 2019 13:29:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1572960572;
        bh=1VWJ5fz8xzmVH93FNmZt4hERKVAWYIS2d6Esm0HnL7U=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=bcQs3TL9yDcFwUjGsXUSYgstYmBMsXlAhT+nNhDixXgbW4ph7KLBgL4jNhNIU/wsS
         4iNRYCGLR5F9C3Mh3MDGoAWpgOAQ/rfsQMVRzAJTvXSQlGB+oj7RWCdADGKMV/Aru0
         Tbr8ST1Qr/7VnAqfNawFOQ0FdyAT6Egcyn0UpISE=
From:   Ard Biesheuvel <ardb@kernel.org>
To:     linux-crypto@vger.kernel.org
Cc:     Ard Biesheuvel <ardb@kernel.org>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Biggers <ebiggers@google.com>,
        linux-arm-kernel@lists.infradead.org
Subject: [PATCH v3 26/29] crypto: marvell/cesa - rename blkcipher to skcipher
Date:   Tue,  5 Nov 2019 14:28:23 +0100
Message-Id: <20191105132826.1838-27-ardb@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20191105132826.1838-1-ardb@kernel.org>
References: <20191105132826.1838-1-ardb@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

The driver specific types contain some rudimentary references to the
blkcipher API, which is deprecated and will be removed. To avoid confusion,
rename these to skcipher. This is a cosmetic change only, as the code does
not actually use the blkcipher API.

Signed-off-by: Ard Biesheuvel <ardb@kernel.org>
---
 drivers/crypto/marvell/cesa.h   |  6 +++---
 drivers/crypto/marvell/cipher.c | 14 +++++++-------
 2 files changed, 10 insertions(+), 10 deletions(-)

diff --git a/drivers/crypto/marvell/cesa.h b/drivers/crypto/marvell/cesa.h
index d63a6ee905c9..f1ed3b85c0d2 100644
--- a/drivers/crypto/marvell/cesa.h
+++ b/drivers/crypto/marvell/cesa.h
@@ -232,13 +232,13 @@ struct mv_cesa_sec_accel_desc {
 };
 
 /**
- * struct mv_cesa_blkcipher_op_ctx - cipher operation context
+ * struct mv_cesa_skcipher_op_ctx - cipher operation context
  * @key:	cipher key
  * @iv:		cipher IV
  *
  * Context associated to a cipher operation.
  */
-struct mv_cesa_blkcipher_op_ctx {
+struct mv_cesa_skcipher_op_ctx {
 	u32 key[8];
 	u32 iv[4];
 };
@@ -265,7 +265,7 @@ struct mv_cesa_hash_op_ctx {
 struct mv_cesa_op_ctx {
 	struct mv_cesa_sec_accel_desc desc;
 	union {
-		struct mv_cesa_blkcipher_op_ctx blkcipher;
+		struct mv_cesa_skcipher_op_ctx skcipher;
 		struct mv_cesa_hash_op_ctx hash;
 	} ctx;
 };
diff --git a/drivers/crypto/marvell/cipher.c b/drivers/crypto/marvell/cipher.c
index 84ceddfee76b..d8e8c857770c 100644
--- a/drivers/crypto/marvell/cipher.c
+++ b/drivers/crypto/marvell/cipher.c
@@ -209,7 +209,7 @@ mv_cesa_skcipher_complete(struct crypto_async_request *req)
 		struct mv_cesa_req *basereq;
 
 		basereq = &creq->base;
-		memcpy(skreq->iv, basereq->chain.last->op->ctx.blkcipher.iv,
+		memcpy(skreq->iv, basereq->chain.last->op->ctx.skcipher.iv,
 		       ivsize);
 	} else {
 		memcpy_fromio(skreq->iv,
@@ -470,7 +470,7 @@ static int mv_cesa_des_op(struct skcipher_request *req,
 	mv_cesa_update_op_cfg(tmpl, CESA_SA_DESC_CFG_CRYPTM_DES,
 			      CESA_SA_DESC_CFG_CRYPTM_MSK);
 
-	memcpy(tmpl->ctx.blkcipher.key, ctx->key, DES_KEY_SIZE);
+	memcpy(tmpl->ctx.skcipher.key, ctx->key, DES_KEY_SIZE);
 
 	return mv_cesa_skcipher_queue_req(req, tmpl);
 }
@@ -523,7 +523,7 @@ static int mv_cesa_cbc_des_op(struct skcipher_request *req,
 	mv_cesa_update_op_cfg(tmpl, CESA_SA_DESC_CFG_CRYPTCM_CBC,
 			      CESA_SA_DESC_CFG_CRYPTCM_MSK);
 
-	memcpy(tmpl->ctx.blkcipher.iv, req->iv, DES_BLOCK_SIZE);
+	memcpy(tmpl->ctx.skcipher.iv, req->iv, DES_BLOCK_SIZE);
 
 	return mv_cesa_des_op(req, tmpl);
 }
@@ -575,7 +575,7 @@ static int mv_cesa_des3_op(struct skcipher_request *req,
 	mv_cesa_update_op_cfg(tmpl, CESA_SA_DESC_CFG_CRYPTM_3DES,
 			      CESA_SA_DESC_CFG_CRYPTM_MSK);
 
-	memcpy(tmpl->ctx.blkcipher.key, ctx->key, DES3_EDE_KEY_SIZE);
+	memcpy(tmpl->ctx.skcipher.key, ctx->key, DES3_EDE_KEY_SIZE);
 
 	return mv_cesa_skcipher_queue_req(req, tmpl);
 }
@@ -628,7 +628,7 @@ struct skcipher_alg mv_cesa_ecb_des3_ede_alg = {
 static int mv_cesa_cbc_des3_op(struct skcipher_request *req,
 			       struct mv_cesa_op_ctx *tmpl)
 {
-	memcpy(tmpl->ctx.blkcipher.iv, req->iv, DES3_EDE_BLOCK_SIZE);
+	memcpy(tmpl->ctx.skcipher.iv, req->iv, DES3_EDE_BLOCK_SIZE);
 
 	return mv_cesa_des3_op(req, tmpl);
 }
@@ -694,7 +694,7 @@ static int mv_cesa_aes_op(struct skcipher_request *req,
 		key = ctx->aes.key_enc;
 
 	for (i = 0; i < ctx->aes.key_length / sizeof(u32); i++)
-		tmpl->ctx.blkcipher.key[i] = cpu_to_le32(key[i]);
+		tmpl->ctx.skcipher.key[i] = cpu_to_le32(key[i]);
 
 	if (ctx->aes.key_length == 24)
 		cfg |= CESA_SA_DESC_CFG_AES_LEN_192;
@@ -755,7 +755,7 @@ static int mv_cesa_cbc_aes_op(struct skcipher_request *req,
 {
 	mv_cesa_update_op_cfg(tmpl, CESA_SA_DESC_CFG_CRYPTCM_CBC,
 			      CESA_SA_DESC_CFG_CRYPTCM_MSK);
-	memcpy(tmpl->ctx.blkcipher.iv, req->iv, AES_BLOCK_SIZE);
+	memcpy(tmpl->ctx.skcipher.iv, req->iv, AES_BLOCK_SIZE);
 
 	return mv_cesa_aes_op(req, tmpl);
 }
-- 
2.20.1

