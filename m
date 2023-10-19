Return-Path: <linux-crypto-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 472C7CDB465
	for <linux-crypto@archiver.kernel.org>; Thu, 19 Oct 2023 05:54:37 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231705AbjJSFyg (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 19 Oct 2023 01:54:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55462 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232678AbjJSFyR (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 19 Oct 2023 01:54:17 -0400
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D589C112
        for <linux-crypto@vger.kernel.org>; Wed, 18 Oct 2023 22:54:14 -0700 (PDT)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A79B5C433CA
        for <linux-crypto@vger.kernel.org>; Thu, 19 Oct 2023 05:54:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1697694854;
        bh=Q/ICmAR+hC7qnlX/jlK/bjhFFZtdntEIDOUu3Skh/nU=;
        h=From:To:Subject:Date:In-Reply-To:References:From;
        b=hH5m5fcIkTYfxyF6ttq+Qul7pZaUHgFgd+6wJnpSmN8SvYF5TwNG8skmiUUeZXhVg
         qBPQrCw3ivkgiG2KiF3r/bwl5JsnGi8EIdkjD68zRt6ptkr/s9uIyTGyLBGvDq9OvN
         pm8llPdsfDVqYsUFVkOvHKR1TnaBbu0rj49OAiX3qzJR5L8UZFee6Vt2jsJ1NqCc31
         vffCckOeMbwq/RsDxq6Y/ixeP/EXrnOCEzuC0w2dQyQvH6FtXZ2Mvjm1aEZQ6g/n3m
         qj9zVOKd/EAV70AZpUA0gPjk9Ft1seBh9BTzZGEjkVD6OQAoyO+hX75zKcF+PKyqr8
         IsJ1NtAyPC7tA==
From:   Eric Biggers <ebiggers@kernel.org>
To:     linux-crypto@vger.kernel.org
Subject: [PATCH 11/17] crypto: shash - remove support for nonzero alignmask
Date:   Wed, 18 Oct 2023 22:53:37 -0700
Message-ID: <20231019055343.588846-12-ebiggers@kernel.org>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20231019055343.588846-1-ebiggers@kernel.org>
References: <20231019055343.588846-1-ebiggers@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

From: Eric Biggers <ebiggers@google.com>

Currently, the shash API checks the alignment of all message, key, and
digest buffers against the algorithm's declared alignmask, and for any
unaligned buffers it falls back to manually aligned temporary buffers.

This is virtually useless, however.  In the case of the message buffer,
cryptographic hash functions internally operate on fixed-size blocks, so
implementations end up needing to deal with byte-aligned data anyway
because the length(s) passed to ->update might not be divisible by the
block size.  Word-alignment of the message can theoretically be helpful
for CRCs, like what was being done in crc32c-sparc64.  But in practice
it's better for the algorithms to use unaligned accesses or align the
message themselves.  A similar argument applies to the key and digest.

In any case, no shash algorithms actually set a nonzero alignmask
anymore.  Therefore, remove support for it from shash.  The benefit is
that all the code to handle "misaligned" buffers in the shash API goes
away, reducing the overhead of the shash API.

Signed-off-by: Eric Biggers <ebiggers@google.com>
---
 crypto/shash.c | 128 ++++---------------------------------------------
 1 file changed, 8 insertions(+), 120 deletions(-)

diff --git a/crypto/shash.c b/crypto/shash.c
index 52420c41db44a..409b33f9c97cc 100644
--- a/crypto/shash.c
+++ b/crypto/shash.c
@@ -3,264 +3,151 @@
  * Synchronous Cryptographic Hash operations.
  *
  * Copyright (c) 2008 Herbert Xu <herbert@gondor.apana.org.au>
  */
 
 #include <crypto/scatterwalk.h>
 #include <linux/cryptouser.h>
 #include <linux/err.h>
 #include <linux/kernel.h>
 #include <linux/module.h>
-#include <linux/slab.h>
 #include <linux/seq_file.h>
 #include <linux/string.h>
 #include <net/netlink.h>
 
 #include "hash.h"
 
-#define MAX_SHASH_ALIGNMASK 63
-
 static const struct crypto_type crypto_shash_type;
 
 static inline struct crypto_istat_hash *shash_get_stat(struct shash_alg *alg)
 {
 	return hash_get_stat(&alg->halg);
 }
 
 static inline int crypto_shash_errstat(struct shash_alg *alg, int err)
 {
 	return crypto_hash_errstat(&alg->halg, err);
 }
 
 int shash_no_setkey(struct crypto_shash *tfm, const u8 *key,
 		    unsigned int keylen)
 {
 	return -ENOSYS;
 }
 EXPORT_SYMBOL_GPL(shash_no_setkey);
 
-static int shash_setkey_unaligned(struct crypto_shash *tfm, const u8 *key,
-				  unsigned int keylen)
-{
-	struct shash_alg *shash = crypto_shash_alg(tfm);
-	unsigned long alignmask = crypto_shash_alignmask(tfm);
-	unsigned long absize;
-	u8 *buffer, *alignbuffer;
-	int err;
-
-	absize = keylen + (alignmask & ~(crypto_tfm_ctx_alignment() - 1));
-	buffer = kmalloc(absize, GFP_ATOMIC);
-	if (!buffer)
-		return -ENOMEM;
-
-	alignbuffer = (u8 *)ALIGN((unsigned long)buffer, alignmask + 1);
-	memcpy(alignbuffer, key, keylen);
-	err = shash->setkey(tfm, alignbuffer, keylen);
-	kfree_sensitive(buffer);
-	return err;
-}
-
 static void shash_set_needkey(struct crypto_shash *tfm, struct shash_alg *alg)
 {
 	if (crypto_shash_alg_needs_key(alg))
 		crypto_shash_set_flags(tfm, CRYPTO_TFM_NEED_KEY);
 }
 
 int crypto_shash_setkey(struct crypto_shash *tfm, const u8 *key,
 			unsigned int keylen)
 {
 	struct shash_alg *shash = crypto_shash_alg(tfm);
-	unsigned long alignmask = crypto_shash_alignmask(tfm);
 	int err;
 
-	if ((unsigned long)key & alignmask)
-		err = shash_setkey_unaligned(tfm, key, keylen);
-	else
-		err = shash->setkey(tfm, key, keylen);
-
+	err = shash->setkey(tfm, key, keylen);
 	if (unlikely(err)) {
 		shash_set_needkey(tfm, shash);
 		return err;
 	}
 
 	crypto_shash_clear_flags(tfm, CRYPTO_TFM_NEED_KEY);
 	return 0;
 }
 EXPORT_SYMBOL_GPL(crypto_shash_setkey);
 
-static int shash_update_unaligned(struct shash_desc *desc, const u8 *data,
-				  unsigned int len)
-{
-	struct crypto_shash *tfm = desc->tfm;
-	struct shash_alg *shash = crypto_shash_alg(tfm);
-	unsigned long alignmask = crypto_shash_alignmask(tfm);
-	unsigned int unaligned_len = alignmask + 1 -
-				     ((unsigned long)data & alignmask);
-	/*
-	 * We cannot count on __aligned() working for large values:
-	 * https://patchwork.kernel.org/patch/9507697/
-	 */
-	u8 ubuf[MAX_SHASH_ALIGNMASK * 2];
-	u8 *buf = PTR_ALIGN(&ubuf[0], alignmask + 1);
-	int err;
-
-	if (WARN_ON(buf + unaligned_len > ubuf + sizeof(ubuf)))
-		return -EINVAL;
-
-	if (unaligned_len > len)
-		unaligned_len = len;
-
-	memcpy(buf, data, unaligned_len);
-	err = shash->update(desc, buf, unaligned_len);
-	memset(buf, 0, unaligned_len);
-
-	return err ?:
-	       shash->update(desc, data + unaligned_len, len - unaligned_len);
-}
-
 int crypto_shash_update(struct shash_desc *desc, const u8 *data,
 			unsigned int len)
 {
-	struct crypto_shash *tfm = desc->tfm;
-	struct shash_alg *shash = crypto_shash_alg(tfm);
-	unsigned long alignmask = crypto_shash_alignmask(tfm);
+	struct shash_alg *shash = crypto_shash_alg(desc->tfm);
 	int err;
 
 	if (IS_ENABLED(CONFIG_CRYPTO_STATS))
 		atomic64_add(len, &shash_get_stat(shash)->hash_tlen);
 
-	if ((unsigned long)data & alignmask)
-		err = shash_update_unaligned(desc, data, len);
-	else
-		err = shash->update(desc, data, len);
+	err = shash->update(desc, data, len);
 
 	return crypto_shash_errstat(shash, err);
 }
 EXPORT_SYMBOL_GPL(crypto_shash_update);
 
-static int shash_final_unaligned(struct shash_desc *desc, u8 *out)
-{
-	struct crypto_shash *tfm = desc->tfm;
-	unsigned long alignmask = crypto_shash_alignmask(tfm);
-	struct shash_alg *shash = crypto_shash_alg(tfm);
-	unsigned int ds = crypto_shash_digestsize(tfm);
-	/*
-	 * We cannot count on __aligned() working for large values:
-	 * https://patchwork.kernel.org/patch/9507697/
-	 */
-	u8 ubuf[MAX_SHASH_ALIGNMASK + HASH_MAX_DIGESTSIZE];
-	u8 *buf = PTR_ALIGN(&ubuf[0], alignmask + 1);
-	int err;
-
-	if (WARN_ON(buf + ds > ubuf + sizeof(ubuf)))
-		return -EINVAL;
-
-	err = shash->final(desc, buf);
-	if (err)
-		goto out;
-
-	memcpy(out, buf, ds);
-
-out:
-	memset(buf, 0, ds);
-	return err;
-}
-
 int crypto_shash_final(struct shash_desc *desc, u8 *out)
 {
-	struct crypto_shash *tfm = desc->tfm;
-	struct shash_alg *shash = crypto_shash_alg(tfm);
-	unsigned long alignmask = crypto_shash_alignmask(tfm);
+	struct shash_alg *shash = crypto_shash_alg(desc->tfm);
 	int err;
 
 	if (IS_ENABLED(CONFIG_CRYPTO_STATS))
 		atomic64_inc(&shash_get_stat(shash)->hash_cnt);
 
-	if ((unsigned long)out & alignmask)
-		err = shash_final_unaligned(desc, out);
-	else
-		err = shash->final(desc, out);
+	err = shash->final(desc, out);
 
 	return crypto_shash_errstat(shash, err);
 }
 EXPORT_SYMBOL_GPL(crypto_shash_final);
 
-static int shash_finup_unaligned(struct shash_desc *desc, const u8 *data,
-				 unsigned int len, u8 *out)
-{
-	return shash_update_unaligned(desc, data, len) ?:
-	       shash_final_unaligned(desc, out);
-}
-
 static int shash_default_finup(struct shash_desc *desc, const u8 *data,
 			       unsigned int len, u8 *out)
 {
 	struct shash_alg *shash = crypto_shash_alg(desc->tfm);
 
 	return shash->update(desc, data, len) ?:
 	       shash->final(desc, out);
 }
 
 int crypto_shash_finup(struct shash_desc *desc, const u8 *data,
 		       unsigned int len, u8 *out)
 {
 	struct crypto_shash *tfm = desc->tfm;
 	struct shash_alg *shash = crypto_shash_alg(tfm);
-	unsigned long alignmask = crypto_shash_alignmask(tfm);
 	int err;
 
 	if (IS_ENABLED(CONFIG_CRYPTO_STATS)) {
 		struct crypto_istat_hash *istat = shash_get_stat(shash);
 
 		atomic64_inc(&istat->hash_cnt);
 		atomic64_add(len, &istat->hash_tlen);
 	}
 
-	if (((unsigned long)data | (unsigned long)out) & alignmask)
-		err = shash_finup_unaligned(desc, data, len, out);
-	else
-		err = shash->finup(desc, data, len, out);
-
+	err = shash->finup(desc, data, len, out);
 
 	return crypto_shash_errstat(shash, err);
 }
 EXPORT_SYMBOL_GPL(crypto_shash_finup);
 
 static int shash_default_digest(struct shash_desc *desc, const u8 *data,
 				unsigned int len, u8 *out)
 {
 	struct shash_alg *shash = crypto_shash_alg(desc->tfm);
 
 	return shash->init(desc) ?:
 	       shash->finup(desc, data, len, out);
 }
 
 int crypto_shash_digest(struct shash_desc *desc, const u8 *data,
 			unsigned int len, u8 *out)
 {
 	struct crypto_shash *tfm = desc->tfm;
 	struct shash_alg *shash = crypto_shash_alg(tfm);
-	unsigned long alignmask = crypto_shash_alignmask(tfm);
 	int err;
 
 	if (IS_ENABLED(CONFIG_CRYPTO_STATS)) {
 		struct crypto_istat_hash *istat = shash_get_stat(shash);
 
 		atomic64_inc(&istat->hash_cnt);
 		atomic64_add(len, &istat->hash_tlen);
 	}
 
 	if (crypto_shash_get_flags(tfm) & CRYPTO_TFM_NEED_KEY)
 		err = -ENOKEY;
-	else if (((unsigned long)data | (unsigned long)out) & alignmask)
-		err = shash->init(desc) ?:
-		      shash_finup_unaligned(desc, data, len, out);
 	else
 		err = shash->digest(desc, data, len, out);
 
 	return crypto_shash_errstat(shash, err);
 }
 EXPORT_SYMBOL_GPL(crypto_shash_digest);
 
 int crypto_shash_tfm_digest(struct crypto_shash *tfm, const u8 *data,
 			    unsigned int len, u8 *out)
 {
@@ -663,21 +550,22 @@ int hash_prepare_alg(struct hash_alg_common *alg)
 }
 
 static int shash_prepare_alg(struct shash_alg *alg)
 {
 	struct crypto_alg *base = &alg->halg.base;
 	int err;
 
 	if (alg->descsize > HASH_MAX_DESCSIZE)
 		return -EINVAL;
 
-	if (base->cra_alignmask > MAX_SHASH_ALIGNMASK)
+	/* alignmask is not useful for shash, so it is not supported. */
+	if (base->cra_alignmask)
 		return -EINVAL;
 
 	if ((alg->export && !alg->import) || (alg->import && !alg->export))
 		return -EINVAL;
 
 	err = hash_prepare_alg(&alg->halg);
 	if (err)
 		return err;
 
 	base->cra_type = &crypto_shash_type;
-- 
2.42.0

