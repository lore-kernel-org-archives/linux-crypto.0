Return-Path: <linux-crypto-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 990A2CDB482
	for <linux-crypto@archiver.kernel.org>; Wed, 18 Oct 2023 22:36:43 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229726AbjJRWgn (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Wed, 18 Oct 2023 18:36:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59812 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229487AbjJRWgm (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 18 Oct 2023 18:36:42 -0400
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BB795AB
        for <linux-crypto@vger.kernel.org>; Wed, 18 Oct 2023 15:36:40 -0700 (PDT)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 55FEBC433C8
        for <linux-crypto@vger.kernel.org>; Wed, 18 Oct 2023 22:36:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1697668600;
        bh=gAXwlRJb8P0AoXgcvtNHrMqvX/MCq7j9aYwOf8xxS+o=;
        h=From:To:Subject:Date:From;
        b=qwt1wD6EFEjrkhMPGoTPFMAO8RW/wMAYxIJYMxnm87gwqMw1sl4wdUeI4wsUertES
         0KLprHmknZ3Ff6uX4KClw0u11o26dONJypWU7b4L7Bn/dHI8AajbuotUlQz42YG2N9
         FMzNCAKwo5zy6xFPLNT5abRdOF4R7iPGekqzF3TbzLCnE9TfXRo4hFYE0yR7kz1vX0
         GCWlBVqwFW09ggHtjh5WlnFPVb7cFNHuWOwaZc2ELpLE/zxEPCuswblcW2pdhFSI9i
         9vCFzWodn7+MgJgXGttGlZFLFti31oglI9kWo0AMmxuPBkG0TXwyfvz5ZBdCRqIKMh
         CvrV/tdPPZTNg==
From:   Eric Biggers <ebiggers@kernel.org>
To:     linux-crypto@vger.kernel.org
Subject: [PATCH] crypto: shash - eliminate indirect call for default import and export
Date:   Wed, 18 Oct 2023 15:34:55 -0700
Message-ID: <20231018223455.95609-1-ebiggers@kernel.org>
X-Mailer: git-send-email 2.42.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

From: Eric Biggers <ebiggers@google.com>

Most shash algorithms don't have custom ->import and ->export functions,
resulting in the memcpy() based default being used.  Yet,
crypto_shash_import() and crypto_shash_export() still make an indirect
call, which is expensive.  Therefore, change how the default import and
export are called to make it so that crypto_shash_import() and
crypto_shash_export() don't do an indirect call in this case.

Signed-off-by: Eric Biggers <ebiggers@google.com>
---
 crypto/shash.c        | 41 +++++++++++++++++++++++++++++++++--------
 include/crypto/hash.h | 15 ++-------------
 2 files changed, 35 insertions(+), 21 deletions(-)

diff --git a/crypto/shash.c b/crypto/shash.c
index 15fee57cca8ef..52420c41db44a 100644
--- a/crypto/shash.c
+++ b/crypto/shash.c
@@ -270,31 +270,48 @@ int crypto_shash_tfm_digest(struct crypto_shash *tfm, const u8 *data,
 	desc->tfm = tfm;
 
 	err = crypto_shash_digest(desc, data, len, out);
 
 	shash_desc_zero(desc);
 
 	return err;
 }
 EXPORT_SYMBOL_GPL(crypto_shash_tfm_digest);
 
-static int shash_default_export(struct shash_desc *desc, void *out)
+int crypto_shash_export(struct shash_desc *desc, void *out)
 {
-	memcpy(out, shash_desc_ctx(desc), crypto_shash_descsize(desc->tfm));
+	struct crypto_shash *tfm = desc->tfm;
+	struct shash_alg *shash = crypto_shash_alg(tfm);
+
+	if (shash->export)
+		return shash->export(desc, out);
+
+	memcpy(out, shash_desc_ctx(desc), crypto_shash_descsize(tfm));
 	return 0;
 }
+EXPORT_SYMBOL_GPL(crypto_shash_export);
 
-static int shash_default_import(struct shash_desc *desc, const void *in)
+int crypto_shash_import(struct shash_desc *desc, const void *in)
 {
-	memcpy(shash_desc_ctx(desc), in, crypto_shash_descsize(desc->tfm));
+	struct crypto_shash *tfm = desc->tfm;
+	struct shash_alg *shash = crypto_shash_alg(tfm);
+
+	if (crypto_shash_get_flags(tfm) & CRYPTO_TFM_NEED_KEY)
+		return -ENOKEY;
+
+	if (shash->import)
+		return shash->import(desc, in);
+
+	memcpy(shash_desc_ctx(desc), in, crypto_shash_descsize(tfm));
 	return 0;
 }
+EXPORT_SYMBOL_GPL(crypto_shash_import);
 
 static int shash_async_setkey(struct crypto_ahash *tfm, const u8 *key,
 			      unsigned int keylen)
 {
 	struct crypto_shash **ctx = crypto_ahash_ctx(tfm);
 
 	return crypto_shash_setkey(*ctx, key, keylen);
 }
 
 static int shash_async_init(struct ahash_request *req)
@@ -659,29 +676,37 @@ static int shash_prepare_alg(struct shash_alg *alg)
 	if ((alg->export && !alg->import) || (alg->import && !alg->export))
 		return -EINVAL;
 
 	err = hash_prepare_alg(&alg->halg);
 	if (err)
 		return err;
 
 	base->cra_type = &crypto_shash_type;
 	base->cra_flags |= CRYPTO_ALG_TYPE_SHASH;
 
+	/*
+	 * Handle missing optional functions.  For each one we can either
+	 * install a default here, or we can leave the pointer as NULL and check
+	 * the pointer for NULL in crypto_shash_*(), avoiding an indirect call
+	 * when the default behavior is desired.  For ->finup and ->digest we
+	 * install defaults, since for optimal performance algorithms should
+	 * implement these anyway.  On the other hand, for ->import and
+	 * ->export the common case and best performance comes from the simple
+	 * memcpy of the shash_desc_ctx, so when those pointers are NULL we
+	 * leave them NULL and provide the memcpy with no indirect call.
+	 */
 	if (!alg->finup)
 		alg->finup = shash_default_finup;
 	if (!alg->digest)
 		alg->digest = shash_default_digest;
-	if (!alg->export) {
-		alg->export = shash_default_export;
-		alg->import = shash_default_import;
+	if (!alg->export)
 		alg->halg.statesize = alg->descsize;
-	}
 	if (!alg->setkey)
 		alg->setkey = shash_no_setkey;
 
 	return 0;
 }
 
 int crypto_register_shash(struct shash_alg *alg)
 {
 	struct crypto_alg *base = &alg->base;
 	int err;
diff --git a/include/crypto/hash.h b/include/crypto/hash.h
index f7c2a22cd776d..52e57e93b2f59 100644
--- a/include/crypto/hash.h
+++ b/include/crypto/hash.h
@@ -945,46 +945,35 @@ int crypto_shash_tfm_digest(struct crypto_shash *tfm, const u8 *data,
  * @desc: reference to the operational state handle whose state is exported
  * @out: output buffer of sufficient size that can hold the hash state
  *
  * This function exports the hash state of the operational state handle into the
  * caller-allocated output buffer out which must have sufficient size (e.g. by
  * calling crypto_shash_descsize).
  *
  * Context: Any context.
  * Return: 0 if the export creation was successful; < 0 if an error occurred
  */
-static inline int crypto_shash_export(struct shash_desc *desc, void *out)
-{
-	return crypto_shash_alg(desc->tfm)->export(desc, out);
-}
+int crypto_shash_export(struct shash_desc *desc, void *out);
 
 /**
  * crypto_shash_import() - import operational state
  * @desc: reference to the operational state handle the state imported into
  * @in: buffer holding the state
  *
  * This function imports the hash state into the operational state handle from
  * the input buffer. That buffer should have been generated with the
  * crypto_ahash_export function.
  *
  * Context: Any context.
  * Return: 0 if the import was successful; < 0 if an error occurred
  */
-static inline int crypto_shash_import(struct shash_desc *desc, const void *in)
-{
-	struct crypto_shash *tfm = desc->tfm;
-
-	if (crypto_shash_get_flags(tfm) & CRYPTO_TFM_NEED_KEY)
-		return -ENOKEY;
-
-	return crypto_shash_alg(tfm)->import(desc, in);
-}
+int crypto_shash_import(struct shash_desc *desc, const void *in);
 
 /**
  * crypto_shash_init() - (re)initialize message digest
  * @desc: operational state handle that is already filled
  *
  * The call (re-)initializes the message digest referenced by the
  * operational state handle. Any potentially existing state created by
  * previous operations is discarded.
  *
  * Context: Any context.

base-commit: 5b90073defd1a52aa8120403d79f6e0fc10c87ee
prerequisite-patch-id: 77bd65b07cfc27f172b1698e0c4d43d6aba7ad8f
prerequisite-patch-id: 3ccf94d7048db0fee9407b5b5fa48554e115b56b
-- 
2.42.0

