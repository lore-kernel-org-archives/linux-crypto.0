Return-Path: <SRS0=LUcm=VV=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3FD29C7618B
	for <linux-crypto@archiver.kernel.org>; Wed, 24 Jul 2019 10:38:04 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id E84FA229ED
	for <linux-crypto@archiver.kernel.org>; Wed, 24 Jul 2019 10:38:03 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="IZS6B8uR"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726481AbfGXKiD (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Wed, 24 Jul 2019 06:38:03 -0400
Received: from mail-ed1-f68.google.com ([209.85.208.68]:41959 "EHLO
        mail-ed1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726070AbfGXKiC (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 24 Jul 2019 06:38:02 -0400
Received: by mail-ed1-f68.google.com with SMTP id p15so46650799eds.8
        for <linux-crypto@vger.kernel.org>; Wed, 24 Jul 2019 03:37:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id;
        bh=iOWIqTvQBkKoTPY8o+dEQlL2k+Zj1oLYbp0TIo1TFG0=;
        b=IZS6B8uR9AmrXt/3BvGdKnz1CVbQ55IBcz0EKfl9R1xGH6EiLudCHMuNAMtcU0qxvx
         fmZmn7J0y6UkPPDB2HwSHg5W7HVnqQFPC8lLpuA/HKxpEXM9M6Cd208B+P/DFTbR1a/T
         ia+hqXTmN8MITTrxhSD5LSZ4NdAiFmF7QKeAKuk/H/akamQAMn250pnMjQXM8jGdbzt2
         VZ6z+tnf59uSaoYb6RVOkAqBVKg+FM7IhNbb/XVdO9t29jSl5mAF4aIFiFPR2exDI4IC
         6NwuhGHmXUeKM8ZNuAlz1FT1B2noXpG4Eucs7suDKBADtMQSZi3bBANaxGR3/yTjLNBD
         6D/A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=iOWIqTvQBkKoTPY8o+dEQlL2k+Zj1oLYbp0TIo1TFG0=;
        b=p27EKDIvkJ/i/avDZkiR5pfwfgucP0wPsWYibaDoFvjvHq9f9BQ135GLzM4PWO/Jqj
         0SvJqj1BEOg5y9RbhzPl+YZ6LMvazcD+kL5e6LFPx7XY1Ldi6WwVLr1KO88pbo1Ljycd
         DjkPpiH1n/9Vuk0HLC3nIBwaChz/CCq/GiqPHOWDrK79hMbHjhQN216/QIEgTYunKlH9
         KlN+d8x2IUNCFqyAWtqHoznZp28UhiSLzNxogeIx0WBnVNZwUOEEr5O26taR1sQMIRvJ
         iR3i0A8pv/+/CvhCtxDOmG7e8cAHdoOQlcp/W5REa3Mtfj1ahzhPG3AvkJ7BSCLpxsj1
         ZO0g==
X-Gm-Message-State: APjAAAUJwqpLm6ivdxaO+AMgjMJgSAflHbcXMwXgR1X0Luf3UFnok3Se
        htQjGuLxHeQQO44Qfcm+Y3uqI5dc
X-Google-Smtp-Source: APXvYqx1ExtNeUT15ZbPwIRmVod8ZoddM/Yd2d9NuAlt3cjGWNkp5xCtZgxpYEDjWDopDf7X/jCm2A==
X-Received: by 2002:a17:906:b6ce:: with SMTP id ec14mr51188302ejb.81.1563964678612;
        Wed, 24 Jul 2019 03:37:58 -0700 (PDT)
Received: from localhost.localdomain.com ([188.204.2.113])
        by smtp.gmail.com with ESMTPSA id l1sm12326900edr.17.2019.07.24.03.37.57
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 24 Jul 2019 03:37:57 -0700 (PDT)
From:   Pascal van Leeuwen <pascalvanl@gmail.com>
X-Google-Original-From: Pascal van Leeuwen <pvanleeuwen@verimatrix.com>
To:     linux-crypto@vger.kernel.org
Cc:     ebiggers@kernel.org, herbert@gondor.apana.org.au,
        davem@davemloft.net,
        Pascal van Leeuwen <pvanleeuwen@verimatrix.com>
Subject: [PATCH] crypto: testmgr - Improve randomization of params for AEAD fuzz testing
Date:   Wed, 24 Jul 2019 11:35:17 +0200
Message-Id: <1563960917-8236-1-git-send-email-pvanleeuwen@verimatrix.com>
X-Mailer: git-send-email 1.8.3.1
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

The probability of hitting specific input length corner cases relevant
for certain hardware driver(s) (specifically: inside-secure) was found
to be too low. Additionally, for authenc AEADs, the probability of
generating a *legal* key blob approached zero, i.e. most vectors
generated would only test the proper generation of a key blob error.

This patch address both of these issues by improving the random
generation of data lengths (for the key, but also for the ICV output
and the AAD and plaintext inputs), making the random generation
individually tweakable on a per-ciphersuite basis.

Finally, this patch enables fuzz testing for AEAD ciphersuites that do
not have a regular testsuite defined as it no longer depends on that
regular testsuite for figuring out the key size.

Signed-off-by: Pascal van Leeuwen <pvanleeuwen@verimatrix.com>
---
 crypto/testmgr.c | 269 +++++++++++++++++++++++++++++++++++++++++++------
 crypto/testmgr.h | 298 +++++++++++++++++++++++++++++++++++++++++++++++++++++++
 2 files changed, 535 insertions(+), 32 deletions(-)

diff --git a/crypto/testmgr.c b/crypto/testmgr.c
index 2ba0c48..9c856d3 100644
--- a/crypto/testmgr.c
+++ b/crypto/testmgr.c
@@ -84,11 +84,24 @@ int alg_test(const char *driver, const char *alg, u32 type, u32 mask)
 #define ENCRYPT 1
 #define DECRYPT 0
 
+struct len_range_set {
+	const struct len_range_sel *lensel;
+	unsigned int count;
+};
+
 struct aead_test_suite {
 	const struct aead_testvec *vecs;
 	unsigned int count;
 };
 
+struct aead_test_params {
+	struct len_range_set ckeylensel;
+	struct len_range_set akeylensel;
+	struct len_range_set authsizesel;
+	struct len_range_set aadlensel;
+	struct len_range_set ptxtlensel;
+};
+
 struct cipher_test_suite {
 	const struct cipher_testvec *vecs;
 	unsigned int count;
@@ -143,6 +156,10 @@ struct alg_test_desc {
 		struct akcipher_test_suite akcipher;
 		struct kpp_test_suite kpp;
 	} suite;
+
+	union {
+		struct aead_test_params aead;
+	} params;
 };
 
 static void hexdump(unsigned char *buf, unsigned int len)
@@ -189,9 +206,6 @@ static void testmgr_free_buf(char *buf[XBUFSIZE])
 	__testmgr_free_buf(buf, 0);
 }
 
-#define TESTMGR_POISON_BYTE	0xfe
-#define TESTMGR_POISON_LEN	16
-
 static inline void testmgr_poison(void *addr, size_t len)
 {
 	memset(addr, TESTMGR_POISON_BYTE, len);
@@ -2035,6 +2049,19 @@ static int test_aead_vec(const char *driver, int enc,
 }
 
 #ifdef CONFIG_CRYPTO_MANAGER_EXTRA_TESTS
+/* Select a random length value from a list of range specs */
+int random_lensel(const struct len_range_set *lens)
+{
+	u32 i, sel = prandom_u32() % 1000;
+
+	for (i = 0; i < lens->count; i++)
+		if (sel < lens->lensel[i].threshold)
+			return (prandom_u32() % (lens->lensel[i].len_hi  -
+						 lens->lensel[i].len_lo + 1)) +
+				lens->lensel[i].len_lo;
+	return -1;
+}
+
 /*
  * Generate an AEAD test vector from the given implementation.
  * Assumes the buffers in 'vec' were already allocated.
@@ -2043,44 +2070,83 @@ static void generate_random_aead_testvec(struct aead_request *req,
 					 struct aead_testvec *vec,
 					 unsigned int maxkeysize,
 					 unsigned int maxdatasize,
+					 const struct aead_test_params *lengths,
 					 char *name, size_t max_namelen)
 {
 	struct crypto_aead *tfm = crypto_aead_reqtfm(req);
 	const unsigned int ivsize = crypto_aead_ivsize(tfm);
 	unsigned int maxauthsize = crypto_aead_alg(tfm)->maxauthsize;
-	unsigned int authsize;
+	int authsize, clen, alen;
 	unsigned int total_len;
 	int i;
 	struct scatterlist src[2], dst;
 	u8 iv[MAX_IVLEN];
 	DECLARE_CRYPTO_WAIT(wait);
 
-	/* Key: length in [0, maxkeysize], but usually choose maxkeysize */
-	vec->klen = maxkeysize;
-	if (prandom_u32() % 4 == 0)
-		vec->klen = prandom_u32() % (maxkeysize + 1);
-	generate_random_bytes((u8 *)vec->key, vec->klen);
+	alen = random_lensel(&lengths->akeylensel);
+	clen = random_lensel(&lengths->ckeylensel);
+	if ((alen >= 0) && (clen >= 0)) {
+		/* Corect blob header. TBD: Do we care about corrupting this? */
+#ifdef __LITTLE_ENDIAN
+		memcpy((void *)vec->key, "\x08\x00\x01\x00\x00\x00\x00\x10", 8);
+#else
+		memcpy((void *)vec->key, "\x00\x08\x00\x01\x00\x00\x00\x10", 8);
+#endif
+
+		/* Generate keys based on length templates */
+		generate_random_bytes((u8 *)(vec->key + 8), alen);
+		generate_random_bytes((u8 *)(vec->key + 8 + alen),
+				      clen);
+
+		vec->klen = 8 + alen + clen;
+	} else {
+		if (clen >= 0)
+			maxkeysize = clen;
+
+		vec->klen = maxkeysize;
+
+		/*
+		 * Key: length in [0, maxkeysize],
+		 * but usually choose maxkeysize
+		 */
+		if (prandom_u32() % 4 == 0)
+			vec->klen = prandom_u32() % (maxkeysize + 1);
+		generate_random_bytes((u8 *)vec->key, vec->klen);
+	}
 	vec->setkey_error = crypto_aead_setkey(tfm, vec->key, vec->klen);
 
 	/* IV */
 	generate_random_bytes((u8 *)vec->iv, ivsize);
 
-	/* Tag length: in [0, maxauthsize], but usually choose maxauthsize */
-	authsize = maxauthsize;
-	if (prandom_u32() % 4 == 0)
-		authsize = prandom_u32() % (maxauthsize + 1);
+	authsize = random_lensel(&lengths->authsizesel);
+	if (authsize < 0) {
+		/*
+		 * Tag length: in [0, maxauthsize],
+		 * but usually choose maxauthsize
+		 */
+		authsize = maxauthsize;
+		if (prandom_u32() % 4 == 0)
+			authsize = prandom_u32() % (maxauthsize + 1);
+	}
 	if (WARN_ON(authsize > maxdatasize))
 		authsize = maxdatasize;
-	maxdatasize -= authsize;
 	vec->setauthsize_error = crypto_aead_setauthsize(tfm, authsize);
 
 	/* Plaintext and associated data */
-	total_len = generate_random_length(maxdatasize);
-	if (prandom_u32() % 4 == 0)
-		vec->alen = 0;
-	else
-		vec->alen = generate_random_length(total_len);
-	vec->plen = total_len - vec->alen;
+	alen = random_lensel(&lengths->aadlensel);
+	clen = random_lensel(&lengths->ptxtlensel);
+	maxdatasize -= authsize;
+	if ((alen < 0) || (clen < 0) || ((alen + clen) > maxdatasize)) {
+		total_len = generate_random_length(maxdatasize);
+		if (prandom_u32() % 4 == 0)
+			vec->alen = 0;
+		else
+			vec->alen = generate_random_length(total_len);
+		vec->plen = total_len - vec->alen;
+	} else {
+		vec->alen = alen;
+		vec->plen = clen;
+	}
 	generate_random_bytes((u8 *)vec->assoc, vec->alen);
 	generate_random_bytes((u8 *)vec->ptext, vec->plen);
 
@@ -2133,7 +2199,7 @@ static int test_aead_vs_generic_impl(const char *driver,
 	char _generic_driver[CRYPTO_MAX_ALG_NAME];
 	struct crypto_aead *generic_tfm = NULL;
 	struct aead_request *generic_req = NULL;
-	unsigned int maxkeysize;
+	unsigned int maxkeysize, maxakeysize;
 	unsigned int i;
 	struct aead_testvec vec = { 0 };
 	char vec_name[64];
@@ -2203,9 +2269,27 @@ static int test_aead_vs_generic_impl(const char *driver,
 	 */
 
 	maxkeysize = 0;
-	for (i = 0; i < test_desc->suite.aead.count; i++)
+	for (i = 0; i < test_desc->params.aead.ckeylensel.count; i++)
 		maxkeysize = max_t(unsigned int, maxkeysize,
-				   test_desc->suite.aead.vecs[i].klen);
+			test_desc->params.aead.ckeylensel.lensel[i].len_hi);
+
+	if (maxkeysize && test_desc->params.aead.akeylensel.count) {
+		/* authenc, explicit keylen ranges defined, use them */
+		maxakeysize = 0;
+		for (i = 0; i < test_desc->params.aead.akeylensel.count; i++)
+			maxakeysize = max_t(unsigned int, maxakeysize,
+			   test_desc->params.aead.akeylensel.lensel[i].len_hi);
+		maxkeysize = 8 + maxkeysize + maxakeysize;
+	} else if (!maxkeysize && test_desc->suite.aead.count) {
+		/* attempt to derive from test vectors */
+		for (i = 0; i < test_desc->suite.aead.count; i++)
+			maxkeysize = max_t(unsigned int, maxkeysize,
+					test_desc->suite.aead.vecs[i].klen);
+	} else {
+		pr_err("alg: aead: no key length templates or test vectors for %s - unable to fuzz\n",
+		       driver);
+		err = -EINVAL;
+	}
 
 	vec.key = kmalloc(maxkeysize, GFP_KERNEL);
 	vec.iv = kmalloc(ivsize, GFP_KERNEL);
@@ -2220,6 +2304,7 @@ static int test_aead_vs_generic_impl(const char *driver,
 	for (i = 0; i < fuzz_iterations * 8; i++) {
 		generate_random_aead_testvec(generic_req, &vec,
 					     maxkeysize, maxdatasize,
+					     &test_desc->params.aead,
 					     vec_name, sizeof(vec_name));
 		generate_random_testvec_config(&cfg, cfgname, sizeof(cfgname));
 
@@ -2280,11 +2365,6 @@ static int alg_test_aead(const struct alg_test_desc *desc, const char *driver,
 	struct cipher_test_sglists *tsgls = NULL;
 	int err;
 
-	if (suite->count <= 0) {
-		pr_err("alg: aead: empty test suite for %s\n", driver);
-		return -EINVAL;
-	}
-
 	tfm = crypto_alloc_aead(driver, type, mask);
 	if (IS_ERR(tfm)) {
 		pr_err("alg: aead: failed to allocate transform for %s: %ld\n",
@@ -2308,6 +2388,11 @@ static int alg_test_aead(const struct alg_test_desc *desc, const char *driver,
 		goto out;
 	}
 
+	if (suite->count <= 0) {
+		pr_err("alg: aead: empty test suite for %s\n", driver);
+		goto aead_skip_testsuite;
+	}
+
 	err = test_aead(driver, ENCRYPT, suite, req, tsgls);
 	if (err)
 		goto out;
@@ -2316,7 +2401,9 @@ static int alg_test_aead(const struct alg_test_desc *desc, const char *driver,
 	if (err)
 		goto out;
 
+aead_skip_testsuite:
 	err = test_aead_vs_generic_impl(driver, desc, req, tsgls);
+
 out:
 	free_cipher_test_sglists(tsgls);
 	aead_request_free(req);
@@ -3834,6 +3921,7 @@ static int alg_test_null(const struct alg_test_desc *desc,
 }
 
 #define __VECS(tv)	{ .vecs = tv, .count = ARRAY_SIZE(tv) }
+#define __LENS(ls)	{ .lensel = ls, .count = ARRAY_SIZE(ls) }
 
 /* Please keep this list sorted by algorithm name. */
 static const struct alg_test_desc alg_test_descs[] = {
@@ -3887,12 +3975,30 @@ static int alg_test_null(const struct alg_test_desc *desc,
 		.fips_allowed = 1,
 		.suite = {
 			.aead = __VECS(hmac_sha1_aes_cbc_tv_temp)
+		},
+		.params = {
+			.aead = {
+				.ckeylensel = __LENS(aes_klen_template),
+				.akeylensel = __LENS(sha1_klen_template),
+				.authsizesel = __LENS(sha1_alen_template),
+				.aadlensel = __LENS(aead_alen_template),
+				.ptxtlensel = __LENS(aead_plen_template),
+			}
 		}
 	}, {
 		.alg = "authenc(hmac(sha1),cbc(des))",
 		.test = alg_test_aead,
 		.suite = {
 			.aead = __VECS(hmac_sha1_des_cbc_tv_temp)
+		},
+		.params = {
+			.aead = {
+				.ckeylensel = __LENS(des_klen_template),
+				.akeylensel = __LENS(sha1_klen_template),
+				.authsizesel = __LENS(sha1_alen_template),
+				.aadlensel = __LENS(aead_alen_template),
+				.ptxtlensel = __LENS(aead_plen_template),
+			}
 		}
 	}, {
 		.alg = "authenc(hmac(sha1),cbc(des3_ede))",
@@ -3900,6 +4006,15 @@ static int alg_test_null(const struct alg_test_desc *desc,
 		.fips_allowed = 1,
 		.suite = {
 			.aead = __VECS(hmac_sha1_des3_ede_cbc_tv_temp)
+		},
+		.params = {
+			.aead = {
+				.ckeylensel = __LENS(des3_klen_template),
+				.akeylensel = __LENS(sha1_klen_template),
+				.authsizesel = __LENS(sha1_alen_template),
+				.aadlensel = __LENS(aead_alen_template),
+				.ptxtlensel = __LENS(aead_plen_template),
+			}
 		}
 	}, {
 		.alg = "authenc(hmac(sha1),ctr(aes))",
@@ -3913,8 +4028,29 @@ static int alg_test_null(const struct alg_test_desc *desc,
 		}
 	}, {
 		.alg = "authenc(hmac(sha1),rfc3686(ctr(aes)))",
-		.test = alg_test_null,
+		.test = alg_test_aead,
 		.fips_allowed = 1,
+		.params = {
+			.aead = {
+				.ckeylensel = __LENS(aes_klen_template),
+				.akeylensel = __LENS(sha1_klen_template),
+				.authsizesel = __LENS(sha1_alen_template),
+				.aadlensel = __LENS(aead_alen_template),
+				.ptxtlensel = __LENS(aead_plen_template),
+			}
+		}
+	}, {
+		.alg = "authenc(hmac(sha224),cbc(aes))",
+		.test = alg_test_aead,
+		.params = {
+			.aead = {
+				.ckeylensel = __LENS(aes_klen_template),
+				.akeylensel = __LENS(sha224_klen_template),
+				.authsizesel = __LENS(sha224_alen_template),
+				.aadlensel = __LENS(aead_alen_template),
+				.ptxtlensel = __LENS(aead_plen_template),
+			}
+		}
 	}, {
 		.alg = "authenc(hmac(sha224),cbc(des))",
 		.test = alg_test_aead,
@@ -3929,11 +4065,32 @@ static int alg_test_null(const struct alg_test_desc *desc,
 			.aead = __VECS(hmac_sha224_des3_ede_cbc_tv_temp)
 		}
 	}, {
+		.alg = "authenc(hmac(sha224),rfc3686(ctr(aes)))",
+		.test = alg_test_aead,
+		.params = {
+			.aead = {
+				.ckeylensel = __LENS(aes_klen_template),
+				.akeylensel = __LENS(sha224_klen_template),
+				.authsizesel = __LENS(sha224_alen_template),
+				.aadlensel = __LENS(aead_alen_template),
+				.ptxtlensel = __LENS(aead_plen_template),
+			}
+		}
+	}, {
 		.alg = "authenc(hmac(sha256),cbc(aes))",
 		.test = alg_test_aead,
 		.fips_allowed = 1,
 		.suite = {
 			.aead = __VECS(hmac_sha256_aes_cbc_tv_temp)
+		},
+		.params = {
+			.aead = {
+				.ckeylensel = __LENS(aes_klen_template),
+				.akeylensel = __LENS(sha256_klen_template),
+				.authsizesel = __LENS(sha256_alen_template),
+				.aadlensel = __LENS(aead_alen_template),
+				.ptxtlensel = __LENS(aead_plen_template),
+			}
 		}
 	}, {
 		.alg = "authenc(hmac(sha256),cbc(des))",
@@ -3954,8 +4111,29 @@ static int alg_test_null(const struct alg_test_desc *desc,
 		.fips_allowed = 1,
 	}, {
 		.alg = "authenc(hmac(sha256),rfc3686(ctr(aes)))",
-		.test = alg_test_null,
+		.test = alg_test_aead,
 		.fips_allowed = 1,
+		.params = {
+			.aead = {
+				.ckeylensel = __LENS(aes_klen_template),
+				.akeylensel = __LENS(sha256_klen_template),
+				.authsizesel = __LENS(sha256_alen_template),
+				.aadlensel = __LENS(aead_alen_template),
+				.ptxtlensel = __LENS(aead_plen_template),
+			}
+		}
+	}, {
+		.alg = "authenc(hmac(sha384),cbc(aes))",
+		.test = alg_test_aead,
+		.params = {
+			.aead = {
+				.ckeylensel = __LENS(aes_klen_template),
+				.akeylensel = __LENS(sha384_klen_template),
+				.authsizesel = __LENS(sha384_alen_template),
+				.aadlensel = __LENS(aead_alen_template),
+				.ptxtlensel = __LENS(aead_plen_template),
+			}
+		}
 	}, {
 		.alg = "authenc(hmac(sha384),cbc(des))",
 		.test = alg_test_aead,
@@ -3975,14 +4153,32 @@ static int alg_test_null(const struct alg_test_desc *desc,
 		.fips_allowed = 1,
 	}, {
 		.alg = "authenc(hmac(sha384),rfc3686(ctr(aes)))",
-		.test = alg_test_null,
+		.test = alg_test_aead,
 		.fips_allowed = 1,
+		.params = {
+			.aead = {
+				.ckeylensel = __LENS(aes_klen_template),
+				.akeylensel = __LENS(sha384_klen_template),
+				.authsizesel = __LENS(sha384_alen_template),
+				.aadlensel = __LENS(aead_alen_template),
+				.ptxtlensel = __LENS(aead_plen_template),
+			}
+		}
 	}, {
 		.alg = "authenc(hmac(sha512),cbc(aes))",
 		.fips_allowed = 1,
 		.test = alg_test_aead,
 		.suite = {
 			.aead = __VECS(hmac_sha512_aes_cbc_tv_temp)
+		},
+		.params = {
+			.aead = {
+				.ckeylensel = __LENS(aes_klen_template),
+				.akeylensel = __LENS(sha512_klen_template),
+				.authsizesel = __LENS(sha512_alen_template),
+				.aadlensel = __LENS(aead_alen_template),
+				.ptxtlensel = __LENS(aead_plen_template),
+			}
 		}
 	}, {
 		.alg = "authenc(hmac(sha512),cbc(des))",
@@ -4003,8 +4199,17 @@ static int alg_test_null(const struct alg_test_desc *desc,
 		.fips_allowed = 1,
 	}, {
 		.alg = "authenc(hmac(sha512),rfc3686(ctr(aes)))",
-		.test = alg_test_null,
+		.test = alg_test_aead,
 		.fips_allowed = 1,
+		.params = {
+			.aead = {
+				.ckeylensel = __LENS(aes_klen_template),
+				.akeylensel = __LENS(sha512_klen_template),
+				.authsizesel = __LENS(sha512_alen_template),
+				.aadlensel = __LENS(aead_alen_template),
+				.ptxtlensel = __LENS(aead_plen_template),
+			}
+		}
 	}, {
 		.alg = "cbc(aes)",
 		.test = alg_test_skcipher,
diff --git a/crypto/testmgr.h b/crypto/testmgr.h
index 6b459a6..105f2ce 100644
--- a/crypto/testmgr.h
+++ b/crypto/testmgr.h
@@ -28,6 +28,8 @@
 #include <linux/oid_registry.h>
 
 #define MAX_IVLEN		32
+#define TESTMGR_POISON_BYTE	0xfe
+#define TESTMGR_POISON_LEN	16
 
 /*
  * hash_testvec:	structure to describe a hash (message digest) test
@@ -176,6 +178,302 @@ struct kpp_testvec {
 static const char zeroed_string[48];
 
 /*
+ * length range declaration lo-hi plus selection threshold 0 - 1000
+ */
+struct len_range_sel {
+	unsigned int len_lo;
+	unsigned int len_hi;
+	unsigned int threshold;
+};
+
+/*
+ * List of length ranges sorted on increasing threshold
+ *
+ * 25% of each of the legal key sizes (128, 192, 256 bits)
+ * plus 25% of illegal sizes in between 0 and 1024 bits.
+ */
+static const struct len_range_sel aes_klen_template[] = {
+	{
+	.len_lo = 0,
+	.len_hi = 15,
+	.threshold = 25,
+	}, {
+	.len_lo = 16,
+	.len_hi = 16,
+	.threshold = 325,
+	}, {
+	.len_lo = 17,
+	.len_hi = 23,
+	.threshold = 350,
+	}, {
+	.len_lo = 24,
+	.len_hi = 24,
+	.threshold = 650,
+	}, {
+	.len_lo = 25,
+	.len_hi = 31,
+	.threshold = 675,
+	}, {
+	.len_lo = 32,
+	.len_hi = 32,
+	.threshold = 975,
+	}, {
+	.len_lo = 33,
+	.len_hi = 128,
+	.threshold = 1000,
+	}
+};
+
+/* 90% legal keys of size 8, rest illegal between 0 and 32 */
+static const struct len_range_sel des_klen_template[] = {
+	{
+	.len_lo = 0,
+	.len_hi = 7,
+	.threshold = 50,
+	}, {
+	.len_lo = 8,
+	.len_hi = 8,
+	.threshold = 950,
+	}, {
+	.len_lo = 9,
+	.len_hi = 32,
+	.threshold = 1000,
+	}
+};
+
+/* 90% legal keys of size 24, rest illegal between 0 and 32 */
+static const struct len_range_sel des3_klen_template[] = {
+	{
+	.len_lo = 0,
+	.len_hi = 23,
+	.threshold = 50,
+	}, {
+	.len_lo = 24,
+	.len_hi = 24,
+	.threshold = 950,
+	}, {
+	.len_lo = 25,
+	.len_hi = 32,
+	.threshold = 1000,
+	}
+};
+
+/*
+ * For HMAC's, favour the actual digest size for both key
+ * size and authenticator size, but do verify some tag
+ * truncation cases and some larger keys, including keys
+ * exceeding the block size.
+ */
+
+static const struct len_range_sel md5_klen_template[] = {
+	{
+	.len_lo = 0, /* Allow 0 here? */
+	.len_hi = 15,
+	.threshold = 50,
+	}, {
+	.len_lo = 16,
+	.len_hi = 16,
+	.threshold = 950,
+	}, {
+	.len_lo = 17,
+	.len_hi = 256,
+	.threshold = 1000,
+	}
+};
+
+static const struct len_range_sel md5_alen_template[] = {
+	{
+	.len_lo = 0, /* Allow 0 here? */
+	.len_hi = 15,
+	.threshold = 100,
+	}, {
+	.len_lo = 16,
+	.len_hi = 16,
+	.threshold = 1000,
+	}
+};
+
+static const struct len_range_sel sha1_klen_template[] = {
+	{
+	.len_lo = 0, /* Allow 0 here? */
+	.len_hi = 19,
+	.threshold = 50,
+	}, {
+	.len_lo = 20,
+	.len_hi = 20,
+	.threshold = 950,
+	}, {
+	.len_lo = 21,
+	.len_hi = 256,
+	.threshold = 1000,
+	}
+};
+
+static const struct len_range_sel sha1_alen_template[] = {
+	{
+	.len_lo = 0, /* Allow 0 here? */
+	.len_hi = 19,
+	.threshold = 100,
+	}, {
+	.len_lo = 20,
+	.len_hi = 20,
+	.threshold = 1000,
+	}
+};
+
+static const struct len_range_sel sha224_klen_template[] = {
+	{
+	.len_lo = 0, /* Allow 0 here? */
+	.len_hi = 23,
+	.threshold = 50,
+	}, {
+	.len_lo = 24,
+	.len_hi = 24,
+	.threshold = 950,
+	}, {
+	.len_lo = 25,
+	.len_hi = 256,
+	.threshold = 1000,
+	}
+};
+
+static const struct len_range_sel sha224_alen_template[] = {
+	{
+	.len_lo = 0, /* Allow 0 here? */
+	.len_hi = 23,
+	.threshold = 100,
+	}, {
+	.len_lo = 24,
+	.len_hi = 24,
+	.threshold = 1000,
+	}
+};
+
+static const struct len_range_sel sha256_klen_template[] = {
+	{
+	.len_lo = 0, /* Allow 0 here? */
+	.len_hi = 31,
+	.threshold = 50,
+	}, {
+	.len_lo = 32,
+	.len_hi = 32,
+	.threshold = 950,
+	}, {
+	.len_lo = 33,
+	.len_hi = 256,
+	.threshold = 1000,
+	}
+};
+
+static const struct len_range_sel sha256_alen_template[] = {
+	{
+	.len_lo = 0, /* Allow 0 here? */
+	.len_hi = 31,
+	.threshold = 100,
+	}, {
+	.len_lo = 32,
+	.len_hi = 32,
+	.threshold = 1000,
+	}
+};
+
+static const struct len_range_sel sha384_klen_template[] = {
+	{
+	.len_lo = 0, /* Allow 0 here? */
+	.len_hi = 47,
+	.threshold = 50,
+	}, {
+	.len_lo = 48,
+	.len_hi = 48,
+	.threshold = 950,
+	}, {
+	.len_lo = 49,
+	.len_hi = 256,
+	.threshold = 1000,
+	}
+};
+
+static const struct len_range_sel sha384_alen_template[] = {
+	{
+	.len_lo = 0, /* Allow 0 here? */
+	.len_hi = 47,
+	.threshold = 100,
+	}, {
+	.len_lo = 48,
+	.len_hi = 48,
+	.threshold = 1000,
+	}
+};
+
+static const struct len_range_sel sha512_klen_template[] = {
+	{
+	.len_lo = 0, /* Allow 0 here? */
+	.len_hi = 63,
+	.threshold = 50,
+	}, {
+	.len_lo = 64,
+	.len_hi = 64,
+	.threshold = 950,
+	}, {
+	.len_lo = 65,
+	.len_hi = 256,
+	.threshold = 1000,
+	}
+};
+
+static const struct len_range_sel sha512_alen_template[] = {
+	{
+	.len_lo = 0, /* Allow 0 here? */
+	.len_hi = 63,
+	.threshold = 100,
+	}, {
+	.len_lo = 64,
+	.len_hi = 64,
+	.threshold = 1000,
+	}
+};
+
+static const struct len_range_sel aead_alen_template[] = {
+	{
+	.len_lo = 0,
+	.len_hi = 0,
+	.threshold = 200,
+	}, {
+	.len_lo = 1,
+	.len_hi = 32,
+	.threshold = 900,
+	}, {
+	.len_lo = 33,
+	.len_hi = (2 * PAGE_SIZE) - TESTMGR_POISON_LEN,
+	.threshold = 1000,
+	}
+};
+
+static const struct len_range_sel aead_plen_template[] = {
+	{
+	.len_lo = 0,
+	.len_hi = 0,
+	.threshold = 200,
+	}, {
+	.len_lo = 1,
+	.len_hi = 63,
+	.threshold = 400,
+	}, {
+	.len_lo = 64,
+	.len_hi = 255,
+	.threshold = 600,
+	}, {
+	.len_lo = 256,
+	.len_hi = 1023,
+	.threshold = 800,
+	}, {
+	.len_lo = 1024,
+	.len_hi = (2 * PAGE_SIZE) - TESTMGR_POISON_LEN,
+	.threshold = 1000,
+	}
+};
+
+/*
  * RSA test vectors. Borrowed from openSSL.
  */
 static const struct akcipher_testvec rsa_tv_template[] = {
-- 
1.8.3.1

