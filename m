From: Harsh Jain <harsh@chelsio.com>
Subject: [PATCH v3 05/10] crypto/chcr: Remove dynamic allocation
Date: Tue, 29 Nov 2016 19:00:38 +0530
Message-ID: <d8979da44ca4b42682aa757351a4ad8d4a01f265.1480413079.git.harsh@chelsio.com>
References: <cover.1480413079.git.harsh@chelsio.com>
Cc: Harsh Jain <harsh@chelsio.com>, Jitendra Lulla <JLULLA@chelsio.com>
To: dan.carpenter@oracle.com, herbert@gondor.apana.org.au,
        linux-crypto@vger.kernel.org, smueller@chronox.de,
        hariprasad@chelsio.com, jlulla@chelsio.com, atul.gupta@chelsio.com,
        yeshaswi@chelsio.com
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from stargate.chelsio.com ([12.32.117.8]:2547 "EHLO
        stargate.chelsio.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S933265AbcK2NbS (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 29 Nov 2016 08:31:18 -0500
In-Reply-To: <cover.1480413079.git.harsh@chelsio.com>
In-Reply-To: <cover.1480413079.git.harsh@chelsio.com>
References: <cover.1480413079.git.harsh@chelsio.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Remove malloc/free in hash operation and allocate
 memory in chcr_ahash_req_ctx structure.

Signed-off-by: Jitendra Lulla <JLULLA@chelsio.com>
---
 drivers/crypto/chelsio/chcr_algo.c   | 69 +++++++++++++++++++++---------------
 drivers/crypto/chelsio/chcr_crypto.h |  8 +++--
 2 files changed, 45 insertions(+), 32 deletions(-)

diff --git a/drivers/crypto/chelsio/chcr_algo.c b/drivers/crypto/chelsio/chcr_algo.c
index 0ae1b09..13aaca2 100644
--- a/drivers/crypto/chelsio/chcr_algo.c
+++ b/drivers/crypto/chelsio/chcr_algo.c
@@ -150,8 +150,6 @@ int chcr_handle_resp(struct crypto_async_request *req, unsigned char *input,
 			       sizeof(struct cpl_fw6_pld),
 			       updated_digestsize);
 		}
-		kfree(ctx_req.ctx.ahash_ctx->dummy_payload_ptr);
-		ctx_req.ctx.ahash_ctx->dummy_payload_ptr = NULL;
 		break;
 	}
 	return 0;
@@ -860,8 +858,8 @@ static struct sk_buff *create_hash_wr(struct ahash_request *req,
 
 	skb_set_transport_header(skb, transhdr_len);
 	if (param->bfr_len != 0)
-		write_buffer_to_skb(skb, &frags, req_ctx->bfr,
-					    param->bfr_len);
+		write_buffer_to_skb(skb, &frags, req_ctx->reqbfr,
+				    param->bfr_len);
 	if (param->sg_len != 0)
 		write_sg_to_skb(skb, &frags, req->src, param->sg_len);
 
@@ -892,30 +890,41 @@ static int chcr_ahash_update(struct ahash_request *req)
 			return -EBUSY;
 	}
 
-	if (nbytes + req_ctx->bfr_len >= bs) {
-		remainder = (nbytes + req_ctx->bfr_len) % bs;
-		nbytes = nbytes + req_ctx->bfr_len - remainder;
+	if (nbytes + req_ctx->reqlen >= bs) {
+		remainder = (nbytes + req_ctx->reqlen) % bs;
+		nbytes = nbytes + req_ctx->reqlen - remainder;
 	} else {
-		sg_pcopy_to_buffer(req->src, sg_nents(req->src), req_ctx->bfr +
-				   req_ctx->bfr_len, nbytes, 0);
-		req_ctx->bfr_len += nbytes;
+		sg_pcopy_to_buffer(req->src, sg_nents(req->src), req_ctx->reqbfr
+				   + req_ctx->reqlen, nbytes, 0);
+		req_ctx->reqlen += nbytes;
 		return 0;
 	}
 
 	params.opad_needed = 0;
 	params.more = 1;
 	params.last = 0;
+	params.sg_len = nbytes - req_ctx->reqlen;
+	params.bfr_len = req_ctx->reqlen;
 	params.scmd1 = 0;
 	get_alg_config(&params.alg_prm, crypto_ahash_digestsize(rtfm));
 	req_ctx->result = 0;
 	req_ctx->data_len += params.sg_len + params.bfr_len;
 	skb = create_hash_wr(req, &params);
 
-	req_ctx->bfr_len = remainder;
-	if (remainder)
+	if (IS_ERR(skb))
+		return PTR_ERR(skb);
+
+	if (remainder) {
+		u8 *temp;
+		/* Swap buffers */
+		temp = req_ctx->reqbfr;
+		req_ctx->reqbfr = req_ctx->skbfr;
+		req_ctx->skbfr = temp;
 		sg_pcopy_to_buffer(req->src, sg_nents(req->src),
-				   req_ctx->bfr, remainder, req->nbytes -
+				   req_ctx->reqbfr, remainder, req->nbytes -
 				   remainder);
+	}
+	req_ctx->reqlen = remainder;
 	skb->dev = u_ctx->lldi.ports[0];
 	set_wr_txq(skb, CPL_PRIORITY_DATA, ctx->tx_channel_id);
 	chcr_send_wr(skb);
@@ -951,10 +960,10 @@ static int chcr_ahash_final(struct ahash_request *req)
 	params.sg_len = 0;
 	get_alg_config(&params.alg_prm, crypto_ahash_digestsize(rtfm));
 	req_ctx->result = 1;
-	params.bfr_len = req_ctx->bfr_len;
+	params.bfr_len = req_ctx->reqlen;
 	req_ctx->data_len += params.bfr_len + params.sg_len;
-	if (req_ctx->bfr && (req_ctx->bfr_len == 0)) {
-		create_last_hash_block(req_ctx->bfr, bs, req_ctx->data_len);
+	if (req_ctx->reqlen == 0) {
+		create_last_hash_block(req_ctx->reqbfr, bs, req_ctx->data_len);
 		params.last = 0;
 		params.more = 1;
 		params.scmd1 = 0;
@@ -1000,12 +1009,12 @@ static int chcr_ahash_finup(struct ahash_request *req)
 		params.opad_needed = 0;
 
 	params.sg_len = req->nbytes;
-	params.bfr_len = req_ctx->bfr_len;
+	params.bfr_len = req_ctx->reqlen;
 	get_alg_config(&params.alg_prm, crypto_ahash_digestsize(rtfm));
 	req_ctx->data_len += params.bfr_len + params.sg_len;
 	req_ctx->result = 1;
-	if (req_ctx->bfr && (req_ctx->bfr_len + req->nbytes) == 0) {
-		create_last_hash_block(req_ctx->bfr, bs, req_ctx->data_len);
+	if ((req_ctx->reqlen + req->nbytes) == 0) {
+		create_last_hash_block(req_ctx->reqbfr, bs, req_ctx->data_len);
 		params.last = 0;
 		params.more = 1;
 		params.scmd1 = 0;
@@ -1061,8 +1070,8 @@ static int chcr_ahash_digest(struct ahash_request *req)
 	req_ctx->result = 1;
 	req_ctx->data_len += params.bfr_len + params.sg_len;
 
-	if (req_ctx->bfr && req->nbytes == 0) {
-		create_last_hash_block(req_ctx->bfr, bs, 0);
+	if (req->nbytes == 0) {
+		create_last_hash_block(req_ctx->reqbfr, bs, 0);
 		params.more = 1;
 		params.bfr_len = bs;
 	}
@@ -1082,12 +1091,12 @@ static int chcr_ahash_export(struct ahash_request *areq, void *out)
 	struct chcr_ahash_req_ctx *req_ctx = ahash_request_ctx(areq);
 	struct chcr_ahash_req_ctx *state = out;
 
-	state->bfr_len = req_ctx->bfr_len;
+	state->reqlen = req_ctx->reqlen;
 	state->data_len = req_ctx->data_len;
-	memcpy(state->bfr, req_ctx->bfr, CHCR_HASH_MAX_BLOCK_SIZE_128);
+	memcpy(state->bfr1, req_ctx->reqbfr, req_ctx->reqlen);
 	memcpy(state->partial_hash, req_ctx->partial_hash,
 	       CHCR_HASH_MAX_DIGEST_SIZE);
-	return 0;
+		return 0;
 }
 
 static int chcr_ahash_import(struct ahash_request *areq, const void *in)
@@ -1095,10 +1104,11 @@ static int chcr_ahash_import(struct ahash_request *areq, const void *in)
 	struct chcr_ahash_req_ctx *req_ctx = ahash_request_ctx(areq);
 	struct chcr_ahash_req_ctx *state = (struct chcr_ahash_req_ctx *)in;
 
-	req_ctx->bfr_len = state->bfr_len;
+	req_ctx->reqlen = state->reqlen;
 	req_ctx->data_len = state->data_len;
-	req_ctx->dummy_payload_ptr = NULL;
-	memcpy(req_ctx->bfr, state->bfr, CHCR_HASH_MAX_BLOCK_SIZE_128);
+	req_ctx->reqbfr = req_ctx->bfr1;
+	req_ctx->skbfr = req_ctx->bfr2;
+	memcpy(req_ctx->bfr1, state->bfr1, CHCR_HASH_MAX_BLOCK_SIZE_128);
 	memcpy(req_ctx->partial_hash, state->partial_hash,
 	       CHCR_HASH_MAX_DIGEST_SIZE);
 	return 0;
@@ -1193,8 +1203,9 @@ static int chcr_sha_init(struct ahash_request *areq)
 	int digestsize =  crypto_ahash_digestsize(tfm);
 
 	req_ctx->data_len = 0;
-	req_ctx->dummy_payload_ptr = NULL;
-	req_ctx->bfr_len = 0;
+	req_ctx->reqlen = 0;
+	req_ctx->reqbfr = req_ctx->bfr1;
+	req_ctx->skbfr = req_ctx->bfr2;
 	req_ctx->skb = NULL;
 	req_ctx->result = 0;
 	copy_hash_init_values(req_ctx->partial_hash, digestsize);
diff --git a/drivers/crypto/chelsio/chcr_crypto.h b/drivers/crypto/chelsio/chcr_crypto.h
index acce367..8934ea2 100644
--- a/drivers/crypto/chelsio/chcr_crypto.h
+++ b/drivers/crypto/chelsio/chcr_crypto.h
@@ -150,12 +150,14 @@ struct chcr_context {
 
 struct chcr_ahash_req_ctx {
 	u32 result;
-	char bfr[CHCR_HASH_MAX_BLOCK_SIZE_128];
-	u8 bfr_len;
+	u8 bfr1[CHCR_HASH_MAX_BLOCK_SIZE_128];
+	u8 bfr2[CHCR_HASH_MAX_BLOCK_SIZE_128];
+	u8 *reqbfr;
+	u8 *skbfr;
+	u8 reqlen;
 	/* DMA the partial hash in it */
 	u8 partial_hash[CHCR_HASH_MAX_DIGEST_SIZE];
 	u64 data_len;  /* Data len till time */
-	void *dummy_payload_ptr;
 	/* SKB which is being sent to the hardware for processing */
 	struct sk_buff *skb;
 };
-- 
1.8.2.3
