Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BB0C86FBF;
	Wed,  6 May 2026 00:02:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778025772; cv=none; b=RHqF4EizJYxr4pb8z8CmltyoYk4NZLqsF06pdBx9Jor3ZcdUGtVU09DAPeBKJmGRQ7x8UIy02pmPf3LcLh/u6ZFRgICmUC9wlqEFL825PS99x0zpKiRdDhkqS/gB+k1yO5zjgSPKIlduse0rbbdzOj+DjZMEzwh9U4z50vPwpH8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778025772; c=relaxed/simple;
	bh=VrgSM6hLqVN3T6coQxFPgt3FUuLkduip1iNZqkdrMrc=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=MV/u28KYSa6aVH23B/14HKUkJIQdfuCzlPmHwKQ8v67IbmB5M9zm29Wpjdg4RhyF9cqg7T8ojKbWMN11/DTGZ8NZtLbnyF4Htn3SYaaplCyal5t2HzIyxHxWwDUPhUKH4cKfK7u53h6kp0+vrEOFONyP8AucB3GmcvHMGVOjoIg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Eb+QzXRL; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Eb+QzXRL"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D5BE5C2BCB4;
	Wed,  6 May 2026 00:02:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1778025772;
	bh=VrgSM6hLqVN3T6coQxFPgt3FUuLkduip1iNZqkdrMrc=;
	h=From:To:Cc:Subject:Date:From;
	b=Eb+QzXRLAnRaP4E/tABXHHA5wx4UX2p5eyqi/hXRzM+Q+7G4jHegRCdTG+F4u7DyL
	 GGQ4k+23iKNLYNtOfa9YDe4xAJ9UM46dH8YokDS6m3Ro2nV82c/S8C8KLj2Yvzjeoj
	 OspfVYr5uR5rFadXdM1AzwjOhp8qjSIb+5xrVcReiIiW965CP2Q5S5rd5Z8drtU60b
	 cw0FYKVM3Wg71joTMPf6Uw7Db6LPIRb67kXxI140bqdJkpOlwWI+UiSnR/gU7/+tB6
	 ZF+i9kAc/+EOWwLrWUw+OQzOTkQLA1IQ6yMwXkK9eV6yDKON1QnKbGmvsbFBl89fRj
	 0YBBMy30pXCdQ==
From: Eric Biggers <ebiggers@kernel.org>
To: linux-crypto@vger.kernel.org,
	Herbert Xu <herbert@gondor.apana.org.au>
Cc: linux-kernel@vger.kernel.org,
	Stephan Mueller <smueller@chronox.de>,
	"Jason A . Donenfeld" <Jason@zx2c4.com>,
	Eric Biggers <ebiggers@kernel.org>,
	Joachim Vandersmissen <joachim@jvdsn.com>
Subject: [PATCH] crypto: drbg - Rename MAX_ADDTL => MAX_ADDTL_BYTES
Date: Tue,  5 May 2026 17:02:17 -0700
Message-ID: <20260506000217.70738-1-ebiggers@kernel.org>
X-Mailer: git-send-email 2.54.0
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Give this constant a name which is clearer and consistent with
DRBG_MAX_REQUEST_BYTES.  No functional change.

Suggested-by: Joachim Vandersmissen <joachim@jvdsn.com>
Signed-off-by: Eric Biggers <ebiggers@kernel.org>
---
 crypto/drbg.c | 11 ++++++-----
 1 file changed, 6 insertions(+), 5 deletions(-)

diff --git a/crypto/drbg.c b/crypto/drbg.c
index ad7b9577479e..ab443be199a0 100644
--- a/crypto/drbg.c
+++ b/crypto/drbg.c
@@ -120,11 +120,11 @@
  * Maximum length of additional info and personalization strings, in bytes.
  * SP800-90A allows up to 2**35 bits, i.e. 2**32 bytes.  We use 2**32 - 2 bytes
  * so that the value never quite completely fills the range of a size_t,
  * allowing the health check to verify that larger values are rejected.
  */
-#define DRBG_MAX_ADDTL		(U32_MAX - 1)
+#define DRBG_MAX_ADDTL_BYTES	(U32_MAX - 1)
 
 struct drbg_state {
 	struct mutex drbg_mutex;	/* lock around DRBG */
 	u8 V[DRBG_STATE_LEN];		/* internal state -- 10.1.2.1 1a */
 	struct hmac_sha512_key key;	/* current key -- 10.1.2.1 1b */
@@ -235,11 +235,11 @@ static int drbg_seed(struct drbg_state *drbg, const u8 *pers, size_t pers_len,
 	u8 entropy_buf[(32 + 16) * 2];
 	size_t entropylen;
 	const u8 *entropy;
 
 	/* 9.1 / 9.2 / 9.3.1 step 3 */
-	if (pers_len > DRBG_MAX_ADDTL) {
+	if (pers_len > DRBG_MAX_ADDTL_BYTES) {
 		pr_devel("DRBG: personalization string too long %zu\n",
 			 pers_len);
 		return -EINVAL;
 	}
 
@@ -353,11 +353,11 @@ static int drbg_generate(struct drbg_state *drbg, u8 *out, size_t outlen,
 	}
 
 	/* 9.3.1 step 3 is implicit with the chosen DRBG */
 
 	/* 9.3.1 step 4 */
-	if (addtl_len > DRBG_MAX_ADDTL) {
+	if (addtl_len > DRBG_MAX_ADDTL_BYTES) {
 		pr_devel("DRBG: additional information string too long %zu\n",
 			 addtl_len);
 		return -EINVAL;
 	}
 	/* 9.3.1 step 5 is implicit with the chosen DRBG */
@@ -568,18 +568,19 @@ static inline int __init drbg_healthcheck_sanity(void)
 	 * we may get an OOPS. And we want to get an OOPS as this is a
 	 * grave bug.
 	 */
 
 	/* overflow addtllen with additional info string */
-	ret = drbg_generate(drbg, buf, OUTBUFLEN, buf, DRBG_MAX_ADDTL + 1);
+	ret = drbg_generate(drbg, buf, OUTBUFLEN, buf,
+			    DRBG_MAX_ADDTL_BYTES + 1);
 	BUG_ON(ret == 0);
 	/* overflow max_bits */
 	ret = drbg_generate(drbg, buf, DRBG_MAX_REQUEST_BYTES + 1, NULL, 0);
 	BUG_ON(ret == 0);
 
 	/* overflow max addtllen with personalization string */
-	ret = drbg_seed(drbg, buf, DRBG_MAX_ADDTL + 1, false);
+	ret = drbg_seed(drbg, buf, DRBG_MAX_ADDTL_BYTES + 1, false);
 	BUG_ON(ret == 0);
 	/* all tests passed */
 
 	pr_devel("DRBG: Sanity tests for failure code paths successfully "
 		 "completed\n");

base-commit: 5b03b1f97542c49a498dbb3b4c1fefb3aca60032
-- 
2.54.0

