Return-Path: <SRS0=lkKn=2T=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 74AFAC2D0CE
	for <linux-crypto@archiver.kernel.org>; Sun, 29 Dec 2019 02:58:16 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 4C11821744
	for <linux-crypto@archiver.kernel.org>; Sun, 29 Dec 2019 02:58:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1577588296;
	bh=eS+BTgN11eJFPRwcXS3QOWwUZTcoi0pAmCDolLQ2xew=;
	h=From:To:Subject:Date:In-Reply-To:References:List-ID:From;
	b=ruo3qswfJ4I9se1TZB07jhqUMupQvBo+VzQr70O//pJqkquibjhrnFlpdu+U6hiK2
	 QXpa+pXNZJ0du2FXmAj9Bu4lzCSr050ZqSDQ4dDrRucCfs11cbEtT0HJQ3ZY23pqMw
	 d+2tfaz04XqPi/S7+xAT3bQDAYik3guQ73HuJze8=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726490AbfL2C6O (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Sat, 28 Dec 2019 21:58:14 -0500
Received: from mail.kernel.org ([198.145.29.99]:44570 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726508AbfL2C6O (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Sat, 28 Dec 2019 21:58:14 -0500
Received: from zzz.tds (h75-100-12-111.burkwi.broadband.dynamic.tds.net [75.100.12.111])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id E6BCD21D7E
        for <linux-crypto@vger.kernel.org>; Sun, 29 Dec 2019 02:58:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1577588293;
        bh=eS+BTgN11eJFPRwcXS3QOWwUZTcoi0pAmCDolLQ2xew=;
        h=From:To:Subject:Date:In-Reply-To:References:From;
        b=xHteLm81gZY7MIYyC4j+ngI4yzOuEfyPDljStLAW3y9BgVHCc8oPYIOWVGQo8VT5Q
         6RG1n5hlLDU5rXLCw7vNCfrlMPYt/fBZfdA/D1TW+mQE52rCokqXagmJYy+q/1zelg
         2hZwofLTU5nzIbQpsvHhTCJH9GBBqCZjp3BHnkgs=
From:   Eric Biggers <ebiggers@kernel.org>
To:     linux-crypto@vger.kernel.org
Subject: [PATCH 25/28] crypto: cipher - make crypto_spawn_cipher() take a crypto_cipher_spawn
Date:   Sat, 28 Dec 2019 20:57:11 -0600
Message-Id: <20191229025714.544159-26-ebiggers@kernel.org>
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

Now that all users of single-block cipher spawns have been converted to
use 'struct crypto_cipher_spawn' rather than the less specifically typed
'struct crypto_spawn', make crypto_spawn_cipher() take a pointer to a
'struct crypto_cipher_spawn' rather than a 'struct crypto_spawn'.

Signed-off-by: Eric Biggers <ebiggers@google.com>
---
 crypto/adiantum.c       | 2 +-
 crypto/ccm.c            | 2 +-
 crypto/cmac.c           | 2 +-
 crypto/skcipher.c       | 2 +-
 crypto/vmac.c           | 2 +-
 crypto/xcbc.c           | 2 +-
 include/crypto/algapi.h | 4 ++--
 7 files changed, 8 insertions(+), 8 deletions(-)

diff --git a/crypto/adiantum.c b/crypto/adiantum.c
index 41cace1d0cb6..177b1bfbd330 100644
--- a/crypto/adiantum.c
+++ b/crypto/adiantum.c
@@ -416,7 +416,7 @@ static int adiantum_init_tfm(struct crypto_skcipher *tfm)
 	if (IS_ERR(streamcipher))
 		return PTR_ERR(streamcipher);
 
-	blockcipher = crypto_spawn_cipher(&ictx->blockcipher_spawn.base);
+	blockcipher = crypto_spawn_cipher(&ictx->blockcipher_spawn);
 	if (IS_ERR(blockcipher)) {
 		err = PTR_ERR(blockcipher);
 		goto err_free_streamcipher;
diff --git a/crypto/ccm.c b/crypto/ccm.c
index 7deb533c7486..987c4d69948a 100644
--- a/crypto/ccm.c
+++ b/crypto/ccm.c
@@ -877,7 +877,7 @@ static int cbcmac_init_tfm(struct crypto_tfm *tfm)
 {
 	struct crypto_cipher *cipher;
 	struct crypto_instance *inst = (void *)tfm->__crt_alg;
-	struct crypto_spawn *spawn = crypto_instance_ctx(inst);
+	struct crypto_cipher_spawn *spawn = crypto_instance_ctx(inst);
 	struct cbcmac_tfm_ctx *ctx = crypto_tfm_ctx(tfm);
 
 	cipher = crypto_spawn_cipher(spawn);
diff --git a/crypto/cmac.c b/crypto/cmac.c
index cb41aab2fe58..cc4f46e2c46f 100644
--- a/crypto/cmac.c
+++ b/crypto/cmac.c
@@ -201,7 +201,7 @@ static int cmac_init_tfm(struct crypto_tfm *tfm)
 {
 	struct crypto_cipher *cipher;
 	struct crypto_instance *inst = (void *)tfm->__crt_alg;
-	struct crypto_spawn *spawn = crypto_instance_ctx(inst);
+	struct crypto_cipher_spawn *spawn = crypto_instance_ctx(inst);
 	struct cmac_tfm_ctx *ctx = crypto_tfm_ctx(tfm);
 
 	cipher = crypto_spawn_cipher(spawn);
diff --git a/crypto/skcipher.c b/crypto/skcipher.c
index 0615fead1529..a1a3f47c98e1 100644
--- a/crypto/skcipher.c
+++ b/crypto/skcipher.c
@@ -902,7 +902,7 @@ static int skcipher_setkey_simple(struct crypto_skcipher *tfm, const u8 *key,
 static int skcipher_init_tfm_simple(struct crypto_skcipher *tfm)
 {
 	struct skcipher_instance *inst = skcipher_alg_instance(tfm);
-	struct crypto_spawn *spawn = skcipher_instance_ctx(inst);
+	struct crypto_cipher_spawn *spawn = skcipher_instance_ctx(inst);
 	struct skcipher_ctx_simple *ctx = crypto_skcipher_ctx(tfm);
 	struct crypto_cipher *cipher;
 
diff --git a/crypto/vmac.c b/crypto/vmac.c
index 73538224f9ab..5241b183f8df 100644
--- a/crypto/vmac.c
+++ b/crypto/vmac.c
@@ -598,7 +598,7 @@ static int vmac_final(struct shash_desc *desc, u8 *out)
 static int vmac_init_tfm(struct crypto_tfm *tfm)
 {
 	struct crypto_instance *inst = crypto_tfm_alg_instance(tfm);
-	struct crypto_spawn *spawn = crypto_instance_ctx(inst);
+	struct crypto_cipher_spawn *spawn = crypto_instance_ctx(inst);
 	struct vmac_tfm_ctx *tctx = crypto_tfm_ctx(tfm);
 	struct crypto_cipher *cipher;
 
diff --git a/crypto/xcbc.c b/crypto/xcbc.c
index e35b2346cfb8..5fa700ab4387 100644
--- a/crypto/xcbc.c
+++ b/crypto/xcbc.c
@@ -167,7 +167,7 @@ static int xcbc_init_tfm(struct crypto_tfm *tfm)
 {
 	struct crypto_cipher *cipher;
 	struct crypto_instance *inst = (void *)tfm->__crt_alg;
-	struct crypto_spawn *spawn = crypto_instance_ctx(inst);
+	struct crypto_cipher_spawn *spawn = crypto_instance_ctx(inst);
 	struct xcbc_tfm_ctx *ctx = crypto_tfm_ctx(tfm);
 
 	cipher = crypto_spawn_cipher(spawn);
diff --git a/include/crypto/algapi.h b/include/crypto/algapi.h
index aad3348f60d1..c7c028472e91 100644
--- a/include/crypto/algapi.h
+++ b/include/crypto/algapi.h
@@ -228,12 +228,12 @@ static inline struct crypto_alg *crypto_spawn_cipher_alg(
 }
 
 static inline struct crypto_cipher *crypto_spawn_cipher(
-	struct crypto_spawn *spawn)
+	struct crypto_cipher_spawn *spawn)
 {
 	u32 type = CRYPTO_ALG_TYPE_CIPHER;
 	u32 mask = CRYPTO_ALG_TYPE_MASK;
 
-	return __crypto_cipher_cast(crypto_spawn_tfm(spawn, type, mask));
+	return __crypto_cipher_cast(crypto_spawn_tfm(&spawn->base, type, mask));
 }
 
 static inline struct cipher_alg *crypto_cipher_alg(struct crypto_cipher *tfm)
-- 
2.24.1

