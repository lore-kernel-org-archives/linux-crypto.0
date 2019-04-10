Return-Path: <SRS0=kwSW=SM=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_PASS,USER_AGENT_GIT autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AD1E4C10F14
	for <linux-crypto@archiver.kernel.org>; Wed, 10 Apr 2019 06:48:51 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 7D6892083E
	for <linux-crypto@archiver.kernel.org>; Wed, 10 Apr 2019 06:48:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1554878931;
	bh=x7vzV1aHpywCshuQcqAmTQ16gOFCRJdSdDA7pzJ7C54=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:List-ID:From;
	b=z46CNK4ppRihkL2SSR5WvNiP3PqHpElS3/eXDyBMwvgv2tORhJ2ooLoPzvRIWob9A
	 zuOejfWw/p2RTpMEbQvD/J7SYYTfOyxDzz0RLiW7K9wN21JPDFF3qs0rzIcIHrX6si
	 AsZZ249j9aSfzyZZCYNkwoIj6QqHybdgfsAv4RSQ=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728642AbfDJGst (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Wed, 10 Apr 2019 02:48:49 -0400
Received: from mail.kernel.org ([198.145.29.99]:53368 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728695AbfDJGss (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 10 Apr 2019 02:48:48 -0400
Received: from sol.localdomain (c-24-5-143-220.hsd1.ca.comcast.net [24.5.143.220])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 36EE02183E;
        Wed, 10 Apr 2019 06:48:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1554878927;
        bh=x7vzV1aHpywCshuQcqAmTQ16gOFCRJdSdDA7pzJ7C54=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ghWenNmymKl6mKqkPeav/Y4XMwLINwgW3NfqxqOK2Red5WwBnDG+um9vIArc6rKxh
         V9xhxAAzGxvlGJOMYnae8u2eh9w3EF56HctSixtr0inknLVhO+W2aCrUEFz5AHaqb3
         Gw95IWImiIrsmVOpyFETLL8vihN1LTykp9UXShUU=
From:   Eric Biggers <ebiggers@kernel.org>
To:     linux-crypto@vger.kernel.org
Cc:     stable@vger.kernel.org
Subject: [PATCH v2 5/7] crypto: gcm - fix incompatibility between "gcm" and "gcm_base"
Date:   Tue,  9 Apr 2019 23:46:33 -0700
Message-Id: <20190410064635.11813-6-ebiggers@kernel.org>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190410064635.11813-1-ebiggers@kernel.org>
References: <20190410064635.11813-1-ebiggers@kernel.org>
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
 crypto/gcm.c | 32 +++++++++-----------------------
 1 file changed, 9 insertions(+), 23 deletions(-)

diff --git a/crypto/gcm.c b/crypto/gcm.c
index e1a11f529d257..c7354ed1fa4d4 100644
--- a/crypto/gcm.c
+++ b/crypto/gcm.c
@@ -597,7 +597,6 @@ static void crypto_gcm_free(struct aead_instance *inst)
 
 static int crypto_gcm_create_common(struct crypto_template *tmpl,
 				    struct rtattr **tb,
-				    const char *full_name,
 				    const char *ctr_name,
 				    const char *ghash_name)
 {
@@ -638,7 +637,7 @@ static int crypto_gcm_create_common(struct crypto_template *tmpl,
 		goto err_free_inst;
 
 	err = -EINVAL;
-	if (ghash->digestsize != 16)
+	if (strcmp(ghash->base.cra_name, "ghash") != 0)
 		goto err_drop_ghash;
 
 	crypto_set_skcipher_spawn(&ctx->ctr, aead_crypto_instance(inst));
@@ -650,24 +649,23 @@ static int crypto_gcm_create_common(struct crypto_template *tmpl,
 
 	ctr = crypto_spawn_skcipher_alg(&ctx->ctr);
 
-	/* We only support 16-byte blocks. */
+	/* The skcipher algorithm must be CTR mode, using 16-byte blocks. */
 	err = -EINVAL;
-	if (crypto_skcipher_alg_ivsize(ctr) != 16)
+	if (strncmp(ctr->base.cra_name, "ctr(", 4) != 0 ||
+	    crypto_skcipher_alg_ivsize(ctr) != 16)
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
@@ -709,7 +707,6 @@ static int crypto_gcm_create(struct crypto_template *tmpl, struct rtattr **tb)
 {
 	const char *cipher_name;
 	char ctr_name[CRYPTO_MAX_ALG_NAME];
-	char full_name[CRYPTO_MAX_ALG_NAME];
 
 	cipher_name = crypto_attr_alg_name(tb[1]);
 	if (IS_ERR(cipher_name))
@@ -719,12 +716,7 @@ static int crypto_gcm_create(struct crypto_template *tmpl, struct rtattr **tb)
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
@@ -732,7 +724,6 @@ static int crypto_gcm_base_create(struct crypto_template *tmpl,
 {
 	const char *ctr_name;
 	const char *ghash_name;
-	char full_name[CRYPTO_MAX_ALG_NAME];
 
 	ctr_name = crypto_attr_alg_name(tb[1]);
 	if (IS_ERR(ctr_name))
@@ -742,12 +733,7 @@ static int crypto_gcm_base_create(struct crypto_template *tmpl,
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
2.21.0

