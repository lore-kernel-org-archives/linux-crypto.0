Return-Path: <SRS0=eKEb=OU=vger.kernel.org=linux-crypto-owner@kernel.org>
Received: from stargate.chelsio.com ([12.32.117.8]:57870 "EHLO
        stargate.chelsio.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726595AbeLKKwB (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 11 Dec 2018 05:52:01 -0500
From: Harsh Jain <harsh@chelsio.com>
To: herbert@gondor.apana.org.au, linux-crypto@vger.kernel.org,
        atul.gupta@chelsio.com, indranil@chelsio.com
Cc: Harsh Jain <harsh@chelsio.com>
Subject: [PATCH 2/6] crypto:chelsio:Use same value for both channel in single WR
Date: Tue, 11 Dec 2018 16:21:38 +0530
Message-Id: <abef3b42cfa387edbd07d7248cdf1e4af5956649.1544520025.git.harsh@chelsio.com>
In-Reply-To: <cover.1544520025.git.harsh@chelsio.com>
References: <cover.1544520025.git.harsh@chelsio.com>
In-Reply-To: <cover.1544520025.git.harsh@chelsio.com>
References: <cover.1544520025.git.harsh@chelsio.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Use tx_channel_id instead of rx_channel_id.

Signed-off-by: Harsh Jain <harsh@chelsio.com>
---
 drivers/crypto/chelsio/chcr_algo.c | 13 ++++++-------
 drivers/crypto/chelsio/chcr_core.h |  1 -
 2 files changed, 6 insertions(+), 8 deletions(-)

diff --git a/drivers/crypto/chelsio/chcr_algo.c b/drivers/crypto/chelsio/chcr_algo.c
index 2b26735..ee985ad 100644
--- a/drivers/crypto/chelsio/chcr_algo.c
+++ b/drivers/crypto/chelsio/chcr_algo.c
@@ -717,7 +717,7 @@ static inline void create_wreq(struct chcr_context *ctx,
 		htonl(FW_CRYPTO_LOOKASIDE_WR_LEN16_V(DIV_ROUND_UP(len16, 16)));
 	chcr_req->wreq.cookie = cpu_to_be64((uintptr_t)req);
 	chcr_req->wreq.rx_chid_to_rx_q_id =
-		FILL_WR_RX_Q_ID(ctx->dev->rx_channel_id, qid,
+		FILL_WR_RX_Q_ID(ctx->tx_chan_id, qid,
 				!!lcb, ctx->tx_qidx);
 
 	chcr_req->ulptx.cmd_dest = FILL_ULPTX_CMD_DEST(ctx->tx_chan_id,
@@ -773,7 +773,7 @@ static struct sk_buff *create_cipher_wr(struct cipher_wr_param *wrparam)
 	}
 	chcr_req = __skb_put_zero(skb, transhdr_len);
 	chcr_req->sec_cpl.op_ivinsrtofst =
-		FILL_SEC_CPL_OP_IVINSR(c_ctx(tfm)->dev->rx_channel_id, 2, 1);
+		FILL_SEC_CPL_OP_IVINSR(c_ctx(tfm)->tx_chan_id, 2, 1);
 
 	chcr_req->sec_cpl.pldlen = htonl(IV + wrparam->bytes);
 	chcr_req->sec_cpl.aadstart_cipherstop_hi =
@@ -1344,7 +1344,6 @@ static int chcr_device_init(struct chcr_context *ctx)
 		spin_lock(&ctx->dev->lock_chcr_dev);
 		ctx->tx_chan_id = ctx->dev->tx_channel_id;
 		ctx->dev->tx_channel_id = !ctx->dev->tx_channel_id;
-		ctx->dev->rx_channel_id = 0;
 		spin_unlock(&ctx->dev->lock_chcr_dev);
 		rxq_idx = ctx->tx_chan_id * rxq_perchan;
 		rxq_idx += id % rxq_perchan;
@@ -1498,7 +1497,7 @@ static struct sk_buff *create_hash_wr(struct ahash_request *req,
 	chcr_req = __skb_put_zero(skb, transhdr_len);
 
 	chcr_req->sec_cpl.op_ivinsrtofst =
-		FILL_SEC_CPL_OP_IVINSR(h_ctx(tfm)->dev->rx_channel_id, 2, 0);
+		FILL_SEC_CPL_OP_IVINSR(h_ctx(tfm)->tx_chan_id, 2, 0);
 	chcr_req->sec_cpl.pldlen = htonl(param->bfr_len + param->sg_len);
 
 	chcr_req->sec_cpl.aadstart_cipherstop_hi =
@@ -2324,7 +2323,7 @@ static struct sk_buff *create_authenc_wr(struct aead_request *req,
 	 * to the hardware spec
 	 */
 	chcr_req->sec_cpl.op_ivinsrtofst =
-		FILL_SEC_CPL_OP_IVINSR(a_ctx(tfm)->dev->rx_channel_id, 2, 1);
+		FILL_SEC_CPL_OP_IVINSR(a_ctx(tfm)->tx_chan_id, 2, 1);
 	chcr_req->sec_cpl.pldlen = htonl(req->assoclen + IV + req->cryptlen);
 	chcr_req->sec_cpl.aadstart_cipherstop_hi = FILL_SEC_CPL_CIPHERSTOP_HI(
 					null ? 0 : 1 + IV,
@@ -2746,7 +2745,7 @@ static void fill_sec_cpl_for_aead(struct cpl_tx_sec_pdu *sec_cpl,
 	struct chcr_aead_ctx *aeadctx = AEAD_CTX(a_ctx(tfm));
 	unsigned int cipher_mode = CHCR_SCMD_CIPHER_MODE_AES_CCM;
 	unsigned int mac_mode = CHCR_SCMD_AUTH_MODE_CBCMAC;
-	unsigned int c_id = a_ctx(tfm)->dev->rx_channel_id;
+	unsigned int c_id = a_ctx(tfm)->tx_chan_id;
 	unsigned int ccm_xtra;
 	unsigned char tag_offset = 0, auth_offset = 0;
 	unsigned int assoclen;
@@ -2967,7 +2966,7 @@ static struct sk_buff *create_gcm_wr(struct aead_request *req,
 	//Offset of tag from end
 	temp = (reqctx->op == CHCR_ENCRYPT_OP) ? 0 : authsize;
 	chcr_req->sec_cpl.op_ivinsrtofst = FILL_SEC_CPL_OP_IVINSR(
-					a_ctx(tfm)->dev->rx_channel_id, 2, 1);
+					a_ctx(tfm)->tx_chan_id, 2, 1);
 	chcr_req->sec_cpl.pldlen =
 		htonl(req->assoclen + IV + req->cryptlen);
 	chcr_req->sec_cpl.aadstart_cipherstop_hi = FILL_SEC_CPL_CIPHERSTOP_HI(
diff --git a/drivers/crypto/chelsio/chcr_core.h b/drivers/crypto/chelsio/chcr_core.h
index 4616663..a50a24f 100644
--- a/drivers/crypto/chelsio/chcr_core.h
+++ b/drivers/crypto/chelsio/chcr_core.h
@@ -133,7 +133,6 @@ struct chcr_dev {
 	spinlock_t lock_chcr_dev;
 	struct uld_ctx *u_ctx;
 	unsigned char tx_channel_id;
-	unsigned char rx_channel_id;
 };
 
 struct uld_ctx {
-- 
2.1.4
