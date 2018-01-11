From: Harsh Jain <harsh@chelsio.com>
Subject: [PATCH 5/5] crypto: chelsio - Remove dst sg size zero check
Date: Thu, 11 Jan 2018 16:45:52 +0530
Message-ID: <c835cca9d1ada5804c9d7c73214c5ea7c73cb5ee.1515669022.git.harsh@chelsio.com>
References: <cover.1515669022.git.harsh@chelsio.com>
Cc: Harsh Jain <harsh@chelsio.com>
To: herbert@gondor.apana.org.au, linux-crypto@vger.kernel.org
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from stargate.chelsio.com ([12.32.117.8]:13303 "EHLO
        stargate.chelsio.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S933815AbeAKLQM (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 11 Jan 2018 06:16:12 -0500
In-Reply-To: <cover.1515669022.git.harsh@chelsio.com>
In-Reply-To: <cover.1515669022.git.harsh@chelsio.com>
References: <cover.1515669022.git.harsh@chelsio.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

sg_nents_xlen will take care of zero length sg list.
Remove Destination sg list size zero check.

Signed-off-by: Harsh Jain <harsh@chelsio.com>
---
 drivers/crypto/chelsio/chcr_algo.c | 43 ++++++++++++--------------------------
 1 file changed, 13 insertions(+), 30 deletions(-)

diff --git a/drivers/crypto/chelsio/chcr_algo.c b/drivers/crypto/chelsio/chcr_algo.c
index 5cc84c4..a9c894b 100644
--- a/drivers/crypto/chelsio/chcr_algo.c
+++ b/drivers/crypto/chelsio/chcr_algo.c
@@ -2109,20 +2109,14 @@ static struct sk_buff *create_authenc_wr(struct aead_request *req,
 		null = 1;
 		assoclen = 0;
 	}
-	dst_size = assoclen + req->cryptlen + (op_type ? -authsize :
-						    authsize);
 	error = chcr_aead_common_init(req, op_type);
 	if (error)
 		return ERR_PTR(error);
-	if (dst_size) {
 		dnents = sg_nents_xlen(req->dst, assoclen, CHCR_DST_SG_SIZE, 0);
 		dnents += sg_nents_xlen(req->dst, req->cryptlen +
 			(op_type ? -authsize : authsize), CHCR_DST_SG_SIZE,
 			req->assoclen);
 		dnents += MIN_AUTH_SG; // For IV
-	} else {
-		dnents = 0;
-	}
 
 	dst_size = get_space_for_phys_dsgl(dnents);
 	kctx_len = (ntohl(KEY_CONTEXT_CTX_LEN_V(aeadctx->key_ctx_hdr)) << 4)
@@ -2687,8 +2681,6 @@ static struct sk_buff *create_aead_ccm_wr(struct aead_request *req,
 	sub_type = get_aead_subtype(tfm);
 	if (sub_type == CRYPTO_ALG_SUB_TYPE_AEAD_RFC4309)
 		assoclen -= 8;
-	dst_size = assoclen + req->cryptlen + (op_type ? -authsize :
-						   authsize);
 	error = chcr_aead_common_init(req, op_type);
 	if (error)
 		return ERR_PTR(error);
@@ -2698,15 +2690,11 @@ static struct sk_buff *create_aead_ccm_wr(struct aead_request *req,
 	error = aead_ccm_validate_input(op_type, req, aeadctx, sub_type);
 	if (error)
 		goto err;
-	if (dst_size) {
-		dnents = sg_nents_xlen(req->dst, assoclen, CHCR_DST_SG_SIZE, 0);
-		dnents += sg_nents_xlen(req->dst, req->cryptlen
-				+ (op_type ? -authsize : authsize),
-				CHCR_DST_SG_SIZE, req->assoclen);
-		dnents += MIN_CCM_SG; // For IV and B0
-	} else {
-		dnents = 0;
-	}
+	dnents = sg_nents_xlen(req->dst, assoclen, CHCR_DST_SG_SIZE, 0);
+	dnents += sg_nents_xlen(req->dst, req->cryptlen
+			+ (op_type ? -authsize : authsize),
+			CHCR_DST_SG_SIZE, req->assoclen);
+	dnents += MIN_CCM_SG; // For IV and B0
 	dst_size = get_space_for_phys_dsgl(dnents);
 	kctx_len = ((DIV_ROUND_UP(aeadctx->enckey_len, 16)) << 4) * 2;
 	transhdr_len = CIPHER_TRANSHDR_SIZE(kctx_len, dst_size);
@@ -2801,19 +2789,14 @@ static struct sk_buff *create_gcm_wr(struct aead_request *req,
 		assoclen = req->assoclen - 8;
 
 	reqctx->b0_dma = 0;
-	dst_size = assoclen + req->cryptlen + (op_type ? -authsize :  authsize);
 	error = chcr_aead_common_init(req, op_type);
-		if (error)
-			return	ERR_PTR(error);
-	if (dst_size) {
-		dnents = sg_nents_xlen(req->dst, assoclen, CHCR_DST_SG_SIZE, 0);
-		dnents += sg_nents_xlen(req->dst,
-			req->cryptlen + (op_type ? -authsize : authsize),
+	if (error)
+		return ERR_PTR(error);
+	dnents = sg_nents_xlen(req->dst, assoclen, CHCR_DST_SG_SIZE, 0);
+	dnents += sg_nents_xlen(req->dst, req->cryptlen +
+				(op_type ? -authsize : authsize),
 				CHCR_DST_SG_SIZE, req->assoclen);
-		dnents += MIN_GCM_SG; // For IV
-	} else {
-		dnents = 0;
-	}
+	dnents += MIN_GCM_SG; // For IV
 	dst_size = get_space_for_phys_dsgl(dnents);
 	kctx_len = ((DIV_ROUND_UP(aeadctx->enckey_len, 16)) << 4) +
 		AEAD_H_SIZE;
@@ -2850,10 +2833,10 @@ static struct sk_buff *create_gcm_wr(struct aead_request *req,
 	chcr_req->sec_cpl.aadstart_cipherstop_hi = FILL_SEC_CPL_CIPHERSTOP_HI(
 					assoclen ? 1 : 0, assoclen,
 					assoclen + IV + 1, 0);
-		chcr_req->sec_cpl.cipherstop_lo_authinsert =
+	chcr_req->sec_cpl.cipherstop_lo_authinsert =
 			FILL_SEC_CPL_AUTHINSERT(0, assoclen + IV + 1,
 						temp, temp);
-		chcr_req->sec_cpl.seqno_numivs =
+	chcr_req->sec_cpl.seqno_numivs =
 			FILL_SEC_CPL_SCMD0_SEQNO(op_type, (op_type ==
 					CHCR_ENCRYPT_OP) ? 1 : 0,
 					CHCR_SCMD_CIPHER_MODE_AES_GCM,
-- 
2.1.4
