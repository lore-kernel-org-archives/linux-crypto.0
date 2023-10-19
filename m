Return-Path: <linux-crypto-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 78D32CDB485
	for <linux-crypto@archiver.kernel.org>; Thu, 19 Oct 2023 05:54:37 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232057AbjJSFyg (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 19 Oct 2023 01:54:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55464 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232683AbjJSFyR (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 19 Oct 2023 01:54:17 -0400
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9C97AB6
        for <linux-crypto@vger.kernel.org>; Wed, 18 Oct 2023 22:54:15 -0700 (PDT)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3D13CC433CC
        for <linux-crypto@vger.kernel.org>; Thu, 19 Oct 2023 05:54:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1697694855;
        bh=rDKS+YvCLRvkbTwqkwMcOAISlL7GPSBnvGKjtB0WB6E=;
        h=From:To:Subject:Date:In-Reply-To:References:From;
        b=fUh0PtvtFDXqoxVBd27XQlUtMdOsxPo50Wqb9jbwAFfXp3PDPpeJPA92LFsKLlT+y
         f0aNzXuG9fhBT5aB6D0tEvWwpPQC44S8F7s49BZmRAyaOCjRIEtJK0eL9Q2e6lUWpj
         RxUzE8vCM7d4mJu/ntxTLSzesnHdrlb66Nb+5KYh6Uq+YylgDVhncY1vM/7f+lJMdU
         Rsc0uKg4kkfgiuo7lyRcHZHGTh5b+duFLnLGYYE7RjnEBfAnXpIBfNF3KV42sQ/6SW
         WGuWqLWKdNYybwEJnH21kLB0WZ5oBJ1QNGmRwj42D7dvs5RqoNBX20EohFaJt4D77z
         HTLHFTur3SAew==
From:   Eric Biggers <ebiggers@kernel.org>
To:     linux-crypto@vger.kernel.org
Subject: [PATCH 14/17] crypto: testmgr - stop checking crypto_shash_alignmask
Date:   Wed, 18 Oct 2023 22:53:40 -0700
Message-ID: <20231019055343.588846-15-ebiggers@kernel.org>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20231019055343.588846-1-ebiggers@kernel.org>
References: <20231019055343.588846-1-ebiggers@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

From: Eric Biggers <ebiggers@google.com>

Now that the shash algorithm type does not support nonzero alignmasks,
crypto_shash_alignmask() always returns 0 and will be removed.  In
preparation for this, stop checking crypto_shash_alignmask() in testmgr.

Signed-off-by: Eric Biggers <ebiggers@google.com>
---
 crypto/testmgr.c | 5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

diff --git a/crypto/testmgr.c b/crypto/testmgr.c
index 54135c7610f06..48a0929c7a158 100644
--- a/crypto/testmgr.c
+++ b/crypto/testmgr.c
@@ -1268,50 +1268,49 @@ static inline int check_shash_op(const char *op, int err,
 
 /* Test one hash test vector in one configuration, using the shash API */
 static int test_shash_vec_cfg(const struct hash_testvec *vec,
 			      const char *vec_name,
 			      const struct testvec_config *cfg,
 			      struct shash_desc *desc,
 			      struct test_sglist *tsgl,
 			      u8 *hashstate)
 {
 	struct crypto_shash *tfm = desc->tfm;
-	const unsigned int alignmask = crypto_shash_alignmask(tfm);
 	const unsigned int digestsize = crypto_shash_digestsize(tfm);
 	const unsigned int statesize = crypto_shash_statesize(tfm);
 	const char *driver = crypto_shash_driver_name(tfm);
 	const struct test_sg_division *divs[XBUFSIZE];
 	unsigned int i;
 	u8 result[HASH_MAX_DIGESTSIZE + TESTMGR_POISON_LEN];
 	int err;
 
 	/* Set the key, if specified */
 	if (vec->ksize) {
 		err = do_setkey(crypto_shash_setkey, tfm, vec->key, vec->ksize,
-				cfg, alignmask);
+				cfg, 0);
 		if (err) {
 			if (err == vec->setkey_error)
 				return 0;
 			pr_err("alg: shash: %s setkey failed on test vector %s; expected_error=%d, actual_error=%d, flags=%#x\n",
 			       driver, vec_name, vec->setkey_error, err,
 			       crypto_shash_get_flags(tfm));
 			return err;
 		}
 		if (vec->setkey_error) {
 			pr_err("alg: shash: %s setkey unexpectedly succeeded on test vector %s; expected_error=%d\n",
 			       driver, vec_name, vec->setkey_error);
 			return -EINVAL;
 		}
 	}
 
 	/* Build the scatterlist for the source data */
-	err = build_hash_sglist(tsgl, vec, cfg, alignmask, divs);
+	err = build_hash_sglist(tsgl, vec, cfg, 0, divs);
 	if (err) {
 		pr_err("alg: shash: %s: error preparing scatterlist for test vector %s, cfg=\"%s\"\n",
 		       driver, vec_name, cfg->name);
 		return err;
 	}
 
 	/* Do the actual hashing */
 
 	testmgr_poison(desc->__ctx, crypto_shash_descsize(tfm));
 	testmgr_poison(result, digestsize + TESTMGR_POISON_LEN);
-- 
2.42.0

