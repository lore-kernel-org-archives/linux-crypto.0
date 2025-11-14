Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0F021224891
	for <linux-crypto@vger.kernel.org>; Fri, 14 Nov 2025 03:05:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763089535; cv=none; b=CAyVxvWBUvP++Ygv9Zswc5cHCV8YTvCydd2GHgecVHMJyRVpc2GeH/oQ1lg6b4k2uMhYCseYB+tC8EBB4qu5JGqvhKBreEtLLSzue6YovgC8DrVk83vr0fVunx0HLjTc3j7hUQG97zhdIHSILn+yGn6iM81LG/EhEBtUIivGMCQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763089535; c=relaxed/simple;
	bh=5O/W/dl4bq31l4eY6tAFjIQTWRaaCaZ7pEPAcg8oa+U=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=bQi9lck2nCCL5uXenEDbh656uT8j+y7N3e8X+fXCSj9VrrRpK0TIyyTBzIMuXHfNSOCFdoiGAksoZq8xmcXLR7qquSMR1gBdiDudntswr6vjeEgj9JbDWc56HwJTqus1vsC9sCac0sHrvY/nME9wSiNX5q/bjxxjzDJpc0XSsK4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=hl8sJPpj; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="hl8sJPpj"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6B719C4CEF8;
	Fri, 14 Nov 2025 03:05:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1763089534;
	bh=5O/W/dl4bq31l4eY6tAFjIQTWRaaCaZ7pEPAcg8oa+U=;
	h=From:To:Cc:Subject:Date:From;
	b=hl8sJPpjH6bkaQUuHnQ2sMrPWEc09PBK8+4Q/q8r2JYCJqDbKwEfvf4oBFpqI5xke
	 kXyBxmS6R8ea924/xPM1fToWMUyoQdjMZVjmZKE6SwJWSxDZTnOdFNVem4ufP2ACwQ
	 GZ+xKPMKs63OBPZfUBTI85Sx3WT+WUNxnWSLo+Usgykf/wo3Indo/kXhNGy7D9QNU2
	 Sd89Jmp1NkAnirN/YunBbqSIl3T8BkNBSvdP5ikxwO/aYefHKZHxt54B2GaaVJZJq4
	 QA5tGPlFbkjdIQCrEu+ek1aXpQeEjDWtBI/cn9FRtiPrBluKfJNNj4jODQF4I5QNET
	 4XZPvLQZ4QC5w==
From: Eric Biggers <ebiggers@kernel.org>
To: linux-crypto@vger.kernel.org,
	Herbert Xu <herbert@gondor.apana.org.au>
Cc: Eric Biggers <ebiggers@kernel.org>
Subject: [PATCH] crypto: tcrypt - Remove unused poly1305 support
Date: Thu, 13 Nov 2025 19:03:44 -0800
Message-ID: <20251114030344.235748-1-ebiggers@kernel.org>
X-Mailer: git-send-email 2.51.2
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Since the crypto_shash support for poly1305 was removed, the tcrypt
support for it is now unused as well.  Support for benchmarking the
kernel's Poly1305 code is now provided by the poly1305 kunit test.

Signed-off-by: Eric Biggers <ebiggers@kernel.org>
---

This patch is targeting cryptodev/master

 crypto/tcrypt.c |  4 ----
 crypto/tcrypt.h | 18 ------------------
 2 files changed, 22 deletions(-)

diff --git a/crypto/tcrypt.c b/crypto/tcrypt.c
index d1d88debbd71..3baff6bfb9d1 100644
--- a/crypto/tcrypt.c
+++ b/crypto/tcrypt.c
@@ -2266,14 +2266,10 @@ static int do_test(const char *alg, u32 type, u32 mask, int m, u32 num_mb)
 		fallthrough;
 	case 319:
 		test_hash_speed("crc32c", sec, generic_hash_speed_template);
 		if (mode > 300 && mode < 400) break;
 		fallthrough;
-	case 321:
-		test_hash_speed("poly1305", sec, poly1305_speed_template);
-		if (mode > 300 && mode < 400) break;
-		fallthrough;
 	case 322:
 		test_hash_speed("sha3-224", sec, generic_hash_speed_template);
 		if (mode > 300 && mode < 400) break;
 		fallthrough;
 	case 323:
diff --git a/crypto/tcrypt.h b/crypto/tcrypt.h
index 7f938ac93e58..85c3f77bcfb4 100644
--- a/crypto/tcrypt.h
+++ b/crypto/tcrypt.h
@@ -94,24 +94,6 @@ static struct hash_speed generic_hash_speed_template[] = {
 
 	/* End marker */
 	{  .blen = 0,	.plen = 0, }
 };
 
-static struct hash_speed poly1305_speed_template[] = {
-	{ .blen = 96,	.plen = 16, },
-	{ .blen = 96,	.plen = 32, },
-	{ .blen = 96,	.plen = 96, },
-	{ .blen = 288,	.plen = 16, },
-	{ .blen = 288,	.plen = 32, },
-	{ .blen = 288,	.plen = 288, },
-	{ .blen = 1056,	.plen = 32, },
-	{ .blen = 1056,	.plen = 1056, },
-	{ .blen = 2080,	.plen = 32, },
-	{ .blen = 2080,	.plen = 2080, },
-	{ .blen = 4128,	.plen = 4128, },
-	{ .blen = 8224,	.plen = 8224, },
-
-	/* End marker */
-	{  .blen = 0,	.plen = 0, }
-};
-
 #endif	/* _CRYPTO_TCRYPT_H */

base-commit: d633730bb3873578a00fde4b97f9ac62a1be8d34
-- 
2.51.2

