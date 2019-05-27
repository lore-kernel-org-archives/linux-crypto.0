Return-Path: <SRS0=ER81=T3=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	UNWANTED_LANGUAGE_BODY,USER_AGENT_GIT autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D2611C072B1
	for <linux-crypto@archiver.kernel.org>; Mon, 27 May 2019 14:52:15 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id B1272217F4
	for <linux-crypto@archiver.kernel.org>; Mon, 27 May 2019 14:52:15 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726889AbfE0Ovo (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Mon, 27 May 2019 10:51:44 -0400
Received: from relay10.mail.gandi.net ([217.70.178.230]:48691 "EHLO
        relay10.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726772AbfE0Ovo (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 27 May 2019 10:51:44 -0400
Received: from localhost (aaubervilliers-681-1-27-134.w90-88.abo.wanadoo.fr [90.88.147.134])
        (Authenticated sender: antoine.tenart@bootlin.com)
        by relay10.mail.gandi.net (Postfix) with ESMTPSA id 8423324000E;
        Mon, 27 May 2019 14:51:40 +0000 (UTC)
From:   Antoine Tenart <antoine.tenart@bootlin.com>
To:     herbert@gondor.apana.org.au, davem@davemloft.net
Cc:     Antoine Tenart <antoine.tenart@bootlin.com>,
        linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
        thomas.petazzoni@bootlin.com, maxime.chevallier@bootlin.com,
        gregory.clement@bootlin.com, miquel.raynal@bootlin.com,
        nadavh@marvell.com, igall@marvell.com
Subject: [PATCH 11/14] crypto: inside-secure - implement IV retrieval
Date:   Mon, 27 May 2019 16:51:03 +0200
Message-Id: <20190527145106.8693-12-antoine.tenart@bootlin.com>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190527145106.8693-1-antoine.tenart@bootlin.com>
References: <20190527145106.8693-1-antoine.tenart@bootlin.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

This patch adds support for retrieving intermediate IV from the crypto
engine when using the CBC block mode with AES and (3)DES. The retrieved
IV is copied to the request IV buffer, as requested by the kernel crypto
API.

This fix boot tests added by
commit 8efd972ef96a ("crypto: testmgr - support checking skcipher output IV").

Signed-off-by: Antoine Tenart <antoine.tenart@bootlin.com>
---
 drivers/crypto/inside-secure/safexcel.h       |  8 +++
 .../crypto/inside-secure/safexcel_cipher.c    | 52 ++++++++++++++++---
 2 files changed, 53 insertions(+), 7 deletions(-)

diff --git a/drivers/crypto/inside-secure/safexcel.h b/drivers/crypto/inside-secure/safexcel.h
index 0bc8859f9d06..ca6ece5607cd 100644
--- a/drivers/crypto/inside-secure/safexcel.h
+++ b/drivers/crypto/inside-secure/safexcel.h
@@ -339,6 +339,7 @@ struct safexcel_context_record {
 #define CONTEXT_CONTROL_IV3			BIT(8)
 #define CONTEXT_CONTROL_DIGEST_CNT		BIT(9)
 #define CONTEXT_CONTROL_COUNTER_MODE		BIT(10)
+#define CONTEXT_CONTROL_CRYPTO_STORE		BIT(12)
 #define CONTEXT_CONTROL_HASH_STORE		BIT(19)
 
 /* The hash counter given to the engine in the context has a granularity of
@@ -431,6 +432,10 @@ struct safexcel_token {
 
 #define EIP197_TOKEN_HASH_RESULT_VERIFY		BIT(16)
 
+#define EIP197_TOKEN_CTX_OFFSET(x)		(x)
+#define EIP197_TOKEN_DIRECTION_EXTERNAL		BIT(11)
+#define EIP197_TOKEN_EXEC_IF_SUCCESSFUL		(0x1 << 12)
+
 #define EIP197_TOKEN_STAT_LAST_HASH		BIT(0)
 #define EIP197_TOKEN_STAT_LAST_PACKET		BIT(1)
 #define EIP197_TOKEN_OPCODE_DIRECTION		0x0
@@ -438,6 +443,7 @@ struct safexcel_token {
 #define EIP197_TOKEN_OPCODE_NOOP		EIP197_TOKEN_OPCODE_INSERT
 #define EIP197_TOKEN_OPCODE_RETRIEVE		0x4
 #define EIP197_TOKEN_OPCODE_VERIFY		0xd
+#define EIP197_TOKEN_OPCODE_CTX_ACCESS		0xe
 #define EIP197_TOKEN_OPCODE_BYPASS		GENMASK(3, 0)
 
 static inline void eip197_noop_token(struct safexcel_token *token)
@@ -448,6 +454,8 @@ static inline void eip197_noop_token(struct safexcel_token *token)
 
 /* Instructions */
 #define EIP197_TOKEN_INS_INSERT_HASH_DIGEST	0x1c
+#define EIP197_TOKEN_INS_ORIGIN_IV0		0x14
+#define EIP197_TOKEN_INS_ORIGIN_LEN(x)		((x) << 5)
 #define EIP197_TOKEN_INS_TYPE_OUTPUT		BIT(5)
 #define EIP197_TOKEN_INS_TYPE_HASH		BIT(6)
 #define EIP197_TOKEN_INS_TYPE_CRYTO		BIT(7)
diff --git a/drivers/crypto/inside-secure/safexcel_cipher.c b/drivers/crypto/inside-secure/safexcel_cipher.c
index aca1cdf33362..cedfb121c278 100644
--- a/drivers/crypto/inside-secure/safexcel_cipher.c
+++ b/drivers/crypto/inside-secure/safexcel_cipher.c
@@ -59,26 +59,26 @@ static void safexcel_skcipher_token(struct safexcel_cipher_ctx *ctx, u8 *iv,
 				    u32 length)
 {
 	struct safexcel_token *token;
-	unsigned offset = 0;
+	u32 offset = 0, block_sz = 0;
 
 	if (ctx->mode == CONTEXT_CONTROL_CRYPTO_MODE_CBC) {
 		switch (ctx->alg) {
 		case SAFEXCEL_DES:
-			offset = DES_BLOCK_SIZE / sizeof(u32);
-			memcpy(cdesc->control_data.token, iv, DES_BLOCK_SIZE);
+			block_sz = DES_BLOCK_SIZE;
 			cdesc->control_data.options |= EIP197_OPTION_2_TOKEN_IV_CMD;
 			break;
 		case SAFEXCEL_3DES:
-			offset = DES3_EDE_BLOCK_SIZE / sizeof(u32);
-			memcpy(cdesc->control_data.token, iv, DES3_EDE_BLOCK_SIZE);
+			block_sz = DES3_EDE_BLOCK_SIZE;
 			cdesc->control_data.options |= EIP197_OPTION_2_TOKEN_IV_CMD;
 			break;
 		case SAFEXCEL_AES:
-			offset = AES_BLOCK_SIZE / sizeof(u32);
-			memcpy(cdesc->control_data.token, iv, AES_BLOCK_SIZE);
+			block_sz = AES_BLOCK_SIZE;
 			cdesc->control_data.options |= EIP197_OPTION_4_TOKEN_IV_CMD;
 			break;
 		}
+
+		offset = block_sz / sizeof(u32);
+		memcpy(cdesc->control_data.token, iv, block_sz);
 	}
 
 	token = (struct safexcel_token *)(cdesc->control_data.token + offset);
@@ -90,6 +90,25 @@ static void safexcel_skcipher_token(struct safexcel_cipher_ctx *ctx, u8 *iv,
 	token[0].instructions = EIP197_TOKEN_INS_LAST |
 				EIP197_TOKEN_INS_TYPE_CRYTO |
 				EIP197_TOKEN_INS_TYPE_OUTPUT;
+
+	if (ctx->mode == CONTEXT_CONTROL_CRYPTO_MODE_CBC) {
+		u32 last = (EIP197_MAX_TOKENS - 1) - offset;
+
+		token[last].opcode = EIP197_TOKEN_OPCODE_CTX_ACCESS;
+		token[last].packet_length = EIP197_TOKEN_DIRECTION_EXTERNAL |
+					    EIP197_TOKEN_EXEC_IF_SUCCESSFUL|
+					    EIP197_TOKEN_CTX_OFFSET(0x2);
+		token[last].stat = EIP197_TOKEN_STAT_LAST_HASH |
+			EIP197_TOKEN_STAT_LAST_PACKET;
+		token[last].instructions =
+			EIP197_TOKEN_INS_ORIGIN_LEN(block_sz / sizeof(u32)) |
+			EIP197_TOKEN_INS_ORIGIN_IV0;
+
+		/* Store the updated IV values back in the internal context
+		 * registers.
+		 */
+		cdesc->control_data.control1 |= CONTEXT_CONTROL_CRYPTO_STORE;
+	}
 }
 
 static void safexcel_aead_token(struct safexcel_cipher_ctx *ctx, u8 *iv,
@@ -559,6 +578,7 @@ static int safexcel_skcipher_handle_result(struct safexcel_crypto_priv *priv,
 {
 	struct skcipher_request *req = skcipher_request_cast(async);
 	struct safexcel_cipher_req *sreq = skcipher_request_ctx(req);
+	struct safexcel_cipher_ctx *ctx = crypto_tfm_ctx(async->tfm);
 	int err;
 
 	if (sreq->needs_inv) {
@@ -569,6 +589,24 @@ static int safexcel_skcipher_handle_result(struct safexcel_crypto_priv *priv,
 		err = safexcel_handle_req_result(priv, ring, async, req->src,
 						 req->dst, req->cryptlen, sreq,
 						 should_complete, ret);
+
+		if (ctx->mode == CONTEXT_CONTROL_CRYPTO_MODE_CBC) {
+			u32 block_sz = 0;
+
+			switch (ctx->alg) {
+			case SAFEXCEL_DES:
+				block_sz = DES_BLOCK_SIZE;
+				break;
+			case SAFEXCEL_3DES:
+				block_sz = DES3_EDE_BLOCK_SIZE;
+				break;
+			case SAFEXCEL_AES:
+				block_sz = AES_BLOCK_SIZE;
+				break;
+			}
+
+			memcpy(req->iv, ctx->base.ctxr->data, block_sz);
+		}
 	}
 
 	return err;
-- 
2.21.0

