Return-Path: <SRS0=LpGJ=WP=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.6 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0AB5CC3A5A0
	for <linux-crypto@archiver.kernel.org>; Mon, 19 Aug 2019 15:43:10 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id C060F206BB
	for <linux-crypto@archiver.kernel.org>; Mon, 19 Aug 2019 15:43:09 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="n0czfQIz"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726987AbfHSPnJ (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Mon, 19 Aug 2019 11:43:09 -0400
Received: from mail-ed1-f49.google.com ([209.85.208.49]:42516 "EHLO
        mail-ed1-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726918AbfHSPnI (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 19 Aug 2019 11:43:08 -0400
Received: by mail-ed1-f49.google.com with SMTP id m44so2075881edd.9
        for <linux-crypto@vger.kernel.org>; Mon, 19 Aug 2019 08:43:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=Sjn6JMGlEE7w/cFxbQ0CsTf2q8mFxojwCr9kf4vhksI=;
        b=n0czfQIzvxAYY+H1nxNxABWxpVU1LDK783f1K9/e+j/RsWxao6QSod5iRwZ9gAhKf9
         hBZtTpKUFp5MTUMEhkIVZWPaDbhgvXDH4k2ZVYAeH9zDPqh5GCWcxNW9QYUOPIpEypvc
         fpYplR+q7N0ahWcChj3vIJr1FKW6RXgQ+ocLn+bvRcPE2mnk/WIK4SPvTv/z0/T3BF+E
         k3CNdDqH2BYLY4P8sSJELIqtt1z4Wgmg/tzFYMm2Ecyiz7HKYM6axnp272Si7ApQVl4/
         JmxvCr1izhGjqSfWm9v0d1nSr5GcABgdiwyl+iVoFZJ1C9vN5l6TXFZKI3Rnyvc5IFU8
         h1SQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=Sjn6JMGlEE7w/cFxbQ0CsTf2q8mFxojwCr9kf4vhksI=;
        b=o2p42RRITJ6REzF+sDj5JqKhzElB0O/MBulcEAkqKoJTXBc/gZua2fn4BHHHMvf2Mq
         z57uNZO2o/ZwXdgyKdl2h2iwVLw7gnW+ZBcKQLlcR6dxlBtkNfYoCHwDeW5Qn3LxLur6
         gl6nNx/spYcuc3eGL8+xeM1I592xKFRv3wnjDSUSzlO7eWorjby263BtLLlSE4/lbLMu
         O/Rw+4rWVHOSErcxlRUd6wzEyyuSERnHjjvA8j0ALYd1jlVRkuCcotDnjKDAxp0wuAOk
         IP6c3vcwOtzPO/jKJKZIvb5oiY8YPs1KVYAVwlRStYZEZq5K+kQVPGIXz7eh0lYiUHwS
         uwpg==
X-Gm-Message-State: APjAAAXJPVT+NsVK3NUwAFzwH0yeJS+KvAYA1Bapsw+3+N2mQthKxSuw
        Y94k/2EayqIHyiw4O7kGL5LFVkmH
X-Google-Smtp-Source: APXvYqy+Zj2Cr6MEREkVIPZYNx8b7EaE+QXSTw14+DuGpA0FwECqbQ10G9/pMkeCAfUn8oUbZ6lGZQ==
X-Received: by 2002:a17:906:30d1:: with SMTP id b17mr14797563ejb.9.1566229386673;
        Mon, 19 Aug 2019 08:43:06 -0700 (PDT)
Received: from localhost.localdomain.com ([188.204.2.113])
        by smtp.gmail.com with ESMTPSA id h10sm2891095edh.64.2019.08.19.08.43.05
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 19 Aug 2019 08:43:06 -0700 (PDT)
From:   Pascal van Leeuwen <pascalvanl@gmail.com>
X-Google-Original-From: Pascal van Leeuwen <pvanleeuwen@verimatrix.com>
To:     linux-crypto@vger.kernel.org
Cc:     antoine.tenart@bootlin.com, herbert@gondor.apana.org.au,
        davem@davemloft.net,
        Pascal van Leeuwen <pvanleeuwen@verimatrix.com>
Subject: [PATCHv5 2/4] crypto: inside-secure - Remove redundant algo to engine mapping code
Date:   Mon, 19 Aug 2019 16:40:24 +0200
Message-Id: <1566225626-10091-3-git-send-email-pvanleeuwen@verimatrix.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1566225626-10091-1-git-send-email-pvanleeuwen@verimatrix.com>
References: <1566225626-10091-1-git-send-email-pvanleeuwen@verimatrix.com>
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

This removes some code determine which engine has which algorithms which
was effectively redundant (may have been forward-looking?) due to always
enabling all algorithms for all currently supported engines.
A future patch will use a different, more scalable approach to achieve
this. This is removed now because otherwise the next patch will add new
hardware which would otherwise have to be added to all algorithms, so
now is a convenient time to just get rid of this.

Signed-off-by: Pascal van Leeuwen <pvanleeuwen@verimatrix.com>
Acked-by: Antoine Tenart <antoine.tenart@bootlin.com>
---
 drivers/crypto/inside-secure/safexcel.c        |  9 ---------
 drivers/crypto/inside-secure/safexcel.h        |  1 -
 drivers/crypto/inside-secure/safexcel_cipher.c | 11 -----------
 drivers/crypto/inside-secure/safexcel_hash.c   | 12 ------------
 4 files changed, 33 deletions(-)

diff --git a/drivers/crypto/inside-secure/safexcel.c b/drivers/crypto/inside-secure/safexcel.c
index 822744d..a5365f2 100644
--- a/drivers/crypto/inside-secure/safexcel.c
+++ b/drivers/crypto/inside-secure/safexcel.c
@@ -884,9 +884,6 @@ static int safexcel_register_algorithms(struct safexcel_crypto_priv *priv)
 	for (i = 0; i < ARRAY_SIZE(safexcel_algs); i++) {
 		safexcel_algs[i]->priv = priv;

-		if (!(safexcel_algs[i]->engines & priv->version))
-			continue;
-
 		if (safexcel_algs[i]->type == SAFEXCEL_ALG_TYPE_SKCIPHER)
 			ret = crypto_register_skcipher(&safexcel_algs[i]->alg.skcipher);
 		else if (safexcel_algs[i]->type == SAFEXCEL_ALG_TYPE_AEAD)
@@ -902,9 +899,6 @@ static int safexcel_register_algorithms(struct safexcel_crypto_priv *priv)

 fail:
 	for (j = 0; j < i; j++) {
-		if (!(safexcel_algs[j]->engines & priv->version))
-			continue;
-
 		if (safexcel_algs[j]->type == SAFEXCEL_ALG_TYPE_SKCIPHER)
 			crypto_unregister_skcipher(&safexcel_algs[j]->alg.skcipher);
 		else if (safexcel_algs[j]->type == SAFEXCEL_ALG_TYPE_AEAD)
@@ -921,9 +915,6 @@ static void safexcel_unregister_algorithms(struct safexcel_crypto_priv *priv)
 	int i;

 	for (i = 0; i < ARRAY_SIZE(safexcel_algs); i++) {
-		if (!(safexcel_algs[i]->engines & priv->version))
-			continue;
-
 		if (safexcel_algs[i]->type == SAFEXCEL_ALG_TYPE_SKCIPHER)
 			crypto_unregister_skcipher(&safexcel_algs[i]->alg.skcipher);
 		else if (safexcel_algs[i]->type == SAFEXCEL_ALG_TYPE_AEAD)
diff --git a/drivers/crypto/inside-secure/safexcel.h b/drivers/crypto/inside-secure/safexcel.h
index 6f9875e..ea9369c 100644
--- a/drivers/crypto/inside-secure/safexcel.h
+++ b/drivers/crypto/inside-secure/safexcel.h
@@ -630,7 +630,6 @@ struct safexcel_ahash_export_state {
 struct safexcel_alg_template {
 	struct safexcel_crypto_priv *priv;
 	enum safexcel_alg_type type;
-	u32 engines;
 	union {
 		struct skcipher_alg skcipher;
 		struct aead_alg aead;
diff --git a/drivers/crypto/inside-secure/safexcel_cipher.c b/drivers/crypto/inside-secure/safexcel_cipher.c
index 5682fe8..c78c6de 100644
--- a/drivers/crypto/inside-secure/safexcel_cipher.c
+++ b/drivers/crypto/inside-secure/safexcel_cipher.c
@@ -1034,7 +1034,6 @@ static void safexcel_aead_cra_exit(struct crypto_tfm *tfm)

 struct safexcel_alg_template safexcel_alg_ecb_aes = {
 	.type = SAFEXCEL_ALG_TYPE_SKCIPHER,
-	.engines = EIP97IES | EIP197B | EIP197D,
 	.alg.skcipher = {
 		.setkey = safexcel_skcipher_aes_setkey,
 		.encrypt = safexcel_ecb_aes_encrypt,
@@ -1073,7 +1072,6 @@ static int safexcel_cbc_aes_decrypt(struct skcipher_request *req)

 struct safexcel_alg_template safexcel_alg_cbc_aes = {
 	.type = SAFEXCEL_ALG_TYPE_SKCIPHER,
-	.engines = EIP97IES | EIP197B | EIP197D,
 	.alg.skcipher = {
 		.setkey = safexcel_skcipher_aes_setkey,
 		.encrypt = safexcel_cbc_aes_encrypt,
@@ -1216,7 +1214,6 @@ static int safexcel_des_setkey(struct crypto_skcipher *ctfm, const u8 *key,

 struct safexcel_alg_template safexcel_alg_cbc_des = {
 	.type = SAFEXCEL_ALG_TYPE_SKCIPHER,
-	.engines = EIP97IES | EIP197B | EIP197D,
 	.alg.skcipher = {
 		.setkey = safexcel_des_setkey,
 		.encrypt = safexcel_cbc_des_encrypt,
@@ -1256,7 +1253,6 @@ static int safexcel_ecb_des_decrypt(struct skcipher_request *req)

 struct safexcel_alg_template safexcel_alg_ecb_des = {
 	.type = SAFEXCEL_ALG_TYPE_SKCIPHER,
-	.engines = EIP97IES | EIP197B | EIP197D,
 	.alg.skcipher = {
 		.setkey = safexcel_des_setkey,
 		.encrypt = safexcel_ecb_des_encrypt,
@@ -1318,7 +1314,6 @@ static int safexcel_des3_ede_setkey(struct crypto_skcipher *ctfm,

 struct safexcel_alg_template safexcel_alg_cbc_des3_ede = {
 	.type = SAFEXCEL_ALG_TYPE_SKCIPHER,
-	.engines = EIP97IES | EIP197B | EIP197D,
 	.alg.skcipher = {
 		.setkey = safexcel_des3_ede_setkey,
 		.encrypt = safexcel_cbc_des3_ede_encrypt,
@@ -1358,7 +1353,6 @@ static int safexcel_ecb_des3_ede_decrypt(struct skcipher_request *req)

 struct safexcel_alg_template safexcel_alg_ecb_des3_ede = {
 	.type = SAFEXCEL_ALG_TYPE_SKCIPHER,
-	.engines = EIP97IES | EIP197B | EIP197D,
 	.alg.skcipher = {
 		.setkey = safexcel_des3_ede_setkey,
 		.encrypt = safexcel_ecb_des3_ede_encrypt,
@@ -1428,7 +1422,6 @@ static int safexcel_aead_sha1_cra_init(struct crypto_tfm *tfm)

 struct safexcel_alg_template safexcel_alg_authenc_hmac_sha1_cbc_aes = {
 	.type = SAFEXCEL_ALG_TYPE_AEAD,
-	.engines = EIP97IES | EIP197B | EIP197D,
 	.alg.aead = {
 		.setkey = safexcel_aead_setkey,
 		.encrypt = safexcel_aead_encrypt_aes,
@@ -1463,7 +1456,6 @@ static int safexcel_aead_sha256_cra_init(struct crypto_tfm *tfm)

 struct safexcel_alg_template safexcel_alg_authenc_hmac_sha256_cbc_aes = {
 	.type = SAFEXCEL_ALG_TYPE_AEAD,
-	.engines = EIP97IES | EIP197B | EIP197D,
 	.alg.aead = {
 		.setkey = safexcel_aead_setkey,
 		.encrypt = safexcel_aead_encrypt_aes,
@@ -1498,7 +1490,6 @@ static int safexcel_aead_sha224_cra_init(struct crypto_tfm *tfm)

 struct safexcel_alg_template safexcel_alg_authenc_hmac_sha224_cbc_aes = {
 	.type = SAFEXCEL_ALG_TYPE_AEAD,
-	.engines = EIP97IES | EIP197B | EIP197D,
 	.alg.aead = {
 		.setkey = safexcel_aead_setkey,
 		.encrypt = safexcel_aead_encrypt_aes,
@@ -1533,7 +1524,6 @@ static int safexcel_aead_sha512_cra_init(struct crypto_tfm *tfm)

 struct safexcel_alg_template safexcel_alg_authenc_hmac_sha512_cbc_aes = {
 	.type = SAFEXCEL_ALG_TYPE_AEAD,
-	.engines = EIP97IES | EIP197B | EIP197D,
 	.alg.aead = {
 		.setkey = safexcel_aead_setkey,
 		.encrypt = safexcel_aead_encrypt_aes,
@@ -1568,7 +1558,6 @@ static int safexcel_aead_sha384_cra_init(struct crypto_tfm *tfm)

 struct safexcel_alg_template safexcel_alg_authenc_hmac_sha384_cbc_aes = {
 	.type = SAFEXCEL_ALG_TYPE_AEAD,
-	.engines = EIP97IES | EIP197B | EIP197D,
 	.alg.aead = {
 		.setkey = safexcel_aead_setkey,
 		.encrypt = safexcel_aead_encrypt_aes,
diff --git a/drivers/crypto/inside-secure/safexcel_hash.c b/drivers/crypto/inside-secure/safexcel_hash.c
index c1776b6..626dd82 100644
--- a/drivers/crypto/inside-secure/safexcel_hash.c
+++ b/drivers/crypto/inside-secure/safexcel_hash.c
@@ -845,7 +845,6 @@ static void safexcel_ahash_cra_exit(struct crypto_tfm *tfm)

 struct safexcel_alg_template safexcel_alg_sha1 = {
 	.type = SAFEXCEL_ALG_TYPE_AHASH,
-	.engines = EIP97IES | EIP197B | EIP197D,
 	.alg.ahash = {
 		.init = safexcel_sha1_init,
 		.update = safexcel_ahash_update,
@@ -1086,7 +1085,6 @@ static int safexcel_hmac_sha1_setkey(struct crypto_ahash *tfm, const u8 *key,

 struct safexcel_alg_template safexcel_alg_hmac_sha1 = {
 	.type = SAFEXCEL_ALG_TYPE_AHASH,
-	.engines = EIP97IES | EIP197B | EIP197D,
 	.alg.ahash = {
 		.init = safexcel_hmac_sha1_init,
 		.update = safexcel_ahash_update,
@@ -1142,7 +1140,6 @@ static int safexcel_sha256_digest(struct ahash_request *areq)

 struct safexcel_alg_template safexcel_alg_sha256 = {
 	.type = SAFEXCEL_ALG_TYPE_AHASH,
-	.engines = EIP97IES | EIP197B | EIP197D,
 	.alg.ahash = {
 		.init = safexcel_sha256_init,
 		.update = safexcel_ahash_update,
@@ -1197,7 +1194,6 @@ static int safexcel_sha224_digest(struct ahash_request *areq)

 struct safexcel_alg_template safexcel_alg_sha224 = {
 	.type = SAFEXCEL_ALG_TYPE_AHASH,
-	.engines = EIP97IES | EIP197B | EIP197D,
 	.alg.ahash = {
 		.init = safexcel_sha224_init,
 		.update = safexcel_ahash_update,
@@ -1266,7 +1262,6 @@ static int safexcel_hmac_sha224_digest(struct ahash_request *areq)

 struct safexcel_alg_template safexcel_alg_hmac_sha224 = {
 	.type = SAFEXCEL_ALG_TYPE_AHASH,
-	.engines = EIP97IES | EIP197B | EIP197D,
 	.alg.ahash = {
 		.init = safexcel_hmac_sha224_init,
 		.update = safexcel_ahash_update,
@@ -1336,7 +1331,6 @@ static int safexcel_hmac_sha256_digest(struct ahash_request *areq)

 struct safexcel_alg_template safexcel_alg_hmac_sha256 = {
 	.type = SAFEXCEL_ALG_TYPE_AHASH,
-	.engines = EIP97IES | EIP197B | EIP197D,
 	.alg.ahash = {
 		.init = safexcel_hmac_sha256_init,
 		.update = safexcel_ahash_update,
@@ -1392,7 +1386,6 @@ static int safexcel_sha512_digest(struct ahash_request *areq)

 struct safexcel_alg_template safexcel_alg_sha512 = {
 	.type = SAFEXCEL_ALG_TYPE_AHASH,
-	.engines = EIP97IES | EIP197B | EIP197D,
 	.alg.ahash = {
 		.init = safexcel_sha512_init,
 		.update = safexcel_ahash_update,
@@ -1447,7 +1440,6 @@ static int safexcel_sha384_digest(struct ahash_request *areq)

 struct safexcel_alg_template safexcel_alg_sha384 = {
 	.type = SAFEXCEL_ALG_TYPE_AHASH,
-	.engines = EIP97IES | EIP197B | EIP197D,
 	.alg.ahash = {
 		.init = safexcel_sha384_init,
 		.update = safexcel_ahash_update,
@@ -1516,7 +1508,6 @@ static int safexcel_hmac_sha512_digest(struct ahash_request *areq)

 struct safexcel_alg_template safexcel_alg_hmac_sha512 = {
 	.type = SAFEXCEL_ALG_TYPE_AHASH,
-	.engines = EIP97IES | EIP197B | EIP197D,
 	.alg.ahash = {
 		.init = safexcel_hmac_sha512_init,
 		.update = safexcel_ahash_update,
@@ -1586,7 +1577,6 @@ static int safexcel_hmac_sha384_digest(struct ahash_request *areq)

 struct safexcel_alg_template safexcel_alg_hmac_sha384 = {
 	.type = SAFEXCEL_ALG_TYPE_AHASH,
-	.engines = EIP97IES | EIP197B | EIP197D,
 	.alg.ahash = {
 		.init = safexcel_hmac_sha384_init,
 		.update = safexcel_ahash_update,
@@ -1642,7 +1632,6 @@ static int safexcel_md5_digest(struct ahash_request *areq)

 struct safexcel_alg_template safexcel_alg_md5 = {
 	.type = SAFEXCEL_ALG_TYPE_AHASH,
-	.engines = EIP97IES | EIP197B | EIP197D,
 	.alg.ahash = {
 		.init = safexcel_md5_init,
 		.update = safexcel_ahash_update,
@@ -1712,7 +1701,6 @@ static int safexcel_hmac_md5_digest(struct ahash_request *areq)

 struct safexcel_alg_template safexcel_alg_hmac_md5 = {
 	.type = SAFEXCEL_ALG_TYPE_AHASH,
-	.engines = EIP97IES | EIP197B | EIP197D,
 	.alg.ahash = {
 		.init = safexcel_hmac_md5_init,
 		.update = safexcel_ahash_update,
--
1.8.3.1
