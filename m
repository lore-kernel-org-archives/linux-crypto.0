Return-Path: <SRS0=A9yi=EB=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.1 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 078FEC2D0A3
	for <linux-crypto@archiver.kernel.org>; Mon, 26 Oct 2020 16:17:29 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id BC5D421D41
	for <linux-crypto@archiver.kernel.org>; Mon, 26 Oct 2020 16:17:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1603729048;
	bh=LlKTdn6AWzllSfYajNgLmJMWhWtyP0qZCJSQOrjj9nQ=;
	h=From:To:Subject:Date:In-Reply-To:References:List-ID:From;
	b=ClIhAcdkiPRsNyvtp1UyDKqmVOr9L5NgAeO7b+rNZROg6fFcKmwGJhxYWaGhrkjS5
	 rUltYJHHleU6kGSP07mjM+vnhK+SV8FL/6cepdJQUGc+WtU0IjzMr5j7q0Yw+rWDBx
	 dqsxW32OItlyYjzITQ8MXsjU1T/CbAQdfIzJR3VA=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1775423AbgJZQR2 (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Mon, 26 Oct 2020 12:17:28 -0400
Received: from mail.kernel.org ([198.145.29.99]:60378 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1775448AbgJZQR0 (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 26 Oct 2020 12:17:26 -0400
Received: from sol.attlocal.net (172-10-235-113.lightspeed.sntcca.sbcglobal.net [172.10.235.113])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id E9E7A20738
        for <linux-crypto@vger.kernel.org>; Mon, 26 Oct 2020 16:17:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1603729046;
        bh=LlKTdn6AWzllSfYajNgLmJMWhWtyP0qZCJSQOrjj9nQ=;
        h=From:To:Subject:Date:In-Reply-To:References:From;
        b=OLPBsF0CgsF7hnUIFfL6Hc0KbpA4G8e0I48O9RTkgNIJtGoFf4OnosrAL/46+w/VY
         0mCoiIpP+0RZwei86y4+xxD7sSQnFURTV0965vkJeDuqcCBIMT1LT8bW7yVqmHBD3E
         ddBz+tMhMSD9vgtZgpCld5TnUx88J/W2SomVu0Gw=
From:   Eric Biggers <ebiggers@kernel.org>
To:     linux-crypto@vger.kernel.org
Subject: [PATCH 4/4] crypto: testmgr - always print the actual skcipher driver name
Date:   Mon, 26 Oct 2020 09:17:02 -0700
Message-Id: <20201026161702.39201-5-ebiggers@kernel.org>
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

Fix this for the skcipher algorithm tests by getting the driver name
from the crypto_skcipher that actually got allocated.

Signed-off-by: Eric Biggers <ebiggers@google.com>
---
 crypto/testmgr.c | 36 ++++++++++++++++--------------------
 1 file changed, 16 insertions(+), 20 deletions(-)

diff --git a/crypto/testmgr.c b/crypto/testmgr.c
index 1b785b2f49870..dcc1fa415e8e0 100644
--- a/crypto/testmgr.c
+++ b/crypto/testmgr.c
@@ -2685,8 +2685,7 @@ static int test_cipher(struct crypto_cipher *tfm, int enc,
 	return ret;
 }
 
-static int test_skcipher_vec_cfg(const char *driver, int enc,
-				 const struct cipher_testvec *vec,
+static int test_skcipher_vec_cfg(int enc, const struct cipher_testvec *vec,
 				 const char *vec_name,
 				 const struct testvec_config *cfg,
 				 struct skcipher_request *req,
@@ -2695,6 +2694,7 @@ static int test_skcipher_vec_cfg(const char *driver, int enc,
 	struct crypto_skcipher *tfm = crypto_skcipher_reqtfm(req);
 	const unsigned int alignmask = crypto_skcipher_alignmask(tfm);
 	const unsigned int ivsize = crypto_skcipher_ivsize(tfm);
+	const char *driver = crypto_skcipher_driver_name(tfm);
 	const u32 req_flags = CRYPTO_TFM_REQ_MAY_BACKLOG | cfg->req_flags;
 	const char *op = enc ? "encryption" : "decryption";
 	DECLARE_CRYPTO_WAIT(wait);
@@ -2849,8 +2849,7 @@ static int test_skcipher_vec_cfg(const char *driver, int enc,
 	return 0;
 }
 
-static int test_skcipher_vec(const char *driver, int enc,
-			     const struct cipher_testvec *vec,
+static int test_skcipher_vec(int enc, const struct cipher_testvec *vec,
 			     unsigned int vec_num,
 			     struct skcipher_request *req,
 			     struct cipher_test_sglists *tsgls)
@@ -2865,7 +2864,7 @@ static int test_skcipher_vec(const char *driver, int enc,
 	sprintf(vec_name, "%u", vec_num);
 
 	for (i = 0; i < ARRAY_SIZE(default_cipher_testvec_configs); i++) {
-		err = test_skcipher_vec_cfg(driver, enc, vec, vec_name,
+		err = test_skcipher_vec_cfg(enc, vec, vec_name,
 					    &default_cipher_testvec_configs[i],
 					    req, tsgls);
 		if (err)
@@ -2880,7 +2879,7 @@ static int test_skcipher_vec(const char *driver, int enc,
 		for (i = 0; i < fuzz_iterations; i++) {
 			generate_random_testvec_config(&cfg, cfgname,
 						       sizeof(cfgname));
-			err = test_skcipher_vec_cfg(driver, enc, vec, vec_name,
+			err = test_skcipher_vec_cfg(enc, vec, vec_name,
 						    &cfg, req, tsgls);
 			if (err)
 				return err;
@@ -2951,8 +2950,7 @@ static void generate_random_cipher_testvec(struct skcipher_request *req,
  * Test the skcipher algorithm represented by @req against the corresponding
  * generic implementation, if one is available.
  */
-static int test_skcipher_vs_generic_impl(const char *driver,
-					 const char *generic_driver,
+static int test_skcipher_vs_generic_impl(const char *generic_driver,
 					 struct skcipher_request *req,
 					 struct cipher_test_sglists *tsgls)
 {
@@ -2962,6 +2960,7 @@ static int test_skcipher_vs_generic_impl(const char *driver,
 	const unsigned int blocksize = crypto_skcipher_blocksize(tfm);
 	const unsigned int maxdatasize = (2 * PAGE_SIZE) - TESTMGR_POISON_LEN;
 	const char *algname = crypto_skcipher_alg(tfm)->base.cra_name;
+	const char *driver = crypto_skcipher_driver_name(tfm);
 	char _generic_driver[CRYPTO_MAX_ALG_NAME];
 	struct crypto_skcipher *generic_tfm = NULL;
 	struct skcipher_request *generic_req = NULL;
@@ -3067,11 +3066,11 @@ static int test_skcipher_vs_generic_impl(const char *driver,
 					       vec_name, sizeof(vec_name));
 		generate_random_testvec_config(cfg, cfgname, sizeof(cfgname));
 
-		err = test_skcipher_vec_cfg(driver, ENCRYPT, &vec, vec_name,
+		err = test_skcipher_vec_cfg(ENCRYPT, &vec, vec_name,
 					    cfg, req, tsgls);
 		if (err)
 			goto out;
-		err = test_skcipher_vec_cfg(driver, DECRYPT, &vec, vec_name,
+		err = test_skcipher_vec_cfg(DECRYPT, &vec, vec_name,
 					    cfg, req, tsgls);
 		if (err)
 			goto out;
@@ -3089,8 +3088,7 @@ static int test_skcipher_vs_generic_impl(const char *driver,
 	return err;
 }
 #else /* !CONFIG_CRYPTO_MANAGER_EXTRA_TESTS */
-static int test_skcipher_vs_generic_impl(const char *driver,
-					 const char *generic_driver,
+static int test_skcipher_vs_generic_impl(const char *generic_driver,
 					 struct skcipher_request *req,
 					 struct cipher_test_sglists *tsgls)
 {
@@ -3098,8 +3096,7 @@ static int test_skcipher_vs_generic_impl(const char *driver,
 }
 #endif /* !CONFIG_CRYPTO_MANAGER_EXTRA_TESTS */
 
-static int test_skcipher(const char *driver, int enc,
-			 const struct cipher_test_suite *suite,
+static int test_skcipher(int enc, const struct cipher_test_suite *suite,
 			 struct skcipher_request *req,
 			 struct cipher_test_sglists *tsgls)
 {
@@ -3107,8 +3104,7 @@ static int test_skcipher(const char *driver, int enc,
 	int err;
 
 	for (i = 0; i < suite->count; i++) {
-		err = test_skcipher_vec(driver, enc, &suite->vecs[i], i, req,
-					tsgls);
+		err = test_skcipher_vec(enc, &suite->vecs[i], i, req, tsgls);
 		if (err)
 			return err;
 		cond_resched();
@@ -3136,6 +3132,7 @@ static int alg_test_skcipher(const struct alg_test_desc *desc,
 		       driver, PTR_ERR(tfm));
 		return PTR_ERR(tfm);
 	}
+	driver = crypto_skcipher_driver_name(tfm);
 
 	req = skcipher_request_alloc(tfm, GFP_KERNEL);
 	if (!req) {
@@ -3153,16 +3150,15 @@ static int alg_test_skcipher(const struct alg_test_desc *desc,
 		goto out;
 	}
 
-	err = test_skcipher(driver, ENCRYPT, suite, req, tsgls);
+	err = test_skcipher(ENCRYPT, suite, req, tsgls);
 	if (err)
 		goto out;
 
-	err = test_skcipher(driver, DECRYPT, suite, req, tsgls);
+	err = test_skcipher(DECRYPT, suite, req, tsgls);
 	if (err)
 		goto out;
 
-	err = test_skcipher_vs_generic_impl(driver, desc->generic_driver, req,
-					    tsgls);
+	err = test_skcipher_vs_generic_impl(desc->generic_driver, req, tsgls);
 out:
 	free_cipher_test_sglists(tsgls);
 	skcipher_request_free(req);
-- 
2.29.1

