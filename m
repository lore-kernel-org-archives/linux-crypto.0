Return-Path: <SRS0=rgpc=NK=vger.kernel.org=linux-crypto-owner@kernel.org>
Received: from youngberry.canonical.com ([91.189.89.112]:49603 "EHLO
        youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727669AbeJ3UzQ (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 30 Oct 2018 16:55:16 -0400
From: Colin King <colin.king@canonical.com>
To: Harsh Jain <harsh@chelsio.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "David S . Miller" <davem@davemloft.net>,
        linux-crypto@vger.kernel.org
Cc: kernel-janitors@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH] crypto: chelsio: clean up various indentation issues
Date: Tue, 30 Oct 2018 12:01:58 +0000
Message-Id: <20181030120158.23323-1-colin.king@canonical.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

From: Colin Ian King <colin.king@canonical.com>

Trivial fix to clean up varous indentation issue

Signed-off-by: Colin Ian King <colin.king@canonical.com>
---
 drivers/crypto/chelsio/chcr_algo.c | 16 ++++++++--------
 1 file changed, 8 insertions(+), 8 deletions(-)

diff --git a/drivers/crypto/chelsio/chcr_algo.c b/drivers/crypto/chelsio/chcr_algo.c
index db203f8be429..497c57803de7 100644
--- a/drivers/crypto/chelsio/chcr_algo.c
+++ b/drivers/crypto/chelsio/chcr_algo.c
@@ -1311,8 +1311,8 @@ static int chcr_aes_decrypt(struct ablkcipher_request *req)
 			return -ENOSPC;
 	}
 
-	 err = process_cipher(req, u_ctx->lldi.rxq_ids[c_ctx(tfm)->rx_qidx],
-			      &skb, CHCR_DECRYPT_OP);
+	err = process_cipher(req, u_ctx->lldi.rxq_ids[c_ctx(tfm)->rx_qidx],
+			     &skb, CHCR_DECRYPT_OP);
 	if (err || !skb)
 		return err;
 	skb->dev = u_ctx->lldi.ports[0];
@@ -2008,7 +2008,7 @@ static int chcr_ahash_export(struct ahash_request *areq, void *out)
 	memcpy(state->partial_hash, req_ctx->partial_hash,
 	       CHCR_HASH_MAX_DIGEST_SIZE);
 	chcr_init_hctx_per_wr(state);
-		return 0;
+	return 0;
 }
 
 static int chcr_ahash_import(struct ahash_request *areq, const void *in)
@@ -2249,7 +2249,7 @@ static int chcr_aead_fallback(struct aead_request *req, unsigned short op_type)
 				  req->base.complete, req->base.data);
 	aead_request_set_crypt(subreq, req->src, req->dst, req->cryptlen,
 				 req->iv);
-	 aead_request_set_ad(subreq, req->assoclen);
+	aead_request_set_ad(subreq, req->assoclen);
 	return op_type ? crypto_aead_decrypt(subreq) :
 		crypto_aead_encrypt(subreq);
 }
@@ -3118,12 +3118,12 @@ static int chcr_gcm_setauthsize(struct crypto_aead *tfm, unsigned int authsize)
 		aeadctx->mayverify = VERIFY_HW;
 		break;
 	case ICV_12:
-		 aeadctx->hmac_ctrl = CHCR_SCMD_HMAC_CTRL_IPSEC_96BIT;
-		 aeadctx->mayverify = VERIFY_HW;
+		aeadctx->hmac_ctrl = CHCR_SCMD_HMAC_CTRL_IPSEC_96BIT;
+		aeadctx->mayverify = VERIFY_HW;
 		break;
 	case ICV_14:
-		 aeadctx->hmac_ctrl = CHCR_SCMD_HMAC_CTRL_PL3;
-		 aeadctx->mayverify = VERIFY_HW;
+		aeadctx->hmac_ctrl = CHCR_SCMD_HMAC_CTRL_PL3;
+		aeadctx->mayverify = VERIFY_HW;
 		break;
 	case ICV_16:
 		aeadctx->hmac_ctrl = CHCR_SCMD_HMAC_CTRL_NO_TRUNC;
-- 
2.19.1
