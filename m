Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 226883932C6;
	Mon, 20 Apr 2026 06:37:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776667030; cv=none; b=PVfGO5j6LCD2uCoPxcY/iSiqtOq6D107m4dDHl2sAssYlqUyJ4LIKIEOLgmTtweH6cjDRjAjQB0HWztFVM4Kgkwx+IW3kwA/hfEOKXNszXKmzbBCR6pcJHWGtfb6tMifZ7iUwK19CqEUlRw1PgJothfxFTDHRu7Z3FGaNg2r708=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776667030; c=relaxed/simple;
	bh=x1ZDX9DkW5kEc9+Yw+UgtvVpuDEP0zsoLM7/n0ZCUUc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=TfYyl3w4A9P3URoodUuAMOyAbDT66ezobO7p+8J0L+KTzJlYCkEnyS39746Swu/HBcKhesWwJLWfx1h7j7qrlVVFadVwpOawI9iLA7pk1YfcNSpBf86QGufnqnCRSVQZ3tt4FHe/ShuWBsp6ZTGivAiSw6Sfq53mkxOnhhXF6Ng=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=ZBD2WzN4; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="ZBD2WzN4"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C1748C2BCB8;
	Mon, 20 Apr 2026 06:37:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1776667030;
	bh=x1ZDX9DkW5kEc9+Yw+UgtvVpuDEP0zsoLM7/n0ZCUUc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ZBD2WzN4t2oglF8qP+SPl9fkgdI0JhUl8FW9V77gHZXfL+7JMRmxx3t5TRm1BfRmX
	 0VGfoud2XFK76pBsr4B6m4vqatDQVB2HSPX1lupslt/p1N8sOoRDnUIo5PvSQF++0p
	 dpwhIdEiRr1VqXpJ4M0+CyNUwwHqdr2c602dB1rBFJ5NwYCqYmMewob9B7OBajB4Lj
	 N7CVmoGmKI/KZ3KQmZanyhaBbKHtMhoQeOuhlDZCQvcZlKVB9iZ5Gzd/QWxlWVRR98
	 cg8RU8iSOik1pCjwFjuzrZVXwtrHQC6HoJN/DHvv1lLffQtmQ+gOI3xsIP6WqQiOb9
	 2ZebusNc6qpOA==
From: Eric Biggers <ebiggers@kernel.org>
To: linux-crypto@vger.kernel.org,
	Herbert Xu <herbert@gondor.apana.org.au>
Cc: linux-kernel@vger.kernel.org,
	Stephan Mueller <smueller@chronox.de>,
	"Jason A . Donenfeld" <Jason@zx2c4.com>,
	Eric Biggers <ebiggers@kernel.org>
Subject: [PATCH 34/38] crypto: drbg - Include get_random_bytes() output in additional input
Date: Sun, 19 Apr 2026 23:34:18 -0700
Message-ID: <20260420063422.324906-35-ebiggers@kernel.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260420063422.324906-1-ebiggers@kernel.org>
References: <20260420063422.324906-1-ebiggers@kernel.org>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Woodage & Shumow (2018) (https://eprint.iacr.org/2018/349.pdf) showed
that contrary to the claims made by NIST in SP800-90A, HMAC_DRBG doesn't
satisfy the formal definition of forward secrecy (i.e. "backtracking
resistance") when it's called with an empty additional input string.

The actual attack seems pretty benign, as it doesn't actually give the
attacker any previous RNG output, but rather just allows them to test
whether their guess of the previous block of RNG output is correct.
Regardless, it's an annoying design flaw, and it's yet another example
of why NIST's DRBGs aren't all that great.

Meanwhile, the kernel's HMAC_DRBG code also tries to reseed itself
automatically after random.c has reseeded itself.  But the
implementation is buggy, as it just checks whether 300 seconds have
elapsed, rather than looking at the actual generation counter.

Let's just follow the example of BoringSSL and use the conservative
approach of always including 32 bytes of "regular" random data in the
additional input string.  This fixes both issues described above.

This does reduce performance.  But this should be tolerable, since:

  - Due to earlier changes, the kernel code that was previously using
    drbg.c regardless of FIPS mode is now using it only in FIPS mode.

  - The additional input string is processed only once per request.  So
    if a lot of bytes are generated at once, the cost is amortized.

  - The NIST DRBGs are notoriously slow anyway.

Note that this fix should have no impact (either positive or negative)
on FIPS 140 certifiability.  From FIPS's point of view the code added by
this commit simply doesn't matter: it adds zero entropy to something
that doesn't need to contain entropy.

Fixes: 541af946fe13 ("crypto: drbg - SP800-90A Deterministic Random Bit Generator")
Signed-off-by: Eric Biggers <ebiggers@kernel.org>
---
 crypto/drbg.c | 29 +++++++++++++++++++++++++----
 1 file changed, 25 insertions(+), 4 deletions(-)

diff --git a/crypto/drbg.c b/crypto/drbg.c
index b2af481aef01..cda79d601f4f 100644
--- a/crypto/drbg.c
+++ b/crypto/drbg.c
@@ -191,17 +191,36 @@ static void drbg_hmac_update(struct drbg_state *drbg,
 
 /* generate function of HMAC DRBG as defined in 10.1.2.5 */
 static void drbg_hmac_generate(struct drbg_state *drbg,
 			       unsigned char *buf,
 			       unsigned int buflen,
-			       const u8 *addtl, size_t addtl_len)
+			       const u8 *addtl1, size_t addtl1_len)
 {
 	int len = 0;
+	u8 addtl2[32];
+	size_t addtl2_len = 0;
+
+	/*
+	 * Append some bytes from get_random_bytes() to the additional input
+	 * string, except when in test mode (as it would break the tests).
+	 * Using a nonempty additional input string works around the forward
+	 * secrecy bug in HMAC_DRBG described by Woodage & Shumow (2018)
+	 * (https://eprint.iacr.org/2018/349.pdf).  Filling the string with
+	 * get_random_bytes() rather than a fixed value is safer still, and in
+	 * particular makes random.c reseeds be immediately reflected.
+	 *
+	 * Note that there's no need to pull bytes from jitterentropy here too,
+	 * since FIPS doesn't require any entropy in the additional input.
+	 */
+	if (drbg->test_entropylen == 0) {
+		get_random_bytes(addtl2, sizeof(addtl2));
+		addtl2_len = sizeof(addtl2);
+	}
 
 	/* 10.1.2.5 step 2 */
-	if (addtl_len)
-		drbg_hmac_update(drbg, addtl, addtl_len, NULL, 0);
+	if (addtl1_len || addtl2_len)
+		drbg_hmac_update(drbg, addtl1, addtl1_len, addtl2, addtl2_len);
 
 	while (len < buflen) {
 		unsigned int outlen = 0;
 
 		/* 10.1.2.5 step 4.1 */
@@ -213,11 +232,13 @@ static void drbg_hmac_generate(struct drbg_state *drbg,
 		memcpy(buf + len, drbg->V, outlen);
 		len += outlen;
 	}
 
 	/* 10.1.2.5 step 6 */
-	drbg_hmac_update(drbg, addtl, addtl_len, NULL, 0);
+	drbg_hmac_update(drbg, addtl1, addtl1_len, addtl2, addtl2_len);
+
+	memzero_explicit(addtl2, sizeof(addtl2));
 }
 
 static inline void __drbg_seed(struct drbg_state *drbg,
 			       const u8 *seed1, size_t seed1_len,
 			       const u8 *seed2, size_t seed2_len,
-- 
2.53.0

