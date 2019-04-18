Return-Path: <SRS0=uowK=SU=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.2 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 99CF5C10F0E
	for <linux-crypto@archiver.kernel.org>; Thu, 18 Apr 2019 21:44:25 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 5D2CE217D7
	for <linux-crypto@archiver.kernel.org>; Thu, 18 Apr 2019 21:44:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1555623865;
	bh=UvxRDDVP6/yKayGObcbjoMgaLifTPony4iNZbfT0kzw=;
	h=From:To:Subject:Date:List-ID:From;
	b=AOn0Yfg83C8KUGFK4SYX6Kj71zl8jsMkCuJ5NyTaxF052OU8Bj/arrieZPcxjiY01
	 O+WYxGzB+29GOq6dDtWa64px/NyIxjshbnu8lSt7vhSFf+pKNLlcj/NsuPJwUsYPdG
	 MptYqoPB81if9QT7gZIcYQlyGmJNI3pfkJYElZwc=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725939AbfDRVoY (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 18 Apr 2019 17:44:24 -0400
Received: from mail.kernel.org ([198.145.29.99]:50302 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725815AbfDRVoY (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 18 Apr 2019 17:44:24 -0400
Received: from ebiggers-linuxstation.mtv.corp.google.com (unknown [104.132.1.77])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 74ECA20652;
        Thu, 18 Apr 2019 21:44:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1555623862;
        bh=UvxRDDVP6/yKayGObcbjoMgaLifTPony4iNZbfT0kzw=;
        h=From:To:Subject:Date:From;
        b=shWHEu67ksbQ8SzrAjh2EVV4ntGkZL0cD5QjOSGBCvwErMLnZR05yO9inPERSTxwJ
         zKxINm24L41s+b5q7eC0e7NBQTn5Q1Okh580BcX/Ql/hAtGfpq6WrcBAfvKb5I5s8Y
         mqW7IkPYzNbuWN7DRAIyvkYMS1dNWA7AfC7RvTTE=
From:   Eric Biggers <ebiggers@kernel.org>
To:     linux-crypto@vger.kernel.org,
        Herbert Xu <herbert@gondor.apana.org.au>
Subject: [PATCH v3] crypto: gcm - fix incompatibility between "gcm" and "gcm_base"
Date:   Thu, 18 Apr 2019 14:43:02 -0700
Message-Id: <20190418214302.137478-1-ebiggers@kernel.org>
X-Mailer: git-send-email 2.21.0.392.gf8f6787159e-goog
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

From: Eric Biggers <ebiggers@google.com>

GCM instances can be created by either the "gcm" template, which only
allows choosing the block cipher, e.g. "gcm(aes)"; or by "gcm_base",
which allows choosing the ctr and ghash implementations, e.g.
"gcm_base(ctr(aes-generic),ghash-generic)".

However, a "gcm_base" instance prevents a "gcm" instance from being
registered using the same implementations.  Nor will the instance be
found by lookups of "gcm".  This can be used as a denial of service.
Moreover, "gcm_base" instances are never tested by the crypto
self-tests, even if there are compatible "gcm" tests.

The root cause of these problems is that instances of the two templates
use different cra_names.  Therefore, fix these problems by making
"gcm_base" instances set the same cra_name as "gcm" instances, e.g.
"gcm(aes)" instead of "gcm_base(ctr(aes-generic),ghash-generic)".

This requires extracting the block cipher name from the name of the ctr
algorithm.  It also requires starting to verify that the algorithms are
really ctr and ghash, not something else entirely.  But it would be
bizarre if anyone were actually using non-gcm-compatible algorithms with
gcm_base, so this shouldn't break anyone in practice.

Fixes: d00aa19b507b ("[CRYPTO] gcm: Allow block cipher parameter")
Cc: stable@vger.kernel.org
Signed-off-by: Eric Biggers <ebiggers@google.com>
---

Changed since v2:
	- Leave checks for ctr cra_blocksize == 1 and ghash digestsize == 16.

Changed since v1:
	- Verify that ghash is really ghash (based on name).
	- Improved commit message.

 crypto/gcm.c | 34 +++++++++++-----------------------
 1 file changed, 11 insertions(+), 23 deletions(-)

diff --git a/crypto/gcm.c b/crypto/gcm.c
index ff498411b43f6..33f45a9809671 100644
--- a/crypto/gcm.c
+++ b/crypto/gcm.c
@@ -597,7 +597,6 @@ static void crypto_gcm_free(struct aead_instance *inst)
 
 static int crypto_gcm_create_common(struct crypto_template *tmpl,
 				    struct rtattr **tb,
-				    const char *full_name,
 				    const char *ctr_name,
 				    const char *ghash_name)
 {
@@ -638,7 +637,8 @@ static int crypto_gcm_create_common(struct crypto_template *tmpl,
 		goto err_free_inst;
 
 	err = -EINVAL;
-	if (ghash->digestsize != 16)
+	if (strcmp(ghash->base.cra_name, "ghash") != 0 ||
+	    ghash->digestsize != 16)
 		goto err_drop_ghash;
 
 	crypto_set_skcipher_spawn(&ctx->ctr, aead_crypto_instance(inst));
@@ -650,24 +650,24 @@ static int crypto_gcm_create_common(struct crypto_template *tmpl,
 
 	ctr = crypto_spawn_skcipher_alg(&ctx->ctr);
 
-	/* We only support 16-byte blocks. */
+	/* The skcipher algorithm must be CTR mode, using 16-byte blocks. */
 	err = -EINVAL;
-	if (crypto_skcipher_alg_ivsize(ctr) != 16)
+	if (strncmp(ctr->base.cra_name, "ctr(", 4) != 0 ||
+	    crypto_skcipher_alg_ivsize(ctr) != 16 ||
+	    ctr->base.cra_blocksize != 1)
 		goto out_put_ctr;
 
-	/* Not a stream cipher? */
-	if (ctr->base.cra_blocksize != 1)
+	err = -ENAMETOOLONG;
+	if (snprintf(inst->alg.base.cra_name, CRYPTO_MAX_ALG_NAME,
+		     "gcm(%s", ctr->base.cra_name + 4) >= CRYPTO_MAX_ALG_NAME)
 		goto out_put_ctr;
 
-	err = -ENAMETOOLONG;
 	if (snprintf(inst->alg.base.cra_driver_name, CRYPTO_MAX_ALG_NAME,
 		     "gcm_base(%s,%s)", ctr->base.cra_driver_name,
 		     ghash_alg->cra_driver_name) >=
 	    CRYPTO_MAX_ALG_NAME)
 		goto out_put_ctr;
 
-	memcpy(inst->alg.base.cra_name, full_name, CRYPTO_MAX_ALG_NAME);
-
 	inst->alg.base.cra_flags = (ghash->base.cra_flags |
 				    ctr->base.cra_flags) & CRYPTO_ALG_ASYNC;
 	inst->alg.base.cra_priority = (ghash->base.cra_priority +
@@ -709,7 +709,6 @@ static int crypto_gcm_create(struct crypto_template *tmpl, struct rtattr **tb)
 {
 	const char *cipher_name;
 	char ctr_name[CRYPTO_MAX_ALG_NAME];
-	char full_name[CRYPTO_MAX_ALG_NAME];
 
 	cipher_name = crypto_attr_alg_name(tb[1]);
 	if (IS_ERR(cipher_name))
@@ -719,12 +718,7 @@ static int crypto_gcm_create(struct crypto_template *tmpl, struct rtattr **tb)
 	    CRYPTO_MAX_ALG_NAME)
 		return -ENAMETOOLONG;
 
-	if (snprintf(full_name, CRYPTO_MAX_ALG_NAME, "gcm(%s)", cipher_name) >=
-	    CRYPTO_MAX_ALG_NAME)
-		return -ENAMETOOLONG;
-
-	return crypto_gcm_create_common(tmpl, tb, full_name,
-					ctr_name, "ghash");
+	return crypto_gcm_create_common(tmpl, tb, ctr_name, "ghash");
 }
 
 static int crypto_gcm_base_create(struct crypto_template *tmpl,
@@ -732,7 +726,6 @@ static int crypto_gcm_base_create(struct crypto_template *tmpl,
 {
 	const char *ctr_name;
 	const char *ghash_name;
-	char full_name[CRYPTO_MAX_ALG_NAME];
 
 	ctr_name = crypto_attr_alg_name(tb[1]);
 	if (IS_ERR(ctr_name))
@@ -742,12 +735,7 @@ static int crypto_gcm_base_create(struct crypto_template *tmpl,
 	if (IS_ERR(ghash_name))
 		return PTR_ERR(ghash_name);
 
-	if (snprintf(full_name, CRYPTO_MAX_ALG_NAME, "gcm_base(%s,%s)",
-		     ctr_name, ghash_name) >= CRYPTO_MAX_ALG_NAME)
-		return -ENAMETOOLONG;
-
-	return crypto_gcm_create_common(tmpl, tb, full_name,
-					ctr_name, ghash_name);
+	return crypto_gcm_create_common(tmpl, tb, ctr_name, ghash_name);
 }
 
 static int crypto_rfc4106_setkey(struct crypto_aead *parent, const u8 *key,
-- 
2.21.0.392.gf8f6787159e-goog

