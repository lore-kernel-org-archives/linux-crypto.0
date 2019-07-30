Return-Path: <SRS0=RABd=V3=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3F605C0650F
	for <linux-crypto@archiver.kernel.org>; Tue, 30 Jul 2019 14:29:42 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 08FAB205C9
	for <linux-crypto@archiver.kernel.org>; Tue, 30 Jul 2019 14:29:42 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="WMOMvmTA"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729808AbfG3O3l (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Tue, 30 Jul 2019 10:29:41 -0400
Received: from mail-ed1-f68.google.com ([209.85.208.68]:41340 "EHLO
        mail-ed1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727865AbfG3O3l (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 30 Jul 2019 10:29:41 -0400
Received: by mail-ed1-f68.google.com with SMTP id p15so62723479eds.8
        for <linux-crypto@vger.kernel.org>; Tue, 30 Jul 2019 07:29:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=78kZgWpqSSTCCuZ5ltpdhVyq87ITsr0X9K7O3fB2j7I=;
        b=WMOMvmTAaMTD7SihiDCuyL85LOiz6t5S0pi9zeCHlEoCX4VobvYS92Ml2Ai8jIA5ko
         VpRjKoHNauPipB4IduCZ6vqZ4dwTuXaXw5G7UAnQQEimtKMtOUI7sBwjheARLTYWLFhz
         PNiNvxrmBuV0trtWk6I4QNLupas+ZXU42QxfGC13SWlDL0qEBD5uhzk1Fdr7NArFxMU+
         k/ojvxlno0KCBf34bYR3Bl5Hhvwhf2shPyRTR+c4pAqZwRvY/sW40zDy6ZzOP5k6oh7i
         TTdSDbBLeh2CoVjJkaC8XOm6buBsJJGPOfRp6ZbGIzJw+H8P0ZrHXMJno5IasagLi6sl
         C8eA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=78kZgWpqSSTCCuZ5ltpdhVyq87ITsr0X9K7O3fB2j7I=;
        b=VxdNj2Vz7JFn5PLUYKnHpKslzMW10wWa15o4d39KaCGy8N2zg750cR8b48FKL0t6/x
         xFLcKiCXdm6EN19hUzAI+xxonjWcu+RkVsKdMqj6JwZchNPBwk23rdO0/7ZkR4OV/enO
         mHkjGvS35/2Y4XvHh+NgFsbClvNj4kkStXdqN7DeXufX9fZPmBr9On3EJ1YTcaaJ0GIB
         K630ppzhHQg/GEj5FuVHn805Nn8Zs1WN9VKD/UOKVR311PdA8baLVKHEl+JfMP6a/LSQ
         LXeP+qBcdC6OhhL+PFPQT8unOnK/D/6kqOWcq3/ln2han2+U/Mn4QecUN4uwHRgZFEAU
         1KRg==
X-Gm-Message-State: APjAAAUr4xVHizlKdKUCgzgR5JTztJholC5+Ms8iR7cxyOgJ3bR1LGFW
        85NpxlWT8PryEN/fbYY6I7683xIr
X-Google-Smtp-Source: APXvYqyitC1mk7EPyV2Ae7UyC9Q1y9zB1uSNHLedM2czEzLStOF6mBeuVJiFy3/KdLHg01NkMDy6+w==
X-Received: by 2002:a17:906:2289:: with SMTP id p9mr30503978eja.249.1564496978682;
        Tue, 30 Jul 2019 07:29:38 -0700 (PDT)
Received: from localhost.localdomain.com ([188.204.2.113])
        by smtp.gmail.com with ESMTPSA id e29sm15240776eda.51.2019.07.30.07.29.37
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 30 Jul 2019 07:29:37 -0700 (PDT)
From:   Pascal van Leeuwen <pascalvanl@gmail.com>
X-Google-Original-From: Pascal van Leeuwen <pvanleeuwen@verimatrix.com>
To:     linux-crypto@vger.kernel.org
Cc:     antoine.tenart@bootlin.com, herbert@gondor.apana.org.au,
        davem@davemloft.net,
        Pascal van Leeuwen <pvanleeuwen@verimatrix.com>
Subject: [PATCH 1/2] crypto: inside-secure - Use defines instead of some constants (cosmetic)
Date:   Tue, 30 Jul 2019 15:27:11 +0200
Message-Id: <1564493232-30733-2-git-send-email-pvanleeuwen@verimatrix.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1564493232-30733-1-git-send-email-pvanleeuwen@verimatrix.com>
References: <1564493232-30733-1-git-send-email-pvanleeuwen@verimatrix.com>
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

This patch replaces some hard constants regarding key, IV and nonce sizes
with appropriate defines from the crypto header files.

Signed-off-by: Pascal van Leeuwen <pvanleeuwen@verimatrix.com>
---
 drivers/crypto/inside-secure/safexcel_cipher.c | 35 ++++++++++++++------------
 1 file changed, 19 insertions(+), 16 deletions(-)

diff --git a/drivers/crypto/inside-secure/safexcel_cipher.c b/drivers/crypto/inside-secure/safexcel_cipher.c
index d65e5f7..a30fdd5 100644
--- a/drivers/crypto/inside-secure/safexcel_cipher.c
+++ b/drivers/crypto/inside-secure/safexcel_cipher.c
@@ -12,6 +12,7 @@
 #include <crypto/aead.h>
 #include <crypto/aes.h>
 #include <crypto/authenc.h>
+#include <crypto/ctr.h>
 #include <crypto/des.h>
 #include <crypto/sha.h>
 #include <crypto/skcipher.h>
@@ -237,19 +238,21 @@ static int safexcel_aead_setkey(struct crypto_aead *ctfm, const u8 *key,
 		goto badkey;
 
 	if (ctx->mode == CONTEXT_CONTROL_CRYPTO_MODE_CTR_LOAD) {
-		/* 20 is minimum AES key: 16 bytes + 4 bytes nonce */
-		if (keys.enckeylen < 20)
+		/* Minimum keysize is minimum AES key size + nonce size */
+		if (keys.enckeylen < (AES_MIN_KEY_SIZE +
+				      CTR_RFC3686_NONCE_SIZE))
 			goto badkey;
 		/* last 4 bytes of key are the nonce! */
-		ctx->nonce = *(u32 *)(keys.enckey + keys.enckeylen - 4);
+		ctx->nonce = *(u32 *)(keys.enckey + keys.enckeylen -
+				      CTR_RFC3686_NONCE_SIZE);
 		/* exclude the nonce here */
-		keys.enckeylen -= 4;
+		keys.enckeylen -= CONTEXT_CONTROL_CRYPTO_MODE_CTR_LOAD;
 	}
 
 	/* Encryption key */
 	switch (ctx->alg) {
 	case SAFEXCEL_3DES:
-		if (keys.enckeylen != 24)
+		if (keys.enckeylen != DES3_EDE_KEY_SIZE)
 			goto badkey;
 		flags = crypto_aead_get_flags(ctfm);
 		err = __des3_verify_key(&flags, keys.enckey);
@@ -1114,9 +1117,9 @@ static int safexcel_skcipher_aesctr_setkey(struct crypto_skcipher *ctfm,
 	unsigned int keylen;
 
 	/* last 4 bytes of key are the nonce! */
-	ctx->nonce = *(u32 *)(key + len - 4);
+	ctx->nonce = *(u32 *)(key + len - CTR_RFC3686_NONCE_SIZE);
 	/* exclude the nonce here */
-	keylen = len - 4;
+	keylen = len - CTR_RFC3686_NONCE_SIZE;
 	ret = crypto_aes_expand_key(&aes, key, keylen);
 	if (ret) {
 		crypto_skcipher_set_flags(ctfm, CRYPTO_TFM_RES_BAD_KEY_LEN);
@@ -1157,10 +1160,10 @@ struct safexcel_alg_template safexcel_alg_ctr_aes = {
 		.setkey = safexcel_skcipher_aesctr_setkey,
 		.encrypt = safexcel_encrypt,
 		.decrypt = safexcel_decrypt,
-		/* Add 4 to include the 4 byte nonce! */
-		.min_keysize = AES_MIN_KEY_SIZE + 4,
-		.max_keysize = AES_MAX_KEY_SIZE + 4,
-		.ivsize = 8,
+		/* Add nonce size */
+		.min_keysize = AES_MIN_KEY_SIZE + CTR_RFC3686_NONCE_SIZE,
+		.max_keysize = AES_MAX_KEY_SIZE + CTR_RFC3686_NONCE_SIZE,
+		.ivsize = CTR_RFC3686_IV_SIZE,
 		.base = {
 			.cra_name = "rfc3686(ctr(aes))",
 			.cra_driver_name = "safexcel-ctr-aes",
@@ -1620,7 +1623,7 @@ struct safexcel_alg_template safexcel_alg_authenc_hmac_sha1_ctr_aes = {
 		.setkey = safexcel_aead_setkey,
 		.encrypt = safexcel_aead_encrypt,
 		.decrypt = safexcel_aead_decrypt,
-		.ivsize = 8,
+		.ivsize = CTR_RFC3686_IV_SIZE,
 		.maxauthsize = SHA1_DIGEST_SIZE,
 		.base = {
 			.cra_name = "authenc(hmac(sha1),rfc3686(ctr(aes)))",
@@ -1653,7 +1656,7 @@ struct safexcel_alg_template safexcel_alg_authenc_hmac_sha256_ctr_aes = {
 		.setkey = safexcel_aead_setkey,
 		.encrypt = safexcel_aead_encrypt,
 		.decrypt = safexcel_aead_decrypt,
-		.ivsize = 8,
+		.ivsize = CTR_RFC3686_IV_SIZE,
 		.maxauthsize = SHA256_DIGEST_SIZE,
 		.base = {
 			.cra_name = "authenc(hmac(sha256),rfc3686(ctr(aes)))",
@@ -1686,7 +1689,7 @@ struct safexcel_alg_template safexcel_alg_authenc_hmac_sha224_ctr_aes = {
 		.setkey = safexcel_aead_setkey,
 		.encrypt = safexcel_aead_encrypt,
 		.decrypt = safexcel_aead_decrypt,
-		.ivsize = 8,
+		.ivsize = CTR_RFC3686_IV_SIZE,
 		.maxauthsize = SHA224_DIGEST_SIZE,
 		.base = {
 			.cra_name = "authenc(hmac(sha224),rfc3686(ctr(aes)))",
@@ -1719,7 +1722,7 @@ struct safexcel_alg_template safexcel_alg_authenc_hmac_sha512_ctr_aes = {
 		.setkey = safexcel_aead_setkey,
 		.encrypt = safexcel_aead_encrypt,
 		.decrypt = safexcel_aead_decrypt,
-		.ivsize = 8,
+		.ivsize = CTR_RFC3686_IV_SIZE,
 		.maxauthsize = SHA512_DIGEST_SIZE,
 		.base = {
 			.cra_name = "authenc(hmac(sha512),rfc3686(ctr(aes)))",
@@ -1752,7 +1755,7 @@ struct safexcel_alg_template safexcel_alg_authenc_hmac_sha384_ctr_aes = {
 		.setkey = safexcel_aead_setkey,
 		.encrypt = safexcel_aead_encrypt,
 		.decrypt = safexcel_aead_decrypt,
-		.ivsize = 8,
+		.ivsize = CTR_RFC3686_IV_SIZE,
 		.maxauthsize = SHA384_DIGEST_SIZE,
 		.base = {
 			.cra_name = "authenc(hmac(sha384),rfc3686(ctr(aes)))",
-- 
1.8.3.1

