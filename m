Return-Path: <SRS0=A9yi=EB=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.1 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B7DC9C5517A
	for <linux-crypto@archiver.kernel.org>; Mon, 26 Oct 2020 16:17:27 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 68D3321D41
	for <linux-crypto@archiver.kernel.org>; Mon, 26 Oct 2020 16:17:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1603729047;
	bh=gwHsUFVSXyQW3l/c9gZqK84vNwrsMULJDNdeLaIwLxo=;
	h=From:To:Subject:Date:In-Reply-To:References:List-ID:From;
	b=gnuYTkAievxLSlMIOCmHbsnHxCfjEmaG9dLh/T2RN4b/QH9iVpKOQnVYqGTisC7Km
	 KkB6/I9L/gmc6nV/hlJxbg8Yt+VWWbbZAtMdpTTYNGiJb6cc5pyZN9oOahwMicX4ok
	 OuqUlGIHKoDaSKh+DUO29RGr0qrzGqJYCgjWh4AE=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1785587AbgJZQR0 (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Mon, 26 Oct 2020 12:17:26 -0400
Received: from mail.kernel.org ([198.145.29.99]:60374 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1737072AbgJZQR0 (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 26 Oct 2020 12:17:26 -0400
Received: from sol.attlocal.net (172-10-235-113.lightspeed.sntcca.sbcglobal.net [172.10.235.113])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 8E6F721D41
        for <linux-crypto@vger.kernel.org>; Mon, 26 Oct 2020 16:17:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1603729045;
        bh=gwHsUFVSXyQW3l/c9gZqK84vNwrsMULJDNdeLaIwLxo=;
        h=From:To:Subject:Date:In-Reply-To:References:From;
        b=w9XkECQ2EGDj0qxh971KkFwFRxM6bNSVbQdABQQMNSSUVgje+TTfybU1PYNO5yP7S
         0eI8+QwpEjJl8LERXz3XMxfGaSmq0VaAhrvicwpiFe5GufNpGe8TU+y4WG1l0+VARQ
         pBmx3OeWS7Scb4SDoSw7ZaT+G8vXlXvBXNUYWnQE=
From:   Eric Biggers <ebiggers@kernel.org>
To:     linux-crypto@vger.kernel.org
Subject: [PATCH 2/4] crypto: testmgr - always print the actual hash driver name
Date:   Mon, 26 Oct 2020 09:17:00 -0700
Message-Id: <20201026161702.39201-3-ebiggers@kernel.org>
X-Mailer: git-send-email 2.29.1
In-Reply-To: <20201026161702.39201-1-ebiggers@kernel.org>
References: <20201026161702.39201-1-ebiggers@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

From: Eric Biggers <ebiggers@google.com>

When alg_test() is called from tcrypt.ko rather than from the algorithm
registration code, "driver" is actually the algorithm name, not the
driver name.  So it shouldn't be used in places where a driver name is
wanted, e.g. when reporting a test failure or when checking whether the
driver is the generic driver or not.

Fix this for the hash algorithm tests by getting the driver name from
the crypto_ahash or crypto_shash that actually got allocated.

Signed-off-by: Eric Biggers <ebiggers@google.com>
---
 crypto/testmgr.c | 43 ++++++++++++++++++++-----------------------
 1 file changed, 20 insertions(+), 23 deletions(-)

diff --git a/crypto/testmgr.c b/crypto/testmgr.c
index a64a639eddfa4..ec64b70a5a836 100644
--- a/crypto/testmgr.c
+++ b/crypto/testmgr.c
@@ -1171,8 +1171,7 @@ static inline const void *sg_data(struct scatterlist *sg)
 }
 
 /* Test one hash test vector in one configuration, using the shash API */
-static int test_shash_vec_cfg(const char *driver,
-			      const struct hash_testvec *vec,
+static int test_shash_vec_cfg(const struct hash_testvec *vec,
 			      const char *vec_name,
 			      const struct testvec_config *cfg,
 			      struct shash_desc *desc,
@@ -1183,6 +1182,7 @@ static int test_shash_vec_cfg(const char *driver,
 	const unsigned int alignmask = crypto_shash_alignmask(tfm);
 	const unsigned int digestsize = crypto_shash_digestsize(tfm);
 	const unsigned int statesize = crypto_shash_statesize(tfm);
+	const char *driver = crypto_shash_driver_name(tfm);
 	const struct test_sg_division *divs[XBUFSIZE];
 	unsigned int i;
 	u8 result[HASH_MAX_DIGESTSIZE + TESTMGR_POISON_LEN];
@@ -1355,8 +1355,7 @@ static int check_nonfinal_ahash_op(const char *op, int err,
 }
 
 /* Test one hash test vector in one configuration, using the ahash API */
-static int test_ahash_vec_cfg(const char *driver,
-			      const struct hash_testvec *vec,
+static int test_ahash_vec_cfg(const struct hash_testvec *vec,
 			      const char *vec_name,
 			      const struct testvec_config *cfg,
 			      struct ahash_request *req,
@@ -1367,6 +1366,7 @@ static int test_ahash_vec_cfg(const char *driver,
 	const unsigned int alignmask = crypto_ahash_alignmask(tfm);
 	const unsigned int digestsize = crypto_ahash_digestsize(tfm);
 	const unsigned int statesize = crypto_ahash_statesize(tfm);
+	const char *driver = crypto_ahash_driver_name(tfm);
 	const u32 req_flags = CRYPTO_TFM_REQ_MAY_BACKLOG | cfg->req_flags;
 	const struct test_sg_division *divs[XBUFSIZE];
 	DECLARE_CRYPTO_WAIT(wait);
@@ -1521,8 +1521,7 @@ static int test_ahash_vec_cfg(const char *driver,
 				 driver, cfg);
 }
 
-static int test_hash_vec_cfg(const char *driver,
-			     const struct hash_testvec *vec,
+static int test_hash_vec_cfg(const struct hash_testvec *vec,
 			     const char *vec_name,
 			     const struct testvec_config *cfg,
 			     struct ahash_request *req,
@@ -1539,20 +1538,18 @@ static int test_hash_vec_cfg(const char *driver,
 	 */
 
 	if (desc) {
-		err = test_shash_vec_cfg(driver, vec, vec_name, cfg, desc, tsgl,
+		err = test_shash_vec_cfg(vec, vec_name, cfg, desc, tsgl,
 					 hashstate);
 		if (err)
 			return err;
 	}
 
-	return test_ahash_vec_cfg(driver, vec, vec_name, cfg, req, tsgl,
-				  hashstate);
+	return test_ahash_vec_cfg(vec, vec_name, cfg, req, tsgl, hashstate);
 }
 
-static int test_hash_vec(const char *driver, const struct hash_testvec *vec,
-			 unsigned int vec_num, struct ahash_request *req,
-			 struct shash_desc *desc, struct test_sglist *tsgl,
-			 u8 *hashstate)
+static int test_hash_vec(const struct hash_testvec *vec, unsigned int vec_num,
+			 struct ahash_request *req, struct shash_desc *desc,
+			 struct test_sglist *tsgl, u8 *hashstate)
 {
 	char vec_name[16];
 	unsigned int i;
@@ -1561,7 +1558,7 @@ static int test_hash_vec(const char *driver, const struct hash_testvec *vec,
 	sprintf(vec_name, "%u", vec_num);
 
 	for (i = 0; i < ARRAY_SIZE(default_hash_testvec_configs); i++) {
-		err = test_hash_vec_cfg(driver, vec, vec_name,
+		err = test_hash_vec_cfg(vec, vec_name,
 					&default_hash_testvec_configs[i],
 					req, desc, tsgl, hashstate);
 		if (err)
@@ -1576,7 +1573,7 @@ static int test_hash_vec(const char *driver, const struct hash_testvec *vec,
 		for (i = 0; i < fuzz_iterations; i++) {
 			generate_random_testvec_config(&cfg, cfgname,
 						       sizeof(cfgname));
-			err = test_hash_vec_cfg(driver, vec, vec_name, &cfg,
+			err = test_hash_vec_cfg(vec, vec_name, &cfg,
 						req, desc, tsgl, hashstate);
 			if (err)
 				return err;
@@ -1633,8 +1630,7 @@ static void generate_random_hash_testvec(struct shash_desc *desc,
  * Test the hash algorithm represented by @req against the corresponding generic
  * implementation, if one is available.
  */
-static int test_hash_vs_generic_impl(const char *driver,
-				     const char *generic_driver,
+static int test_hash_vs_generic_impl(const char *generic_driver,
 				     unsigned int maxkeysize,
 				     struct ahash_request *req,
 				     struct shash_desc *desc,
@@ -1646,6 +1642,7 @@ static int test_hash_vs_generic_impl(const char *driver,
 	const unsigned int blocksize = crypto_ahash_blocksize(tfm);
 	const unsigned int maxdatasize = (2 * PAGE_SIZE) - TESTMGR_POISON_LEN;
 	const char *algname = crypto_hash_alg_common(tfm)->base.cra_name;
+	const char *driver = crypto_ahash_driver_name(tfm);
 	char _generic_driver[CRYPTO_MAX_ALG_NAME];
 	struct crypto_shash *generic_tfm = NULL;
 	struct shash_desc *generic_desc = NULL;
@@ -1732,7 +1729,7 @@ static int test_hash_vs_generic_impl(const char *driver,
 					     vec_name, sizeof(vec_name));
 		generate_random_testvec_config(cfg, cfgname, sizeof(cfgname));
 
-		err = test_hash_vec_cfg(driver, &vec, vec_name, cfg,
+		err = test_hash_vec_cfg(&vec, vec_name, cfg,
 					req, desc, tsgl, hashstate);
 		if (err)
 			goto out;
@@ -1749,8 +1746,7 @@ static int test_hash_vs_generic_impl(const char *driver,
 	return err;
 }
 #else /* !CONFIG_CRYPTO_MANAGER_EXTRA_TESTS */
-static int test_hash_vs_generic_impl(const char *driver,
-				     const char *generic_driver,
+static int test_hash_vs_generic_impl(const char *generic_driver,
 				     unsigned int maxkeysize,
 				     struct ahash_request *req,
 				     struct shash_desc *desc,
@@ -1820,6 +1816,7 @@ static int __alg_test_hash(const struct hash_testvec *vecs,
 		       driver, PTR_ERR(atfm));
 		return PTR_ERR(atfm);
 	}
+	driver = crypto_ahash_driver_name(atfm);
 
 	req = ahash_request_alloc(atfm, GFP_KERNEL);
 	if (!req) {
@@ -1859,13 +1856,12 @@ static int __alg_test_hash(const struct hash_testvec *vecs,
 	}
 
 	for (i = 0; i < num_vecs; i++) {
-		err = test_hash_vec(driver, &vecs[i], i, req, desc, tsgl,
-				    hashstate);
+		err = test_hash_vec(&vecs[i], i, req, desc, tsgl, hashstate);
 		if (err)
 			goto out;
 		cond_resched();
 	}
-	err = test_hash_vs_generic_impl(driver, generic_driver, maxkeysize, req,
+	err = test_hash_vs_generic_impl(generic_driver, maxkeysize, req,
 					desc, tsgl, hashstate);
 out:
 	kfree(hashstate);
@@ -3602,6 +3598,7 @@ static int alg_test_crc32c(const struct alg_test_desc *desc,
 		       "%ld\n", driver, PTR_ERR(tfm));
 		return PTR_ERR(tfm);
 	}
+	driver = crypto_shash_driver_name(tfm);
 
 	do {
 		SHASH_DESC_ON_STACK(shash, tfm);
-- 
2.29.1

