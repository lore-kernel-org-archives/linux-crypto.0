Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-26.6 required=3.0 tests=BAYES_00,DKIMWL_WL_MED,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_GIT,USER_IN_DEF_DKIM_WL autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C0AD4C433DB
	for <linux-crypto@archiver.kernel.org>; Fri,  8 Jan 2021 17:39:42 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 86B5E23A00
	for <linux-crypto@archiver.kernel.org>; Fri,  8 Jan 2021 17:39:42 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728322AbhAHRjf (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 8 Jan 2021 12:39:35 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56196 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728004AbhAHRjf (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 8 Jan 2021 12:39:35 -0500
Received: from mail-qv1-xf4a.google.com (mail-qv1-xf4a.google.com [IPv6:2607:f8b0:4864:20::f4a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9B3ECC061381
        for <linux-crypto@vger.kernel.org>; Fri,  8 Jan 2021 09:38:54 -0800 (PST)
Received: by mail-qv1-xf4a.google.com with SMTP id x17so380164qvo.23
        for <linux-crypto@vger.kernel.org>; Fri, 08 Jan 2021 09:38:54 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=sender:date:message-id:mime-version:subject:from:to:cc;
        bh=PSI/mw6bwGc53gnrPU2GZuEk6B0fE3D9J0+i0QkT3uI=;
        b=Oj90gi+2Lgn0i9LuF0Lz4gyPhHsuvz+AxM0LmXhg1ImkPKEGENtMA1skeMa8+40vEL
         F71JDgIG1KuboaYYaSKM8M24VjK58I6Vo9CokiQAAqQNY6g6hVxFs063lSmwN0M4wTNe
         un2V8dNNZNT4dCBaSXNQ3FrRyeP7dxYKqMcwizZytPFjpM8SFqFMnmL2L4LO1TSsOAO6
         Ge9RrTUtUj4uJVZNsOgC9bnjv3x/GCqvSR/zAQY58v93OFT88Dwqx3f7da8eYmJBzR+4
         FKfZ8XzP2bzYUBrdsZ/pxmTd+/qd0gXMhK4IEbR0SPOMeYlqDUsvP7ehrCOqxQXubl0C
         SAMg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:date:message-id:mime-version:subject:from
         :to:cc;
        bh=PSI/mw6bwGc53gnrPU2GZuEk6B0fE3D9J0+i0QkT3uI=;
        b=CjLCQw+JrNI+k61U/SwWq+mQO3o6N9NLDXZSV/aXNGBrae7fo++UXnwOLs9FxBDUL1
         95afd54UkpaTURDTZu53qP2M3iECvfZChSLsZjIfXhw1PdvoIzdUFXVovVI4Ix4/hL6e
         sVwAK9uiaTWtXr8U97k5L7/3vSkVwT3YVCvnhI5Hdu/XZJ9KwaMu9OZ1j5EiH5QINGKP
         dPGu/aNJ9ri+i4XxHl785PjF8fTYIIpM2GDWXhNKLGY/Jaw8NUhuEh/RSKFnJe48Itje
         ic5zHH2A3+0qTTpfcWjx2eEpUB12DfXg+jeuOfeyRWLKD0OshMOlXqP0pXYzVXqHIYC+
         OyKg==
X-Gm-Message-State: AOAM530ayYKM3cb+q5L+ORs5aL8VL+kTpgzRzHMMPjjxrAwu9W2DFCMc
        /w0nWIQstbEtiDj+6e+N6o4FPAERASu1aDzEKNxPCHNu/A5WWffLQBfeo39INME6XTQqTzpMY8U
        BDAbYIpVCL4QnK1yZbxvPDOgCg/LPP3FCG6iRaIj2XNI2H08YbzfPhahU4+chOZGU7BEqo10C
X-Google-Smtp-Source: ABdhPJxg5PKnIYuELFQWkoITVrWqd19PU6QQPZ9rcRWjM0qKbmjm9gsXduf3ZhY66qAaXI9lIaQqqnRtIQAq
Sender: "lenaptr via sendgmr" <lenaptr@beef.c.googlers.com>
X-Received: from beef.c.googlers.com ([fda3:e722:ac3:cc00:28:9cb1:c0a8:1091])
 (user=lenaptr job=sendgmr) by 2002:ad4:580f:: with SMTP id
 dd15mr7669849qvb.40.1610127533729; Fri, 08 Jan 2021 09:38:53 -0800 (PST)
Date:   Fri,  8 Jan 2021 17:38:49 +0000
Message-Id: <20210108173849.333780-1-lenaptr@google.com>
Mime-Version: 1.0
X-Mailer: git-send-email 2.30.0.284.gd98b1dd5eaa7-goog
Subject: [PATCH] crypto: testmgr - add NIAP FPT_TST_EXT.1 subset of tests
From:   Elena Petrova <lenaptr@google.com>
To:     linux-crypto@vger.kernel.org
Cc:     Elena Petrova <lenaptr@google.com>,
        Eric Biggers <ebiggers@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

NIAP FPT_TST_EXT.1 [1] specification requires testing of a small set of
cryptographic modules on boot for devices that need to be NIAP
compliant. This is also a requirement for FIPS CMVP 140-2/140-3
certification.

Currently testmgr adds significant boot time overhead when enabled; we
measured 3-5 seconds for Android.

This change adds a CONFIG_ option that allows testmgr to run a
smaller subset of tests required by NIAP FPT_TST_EXT.1.

[1] https://www.niap-ccevs.org/MMO/PP/-417-/#FPT_TST_EXT.1.1

Signed-off-by: Elena Petrova <lenaptr@google.com>
---
 crypto/Kconfig   | 19 +++++++++++++++++++
 crypto/testmgr.c | 38 +++++++++++++++++++++++++++++++++++++-
 2 files changed, 56 insertions(+), 1 deletion(-)

diff --git a/crypto/Kconfig b/crypto/Kconfig
index a367fcfeb5d4..4985406f1342 100644
--- a/crypto/Kconfig
+++ b/crypto/Kconfig
@@ -32,6 +32,17 @@ config CRYPTO_FIPS
 	  certification.  You should say no unless you know what
 	  this is.
 
+config CRYPTO_NIAP_FPT_TST_EXT_11
+	bool "NIAP FPT_TST_EXT.1.1 compliance"
+	depends on CRYPTO_MANAGER
+	depends on CRYPTO_SHA512 && CRYPTO_HMAC
+	depends on CRYPTO_SHA256
+	depends on CRYPTO_AES && CRYPTO_CBC
+	help
+	  This option enables a set of self-tests to demonstrate
+	  the correct operation of cryptographic functionality, as
+	  required in NIAP FPT_TST_EXT.1.1.
+
 config CRYPTO_ALGAPI
 	tristate
 	select CRYPTO_ALGAPI2
@@ -153,6 +164,14 @@ config CRYPTO_MANAGER_EXTRA_TESTS
 	  This is intended for developer use only, as these tests take much
 	  longer to run than the normal self tests.
 
+config CRYPTO_MANAGER_NIAP_TESTS_ONLY
+	bool "Enable only NIAP FPT_TST_EXT.1 run-time self tests"
+	depends on !CRYPTO_MANAGER_DISABLE_TESTS && CRYPTO_NIAP_FPT_TST_EXT_11
+	default y
+	help
+	  Disable run-time self tests except for those required by
+	  NIAP FPT_TST_EXT.1.
+
 config CRYPTO_GF128MUL
 	tristate
 
diff --git a/crypto/testmgr.c b/crypto/testmgr.c
index 321e38eef51b..2abe140f265a 100644
--- a/crypto/testmgr.c
+++ b/crypto/testmgr.c
@@ -1919,6 +1919,7 @@ static int alg_test_hash(const struct alg_test_desc *desc, const char *driver,
 	return err;
 }
 
+#ifndef CONFIG_CRYPTO_MANAGER_NIAP_TESTS_ONLY
 static int test_aead_vec_cfg(int enc, const struct aead_testvec *vec,
 			     const char *vec_name,
 			     const struct testvec_config *cfg,
@@ -2597,6 +2598,7 @@ static int alg_test_aead(const struct alg_test_desc *desc, const char *driver,
 	crypto_free_aead(tfm);
 	return err;
 }
+#endif /* !CONFIG_CRYPTO_MANAGER_NIAP_TESTS_ONLY */
 
 static int test_cipher(struct crypto_cipher *tfm, int enc,
 		       const struct cipher_testvec *template,
@@ -3166,6 +3168,7 @@ static int alg_test_skcipher(const struct alg_test_desc *desc,
 	return err;
 }
 
+#ifndef CONFIG_CRYPTO_MANAGER_NIAP_TESTS_ONLY
 static int test_comp(struct crypto_comp *tfm,
 		     const struct comp_testvec *ctemplate,
 		     const struct comp_testvec *dtemplate,
@@ -3502,6 +3505,7 @@ static int test_cprng(struct crypto_rng *tfm,
 	kfree(seed);
 	return err;
 }
+#endif /* !CONFIG_CRYPTO_MANAGER_NIAP_TESTS_ONLY */
 
 static int alg_test_cipher(const struct alg_test_desc *desc,
 			   const char *driver, u32 type, u32 mask)
@@ -3525,6 +3529,7 @@ static int alg_test_cipher(const struct alg_test_desc *desc,
 	return err;
 }
 
+#ifndef CONFIG_CRYPTO_MANAGER_NIAP_TESTS_ONLY
 static int alg_test_comp(const struct alg_test_desc *desc, const char *driver,
 			 u32 type, u32 mask)
 {
@@ -4141,12 +4146,38 @@ static int alg_test_null(const struct alg_test_desc *desc,
 {
 	return 0;
 }
+#endif /* !CONFIG_CRYPTO_MANAGER_NIAP_TESTS_ONLY */
 
 #define ____VECS(tv)	.vecs = tv, .count = ARRAY_SIZE(tv)
 #define __VECS(tv)	{ ____VECS(tv) }
 
 /* Please keep this list sorted by algorithm name. */
 static const struct alg_test_desc alg_test_descs[] = {
+#ifdef CONFIG_CRYPTO_MANAGER_NIAP_TESTS_ONLY
+	/* Reduced list of algorithms for NIAP FPT_TST_EXT.1 */
+	{
+		.alg = "cbc(aes)",
+		.test = alg_test_skcipher,
+		.fips_allowed = 1,
+		.suite = {
+			.cipher = __VECS(aes_cbc_tv_template)
+		},
+	}, {
+		.alg = "hmac(sha512)",
+		.test = alg_test_hash,
+		.fips_allowed = 1,
+		.suite = {
+			.hash = __VECS(hmac_sha512_tv_template)
+		}
+	}, {
+		.alg = "sha256",
+		.test = alg_test_hash,
+		.fips_allowed = 1,
+		.suite = {
+			.hash = __VECS(sha256_tv_template)
+		}
+	}
+#else /* !CONFIG_CRYPTO_MANAGER_NIAP_TESTS_ONLY */
 	{
 		.alg = "adiantum(xchacha12,aes)",
 		.generic_driver = "adiantum(xchacha12-generic,aes-generic,nhpoly1305-generic)",
@@ -5544,6 +5575,7 @@ static const struct alg_test_desc alg_test_descs[] = {
 			}
 		}
 	}
+#endif /* !CONFIG_CRYPTO_MANAGER_NIAP_TESTS_ONLY */
 };
 
 static void alg_check_test_descs_order(void)
@@ -5671,10 +5703,14 @@ int alg_test(const char *driver, const char *alg, u32 type, u32 mask)
 			      driver, alg,
 			      fips_enabled ? "fips" : "panic_on_fail");
 		}
+		if (IS_ENABLED(CONFIG_CRYPTO_NIAP_FPT_TST_EXT_11))
+			panic("alg: self-tests for %s (%s) failed in NIAP mode!\n",
+			      driver, alg);
+
 		WARN(1, "alg: self-tests for %s (%s) failed (rc=%d)",
 		     driver, alg, rc);
 	} else {
-		if (fips_enabled)
+		if (fips_enabled || IS_ENABLED(CONFIG_CRYPTO_NIAP_FPT_TST_EXT_11))
 			pr_info("alg: self-tests for %s (%s) passed\n",
 				driver, alg);
 	}
-- 
2.30.0.284.gd98b1dd5eaa7-goog

