Return-Path: <SRS0=wI/w=Z4=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 48988C43603
	for <linux-crypto@archiver.kernel.org>; Fri,  6 Dec 2019 02:36:21 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 24E1D2245C
	for <linux-crypto@archiver.kernel.org>; Fri,  6 Dec 2019 02:36:21 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726206AbfLFCgU (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 5 Dec 2019 21:36:20 -0500
Received: from helcar.hmeau.com ([216.24.177.18]:37570 "EHLO deadmen.hmeau.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726273AbfLFCgU (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 5 Dec 2019 21:36:20 -0500
Received: from gondobar.mordor.me.apana.org.au ([192.168.128.4] helo=gondobar)
        by deadmen.hmeau.com with esmtps (Exim 4.89 #2 (Debian))
        id 1id3Tf-00034g-76
        for <linux-crypto@vger.kernel.org>; Fri, 06 Dec 2019 10:36:19 +0800
Received: from herbert by gondobar with local (Exim 4.89)
        (envelope-from <herbert@gondor.apana.org.au>)
        id 1id3Te-00077s-Ux; Fri, 06 Dec 2019 10:36:19 +0800
Subject: [PATCH 1/3] crypto: shash - Add init_tfm/exit_tfm and verify descsize
References: <20191206023527.k4kxngcsb7rpq2rz@gondor.apana.org.au>
To:     Linux Crypto Mailing List <linux-crypto@vger.kernel.org>
Message-Id: <E1id3Te-00077s-Ux@gondobar>
From:   Herbert Xu <herbert@gondor.apana.org.au>
Date:   Fri, 06 Dec 2019 10:36:18 +0800
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

The shash interface supports a dynamic descsize field because of
the presence of fallbacks (it's just padlock-sha actually, perhaps
we can remove it one day).  As it is the API does not verify the
setting of descsize at all.  It is up to the individual algorithms
to ensure that descsize does not exceed the specified maximum value
of HASH_MAX_DESCSIZE (going above would cause stack corruption).

In order to allow the API to impose this limit directly, this patch
adds init_tfm/exit_tfm hooks to the shash_alg structure.  We can
then verify the descsize setting in the API directly.

Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
---

 crypto/shash.c        |   25 +++++++++++++++++++++++++
 include/crypto/hash.h |   14 ++++++++++++++
 2 files changed, 39 insertions(+)

diff --git a/crypto/shash.c b/crypto/shash.c
index e83c5124f6eb..40628712feec 100644
--- a/crypto/shash.c
+++ b/crypto/shash.c
@@ -386,15 +386,40 @@ int crypto_init_shash_ops_async(struct crypto_tfm *tfm)
 	return 0;
 }
 
+static void crypto_shash_exit_tfm(struct crypto_tfm *tfm)
+{
+	struct crypto_shash *hash = __crypto_shash_cast(tfm);
+	struct shash_alg *alg = crypto_shash_alg(hash);
+
+	alg->exit_tfm(hash);
+}
+
 static int crypto_shash_init_tfm(struct crypto_tfm *tfm)
 {
 	struct crypto_shash *hash = __crypto_shash_cast(tfm);
 	struct shash_alg *alg = crypto_shash_alg(hash);
+	int err;
 
 	hash->descsize = alg->descsize;
 
 	shash_set_needkey(hash, alg);
 
+	if (alg->exit_tfm)
+		tfm->exit = crypto_shash_exit_tfm;
+
+	if (!alg->init_tfm)
+		return 0;
+
+	err = alg->init_tfm(hash);
+	if (err)
+		return err;
+
+	if (hash->descsize > HASH_MAX_DESCSIZE) {
+		if (alg->exit_tfm)
+			alg->exit_tfm(hash);
+		return -EINVAL;
+	}
+
 	return 0;
 }
 
diff --git a/include/crypto/hash.h b/include/crypto/hash.h
index fe7f73bad1e2..ba1435b38266 100644
--- a/include/crypto/hash.h
+++ b/include/crypto/hash.h
@@ -169,6 +169,18 @@ struct shash_desc {
  * @export: see struct ahash_alg
  * @import: see struct ahash_alg
  * @setkey: see struct ahash_alg
+ * @init_tfm: Initialize the cryptographic transformation object.
+ *	      This function is used to initialize the cryptographic
+ *	      transformation object.  This function is called only
+ *	      once at the instantiation time, right after the
+ *	      transformation context was allocated. In case the
+ *	      cryptographic hardware has some special requirements
+ *	      which need to be handled by software, this function
+ *	      shall check for the precise requirement of the
+ *	      transformation and put any software fallbacks in place.
+ * @exit_tfm: Deinitialize the cryptographic transformation object.
+ *	      This is a counterpart to @init_tfm, used to remove
+ *	      various changes set in @init_tfm.
  * @digestsize: see struct ahash_alg
  * @statesize: see struct ahash_alg
  * @descsize: Size of the operational state for the message digest. This state
@@ -189,6 +201,8 @@ struct shash_alg {
 	int (*import)(struct shash_desc *desc, const void *in);
 	int (*setkey)(struct crypto_shash *tfm, const u8 *key,
 		      unsigned int keylen);
+	int (*init_tfm)(struct crypto_shash *tfm);
+	void (*exit_tfm)(struct crypto_shash *tfm);
 
 	unsigned int descsize;
 
