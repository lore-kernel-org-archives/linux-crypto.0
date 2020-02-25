Return-Path: <SRS0=ER22=4N=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=unavailable autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9B7DAC35E04
	for <linux-crypto@archiver.kernel.org>; Tue, 25 Feb 2020 15:48:51 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 7A96C218AC
	for <linux-crypto@archiver.kernel.org>; Tue, 25 Feb 2020 15:48:51 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731013AbgBYPsr (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Tue, 25 Feb 2020 10:48:47 -0500
Received: from foss.arm.com ([217.140.110.172]:52374 "EHLO foss.arm.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730019AbgBYPsr (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 25 Feb 2020 10:48:47 -0500
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 4F0D5328;
        Tue, 25 Feb 2020 07:48:46 -0800 (PST)
Received: from e110176-lin.kfn.arm.com (unknown [10.50.4.157])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id E681C3F703;
        Tue, 25 Feb 2020 07:48:44 -0800 (PST)
From:   Gilad Ben-Yossef <gilad@benyossef.com>
To:     Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>
Cc:     Ofir Drang <ofir.drang@arm.com>,
        Eric Biggers <ebiggers@kernel.org>,
        linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH 1/2] crypto: testmgr - use generic algs making test vecs
Date:   Tue, 25 Feb 2020 17:48:33 +0200
Message-Id: <20200225154834.25108-2-gilad@benyossef.com>
X-Mailer: git-send-email 2.25.0
In-Reply-To: <20200225154834.25108-1-gilad@benyossef.com>
References: <20200225154834.25108-1-gilad@benyossef.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Use generic algs to produce inauthentic AEAD messages,
otherwise we are running the risk of using an untested
code to produce the test messages.

As this code is only used in developer only extended tests
any cycles/runtime costs are negligible.

Signed-off-by: Gilad Ben-Yossef <gilad@benyossef.com>
Cc: Eric Biggers <ebiggers@kernel.org>
---
 crypto/testmgr.c | 50 +++++++++++++++++++++++++++++++++++++++++++-----
 1 file changed, 45 insertions(+), 5 deletions(-)

diff --git a/crypto/testmgr.c b/crypto/testmgr.c
index 88f33c0efb23..cf565b063cdf 100644
--- a/crypto/testmgr.c
+++ b/crypto/testmgr.c
@@ -2314,12 +2314,13 @@ static void generate_random_aead_testvec(struct aead_request *req,
 }
 
 static void try_to_generate_inauthentic_testvec(
-					struct aead_extra_tests_ctx *ctx)
+					struct aead_extra_tests_ctx *ctx,
+					struct aead_request *req)
 {
 	int i;
 
 	for (i = 0; i < 10; i++) {
-		generate_random_aead_testvec(ctx->req, &ctx->vec,
+		generate_random_aead_testvec(req, &ctx->vec,
 					     &ctx->test_desc->suite.aead,
 					     ctx->maxkeysize, ctx->maxdatasize,
 					     ctx->vec_name,
@@ -2337,8 +2338,42 @@ static int test_aead_inauthentic_inputs(struct aead_extra_tests_ctx *ctx)
 {
 	unsigned int i;
 	int err;
+	struct crypto_aead *tfm = ctx->tfm;
+	const char *algname = crypto_aead_alg(tfm)->base.cra_name;
+	const char *driver = ctx->driver;
+	const char *generic_driver = ctx->test_desc->generic_driver;
+	char _generic_driver[CRYPTO_MAX_ALG_NAME];
+	struct crypto_aead *generic_tfm = NULL;
+	struct aead_request *generic_req = NULL;
+
+	if (!generic_driver) {
+		err = build_generic_driver_name(algname, _generic_driver);
+		if (err)
+			return err;
+		generic_driver = _generic_driver;
+	}
+
+	if (!strcmp(generic_driver, driver) == 0) {
+		/* Already the generic impl? */
+
+		generic_tfm = crypto_alloc_aead(generic_driver, 0, 0);
+		if (IS_ERR(generic_tfm)) {
+			err = PTR_ERR(generic_tfm);
+			pr_err("alg: aead: error allocating %s (generic impl of %s): %d\n",
+			generic_driver, algname, err);
+			return err;
+		}
+
+		generic_req = aead_request_alloc(generic_tfm, GFP_KERNEL);
+		if (!generic_req)
+			goto free_tfm;
+	}
 
 	for (i = 0; i < fuzz_iterations * 8; i++) {
+		struct aead_request *req;
+
+		req = generic_req ? generic_req : ctx->req;
+
 		/*
 		 * Since this part of the tests isn't comparing the
 		 * implementation to another, there's no point in testing any
@@ -2348,7 +2383,7 @@ static int test_aead_inauthentic_inputs(struct aead_extra_tests_ctx *ctx)
 		 * if the algorithm keeps rejecting the generated keys, don't
 		 * retry forever; just continue on.
 		 */
-		try_to_generate_inauthentic_testvec(ctx);
+		try_to_generate_inauthentic_testvec(ctx, req);
 		if (ctx->vec.novrfy) {
 			generate_random_testvec_config(&ctx->cfg, ctx->cfgname,
 						       sizeof(ctx->cfgname));
@@ -2356,11 +2391,16 @@ static int test_aead_inauthentic_inputs(struct aead_extra_tests_ctx *ctx)
 						ctx->vec_name, &ctx->cfg,
 						ctx->req, ctx->tsgls);
 			if (err)
-				return err;
+				goto out;
 		}
 		cond_resched();
 	}
-	return 0;
+
+out:
+	aead_request_free(generic_req);
+free_tfm:
+	crypto_free_aead(generic_tfm);
+	return err;
 }
 
 /*
-- 
2.25.0

