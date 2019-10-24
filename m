Return-Path: <SRS0=tzqc=YR=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7D683CA9EBE
	for <linux-crypto@archiver.kernel.org>; Thu, 24 Oct 2019 13:24:35 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 51EA02166E
	for <linux-crypto@archiver.kernel.org>; Thu, 24 Oct 2019 13:24:35 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="FhF56Pxn"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731935AbfJXNYe (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 24 Oct 2019 09:24:34 -0400
Received: from mail-wm1-f67.google.com ([209.85.128.67]:34395 "EHLO
        mail-wm1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2502434AbfJXNYe (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 24 Oct 2019 09:24:34 -0400
Received: by mail-wm1-f67.google.com with SMTP id v3so2001226wmh.1
        for <linux-crypto@vger.kernel.org>; Thu, 24 Oct 2019 06:24:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=pIvf3uaGexOd3cBtkCmgOi+/J9vxhbC8kqb/606IHXY=;
        b=FhF56Pxn4X3XQVxawn/+Eu+hcpuuhw0C9uevsNl8pV9C/b0nSJu6BuMkHF23q4KPHP
         oTVaS7ramu0vMoIUrzbPGj99cz/+em3Y8RUF0OJZbHaGBAfjMWUX+jy7li206eJNLk0G
         l33a4FEzF1w6/MabcLmZJCRjvHdwKPtZPYwgNXB7fJ9JILxo9PdF8DgmmaSxRWnzeUIU
         DDvwe1/4A4kzlNv/eL5Dxe+zp0FfhFV8tO3KDrngcRbD/B38M29QCnmQV+NvbuX5kyRZ
         wV4saxxqa1dSh3MwQf7bUIMUcWYJyB8DTpnEotJajuraygBur7fdbEfCbL1L/MrqTWL3
         r08w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=pIvf3uaGexOd3cBtkCmgOi+/J9vxhbC8kqb/606IHXY=;
        b=AMIn8GRHT+vSK2XMBF6VriGs2PQMUhBim8Q2V4c43309ZAOQCJe6PDJgd1bednZhMo
         W4kCmAG7j1CAUkIfw/FovQDCbR+1yGpMZ+OaDEPfRQxfdOUVNGKqDpHMH0kfpE5WVirT
         ETTkdQ1S5SXoev9hbcbmRPb6HA/c/lFffDGxNZ5dugBcDcHcg0U49PXW30ZUbtjJG3iA
         9+g8Hqx5XL03eG24VOVSvXlXOXENrG2WUhhvjr4yKBml5+62t9AelaCMpUYJrThhd8s/
         1Q+ai5XN91lCFgYUx6xfWBCzAyukxTAiolRLruPVr43MxxJx2xyb91VNifgzPHObmPze
         mhNQ==
X-Gm-Message-State: APjAAAWXea4WqspTR4fm6rrDS/7g1LVaext5cXum6HSoEdSfWq6DE0Er
        /Wq1CDajknzbx4K9iA3jojPewYHUJlSrf7WS
X-Google-Smtp-Source: APXvYqzoCg2b5XHvYPu+5eB6aX89cQV4TlVbsQXRylMtCiOq+8zfsUcRYhaMc0a1t03d37CsAZTqXA==
X-Received: by 2002:a7b:c94f:: with SMTP id i15mr5107043wml.8.1571923470209;
        Thu, 24 Oct 2019 06:24:30 -0700 (PDT)
Received: from localhost.localdomain (laubervilliers-657-1-83-120.w92-154.abo.wanadoo.fr. [92.154.90.120])
        by smtp.gmail.com with ESMTPSA id e3sm2346310wme.36.2019.10.24.06.24.28
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 24 Oct 2019 06:24:29 -0700 (PDT)
From:   Ard Biesheuvel <ard.biesheuvel@linaro.org>
To:     linux-crypto@vger.kernel.org
Cc:     Ard Biesheuvel <ard.biesheuvel@linaro.org>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Biggers <ebiggers@google.com>,
        linux-arm-kernel@lists.infradead.org
Subject: [PATCH v2 26/27] crypto: marvell/cesa - rename blkcipher to skcipher
Date:   Thu, 24 Oct 2019 15:23:44 +0200
Message-Id: <20191024132345.5236-27-ard.biesheuvel@linaro.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20191024132345.5236-1-ard.biesheuvel@linaro.org>
References: <20191024132345.5236-1-ard.biesheuvel@linaro.org>
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

Signed-off-by: Ard Biesheuvel <ard.biesheuvel@linaro.org>
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

