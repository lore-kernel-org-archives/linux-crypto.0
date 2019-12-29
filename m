Return-Path: <SRS0=lkKn=2T=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5DF2AC2D0C8
	for <linux-crypto@archiver.kernel.org>; Sun, 29 Dec 2019 02:58:07 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 203FD2176D
	for <linux-crypto@archiver.kernel.org>; Sun, 29 Dec 2019 02:58:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1577588287;
	bh=ClyIXS8Xvl75NkhFMi4cReNhOBcgtBL7ysEmsNClS6c=;
	h=From:To:Subject:Date:In-Reply-To:References:List-ID:From;
	b=Jfvv/k+24bNd/LxcTyqc5Btl2X8XsTSm29HL/YedS6q8e3Io/TXR96RabLVA/odjJ
	 bP2zXxdol56Aw+Jqcn81ejAE05OdxXXDsu9pYEUEmQe3m8E4Q3pc72nz3FETD2+5iD
	 Xfp2oxN5CdazCK8G4FeGe958zAM5m+KO6PppaT2w=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726396AbfL2C6G (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Sat, 28 Dec 2019 21:58:06 -0500
Received: from mail.kernel.org ([198.145.29.99]:44410 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726187AbfL2C6G (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Sat, 28 Dec 2019 21:58:06 -0500
Received: from zzz.tds (h75-100-12-111.burkwi.broadband.dynamic.tds.net [75.100.12.111])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 33D622176D
        for <linux-crypto@vger.kernel.org>; Sun, 29 Dec 2019 02:58:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1577588284;
        bh=ClyIXS8Xvl75NkhFMi4cReNhOBcgtBL7ysEmsNClS6c=;
        h=From:To:Subject:Date:In-Reply-To:References:From;
        b=OiFIRikF7Q4e4QiRUH08FF7nAf4AMSkx+KFXgYkOCNF+AeS4MdbJXncXBu52C0Wbh
         KRSMLLTvTuoUFBlEhyApulX+Ese1pc7BPMhtkVZKJ2GZZas/xERioFDlm3RRJGu4YS
         fl2swQS2/3AroP2n8CxbuChV84WNmzv2Os1nc3nU=
From:   Eric Biggers <ebiggers@kernel.org>
To:     linux-crypto@vger.kernel.org
Subject: [PATCH 05/28] crypto: skcipher - pass instance to crypto_grab_skcipher()
Date:   Sat, 28 Dec 2019 20:56:51 -0600
Message-Id: <20191229025714.544159-6-ebiggers@kernel.org>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20191229025714.544159-1-ebiggers@kernel.org>
References: <20191229025714.544159-1-ebiggers@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

From: Eric Biggers <ebiggers@google.com>

Initializing a crypto_skcipher_spawn currently requires:

1. Set spawn->base.inst to point to the instance.
2. Call crypto_grab_skcipher().

But there's no reason for these steps to be separate, and in fact this
unneeded complication has caused at least one bug, the one fixed by
commit 6db43410179b ("crypto: adiantum - initialize crypto_spawn::inst")

So just make crypto_grab_skcipher() take the instance as an argument.

To keep the function calls from getting too unwieldy due to this extra
argument, also introduce a 'mask' variable into the affected places
which weren't already using one.

Signed-off-by: Eric Biggers <ebiggers@google.com>
---
 crypto/adiantum.c                  | 11 ++++++-----
 crypto/authenc.c                   | 12 ++++++------
 crypto/authencesn.c                | 12 ++++++------
 crypto/ccm.c                       |  9 +++++----
 crypto/chacha20poly1305.c          | 13 ++++++-------
 crypto/cryptd.c                    |  4 ++--
 crypto/ctr.c                       |  4 ++--
 crypto/cts.c                       |  9 +++++----
 crypto/essiv.c                     | 13 +++++--------
 crypto/gcm.c                       | 13 ++++++-------
 crypto/lrw.c                       | 15 ++++++++-------
 crypto/skcipher.c                  |  4 +++-
 crypto/xts.c                       |  9 +++++----
 include/crypto/internal/skcipher.h | 11 +++--------
 14 files changed, 68 insertions(+), 71 deletions(-)

diff --git a/crypto/adiantum.c b/crypto/adiantum.c
index aded26092268..aaf8a66f871c 100644
--- a/crypto/adiantum.c
+++ b/crypto/adiantum.c
@@ -501,6 +501,7 @@ static bool adiantum_supported_algorithms(struct skcipher_alg *streamcipher_alg,
 static int adiantum_create(struct crypto_template *tmpl, struct rtattr **tb)
 {
 	struct crypto_attr_type *algt;
+	u32 mask;
 	const char *streamcipher_name;
 	const char *blockcipher_name;
 	const char *nhpoly1305_name;
@@ -519,6 +520,8 @@ static int adiantum_create(struct crypto_template *tmpl, struct rtattr **tb)
 	if ((algt->type ^ CRYPTO_ALG_TYPE_SKCIPHER) & algt->mask)
 		return -EINVAL;
 
+	mask = crypto_requires_sync(algt->type, algt->mask);
+
 	streamcipher_name = crypto_attr_alg_name(tb[1]);
 	if (IS_ERR(streamcipher_name))
 		return PTR_ERR(streamcipher_name);
@@ -539,11 +542,9 @@ static int adiantum_create(struct crypto_template *tmpl, struct rtattr **tb)
 	ictx = skcipher_instance_ctx(inst);
 
 	/* Stream cipher, e.g. "xchacha12" */
-	crypto_set_skcipher_spawn(&ictx->streamcipher_spawn,
-				  skcipher_crypto_instance(inst));
-	err = crypto_grab_skcipher(&ictx->streamcipher_spawn, streamcipher_name,
-				   0, crypto_requires_sync(algt->type,
-							   algt->mask));
+	err = crypto_grab_skcipher(&ictx->streamcipher_spawn,
+				   skcipher_crypto_instance(inst),
+				   streamcipher_name, 0, mask);
 	if (err)
 		goto out_free_inst;
 	streamcipher_alg = crypto_spawn_skcipher_alg(&ictx->streamcipher_spawn);
diff --git a/crypto/authenc.c b/crypto/authenc.c
index 3f0ed9402582..aef04792702a 100644
--- a/crypto/authenc.c
+++ b/crypto/authenc.c
@@ -383,6 +383,7 @@ static int crypto_authenc_create(struct crypto_template *tmpl,
 				 struct rtattr **tb)
 {
 	struct crypto_attr_type *algt;
+	u32 mask;
 	struct aead_instance *inst;
 	struct hash_alg_common *auth;
 	struct crypto_alg *auth_base;
@@ -398,9 +399,10 @@ static int crypto_authenc_create(struct crypto_template *tmpl,
 	if ((algt->type ^ CRYPTO_ALG_TYPE_AEAD) & algt->mask)
 		return -EINVAL;
 
+	mask = crypto_requires_sync(algt->type, algt->mask);
+
 	auth = ahash_attr_alg(tb[1], CRYPTO_ALG_TYPE_HASH,
-			      CRYPTO_ALG_TYPE_AHASH_MASK |
-			      crypto_requires_sync(algt->type, algt->mask));
+			      CRYPTO_ALG_TYPE_AHASH_MASK | mask);
 	if (IS_ERR(auth))
 		return PTR_ERR(auth);
 
@@ -423,10 +425,8 @@ static int crypto_authenc_create(struct crypto_template *tmpl,
 	if (err)
 		goto err_free_inst;
 
-	crypto_set_skcipher_spawn(&ctx->enc, aead_crypto_instance(inst));
-	err = crypto_grab_skcipher(&ctx->enc, enc_name, 0,
-				   crypto_requires_sync(algt->type,
-							algt->mask));
+	err = crypto_grab_skcipher(&ctx->enc, aead_crypto_instance(inst),
+				   enc_name, 0, mask);
 	if (err)
 		goto err_drop_auth;
 
diff --git a/crypto/authencesn.c b/crypto/authencesn.c
index adb7554fca29..48582c3741dc 100644
--- a/crypto/authencesn.c
+++ b/crypto/authencesn.c
@@ -401,6 +401,7 @@ static int crypto_authenc_esn_create(struct crypto_template *tmpl,
 				     struct rtattr **tb)
 {
 	struct crypto_attr_type *algt;
+	u32 mask;
 	struct aead_instance *inst;
 	struct hash_alg_common *auth;
 	struct crypto_alg *auth_base;
@@ -416,9 +417,10 @@ static int crypto_authenc_esn_create(struct crypto_template *tmpl,
 	if ((algt->type ^ CRYPTO_ALG_TYPE_AEAD) & algt->mask)
 		return -EINVAL;
 
+	mask = crypto_requires_sync(algt->type, algt->mask);
+
 	auth = ahash_attr_alg(tb[1], CRYPTO_ALG_TYPE_HASH,
-			      CRYPTO_ALG_TYPE_AHASH_MASK |
-			      crypto_requires_sync(algt->type, algt->mask));
+			      CRYPTO_ALG_TYPE_AHASH_MASK | mask);
 	if (IS_ERR(auth))
 		return PTR_ERR(auth);
 
@@ -441,10 +443,8 @@ static int crypto_authenc_esn_create(struct crypto_template *tmpl,
 	if (err)
 		goto err_free_inst;
 
-	crypto_set_skcipher_spawn(&ctx->enc, aead_crypto_instance(inst));
-	err = crypto_grab_skcipher(&ctx->enc, enc_name, 0,
-				   crypto_requires_sync(algt->type,
-							algt->mask));
+	err = crypto_grab_skcipher(&ctx->enc, aead_crypto_instance(inst),
+				   enc_name, 0, mask);
 	if (err)
 		goto err_drop_auth;
 
diff --git a/crypto/ccm.c b/crypto/ccm.c
index 380eb619f657..d2279dc5b970 100644
--- a/crypto/ccm.c
+++ b/crypto/ccm.c
@@ -457,6 +457,7 @@ static int crypto_ccm_create_common(struct crypto_template *tmpl,
 				    const char *mac_name)
 {
 	struct crypto_attr_type *algt;
+	u32 mask;
 	struct aead_instance *inst;
 	struct skcipher_alg *ctr;
 	struct crypto_alg *mac_alg;
@@ -471,6 +472,8 @@ static int crypto_ccm_create_common(struct crypto_template *tmpl,
 	if ((algt->type ^ CRYPTO_ALG_TYPE_AEAD) & algt->mask)
 		return -EINVAL;
 
+	mask = crypto_requires_sync(algt->type, algt->mask);
+
 	mac_alg = crypto_find_alg(mac_name, &crypto_ahash_type,
 				  CRYPTO_ALG_TYPE_HASH,
 				  CRYPTO_ALG_TYPE_AHASH_MASK |
@@ -495,10 +498,8 @@ static int crypto_ccm_create_common(struct crypto_template *tmpl,
 	if (err)
 		goto err_free_inst;
 
-	crypto_set_skcipher_spawn(&ictx->ctr, aead_crypto_instance(inst));
-	err = crypto_grab_skcipher(&ictx->ctr, ctr_name, 0,
-				   crypto_requires_sync(algt->type,
-							algt->mask));
+	err = crypto_grab_skcipher(&ictx->ctr, aead_crypto_instance(inst),
+				   ctr_name, 0, mask);
 	if (err)
 		goto err_drop_mac;
 
diff --git a/crypto/chacha20poly1305.c b/crypto/chacha20poly1305.c
index 74e824e537e6..fcb8ec4ba083 100644
--- a/crypto/chacha20poly1305.c
+++ b/crypto/chacha20poly1305.c
@@ -563,6 +563,7 @@ static int chachapoly_create(struct crypto_template *tmpl, struct rtattr **tb,
 			     const char *name, unsigned int ivsize)
 {
 	struct crypto_attr_type *algt;
+	u32 mask;
 	struct aead_instance *inst;
 	struct skcipher_alg *chacha;
 	struct crypto_alg *poly;
@@ -581,6 +582,8 @@ static int chachapoly_create(struct crypto_template *tmpl, struct rtattr **tb,
 	if ((algt->type ^ CRYPTO_ALG_TYPE_AEAD) & algt->mask)
 		return -EINVAL;
 
+	mask = crypto_requires_sync(algt->type, algt->mask);
+
 	chacha_name = crypto_attr_alg_name(tb[1]);
 	if (IS_ERR(chacha_name))
 		return PTR_ERR(chacha_name);
@@ -590,9 +593,7 @@ static int chachapoly_create(struct crypto_template *tmpl, struct rtattr **tb,
 
 	poly = crypto_find_alg(poly_name, &crypto_ahash_type,
 			       CRYPTO_ALG_TYPE_HASH,
-			       CRYPTO_ALG_TYPE_AHASH_MASK |
-			       crypto_requires_sync(algt->type,
-						    algt->mask));
+			       CRYPTO_ALG_TYPE_AHASH_MASK | mask);
 	if (IS_ERR(poly))
 		return PTR_ERR(poly);
 	poly_hash = __crypto_hash_alg_common(poly);
@@ -613,10 +614,8 @@ static int chachapoly_create(struct crypto_template *tmpl, struct rtattr **tb,
 	if (err)
 		goto err_free_inst;
 
-	crypto_set_skcipher_spawn(&ctx->chacha, aead_crypto_instance(inst));
-	err = crypto_grab_skcipher(&ctx->chacha, chacha_name, 0,
-				   crypto_requires_sync(algt->type,
-							algt->mask));
+	err = crypto_grab_skcipher(&ctx->chacha, aead_crypto_instance(inst),
+				   chacha_name, 0, mask);
 	if (err)
 		goto err_drop_poly;
 
diff --git a/crypto/cryptd.c b/crypto/cryptd.c
index 2c6649b10923..01a1f6aa30ac 100644
--- a/crypto/cryptd.c
+++ b/crypto/cryptd.c
@@ -421,8 +421,8 @@ static int cryptd_create_skcipher(struct crypto_template *tmpl,
 	ctx = skcipher_instance_ctx(inst);
 	ctx->queue = queue;
 
-	crypto_set_skcipher_spawn(&ctx->spawn, skcipher_crypto_instance(inst));
-	err = crypto_grab_skcipher(&ctx->spawn, name, type, mask);
+	err = crypto_grab_skcipher(&ctx->spawn, skcipher_crypto_instance(inst),
+				   name, type, mask);
 	if (err)
 		goto out_free_inst;
 
diff --git a/crypto/ctr.c b/crypto/ctr.c
index 1e9d6b86b3c6..c8076d9106a1 100644
--- a/crypto/ctr.c
+++ b/crypto/ctr.c
@@ -291,8 +291,8 @@ static int crypto_rfc3686_create(struct crypto_template *tmpl,
 
 	spawn = skcipher_instance_ctx(inst);
 
-	crypto_set_skcipher_spawn(spawn, skcipher_crypto_instance(inst));
-	err = crypto_grab_skcipher(spawn, cipher_name, 0, mask);
+	err = crypto_grab_skcipher(spawn, skcipher_crypto_instance(inst),
+				   cipher_name, 0, mask);
 	if (err)
 		goto err_free_inst;
 
diff --git a/crypto/cts.c b/crypto/cts.c
index 6b6087dbb62a..b98c5a563346 100644
--- a/crypto/cts.c
+++ b/crypto/cts.c
@@ -332,6 +332,7 @@ static int crypto_cts_create(struct crypto_template *tmpl, struct rtattr **tb)
 	struct crypto_attr_type *algt;
 	struct skcipher_alg *alg;
 	const char *cipher_name;
+	u32 mask;
 	int err;
 
 	algt = crypto_get_attr_type(tb);
@@ -341,6 +342,8 @@ static int crypto_cts_create(struct crypto_template *tmpl, struct rtattr **tb)
 	if ((algt->type ^ CRYPTO_ALG_TYPE_SKCIPHER) & algt->mask)
 		return -EINVAL;
 
+	mask = crypto_requires_sync(algt->type, algt->mask);
+
 	cipher_name = crypto_attr_alg_name(tb[1]);
 	if (IS_ERR(cipher_name))
 		return PTR_ERR(cipher_name);
@@ -351,10 +354,8 @@ static int crypto_cts_create(struct crypto_template *tmpl, struct rtattr **tb)
 
 	spawn = skcipher_instance_ctx(inst);
 
-	crypto_set_skcipher_spawn(spawn, skcipher_crypto_instance(inst));
-	err = crypto_grab_skcipher(spawn, cipher_name, 0,
-				   crypto_requires_sync(algt->type,
-							algt->mask));
+	err = crypto_grab_skcipher(spawn, skcipher_crypto_instance(inst),
+				   cipher_name, 0, mask);
 	if (err)
 		goto err_free_inst;
 
diff --git a/crypto/essiv.c b/crypto/essiv.c
index e4b32c2ea7ec..2019250da08e 100644
--- a/crypto/essiv.c
+++ b/crypto/essiv.c
@@ -468,6 +468,7 @@ static int essiv_create(struct crypto_template *tmpl, struct rtattr **tb)
 	struct shash_alg *hash_alg;
 	int ivsize;
 	u32 type;
+	u32 mask;
 	int err;
 
 	algt = crypto_get_attr_type(tb);
@@ -483,6 +484,7 @@ static int essiv_create(struct crypto_template *tmpl, struct rtattr **tb)
 		return PTR_ERR(shash_name);
 
 	type = algt->type & algt->mask;
+	mask = crypto_requires_sync(algt->type, algt->mask);
 
 	switch (type) {
 	case CRYPTO_ALG_TYPE_SKCIPHER:
@@ -495,11 +497,8 @@ static int essiv_create(struct crypto_template *tmpl, struct rtattr **tb)
 		ictx = crypto_instance_ctx(inst);
 
 		/* Symmetric cipher, e.g., "cbc(aes)" */
-		crypto_set_skcipher_spawn(&ictx->u.skcipher_spawn, inst);
-		err = crypto_grab_skcipher(&ictx->u.skcipher_spawn,
-					   inner_cipher_name, 0,
-					   crypto_requires_sync(algt->type,
-								algt->mask));
+		err = crypto_grab_skcipher(&ictx->u.skcipher_spawn, inst,
+					   inner_cipher_name, 0, mask);
 		if (err)
 			goto out_free_inst;
 		skcipher_alg = crypto_spawn_skcipher_alg(&ictx->u.skcipher_spawn);
@@ -519,9 +518,7 @@ static int essiv_create(struct crypto_template *tmpl, struct rtattr **tb)
 		/* AEAD cipher, e.g., "authenc(hmac(sha256),cbc(aes))" */
 		crypto_set_aead_spawn(&ictx->u.aead_spawn, inst);
 		err = crypto_grab_aead(&ictx->u.aead_spawn,
-				       inner_cipher_name, 0,
-				       crypto_requires_sync(algt->type,
-							    algt->mask));
+				       inner_cipher_name, 0, mask);
 		if (err)
 			goto out_free_inst;
 		aead_alg = crypto_spawn_aead_alg(&ictx->u.aead_spawn);
diff --git a/crypto/gcm.c b/crypto/gcm.c
index 73884208f075..5a01b2b956f6 100644
--- a/crypto/gcm.c
+++ b/crypto/gcm.c
@@ -585,6 +585,7 @@ static int crypto_gcm_create_common(struct crypto_template *tmpl,
 				    const char *ghash_name)
 {
 	struct crypto_attr_type *algt;
+	u32 mask;
 	struct aead_instance *inst;
 	struct skcipher_alg *ctr;
 	struct crypto_alg *ghash_alg;
@@ -599,11 +600,11 @@ static int crypto_gcm_create_common(struct crypto_template *tmpl,
 	if ((algt->type ^ CRYPTO_ALG_TYPE_AEAD) & algt->mask)
 		return -EINVAL;
 
+	mask = crypto_requires_sync(algt->type, algt->mask);
+
 	ghash_alg = crypto_find_alg(ghash_name, &crypto_ahash_type,
 				    CRYPTO_ALG_TYPE_HASH,
-				    CRYPTO_ALG_TYPE_AHASH_MASK |
-				    crypto_requires_sync(algt->type,
-							 algt->mask));
+				    CRYPTO_ALG_TYPE_AHASH_MASK | mask);
 	if (IS_ERR(ghash_alg))
 		return PTR_ERR(ghash_alg);
 
@@ -625,10 +626,8 @@ static int crypto_gcm_create_common(struct crypto_template *tmpl,
 	    ghash->digestsize != 16)
 		goto err_drop_ghash;
 
-	crypto_set_skcipher_spawn(&ctx->ctr, aead_crypto_instance(inst));
-	err = crypto_grab_skcipher(&ctx->ctr, ctr_name, 0,
-				   crypto_requires_sync(algt->type,
-							algt->mask));
+	err = crypto_grab_skcipher(&ctx->ctr, aead_crypto_instance(inst),
+				   ctr_name, 0, mask);
 	if (err)
 		goto err_drop_ghash;
 
diff --git a/crypto/lrw.c b/crypto/lrw.c
index be829f6afc8e..ae72f8ab1d9f 100644
--- a/crypto/lrw.c
+++ b/crypto/lrw.c
@@ -303,6 +303,7 @@ static int create(struct crypto_template *tmpl, struct rtattr **tb)
 	struct skcipher_alg *alg;
 	const char *cipher_name;
 	char ecb_name[CRYPTO_MAX_ALG_NAME];
+	u32 mask;
 	int err;
 
 	algt = crypto_get_attr_type(tb);
@@ -312,6 +313,8 @@ static int create(struct crypto_template *tmpl, struct rtattr **tb)
 	if ((algt->type ^ CRYPTO_ALG_TYPE_SKCIPHER) & algt->mask)
 		return -EINVAL;
 
+	mask = crypto_requires_sync(algt->type, algt->mask);
+
 	cipher_name = crypto_attr_alg_name(tb[1]);
 	if (IS_ERR(cipher_name))
 		return PTR_ERR(cipher_name);
@@ -322,19 +325,17 @@ static int create(struct crypto_template *tmpl, struct rtattr **tb)
 
 	spawn = skcipher_instance_ctx(inst);
 
-	crypto_set_skcipher_spawn(spawn, skcipher_crypto_instance(inst));
-	err = crypto_grab_skcipher(spawn, cipher_name, 0,
-				   crypto_requires_sync(algt->type,
-							algt->mask));
+	err = crypto_grab_skcipher(spawn, skcipher_crypto_instance(inst),
+				   cipher_name, 0, mask);
 	if (err == -ENOENT) {
 		err = -ENAMETOOLONG;
 		if (snprintf(ecb_name, CRYPTO_MAX_ALG_NAME, "ecb(%s)",
 			     cipher_name) >= CRYPTO_MAX_ALG_NAME)
 			goto err_free_inst;
 
-		err = crypto_grab_skcipher(spawn, ecb_name, 0,
-					   crypto_requires_sync(algt->type,
-								algt->mask));
+		err = crypto_grab_skcipher(spawn,
+					   skcipher_crypto_instance(inst),
+					   ecb_name, 0, mask);
 	}
 
 	if (err)
diff --git a/crypto/skcipher.c b/crypto/skcipher.c
index 37adb71f7759..e5083dccccdc 100644
--- a/crypto/skcipher.c
+++ b/crypto/skcipher.c
@@ -758,8 +758,10 @@ static const struct crypto_type crypto_skcipher_type = {
 };
 
 int crypto_grab_skcipher(struct crypto_skcipher_spawn *spawn,
-			  const char *name, u32 type, u32 mask)
+			 struct crypto_instance *inst,
+			 const char *name, u32 type, u32 mask)
 {
+	spawn->base.inst = inst;
 	spawn->base.frontend = &crypto_skcipher_type;
 	return crypto_grab_spawn(&spawn->base, name, type, mask);
 }
diff --git a/crypto/xts.c b/crypto/xts.c
index ab117633d64e..43e9048ba36b 100644
--- a/crypto/xts.c
+++ b/crypto/xts.c
@@ -361,20 +361,21 @@ static int create(struct crypto_template *tmpl, struct rtattr **tb)
 
 	ctx = skcipher_instance_ctx(inst);
 
-	crypto_set_skcipher_spawn(&ctx->spawn, skcipher_crypto_instance(inst));
-
 	mask = crypto_requires_off(algt->type, algt->mask,
 				   CRYPTO_ALG_NEED_FALLBACK |
 				   CRYPTO_ALG_ASYNC);
 
-	err = crypto_grab_skcipher(&ctx->spawn, cipher_name, 0, mask);
+	err = crypto_grab_skcipher(&ctx->spawn, skcipher_crypto_instance(inst),
+				   cipher_name, 0, mask);
 	if (err == -ENOENT) {
 		err = -ENAMETOOLONG;
 		if (snprintf(ctx->name, CRYPTO_MAX_ALG_NAME, "ecb(%s)",
 			     cipher_name) >= CRYPTO_MAX_ALG_NAME)
 			goto err_free_inst;
 
-		err = crypto_grab_skcipher(&ctx->spawn, ctx->name, 0, mask);
+		err = crypto_grab_skcipher(&ctx->spawn,
+					   skcipher_crypto_instance(inst),
+					   ctx->name, 0, mask);
 	}
 
 	if (err)
diff --git a/include/crypto/internal/skcipher.h b/include/crypto/internal/skcipher.h
index ad4a6330ff53..b81cb4902abc 100644
--- a/include/crypto/internal/skcipher.h
+++ b/include/crypto/internal/skcipher.h
@@ -88,14 +88,9 @@ static inline void skcipher_request_complete(struct skcipher_request *req, int e
 	req->base.complete(&req->base, err);
 }
 
-static inline void crypto_set_skcipher_spawn(
-	struct crypto_skcipher_spawn *spawn, struct crypto_instance *inst)
-{
-	crypto_set_spawn(&spawn->base, inst);
-}
-
-int crypto_grab_skcipher(struct crypto_skcipher_spawn *spawn, const char *name,
-			 u32 type, u32 mask);
+int crypto_grab_skcipher(struct crypto_skcipher_spawn *spawn,
+			 struct crypto_instance *inst,
+			 const char *name, u32 type, u32 mask);
 
 static inline void crypto_drop_skcipher(struct crypto_skcipher_spawn *spawn)
 {
-- 
2.24.1

