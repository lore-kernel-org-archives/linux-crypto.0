Return-Path: <SRS0=52Dc=ZX=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7EF0AC33CBA
	for <linux-crypto@archiver.kernel.org>; Sun,  1 Dec 2019 21:54:23 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 4BD34215F1
	for <linux-crypto@archiver.kernel.org>; Sun,  1 Dec 2019 21:54:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1575237263;
	bh=9sJ8enjA7nl8YRMq0vNbEQrelK7iqTnzQNTzTrPP08c=;
	h=From:To:Subject:Date:In-Reply-To:References:List-ID:From;
	b=WDMitVCgH+e4lQXyi01Y+Gv6alKRhAFFMBJwtx9cCIOyfHdJjUWGf6seTH9e5x4EU
	 C6gyRjwIhznIAgVs6Oa+RQRNwij4M+/6R0ShQfo2t7EPSSM1GnsEhCSJZGTOgGg7FD
	 HL5WeSrkWVdAU+LNdwen+B+GJJsA4XsGJmKSy9Vs=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727279AbfLAVyW (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Sun, 1 Dec 2019 16:54:22 -0500
Received: from mail.kernel.org ([198.145.29.99]:33406 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727297AbfLAVyV (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Sun, 1 Dec 2019 16:54:21 -0500
Received: from sol.localdomain (c-24-5-143-220.hsd1.ca.comcast.net [24.5.143.220])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id E38C820865
        for <linux-crypto@vger.kernel.org>; Sun,  1 Dec 2019 21:54:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1575237261;
        bh=9sJ8enjA7nl8YRMq0vNbEQrelK7iqTnzQNTzTrPP08c=;
        h=From:To:Subject:Date:In-Reply-To:References:From;
        b=XwTPt86/brFTuF9LHa8OHaVuPip9kD80DNdsv9kXB2v+1sjo1gL8D0bmDsMUkW7eu
         avwzpaxNUfHNYbnE8fUOrlGjjoNjbDECQCaWvsNQfcx0PFF0lF24vEou05p0nlERDn
         CX+F9i5VZsL7zz54zceZ1hzbdIyQ06ZQebALBW8g=
From:   Eric Biggers <ebiggers@kernel.org>
To:     linux-crypto@vger.kernel.org
Subject: [PATCH 6/7] crypto: testmgr - create struct aead_extra_tests_ctx
Date:   Sun,  1 Dec 2019 13:53:29 -0800
Message-Id: <20191201215330.171990-7-ebiggers@kernel.org>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <20191201215330.171990-1-ebiggers@kernel.org>
References: <20191201215330.171990-1-ebiggers@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

From: Eric Biggers <ebiggers@google.com>

In preparation for adding inauthentic input fuzz tests, which don't
require that a generic implementation of the algorithm be available,
refactor test_aead_vs_generic_impl() so that instead there's a
higher-level function test_aead_extra() which initializes a struct
aead_extra_tests_ctx and then calls test_aead_vs_generic_impl() with a
pointer to that struct.

As a bonus, this reduces stack usage.

Also switch from crypto_aead_alg(tfm)->maxauthsize to
crypto_aead_maxauthsize(), now that the latter is available in
<crypto/aead.h>.

Signed-off-by: Eric Biggers <ebiggers@google.com>
---
 crypto/testmgr.c | 170 +++++++++++++++++++++++++++--------------------
 1 file changed, 99 insertions(+), 71 deletions(-)

diff --git a/crypto/testmgr.c b/crypto/testmgr.c
index d1ffa8f73948..4fe210845e78 100644
--- a/crypto/testmgr.c
+++ b/crypto/testmgr.c
@@ -2111,6 +2111,22 @@ static int test_aead_vec(const char *driver, int enc,
 }
 
 #ifdef CONFIG_CRYPTO_MANAGER_EXTRA_TESTS
+
+struct aead_extra_tests_ctx {
+	struct aead_request *req;
+	struct crypto_aead *tfm;
+	const char *driver;
+	const struct alg_test_desc *test_desc;
+	struct cipher_test_sglists *tsgls;
+	unsigned int maxdatasize;
+	unsigned int maxkeysize;
+
+	struct aead_testvec vec;
+	char vec_name[64];
+	char cfgname[TESTVEC_CONFIG_NAMELEN];
+	struct testvec_config cfg;
+};
+
 /*
  * Generate an AEAD test vector from the given implementation.
  * Assumes the buffers in 'vec' were already allocated.
@@ -2123,7 +2139,7 @@ static void generate_random_aead_testvec(struct aead_request *req,
 {
 	struct crypto_aead *tfm = crypto_aead_reqtfm(req);
 	const unsigned int ivsize = crypto_aead_ivsize(tfm);
-	unsigned int maxauthsize = crypto_aead_alg(tfm)->maxauthsize;
+	const unsigned int maxauthsize = crypto_aead_maxauthsize(tfm);
 	unsigned int authsize;
 	unsigned int total_len;
 	int i;
@@ -2192,35 +2208,21 @@ static void generate_random_aead_testvec(struct aead_request *req,
 }
 
 /*
- * Test the AEAD algorithm represented by @req against the corresponding generic
- * implementation, if one is available.
+ * Test the AEAD algorithm against the corresponding generic implementation, if
+ * one is available.
  */
-static int test_aead_vs_generic_impl(const char *driver,
-				     const struct alg_test_desc *test_desc,
-				     struct aead_request *req,
-				     struct cipher_test_sglists *tsgls)
+static int test_aead_vs_generic_impl(struct aead_extra_tests_ctx *ctx)
 {
-	struct crypto_aead *tfm = crypto_aead_reqtfm(req);
-	const unsigned int ivsize = crypto_aead_ivsize(tfm);
-	const unsigned int maxauthsize = crypto_aead_alg(tfm)->maxauthsize;
-	const unsigned int blocksize = crypto_aead_blocksize(tfm);
-	const unsigned int maxdatasize = (2 * PAGE_SIZE) - TESTMGR_POISON_LEN;
+	struct crypto_aead *tfm = ctx->tfm;
 	const char *algname = crypto_aead_alg(tfm)->base.cra_name;
-	const char *generic_driver = test_desc->generic_driver;
+	const char *driver = ctx->driver;
+	const char *generic_driver = ctx->test_desc->generic_driver;
 	char _generic_driver[CRYPTO_MAX_ALG_NAME];
 	struct crypto_aead *generic_tfm = NULL;
 	struct aead_request *generic_req = NULL;
-	unsigned int maxkeysize;
 	unsigned int i;
-	struct aead_testvec vec = { 0 };
-	char vec_name[64];
-	struct testvec_config *cfg;
-	char cfgname[TESTVEC_CONFIG_NAMELEN];
 	int err;
 
-	if (noextratests)
-		return 0;
-
 	if (!generic_driver) { /* Use default naming convention? */
 		err = build_generic_driver_name(algname, _generic_driver);
 		if (err)
@@ -2244,12 +2246,6 @@ static int test_aead_vs_generic_impl(const char *driver,
 		return err;
 	}
 
-	cfg = kzalloc(sizeof(*cfg), GFP_KERNEL);
-	if (!cfg) {
-		err = -ENOMEM;
-		goto out;
-	}
-
 	generic_req = aead_request_alloc(generic_tfm, GFP_KERNEL);
 	if (!generic_req) {
 		err = -ENOMEM;
@@ -2258,24 +2254,27 @@ static int test_aead_vs_generic_impl(const char *driver,
 
 	/* Check the algorithm properties for consistency. */
 
-	if (maxauthsize != crypto_aead_alg(generic_tfm)->maxauthsize) {
+	if (crypto_aead_maxauthsize(tfm) !=
+	    crypto_aead_maxauthsize(generic_tfm)) {
 		pr_err("alg: aead: maxauthsize for %s (%u) doesn't match generic impl (%u)\n",
-		       driver, maxauthsize,
-		       crypto_aead_alg(generic_tfm)->maxauthsize);
+		       driver, crypto_aead_maxauthsize(tfm),
+		       crypto_aead_maxauthsize(generic_tfm));
 		err = -EINVAL;
 		goto out;
 	}
 
-	if (ivsize != crypto_aead_ivsize(generic_tfm)) {
+	if (crypto_aead_ivsize(tfm) != crypto_aead_ivsize(generic_tfm)) {
 		pr_err("alg: aead: ivsize for %s (%u) doesn't match generic impl (%u)\n",
-		       driver, ivsize, crypto_aead_ivsize(generic_tfm));
+		       driver, crypto_aead_ivsize(tfm),
+		       crypto_aead_ivsize(generic_tfm));
 		err = -EINVAL;
 		goto out;
 	}
 
-	if (blocksize != crypto_aead_blocksize(generic_tfm)) {
+	if (crypto_aead_blocksize(tfm) != crypto_aead_blocksize(generic_tfm)) {
 		pr_err("alg: aead: blocksize for %s (%u) doesn't match generic impl (%u)\n",
-		       driver, blocksize, crypto_aead_blocksize(generic_tfm));
+		       driver, crypto_aead_blocksize(tfm),
+		       crypto_aead_blocksize(generic_tfm));
 		err = -EINVAL;
 		goto out;
 	}
@@ -2284,35 +2283,22 @@ static int test_aead_vs_generic_impl(const char *driver,
 	 * Now generate test vectors using the generic implementation, and test
 	 * the other implementation against them.
 	 */
-
-	maxkeysize = 0;
-	for (i = 0; i < test_desc->suite.aead.count; i++)
-		maxkeysize = max_t(unsigned int, maxkeysize,
-				   test_desc->suite.aead.vecs[i].klen);
-
-	vec.key = kmalloc(maxkeysize, GFP_KERNEL);
-	vec.iv = kmalloc(ivsize, GFP_KERNEL);
-	vec.assoc = kmalloc(maxdatasize, GFP_KERNEL);
-	vec.ptext = kmalloc(maxdatasize, GFP_KERNEL);
-	vec.ctext = kmalloc(maxdatasize, GFP_KERNEL);
-	if (!vec.key || !vec.iv || !vec.assoc || !vec.ptext || !vec.ctext) {
-		err = -ENOMEM;
-		goto out;
-	}
-
 	for (i = 0; i < fuzz_iterations * 8; i++) {
-		generate_random_aead_testvec(generic_req, &vec,
-					     maxkeysize, maxdatasize,
-					     vec_name, sizeof(vec_name));
-		generate_random_testvec_config(cfg, cfgname, sizeof(cfgname));
-
-		err = test_aead_vec_cfg(driver, ENCRYPT, &vec, vec_name, cfg,
-					req, tsgls);
+		generate_random_aead_testvec(generic_req, &ctx->vec,
+					     ctx->maxkeysize, ctx->maxdatasize,
+					     ctx->vec_name,
+					     sizeof(ctx->vec_name));
+		generate_random_testvec_config(&ctx->cfg, ctx->cfgname,
+					       sizeof(ctx->cfgname));
+		err = test_aead_vec_cfg(driver, ENCRYPT, &ctx->vec,
+					ctx->vec_name, &ctx->cfg,
+					ctx->req, ctx->tsgls);
 		if (err)
 			goto out;
-		if (vec.crypt_error == 0) {
-			err = test_aead_vec_cfg(driver, DECRYPT, &vec, vec_name,
-						cfg, req, tsgls);
+		if (ctx->vec.crypt_error == 0) {
+			err = test_aead_vec_cfg(driver, DECRYPT, &ctx->vec,
+						ctx->vec_name, &ctx->cfg,
+						ctx->req, ctx->tsgls);
 			if (err)
 				goto out;
 		}
@@ -2320,21 +2306,63 @@ static int test_aead_vs_generic_impl(const char *driver,
 	}
 	err = 0;
 out:
-	kfree(cfg);
-	kfree(vec.key);
-	kfree(vec.iv);
-	kfree(vec.assoc);
-	kfree(vec.ptext);
-	kfree(vec.ctext);
 	crypto_free_aead(generic_tfm);
 	aead_request_free(generic_req);
 	return err;
 }
+
+static int test_aead_extra(const char *driver,
+			   const struct alg_test_desc *test_desc,
+			   struct aead_request *req,
+			   struct cipher_test_sglists *tsgls)
+{
+	struct aead_extra_tests_ctx *ctx;
+	unsigned int i;
+	int err;
+
+	if (noextratests)
+		return 0;
+
+	ctx = kzalloc(sizeof(*ctx), GFP_KERNEL);
+	if (!ctx)
+		return -ENOMEM;
+	ctx->req = req;
+	ctx->tfm = crypto_aead_reqtfm(req);
+	ctx->driver = driver;
+	ctx->test_desc = test_desc;
+	ctx->tsgls = tsgls;
+	ctx->maxdatasize = (2 * PAGE_SIZE) - TESTMGR_POISON_LEN;
+	ctx->maxkeysize = 0;
+	for (i = 0; i < test_desc->suite.aead.count; i++)
+		ctx->maxkeysize = max_t(unsigned int, ctx->maxkeysize,
+					test_desc->suite.aead.vecs[i].klen);
+
+	ctx->vec.key = kmalloc(ctx->maxkeysize, GFP_KERNEL);
+	ctx->vec.iv = kmalloc(crypto_aead_ivsize(ctx->tfm), GFP_KERNEL);
+	ctx->vec.assoc = kmalloc(ctx->maxdatasize, GFP_KERNEL);
+	ctx->vec.ptext = kmalloc(ctx->maxdatasize, GFP_KERNEL);
+	ctx->vec.ctext = kmalloc(ctx->maxdatasize, GFP_KERNEL);
+	if (!ctx->vec.key || !ctx->vec.iv || !ctx->vec.assoc ||
+	    !ctx->vec.ptext || !ctx->vec.ctext) {
+		err = -ENOMEM;
+		goto out;
+	}
+
+	err = test_aead_vs_generic_impl(ctx);
+out:
+	kfree(ctx->vec.key);
+	kfree(ctx->vec.iv);
+	kfree(ctx->vec.assoc);
+	kfree(ctx->vec.ptext);
+	kfree(ctx->vec.ctext);
+	kfree(ctx);
+	return err;
+}
 #else /* !CONFIG_CRYPTO_MANAGER_EXTRA_TESTS */
-static int test_aead_vs_generic_impl(const char *driver,
-				     const struct alg_test_desc *test_desc,
-				     struct aead_request *req,
-				     struct cipher_test_sglists *tsgls)
+static int test_aead_extra(const char *driver,
+			   const struct alg_test_desc *test_desc,
+			   struct aead_request *req,
+			   struct cipher_test_sglists *tsgls)
 {
 	return 0;
 }
@@ -2403,7 +2431,7 @@ static int alg_test_aead(const struct alg_test_desc *desc, const char *driver,
 	if (err)
 		goto out;
 
-	err = test_aead_vs_generic_impl(driver, desc, req, tsgls);
+	err = test_aead_extra(driver, desc, req, tsgls);
 out:
 	free_cipher_test_sglists(tsgls);
 	aead_request_free(req);
-- 
2.24.0

