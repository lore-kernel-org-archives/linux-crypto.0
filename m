Received: from mail-yb1-f202.google.com (mail-yb1-f202.google.com [209.85.219.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A9D1D142E77
	for <linux-crypto@vger.kernel.org>; Tue, 15 Oct 2024 14:15:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.219.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729001729; cv=none; b=TFOMHIEvvr31EztdhPSJzIwydsCs3XY8SjZ4WhLk+9hvaX89j0Ekhs/beqUErgPPEl4VT7p9g8kRPO/+Xl3LbfvpdgD/jBCclsKY3w451pqLEaYKY6a5BUwKVfEgxk1scEQMGfIXkX6wL6r7VQtJnL95tHFDaZdtizkdF1g2c6Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729001729; c=relaxed/simple;
	bh=+TReaEdQsfZfrNMi/7zSZ3UXpXhQF8S+L8H6Bog6rgw=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=ME1Tq4KZB5Tu+PVPcVpzPiHn56m329Zvw5ZsBZnC0A/ZUqABoDtNrZY4WskGtOksRsN5o0CXDgysxLCpNDxcN+MvuXG+qL50rvXoSiPE9bIYaU7jM9sY2BZw9Fna0xQYHVrxxEK9MPwpB6ozlCKgWvzJCTYK4bYbXdFP3W9KQbk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--ardb.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=jLIttgT2; arc=none smtp.client-ip=209.85.219.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--ardb.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="jLIttgT2"
Received: by mail-yb1-f202.google.com with SMTP id 3f1490d57ef6-e0b8fa94718so7600795276.0
        for <linux-crypto@vger.kernel.org>; Tue, 15 Oct 2024 07:15:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1729001726; x=1729606526; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=4T99DahR2DAaxzHSfzgz+6ZZ8SutcvhdH+1X2CM2O5k=;
        b=jLIttgT2FdjpZ5jw98q3S0pQ19orSPBPkByLr+DRMtEm9Mr3Zh1Ly1R2N246kP3ow0
         sCyeQl76MvZfVKRmpH2h1OauqL0SDvUySH8Lm5XLWgXlhb0Yi3RgcqEbcZl8m+iJlmDc
         gwoZYDS1oPqRYlgAHNfcLw1qFJv8kg2RULMePNY8aD/ZYR6eNBcTHRzxgg4zV+JKaIR2
         qnJ85bvLwNMTwtl/bs24HFLO/6andhf2XJLGnnPEiZXOlsPl6Z28wRI5NPPddNrArthR
         pC8oUVtt8k4pGO4UNjPt0wbMfrhGeNmvxIgdHpW8SzbYb/1ckJplo6Ht+81OUngOwVic
         UX5A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1729001726; x=1729606526;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=4T99DahR2DAaxzHSfzgz+6ZZ8SutcvhdH+1X2CM2O5k=;
        b=NPxdn/p6HH2H4On3OLbN4AyJt+ZygOwrdOm+s+0ZYl6J70hSrMP0qFawuGbl16uPYX
         3/8Otss8w9yhUkZVZ1NUN8M5uqmP41tjk5N5dBADKekMbGmiodr3W2nNG6RjXijqM+mT
         Ikj1skv3aCvLrxGKzA6r5uJJN8rr9RE5NHRS5KUIu2zVoqHyd3HVpNJfN3G/ktoIvTy3
         6Nudf+B5Vw1nq3LcwGkPhjHkjIGGhMuiWNwGPLIBUoIfNMBxrH1TkkNHUmCSsBRnhdpU
         iHGC0dOR4nnd+CWT7wijKwXc+DSt7IlPJJvAAW0ILGrjhcCqxDNrhDEpfMu7qxYtc6rM
         I96Q==
X-Gm-Message-State: AOJu0YzA8CrCQeBPGMhaiAnsn7bVzn3YgFKCibG/uoMEmuNr8SzINm5C
	GOKgoWGvi6Seo0izNfuiRt3vS0b4qs5y5VCr0i1dDAtL0O4DQjx29f0giRIF7uEm2YVr20Z4zgi
	W3eBlVwyasWCXp+uVCphrjfHhtoJuTKhlnYHOgwZXbMJnJORpJike3+i7ugH4NHLrCoTMocRAiv
	5blDqLzPcMt836reA9JK28SruaDUwmnw==
X-Google-Smtp-Source: AGHT+IHpRl7iGygSVJTMVxqOLrNAyCcgeEoqscUVKafaM0lCr65ygf/DLGMDcfgWgdbt5E6dkHzUqliz
X-Received: from palermo.c.googlers.com ([fda3:e722:ac3:cc00:7b:198d:ac11:8138])
 (user=ardb job=sendgmr) by 2002:a25:b601:0:b0:e28:f8e6:f4c6 with SMTP id
 3f1490d57ef6-e29782b025emr205276.2.1729001725922; Tue, 15 Oct 2024 07:15:25
 -0700 (PDT)
Date: Tue, 15 Oct 2024 16:15:16 +0200
In-Reply-To: <20241015141514.3000757-4-ardb+git@google.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20241015141514.3000757-4-ardb+git@google.com>
X-Developer-Key: i=ardb@kernel.org; a=openpgp; fpr=F43D03328115A198C90016883D200E9CA6329909
X-Developer-Signature: v=1; a=openpgp-sha256; l=3957; i=ardb@kernel.org;
 h=from:subject; bh=DkMuhLyEdXzGQv+7T0r8x/uwmKJEbsIifEEQjFZBuxM=;
 b=owGbwMvMwCFmkMcZplerG8N4Wi2JIZ2v4nOmYb0TxwHb4zWBh/InKZ/bI9at/SbG4NjPM+6H/
 SeujjboKGVhEONgkBVTZBGY/ffdztMTpWqdZ8nCzGFlAhnCwMUpABNxmsrw3zf/K9fTOWm6z41W
 Lf8x7TZ3GGvEziaxRSmyaZr20+RVixgZttpIvtR+f+hG5qrtr3gOPj5stfnLrm13WTw7so4+f3H Omh8A
X-Mailer: git-send-email 2.47.0.rc1.288.g06298d1525-goog
Message-ID: <20241015141514.3000757-5-ardb+git@google.com>
Subject: [PATCH 1/2] crypto/crc32: Provide crc32-base alias to enable fuzz testing
From: Ard Biesheuvel <ardb+git@google.com>
To: linux-crypto@vger.kernel.org
Cc: ebiggers@kernel.org, herbert@gondor.apana.org.au, 
	Ard Biesheuvel <ardb@kernel.org>
Content-Type: text/plain; charset="UTF-8"

From: Ard Biesheuvel <ardb@kernel.org>

crc32-generic is backed by the architecture's CRC-32 library, which may
offer a variety of implementations depending on the capabilities of the
platform. These are not covered by the crypto subsystem's fuzz testing
capabilities because crc32-generic is the reference driver that the
fuzzing logic uses as a source of truth.

Fix this by proving a crc32-base implementation which is always based on
the generic C implementation, and wire it up as the reference
implementation for the fuzz tester.

Signed-off-by: Ard Biesheuvel <ardb@kernel.org>
---
 crypto/crc32_generic.c | 73 ++++++++++++++------
 crypto/testmgr.c       |  1 +
 2 files changed, 52 insertions(+), 22 deletions(-)

diff --git a/crypto/crc32_generic.c b/crypto/crc32_generic.c
index d1251663ed66..73948ce96ac7 100644
--- a/crypto/crc32_generic.c
+++ b/crypto/crc32_generic.c
@@ -63,6 +63,17 @@ static int crc32_update(struct shash_desc *desc, const u8 *data,
 	return 0;
 }
 
+#ifdef CONFIG_CRYPTO_MANAGER_EXTRA_TESTS
+static int crc32_update_base(struct shash_desc *desc, const u8 *data,
+			     unsigned int len)
+{
+	u32 *crcp = shash_desc_ctx(desc);
+
+	*crcp = crc32_le_base(*crcp, data, len);
+	return 0;
+}
+#endif
+
 /* No final XOR 0xFFFFFFFF, like crc32_le */
 static int __crc32_finup(u32 *crcp, const u8 *data, unsigned int len,
 			 u8 *out)
@@ -91,35 +102,53 @@ static int crc32_digest(struct shash_desc *desc, const u8 *data,
 	return __crc32_finup(crypto_shash_ctx(desc->tfm), data, len,
 			     out);
 }
-static struct shash_alg alg = {
-	.setkey		= crc32_setkey,
-	.init		= crc32_init,
-	.update		= crc32_update,
-	.final		= crc32_final,
-	.finup		= crc32_finup,
-	.digest		= crc32_digest,
-	.descsize	= sizeof(u32),
-	.digestsize	= CHKSUM_DIGEST_SIZE,
-	.base		= {
-		.cra_name		= "crc32",
-		.cra_driver_name	= "crc32-generic",
-		.cra_priority		= 100,
-		.cra_flags		= CRYPTO_ALG_OPTIONAL_KEY,
-		.cra_blocksize		= CHKSUM_BLOCK_SIZE,
-		.cra_ctxsize		= sizeof(u32),
-		.cra_module		= THIS_MODULE,
-		.cra_init		= crc32_cra_init,
-	}
-};
+static struct shash_alg algs[] = {{
+	.setkey			= crc32_setkey,
+	.init			= crc32_init,
+	.update			= crc32_update,
+	.final			= crc32_final,
+	.finup			= crc32_finup,
+	.digest			= crc32_digest,
+	.descsize		= sizeof(u32),
+	.digestsize		= CHKSUM_DIGEST_SIZE,
+
+	.base.cra_name		= "crc32",
+	.base.cra_driver_name	= "crc32-generic",
+	.base.cra_priority	= 100,
+	.base.cra_flags		= CRYPTO_ALG_OPTIONAL_KEY,
+	.base.cra_blocksize	= CHKSUM_BLOCK_SIZE,
+	.base.cra_ctxsize	= sizeof(u32),
+	.base.cra_module	= THIS_MODULE,
+	.base.cra_init		= crc32_cra_init,
+#ifdef CONFIG_CRYPTO_MANAGER_EXTRA_TESTS
+}, {
+	.setkey			= crc32_setkey,
+	.init			= crc32_init,
+	.update			= crc32_update_base,
+	.final			= crc32_final,
+	.digest			= crc32_digest,
+	.descsize		= sizeof(u32),
+	.digestsize		= CHKSUM_DIGEST_SIZE,
+
+	.base.cra_name		= "crc32",
+	.base.cra_driver_name	= "crc32-base",
+	.base.cra_flags		= CRYPTO_ALG_OPTIONAL_KEY,
+	.base.cra_blocksize	= CHKSUM_BLOCK_SIZE,
+	.base.cra_ctxsize	= sizeof(u32),
+	.base.cra_module	= THIS_MODULE,
+	.base.cra_init		= crc32_cra_init,
+#endif
+}};
 
 static int __init crc32_mod_init(void)
 {
-	return crypto_register_shash(&alg);
+	return crypto_register_shashes(algs, ARRAY_SIZE(algs));
 }
 
 static void __exit crc32_mod_fini(void)
 {
-	crypto_unregister_shash(&alg);
+	crypto_unregister_shashes(algs, ARRAY_SIZE(algs));
+
 }
 
 subsys_initcall(crc32_mod_init);
diff --git a/crypto/testmgr.c b/crypto/testmgr.c
index ee8da628e9da..e0d6bfcc13e6 100644
--- a/crypto/testmgr.c
+++ b/crypto/testmgr.c
@@ -4692,6 +4692,7 @@ static const struct alg_test_desc alg_test_descs[] = {
 		.test = alg_test_null,
 	}, {
 		.alg = "crc32",
+		.generic_driver = "crc32-base",
 		.test = alg_test_hash,
 		.fips_allowed = 1,
 		.suite = {
-- 
2.47.0.rc1.288.g06298d1525-goog

