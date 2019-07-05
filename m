Return-Path: <SRS0=kkEj=VC=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.0 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6F846C5B57D
	for <linux-crypto@archiver.kernel.org>; Fri,  5 Jul 2019 07:53:12 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 3A1D920843
	for <linux-crypto@archiver.kernel.org>; Fri,  5 Jul 2019 07:53:12 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="U+OftVS/"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728080AbfGEHxL (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 5 Jul 2019 03:53:11 -0400
Received: from mail-ed1-f46.google.com ([209.85.208.46]:35430 "EHLO
        mail-ed1-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727822AbfGEHxL (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 5 Jul 2019 03:53:11 -0400
Received: by mail-ed1-f46.google.com with SMTP id w20so7431835edd.2
        for <linux-crypto@vger.kernel.org>; Fri, 05 Jul 2019 00:53:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=eg9UGsSD/QBvispMpDfmw5tOOX5RhkGB6QaG82+VgBk=;
        b=U+OftVS/vA6WjKduUv29mJ7X3MBblxKh9FLAcAZVbmBqAcVQ373uysz8DPfpGxzZdH
         +Lo+D4x23NEZm39kC9Ft9YgdS7qQ0txNWErzOMHxlDzASuhXtFYMopNs01BpC2aNuA6t
         VIM/9UTKwUBmryWzpo6cX2rddZqm1+ZezFyn24F+MWSVnqasQLWme/AadvALlu/b3jO6
         8RWcAVCEW+EoPL3KcaZN7bfv4+V5d3ZuAISlFS95t3LrHFJSwviLdHNgk3GBdSAKZhXt
         K/1/QRIVz2p53/JzKWVJzSZBjuT8kP3V+nKBWya3sFR3oXtFUE0R9bjRsyAFx/0MQm06
         iXbQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=eg9UGsSD/QBvispMpDfmw5tOOX5RhkGB6QaG82+VgBk=;
        b=kQD2s07ggtUbQZ5zS08Tem/46SVDMUdv5msoQipBpZA2SAUoxJ1IBbrNafG9cJphSc
         e6TXI4j+4kCOQqhFZDB4D82YFeTgVoOH+06kMQtqSkjRKTDKDKEpeUFkS8qFYsJdMqgE
         JoZfzGI4LmUoH7VDc0UXRNxkFsRZVdCJnEYOWcnglh4liynw0cPnIF8SOA9Bfrb6mvSR
         BRJW67VEe0BRPXN/SLOg0FZi6Jb0j1ODjSddR7H7Q4rPYbkzA+/MrnilpLnexSdVPF5R
         Lr7qxfYeTlYPOCV1o2TGz3JPKPFdbuMCS2L66cBKSYub9X/GYIYKSOUerkzX+qnSqbIy
         P9qA==
X-Gm-Message-State: APjAAAV7ScSzLkP18hCN/mvxgeAowY4aqkFxkj7BIY8uq0GkCQHXzjJv
        zzxey2wdKO+vyscOZz7Ug3h6TR2F
X-Google-Smtp-Source: APXvYqwC6A/YRxnACcmYiKfZyQJLYPYQ69JPt8GDG4riz2rTbfB7cDY7kirKzmxzJFU0Dn1SpTRXaA==
X-Received: by 2002:aa7:d28a:: with SMTP id w10mr2881415edq.251.1562313188462;
        Fri, 05 Jul 2019 00:53:08 -0700 (PDT)
Received: from localhost.localdomain.com ([188.204.2.113])
        by smtp.gmail.com with ESMTPSA id z2sm1551438ejp.73.2019.07.05.00.53.07
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Fri, 05 Jul 2019 00:53:07 -0700 (PDT)
From:   Pascal van Leeuwen <pascalvanl@gmail.com>
X-Google-Original-From: Pascal van Leeuwen <pvanleeuwen@verimatrix.com>
To:     linux-crypto@vger.kernel.org
Cc:     antoine.tenart@bootlin.com, herbert@gondor.apana.org.au,
        davem@davemloft.net,
        Pascal van Leeuwen <pvanleeuwen@verimatrix.com>
Subject: [PATCH 1/3] crypto: inside-secure - add support for authenc(hmac(sha1),cbc(des3_ede))
Date:   Fri,  5 Jul 2019 08:49:22 +0200
Message-Id: <1562309364-942-2-git-send-email-pvanleeuwen@verimatrix.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1562309364-942-1-git-send-email-pvanleeuwen@verimatrix.com>
References: <1562309364-942-1-git-send-email-pvanleeuwen@verimatrix.com>
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Signed-off-by: Pascal van Leeuwen <pvanleeuwen@verimatrix.com>
---
 drivers/crypto/inside-secure/safexcel.c        |  1 +
 drivers/crypto/inside-secure/safexcel.h        |  1 +
 drivers/crypto/inside-secure/safexcel_cipher.c | 89 ++++++++++++++++++++------
 3 files changed, 72 insertions(+), 19 deletions(-)

diff --git a/drivers/crypto/inside-secure/safexcel.c b/drivers/crypto/inside-secure/safexcel.c
index 8e8c01d..c3bb177 100644
--- a/drivers/crypto/inside-secure/safexcel.c
+++ b/drivers/crypto/inside-secure/safexcel.c
@@ -1004,6 +1004,7 @@ static int safexcel_request_ring_irq(void *pdev, int irqid,
 	&safexcel_alg_authenc_hmac_sha256_cbc_aes,
 	&safexcel_alg_authenc_hmac_sha384_cbc_aes,
 	&safexcel_alg_authenc_hmac_sha512_cbc_aes,
+	&safexcel_alg_authenc_hmac_sha1_cbc_des3_ede,
 };
 
 static int safexcel_register_algorithms(struct safexcel_crypto_priv *priv)
diff --git a/drivers/crypto/inside-secure/safexcel.h b/drivers/crypto/inside-secure/safexcel.h
index b68fec3..765f481 100644
--- a/drivers/crypto/inside-secure/safexcel.h
+++ b/drivers/crypto/inside-secure/safexcel.h
@@ -765,5 +765,6 @@ int safexcel_hmac_setkey(const char *alg, const u8 *key, unsigned int keylen,
 extern struct safexcel_alg_template safexcel_alg_authenc_hmac_sha256_cbc_aes;
 extern struct safexcel_alg_template safexcel_alg_authenc_hmac_sha384_cbc_aes;
 extern struct safexcel_alg_template safexcel_alg_authenc_hmac_sha512_cbc_aes;
+extern struct safexcel_alg_template safexcel_alg_authenc_hmac_sha1_cbc_des3_ede;
 
 #endif
diff --git a/drivers/crypto/inside-secure/safexcel_cipher.c b/drivers/crypto/inside-secure/safexcel_cipher.c
index ea122dd..5eed890 100644
--- a/drivers/crypto/inside-secure/safexcel_cipher.c
+++ b/drivers/crypto/inside-secure/safexcel_cipher.c
@@ -183,14 +183,16 @@ static int safexcel_skcipher_aes_setkey(struct crypto_skcipher *ctfm,
 	return 0;
 }
 
-static int safexcel_aead_aes_setkey(struct crypto_aead *ctfm, const u8 *key,
-				    unsigned int len)
+static int safexcel_aead_setkey(struct crypto_aead *ctfm, const u8 *key,
+				unsigned int len)
 {
 	struct crypto_tfm *tfm = crypto_aead_tfm(ctfm);
 	struct safexcel_cipher_ctx *ctx = crypto_tfm_ctx(tfm);
 	struct safexcel_ahash_export_state istate, ostate;
 	struct safexcel_crypto_priv *priv = ctx->priv;
 	struct crypto_authenc_keys keys;
+	u32 flags;
+	int err;
 
 	if (crypto_authenc_extractkeys(&keys, key, len) != 0)
 		goto badkey;
@@ -199,6 +201,15 @@ static int safexcel_aead_aes_setkey(struct crypto_aead *ctfm, const u8 *key,
 		goto badkey;
 
 	/* Encryption key */
+	if (ctx->alg == SAFEXCEL_3DES) {
+		flags = crypto_aead_get_flags(ctfm);
+		err = __des3_verify_key(&flags, keys.enckey);
+		crypto_aead_set_flags(ctfm, flags);
+
+		if (unlikely(err))
+			return err;
+	}
+
 	if (priv->flags & EIP197_TRC_CACHE && ctx->base.ctxr_dma &&
 	    memcmp(ctx->key, keys.enckey, keys.enckeylen))
 		ctx->base.needs_inv = true;
@@ -1240,7 +1251,7 @@ struct safexcel_alg_template safexcel_alg_ecb_des3_ede = {
 	},
 };
 
-static int safexcel_aead_encrypt(struct aead_request *req)
+static int safexcel_aead_encrypt_aes(struct aead_request *req)
 {
 	struct safexcel_cipher_req *creq = aead_request_ctx(req);
 
@@ -1248,7 +1259,7 @@ static int safexcel_aead_encrypt(struct aead_request *req)
 			CONTEXT_CONTROL_CRYPTO_MODE_CBC, SAFEXCEL_AES);
 }
 
-static int safexcel_aead_decrypt(struct aead_request *req)
+static int safexcel_aead_decrypt_aes(struct aead_request *req)
 {
 	struct safexcel_cipher_req *creq = aead_request_ctx(req);
 
@@ -1287,9 +1298,9 @@ static int safexcel_aead_sha1_cra_init(struct crypto_tfm *tfm)
 struct safexcel_alg_template safexcel_alg_authenc_hmac_sha1_cbc_aes = {
 	.type = SAFEXCEL_ALG_TYPE_AEAD,
 	.alg.aead = {
-		.setkey = safexcel_aead_aes_setkey,
-		.encrypt = safexcel_aead_encrypt,
-		.decrypt = safexcel_aead_decrypt,
+		.setkey = safexcel_aead_setkey,
+		.encrypt = safexcel_aead_encrypt_aes,
+		.decrypt = safexcel_aead_decrypt_aes,
 		.ivsize = AES_BLOCK_SIZE,
 		.maxauthsize = SHA1_DIGEST_SIZE,
 		.base = {
@@ -1321,9 +1332,9 @@ static int safexcel_aead_sha256_cra_init(struct crypto_tfm *tfm)
 struct safexcel_alg_template safexcel_alg_authenc_hmac_sha256_cbc_aes = {
 	.type = SAFEXCEL_ALG_TYPE_AEAD,
 	.alg.aead = {
-		.setkey = safexcel_aead_aes_setkey,
-		.encrypt = safexcel_aead_encrypt,
-		.decrypt = safexcel_aead_decrypt,
+		.setkey = safexcel_aead_setkey,
+		.encrypt = safexcel_aead_encrypt_aes,
+		.decrypt = safexcel_aead_decrypt_aes,
 		.ivsize = AES_BLOCK_SIZE,
 		.maxauthsize = SHA256_DIGEST_SIZE,
 		.base = {
@@ -1355,9 +1366,9 @@ static int safexcel_aead_sha224_cra_init(struct crypto_tfm *tfm)
 struct safexcel_alg_template safexcel_alg_authenc_hmac_sha224_cbc_aes = {
 	.type = SAFEXCEL_ALG_TYPE_AEAD,
 	.alg.aead = {
-		.setkey = safexcel_aead_aes_setkey,
-		.encrypt = safexcel_aead_encrypt,
-		.decrypt = safexcel_aead_decrypt,
+		.setkey = safexcel_aead_setkey,
+		.encrypt = safexcel_aead_encrypt_aes,
+		.decrypt = safexcel_aead_decrypt_aes,
 		.ivsize = AES_BLOCK_SIZE,
 		.maxauthsize = SHA224_DIGEST_SIZE,
 		.base = {
@@ -1389,9 +1400,9 @@ static int safexcel_aead_sha512_cra_init(struct crypto_tfm *tfm)
 struct safexcel_alg_template safexcel_alg_authenc_hmac_sha512_cbc_aes = {
 	.type = SAFEXCEL_ALG_TYPE_AEAD,
 	.alg.aead = {
-		.setkey = safexcel_aead_aes_setkey,
-		.encrypt = safexcel_aead_encrypt,
-		.decrypt = safexcel_aead_decrypt,
+		.setkey = safexcel_aead_setkey,
+		.encrypt = safexcel_aead_encrypt_aes,
+		.decrypt = safexcel_aead_decrypt_aes,
 		.ivsize = AES_BLOCK_SIZE,
 		.maxauthsize = SHA512_DIGEST_SIZE,
 		.base = {
@@ -1423,9 +1434,9 @@ static int safexcel_aead_sha384_cra_init(struct crypto_tfm *tfm)
 struct safexcel_alg_template safexcel_alg_authenc_hmac_sha384_cbc_aes = {
 	.type = SAFEXCEL_ALG_TYPE_AEAD,
 	.alg.aead = {
-		.setkey = safexcel_aead_aes_setkey,
-		.encrypt = safexcel_aead_encrypt,
-		.decrypt = safexcel_aead_decrypt,
+		.setkey = safexcel_aead_setkey,
+		.encrypt = safexcel_aead_encrypt_aes,
+		.decrypt = safexcel_aead_decrypt_aes,
 		.ivsize = AES_BLOCK_SIZE,
 		.maxauthsize = SHA384_DIGEST_SIZE,
 		.base = {
@@ -1443,3 +1454,43 @@ struct safexcel_alg_template safexcel_alg_authenc_hmac_sha384_cbc_aes = {
 		},
 	},
 };
+
+static int safexcel_aead_encrypt_3des(struct aead_request *req)
+{
+	struct safexcel_cipher_req *creq = aead_request_ctx(req);
+
+	return safexcel_queue_req(&req->base, creq, SAFEXCEL_ENCRYPT,
+			CONTEXT_CONTROL_CRYPTO_MODE_CBC, SAFEXCEL_3DES);
+}
+
+static int safexcel_aead_decrypt_3des(struct aead_request *req)
+{
+	struct safexcel_cipher_req *creq = aead_request_ctx(req);
+
+	return safexcel_queue_req(&req->base, creq, SAFEXCEL_DECRYPT,
+			CONTEXT_CONTROL_CRYPTO_MODE_CBC, SAFEXCEL_3DES);
+}
+
+struct safexcel_alg_template safexcel_alg_authenc_hmac_sha1_cbc_des3_ede = {
+	.type = SAFEXCEL_ALG_TYPE_AEAD,
+	.alg.aead = {
+		.setkey = safexcel_aead_setkey,
+		.encrypt = safexcel_aead_encrypt_3des,
+		.decrypt = safexcel_aead_decrypt_3des,
+		.ivsize = DES3_EDE_BLOCK_SIZE,
+		.maxauthsize = SHA1_DIGEST_SIZE,
+		.base = {
+			.cra_name = "authenc(hmac(sha1),cbc(des3_ede))",
+			.cra_driver_name = "safexcel-authenc-hmac-sha1-cbc-des3_ede",
+			.cra_priority = 300,
+			.cra_flags = CRYPTO_ALG_ASYNC |
+				     CRYPTO_ALG_KERN_DRIVER_ONLY,
+			.cra_blocksize = DES3_EDE_BLOCK_SIZE,
+			.cra_ctxsize = sizeof(struct safexcel_cipher_ctx),
+			.cra_alignmask = 0,
+			.cra_init = safexcel_aead_sha1_cra_init,
+			.cra_exit = safexcel_aead_cra_exit,
+			.cra_module = THIS_MODULE,
+		},
+	},
+};
-- 
1.8.3.1

