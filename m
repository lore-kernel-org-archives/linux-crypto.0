Return-Path: <SRS0=A9yi=EB=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.1 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D5372C4363A
	for <linux-crypto@archiver.kernel.org>; Mon, 26 Oct 2020 16:17:28 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 914C3207F7
	for <linux-crypto@archiver.kernel.org>; Mon, 26 Oct 2020 16:17:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1603729048;
	bh=4RgHLxmAPQ9dbQbgafZ4VTUASPkrncAqdgJrCsstMgc=;
	h=From:To:Subject:Date:In-Reply-To:References:List-ID:From;
	b=GDef87yS0qqOnbDt0YLaC5rMMzGbBbqt4T2rhGnr9B4/7rLAevBTYdKss8IunPtVm
	 6Lt+bnDdEHfM+v67hbDVQjzIchRcXkeKuFPKv3VnV8KMu6Y3/SMP5viiOX/0uxqiMq
	 MqcPHNRF2U7lWjEsautBeJltnLm9FYs7HNudLUXc=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1785588AbgJZQR1 (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Mon, 26 Oct 2020 12:17:27 -0400
Received: from mail.kernel.org ([198.145.29.99]:60376 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1775423AbgJZQR0 (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 26 Oct 2020 12:17:26 -0400
Received: from sol.attlocal.net (172-10-235-113.lightspeed.sntcca.sbcglobal.net [172.10.235.113])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id BCCB8207F7
        for <linux-crypto@vger.kernel.org>; Mon, 26 Oct 2020 16:17:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1603729045;
        bh=4RgHLxmAPQ9dbQbgafZ4VTUASPkrncAqdgJrCsstMgc=;
        h=From:To:Subject:Date:In-Reply-To:References:From;
        b=NiGem/nomm3+s5VuHet1QKSpDP6InZrv169HTe8fepeIOE2FFMqCS2+9gth5mJVly
         J4inNvkDvucWg9qsY60F7llHCpSc2vTBIZxDqkkierfBlFLVHkRV8dUDc9f9qYgOqw
         AXPU4whKJc5sanmxursNyZ4CMCgovW0eug04XWq4=
From:   Eric Biggers <ebiggers@kernel.org>
To:     linux-crypto@vger.kernel.org
Subject: [PATCH 3/4] crypto: testmgr - always print the actual AEAD driver name
Date:   Mon, 26 Oct 2020 09:17:01 -0700
Message-Id: <20201026161702.39201-4-ebiggers@kernel.org>
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

Fix this for the AEAD algorithm tests by getting the driver name from
the crypto_aead that actually got allocated.

Signed-off-by: Eric Biggers <ebiggers@google.com>
---
 crypto/testmgr.c | 42 ++++++++++++++++++------------------------
 1 file changed, 18 insertions(+), 24 deletions(-)

diff --git a/crypto/testmgr.c b/crypto/testmgr.c
index ec64b70a5a836..1b785b2f49870 100644
--- a/crypto/testmgr.c
+++ b/crypto/testmgr.c
@@ -1919,8 +1919,7 @@ static int alg_test_hash(const struct alg_test_desc *desc, const char *driver,
 	return err;
 }
 
-static int test_aead_vec_cfg(const char *driver, int enc,
-			     const struct aead_testvec *vec,
+static int test_aead_vec_cfg(int enc, const struct aead_testvec *vec,
 			     const char *vec_name,
 			     const struct testvec_config *cfg,
 			     struct aead_request *req,
@@ -1930,6 +1929,7 @@ static int test_aead_vec_cfg(const char *driver, int enc,
 	const unsigned int alignmask = crypto_aead_alignmask(tfm);
 	const unsigned int ivsize = crypto_aead_ivsize(tfm);
 	const unsigned int authsize = vec->clen - vec->plen;
+	const char *driver = crypto_aead_driver_name(tfm);
 	const u32 req_flags = CRYPTO_TFM_REQ_MAY_BACKLOG | cfg->req_flags;
 	const char *op = enc ? "encryption" : "decryption";
 	DECLARE_CRYPTO_WAIT(wait);
@@ -2102,9 +2102,8 @@ static int test_aead_vec_cfg(const char *driver, int enc,
 	return 0;
 }
 
-static int test_aead_vec(const char *driver, int enc,
-			 const struct aead_testvec *vec, unsigned int vec_num,
-			 struct aead_request *req,
+static int test_aead_vec(int enc, const struct aead_testvec *vec,
+			 unsigned int vec_num, struct aead_request *req,
 			 struct cipher_test_sglists *tsgls)
 {
 	char vec_name[16];
@@ -2117,7 +2116,7 @@ static int test_aead_vec(const char *driver, int enc,
 	sprintf(vec_name, "%u", vec_num);
 
 	for (i = 0; i < ARRAY_SIZE(default_cipher_testvec_configs); i++) {
-		err = test_aead_vec_cfg(driver, enc, vec, vec_name,
+		err = test_aead_vec_cfg(enc, vec, vec_name,
 					&default_cipher_testvec_configs[i],
 					req, tsgls);
 		if (err)
@@ -2132,7 +2131,7 @@ static int test_aead_vec(const char *driver, int enc,
 		for (i = 0; i < fuzz_iterations; i++) {
 			generate_random_testvec_config(&cfg, cfgname,
 						       sizeof(cfgname));
-			err = test_aead_vec_cfg(driver, enc, vec, vec_name,
+			err = test_aead_vec_cfg(enc, vec, vec_name,
 						&cfg, req, tsgls);
 			if (err)
 				return err;
@@ -2148,7 +2147,6 @@ static int test_aead_vec(const char *driver, int enc,
 struct aead_extra_tests_ctx {
 	struct aead_request *req;
 	struct crypto_aead *tfm;
-	const char *driver;
 	const struct alg_test_desc *test_desc;
 	struct cipher_test_sglists *tsgls;
 	unsigned int maxdatasize;
@@ -2354,7 +2352,7 @@ static int test_aead_inauthentic_inputs(struct aead_extra_tests_ctx *ctx)
 		if (ctx->vec.novrfy) {
 			generate_random_testvec_config(&ctx->cfg, ctx->cfgname,
 						       sizeof(ctx->cfgname));
-			err = test_aead_vec_cfg(ctx->driver, DECRYPT, &ctx->vec,
+			err = test_aead_vec_cfg(DECRYPT, &ctx->vec,
 						ctx->vec_name, &ctx->cfg,
 						ctx->req, ctx->tsgls);
 			if (err)
@@ -2373,7 +2371,7 @@ static int test_aead_vs_generic_impl(struct aead_extra_tests_ctx *ctx)
 {
 	struct crypto_aead *tfm = ctx->tfm;
 	const char *algname = crypto_aead_alg(tfm)->base.cra_name;
-	const char *driver = ctx->driver;
+	const char *driver = crypto_aead_driver_name(tfm);
 	const char *generic_driver = ctx->test_desc->generic_driver;
 	char _generic_driver[CRYPTO_MAX_ALG_NAME];
 	struct crypto_aead *generic_tfm = NULL;
@@ -2450,14 +2448,14 @@ static int test_aead_vs_generic_impl(struct aead_extra_tests_ctx *ctx)
 		generate_random_testvec_config(&ctx->cfg, ctx->cfgname,
 					       sizeof(ctx->cfgname));
 		if (!ctx->vec.novrfy) {
-			err = test_aead_vec_cfg(driver, ENCRYPT, &ctx->vec,
+			err = test_aead_vec_cfg(ENCRYPT, &ctx->vec,
 						ctx->vec_name, &ctx->cfg,
 						ctx->req, ctx->tsgls);
 			if (err)
 				goto out;
 		}
 		if (ctx->vec.crypt_error == 0 || ctx->vec.novrfy) {
-			err = test_aead_vec_cfg(driver, DECRYPT, &ctx->vec,
+			err = test_aead_vec_cfg(DECRYPT, &ctx->vec,
 						ctx->vec_name, &ctx->cfg,
 						ctx->req, ctx->tsgls);
 			if (err)
@@ -2472,8 +2470,7 @@ static int test_aead_vs_generic_impl(struct aead_extra_tests_ctx *ctx)
 	return err;
 }
 
-static int test_aead_extra(const char *driver,
-			   const struct alg_test_desc *test_desc,
+static int test_aead_extra(const struct alg_test_desc *test_desc,
 			   struct aead_request *req,
 			   struct cipher_test_sglists *tsgls)
 {
@@ -2489,7 +2486,6 @@ static int test_aead_extra(const char *driver,
 		return -ENOMEM;
 	ctx->req = req;
 	ctx->tfm = crypto_aead_reqtfm(req);
-	ctx->driver = driver;
 	ctx->test_desc = test_desc;
 	ctx->tsgls = tsgls;
 	ctx->maxdatasize = (2 * PAGE_SIZE) - TESTMGR_POISON_LEN;
@@ -2524,8 +2520,7 @@ static int test_aead_extra(const char *driver,
 	return err;
 }
 #else /* !CONFIG_CRYPTO_MANAGER_EXTRA_TESTS */
-static int test_aead_extra(const char *driver,
-			   const struct alg_test_desc *test_desc,
+static int test_aead_extra(const struct alg_test_desc *test_desc,
 			   struct aead_request *req,
 			   struct cipher_test_sglists *tsgls)
 {
@@ -2533,8 +2528,7 @@ static int test_aead_extra(const char *driver,
 }
 #endif /* !CONFIG_CRYPTO_MANAGER_EXTRA_TESTS */
 
-static int test_aead(const char *driver, int enc,
-		     const struct aead_test_suite *suite,
+static int test_aead(int enc, const struct aead_test_suite *suite,
 		     struct aead_request *req,
 		     struct cipher_test_sglists *tsgls)
 {
@@ -2542,8 +2536,7 @@ static int test_aead(const char *driver, int enc,
 	int err;
 
 	for (i = 0; i < suite->count; i++) {
-		err = test_aead_vec(driver, enc, &suite->vecs[i], i, req,
-				    tsgls);
+		err = test_aead_vec(enc, &suite->vecs[i], i, req, tsgls);
 		if (err)
 			return err;
 		cond_resched();
@@ -2571,6 +2564,7 @@ static int alg_test_aead(const struct alg_test_desc *desc, const char *driver,
 		       driver, PTR_ERR(tfm));
 		return PTR_ERR(tfm);
 	}
+	driver = crypto_aead_driver_name(tfm);
 
 	req = aead_request_alloc(tfm, GFP_KERNEL);
 	if (!req) {
@@ -2588,15 +2582,15 @@ static int alg_test_aead(const struct alg_test_desc *desc, const char *driver,
 		goto out;
 	}
 
-	err = test_aead(driver, ENCRYPT, suite, req, tsgls);
+	err = test_aead(ENCRYPT, suite, req, tsgls);
 	if (err)
 		goto out;
 
-	err = test_aead(driver, DECRYPT, suite, req, tsgls);
+	err = test_aead(DECRYPT, suite, req, tsgls);
 	if (err)
 		goto out;
 
-	err = test_aead_extra(driver, desc, req, tsgls);
+	err = test_aead_extra(desc, req, tsgls);
 out:
 	free_cipher_test_sglists(tsgls);
 	aead_request_free(req);
-- 
2.29.1

