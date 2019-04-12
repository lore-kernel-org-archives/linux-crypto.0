Return-Path: <SRS0=860h=SO=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0497DC10F0E
	for <linux-crypto@archiver.kernel.org>; Fri, 12 Apr 2019 05:00:54 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id C77A6218E2
	for <linux-crypto@archiver.kernel.org>; Fri, 12 Apr 2019 05:00:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1555045253;
	bh=hQJ8C7wawsg1llKyLM1NkAhGlPcZFrgtYoJDRkg0wIs=;
	h=From:To:Subject:Date:In-Reply-To:References:List-ID:From;
	b=LW4NGlAUt3cAMU8BrLuKKmGZ3HXiMFC7ZLdtIOt678fyhBIE3MiCAk/rjuNWL9JCG
	 vmtZ4lXa/3kZoP+bKssoCTL3oQBlSDfeCWUOEA2odDD+CB2wGT9ZSthBSQg/4d4BHZ
	 tD+Y8fM/It9VYifnsGdD22wOZOnKxpxj6u2INh7E=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726833AbfDLFAw (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 12 Apr 2019 01:00:52 -0400
Received: from mail.kernel.org ([198.145.29.99]:55604 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726838AbfDLFAv (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 12 Apr 2019 01:00:51 -0400
Received: from sol.localdomain (c-24-5-143-220.hsd1.ca.comcast.net [24.5.143.220])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 6DE98218A6;
        Fri, 12 Apr 2019 05:00:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1555045250;
        bh=hQJ8C7wawsg1llKyLM1NkAhGlPcZFrgtYoJDRkg0wIs=;
        h=From:To:Subject:Date:In-Reply-To:References:From;
        b=iaqAV+l7NnuVCgzztgmwVUXNk0pMAJq3HKMpYDyAS/SXpntlwH9QtyYyByLZBA0f0
         9gRRBFp2SHsmqh6w1t7y3S+zGUW2bxNC/bZpH7QkfJ2c7IXy9AI2sPe2z+8a9c6Vl4
         cQRwRo6rT0DFzdvVpKQPtB9zB8A386c2/kwlqkCM=
From:   Eric Biggers <ebiggers@kernel.org>
To:     linux-crypto@vger.kernel.org,
        Herbert Xu <herbert@gondor.apana.org.au>
Subject: [PATCH v2 4/7] crypto: testmgr - fuzz hashes against their generic implementation
Date:   Thu, 11 Apr 2019 21:57:39 -0700
Message-Id: <20190412045742.1725-5-ebiggers@kernel.org>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190412045742.1725-1-ebiggers@kernel.org>
References: <20190412045742.1725-1-ebiggers@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

From: Eric Biggers <ebiggers@google.com>

When the extra crypto self-tests are enabled, test each hash algorithm
against its generic implementation when one is available.  This
involves: checking the algorithm properties for consistency, then
randomly generating test vectors using the generic implementation and
running them against the implementation under test.  Both good and bad
inputs are tested.

This has already detected a bug in the x86 implementation of poly1305,
bugs in crct10dif, and an inconsistency in cbcmac.

Signed-off-by: Eric Biggers <ebiggers@google.com>
---
 crypto/testmgr.c | 174 +++++++++++++++++++++++++++++++++++++++++++++--
 1 file changed, 170 insertions(+), 4 deletions(-)

diff --git a/crypto/testmgr.c b/crypto/testmgr.c
index 27efa3e8824ca..c66101ea32b8d 100644
--- a/crypto/testmgr.c
+++ b/crypto/testmgr.c
@@ -1290,9 +1290,169 @@ static int test_hash_vec(const char *driver, const struct hash_testvec *vec,
 	return 0;
 }
 
+#ifdef CONFIG_CRYPTO_MANAGER_EXTRA_TESTS
+/*
+ * Generate a hash test vector from the given implementation.
+ * Assumes the buffers in 'vec' were already allocated.
+ */
+static void generate_random_hash_testvec(struct crypto_shash *tfm,
+					 struct hash_testvec *vec,
+					 unsigned int maxkeysize,
+					 unsigned int maxdatasize,
+					 char *name, size_t max_namelen)
+{
+	SHASH_DESC_ON_STACK(desc, tfm);
+
+	/* Data */
+	vec->psize = generate_random_length(maxdatasize);
+	generate_random_bytes((u8 *)vec->plaintext, vec->psize);
+
+	/*
+	 * Key: length in range [1, maxkeysize], but usually choose maxkeysize.
+	 * If algorithm is unkeyed, then maxkeysize == 0 and set ksize = 0.
+	 */
+	vec->setkey_error = 0;
+	vec->ksize = 0;
+	if (maxkeysize) {
+		vec->ksize = maxkeysize;
+		if (prandom_u32() % 4 == 0)
+			vec->ksize = 1 + (prandom_u32() % maxkeysize);
+		generate_random_bytes((u8 *)vec->key, vec->ksize);
+
+		vec->setkey_error = crypto_shash_setkey(tfm, vec->key,
+							vec->ksize);
+		/* If the key couldn't be set, no need to continue to digest. */
+		if (vec->setkey_error)
+			goto done;
+	}
+
+	/* Digest */
+	desc->tfm = tfm;
+	desc->flags = 0;
+	vec->digest_error = crypto_shash_digest(desc, vec->plaintext,
+						vec->psize, (u8 *)vec->digest);
+done:
+	snprintf(name, max_namelen, "\"random: psize=%u ksize=%u\"",
+		 vec->psize, vec->ksize);
+}
+
+/*
+ * Test the hash algorithm represented by @req against the corresponding generic
+ * implementation, if one is available.
+ */
+static int test_hash_vs_generic_impl(const char *driver,
+				     const char *generic_driver,
+				     unsigned int maxkeysize,
+				     struct ahash_request *req,
+				     struct test_sglist *tsgl,
+				     u8 *hashstate)
+{
+	struct crypto_ahash *tfm = crypto_ahash_reqtfm(req);
+	const unsigned int digestsize = crypto_ahash_digestsize(tfm);
+	const unsigned int blocksize = crypto_ahash_blocksize(tfm);
+	const unsigned int maxdatasize = (2 * PAGE_SIZE) - TESTMGR_POISON_LEN;
+	const char *algname = crypto_hash_alg_common(tfm)->base.cra_name;
+	char _generic_driver[CRYPTO_MAX_ALG_NAME];
+	struct crypto_shash *generic_tfm = NULL;
+	unsigned int i;
+	struct hash_testvec vec = { 0 };
+	char vec_name[64];
+	struct testvec_config cfg;
+	char cfgname[TESTVEC_CONFIG_NAMELEN];
+	int err;
+
+	if (noextratests)
+		return 0;
+
+	if (!generic_driver) { /* Use default naming convention? */
+		err = build_generic_driver_name(algname, _generic_driver);
+		if (err)
+			return err;
+		generic_driver = _generic_driver;
+	}
+
+	if (strcmp(generic_driver, driver) == 0) /* Already the generic impl? */
+		return 0;
+
+	generic_tfm = crypto_alloc_shash(generic_driver, 0, 0);
+	if (IS_ERR(generic_tfm)) {
+		err = PTR_ERR(generic_tfm);
+		if (err == -ENOENT) {
+			pr_warn("alg: hash: skipping comparison tests for %s because %s is unavailable\n",
+				driver, generic_driver);
+			return 0;
+		}
+		pr_err("alg: hash: error allocating %s (generic impl of %s): %d\n",
+		       generic_driver, algname, err);
+		return err;
+	}
+
+	/* Check the algorithm properties for consistency. */
+
+	if (digestsize != crypto_shash_digestsize(generic_tfm)) {
+		pr_err("alg: hash: digestsize for %s (%u) doesn't match generic impl (%u)\n",
+		       driver, digestsize,
+		       crypto_shash_digestsize(generic_tfm));
+		err = -EINVAL;
+		goto out;
+	}
+
+	if (blocksize != crypto_shash_blocksize(generic_tfm)) {
+		pr_err("alg: hash: blocksize for %s (%u) doesn't match generic impl (%u)\n",
+		       driver, blocksize, crypto_shash_blocksize(generic_tfm));
+		err = -EINVAL;
+		goto out;
+	}
+
+	/*
+	 * Now generate test vectors using the generic implementation, and test
+	 * the other implementation against them.
+	 */
+
+	vec.key = kmalloc(maxkeysize, GFP_KERNEL);
+	vec.plaintext = kmalloc(maxdatasize, GFP_KERNEL);
+	vec.digest = kmalloc(digestsize, GFP_KERNEL);
+	if (!vec.key || !vec.plaintext || !vec.digest) {
+		err = -ENOMEM;
+		goto out;
+	}
+
+	for (i = 0; i < fuzz_iterations * 8; i++) {
+		generate_random_hash_testvec(generic_tfm, &vec,
+					     maxkeysize, maxdatasize,
+					     vec_name, sizeof(vec_name));
+		generate_random_testvec_config(&cfg, cfgname, sizeof(cfgname));
+
+		err = test_hash_vec_cfg(driver, &vec, vec_name, &cfg,
+					req, tsgl, hashstate);
+		if (err)
+			goto out;
+		cond_resched();
+	}
+	err = 0;
+out:
+	kfree(vec.key);
+	kfree(vec.plaintext);
+	kfree(vec.digest);
+	crypto_free_shash(generic_tfm);
+	return err;
+}
+#else /* !CONFIG_CRYPTO_MANAGER_EXTRA_TESTS */
+static int test_hash_vs_generic_impl(const char *driver,
+				     const char *generic_driver,
+				     unsigned int maxkeysize,
+				     struct ahash_request *req,
+				     struct test_sglist *tsgl,
+				     u8 *hashstate)
+{
+	return 0;
+}
+#endif /* !CONFIG_CRYPTO_MANAGER_EXTRA_TESTS */
+
 static int __alg_test_hash(const struct hash_testvec *vecs,
 			   unsigned int num_vecs, const char *driver,
-			   u32 type, u32 mask)
+			   u32 type, u32 mask,
+			   const char *generic_driver, unsigned int maxkeysize)
 {
 	struct crypto_ahash *tfm;
 	struct ahash_request *req = NULL;
@@ -1340,7 +1500,8 @@ static int __alg_test_hash(const struct hash_testvec *vecs,
 		if (err)
 			goto out;
 	}
-	err = 0;
+	err = test_hash_vs_generic_impl(driver, generic_driver, maxkeysize, req,
+					tsgl, hashstate);
 out:
 	kfree(hashstate);
 	if (tsgl) {
@@ -1358,6 +1519,7 @@ static int alg_test_hash(const struct alg_test_desc *desc, const char *driver,
 	const struct hash_testvec *template = desc->suite.hash.vecs;
 	unsigned int tcount = desc->suite.hash.count;
 	unsigned int nr_unkeyed, nr_keyed;
+	unsigned int maxkeysize = 0;
 	int err;
 
 	/*
@@ -1376,16 +1538,20 @@ static int alg_test_hash(const struct alg_test_desc *desc, const char *driver,
 			       "unkeyed ones must come first\n", desc->alg);
 			return -EINVAL;
 		}
+		maxkeysize = max_t(unsigned int, maxkeysize,
+				   template[nr_unkeyed + nr_keyed].ksize);
 	}
 
 	err = 0;
 	if (nr_unkeyed) {
-		err = __alg_test_hash(template, nr_unkeyed, driver, type, mask);
+		err = __alg_test_hash(template, nr_unkeyed, driver, type, mask,
+				      desc->generic_driver, maxkeysize);
 		template += nr_unkeyed;
 	}
 
 	if (!err && nr_keyed)
-		err = __alg_test_hash(template, nr_keyed, driver, type, mask);
+		err = __alg_test_hash(template, nr_keyed, driver, type, mask,
+				      desc->generic_driver, maxkeysize);
 
 	return err;
 }
-- 
2.21.0

