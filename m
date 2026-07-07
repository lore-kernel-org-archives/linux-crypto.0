Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E4D7938AC8C;
	Tue,  7 Jul 2026 05:37:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783402643; cv=none; b=WHyUL1COSPCrmoxcOfHvkLPTMhqYONiyNjaaCEMvuGXqSzQvUal6dhXAfp4tUw1W0aBeJNWNn8ZpMmvyd7G4qhkQjLcaK+G7hDctGxN2E2V7y1THCFecIC7WuVT/jtWM4vU2TxU18r23DYY+6Vx70blwDLQahRGQ0qKktKNE50U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783402643; c=relaxed/simple;
	bh=yrbKVhe3VXAay4TDhNOuz0sbhfW7X5+ZrtZWtRQjORs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=czLiHOo2RHIoT2KefctiTtdtnARhfBELFlJ32qBe9a/owr0SMmaLFPZki2IbZHuGJw1PT2CNcU2z4Pio6nhQIsN163ZNutLoaNTmK9inweiXSwUilbygs1sZEkuiM+9Kd0GqZ1+Jrc7NfY50yyCU9jSV3QAuGXUeuRA+1Sz4cYQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=RYZITeYP; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="RYZITeYP"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B03CE1F00ACF;
	Tue,  7 Jul 2026 05:37:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1783402640;
	bh=VA2RzTHA5LTqo/2Lcs1YbHaNRs0VEpMdFLPSxQizc6w=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=RYZITeYP3gzlr8dCO4D6YJxsstbqvvqgY4PxrSvEpAbp/caOAczaDVcGQ54gwgSCo
	 cBGocPlL3FsFNV721o2WWFXtKdf1WcVHN9DV/oKT+Nn2Nk7Etuf+n8/0QTG+3SA0yH
	 mT5/SA4bDMYfbJZ7+sa8e0Z0VOCdKycU8SNLlgbGZAR1RssiXxI/eC8yYR+F2UQ0h+
	 g9LQeohGCibq/gwPzt1OKfDfIIPtNlFujzUtUjp21dPBGnJqkEhIcCB5+Et/llyjkj
	 Nce80wqzbHQoGVb+A49mc7qKUYc90sN96aYY9YNvnmSjHAtlhG7bM9PtjYY/7N8qVs
	 5yuIKsg/HTrJQ==
From: Eric Biggers <ebiggers@kernel.org>
To: linux-crypto@vger.kernel.org
Cc: linux-kernel@vger.kernel.org,
	Eric Biggers <ebiggers@kernel.org>
Subject: [PATCH 17/33] lib/crypto: aes: Remove aes_cbcmac_* functions
Date: Mon,  6 Jul 2026 22:34:47 -0700
Message-ID: <20260707053503.209874-18-ebiggers@kernel.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260707053503.209874-1-ebiggers@kernel.org>
References: <20260707053503.209874-1-ebiggers@kernel.org>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

The aes_cbcmac_* functions are no longer used, except by their KUnit
test, since their functionality was folded directly into the AES-CCM
library code.  Remove them.

Note that the aes_cmac_* and aes_xcbcmac_* functions remain unchanged.

Signed-off-by: Eric Biggers <ebiggers@kernel.org>
---
 include/crypto/aes-cbc-macs.h         | 22 +--------
 lib/crypto/aes.c                      | 43 -----------------
 lib/crypto/tests/aes_cbc_macs_kunit.c | 68 +--------------------------
 3 files changed, 2 insertions(+), 131 deletions(-)

diff --git a/include/crypto/aes-cbc-macs.h b/include/crypto/aes-cbc-macs.h
index e61df108b926..95bbb8603420 100644
--- a/include/crypto/aes-cbc-macs.h
+++ b/include/crypto/aes-cbc-macs.h
@@ -1,6 +1,6 @@
 /* SPDX-License-Identifier: GPL-2.0 */
 /*
- * Support for AES-CMAC, AES-XCBC-MAC, and AES-CBC-MAC
+ * Support for AES-CMAC and AES-XCBC-MAC
  *
  * Copyright 2026 Google LLC
  */
@@ -131,24 +131,4 @@ static inline void aes_cmac(const struct aes_cmac_key *key, const u8 *data,
 	aes_cmac_final(&ctx, out);
 }
 
-/*
- * AES-CBC-MAC support.  This is provided only for use by the implementation of
- * AES-CCM.  It should have no other users.  Warning: unlike AES-CMAC and
- * AES-XCBC-MAC, AES-CBC-MAC isn't a secure MAC for variable-length messages.
- */
-struct aes_cbcmac_ctx {
-	const struct aes_enckey *key;
-	size_t partial_len;
-	u8 h[AES_BLOCK_SIZE];
-};
-static inline void aes_cbcmac_init(struct aes_cbcmac_ctx *ctx,
-				   const struct aes_enckey *key)
-{
-	*ctx = (struct aes_cbcmac_ctx){ .key = key };
-}
-void aes_cbcmac_update(struct aes_cbcmac_ctx *ctx, const u8 *data,
-		       size_t data_len);
-void aes_cbcmac_final(struct aes_cbcmac_ctx *ctx,
-		      u8 out[at_least AES_BLOCK_SIZE]);
-
 #endif /* _CRYPTO_AES_CBC_MACS_H */
diff --git a/lib/crypto/aes.c b/lib/crypto/aes.c
index 1a1b32e41ac1..aeefd55eacaa 100644
--- a/lib/crypto/aes.c
+++ b/lib/crypto/aes.c
@@ -674,49 +674,6 @@ void aes_cmac_final(struct aes_cmac_ctx *ctx, u8 out[AES_BLOCK_SIZE])
 }
 EXPORT_SYMBOL_GPL(aes_cmac_final);
 
-void aes_cbcmac_update(struct aes_cbcmac_ctx *ctx, const u8 *data,
-		       size_t data_len)
-{
-	bool enc_before = false;
-	size_t nblocks;
-
-	if (ctx->partial_len) {
-		size_t l = min(data_len, AES_BLOCK_SIZE - ctx->partial_len);
-
-		crypto_xor(&ctx->h[ctx->partial_len], data, l);
-		data += l;
-		data_len -= l;
-		ctx->partial_len += l;
-		if (ctx->partial_len < AES_BLOCK_SIZE)
-			return;
-		enc_before = true;
-	}
-
-	nblocks = data_len / AES_BLOCK_SIZE;
-	data_len %= AES_BLOCK_SIZE;
-	if (nblocks == 0) {
-		if (enc_before)
-			aes_encrypt(ctx->key, ctx->h, ctx->h);
-	} else {
-		aes_cbcmac_blocks(ctx->h, ctx->key, data, nblocks, enc_before,
-				  /* enc_after= */ true);
-		data += nblocks * AES_BLOCK_SIZE;
-	}
-	crypto_xor(ctx->h, data, data_len);
-	ctx->partial_len = data_len;
-}
-EXPORT_SYMBOL_NS_GPL(aes_cbcmac_update, "CRYPTO_INTERNAL");
-
-void aes_cbcmac_final(struct aes_cbcmac_ctx *ctx, u8 out[AES_BLOCK_SIZE])
-{
-	if (ctx->partial_len)
-		aes_encrypt(ctx->key, out, ctx->h);
-	else
-		memcpy(out, ctx->h, AES_BLOCK_SIZE);
-	memzero_explicit(ctx, sizeof(*ctx));
-}
-EXPORT_SYMBOL_NS_GPL(aes_cbcmac_final, "CRYPTO_INTERNAL");
-
 /*
  * FIPS cryptographic algorithm self-test for AES-CMAC.  As per the FIPS 140-3
  * Implementation Guidance, a cryptographic algorithm self-test for at least one
diff --git a/lib/crypto/tests/aes_cbc_macs_kunit.c b/lib/crypto/tests/aes_cbc_macs_kunit.c
index ae3745212f03..97a4594895c2 100644
--- a/lib/crypto/tests/aes_cbc_macs_kunit.c
+++ b/lib/crypto/tests/aes_cbc_macs_kunit.c
@@ -141,75 +141,10 @@ static void test_aes_xcbcmac_rfc3566(struct kunit *test)
 	KUNIT_ASSERT_MEMEQ(test, actual_mac, expected_mac, AES_BLOCK_SIZE);
 }
 
-static void test_aes_cbcmac_rfc3610(struct kunit *test)
-{
-	/*
-	 * The following AES-CBC-MAC test vector is extracted from RFC 3610
-	 * Packet Vector #11.  It required some rearrangement to get the actual
-	 * input to AES-CBC-MAC from the values given.
-	 */
-	static const u8 raw_key[AES_KEYSIZE_128] = {
-		0xc0, 0xc1, 0xc2, 0xc3, 0xc4, 0xc5, 0xc6, 0xc7,
-		0xc8, 0xc9, 0xca, 0xcb, 0xcc, 0xcd, 0xce, 0xcf,
-	};
-	const size_t unpadded_data_len = 52;
-	static const u8 data[64] = {
-		/* clang-format off */
-		/* CCM header */
-		0x61, 0x00, 0x00, 0x00, 0x0d, 0x0c, 0x0b, 0x0a,
-		0xa0, 0xa1, 0xa2, 0xa3, 0xa4, 0xa5, 0x00, 0x14,
-		/* CCM additional authentication blocks */
-		0x00, 0x0c, 0x00, 0x01, 0x02, 0x03, 0x04, 0x05,
-		0x06, 0x07, 0x08, 0x09, 0x0a, 0x0b, 0x00, 0x00,
-		/* CCM message blocks */
-		0x0c, 0x0d, 0x0e, 0x0f, 0x10, 0x11, 0x12, 0x13,
-		0x14, 0x15, 0x16, 0x17, 0x18, 0x19, 0x1a, 0x1b,
-		0x1c, 0x1d, 0x1e, 0x1f, 0x00, 0x00, 0x00, 0x00,
-		0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
-		/* clang-format on */
-	};
-	static const u8 expected_mac[AES_BLOCK_SIZE] = {
-		0x6b, 0x5e, 0x24, 0x34, 0x12, 0xcc, 0xc2, 0xad,
-		0x6f, 0x1b, 0x11, 0xc3, 0xa1, 0xa9, 0xd8, 0xbc,
-	};
-	struct aes_enckey key;
-	struct aes_cbcmac_ctx ctx;
-	u8 actual_mac[AES_BLOCK_SIZE];
-	int err;
-
-	err = aes_prepareenckey(&key, raw_key, sizeof(raw_key));
-	KUNIT_ASSERT_EQ(test, err, 0);
-
-	/*
-	 * Trailing zeroes should not affect the CBC-MAC value, up to the next
-	 * AES block boundary.
-	 */
-	for (size_t data_len = unpadded_data_len; data_len <= sizeof(data);
-	     data_len++) {
-		aes_cbcmac_init(&ctx, &key);
-		aes_cbcmac_update(&ctx, data, data_len);
-		aes_cbcmac_final(&ctx, actual_mac);
-		KUNIT_ASSERT_MEMEQ(test, actual_mac, expected_mac,
-				   AES_BLOCK_SIZE);
-
-		/* Incremental computations should produce the same result. */
-		for (size_t part1_len = 0; part1_len <= data_len; part1_len++) {
-			aes_cbcmac_init(&ctx, &key);
-			aes_cbcmac_update(&ctx, data, part1_len);
-			aes_cbcmac_update(&ctx, &data[part1_len],
-					  data_len - part1_len);
-			aes_cbcmac_final(&ctx, actual_mac);
-			KUNIT_ASSERT_MEMEQ(test, actual_mac, expected_mac,
-					   AES_BLOCK_SIZE);
-		}
-	}
-}
-
 static struct kunit_case aes_cbc_macs_test_cases[] = {
 	HASH_KUNIT_CASES,
 	KUNIT_CASE(test_aes_cmac_rfc4493),
 	KUNIT_CASE(test_aes_xcbcmac_rfc3566),
-	KUNIT_CASE(test_aes_cbcmac_rfc3610),
 	KUNIT_CASE(benchmark_hash),
 	{},
 };
@@ -222,7 +157,6 @@ static struct kunit_suite aes_cbc_macs_test_suite = {
 };
 kunit_test_suite(aes_cbc_macs_test_suite);
 
-MODULE_DESCRIPTION(
-	"KUnit tests and benchmark for AES-CMAC, AES-XCBC-MAC, and AES-CBC-MAC");
+MODULE_DESCRIPTION("KUnit tests and benchmark for AES-CMAC and AES-XCBC-MAC");
 MODULE_IMPORT_NS("CRYPTO_INTERNAL");
 MODULE_LICENSE("GPL");
-- 
2.54.0

