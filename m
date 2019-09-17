Return-Path: <SRS0=aQ9n=XM=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0A7FAC4CEC9
	for <linux-crypto@archiver.kernel.org>; Tue, 17 Sep 2019 11:10:57 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id CBEF7214AF
	for <linux-crypto@archiver.kernel.org>; Tue, 17 Sep 2019 11:10:56 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="bdqM30ra"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726523AbfIQLK4 (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Tue, 17 Sep 2019 07:10:56 -0400
Received: from mail-ed1-f65.google.com ([209.85.208.65]:42363 "EHLO
        mail-ed1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726091AbfIQLK4 (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 17 Sep 2019 07:10:56 -0400
Received: by mail-ed1-f65.google.com with SMTP id y91so2919172ede.9
        for <linux-crypto@vger.kernel.org>; Tue, 17 Sep 2019 04:10:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=6l03A18+Pqx0Bv7bmfg+Mm9yI8h7Rad5qbP0y8DBm90=;
        b=bdqM30ra67fTc5rpKaaH52GV01CEqkf8E3T50vdYUxWUfOyrIrMxAktD5j0vzG8gWb
         1wYdP5OqPr7IpeKPQ1LQEN0AI+yz7dMWe8UpKKk81hlwNiBYKeuAWsFC26BgTATDHaQ2
         O1JcseIb8QaI4645A+8gWeWqrRxU3WCK3yWEq0VFJn0VMWh5d+fMxaN2tQQNqFFzLWxq
         rGIovgnx8ufH6DeiA2bWtq6PYW0QHofUhPyw3G3kNIm7v30y/7HRqqJr0BaOGiO5QWru
         UKdFpbr855uWYujHuQlhucO1/nBvuNZYemsNnQC1dH1f6wDQYfi30OZtlmLOptZSdXee
         f2bw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=6l03A18+Pqx0Bv7bmfg+Mm9yI8h7Rad5qbP0y8DBm90=;
        b=PoeJY3Wh63ZpW8v3A4JpLwNQ7vBD1X4fh/hV/WC3IWL4vqddiu+EFHIurwY04bgFOe
         8DIoiuZSj8c7JqlsNtuamRlw8Kihxl7uUjnobHkHrUavFWqC5EtdcN0ils0h1EMRJOje
         +L0o7v81gNfc7mmee85eKjmTXflWtgLIP63SJdqcK8actIiWjTi8zkE5zu0aaBk18Qdy
         Ar4Fey4b5XtSxcojfMoo6JzJ2CrP0W+SlYog9Rdr9aaX1RveQjh5mnT9bsOso2X/SHXp
         fyVv4zRsWp5Vj/cnlYaqftTfvyeHZ7eq3Yfp39Vjo8waiPI2kJXMCYkiJMViaENC95WW
         u/Mw==
X-Gm-Message-State: APjAAAUNOZMNkBxYohw3eZqJCpM0cZkQ7mpDDqxNCsge1ksa0a39/NLG
        wmGVwZZSEkAxGaMgRyyzbsHOv+wR
X-Google-Smtp-Source: APXvYqx6sCUCT5O3vNTDb3cITgL6SkCyREADL6chLXwZ7KB5JSzpQO9y72xCC23umBuF+76O45n1zA==
X-Received: by 2002:a17:906:c742:: with SMTP id fk2mr4204015ejb.44.1568718653392;
        Tue, 17 Sep 2019 04:10:53 -0700 (PDT)
Received: from localhost.localdomain.com ([188.204.2.113])
        by smtp.gmail.com with ESMTPSA id a50sm376204eda.25.2019.09.17.04.10.52
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 17 Sep 2019 04:10:52 -0700 (PDT)
From:   Pascal van Leeuwen <pascalvanl@gmail.com>
X-Google-Original-From: Pascal van Leeuwen <pvanleeuwen@verimatrix.com>
To:     linux-crypto@vger.kernel.org
Cc:     antoine.tenart@bootlin.com, herbert@gondor.apana.org.au,
        davem@davemloft.net,
        Pascal van Leeuwen <pvanleeuwen@verimatrix.com>
Subject: [PATCH 3/3] crypto: inside-secure - Added support for the rfc4309(ccm(aes)) AEAD
Date:   Tue, 17 Sep 2019 12:08:01 +0200
Message-Id: <1568714881-30426-4-git-send-email-pvanleeuwen@verimatrix.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1568714881-30426-1-git-send-email-pvanleeuwen@verimatrix.com>
References: <1568714881-30426-1-git-send-email-pvanleeuwen@verimatrix.com>
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

This patch adds support for rfc4309(ccm(aes)) for use with IPsec ESP

Signed-off-by: Pascal van Leeuwen <pvanleeuwen@verimatrix.com>
---
 drivers/crypto/inside-secure/safexcel.c        |   1 +
 drivers/crypto/inside-secure/safexcel.h        |   5 +-
 drivers/crypto/inside-secure/safexcel_cipher.c | 165 +++++++++++++++++++------
 3 files changed, 134 insertions(+), 37 deletions(-)

diff --git a/drivers/crypto/inside-secure/safexcel.c b/drivers/crypto/inside-secure/safexcel.c
index 09d17f3..dc04112 100644
--- a/drivers/crypto/inside-secure/safexcel.c
+++ b/drivers/crypto/inside-secure/safexcel.c
@@ -1206,6 +1206,7 @@ static int safexcel_request_ring_irq(void *pdev, int irqid,
 	&safexcel_alg_authenc_hmac_sha384_cbc_des,
 	&safexcel_alg_rfc4106_gcm,
 	&safexcel_alg_rfc4543_gcm,
+	&safexcel_alg_rfc4309_ccm,
 };
 
 static int safexcel_register_algorithms(struct safexcel_crypto_priv *priv)
diff --git a/drivers/crypto/inside-secure/safexcel.h b/drivers/crypto/inside-secure/safexcel.h
index c172b97..e473dab 100644
--- a/drivers/crypto/inside-secure/safexcel.h
+++ b/drivers/crypto/inside-secure/safexcel.h
@@ -28,7 +28,7 @@
 
 /* Static configuration */
 #define EIP197_DEFAULT_RING_SIZE		400
-#define EIP197_MAX_TOKENS			18
+#define EIP197_MAX_TOKENS			19
 #define EIP197_MAX_RINGS			4
 #define EIP197_FETCH_DEPTH			2
 #define EIP197_MAX_BATCH_SZ			64
@@ -410,6 +410,8 @@ struct safexcel_context_record {
 #define EIP197_AEAD_TYPE_IPSEC_ESP_GMAC		3
 #define EIP197_AEAD_IPSEC_IV_SIZE		8
 #define EIP197_AEAD_IPSEC_NONCE_SIZE		4
+#define EIP197_AEAD_IPSEC_COUNTER_SIZE		4
+#define EIP197_AEAD_IPSEC_CCM_NONCE_SIZE	3
 
 /* The hash counter given to the engine in the context has a granularity of
  * 64 bits.
@@ -913,5 +915,6 @@ int safexcel_hmac_setkey(const char *alg, const u8 *key, unsigned int keylen,
 extern struct safexcel_alg_template safexcel_alg_authenc_hmac_sha384_cbc_des;
 extern struct safexcel_alg_template safexcel_alg_rfc4106_gcm;
 extern struct safexcel_alg_template safexcel_alg_rfc4543_gcm;
+extern struct safexcel_alg_template safexcel_alg_rfc4309_ccm;
 
 #endif
diff --git a/drivers/crypto/inside-secure/safexcel_cipher.c b/drivers/crypto/inside-secure/safexcel_cipher.c
index e895c5a..7702e22 100644
--- a/drivers/crypto/inside-secure/safexcel_cipher.c
+++ b/drivers/crypto/inside-secure/safexcel_cipher.c
@@ -86,7 +86,8 @@ static void safexcel_cipher_token(struct safexcel_cipher_ctx *ctx, u8 *iv,
 		/* 64 bit IV part */
 		memcpy(&cdesc->control_data.token[1], iv, 8);
 
-		if (ctx->alg == SAFEXCEL_CHACHA20) {
+		if (ctx->alg == SAFEXCEL_CHACHA20 ||
+		    ctx->xcm == EIP197_XCM_MODE_CCM) {
 			/* 32 bit counter, starting at 0 */
 			cdesc->control_data.token[3] = 0;
 		} else {
@@ -189,39 +190,39 @@ static void safexcel_aead_token(struct safexcel_cipher_ctx *ctx, u8 *iv,
 	if (direction == SAFEXCEL_ENCRYPT) {
 		/* align end of instruction sequence to end of token */
 		token = (struct safexcel_token *)(cdesc->control_data.token +
-			 EIP197_MAX_TOKENS - 13);
+			 EIP197_MAX_TOKENS - 14);
 
-		token[12].opcode = EIP197_TOKEN_OPCODE_INSERT;
-		token[12].packet_length = digestsize;
-		token[12].stat = EIP197_TOKEN_STAT_LAST_HASH |
+		token[13].opcode = EIP197_TOKEN_OPCODE_INSERT;
+		token[13].packet_length = digestsize;
+		token[13].stat = EIP197_TOKEN_STAT_LAST_HASH |
 				 EIP197_TOKEN_STAT_LAST_PACKET;
-		token[12].instructions = EIP197_TOKEN_INS_TYPE_OUTPUT |
+		token[13].instructions = EIP197_TOKEN_INS_TYPE_OUTPUT |
 					 EIP197_TOKEN_INS_INSERT_HASH_DIGEST;
 	} else {
 		cryptlen -= digestsize;
 
 		/* align end of instruction sequence to end of token */
 		token = (struct safexcel_token *)(cdesc->control_data.token +
-			 EIP197_MAX_TOKENS - 14);
+			 EIP197_MAX_TOKENS - 15);
 
-		token[12].opcode = EIP197_TOKEN_OPCODE_RETRIEVE;
-		token[12].packet_length = digestsize;
-		token[12].stat = EIP197_TOKEN_STAT_LAST_HASH |
+		token[13].opcode = EIP197_TOKEN_OPCODE_RETRIEVE;
+		token[13].packet_length = digestsize;
+		token[13].stat = EIP197_TOKEN_STAT_LAST_HASH |
 				 EIP197_TOKEN_STAT_LAST_PACKET;
-		token[12].instructions = EIP197_TOKEN_INS_INSERT_HASH_DIGEST;
+		token[13].instructions = EIP197_TOKEN_INS_INSERT_HASH_DIGEST;
 
-		token[13].opcode = EIP197_TOKEN_OPCODE_VERIFY;
-		token[13].packet_length = digestsize |
+		token[14].opcode = EIP197_TOKEN_OPCODE_VERIFY;
+		token[14].packet_length = digestsize |
 					  EIP197_TOKEN_HASH_RESULT_VERIFY;
-		token[13].stat = EIP197_TOKEN_STAT_LAST_HASH |
+		token[14].stat = EIP197_TOKEN_STAT_LAST_HASH |
 				 EIP197_TOKEN_STAT_LAST_PACKET;
-		token[13].instructions = EIP197_TOKEN_INS_TYPE_OUTPUT;
+		token[14].instructions = EIP197_TOKEN_INS_TYPE_OUTPUT;
 	}
 
 	if (ctx->aead == EIP197_AEAD_TYPE_IPSEC_ESP) {
 		/* For ESP mode (and not GMAC), skip over the IV */
-		token[7].opcode = EIP197_TOKEN_OPCODE_DIRECTION;
-		token[7].packet_length = EIP197_AEAD_IPSEC_IV_SIZE;
+		token[8].opcode = EIP197_TOKEN_OPCODE_DIRECTION;
+		token[8].packet_length = EIP197_AEAD_IPSEC_IV_SIZE;
 
 		assoclen -= EIP197_AEAD_IPSEC_IV_SIZE;
 	}
@@ -232,17 +233,17 @@ static void safexcel_aead_token(struct safexcel_cipher_ctx *ctx, u8 *iv,
 				EIP197_TOKEN_INS_TYPE_HASH;
 
 	if (likely(cryptlen || ctx->alg == SAFEXCEL_CHACHA20)) {
-		token[10].opcode = EIP197_TOKEN_OPCODE_DIRECTION;
-		token[10].packet_length = cryptlen;
-		token[10].stat = EIP197_TOKEN_STAT_LAST_HASH;
+		token[11].opcode = EIP197_TOKEN_OPCODE_DIRECTION;
+		token[11].packet_length = cryptlen;
+		token[11].stat = EIP197_TOKEN_STAT_LAST_HASH;
 		if (unlikely(ctx->aead == EIP197_AEAD_TYPE_IPSEC_ESP_GMAC)) {
 			token[6].instructions = EIP197_TOKEN_INS_TYPE_HASH;
 			/* Do not send to crypt engine in case of GMAC */
-			token[10].instructions = EIP197_TOKEN_INS_LAST |
+			token[11].instructions = EIP197_TOKEN_INS_LAST |
 						 EIP197_TOKEN_INS_TYPE_HASH |
 						 EIP197_TOKEN_INS_TYPE_OUTPUT;
 		} else {
-			token[10].instructions = EIP197_TOKEN_INS_LAST |
+			token[11].instructions = EIP197_TOKEN_INS_LAST |
 						 EIP197_TOKEN_INS_TYPE_CRYPTO |
 						 EIP197_TOKEN_INS_TYPE_HASH |
 						 EIP197_TOKEN_INS_TYPE_OUTPUT;
@@ -254,16 +255,17 @@ static void safexcel_aead_token(struct safexcel_cipher_ctx *ctx, u8 *iv,
 	if (!ctx->xcm)
 		return;
 
-	token[8].opcode = EIP197_TOKEN_OPCODE_INSERT_REMRES;
-	token[8].packet_length = 0;
-	token[8].instructions = AES_BLOCK_SIZE;
+	token[9].opcode = EIP197_TOKEN_OPCODE_INSERT_REMRES;
+	token[9].packet_length = 0;
+	token[9].instructions = AES_BLOCK_SIZE;
 
-	token[9].opcode = EIP197_TOKEN_OPCODE_INSERT;
-	token[9].packet_length = AES_BLOCK_SIZE;
-	token[9].instructions = EIP197_TOKEN_INS_TYPE_OUTPUT |
-				EIP197_TOKEN_INS_TYPE_CRYPTO;
+	token[10].opcode = EIP197_TOKEN_OPCODE_INSERT;
+	token[10].packet_length = AES_BLOCK_SIZE;
+	token[10].instructions = EIP197_TOKEN_INS_TYPE_OUTPUT |
+				 EIP197_TOKEN_INS_TYPE_CRYPTO;
 
 	if (ctx->xcm != EIP197_XCM_MODE_GCM) {
+		u8 *final_iv = (u8 *)cdesc->control_data.token;
 		u8 *cbcmaciv = (u8 *)&token[1];
 		u32 *aadlen = (u32 *)&token[5];
 
@@ -274,11 +276,11 @@ static void safexcel_aead_token(struct safexcel_cipher_ctx *ctx, u8 *iv,
 		token[0].instructions = EIP197_TOKEN_INS_ORIGIN_TOKEN |
 					EIP197_TOKEN_INS_TYPE_HASH;
 		/* Variable length IV part */
-		memcpy(cbcmaciv, iv, 15 - iv[0]);
+		memcpy(cbcmaciv, final_iv, 15 - final_iv[0]);
 		/* fixup flags byte */
 		cbcmaciv[0] |= ((assoclen > 0) << 6) | ((digestsize - 2) << 2);
 		/* Clear upper bytes of variable message length to 0 */
-		memset(cbcmaciv + 15 - iv[0], 0, iv[0] - 1);
+		memset(cbcmaciv + 15 - final_iv[0], 0, final_iv[0] - 1);
 		/* insert lower 2 bytes of message length */
 		cbcmaciv[14] = cryptlen >> 8;
 		cbcmaciv[15] = cryptlen & 255;
@@ -299,13 +301,13 @@ static void safexcel_aead_token(struct safexcel_cipher_ctx *ctx, u8 *iv,
 			token[7].instructions = EIP197_TOKEN_INS_TYPE_HASH;
 
 			/* Align crypto data towards hash engine */
-			token[10].stat = 0;
+			token[11].stat = 0;
 
-			token[11].opcode = EIP197_TOKEN_OPCODE_INSERT;
+			token[12].opcode = EIP197_TOKEN_OPCODE_INSERT;
 			cryptlen &= 15;
-			token[11].packet_length = cryptlen ? 16 - cryptlen : 0;
-			token[11].stat = EIP197_TOKEN_STAT_LAST_HASH;
-			token[11].instructions = EIP197_TOKEN_INS_TYPE_HASH;
+			token[12].packet_length = cryptlen ? 16 - cryptlen : 0;
+			token[12].stat = EIP197_TOKEN_STAT_LAST_HASH;
+			token[12].instructions = EIP197_TOKEN_INS_TYPE_HASH;
 		} else {
 			token[7].stat = EIP197_TOKEN_STAT_LAST_HASH;
 			token[7].instructions = EIP197_TOKEN_INS_LAST |
@@ -3550,3 +3552,94 @@ struct safexcel_alg_template safexcel_alg_rfc4543_gcm = {
 		},
 	},
 };
+
+static int safexcel_rfc4309_ccm_setkey(struct crypto_aead *ctfm, const u8 *key,
+				       unsigned int len)
+{
+	struct crypto_tfm *tfm = crypto_aead_tfm(ctfm);
+	struct safexcel_cipher_ctx *ctx = crypto_tfm_ctx(tfm);
+
+	/* First byte of the nonce = L = always 3 for RFC4309 (4 byte ctr) */
+	*(u8 *)&ctx->nonce = EIP197_AEAD_IPSEC_COUNTER_SIZE - 1;
+	/* last 3 bytes of key are the nonce! */
+	memcpy((u8 *)&ctx->nonce + 1, key + len -
+	       EIP197_AEAD_IPSEC_CCM_NONCE_SIZE,
+	       EIP197_AEAD_IPSEC_CCM_NONCE_SIZE);
+
+	len -= EIP197_AEAD_IPSEC_CCM_NONCE_SIZE;
+	return safexcel_aead_ccm_setkey(ctfm, key, len);
+}
+
+static int safexcel_rfc4309_ccm_setauthsize(struct crypto_aead *tfm,
+					    unsigned int authsize)
+{
+	/* Borrowed from crypto/ccm.c */
+	switch (authsize) {
+	case 8:
+	case 12:
+	case 16:
+		break;
+	default:
+		return -EINVAL;
+	}
+
+	return 0;
+}
+
+static int safexcel_rfc4309_ccm_encrypt(struct aead_request *req)
+{
+	struct safexcel_cipher_req *creq = aead_request_ctx(req);
+
+	/* Borrowed from crypto/ccm.c */
+	if (req->assoclen != 16 && req->assoclen != 20)
+		return -EINVAL;
+
+	return safexcel_queue_req(&req->base, creq, SAFEXCEL_ENCRYPT);
+}
+
+static int safexcel_rfc4309_ccm_decrypt(struct aead_request *req)
+{
+	struct safexcel_cipher_req *creq = aead_request_ctx(req);
+
+	/* Borrowed from crypto/ccm.c */
+	if (req->assoclen != 16 && req->assoclen != 20)
+		return -EINVAL;
+
+	return safexcel_queue_req(&req->base, creq, SAFEXCEL_DECRYPT);
+}
+
+static int safexcel_rfc4309_ccm_cra_init(struct crypto_tfm *tfm)
+{
+	struct safexcel_cipher_ctx *ctx = crypto_tfm_ctx(tfm);
+	int ret;
+
+	ret = safexcel_aead_ccm_cra_init(tfm);
+	ctx->aead  = EIP197_AEAD_TYPE_IPSEC_ESP;
+	return ret;
+}
+
+struct safexcel_alg_template safexcel_alg_rfc4309_ccm = {
+	.type = SAFEXCEL_ALG_TYPE_AEAD,
+	.algo_mask = SAFEXCEL_ALG_AES | SAFEXCEL_ALG_CBC_MAC_ALL,
+	.alg.aead = {
+		.setkey = safexcel_rfc4309_ccm_setkey,
+		.setauthsize = safexcel_rfc4309_ccm_setauthsize,
+		.encrypt = safexcel_rfc4309_ccm_encrypt,
+		.decrypt = safexcel_rfc4309_ccm_decrypt,
+		.ivsize = EIP197_AEAD_IPSEC_IV_SIZE,
+		.maxauthsize = AES_BLOCK_SIZE,
+		.base = {
+			.cra_name = "rfc4309(ccm(aes))",
+			.cra_driver_name = "safexcel-rfc4309-ccm-aes",
+			.cra_priority = SAFEXCEL_CRA_PRIORITY,
+			.cra_flags = CRYPTO_ALG_ASYNC |
+				     CRYPTO_ALG_KERN_DRIVER_ONLY,
+			.cra_blocksize = 1,
+			.cra_ctxsize = sizeof(struct safexcel_cipher_ctx),
+			.cra_alignmask = 0,
+			.cra_init = safexcel_rfc4309_ccm_cra_init,
+			.cra_exit = safexcel_aead_cra_exit,
+			.cra_module = THIS_MODULE,
+		},
+	},
+};
-- 
1.8.3.1

