Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-26.3 required=3.0 tests=BAYES_00,DKIMWL_WL_MED,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT,USER_IN_DEF_DKIM_WL autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A02BCC636CA
	for <linux-crypto@archiver.kernel.org>; Thu, 15 Jul 2021 21:32:16 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 733FE61374
	for <linux-crypto@archiver.kernel.org>; Thu, 15 Jul 2021 21:32:16 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231364AbhGOVfI (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 15 Jul 2021 17:35:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39382 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231383AbhGOVe5 (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 15 Jul 2021 17:34:57 -0400
Received: from mail-qt1-x849.google.com (mail-qt1-x849.google.com [IPv6:2607:f8b0:4864:20::849])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A0A5CC061764
        for <linux-crypto@vger.kernel.org>; Thu, 15 Jul 2021 14:32:03 -0700 (PDT)
Received: by mail-qt1-x849.google.com with SMTP id 100-20020aed206d0000b029024ea3acef5bso5052368qta.12
        for <linux-crypto@vger.kernel.org>; Thu, 15 Jul 2021 14:32:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=T1/9836cQsafXym5j2R7aUELCuwh7E9Tqp3jPPdw4OE=;
        b=YMad7OiXGJ0ODjrvGVmUWrSzXRnRu/k+E93O/llQQdWDUocE/WM81qCQ3/bp5f3luz
         5cVk+gPjsJQxGXj/bLK5qs9oLfrZtQu+WXMcj0qy2vZt6krCa03aMsW2MnwBu72Pk16c
         OCcVWapxKfTyUXm7zIM0s19MQOxfH5EPhmqDb6oDma6CEJVddXFRQ5e9bjsAiJMCtLcR
         Qz9xWXvu8NWmswEomvH1ZYPvO8eZDTVTVRW8no/FpZo70I2JwtD1RmuhUwpoRDrdryOB
         th8KEJo+0isCWKkxbQ0Wgzrylgk4OPTnV5NmTLsuk1BE+EuJ+tbe+BoQ6CGRUjI1nXVj
         Qtqw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=T1/9836cQsafXym5j2R7aUELCuwh7E9Tqp3jPPdw4OE=;
        b=kXEBHjjhtjPq35jRzbSBx35NNU91EvFKKudh42cIpG1dzC3iAy9KWACkLCTnkhBKYI
         506qWHQpJCljHIrQ2iTDG61lCIf+oU+Jff2869Rg45ZRVW1y0BM1flNkzftOCLRfw+kQ
         wDuG6Chl1lRT0wZ/f+U3PH9phygtvNT4p8YtS4Fai6MN6rF1uovtCm+OdoEf7aJ1tUpl
         d7VqiVyN/n5O7FQ5reDs8SRBupg/Tsa5u9230EhXEesCXMfIzysnLSNXo4H/UyB3oA/L
         huzTcTeNQONctVyZga2Giep1tHCc7X2F7xRxBPnSA+U0rOB0Cs5dxqY9NH0fKFs4JVj7
         PfzQ==
X-Gm-Message-State: AOAM531LUB6Na63Ag70NB0KH55Jd2mzxzSvsIkpHEgZVtwYf+epIqewh
        vlxUS3ikJksOiGnmiJUmM2hWVyfWHU3jeQ==
X-Google-Smtp-Source: ABdhPJwEnn7qw35WeqduFHV1lAN3Xv9MbfL7Vbu2omcArdMVLtbnwy7krOB2BbNNRxqI4aXDb+hGxYVjycQZGQ==
X-Received: from dlatypov.svl.corp.google.com ([2620:15c:2cd:202:24a2:4c13:4cc0:8818])
 (user=dlatypov job=sendgmr) by 2002:a0c:9ada:: with SMTP id
 k26mr6615984qvf.16.1626384722579; Thu, 15 Jul 2021 14:32:02 -0700 (PDT)
Date:   Thu, 15 Jul 2021 14:31:38 -0700
In-Reply-To: <20210715213138.1363079-1-dlatypov@google.com>
Message-Id: <20210715213138.1363079-3-dlatypov@google.com>
Mime-Version: 1.0
References: <20210715213138.1363079-1-dlatypov@google.com>
X-Mailer: git-send-email 2.32.0.402.g57bb445576-goog
Subject: [RFC v1 2/2] crypto: tcrypt: call KUNIT_FAIL() instead of pr_err()
From:   Daniel Latypov <dlatypov@google.com>
To:     herbert@gondor.apana.org.au
Cc:     davem@davemloft.net, linux-crypto@vger.kernel.org,
        brendanhiggins@google.com, davidgow@google.com,
        linux-kernel@vger.kernel.org, kunit-dev@googlegroups.com,
        Daniel Latypov <dlatypov@google.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

When running the test module, tests outside of the default set can run
and print errors, but not signal failure via a non-zero exit code from
mod_init().
So it's up to a human to make sure they don't overlook any error logs.

KUnit doesn't use the exit code, but rather structured TAP output, like
kselftest. With this change, errors are still logged, but also mark the
overall KUnit test suite as failed to make the failure more obvious.

Example failure message from the kunit.py view:
[15:45:45] ======== [FAILED] tcrypt ========
[15:45:45] [FAILED] tcrypt
[15:45:45]     # tcrypt: EXPECTATION FAILED at crypto/tcrypt.c:1520
[15:45:45] failed to load transform for ecb(aes): -2

Raw kernel output:
    # Subtest: tcrypt
    1..1
    # tcrypt: EXPECTATION FAILED at crypto/tcrypt.c:1520
failed to load transform for ecb(aes): -2
    ...
    not ok 1 - tcrypt

Signed-off-by: Daniel Latypov <dlatypov@google.com>
---
 crypto/tcrypt.c | 762 ++++++++++++++++++++++++------------------------
 1 file changed, 381 insertions(+), 381 deletions(-)

diff --git a/crypto/tcrypt.c b/crypto/tcrypt.c
index 319fe71a69b5..ea62d217bd38 100644
--- a/crypto/tcrypt.c
+++ b/crypto/tcrypt.c
@@ -249,7 +249,7 @@ static int test_mb_aead_cycles(struct test_mb_aead_data *data, int enc,
 	return ret;
 }
 
-static void test_mb_aead_speed(const char *algo, int enc, int secs,
+static void test_mb_aead_speed(struct kunit *test, const char *algo, int enc, int secs,
 			       struct aead_speed_template *template,
 			       unsigned int tcount, u8 authsize,
 			       unsigned int aad_size, u8 *keysize, u32 num_mb)
@@ -266,7 +266,7 @@ static void test_mb_aead_speed(const char *algo, int enc, int secs,
 
 
 	if (aad_size >= PAGE_SIZE) {
-		pr_err("associate data length (%u) too big\n", aad_size);
+		KUNIT_FAIL(test, "associate data length (%u) too big\n", aad_size);
 		return;
 	}
 
@@ -285,7 +285,7 @@ static void test_mb_aead_speed(const char *algo, int enc, int secs,
 
 	tfm = crypto_alloc_aead(algo, 0, 0);
 	if (IS_ERR(tfm)) {
-		pr_err("failed to load transform for %s: %ld\n",
+		KUNIT_FAIL(test, "failed to load transform for %s: %ld\n",
 			algo, PTR_ERR(tfm));
 		goto out_free_data;
 	}
@@ -316,7 +316,7 @@ static void test_mb_aead_speed(const char *algo, int enc, int secs,
 	for (i = 0; i < num_mb; ++i) {
 		data[i].req = aead_request_alloc(tfm, GFP_KERNEL);
 		if (!data[i].req) {
-			pr_err("alg: skcipher: Failed to allocate request for %s\n",
+			KUNIT_FAIL(test, "alg: skcipher: Failed to allocate request for %s\n",
 			       algo);
 			while (i--)
 				aead_request_free(data[i].req);
@@ -341,7 +341,7 @@ static void test_mb_aead_speed(const char *algo, int enc, int secs,
 			int bs = round_up(*b_size, crypto_aead_blocksize(tfm));
 
 			if (bs + authsize > XBUFSIZE * PAGE_SIZE) {
-				pr_err("template (%u) too big for buffer (%lu)\n",
+				KUNIT_FAIL(test, "template (%u) too big for buffer (%lu)\n",
 				       authsize + bs,
 				       XBUFSIZE * PAGE_SIZE);
 				goto out;
@@ -365,7 +365,7 @@ static void test_mb_aead_speed(const char *algo, int enc, int secs,
 
 			ret = crypto_aead_setkey(tfm, key, *keysize);
 			if (ret) {
-				pr_err("setkey() failed flags=%x\n",
+				KUNIT_FAIL(test, "setkey() failed flags=%x\n",
 				       crypto_aead_get_flags(tfm));
 				goto out;
 			}
@@ -402,7 +402,7 @@ static void test_mb_aead_speed(const char *algo, int enc, int secs,
 					ret = do_one_aead_op(cur->req, ret);
 
 					if (ret) {
-						pr_err("calculating auth failed (%d)\n",
+						KUNIT_FAIL(test, "calculating auth failed (%d)\n",
 						       ret);
 						break;
 					}
@@ -425,7 +425,7 @@ static void test_mb_aead_speed(const char *algo, int enc, int secs,
 			}
 
 			if (ret) {
-				pr_err("%s() failed return code=%d\n", e, ret);
+				KUNIT_FAIL(test, "%s() failed return code=%d\n", e, ret);
 				break;
 			}
 			b_size++;
@@ -519,7 +519,7 @@ static int test_aead_cycles(struct aead_request *req, int enc, int blen)
 	return ret;
 }
 
-static void test_aead_speed(const char *algo, int enc, unsigned int secs,
+static void test_aead_speed(struct kunit *test, const char *algo, int enc, unsigned int secs,
 			    struct aead_speed_template *template,
 			    unsigned int tcount, u8 authsize,
 			    unsigned int aad_size, u8 *keysize)
@@ -546,7 +546,7 @@ static void test_aead_speed(const char *algo, int enc, unsigned int secs,
 		return;
 
 	if (aad_size >= PAGE_SIZE) {
-		pr_err("associate data length (%u) too big\n", aad_size);
+		KUNIT_FAIL(test, "associate data length (%u) too big\n", aad_size);
 		goto out_noxbuf;
 	}
 
@@ -570,7 +570,7 @@ static void test_aead_speed(const char *algo, int enc, unsigned int secs,
 	tfm = crypto_alloc_aead(algo, 0, 0);
 
 	if (IS_ERR(tfm)) {
-		pr_err("alg: aead: Failed to load transform for %s: %ld\n", algo,
+		KUNIT_FAIL(test, "alg: aead: Failed to load transform for %s: %ld\n", algo,
 		       PTR_ERR(tfm));
 		goto out_notfm;
 	}
@@ -581,7 +581,7 @@ static void test_aead_speed(const char *algo, int enc, unsigned int secs,
 
 	req = aead_request_alloc(tfm, GFP_KERNEL);
 	if (!req) {
-		pr_err("alg: aead: Failed to allocate request for %s\n",
+		KUNIT_FAIL(test, "alg: aead: Failed to allocate request for %s\n",
 		       algo);
 		goto out_noreq;
 	}
@@ -599,7 +599,7 @@ static void test_aead_speed(const char *algo, int enc, unsigned int secs,
 			memset(assoc, 0xff, aad_size);
 
 			if ((*keysize + bs) > TVMEMSIZE * PAGE_SIZE) {
-				pr_err("template (%u) too big for tvmem (%lu)\n",
+				KUNIT_FAIL(test, "template (%u) too big for tvmem (%lu)\n",
 				       *keysize + bs,
 					TVMEMSIZE * PAGE_SIZE);
 				goto out;
@@ -627,7 +627,7 @@ static void test_aead_speed(const char *algo, int enc, unsigned int secs,
 			memset(tvmem[0], 0xff, PAGE_SIZE);
 
 			if (ret) {
-				pr_err("setkey() failed flags=%x\n",
+				KUNIT_FAIL(test, "setkey() failed flags=%x\n",
 						crypto_aead_get_flags(tfm));
 				goto out;
 			}
@@ -654,7 +654,7 @@ static void test_aead_speed(const char *algo, int enc, unsigned int secs,
 						     crypto_aead_encrypt(req));
 
 				if (ret) {
-					pr_err("calculating auth failed (%d)\n",
+					KUNIT_FAIL(test, "calculating auth failed (%d)\n",
 					       ret);
 					break;
 				}
@@ -673,7 +673,7 @@ static void test_aead_speed(const char *algo, int enc, unsigned int secs,
 			}
 
 			if (ret) {
-				pr_err("%s() failed return code=%d\n", e, ret);
+				KUNIT_FAIL(test, "%s() failed return code=%d\n", e, ret);
 				break;
 			}
 			b_size++;
@@ -814,7 +814,7 @@ static int test_mb_ahash_cycles(struct test_mb_ahash_data *data, int blen,
 	return ret;
 }
 
-static void test_mb_ahash_speed(const char *algo, unsigned int secs,
+static void test_mb_ahash_speed(struct kunit *test, const char *algo, unsigned int secs,
 				struct hash_speed *speed, u32 num_mb)
 {
 	struct test_mb_ahash_data *data;
@@ -828,7 +828,7 @@ static void test_mb_ahash_speed(const char *algo, unsigned int secs,
 
 	tfm = crypto_alloc_ahash(algo, 0, 0);
 	if (IS_ERR(tfm)) {
-		pr_err("failed to load transform for %s: %ld\n",
+		KUNIT_FAIL(test, "failed to load transform for %s: %ld\n",
 			algo, PTR_ERR(tfm));
 		goto free_data;
 	}
@@ -841,7 +841,7 @@ static void test_mb_ahash_speed(const char *algo, unsigned int secs,
 
 		data[i].req = ahash_request_alloc(tfm, GFP_KERNEL);
 		if (!data[i].req) {
-			pr_err("alg: hash: Failed to allocate request for %s\n",
+			KUNIT_FAIL(test, "alg: hash: Failed to allocate request for %s\n",
 			       algo);
 			goto out;
 		}
@@ -865,7 +865,7 @@ static void test_mb_ahash_speed(const char *algo, unsigned int secs,
 			continue;
 
 		if (speed[i].blen > XBUFSIZE * PAGE_SIZE) {
-			pr_err("template (%u) too big for tvmem (%lu)\n",
+			KUNIT_FAIL(test, "template (%u) too big for tvmem (%lu)\n",
 			       speed[i].blen, XBUFSIZE * PAGE_SIZE);
 			goto out;
 		}
@@ -892,7 +892,7 @@ static void test_mb_ahash_speed(const char *algo, unsigned int secs,
 
 
 		if (ret) {
-			pr_err("At least one hashing failed ret=%d\n", ret);
+			KUNIT_FAIL(test, "At least one hashing failed ret=%d\n", ret);
 			break;
 		}
 	}
@@ -1057,7 +1057,7 @@ static int test_ahash_cycles(struct ahash_request *req, int blen,
 	return 0;
 }
 
-static void test_ahash_speed_common(const char *algo, unsigned int secs,
+static void test_ahash_speed_common(struct kunit *test, const char *algo, unsigned int secs,
 				    struct hash_speed *speed, unsigned mask)
 {
 	struct scatterlist sg[TVMEMSIZE];
@@ -1069,7 +1069,7 @@ static void test_ahash_speed_common(const char *algo, unsigned int secs,
 
 	tfm = crypto_alloc_ahash(algo, 0, mask);
 	if (IS_ERR(tfm)) {
-		pr_err("failed to load transform for %s: %ld\n",
+		KUNIT_FAIL(test, "failed to load transform for %s: %ld\n",
 		       algo, PTR_ERR(tfm));
 		return;
 	}
@@ -1078,7 +1078,7 @@ static void test_ahash_speed_common(const char *algo, unsigned int secs,
 			get_driver_name(crypto_ahash, tfm));
 
 	if (crypto_ahash_digestsize(tfm) > MAX_DIGEST_SIZE) {
-		pr_err("digestsize(%u) > %d\n", crypto_ahash_digestsize(tfm),
+		KUNIT_FAIL(test, "digestsize(%u) > %d\n", crypto_ahash_digestsize(tfm),
 		       MAX_DIGEST_SIZE);
 		goto out;
 	}
@@ -1086,7 +1086,7 @@ static void test_ahash_speed_common(const char *algo, unsigned int secs,
 	test_hash_sg_init(sg);
 	req = ahash_request_alloc(tfm, GFP_KERNEL);
 	if (!req) {
-		pr_err("ahash request allocation failure\n");
+		KUNIT_FAIL(test, "ahash request allocation failure\n");
 		goto out;
 	}
 
@@ -1100,7 +1100,7 @@ static void test_ahash_speed_common(const char *algo, unsigned int secs,
 
 	for (i = 0; speed[i].blen != 0; i++) {
 		if (speed[i].blen > TVMEMSIZE * PAGE_SIZE) {
-			pr_err("template (%u) too big for tvmem (%lu)\n",
+			KUNIT_FAIL(test, "template (%u) too big for tvmem (%lu)\n",
 			       speed[i].blen, TVMEMSIZE * PAGE_SIZE);
 			break;
 		}
@@ -1124,7 +1124,7 @@ static void test_ahash_speed_common(const char *algo, unsigned int secs,
 		}
 
 		if (ret) {
-			pr_err("hashing failed ret=%d\n", ret);
+			KUNIT_FAIL(test, "hashing failed ret=%d\n", ret);
 			break;
 		}
 	}
@@ -1138,16 +1138,16 @@ static void test_ahash_speed_common(const char *algo, unsigned int secs,
 	crypto_free_ahash(tfm);
 }
 
-static void test_ahash_speed(const char *algo, unsigned int secs,
+static void test_ahash_speed(struct kunit *test, const char *algo, unsigned int secs,
 			     struct hash_speed *speed)
 {
-	return test_ahash_speed_common(algo, secs, speed, 0);
+	return test_ahash_speed_common(test, algo, secs, speed, 0);
 }
 
-static void test_hash_speed(const char *algo, unsigned int secs,
+static void test_hash_speed(struct kunit *test, const char *algo, unsigned int secs,
 			    struct hash_speed *speed)
 {
-	return test_ahash_speed_common(algo, secs, speed, CRYPTO_ALG_ASYNC);
+	return test_ahash_speed_common(test, algo, secs, speed, CRYPTO_ALG_ASYNC);
 }
 
 struct test_mb_skcipher_data {
@@ -1251,7 +1251,7 @@ static int test_mb_acipher_cycles(struct test_mb_skcipher_data *data, int enc,
 	return ret;
 }
 
-static void test_mb_skcipher_speed(const char *algo, int enc, int secs,
+static void test_mb_skcipher_speed(struct kunit *test, const char *algo, int enc, int secs,
 				   struct cipher_speed_template *template,
 				   unsigned int tcount, u8 *keysize, u32 num_mb)
 {
@@ -1275,7 +1275,7 @@ static void test_mb_skcipher_speed(const char *algo, int enc, int secs,
 
 	tfm = crypto_alloc_skcipher(algo, 0, 0);
 	if (IS_ERR(tfm)) {
-		pr_err("failed to load transform for %s: %ld\n",
+		KUNIT_FAIL(test, "failed to load transform for %s: %ld\n",
 			algo, PTR_ERR(tfm));
 		goto out_free_data;
 	}
@@ -1299,7 +1299,7 @@ static void test_mb_skcipher_speed(const char *algo, int enc, int secs,
 	for (i = 0; i < num_mb; ++i) {
 		data[i].req = skcipher_request_alloc(tfm, GFP_KERNEL);
 		if (!data[i].req) {
-			pr_err("alg: skcipher: Failed to allocate request for %s\n",
+			KUNIT_FAIL(test, "alg: skcipher: Failed to allocate request for %s\n",
 			       algo);
 			while (i--)
 				skcipher_request_free(data[i].req);
@@ -1324,7 +1324,7 @@ static void test_mb_skcipher_speed(const char *algo, int enc, int secs,
 			u32 bs = round_up(*b_size, crypto_skcipher_blocksize(tfm));
 
 			if (bs > XBUFSIZE * PAGE_SIZE) {
-				pr_err("template (%u) too big for buffer (%lu)\n",
+				KUNIT_FAIL(test, "template (%u) too big for buffer (%lu)\n",
 				       *b_size, XBUFSIZE * PAGE_SIZE);
 				goto out;
 			}
@@ -1347,7 +1347,7 @@ static void test_mb_skcipher_speed(const char *algo, int enc, int secs,
 
 			ret = crypto_skcipher_setkey(tfm, key, *keysize);
 			if (ret) {
-				pr_err("setkey() failed flags=%x\n",
+				KUNIT_FAIL(test, "setkey() failed flags=%x\n",
 				       crypto_skcipher_get_flags(tfm));
 				goto out;
 			}
@@ -1393,7 +1393,7 @@ static void test_mb_skcipher_speed(const char *algo, int enc, int secs,
 			}
 
 			if (ret) {
-				pr_err("%s() failed flags=%x\n", e,
+				KUNIT_FAIL(test, "%s() failed flags=%x\n", e,
 				       crypto_skcipher_get_flags(tfm));
 				break;
 			}
@@ -1494,7 +1494,7 @@ static int test_acipher_cycles(struct skcipher_request *req, int enc,
 	return ret;
 }
 
-static void test_skcipher_speed(const char *algo, int enc, unsigned int secs,
+static void test_skcipher_speed(struct kunit *test, const char *algo, int enc, unsigned int secs,
 				struct cipher_speed_template *template,
 				unsigned int tcount, u8 *keysize, bool async)
 {
@@ -1517,7 +1517,7 @@ static void test_skcipher_speed(const char *algo, int enc, unsigned int secs,
 	tfm = crypto_alloc_skcipher(algo, 0, async ? 0 : CRYPTO_ALG_ASYNC);
 
 	if (IS_ERR(tfm)) {
-		pr_err("failed to load transform for %s: %ld\n", algo,
+		KUNIT_FAIL(test, "failed to load transform for %s: %ld\n", algo,
 		       PTR_ERR(tfm));
 		return;
 	}
@@ -1527,7 +1527,7 @@ static void test_skcipher_speed(const char *algo, int enc, unsigned int secs,
 
 	req = skcipher_request_alloc(tfm, GFP_KERNEL);
 	if (!req) {
-		pr_err("tcrypt: skcipher: Failed to allocate request for %s\n",
+		KUNIT_FAIL(test, "tcrypt: skcipher: Failed to allocate request for %s\n",
 		       algo);
 		goto out;
 	}
@@ -1544,7 +1544,7 @@ static void test_skcipher_speed(const char *algo, int enc, unsigned int secs,
 			struct scatterlist sg[TVMEMSIZE];
 
 			if ((*keysize + bs) > TVMEMSIZE * PAGE_SIZE) {
-				pr_err("template (%u) too big for "
+				KUNIT_FAIL(test, "template (%u) too big for "
 				       "tvmem (%lu)\n", *keysize + bs,
 				       TVMEMSIZE * PAGE_SIZE);
 				goto out_free_req;
@@ -1568,7 +1568,7 @@ static void test_skcipher_speed(const char *algo, int enc, unsigned int secs,
 
 			ret = crypto_skcipher_setkey(tfm, key, *keysize);
 			if (ret) {
-				pr_err("setkey() failed flags=%x\n",
+				KUNIT_FAIL(test, "setkey() failed flags=%x\n",
 					crypto_skcipher_get_flags(tfm));
 				goto out_free_req;
 			}
@@ -1609,7 +1609,7 @@ static void test_skcipher_speed(const char *algo, int enc, unsigned int secs,
 			}
 
 			if (ret) {
-				pr_err("%s() failed flags=%x\n", e,
+				KUNIT_FAIL(test, "%s() failed flags=%x\n", e,
 				       crypto_skcipher_get_flags(tfm));
 				break;
 			}
@@ -1625,19 +1625,19 @@ static void test_skcipher_speed(const char *algo, int enc, unsigned int secs,
 	crypto_free_skcipher(tfm);
 }
 
-static void test_acipher_speed(const char *algo, int enc, unsigned int secs,
+static void test_acipher_speed(struct kunit *test, const char *algo, int enc, unsigned int secs,
 			       struct cipher_speed_template *template,
 			       unsigned int tcount, u8 *keysize)
 {
-	return test_skcipher_speed(algo, enc, secs, template, tcount, keysize,
+	return test_skcipher_speed(test, algo, enc, secs, template, tcount, keysize,
 				   true);
 }
 
-static void test_cipher_speed(const char *algo, int enc, unsigned int secs,
+static void test_cipher_speed(struct kunit *test, const char *algo, int enc, unsigned int secs,
 			      struct cipher_speed_template *template,
 			      unsigned int tcount, u8 *keysize)
 {
-	return test_skcipher_speed(algo, enc, secs, template, tcount, keysize,
+	return test_skcipher_speed(test, algo, enc, secs, template, tcount, keysize,
 				   false);
 }
 
@@ -1657,7 +1657,7 @@ static inline void tcrypt_test(struct kunit *test, const char *alg)
 {
 	int ret;
 
-	pr_debug("testing %s\n", alg);
+	kunit_info(test, "testing %s\n", alg);
 
 	ret = alg_test(alg, alg, 0, 0);
 	/* non-fips algs return -EINVAL in fips mode */
@@ -2035,400 +2035,400 @@ static void do_test(struct kunit *test, const char *alg, u32 type, u32 mask,
 		tcrypt_test(test, "ctr(sm4)");
 		break;
 	case 200:
-		test_cipher_speed("ecb(aes)", ENCRYPT, sec, NULL, 0,
+		test_cipher_speed(test, "ecb(aes)", ENCRYPT, sec, NULL, 0,
 				speed_template_16_24_32);
-		test_cipher_speed("ecb(aes)", DECRYPT, sec, NULL, 0,
+		test_cipher_speed(test, "ecb(aes)", DECRYPT, sec, NULL, 0,
 				speed_template_16_24_32);
-		test_cipher_speed("cbc(aes)", ENCRYPT, sec, NULL, 0,
+		test_cipher_speed(test, "cbc(aes)", ENCRYPT, sec, NULL, 0,
 				speed_template_16_24_32);
-		test_cipher_speed("cbc(aes)", DECRYPT, sec, NULL, 0,
+		test_cipher_speed(test, "cbc(aes)", DECRYPT, sec, NULL, 0,
 				speed_template_16_24_32);
-		test_cipher_speed("lrw(aes)", ENCRYPT, sec, NULL, 0,
+		test_cipher_speed(test, "lrw(aes)", ENCRYPT, sec, NULL, 0,
 				speed_template_32_40_48);
-		test_cipher_speed("lrw(aes)", DECRYPT, sec, NULL, 0,
+		test_cipher_speed(test, "lrw(aes)", DECRYPT, sec, NULL, 0,
 				speed_template_32_40_48);
-		test_cipher_speed("xts(aes)", ENCRYPT, sec, NULL, 0,
+		test_cipher_speed(test, "xts(aes)", ENCRYPT, sec, NULL, 0,
 				speed_template_32_64);
-		test_cipher_speed("xts(aes)", DECRYPT, sec, NULL, 0,
+		test_cipher_speed(test, "xts(aes)", DECRYPT, sec, NULL, 0,
 				speed_template_32_64);
-		test_cipher_speed("cts(cbc(aes))", ENCRYPT, sec, NULL, 0,
+		test_cipher_speed(test, "cts(cbc(aes))", ENCRYPT, sec, NULL, 0,
 				speed_template_16_24_32);
-		test_cipher_speed("cts(cbc(aes))", DECRYPT, sec, NULL, 0,
+		test_cipher_speed(test, "cts(cbc(aes))", DECRYPT, sec, NULL, 0,
 				speed_template_16_24_32);
-		test_cipher_speed("ctr(aes)", ENCRYPT, sec, NULL, 0,
+		test_cipher_speed(test, "ctr(aes)", ENCRYPT, sec, NULL, 0,
 				speed_template_16_24_32);
-		test_cipher_speed("ctr(aes)", DECRYPT, sec, NULL, 0,
+		test_cipher_speed(test, "ctr(aes)", DECRYPT, sec, NULL, 0,
 				speed_template_16_24_32);
-		test_cipher_speed("cfb(aes)", ENCRYPT, sec, NULL, 0,
+		test_cipher_speed(test, "cfb(aes)", ENCRYPT, sec, NULL, 0,
 				speed_template_16_24_32);
-		test_cipher_speed("cfb(aes)", DECRYPT, sec, NULL, 0,
+		test_cipher_speed(test, "cfb(aes)", DECRYPT, sec, NULL, 0,
 				speed_template_16_24_32);
 		break;
 
 	case 201:
-		test_cipher_speed("ecb(des3_ede)", ENCRYPT, sec,
+		test_cipher_speed(test, "ecb(des3_ede)", ENCRYPT, sec,
 				des3_speed_template, DES3_SPEED_VECTORS,
 				speed_template_24);
-		test_cipher_speed("ecb(des3_ede)", DECRYPT, sec,
+		test_cipher_speed(test, "ecb(des3_ede)", DECRYPT, sec,
 				des3_speed_template, DES3_SPEED_VECTORS,
 				speed_template_24);
-		test_cipher_speed("cbc(des3_ede)", ENCRYPT, sec,
+		test_cipher_speed(test, "cbc(des3_ede)", ENCRYPT, sec,
 				des3_speed_template, DES3_SPEED_VECTORS,
 				speed_template_24);
-		test_cipher_speed("cbc(des3_ede)", DECRYPT, sec,
+		test_cipher_speed(test, "cbc(des3_ede)", DECRYPT, sec,
 				des3_speed_template, DES3_SPEED_VECTORS,
 				speed_template_24);
-		test_cipher_speed("ctr(des3_ede)", ENCRYPT, sec,
+		test_cipher_speed(test, "ctr(des3_ede)", ENCRYPT, sec,
 				des3_speed_template, DES3_SPEED_VECTORS,
 				speed_template_24);
-		test_cipher_speed("ctr(des3_ede)", DECRYPT, sec,
+		test_cipher_speed(test, "ctr(des3_ede)", DECRYPT, sec,
 				des3_speed_template, DES3_SPEED_VECTORS,
 				speed_template_24);
 		break;
 
 	case 202:
-		test_cipher_speed("ecb(twofish)", ENCRYPT, sec, NULL, 0,
+		test_cipher_speed(test, "ecb(twofish)", ENCRYPT, sec, NULL, 0,
 				speed_template_16_24_32);
-		test_cipher_speed("ecb(twofish)", DECRYPT, sec, NULL, 0,
+		test_cipher_speed(test, "ecb(twofish)", DECRYPT, sec, NULL, 0,
 				speed_template_16_24_32);
-		test_cipher_speed("cbc(twofish)", ENCRYPT, sec, NULL, 0,
+		test_cipher_speed(test, "cbc(twofish)", ENCRYPT, sec, NULL, 0,
 				speed_template_16_24_32);
-		test_cipher_speed("cbc(twofish)", DECRYPT, sec, NULL, 0,
+		test_cipher_speed(test, "cbc(twofish)", DECRYPT, sec, NULL, 0,
 				speed_template_16_24_32);
-		test_cipher_speed("ctr(twofish)", ENCRYPT, sec, NULL, 0,
+		test_cipher_speed(test, "ctr(twofish)", ENCRYPT, sec, NULL, 0,
 				speed_template_16_24_32);
-		test_cipher_speed("ctr(twofish)", DECRYPT, sec, NULL, 0,
+		test_cipher_speed(test, "ctr(twofish)", DECRYPT, sec, NULL, 0,
 				speed_template_16_24_32);
-		test_cipher_speed("lrw(twofish)", ENCRYPT, sec, NULL, 0,
+		test_cipher_speed(test, "lrw(twofish)", ENCRYPT, sec, NULL, 0,
 				speed_template_32_40_48);
-		test_cipher_speed("lrw(twofish)", DECRYPT, sec, NULL, 0,
+		test_cipher_speed(test, "lrw(twofish)", DECRYPT, sec, NULL, 0,
 				speed_template_32_40_48);
-		test_cipher_speed("xts(twofish)", ENCRYPT, sec, NULL, 0,
+		test_cipher_speed(test, "xts(twofish)", ENCRYPT, sec, NULL, 0,
 				speed_template_32_48_64);
-		test_cipher_speed("xts(twofish)", DECRYPT, sec, NULL, 0,
+		test_cipher_speed(test, "xts(twofish)", DECRYPT, sec, NULL, 0,
 				speed_template_32_48_64);
 		break;
 
 	case 203:
-		test_cipher_speed("ecb(blowfish)", ENCRYPT, sec, NULL, 0,
+		test_cipher_speed(test, "ecb(blowfish)", ENCRYPT, sec, NULL, 0,
 				  speed_template_8_32);
-		test_cipher_speed("ecb(blowfish)", DECRYPT, sec, NULL, 0,
+		test_cipher_speed(test, "ecb(blowfish)", DECRYPT, sec, NULL, 0,
 				  speed_template_8_32);
-		test_cipher_speed("cbc(blowfish)", ENCRYPT, sec, NULL, 0,
+		test_cipher_speed(test, "cbc(blowfish)", ENCRYPT, sec, NULL, 0,
 				  speed_template_8_32);
-		test_cipher_speed("cbc(blowfish)", DECRYPT, sec, NULL, 0,
+		test_cipher_speed(test, "cbc(blowfish)", DECRYPT, sec, NULL, 0,
 				  speed_template_8_32);
-		test_cipher_speed("ctr(blowfish)", ENCRYPT, sec, NULL, 0,
+		test_cipher_speed(test, "ctr(blowfish)", ENCRYPT, sec, NULL, 0,
 				  speed_template_8_32);
-		test_cipher_speed("ctr(blowfish)", DECRYPT, sec, NULL, 0,
+		test_cipher_speed(test, "ctr(blowfish)", DECRYPT, sec, NULL, 0,
 				  speed_template_8_32);
 		break;
 
 	case 204:
-		test_cipher_speed("ecb(des)", ENCRYPT, sec, NULL, 0,
+		test_cipher_speed(test, "ecb(des)", ENCRYPT, sec, NULL, 0,
 				  speed_template_8);
-		test_cipher_speed("ecb(des)", DECRYPT, sec, NULL, 0,
+		test_cipher_speed(test, "ecb(des)", DECRYPT, sec, NULL, 0,
 				  speed_template_8);
-		test_cipher_speed("cbc(des)", ENCRYPT, sec, NULL, 0,
+		test_cipher_speed(test, "cbc(des)", ENCRYPT, sec, NULL, 0,
 				  speed_template_8);
-		test_cipher_speed("cbc(des)", DECRYPT, sec, NULL, 0,
+		test_cipher_speed(test, "cbc(des)", DECRYPT, sec, NULL, 0,
 				  speed_template_8);
 		break;
 
 	case 205:
-		test_cipher_speed("ecb(camellia)", ENCRYPT, sec, NULL, 0,
+		test_cipher_speed(test, "ecb(camellia)", ENCRYPT, sec, NULL, 0,
 				speed_template_16_24_32);
-		test_cipher_speed("ecb(camellia)", DECRYPT, sec, NULL, 0,
+		test_cipher_speed(test, "ecb(camellia)", DECRYPT, sec, NULL, 0,
 				speed_template_16_24_32);
-		test_cipher_speed("cbc(camellia)", ENCRYPT, sec, NULL, 0,
+		test_cipher_speed(test, "cbc(camellia)", ENCRYPT, sec, NULL, 0,
 				speed_template_16_24_32);
-		test_cipher_speed("cbc(camellia)", DECRYPT, sec, NULL, 0,
+		test_cipher_speed(test, "cbc(camellia)", DECRYPT, sec, NULL, 0,
 				speed_template_16_24_32);
-		test_cipher_speed("ctr(camellia)", ENCRYPT, sec, NULL, 0,
+		test_cipher_speed(test, "ctr(camellia)", ENCRYPT, sec, NULL, 0,
 				speed_template_16_24_32);
-		test_cipher_speed("ctr(camellia)", DECRYPT, sec, NULL, 0,
+		test_cipher_speed(test, "ctr(camellia)", DECRYPT, sec, NULL, 0,
 				speed_template_16_24_32);
-		test_cipher_speed("lrw(camellia)", ENCRYPT, sec, NULL, 0,
+		test_cipher_speed(test, "lrw(camellia)", ENCRYPT, sec, NULL, 0,
 				speed_template_32_40_48);
-		test_cipher_speed("lrw(camellia)", DECRYPT, sec, NULL, 0,
+		test_cipher_speed(test, "lrw(camellia)", DECRYPT, sec, NULL, 0,
 				speed_template_32_40_48);
-		test_cipher_speed("xts(camellia)", ENCRYPT, sec, NULL, 0,
+		test_cipher_speed(test, "xts(camellia)", ENCRYPT, sec, NULL, 0,
 				speed_template_32_48_64);
-		test_cipher_speed("xts(camellia)", DECRYPT, sec, NULL, 0,
+		test_cipher_speed(test, "xts(camellia)", DECRYPT, sec, NULL, 0,
 				speed_template_32_48_64);
 		break;
 
 	case 207:
-		test_cipher_speed("ecb(serpent)", ENCRYPT, sec, NULL, 0,
+		test_cipher_speed(test, "ecb(serpent)", ENCRYPT, sec, NULL, 0,
 				  speed_template_16_32);
-		test_cipher_speed("ecb(serpent)", DECRYPT, sec, NULL, 0,
+		test_cipher_speed(test, "ecb(serpent)", DECRYPT, sec, NULL, 0,
 				  speed_template_16_32);
-		test_cipher_speed("cbc(serpent)", ENCRYPT, sec, NULL, 0,
+		test_cipher_speed(test, "cbc(serpent)", ENCRYPT, sec, NULL, 0,
 				  speed_template_16_32);
-		test_cipher_speed("cbc(serpent)", DECRYPT, sec, NULL, 0,
+		test_cipher_speed(test, "cbc(serpent)", DECRYPT, sec, NULL, 0,
 				  speed_template_16_32);
-		test_cipher_speed("ctr(serpent)", ENCRYPT, sec, NULL, 0,
+		test_cipher_speed(test, "ctr(serpent)", ENCRYPT, sec, NULL, 0,
 				  speed_template_16_32);
-		test_cipher_speed("ctr(serpent)", DECRYPT, sec, NULL, 0,
+		test_cipher_speed(test, "ctr(serpent)", DECRYPT, sec, NULL, 0,
 				  speed_template_16_32);
-		test_cipher_speed("lrw(serpent)", ENCRYPT, sec, NULL, 0,
+		test_cipher_speed(test, "lrw(serpent)", ENCRYPT, sec, NULL, 0,
 				  speed_template_32_48);
-		test_cipher_speed("lrw(serpent)", DECRYPT, sec, NULL, 0,
+		test_cipher_speed(test, "lrw(serpent)", DECRYPT, sec, NULL, 0,
 				  speed_template_32_48);
-		test_cipher_speed("xts(serpent)", ENCRYPT, sec, NULL, 0,
+		test_cipher_speed(test, "xts(serpent)", ENCRYPT, sec, NULL, 0,
 				  speed_template_32_64);
-		test_cipher_speed("xts(serpent)", DECRYPT, sec, NULL, 0,
+		test_cipher_speed(test, "xts(serpent)", DECRYPT, sec, NULL, 0,
 				  speed_template_32_64);
 		break;
 
 	case 208:
-		test_cipher_speed("ecb(arc4)", ENCRYPT, sec, NULL, 0,
+		test_cipher_speed(test, "ecb(arc4)", ENCRYPT, sec, NULL, 0,
 				  speed_template_8);
 		break;
 
 	case 209:
-		test_cipher_speed("ecb(cast5)", ENCRYPT, sec, NULL, 0,
+		test_cipher_speed(test, "ecb(cast5)", ENCRYPT, sec, NULL, 0,
 				  speed_template_8_16);
-		test_cipher_speed("ecb(cast5)", DECRYPT, sec, NULL, 0,
+		test_cipher_speed(test, "ecb(cast5)", DECRYPT, sec, NULL, 0,
 				  speed_template_8_16);
-		test_cipher_speed("cbc(cast5)", ENCRYPT, sec, NULL, 0,
+		test_cipher_speed(test, "cbc(cast5)", ENCRYPT, sec, NULL, 0,
 				  speed_template_8_16);
-		test_cipher_speed("cbc(cast5)", DECRYPT, sec, NULL, 0,
+		test_cipher_speed(test, "cbc(cast5)", DECRYPT, sec, NULL, 0,
 				  speed_template_8_16);
-		test_cipher_speed("ctr(cast5)", ENCRYPT, sec, NULL, 0,
+		test_cipher_speed(test, "ctr(cast5)", ENCRYPT, sec, NULL, 0,
 				  speed_template_8_16);
-		test_cipher_speed("ctr(cast5)", DECRYPT, sec, NULL, 0,
+		test_cipher_speed(test, "ctr(cast5)", DECRYPT, sec, NULL, 0,
 				  speed_template_8_16);
 		break;
 
 	case 210:
-		test_cipher_speed("ecb(cast6)", ENCRYPT, sec, NULL, 0,
+		test_cipher_speed(test, "ecb(cast6)", ENCRYPT, sec, NULL, 0,
 				  speed_template_16_32);
-		test_cipher_speed("ecb(cast6)", DECRYPT, sec, NULL, 0,
+		test_cipher_speed(test, "ecb(cast6)", DECRYPT, sec, NULL, 0,
 				  speed_template_16_32);
-		test_cipher_speed("cbc(cast6)", ENCRYPT, sec, NULL, 0,
+		test_cipher_speed(test, "cbc(cast6)", ENCRYPT, sec, NULL, 0,
 				  speed_template_16_32);
-		test_cipher_speed("cbc(cast6)", DECRYPT, sec, NULL, 0,
+		test_cipher_speed(test, "cbc(cast6)", DECRYPT, sec, NULL, 0,
 				  speed_template_16_32);
-		test_cipher_speed("ctr(cast6)", ENCRYPT, sec, NULL, 0,
+		test_cipher_speed(test, "ctr(cast6)", ENCRYPT, sec, NULL, 0,
 				  speed_template_16_32);
-		test_cipher_speed("ctr(cast6)", DECRYPT, sec, NULL, 0,
+		test_cipher_speed(test, "ctr(cast6)", DECRYPT, sec, NULL, 0,
 				  speed_template_16_32);
-		test_cipher_speed("lrw(cast6)", ENCRYPT, sec, NULL, 0,
+		test_cipher_speed(test, "lrw(cast6)", ENCRYPT, sec, NULL, 0,
 				  speed_template_32_48);
-		test_cipher_speed("lrw(cast6)", DECRYPT, sec, NULL, 0,
+		test_cipher_speed(test, "lrw(cast6)", DECRYPT, sec, NULL, 0,
 				  speed_template_32_48);
-		test_cipher_speed("xts(cast6)", ENCRYPT, sec, NULL, 0,
+		test_cipher_speed(test, "xts(cast6)", ENCRYPT, sec, NULL, 0,
 				  speed_template_32_64);
-		test_cipher_speed("xts(cast6)", DECRYPT, sec, NULL, 0,
+		test_cipher_speed(test, "xts(cast6)", DECRYPT, sec, NULL, 0,
 				  speed_template_32_64);
 		break;
 
 	case 211:
-		test_aead_speed("rfc4106(gcm(aes))", ENCRYPT, sec,
+		test_aead_speed(test, "rfc4106(gcm(aes))", ENCRYPT, sec,
 				NULL, 0, 16, 16, aead_speed_template_20);
-		test_aead_speed("gcm(aes)", ENCRYPT, sec,
+		test_aead_speed(test, "gcm(aes)", ENCRYPT, sec,
 				NULL, 0, 16, 8, speed_template_16_24_32);
-		test_aead_speed("rfc4106(gcm(aes))", DECRYPT, sec,
+		test_aead_speed(test, "rfc4106(gcm(aes))", DECRYPT, sec,
 				NULL, 0, 16, 16, aead_speed_template_20);
-		test_aead_speed("gcm(aes)", DECRYPT, sec,
+		test_aead_speed(test, "gcm(aes)", DECRYPT, sec,
 				NULL, 0, 16, 8, speed_template_16_24_32);
 		break;
 
 	case 212:
-		test_aead_speed("rfc4309(ccm(aes))", ENCRYPT, sec,
+		test_aead_speed(test, "rfc4309(ccm(aes))", ENCRYPT, sec,
 				NULL, 0, 16, 16, aead_speed_template_19);
-		test_aead_speed("rfc4309(ccm(aes))", DECRYPT, sec,
+		test_aead_speed(test, "rfc4309(ccm(aes))", DECRYPT, sec,
 				NULL, 0, 16, 16, aead_speed_template_19);
 		break;
 
 	case 213:
-		test_aead_speed("rfc7539esp(chacha20,poly1305)", ENCRYPT, sec,
+		test_aead_speed(test, "rfc7539esp(chacha20,poly1305)", ENCRYPT, sec,
 				NULL, 0, 16, 8, aead_speed_template_36);
-		test_aead_speed("rfc7539esp(chacha20,poly1305)", DECRYPT, sec,
+		test_aead_speed(test, "rfc7539esp(chacha20,poly1305)", DECRYPT, sec,
 				NULL, 0, 16, 8, aead_speed_template_36);
 		break;
 
 	case 214:
-		test_cipher_speed("chacha20", ENCRYPT, sec, NULL, 0,
+		test_cipher_speed(test, "chacha20", ENCRYPT, sec, NULL, 0,
 				  speed_template_32);
 		break;
 
 	case 215:
-		test_mb_aead_speed("rfc4106(gcm(aes))", ENCRYPT, sec, NULL,
+		test_mb_aead_speed(test, "rfc4106(gcm(aes))", ENCRYPT, sec, NULL,
 				   0, 16, 16, aead_speed_template_20, num_mb);
-		test_mb_aead_speed("gcm(aes)", ENCRYPT, sec, NULL, 0, 16, 8,
+		test_mb_aead_speed(test, "gcm(aes)", ENCRYPT, sec, NULL, 0, 16, 8,
 				   speed_template_16_24_32, num_mb);
-		test_mb_aead_speed("rfc4106(gcm(aes))", DECRYPT, sec, NULL,
+		test_mb_aead_speed(test, "rfc4106(gcm(aes))", DECRYPT, sec, NULL,
 				   0, 16, 16, aead_speed_template_20, num_mb);
-		test_mb_aead_speed("gcm(aes)", DECRYPT, sec, NULL, 0, 16, 8,
+		test_mb_aead_speed(test, "gcm(aes)", DECRYPT, sec, NULL, 0, 16, 8,
 				   speed_template_16_24_32, num_mb);
 		break;
 
 	case 216:
-		test_mb_aead_speed("rfc4309(ccm(aes))", ENCRYPT, sec, NULL, 0,
+		test_mb_aead_speed(test, "rfc4309(ccm(aes))", ENCRYPT, sec, NULL, 0,
 				   16, 16, aead_speed_template_19, num_mb);
-		test_mb_aead_speed("rfc4309(ccm(aes))", DECRYPT, sec, NULL, 0,
+		test_mb_aead_speed(test, "rfc4309(ccm(aes))", DECRYPT, sec, NULL, 0,
 				   16, 16, aead_speed_template_19, num_mb);
 		break;
 
 	case 217:
-		test_mb_aead_speed("rfc7539esp(chacha20,poly1305)", ENCRYPT,
+		test_mb_aead_speed(test, "rfc7539esp(chacha20,poly1305)", ENCRYPT,
 				   sec, NULL, 0, 16, 8, aead_speed_template_36,
 				   num_mb);
-		test_mb_aead_speed("rfc7539esp(chacha20,poly1305)", DECRYPT,
+		test_mb_aead_speed(test, "rfc7539esp(chacha20,poly1305)", DECRYPT,
 				   sec, NULL, 0, 16, 8, aead_speed_template_36,
 				   num_mb);
 		break;
 
 	case 218:
-		test_cipher_speed("ecb(sm4)", ENCRYPT, sec, NULL, 0,
+		test_cipher_speed(test, "ecb(sm4)", ENCRYPT, sec, NULL, 0,
 				speed_template_16);
-		test_cipher_speed("ecb(sm4)", DECRYPT, sec, NULL, 0,
+		test_cipher_speed(test, "ecb(sm4)", DECRYPT, sec, NULL, 0,
 				speed_template_16);
-		test_cipher_speed("cbc(sm4)", ENCRYPT, sec, NULL, 0,
+		test_cipher_speed(test, "cbc(sm4)", ENCRYPT, sec, NULL, 0,
 				speed_template_16);
-		test_cipher_speed("cbc(sm4)", DECRYPT, sec, NULL, 0,
+		test_cipher_speed(test, "cbc(sm4)", DECRYPT, sec, NULL, 0,
 				speed_template_16);
-		test_cipher_speed("ctr(sm4)", ENCRYPT, sec, NULL, 0,
+		test_cipher_speed(test, "ctr(sm4)", ENCRYPT, sec, NULL, 0,
 				speed_template_16);
-		test_cipher_speed("ctr(sm4)", DECRYPT, sec, NULL, 0,
+		test_cipher_speed(test, "ctr(sm4)", DECRYPT, sec, NULL, 0,
 				speed_template_16);
 		break;
 
 	case 219:
-		test_cipher_speed("adiantum(xchacha12,aes)", ENCRYPT, sec, NULL,
+		test_cipher_speed(test, "adiantum(xchacha12,aes)", ENCRYPT, sec, NULL,
 				  0, speed_template_32);
-		test_cipher_speed("adiantum(xchacha12,aes)", DECRYPT, sec, NULL,
+		test_cipher_speed(test, "adiantum(xchacha12,aes)", DECRYPT, sec, NULL,
 				  0, speed_template_32);
-		test_cipher_speed("adiantum(xchacha20,aes)", ENCRYPT, sec, NULL,
+		test_cipher_speed(test, "adiantum(xchacha20,aes)", ENCRYPT, sec, NULL,
 				  0, speed_template_32);
-		test_cipher_speed("adiantum(xchacha20,aes)", DECRYPT, sec, NULL,
+		test_cipher_speed(test, "adiantum(xchacha20,aes)", DECRYPT, sec, NULL,
 				  0, speed_template_32);
 		break;
 
 	case 220:
-		test_acipher_speed("essiv(cbc(aes),sha256)",
+		test_acipher_speed(test, "essiv(cbc(aes),sha256)",
 				  ENCRYPT, sec, NULL, 0,
 				  speed_template_16_24_32);
-		test_acipher_speed("essiv(cbc(aes),sha256)",
+		test_acipher_speed(test, "essiv(cbc(aes),sha256)",
 				  DECRYPT, sec, NULL, 0,
 				  speed_template_16_24_32);
 		break;
 
 	case 221:
-		test_aead_speed("aegis128", ENCRYPT, sec,
+		test_aead_speed(test, "aegis128", ENCRYPT, sec,
 				NULL, 0, 16, 8, speed_template_16);
-		test_aead_speed("aegis128", DECRYPT, sec,
+		test_aead_speed(test, "aegis128", DECRYPT, sec,
 				NULL, 0, 16, 8, speed_template_16);
 		break;
 
 	case 300:
 		if (alg) {
-			test_hash_speed(alg, sec, generic_hash_speed_template);
+			test_hash_speed(test, alg, sec, generic_hash_speed_template);
 			break;
 		}
 		fallthrough;
 	case 301:
-		test_hash_speed("md4", sec, generic_hash_speed_template);
+		test_hash_speed(test, "md4", sec, generic_hash_speed_template);
 		if (mode > 300 && mode < 400) break;
 		fallthrough;
 	case 302:
-		test_hash_speed("md5", sec, generic_hash_speed_template);
+		test_hash_speed(test, "md5", sec, generic_hash_speed_template);
 		if (mode > 300 && mode < 400) break;
 		fallthrough;
 	case 303:
-		test_hash_speed("sha1", sec, generic_hash_speed_template);
+		test_hash_speed(test, "sha1", sec, generic_hash_speed_template);
 		if (mode > 300 && mode < 400) break;
 		fallthrough;
 	case 304:
-		test_hash_speed("sha256", sec, generic_hash_speed_template);
+		test_hash_speed(test, "sha256", sec, generic_hash_speed_template);
 		if (mode > 300 && mode < 400) break;
 		fallthrough;
 	case 305:
-		test_hash_speed("sha384", sec, generic_hash_speed_template);
+		test_hash_speed(test, "sha384", sec, generic_hash_speed_template);
 		if (mode > 300 && mode < 400) break;
 		fallthrough;
 	case 306:
-		test_hash_speed("sha512", sec, generic_hash_speed_template);
+		test_hash_speed(test, "sha512", sec, generic_hash_speed_template);
 		if (mode > 300 && mode < 400) break;
 		fallthrough;
 	case 307:
-		test_hash_speed("wp256", sec, generic_hash_speed_template);
+		test_hash_speed(test, "wp256", sec, generic_hash_speed_template);
 		if (mode > 300 && mode < 400) break;
 		fallthrough;
 	case 308:
-		test_hash_speed("wp384", sec, generic_hash_speed_template);
+		test_hash_speed(test, "wp384", sec, generic_hash_speed_template);
 		if (mode > 300 && mode < 400) break;
 		fallthrough;
 	case 309:
-		test_hash_speed("wp512", sec, generic_hash_speed_template);
+		test_hash_speed(test, "wp512", sec, generic_hash_speed_template);
 		if (mode > 300 && mode < 400) break;
 		fallthrough;
 	case 313:
-		test_hash_speed("sha224", sec, generic_hash_speed_template);
+		test_hash_speed(test, "sha224", sec, generic_hash_speed_template);
 		if (mode > 300 && mode < 400) break;
 		fallthrough;
 	case 314:
-		test_hash_speed("xxhash64", sec, generic_hash_speed_template);
+		test_hash_speed(test, "xxhash64", sec, generic_hash_speed_template);
 		if (mode > 300 && mode < 400) break;
 		fallthrough;
 	case 315:
-		test_hash_speed("rmd160", sec, generic_hash_speed_template);
+		test_hash_speed(test, "rmd160", sec, generic_hash_speed_template);
 		if (mode > 300 && mode < 400) break;
 		fallthrough;
 	case 316:
-		test_hash_speed("blake2s-256", sec, generic_hash_speed_template);
+		test_hash_speed(test, "blake2s-256", sec, generic_hash_speed_template);
 		if (mode > 300 && mode < 400) break;
 		fallthrough;
 	case 317:
-		test_hash_speed("blake2b-512", sec, generic_hash_speed_template);
+		test_hash_speed(test, "blake2b-512", sec, generic_hash_speed_template);
 		if (mode > 300 && mode < 400) break;
 		fallthrough;
 	case 318:
 		klen = 16;
-		test_hash_speed("ghash", sec, generic_hash_speed_template);
+		test_hash_speed(test, "ghash", sec, generic_hash_speed_template);
 		if (mode > 300 && mode < 400) break;
 		fallthrough;
 	case 319:
-		test_hash_speed("crc32c", sec, generic_hash_speed_template);
+		test_hash_speed(test, "crc32c", sec, generic_hash_speed_template);
 		if (mode > 300 && mode < 400) break;
 		fallthrough;
 	case 320:
-		test_hash_speed("crct10dif", sec, generic_hash_speed_template);
+		test_hash_speed(test, "crct10dif", sec, generic_hash_speed_template);
 		if (mode > 300 && mode < 400) break;
 		fallthrough;
 	case 321:
-		test_hash_speed("poly1305", sec, poly1305_speed_template);
+		test_hash_speed(test, "poly1305", sec, poly1305_speed_template);
 		if (mode > 300 && mode < 400) break;
 		fallthrough;
 	case 322:
-		test_hash_speed("sha3-224", sec, generic_hash_speed_template);
+		test_hash_speed(test, "sha3-224", sec, generic_hash_speed_template);
 		if (mode > 300 && mode < 400) break;
 		fallthrough;
 	case 323:
-		test_hash_speed("sha3-256", sec, generic_hash_speed_template);
+		test_hash_speed(test, "sha3-256", sec, generic_hash_speed_template);
 		if (mode > 300 && mode < 400) break;
 		fallthrough;
 	case 324:
-		test_hash_speed("sha3-384", sec, generic_hash_speed_template);
+		test_hash_speed(test, "sha3-384", sec, generic_hash_speed_template);
 		if (mode > 300 && mode < 400) break;
 		fallthrough;
 	case 325:
-		test_hash_speed("sha3-512", sec, generic_hash_speed_template);
+		test_hash_speed(test, "sha3-512", sec, generic_hash_speed_template);
 		if (mode > 300 && mode < 400) break;
 		fallthrough;
 	case 326:
-		test_hash_speed("sm3", sec, generic_hash_speed_template);
+		test_hash_speed(test, "sm3", sec, generic_hash_speed_template);
 		if (mode > 300 && mode < 400) break;
 		fallthrough;
 	case 327:
-		test_hash_speed("streebog256", sec,
+		test_hash_speed(test, "streebog256", sec,
 				generic_hash_speed_template);
 		if (mode > 300 && mode < 400) break;
 		fallthrough;
 	case 328:
-		test_hash_speed("streebog512", sec,
+		test_hash_speed(test, "streebog512", sec,
 				generic_hash_speed_template);
 		if (mode > 300 && mode < 400) break;
 		fallthrough;
@@ -2437,109 +2437,109 @@ static void do_test(struct kunit *test, const char *alg, u32 type, u32 mask,
 
 	case 400:
 		if (alg) {
-			test_ahash_speed(alg, sec, generic_hash_speed_template);
+			test_ahash_speed(test, alg, sec, generic_hash_speed_template);
 			break;
 		}
 		fallthrough;
 	case 401:
-		test_ahash_speed("md4", sec, generic_hash_speed_template);
+		test_ahash_speed(test, "md4", sec, generic_hash_speed_template);
 		if (mode > 400 && mode < 500) break;
 		fallthrough;
 	case 402:
-		test_ahash_speed("md5", sec, generic_hash_speed_template);
+		test_ahash_speed(test, "md5", sec, generic_hash_speed_template);
 		if (mode > 400 && mode < 500) break;
 		fallthrough;
 	case 403:
-		test_ahash_speed("sha1", sec, generic_hash_speed_template);
+		test_ahash_speed(test, "sha1", sec, generic_hash_speed_template);
 		if (mode > 400 && mode < 500) break;
 		fallthrough;
 	case 404:
-		test_ahash_speed("sha256", sec, generic_hash_speed_template);
+		test_ahash_speed(test, "sha256", sec, generic_hash_speed_template);
 		if (mode > 400 && mode < 500) break;
 		fallthrough;
 	case 405:
-		test_ahash_speed("sha384", sec, generic_hash_speed_template);
+		test_ahash_speed(test, "sha384", sec, generic_hash_speed_template);
 		if (mode > 400 && mode < 500) break;
 		fallthrough;
 	case 406:
-		test_ahash_speed("sha512", sec, generic_hash_speed_template);
+		test_ahash_speed(test, "sha512", sec, generic_hash_speed_template);
 		if (mode > 400 && mode < 500) break;
 		fallthrough;
 	case 407:
-		test_ahash_speed("wp256", sec, generic_hash_speed_template);
+		test_ahash_speed(test, "wp256", sec, generic_hash_speed_template);
 		if (mode > 400 && mode < 500) break;
 		fallthrough;
 	case 408:
-		test_ahash_speed("wp384", sec, generic_hash_speed_template);
+		test_ahash_speed(test, "wp384", sec, generic_hash_speed_template);
 		if (mode > 400 && mode < 500) break;
 		fallthrough;
 	case 409:
-		test_ahash_speed("wp512", sec, generic_hash_speed_template);
+		test_ahash_speed(test, "wp512", sec, generic_hash_speed_template);
 		if (mode > 400 && mode < 500) break;
 		fallthrough;
 	case 413:
-		test_ahash_speed("sha224", sec, generic_hash_speed_template);
+		test_ahash_speed(test, "sha224", sec, generic_hash_speed_template);
 		if (mode > 400 && mode < 500) break;
 		fallthrough;
 	case 414:
-		test_ahash_speed("xxhash64", sec, generic_hash_speed_template);
+		test_ahash_speed(test, "xxhash64", sec, generic_hash_speed_template);
 		if (mode > 400 && mode < 500) break;
 		fallthrough;
 	case 415:
-		test_ahash_speed("rmd160", sec, generic_hash_speed_template);
+		test_ahash_speed(test, "rmd160", sec, generic_hash_speed_template);
 		if (mode > 400 && mode < 500) break;
 		fallthrough;
 	case 416:
-		test_ahash_speed("blake2s-256", sec, generic_hash_speed_template);
+		test_ahash_speed(test, "blake2s-256", sec, generic_hash_speed_template);
 		if (mode > 400 && mode < 500) break;
 		fallthrough;
 	case 417:
-		test_ahash_speed("blake2b-512", sec, generic_hash_speed_template);
+		test_ahash_speed(test, "blake2b-512", sec, generic_hash_speed_template);
 		if (mode > 400 && mode < 500) break;
 		fallthrough;
 	case 418:
-		test_ahash_speed("sha3-224", sec, generic_hash_speed_template);
+		test_ahash_speed(test, "sha3-224", sec, generic_hash_speed_template);
 		if (mode > 400 && mode < 500) break;
 		fallthrough;
 	case 419:
-		test_ahash_speed("sha3-256", sec, generic_hash_speed_template);
+		test_ahash_speed(test, "sha3-256", sec, generic_hash_speed_template);
 		if (mode > 400 && mode < 500) break;
 		fallthrough;
 	case 420:
-		test_ahash_speed("sha3-384", sec, generic_hash_speed_template);
+		test_ahash_speed(test, "sha3-384", sec, generic_hash_speed_template);
 		if (mode > 400 && mode < 500) break;
 		fallthrough;
 	case 421:
-		test_ahash_speed("sha3-512", sec, generic_hash_speed_template);
+		test_ahash_speed(test, "sha3-512", sec, generic_hash_speed_template);
 		if (mode > 400 && mode < 500) break;
 		fallthrough;
 	case 422:
-		test_mb_ahash_speed("sha1", sec, generic_hash_speed_template,
+		test_mb_ahash_speed(test, "sha1", sec, generic_hash_speed_template,
 				    num_mb);
 		if (mode > 400 && mode < 500) break;
 		fallthrough;
 	case 423:
-		test_mb_ahash_speed("sha256", sec, generic_hash_speed_template,
+		test_mb_ahash_speed(test, "sha256", sec, generic_hash_speed_template,
 				    num_mb);
 		if (mode > 400 && mode < 500) break;
 		fallthrough;
 	case 424:
-		test_mb_ahash_speed("sha512", sec, generic_hash_speed_template,
+		test_mb_ahash_speed(test, "sha512", sec, generic_hash_speed_template,
 				    num_mb);
 		if (mode > 400 && mode < 500) break;
 		fallthrough;
 	case 425:
-		test_mb_ahash_speed("sm3", sec, generic_hash_speed_template,
+		test_mb_ahash_speed(test, "sm3", sec, generic_hash_speed_template,
 				    num_mb);
 		if (mode > 400 && mode < 500) break;
 		fallthrough;
 	case 426:
-		test_mb_ahash_speed("streebog256", sec,
+		test_mb_ahash_speed(test, "streebog256", sec,
 				    generic_hash_speed_template, num_mb);
 		if (mode > 400 && mode < 500) break;
 		fallthrough;
 	case 427:
-		test_mb_ahash_speed("streebog512", sec,
+		test_mb_ahash_speed(test, "streebog512", sec,
 				    generic_hash_speed_template, num_mb);
 		if (mode > 400 && mode < 500) break;
 		fallthrough;
@@ -2547,426 +2547,426 @@ static void do_test(struct kunit *test, const char *alg, u32 type, u32 mask,
 		break;
 
 	case 500:
-		test_acipher_speed("ecb(aes)", ENCRYPT, sec, NULL, 0,
+		test_acipher_speed(test, "ecb(aes)", ENCRYPT, sec, NULL, 0,
 				   speed_template_16_24_32);
-		test_acipher_speed("ecb(aes)", DECRYPT, sec, NULL, 0,
+		test_acipher_speed(test, "ecb(aes)", DECRYPT, sec, NULL, 0,
 				   speed_template_16_24_32);
-		test_acipher_speed("cbc(aes)", ENCRYPT, sec, NULL, 0,
+		test_acipher_speed(test, "cbc(aes)", ENCRYPT, sec, NULL, 0,
 				   speed_template_16_24_32);
-		test_acipher_speed("cbc(aes)", DECRYPT, sec, NULL, 0,
+		test_acipher_speed(test, "cbc(aes)", DECRYPT, sec, NULL, 0,
 				   speed_template_16_24_32);
-		test_acipher_speed("lrw(aes)", ENCRYPT, sec, NULL, 0,
+		test_acipher_speed(test, "lrw(aes)", ENCRYPT, sec, NULL, 0,
 				   speed_template_32_40_48);
-		test_acipher_speed("lrw(aes)", DECRYPT, sec, NULL, 0,
+		test_acipher_speed(test, "lrw(aes)", DECRYPT, sec, NULL, 0,
 				   speed_template_32_40_48);
-		test_acipher_speed("xts(aes)", ENCRYPT, sec, NULL, 0,
+		test_acipher_speed(test, "xts(aes)", ENCRYPT, sec, NULL, 0,
 				   speed_template_32_64);
-		test_acipher_speed("xts(aes)", DECRYPT, sec, NULL, 0,
+		test_acipher_speed(test, "xts(aes)", DECRYPT, sec, NULL, 0,
 				   speed_template_32_64);
-		test_acipher_speed("cts(cbc(aes))", ENCRYPT, sec, NULL, 0,
+		test_acipher_speed(test, "cts(cbc(aes))", ENCRYPT, sec, NULL, 0,
 				   speed_template_16_24_32);
-		test_acipher_speed("cts(cbc(aes))", DECRYPT, sec, NULL, 0,
+		test_acipher_speed(test, "cts(cbc(aes))", DECRYPT, sec, NULL, 0,
 				   speed_template_16_24_32);
-		test_acipher_speed("ctr(aes)", ENCRYPT, sec, NULL, 0,
+		test_acipher_speed(test, "ctr(aes)", ENCRYPT, sec, NULL, 0,
 				   speed_template_16_24_32);
-		test_acipher_speed("ctr(aes)", DECRYPT, sec, NULL, 0,
+		test_acipher_speed(test, "ctr(aes)", DECRYPT, sec, NULL, 0,
 				   speed_template_16_24_32);
-		test_acipher_speed("cfb(aes)", ENCRYPT, sec, NULL, 0,
+		test_acipher_speed(test, "cfb(aes)", ENCRYPT, sec, NULL, 0,
 				   speed_template_16_24_32);
-		test_acipher_speed("cfb(aes)", DECRYPT, sec, NULL, 0,
+		test_acipher_speed(test, "cfb(aes)", DECRYPT, sec, NULL, 0,
 				   speed_template_16_24_32);
-		test_acipher_speed("ofb(aes)", ENCRYPT, sec, NULL, 0,
+		test_acipher_speed(test, "ofb(aes)", ENCRYPT, sec, NULL, 0,
 				   speed_template_16_24_32);
-		test_acipher_speed("ofb(aes)", DECRYPT, sec, NULL, 0,
+		test_acipher_speed(test, "ofb(aes)", DECRYPT, sec, NULL, 0,
 				   speed_template_16_24_32);
-		test_acipher_speed("rfc3686(ctr(aes))", ENCRYPT, sec, NULL, 0,
+		test_acipher_speed(test, "rfc3686(ctr(aes))", ENCRYPT, sec, NULL, 0,
 				   speed_template_20_28_36);
-		test_acipher_speed("rfc3686(ctr(aes))", DECRYPT, sec, NULL, 0,
+		test_acipher_speed(test, "rfc3686(ctr(aes))", DECRYPT, sec, NULL, 0,
 				   speed_template_20_28_36);
 		break;
 
 	case 501:
-		test_acipher_speed("ecb(des3_ede)", ENCRYPT, sec,
+		test_acipher_speed(test, "ecb(des3_ede)", ENCRYPT, sec,
 				   des3_speed_template, DES3_SPEED_VECTORS,
 				   speed_template_24);
-		test_acipher_speed("ecb(des3_ede)", DECRYPT, sec,
+		test_acipher_speed(test, "ecb(des3_ede)", DECRYPT, sec,
 				   des3_speed_template, DES3_SPEED_VECTORS,
 				   speed_template_24);
-		test_acipher_speed("cbc(des3_ede)", ENCRYPT, sec,
+		test_acipher_speed(test, "cbc(des3_ede)", ENCRYPT, sec,
 				   des3_speed_template, DES3_SPEED_VECTORS,
 				   speed_template_24);
-		test_acipher_speed("cbc(des3_ede)", DECRYPT, sec,
+		test_acipher_speed(test, "cbc(des3_ede)", DECRYPT, sec,
 				   des3_speed_template, DES3_SPEED_VECTORS,
 				   speed_template_24);
-		test_acipher_speed("cfb(des3_ede)", ENCRYPT, sec,
+		test_acipher_speed(test, "cfb(des3_ede)", ENCRYPT, sec,
 				   des3_speed_template, DES3_SPEED_VECTORS,
 				   speed_template_24);
-		test_acipher_speed("cfb(des3_ede)", DECRYPT, sec,
+		test_acipher_speed(test, "cfb(des3_ede)", DECRYPT, sec,
 				   des3_speed_template, DES3_SPEED_VECTORS,
 				   speed_template_24);
-		test_acipher_speed("ofb(des3_ede)", ENCRYPT, sec,
+		test_acipher_speed(test, "ofb(des3_ede)", ENCRYPT, sec,
 				   des3_speed_template, DES3_SPEED_VECTORS,
 				   speed_template_24);
-		test_acipher_speed("ofb(des3_ede)", DECRYPT, sec,
+		test_acipher_speed(test, "ofb(des3_ede)", DECRYPT, sec,
 				   des3_speed_template, DES3_SPEED_VECTORS,
 				   speed_template_24);
 		break;
 
 	case 502:
-		test_acipher_speed("ecb(des)", ENCRYPT, sec, NULL, 0,
+		test_acipher_speed(test, "ecb(des)", ENCRYPT, sec, NULL, 0,
 				   speed_template_8);
-		test_acipher_speed("ecb(des)", DECRYPT, sec, NULL, 0,
+		test_acipher_speed(test, "ecb(des)", DECRYPT, sec, NULL, 0,
 				   speed_template_8);
-		test_acipher_speed("cbc(des)", ENCRYPT, sec, NULL, 0,
+		test_acipher_speed(test, "cbc(des)", ENCRYPT, sec, NULL, 0,
 				   speed_template_8);
-		test_acipher_speed("cbc(des)", DECRYPT, sec, NULL, 0,
+		test_acipher_speed(test, "cbc(des)", DECRYPT, sec, NULL, 0,
 				   speed_template_8);
-		test_acipher_speed("cfb(des)", ENCRYPT, sec, NULL, 0,
+		test_acipher_speed(test, "cfb(des)", ENCRYPT, sec, NULL, 0,
 				   speed_template_8);
-		test_acipher_speed("cfb(des)", DECRYPT, sec, NULL, 0,
+		test_acipher_speed(test, "cfb(des)", DECRYPT, sec, NULL, 0,
 				   speed_template_8);
-		test_acipher_speed("ofb(des)", ENCRYPT, sec, NULL, 0,
+		test_acipher_speed(test, "ofb(des)", ENCRYPT, sec, NULL, 0,
 				   speed_template_8);
-		test_acipher_speed("ofb(des)", DECRYPT, sec, NULL, 0,
+		test_acipher_speed(test, "ofb(des)", DECRYPT, sec, NULL, 0,
 				   speed_template_8);
 		break;
 
 	case 503:
-		test_acipher_speed("ecb(serpent)", ENCRYPT, sec, NULL, 0,
+		test_acipher_speed(test, "ecb(serpent)", ENCRYPT, sec, NULL, 0,
 				   speed_template_16_32);
-		test_acipher_speed("ecb(serpent)", DECRYPT, sec, NULL, 0,
+		test_acipher_speed(test, "ecb(serpent)", DECRYPT, sec, NULL, 0,
 				   speed_template_16_32);
-		test_acipher_speed("cbc(serpent)", ENCRYPT, sec, NULL, 0,
+		test_acipher_speed(test, "cbc(serpent)", ENCRYPT, sec, NULL, 0,
 				   speed_template_16_32);
-		test_acipher_speed("cbc(serpent)", DECRYPT, sec, NULL, 0,
+		test_acipher_speed(test, "cbc(serpent)", DECRYPT, sec, NULL, 0,
 				   speed_template_16_32);
-		test_acipher_speed("ctr(serpent)", ENCRYPT, sec, NULL, 0,
+		test_acipher_speed(test, "ctr(serpent)", ENCRYPT, sec, NULL, 0,
 				   speed_template_16_32);
-		test_acipher_speed("ctr(serpent)", DECRYPT, sec, NULL, 0,
+		test_acipher_speed(test, "ctr(serpent)", DECRYPT, sec, NULL, 0,
 				   speed_template_16_32);
-		test_acipher_speed("lrw(serpent)", ENCRYPT, sec, NULL, 0,
+		test_acipher_speed(test, "lrw(serpent)", ENCRYPT, sec, NULL, 0,
 				   speed_template_32_48);
-		test_acipher_speed("lrw(serpent)", DECRYPT, sec, NULL, 0,
+		test_acipher_speed(test, "lrw(serpent)", DECRYPT, sec, NULL, 0,
 				   speed_template_32_48);
-		test_acipher_speed("xts(serpent)", ENCRYPT, sec, NULL, 0,
+		test_acipher_speed(test, "xts(serpent)", ENCRYPT, sec, NULL, 0,
 				   speed_template_32_64);
-		test_acipher_speed("xts(serpent)", DECRYPT, sec, NULL, 0,
+		test_acipher_speed(test, "xts(serpent)", DECRYPT, sec, NULL, 0,
 				   speed_template_32_64);
 		break;
 
 	case 504:
-		test_acipher_speed("ecb(twofish)", ENCRYPT, sec, NULL, 0,
+		test_acipher_speed(test, "ecb(twofish)", ENCRYPT, sec, NULL, 0,
 				   speed_template_16_24_32);
-		test_acipher_speed("ecb(twofish)", DECRYPT, sec, NULL, 0,
+		test_acipher_speed(test, "ecb(twofish)", DECRYPT, sec, NULL, 0,
 				   speed_template_16_24_32);
-		test_acipher_speed("cbc(twofish)", ENCRYPT, sec, NULL, 0,
+		test_acipher_speed(test, "cbc(twofish)", ENCRYPT, sec, NULL, 0,
 				   speed_template_16_24_32);
-		test_acipher_speed("cbc(twofish)", DECRYPT, sec, NULL, 0,
+		test_acipher_speed(test, "cbc(twofish)", DECRYPT, sec, NULL, 0,
 				   speed_template_16_24_32);
-		test_acipher_speed("ctr(twofish)", ENCRYPT, sec, NULL, 0,
+		test_acipher_speed(test, "ctr(twofish)", ENCRYPT, sec, NULL, 0,
 				   speed_template_16_24_32);
-		test_acipher_speed("ctr(twofish)", DECRYPT, sec, NULL, 0,
+		test_acipher_speed(test, "ctr(twofish)", DECRYPT, sec, NULL, 0,
 				   speed_template_16_24_32);
-		test_acipher_speed("lrw(twofish)", ENCRYPT, sec, NULL, 0,
+		test_acipher_speed(test, "lrw(twofish)", ENCRYPT, sec, NULL, 0,
 				   speed_template_32_40_48);
-		test_acipher_speed("lrw(twofish)", DECRYPT, sec, NULL, 0,
+		test_acipher_speed(test, "lrw(twofish)", DECRYPT, sec, NULL, 0,
 				   speed_template_32_40_48);
-		test_acipher_speed("xts(twofish)", ENCRYPT, sec, NULL, 0,
+		test_acipher_speed(test, "xts(twofish)", ENCRYPT, sec, NULL, 0,
 				   speed_template_32_48_64);
-		test_acipher_speed("xts(twofish)", DECRYPT, sec, NULL, 0,
+		test_acipher_speed(test, "xts(twofish)", DECRYPT, sec, NULL, 0,
 				   speed_template_32_48_64);
 		break;
 
 	case 505:
-		test_acipher_speed("ecb(arc4)", ENCRYPT, sec, NULL, 0,
+		test_acipher_speed(test, "ecb(arc4)", ENCRYPT, sec, NULL, 0,
 				   speed_template_8);
 		break;
 
 	case 506:
-		test_acipher_speed("ecb(cast5)", ENCRYPT, sec, NULL, 0,
+		test_acipher_speed(test, "ecb(cast5)", ENCRYPT, sec, NULL, 0,
 				   speed_template_8_16);
-		test_acipher_speed("ecb(cast5)", DECRYPT, sec, NULL, 0,
+		test_acipher_speed(test, "ecb(cast5)", DECRYPT, sec, NULL, 0,
 				   speed_template_8_16);
-		test_acipher_speed("cbc(cast5)", ENCRYPT, sec, NULL, 0,
+		test_acipher_speed(test, "cbc(cast5)", ENCRYPT, sec, NULL, 0,
 				   speed_template_8_16);
-		test_acipher_speed("cbc(cast5)", DECRYPT, sec, NULL, 0,
+		test_acipher_speed(test, "cbc(cast5)", DECRYPT, sec, NULL, 0,
 				   speed_template_8_16);
-		test_acipher_speed("ctr(cast5)", ENCRYPT, sec, NULL, 0,
+		test_acipher_speed(test, "ctr(cast5)", ENCRYPT, sec, NULL, 0,
 				   speed_template_8_16);
-		test_acipher_speed("ctr(cast5)", DECRYPT, sec, NULL, 0,
+		test_acipher_speed(test, "ctr(cast5)", DECRYPT, sec, NULL, 0,
 				   speed_template_8_16);
 		break;
 
 	case 507:
-		test_acipher_speed("ecb(cast6)", ENCRYPT, sec, NULL, 0,
+		test_acipher_speed(test, "ecb(cast6)", ENCRYPT, sec, NULL, 0,
 				   speed_template_16_32);
-		test_acipher_speed("ecb(cast6)", DECRYPT, sec, NULL, 0,
+		test_acipher_speed(test, "ecb(cast6)", DECRYPT, sec, NULL, 0,
 				   speed_template_16_32);
-		test_acipher_speed("cbc(cast6)", ENCRYPT, sec, NULL, 0,
+		test_acipher_speed(test, "cbc(cast6)", ENCRYPT, sec, NULL, 0,
 				   speed_template_16_32);
-		test_acipher_speed("cbc(cast6)", DECRYPT, sec, NULL, 0,
+		test_acipher_speed(test, "cbc(cast6)", DECRYPT, sec, NULL, 0,
 				   speed_template_16_32);
-		test_acipher_speed("ctr(cast6)", ENCRYPT, sec, NULL, 0,
+		test_acipher_speed(test, "ctr(cast6)", ENCRYPT, sec, NULL, 0,
 				   speed_template_16_32);
-		test_acipher_speed("ctr(cast6)", DECRYPT, sec, NULL, 0,
+		test_acipher_speed(test, "ctr(cast6)", DECRYPT, sec, NULL, 0,
 				   speed_template_16_32);
-		test_acipher_speed("lrw(cast6)", ENCRYPT, sec, NULL, 0,
+		test_acipher_speed(test, "lrw(cast6)", ENCRYPT, sec, NULL, 0,
 				   speed_template_32_48);
-		test_acipher_speed("lrw(cast6)", DECRYPT, sec, NULL, 0,
+		test_acipher_speed(test, "lrw(cast6)", DECRYPT, sec, NULL, 0,
 				   speed_template_32_48);
-		test_acipher_speed("xts(cast6)", ENCRYPT, sec, NULL, 0,
+		test_acipher_speed(test, "xts(cast6)", ENCRYPT, sec, NULL, 0,
 				   speed_template_32_64);
-		test_acipher_speed("xts(cast6)", DECRYPT, sec, NULL, 0,
+		test_acipher_speed(test, "xts(cast6)", DECRYPT, sec, NULL, 0,
 				   speed_template_32_64);
 		break;
 
 	case 508:
-		test_acipher_speed("ecb(camellia)", ENCRYPT, sec, NULL, 0,
+		test_acipher_speed(test, "ecb(camellia)", ENCRYPT, sec, NULL, 0,
 				   speed_template_16_32);
-		test_acipher_speed("ecb(camellia)", DECRYPT, sec, NULL, 0,
+		test_acipher_speed(test, "ecb(camellia)", DECRYPT, sec, NULL, 0,
 				   speed_template_16_32);
-		test_acipher_speed("cbc(camellia)", ENCRYPT, sec, NULL, 0,
+		test_acipher_speed(test, "cbc(camellia)", ENCRYPT, sec, NULL, 0,
 				   speed_template_16_32);
-		test_acipher_speed("cbc(camellia)", DECRYPT, sec, NULL, 0,
+		test_acipher_speed(test, "cbc(camellia)", DECRYPT, sec, NULL, 0,
 				   speed_template_16_32);
-		test_acipher_speed("ctr(camellia)", ENCRYPT, sec, NULL, 0,
+		test_acipher_speed(test, "ctr(camellia)", ENCRYPT, sec, NULL, 0,
 				   speed_template_16_32);
-		test_acipher_speed("ctr(camellia)", DECRYPT, sec, NULL, 0,
+		test_acipher_speed(test, "ctr(camellia)", DECRYPT, sec, NULL, 0,
 				   speed_template_16_32);
-		test_acipher_speed("lrw(camellia)", ENCRYPT, sec, NULL, 0,
+		test_acipher_speed(test, "lrw(camellia)", ENCRYPT, sec, NULL, 0,
 				   speed_template_32_48);
-		test_acipher_speed("lrw(camellia)", DECRYPT, sec, NULL, 0,
+		test_acipher_speed(test, "lrw(camellia)", DECRYPT, sec, NULL, 0,
 				   speed_template_32_48);
-		test_acipher_speed("xts(camellia)", ENCRYPT, sec, NULL, 0,
+		test_acipher_speed(test, "xts(camellia)", ENCRYPT, sec, NULL, 0,
 				   speed_template_32_64);
-		test_acipher_speed("xts(camellia)", DECRYPT, sec, NULL, 0,
+		test_acipher_speed(test, "xts(camellia)", DECRYPT, sec, NULL, 0,
 				   speed_template_32_64);
 		break;
 
 	case 509:
-		test_acipher_speed("ecb(blowfish)", ENCRYPT, sec, NULL, 0,
+		test_acipher_speed(test, "ecb(blowfish)", ENCRYPT, sec, NULL, 0,
 				   speed_template_8_32);
-		test_acipher_speed("ecb(blowfish)", DECRYPT, sec, NULL, 0,
+		test_acipher_speed(test, "ecb(blowfish)", DECRYPT, sec, NULL, 0,
 				   speed_template_8_32);
-		test_acipher_speed("cbc(blowfish)", ENCRYPT, sec, NULL, 0,
+		test_acipher_speed(test, "cbc(blowfish)", ENCRYPT, sec, NULL, 0,
 				   speed_template_8_32);
-		test_acipher_speed("cbc(blowfish)", DECRYPT, sec, NULL, 0,
+		test_acipher_speed(test, "cbc(blowfish)", DECRYPT, sec, NULL, 0,
 				   speed_template_8_32);
-		test_acipher_speed("ctr(blowfish)", ENCRYPT, sec, NULL, 0,
+		test_acipher_speed(test, "ctr(blowfish)", ENCRYPT, sec, NULL, 0,
 				   speed_template_8_32);
-		test_acipher_speed("ctr(blowfish)", DECRYPT, sec, NULL, 0,
+		test_acipher_speed(test, "ctr(blowfish)", DECRYPT, sec, NULL, 0,
 				   speed_template_8_32);
 		break;
 
 	case 600:
-		test_mb_skcipher_speed("ecb(aes)", ENCRYPT, sec, NULL, 0,
+		test_mb_skcipher_speed(test, "ecb(aes)", ENCRYPT, sec, NULL, 0,
 				       speed_template_16_24_32, num_mb);
-		test_mb_skcipher_speed("ecb(aes)", DECRYPT, sec, NULL, 0,
+		test_mb_skcipher_speed(test, "ecb(aes)", DECRYPT, sec, NULL, 0,
 				       speed_template_16_24_32, num_mb);
-		test_mb_skcipher_speed("cbc(aes)", ENCRYPT, sec, NULL, 0,
+		test_mb_skcipher_speed(test, "cbc(aes)", ENCRYPT, sec, NULL, 0,
 				       speed_template_16_24_32, num_mb);
-		test_mb_skcipher_speed("cbc(aes)", DECRYPT, sec, NULL, 0,
+		test_mb_skcipher_speed(test, "cbc(aes)", DECRYPT, sec, NULL, 0,
 				       speed_template_16_24_32, num_mb);
-		test_mb_skcipher_speed("lrw(aes)", ENCRYPT, sec, NULL, 0,
+		test_mb_skcipher_speed(test, "lrw(aes)", ENCRYPT, sec, NULL, 0,
 				       speed_template_32_40_48, num_mb);
-		test_mb_skcipher_speed("lrw(aes)", DECRYPT, sec, NULL, 0,
+		test_mb_skcipher_speed(test, "lrw(aes)", DECRYPT, sec, NULL, 0,
 				       speed_template_32_40_48, num_mb);
-		test_mb_skcipher_speed("xts(aes)", ENCRYPT, sec, NULL, 0,
+		test_mb_skcipher_speed(test, "xts(aes)", ENCRYPT, sec, NULL, 0,
 				       speed_template_32_64, num_mb);
-		test_mb_skcipher_speed("xts(aes)", DECRYPT, sec, NULL, 0,
+		test_mb_skcipher_speed(test, "xts(aes)", DECRYPT, sec, NULL, 0,
 				       speed_template_32_64, num_mb);
-		test_mb_skcipher_speed("cts(cbc(aes))", ENCRYPT, sec, NULL, 0,
+		test_mb_skcipher_speed(test, "cts(cbc(aes))", ENCRYPT, sec, NULL, 0,
 				       speed_template_16_24_32, num_mb);
-		test_mb_skcipher_speed("cts(cbc(aes))", DECRYPT, sec, NULL, 0,
+		test_mb_skcipher_speed(test, "cts(cbc(aes))", DECRYPT, sec, NULL, 0,
 				       speed_template_16_24_32, num_mb);
-		test_mb_skcipher_speed("ctr(aes)", ENCRYPT, sec, NULL, 0,
+		test_mb_skcipher_speed(test, "ctr(aes)", ENCRYPT, sec, NULL, 0,
 				       speed_template_16_24_32, num_mb);
-		test_mb_skcipher_speed("ctr(aes)", DECRYPT, sec, NULL, 0,
+		test_mb_skcipher_speed(test, "ctr(aes)", DECRYPT, sec, NULL, 0,
 				       speed_template_16_24_32, num_mb);
-		test_mb_skcipher_speed("cfb(aes)", ENCRYPT, sec, NULL, 0,
+		test_mb_skcipher_speed(test, "cfb(aes)", ENCRYPT, sec, NULL, 0,
 				       speed_template_16_24_32, num_mb);
-		test_mb_skcipher_speed("cfb(aes)", DECRYPT, sec, NULL, 0,
+		test_mb_skcipher_speed(test, "cfb(aes)", DECRYPT, sec, NULL, 0,
 				       speed_template_16_24_32, num_mb);
-		test_mb_skcipher_speed("ofb(aes)", ENCRYPT, sec, NULL, 0,
+		test_mb_skcipher_speed(test, "ofb(aes)", ENCRYPT, sec, NULL, 0,
 				       speed_template_16_24_32, num_mb);
-		test_mb_skcipher_speed("ofb(aes)", DECRYPT, sec, NULL, 0,
+		test_mb_skcipher_speed(test, "ofb(aes)", DECRYPT, sec, NULL, 0,
 				       speed_template_16_24_32, num_mb);
-		test_mb_skcipher_speed("rfc3686(ctr(aes))", ENCRYPT, sec, NULL,
+		test_mb_skcipher_speed(test, "rfc3686(ctr(aes))", ENCRYPT, sec, NULL,
 				       0, speed_template_20_28_36, num_mb);
-		test_mb_skcipher_speed("rfc3686(ctr(aes))", DECRYPT, sec, NULL,
+		test_mb_skcipher_speed(test, "rfc3686(ctr(aes))", DECRYPT, sec, NULL,
 				       0, speed_template_20_28_36, num_mb);
 		break;
 
 	case 601:
-		test_mb_skcipher_speed("ecb(des3_ede)", ENCRYPT, sec,
+		test_mb_skcipher_speed(test, "ecb(des3_ede)", ENCRYPT, sec,
 				       des3_speed_template, DES3_SPEED_VECTORS,
 				       speed_template_24, num_mb);
-		test_mb_skcipher_speed("ecb(des3_ede)", DECRYPT, sec,
+		test_mb_skcipher_speed(test, "ecb(des3_ede)", DECRYPT, sec,
 				       des3_speed_template, DES3_SPEED_VECTORS,
 				       speed_template_24, num_mb);
-		test_mb_skcipher_speed("cbc(des3_ede)", ENCRYPT, sec,
+		test_mb_skcipher_speed(test, "cbc(des3_ede)", ENCRYPT, sec,
 				       des3_speed_template, DES3_SPEED_VECTORS,
 				       speed_template_24, num_mb);
-		test_mb_skcipher_speed("cbc(des3_ede)", DECRYPT, sec,
+		test_mb_skcipher_speed(test, "cbc(des3_ede)", DECRYPT, sec,
 				       des3_speed_template, DES3_SPEED_VECTORS,
 				       speed_template_24, num_mb);
-		test_mb_skcipher_speed("cfb(des3_ede)", ENCRYPT, sec,
+		test_mb_skcipher_speed(test, "cfb(des3_ede)", ENCRYPT, sec,
 				       des3_speed_template, DES3_SPEED_VECTORS,
 				       speed_template_24, num_mb);
-		test_mb_skcipher_speed("cfb(des3_ede)", DECRYPT, sec,
+		test_mb_skcipher_speed(test, "cfb(des3_ede)", DECRYPT, sec,
 				       des3_speed_template, DES3_SPEED_VECTORS,
 				       speed_template_24, num_mb);
-		test_mb_skcipher_speed("ofb(des3_ede)", ENCRYPT, sec,
+		test_mb_skcipher_speed(test, "ofb(des3_ede)", ENCRYPT, sec,
 				       des3_speed_template, DES3_SPEED_VECTORS,
 				       speed_template_24, num_mb);
-		test_mb_skcipher_speed("ofb(des3_ede)", DECRYPT, sec,
+		test_mb_skcipher_speed(test, "ofb(des3_ede)", DECRYPT, sec,
 				       des3_speed_template, DES3_SPEED_VECTORS,
 				       speed_template_24, num_mb);
 		break;
 
 	case 602:
-		test_mb_skcipher_speed("ecb(des)", ENCRYPT, sec, NULL, 0,
+		test_mb_skcipher_speed(test, "ecb(des)", ENCRYPT, sec, NULL, 0,
 				       speed_template_8, num_mb);
-		test_mb_skcipher_speed("ecb(des)", DECRYPT, sec, NULL, 0,
+		test_mb_skcipher_speed(test, "ecb(des)", DECRYPT, sec, NULL, 0,
 				       speed_template_8, num_mb);
-		test_mb_skcipher_speed("cbc(des)", ENCRYPT, sec, NULL, 0,
+		test_mb_skcipher_speed(test, "cbc(des)", ENCRYPT, sec, NULL, 0,
 				       speed_template_8, num_mb);
-		test_mb_skcipher_speed("cbc(des)", DECRYPT, sec, NULL, 0,
+		test_mb_skcipher_speed(test, "cbc(des)", DECRYPT, sec, NULL, 0,
 				       speed_template_8, num_mb);
-		test_mb_skcipher_speed("cfb(des)", ENCRYPT, sec, NULL, 0,
+		test_mb_skcipher_speed(test, "cfb(des)", ENCRYPT, sec, NULL, 0,
 				       speed_template_8, num_mb);
-		test_mb_skcipher_speed("cfb(des)", DECRYPT, sec, NULL, 0,
+		test_mb_skcipher_speed(test, "cfb(des)", DECRYPT, sec, NULL, 0,
 				       speed_template_8, num_mb);
-		test_mb_skcipher_speed("ofb(des)", ENCRYPT, sec, NULL, 0,
+		test_mb_skcipher_speed(test, "ofb(des)", ENCRYPT, sec, NULL, 0,
 				       speed_template_8, num_mb);
-		test_mb_skcipher_speed("ofb(des)", DECRYPT, sec, NULL, 0,
+		test_mb_skcipher_speed(test, "ofb(des)", DECRYPT, sec, NULL, 0,
 				       speed_template_8, num_mb);
 		break;
 
 	case 603:
-		test_mb_skcipher_speed("ecb(serpent)", ENCRYPT, sec, NULL, 0,
+		test_mb_skcipher_speed(test, "ecb(serpent)", ENCRYPT, sec, NULL, 0,
 				       speed_template_16_32, num_mb);
-		test_mb_skcipher_speed("ecb(serpent)", DECRYPT, sec, NULL, 0,
+		test_mb_skcipher_speed(test, "ecb(serpent)", DECRYPT, sec, NULL, 0,
 				       speed_template_16_32, num_mb);
-		test_mb_skcipher_speed("cbc(serpent)", ENCRYPT, sec, NULL, 0,
+		test_mb_skcipher_speed(test, "cbc(serpent)", ENCRYPT, sec, NULL, 0,
 				       speed_template_16_32, num_mb);
-		test_mb_skcipher_speed("cbc(serpent)", DECRYPT, sec, NULL, 0,
+		test_mb_skcipher_speed(test, "cbc(serpent)", DECRYPT, sec, NULL, 0,
 				       speed_template_16_32, num_mb);
-		test_mb_skcipher_speed("ctr(serpent)", ENCRYPT, sec, NULL, 0,
+		test_mb_skcipher_speed(test, "ctr(serpent)", ENCRYPT, sec, NULL, 0,
 				       speed_template_16_32, num_mb);
-		test_mb_skcipher_speed("ctr(serpent)", DECRYPT, sec, NULL, 0,
+		test_mb_skcipher_speed(test, "ctr(serpent)", DECRYPT, sec, NULL, 0,
 				       speed_template_16_32, num_mb);
-		test_mb_skcipher_speed("lrw(serpent)", ENCRYPT, sec, NULL, 0,
+		test_mb_skcipher_speed(test, "lrw(serpent)", ENCRYPT, sec, NULL, 0,
 				       speed_template_32_48, num_mb);
-		test_mb_skcipher_speed("lrw(serpent)", DECRYPT, sec, NULL, 0,
+		test_mb_skcipher_speed(test, "lrw(serpent)", DECRYPT, sec, NULL, 0,
 				       speed_template_32_48, num_mb);
-		test_mb_skcipher_speed("xts(serpent)", ENCRYPT, sec, NULL, 0,
+		test_mb_skcipher_speed(test, "xts(serpent)", ENCRYPT, sec, NULL, 0,
 				       speed_template_32_64, num_mb);
-		test_mb_skcipher_speed("xts(serpent)", DECRYPT, sec, NULL, 0,
+		test_mb_skcipher_speed(test, "xts(serpent)", DECRYPT, sec, NULL, 0,
 				       speed_template_32_64, num_mb);
 		break;
 
 	case 604:
-		test_mb_skcipher_speed("ecb(twofish)", ENCRYPT, sec, NULL, 0,
+		test_mb_skcipher_speed(test, "ecb(twofish)", ENCRYPT, sec, NULL, 0,
 				       speed_template_16_24_32, num_mb);
-		test_mb_skcipher_speed("ecb(twofish)", DECRYPT, sec, NULL, 0,
+		test_mb_skcipher_speed(test, "ecb(twofish)", DECRYPT, sec, NULL, 0,
 				       speed_template_16_24_32, num_mb);
-		test_mb_skcipher_speed("cbc(twofish)", ENCRYPT, sec, NULL, 0,
+		test_mb_skcipher_speed(test, "cbc(twofish)", ENCRYPT, sec, NULL, 0,
 				       speed_template_16_24_32, num_mb);
-		test_mb_skcipher_speed("cbc(twofish)", DECRYPT, sec, NULL, 0,
+		test_mb_skcipher_speed(test, "cbc(twofish)", DECRYPT, sec, NULL, 0,
 				       speed_template_16_24_32, num_mb);
-		test_mb_skcipher_speed("ctr(twofish)", ENCRYPT, sec, NULL, 0,
+		test_mb_skcipher_speed(test, "ctr(twofish)", ENCRYPT, sec, NULL, 0,
 				       speed_template_16_24_32, num_mb);
-		test_mb_skcipher_speed("ctr(twofish)", DECRYPT, sec, NULL, 0,
+		test_mb_skcipher_speed(test, "ctr(twofish)", DECRYPT, sec, NULL, 0,
 				       speed_template_16_24_32, num_mb);
-		test_mb_skcipher_speed("lrw(twofish)", ENCRYPT, sec, NULL, 0,
+		test_mb_skcipher_speed(test, "lrw(twofish)", ENCRYPT, sec, NULL, 0,
 				       speed_template_32_40_48, num_mb);
-		test_mb_skcipher_speed("lrw(twofish)", DECRYPT, sec, NULL, 0,
+		test_mb_skcipher_speed(test, "lrw(twofish)", DECRYPT, sec, NULL, 0,
 				       speed_template_32_40_48, num_mb);
-		test_mb_skcipher_speed("xts(twofish)", ENCRYPT, sec, NULL, 0,
+		test_mb_skcipher_speed(test, "xts(twofish)", ENCRYPT, sec, NULL, 0,
 				       speed_template_32_48_64, num_mb);
-		test_mb_skcipher_speed("xts(twofish)", DECRYPT, sec, NULL, 0,
+		test_mb_skcipher_speed(test, "xts(twofish)", DECRYPT, sec, NULL, 0,
 				       speed_template_32_48_64, num_mb);
 		break;
 
 	case 605:
-		test_mb_skcipher_speed("ecb(arc4)", ENCRYPT, sec, NULL, 0,
+		test_mb_skcipher_speed(test, "ecb(arc4)", ENCRYPT, sec, NULL, 0,
 				       speed_template_8, num_mb);
 		break;
 
 	case 606:
-		test_mb_skcipher_speed("ecb(cast5)", ENCRYPT, sec, NULL, 0,
+		test_mb_skcipher_speed(test, "ecb(cast5)", ENCRYPT, sec, NULL, 0,
 				       speed_template_8_16, num_mb);
-		test_mb_skcipher_speed("ecb(cast5)", DECRYPT, sec, NULL, 0,
+		test_mb_skcipher_speed(test, "ecb(cast5)", DECRYPT, sec, NULL, 0,
 				       speed_template_8_16, num_mb);
-		test_mb_skcipher_speed("cbc(cast5)", ENCRYPT, sec, NULL, 0,
+		test_mb_skcipher_speed(test, "cbc(cast5)", ENCRYPT, sec, NULL, 0,
 				       speed_template_8_16, num_mb);
-		test_mb_skcipher_speed("cbc(cast5)", DECRYPT, sec, NULL, 0,
+		test_mb_skcipher_speed(test, "cbc(cast5)", DECRYPT, sec, NULL, 0,
 				       speed_template_8_16, num_mb);
-		test_mb_skcipher_speed("ctr(cast5)", ENCRYPT, sec, NULL, 0,
+		test_mb_skcipher_speed(test, "ctr(cast5)", ENCRYPT, sec, NULL, 0,
 				       speed_template_8_16, num_mb);
-		test_mb_skcipher_speed("ctr(cast5)", DECRYPT, sec, NULL, 0,
+		test_mb_skcipher_speed(test, "ctr(cast5)", DECRYPT, sec, NULL, 0,
 				       speed_template_8_16, num_mb);
 		break;
 
 	case 607:
-		test_mb_skcipher_speed("ecb(cast6)", ENCRYPT, sec, NULL, 0,
+		test_mb_skcipher_speed(test, "ecb(cast6)", ENCRYPT, sec, NULL, 0,
 				       speed_template_16_32, num_mb);
-		test_mb_skcipher_speed("ecb(cast6)", DECRYPT, sec, NULL, 0,
+		test_mb_skcipher_speed(test, "ecb(cast6)", DECRYPT, sec, NULL, 0,
 				       speed_template_16_32, num_mb);
-		test_mb_skcipher_speed("cbc(cast6)", ENCRYPT, sec, NULL, 0,
+		test_mb_skcipher_speed(test, "cbc(cast6)", ENCRYPT, sec, NULL, 0,
 				       speed_template_16_32, num_mb);
-		test_mb_skcipher_speed("cbc(cast6)", DECRYPT, sec, NULL, 0,
+		test_mb_skcipher_speed(test, "cbc(cast6)", DECRYPT, sec, NULL, 0,
 				       speed_template_16_32, num_mb);
-		test_mb_skcipher_speed("ctr(cast6)", ENCRYPT, sec, NULL, 0,
+		test_mb_skcipher_speed(test, "ctr(cast6)", ENCRYPT, sec, NULL, 0,
 				       speed_template_16_32, num_mb);
-		test_mb_skcipher_speed("ctr(cast6)", DECRYPT, sec, NULL, 0,
+		test_mb_skcipher_speed(test, "ctr(cast6)", DECRYPT, sec, NULL, 0,
 				       speed_template_16_32, num_mb);
-		test_mb_skcipher_speed("lrw(cast6)", ENCRYPT, sec, NULL, 0,
+		test_mb_skcipher_speed(test, "lrw(cast6)", ENCRYPT, sec, NULL, 0,
 				       speed_template_32_48, num_mb);
-		test_mb_skcipher_speed("lrw(cast6)", DECRYPT, sec, NULL, 0,
+		test_mb_skcipher_speed(test, "lrw(cast6)", DECRYPT, sec, NULL, 0,
 				       speed_template_32_48, num_mb);
-		test_mb_skcipher_speed("xts(cast6)", ENCRYPT, sec, NULL, 0,
+		test_mb_skcipher_speed(test, "xts(cast6)", ENCRYPT, sec, NULL, 0,
 				       speed_template_32_64, num_mb);
-		test_mb_skcipher_speed("xts(cast6)", DECRYPT, sec, NULL, 0,
+		test_mb_skcipher_speed(test, "xts(cast6)", DECRYPT, sec, NULL, 0,
 				       speed_template_32_64, num_mb);
 		break;
 
 	case 608:
-		test_mb_skcipher_speed("ecb(camellia)", ENCRYPT, sec, NULL, 0,
+		test_mb_skcipher_speed(test, "ecb(camellia)", ENCRYPT, sec, NULL, 0,
 				       speed_template_16_32, num_mb);
-		test_mb_skcipher_speed("ecb(camellia)", DECRYPT, sec, NULL, 0,
+		test_mb_skcipher_speed(test, "ecb(camellia)", DECRYPT, sec, NULL, 0,
 				       speed_template_16_32, num_mb);
-		test_mb_skcipher_speed("cbc(camellia)", ENCRYPT, sec, NULL, 0,
+		test_mb_skcipher_speed(test, "cbc(camellia)", ENCRYPT, sec, NULL, 0,
 				       speed_template_16_32, num_mb);
-		test_mb_skcipher_speed("cbc(camellia)", DECRYPT, sec, NULL, 0,
+		test_mb_skcipher_speed(test, "cbc(camellia)", DECRYPT, sec, NULL, 0,
 				       speed_template_16_32, num_mb);
-		test_mb_skcipher_speed("ctr(camellia)", ENCRYPT, sec, NULL, 0,
+		test_mb_skcipher_speed(test, "ctr(camellia)", ENCRYPT, sec, NULL, 0,
 				       speed_template_16_32, num_mb);
-		test_mb_skcipher_speed("ctr(camellia)", DECRYPT, sec, NULL, 0,
+		test_mb_skcipher_speed(test, "ctr(camellia)", DECRYPT, sec, NULL, 0,
 				       speed_template_16_32, num_mb);
-		test_mb_skcipher_speed("lrw(camellia)", ENCRYPT, sec, NULL, 0,
+		test_mb_skcipher_speed(test, "lrw(camellia)", ENCRYPT, sec, NULL, 0,
 				       speed_template_32_48, num_mb);
-		test_mb_skcipher_speed("lrw(camellia)", DECRYPT, sec, NULL, 0,
+		test_mb_skcipher_speed(test, "lrw(camellia)", DECRYPT, sec, NULL, 0,
 				       speed_template_32_48, num_mb);
-		test_mb_skcipher_speed("xts(camellia)", ENCRYPT, sec, NULL, 0,
+		test_mb_skcipher_speed(test, "xts(camellia)", ENCRYPT, sec, NULL, 0,
 				       speed_template_32_64, num_mb);
-		test_mb_skcipher_speed("xts(camellia)", DECRYPT, sec, NULL, 0,
+		test_mb_skcipher_speed(test, "xts(camellia)", DECRYPT, sec, NULL, 0,
 				       speed_template_32_64, num_mb);
 		break;
 
 	case 609:
-		test_mb_skcipher_speed("ecb(blowfish)", ENCRYPT, sec, NULL, 0,
+		test_mb_skcipher_speed(test, "ecb(blowfish)", ENCRYPT, sec, NULL, 0,
 				       speed_template_8_32, num_mb);
-		test_mb_skcipher_speed("ecb(blowfish)", DECRYPT, sec, NULL, 0,
+		test_mb_skcipher_speed(test, "ecb(blowfish)", DECRYPT, sec, NULL, 0,
 				       speed_template_8_32, num_mb);
-		test_mb_skcipher_speed("cbc(blowfish)", ENCRYPT, sec, NULL, 0,
+		test_mb_skcipher_speed(test, "cbc(blowfish)", ENCRYPT, sec, NULL, 0,
 				       speed_template_8_32, num_mb);
-		test_mb_skcipher_speed("cbc(blowfish)", DECRYPT, sec, NULL, 0,
+		test_mb_skcipher_speed(test, "cbc(blowfish)", DECRYPT, sec, NULL, 0,
 				       speed_template_8_32, num_mb);
-		test_mb_skcipher_speed("ctr(blowfish)", ENCRYPT, sec, NULL, 0,
+		test_mb_skcipher_speed(test, "ctr(blowfish)", ENCRYPT, sec, NULL, 0,
 				       speed_template_8_32, num_mb);
-		test_mb_skcipher_speed("ctr(blowfish)", DECRYPT, sec, NULL, 0,
+		test_mb_skcipher_speed(test, "ctr(blowfish)", DECRYPT, sec, NULL, 0,
 				       speed_template_8_32, num_mb);
 		break;
 
-- 
2.32.0.402.g57bb445576-goog

