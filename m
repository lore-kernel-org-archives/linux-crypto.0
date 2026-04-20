Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 30454393DFD;
	Mon, 20 Apr 2026 06:37:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776667031; cv=none; b=AeZIQTV6CVT69Pnghg190Nj266S3p8MtohFiP1fnWb5h4B6U67s1ARuw1vHg7l+66ccDTTUDCloLprOrvA6fdQH5YrLDoWKCl0LC+G4z3KnKey2VmzYzXakqNVK9s4jOHMI/E4vOIE7k6EbaymXOaKLWRIc5n2wNxPMQTOiEmJo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776667031; c=relaxed/simple;
	bh=yWsOliU3FcFx45ZLBYbhLJzZMSG7sIHqGJUl35fV29I=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=LmewH9uwrZi+G5KZuptwVnpKinlVL+JXwatmSKuHD42FE4NstqsXVZLZIe5gQ3o2P7zHQzEREC/Hx0oDi+qwvm8r1Vo/9lbMEEYAChuPvxM8eDMxsGQ78PXXo911K+Awd/4+KPhObiCr5E+XPxlSA/EfM+rPcL10TeHkHOzFxFQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=pBn2UudF; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="pBn2UudF"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B0FD6C2BCC4;
	Mon, 20 Apr 2026 06:37:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1776667030;
	bh=yWsOliU3FcFx45ZLBYbhLJzZMSG7sIHqGJUl35fV29I=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=pBn2UudFYSzREjfV5MykmmtIO2cijQoHaCbWM1pcu9b+yDTTO6OJCunoX3+GWJ/4/
	 mTRcKIMKKHSJ19V1plR+coyB22VFE2t9+//dguDjLwggkkykD7NvC8yX72zSOruv9x
	 HjPx9sa+jRe7LSBB/7iRbqTfJ6e+rAt08/rn57umSKqRf3wX6UZTV9knDnad4NWFyq
	 fojkQ/5cgqfbd25srQm43dmS/Tm0KpCAdL49hvq+yhD75P4+f5bWkHXpuhLk0xihK8
	 pZfn3nbzRYVjt5Kp5iX6P9uomBxxKHTgZcx4KRyXDMZdvol4Py5V7tUXRtpr6EGCWd
	 2x6qApGL1RVAw==
From: Eric Biggers <ebiggers@kernel.org>
To: linux-crypto@vger.kernel.org,
	Herbert Xu <herbert@gondor.apana.org.au>
Cc: linux-kernel@vger.kernel.org,
	Stephan Mueller <smueller@chronox.de>,
	"Jason A . Donenfeld" <Jason@zx2c4.com>,
	Eric Biggers <ebiggers@kernel.org>
Subject: [PATCH 37/38] crypto: drbg - Clean up generation code
Date: Sun, 19 Apr 2026 23:34:21 -0700
Message-ID: <20260420063422.324906-38-ebiggers@kernel.org>
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

A few miscellaneous cleanups to make the code a bit more readable:

  - Replace (buf, buflen) with (out, outlen)
  - Update (out, outlen) as we go along
  - Use size_t for lengths
  - Use min()
  - Adjust some comments and log messages
  - Rename a variable named 'len' to 'err', since it isn't a length

Signed-off-by: Eric Biggers <ebiggers@kernel.org>
---
 crypto/drbg.c | 53 ++++++++++++++++++---------------------------------
 1 file changed, 19 insertions(+), 34 deletions(-)

diff --git a/crypto/drbg.c b/crypto/drbg.c
index bab766026177..b54c807930af 100644
--- a/crypto/drbg.c
+++ b/crypto/drbg.c
@@ -178,16 +178,13 @@ static void drbg_hmac_update(struct drbg_state *drbg,
 	}
 	memzero_explicit(new_key, sizeof(new_key));
 }
 
 /* generate function of HMAC DRBG as defined in 10.1.2.5 */
-static void drbg_hmac_generate(struct drbg_state *drbg,
-			       unsigned char *buf,
-			       unsigned int buflen,
+static void drbg_hmac_generate(struct drbg_state *drbg, u8 *out, size_t outlen,
 			       const u8 *addtl1, size_t addtl1_len)
 {
-	int len = 0;
 	u8 addtl2[32];
 	size_t addtl2_len = 0;
 
 	/*
 	 * Append some bytes from get_random_bytes() to the additional input
@@ -208,21 +205,20 @@ static void drbg_hmac_generate(struct drbg_state *drbg,
 
 	/* 10.1.2.5 step 2 */
 	if (addtl1_len || addtl2_len)
 		drbg_hmac_update(drbg, addtl1, addtl1_len, addtl2, addtl2_len);
 
-	while (len < buflen) {
-		unsigned int outlen = 0;
+	while (outlen) {
+		size_t n = min(DRBG_STATE_LEN, outlen);
 
 		/* 10.1.2.5 step 4.1 */
 		hmac_sha512(&drbg->key, drbg->V, DRBG_STATE_LEN, drbg->V);
-		outlen = (DRBG_STATE_LEN < (buflen - len)) ?
-			  DRBG_STATE_LEN : (buflen - len);
 
 		/* 10.1.2.5 step 4.2 */
-		memcpy(buf + len, drbg->V, outlen);
-		len += outlen;
+		memcpy(out, drbg->V, n);
+		out += n;
+		outlen -= n;
 	}
 
 	/* 10.1.2.5 step 6 */
 	drbg_hmac_update(drbg, addtl1, addtl1_len, addtl2, addtl2_len);
 
@@ -329,47 +325,42 @@ static int drbg_seed(struct drbg_state *drbg, const u8 *pers, size_t pers_len,
 
 	return ret;
 }
 
 /*
- * DRBG generate function as required by SP800-90A - this function
- * generates random numbers
+ * Generate random bytes from an SP800-90A DRBG.
  *
  * @drbg DRBG state handle
- * @buf Buffer where to store the random numbers -- the buffer must already
- *      be pre-allocated by caller
- * @buflen Length of output buffer - this value defines the number of random
- *	   bytes pulled from DRBG
+ * @out Buffer where to store the random bytes
+ * @outlen Number of random bytes to generate
  * @addtl Optional additional input that is mixed into state
  * @addtl_len Length of @addtl in bytes, may be 0
  *
  * return: 0 when all bytes are generated; < 0 in case of an error
  */
-static int drbg_generate(struct drbg_state *drbg,
-			 unsigned char *buf, unsigned int buflen,
+static int drbg_generate(struct drbg_state *drbg, u8 *out, size_t outlen,
 			 const u8 *addtl, size_t addtl_len)
 	__must_hold(&drbg->drbg_mutex)
 {
-	int len = 0;
+	int err;
 
 	if (!drbg->instantiated) {
 		pr_devel("DRBG: not yet instantiated\n");
 		return -EINVAL;
 	}
-	if (0 == buflen || !buf) {
+	if (out == NULL || outlen == 0) {
 		pr_devel("DRBG: no output buffer provided\n");
 		return -EINVAL;
 	}
 	if (addtl == NULL && addtl_len != 0) {
 		pr_devel("DRBG: wrong format of additional information\n");
 		return -EINVAL;
 	}
 
 	/* 9.3.1 step 2 */
-	if (buflen > DRBG_MAX_REQUEST_BYTES) {
-		pr_devel("DRBG: requested random numbers too large %u\n",
-			 buflen);
+	if (outlen > DRBG_MAX_REQUEST_BYTES) {
+		pr_devel("DRBG: request length is too long %zu\n", outlen);
 		return -EINVAL;
 	}
 
 	/* 9.3.1 step 3 is implicit with the chosen DRBG */
 
@@ -391,20 +382,20 @@ static int drbg_generate(struct drbg_state *drbg,
 	 */
 	if (drbg->pr || drbg->reseed_ctr > DRBG_MAX_REQUESTS) {
 		pr_devel("DRBG: reseeding before generation (prediction resistance: %s)\n",
 			 str_true_false(drbg->pr));
 		/* 9.3.1 steps 7.1 through 7.3 */
-		len = drbg_seed(drbg, addtl, addtl_len, true);
-		if (len)
-			goto err;
+		err = drbg_seed(drbg, addtl, addtl_len, true);
+		if (err)
+			return err;
 		/* 9.3.1 step 7.4 */
 		addtl = NULL;
 		addtl_len = 0;
 	}
 
 	/* 9.3.1 step 8 and 10 */
-	drbg_hmac_generate(drbg, buf, buflen, addtl, addtl_len);
+	drbg_hmac_generate(drbg, out, outlen, addtl, addtl_len);
 
 	/* 10.1.2.5 step 7 */
 	drbg->reseed_ctr++;
 
 	/*
@@ -418,17 +409,11 @@ static int drbg_generate(struct drbg_state *drbg,
 	 * In this case, the entire kernel operation is questionable and it
 	 * is unlikely that the integrity violation only affects the
 	 * correct operation of the DRBG.
 	 */
 
-	/*
-	 * All operations were successful, return 0 as mandated by
-	 * the kernel crypto API interface.
-	 */
-	len = 0;
-err:
-	return len;
+	return 0;
 }
 
 /***************************************************************
  * Kernel crypto API interface to DRBG
  ***************************************************************/
-- 
2.53.0

