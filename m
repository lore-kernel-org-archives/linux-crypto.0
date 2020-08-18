Return-Path: <SRS0=RX8q=B4=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CFC72C433E1
	for <linux-crypto@archiver.kernel.org>; Tue, 18 Aug 2020 08:25:37 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id AE858206B5
	for <linux-crypto@archiver.kernel.org>; Tue, 18 Aug 2020 08:25:37 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726374AbgHRIZh (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Tue, 18 Aug 2020 04:25:37 -0400
Received: from helcar.hmeau.com ([216.24.177.18]:42310 "EHLO fornost.hmeau.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726203AbgHRIZg (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 18 Aug 2020 04:25:36 -0400
Received: from gwarestrin.arnor.me.apana.org.au ([192.168.0.7])
        by fornost.hmeau.com with smtp (Exim 4.92 #5 (Debian))
        id 1k7ww2-0000dq-2M; Tue, 18 Aug 2020 18:25:35 +1000
Received: by gwarestrin.arnor.me.apana.org.au (sSMTP sendmail emulation); Tue, 18 Aug 2020 18:25:34 +1000
From:   "Herbert Xu" <herbert@gondor.apana.org.au>
Date:   Tue, 18 Aug 2020 18:25:34 +1000
Subject: [PATCH 3/6] crypto: ahash - Add init_tfm/exit_tfm
References: <20200818082410.GA24497@gondor.apana.org.au>
To:     Ard Biesheuvel <ardb@kernel.org>, linux-crypto@vger.kernel.org,
        ebiggers@kernel.org, Ben Greear <greearb@candelatech.com>
Message-Id: <E1k7ww2-0000dq-2M@fornost.hmeau.com>
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

This patch adds the type-safe init_tfm/exit_tfm functions to the
ahash interface.  This is meant to replace the unsafe cra_init and
cra_exit interface.

Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
---

 crypto/ahash.c        |   13 ++++++++++++-
 include/crypto/hash.h |   13 +++++++++++++
 2 files changed, 25 insertions(+), 1 deletion(-)

diff --git a/crypto/ahash.c b/crypto/ahash.c
index 3398e43d66f01..c55b10e6c825d 100644
--- a/crypto/ahash.c
+++ b/crypto/ahash.c
@@ -477,6 +477,14 @@ static int ahash_def_finup(struct ahash_request *req)
 	return ahash_def_finup_finish1(req, err);
 }
 
+static void crypto_ahash_exit_tfm(struct crypto_tfm *tfm)
+{
+	struct crypto_ahash *hash = __crypto_ahash_cast(tfm);
+	struct ahash_alg *alg = crypto_ahash_alg(hash);
+
+	alg->exit_tfm(hash);
+}
+
 static int crypto_ahash_init_tfm(struct crypto_tfm *tfm)
 {
 	struct crypto_ahash *hash = __crypto_ahash_cast(tfm);
@@ -500,7 +508,10 @@ static int crypto_ahash_init_tfm(struct crypto_tfm *tfm)
 		ahash_set_needkey(hash);
 	}
 
-	return 0;
+	if (alg->exit_tfm)
+		tfm->exit = crypto_ahash_exit_tfm;
+
+	return alg->init_tfm ? alg->init_tfm(hash) : 0;
 }
 
 static unsigned int crypto_ahash_extsize(struct crypto_alg *alg)
diff --git a/include/crypto/hash.h b/include/crypto/hash.h
index 19ce91f2359f5..c9d3fd3efa1b0 100644
--- a/include/crypto/hash.h
+++ b/include/crypto/hash.h
@@ -123,6 +123,17 @@ struct ahash_request {
  *	    data so the transformation can continue from this point onward. No
  *	    data processing happens at this point. Driver must not use
  *	    req->result.
+ * @init_tfm: Initialize the cryptographic transformation object.
+ *	      This function is called only once at the instantiation
+ *	      time, right after the transformation context was
+ *	      allocated. In case the cryptographic hardware has
+ *	      some special requirements which need to be handled
+ *	      by software, this function shall check for the precise
+ *	      requirement of the transformation and put any software
+ *	      fallbacks in place.
+ * @exit_tfm: Deinitialize the cryptographic transformation object.
+ *	      This is a counterpart to @init_tfm, used to remove
+ *	      various changes set in @init_tfm.
  * @halg: see struct hash_alg_common
  */
 struct ahash_alg {
@@ -135,6 +146,8 @@ struct ahash_alg {
 	int (*import)(struct ahash_request *req, const void *in);
 	int (*setkey)(struct crypto_ahash *tfm, const u8 *key,
 		      unsigned int keylen);
+	int (*init_tfm)(struct crypto_ahash *tfm);
+	void (*exit_tfm)(struct crypto_ahash *tfm);
 
 	struct hash_alg_common halg;
 };
