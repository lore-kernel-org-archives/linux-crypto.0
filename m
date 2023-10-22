Return-Path: <linux-crypto-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0485AC25B42
	for <linux-crypto@archiver.kernel.org>; Sun, 22 Oct 2023 08:19:16 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231463AbjJVITP (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Sun, 22 Oct 2023 04:19:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37420 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231752AbjJVISx (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Sun, 22 Oct 2023 04:18:53 -0400
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3341FD66
        for <linux-crypto@vger.kernel.org>; Sun, 22 Oct 2023 01:18:50 -0700 (PDT)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CC2FCC433CD
        for <linux-crypto@vger.kernel.org>; Sun, 22 Oct 2023 08:18:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1697962729;
        bh=qYUoZ18gV/v9jD2C+nhy14QvgKVFOozIRdZNRKQCNb0=;
        h=From:To:Subject:Date:In-Reply-To:References:From;
        b=N6hzRrGvROWevpi/EXGK04ga/MBD4MUyiIRZ7McDxsTUp8y+sl+ANitL+Zv2+hwik
         Iv2NlpWq8aN31t6yGig4r+wnAN0wBQw59LnR+sDlrpFkGuXwxNYJjBX/PjELYPVnn4
         O3v0zLlJZl2b3cAPJd0400iBRQCdo71IGE5i/L91wrf7Dv4bE+3/YOMCbkHs9ZUkpT
         mrtkVNdUeN6V8JIA0H3TUTBD17GMeHnPKEYxIzCpdl6jlelcfaX57S8XvfHinly2vx
         VGexSVPwbP9ubD+LUce0nGdOLkBuvDBmrScQedl18IZ4gvTz+n8D56Tkw3ELL14hLq
         NKZnjz+xKLtoA==
From:   Eric Biggers <ebiggers@kernel.org>
To:     linux-crypto@vger.kernel.org
Subject: [PATCH 29/30] crypto: ahash - check for shash type instead of not ahash type
Date:   Sun, 22 Oct 2023 01:10:59 -0700
Message-ID: <20231022081100.123613-30-ebiggers@kernel.org>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20231022081100.123613-1-ebiggers@kernel.org>
References: <20231022081100.123613-1-ebiggers@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

From: Eric Biggers <ebiggers@google.com>

Since the previous patch made crypto_shash_type visible to ahash.c,
change checks for '->cra_type != &crypto_ahash_type' to '->cra_type ==
&crypto_shash_type'.  This makes more sense and avoids having to
forward-declare crypto_ahash_type.  The result is still the same, since
the type is either shash or ahash here.

Signed-off-by: Eric Biggers <ebiggers@google.com>
---
 crypto/ahash.c | 8 +++-----
 1 file changed, 3 insertions(+), 5 deletions(-)

diff --git a/crypto/ahash.c b/crypto/ahash.c
index 74be1eb26c1aa..96fec0ca202af 100644
--- a/crypto/ahash.c
+++ b/crypto/ahash.c
@@ -20,22 +20,20 @@
 #include <linux/sched.h>
 #include <linux/slab.h>
 #include <linux/seq_file.h>
 #include <linux/string.h>
 #include <net/netlink.h>
 
 #include "hash.h"
 
 #define CRYPTO_ALG_TYPE_AHASH_MASK	0x0000000e
 
-static const struct crypto_type crypto_ahash_type;
-
 static int shash_async_setkey(struct crypto_ahash *tfm, const u8 *key,
 			      unsigned int keylen)
 {
 	struct crypto_shash **ctx = crypto_ahash_ctx(tfm);
 
 	return crypto_shash_setkey(*ctx, key, keylen);
 }
 
 static int shash_async_init(struct ahash_request *req)
 {
@@ -504,21 +502,21 @@ static void crypto_ahash_exit_tfm(struct crypto_tfm *tfm)
 
 static int crypto_ahash_init_tfm(struct crypto_tfm *tfm)
 {
 	struct crypto_ahash *hash = __crypto_ahash_cast(tfm);
 	struct ahash_alg *alg = crypto_ahash_alg(hash);
 
 	hash->setkey = ahash_nosetkey;
 
 	crypto_ahash_set_statesize(hash, alg->halg.statesize);
 
-	if (tfm->__crt_alg->cra_type != &crypto_ahash_type)
+	if (tfm->__crt_alg->cra_type == &crypto_shash_type)
 		return crypto_init_shash_ops_async(tfm);
 
 	hash->init = alg->init;
 	hash->update = alg->update;
 	hash->final = alg->final;
 	hash->finup = alg->finup ?: ahash_def_finup;
 	hash->digest = alg->digest;
 	hash->export = alg->export;
 	hash->import = alg->import;
 
@@ -528,21 +526,21 @@ static int crypto_ahash_init_tfm(struct crypto_tfm *tfm)
 	}
 
 	if (alg->exit_tfm)
 		tfm->exit = crypto_ahash_exit_tfm;
 
 	return alg->init_tfm ? alg->init_tfm(hash) : 0;
 }
 
 static unsigned int crypto_ahash_extsize(struct crypto_alg *alg)
 {
-	if (alg->cra_type != &crypto_ahash_type)
+	if (alg->cra_type == &crypto_shash_type)
 		return sizeof(struct crypto_shash *);
 
 	return crypto_alg_extsize(alg);
 }
 
 static void crypto_ahash_free_instance(struct crypto_instance *inst)
 {
 	struct ahash_instance *ahash = ahash_instance(inst);
 
 	ahash->free(ahash);
@@ -753,19 +751,19 @@ int ahash_register_instance(struct crypto_template *tmpl,
 		return err;
 
 	return crypto_register_instance(tmpl, ahash_crypto_instance(inst));
 }
 EXPORT_SYMBOL_GPL(ahash_register_instance);
 
 bool crypto_hash_alg_has_setkey(struct hash_alg_common *halg)
 {
 	struct crypto_alg *alg = &halg->base;
 
-	if (alg->cra_type != &crypto_ahash_type)
+	if (alg->cra_type == &crypto_shash_type)
 		return crypto_shash_alg_has_setkey(__crypto_shash_alg(alg));
 
 	return __crypto_ahash_alg(alg)->setkey != NULL;
 }
 EXPORT_SYMBOL_GPL(crypto_hash_alg_has_setkey);
 
 MODULE_LICENSE("GPL");
 MODULE_DESCRIPTION("Asynchronous cryptographic hash type");
-- 
2.42.0

