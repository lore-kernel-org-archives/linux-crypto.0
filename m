Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6995838B136;
	Mon, 20 Apr 2026 06:37:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776667028; cv=none; b=bOLFILQO+fJM0TLOxu3dC26EKC+y8ESk2tqO2FqblSgVIjRofZf1QDn24hD2um450N74kfocmFV40Fk0unS303BXKKFQD2YyKJwmep9MWQ8cx7H3cTiCIPpzqY2V3wiGLuBM7Dp5StYRfx5Hnh8/+EAdGoQi50Q+kuT0mu0o3ts=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776667028; c=relaxed/simple;
	bh=0WR+Gj9FEmt/sHKSbW+KRJNKsVT9ClFWDq6qAHNgwjM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=GO550vnd6ohHdW1CKNqJoh8uOB4F3KECh9RDZquhcBmoydH3wXFkpK0cMSg9uTCC/qmfn6AeCORtsLjn2Q/4vDvZL7Oh5raeFXS7z1Xpf71J57ez89gcelOxjscDTTe5xyXRDLcwMV+kX9uEwomVD4H3hE2tXWP8OO7nKoGXiOY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=pn5FPAsi; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="pn5FPAsi"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EB593C19425;
	Mon, 20 Apr 2026 06:37:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1776667028;
	bh=0WR+Gj9FEmt/sHKSbW+KRJNKsVT9ClFWDq6qAHNgwjM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=pn5FPAsigZXnATDnd0XFWSDXMSTL1sdAcjaMfIdUkPBCPkFFrICnFwSU+lAXbPjNU
	 bzX36hG4Hws2brSoMLzfV1uYjHwXmph/IX4YyX2+mESSnnUd6lS5gv41ziwNeQ9YCO
	 GSZVlGraQ7gzzhI6x5ikQW2OxAsL2PR+hXQy9aJ39MEHNO9kroRBQEGR5tPx8M2kiR
	 ntrhx54edSsXAmFPesfZ6f1kF2U+5XGyGP5SfetnwvktlU/XoZxMqqfDB6lXoS20jI
	 iYczH5anSjtjLHmAMILz9PPGzAaDquFQbfKRfeAcPBN0qiHSeSIGxhDAATwpTkX+2D
	 ZyLq0/cm+04YQ==
From: Eric Biggers <ebiggers@kernel.org>
To: linux-crypto@vger.kernel.org,
	Herbert Xu <herbert@gondor.apana.org.au>
Cc: linux-kernel@vger.kernel.org,
	Stephan Mueller <smueller@chronox.de>,
	"Jason A . Donenfeld" <Jason@zx2c4.com>,
	Eric Biggers <ebiggers@kernel.org>
Subject: [PATCH 28/38] crypto: drbg - Simplify drbg_generate_long() and fold into caller
Date: Sun, 19 Apr 2026 23:34:12 -0700
Message-ID: <20260420063422.324906-29-ebiggers@kernel.org>
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

Simplify drbg_generate_long() to use a more straightforward loop, and
then fold it into its only caller.  No functional change.

Signed-off-by: Eric Biggers <ebiggers@kernel.org>
---
 crypto/drbg.c | 48 +++++++++++++++++-------------------------------
 1 file changed, 17 insertions(+), 31 deletions(-)

diff --git a/crypto/drbg.c b/crypto/drbg.c
index b0cd8da51b26..9ff1a0e1b129 100644
--- a/crypto/drbg.c
+++ b/crypto/drbg.c
@@ -504,39 +504,10 @@ static int drbg_generate(struct drbg_state *drbg,
 	len = 0;
 err:
 	return len;
 }
 
-/*
- * Wrapper around drbg_generate which can pull arbitrary long strings
- * from the DRBG without hitting the maximum request limitation.
- *
- * Parameters: see drbg_generate
- * Return codes: see drbg_generate -- if one drbg_generate request fails,
- *		 the entire drbg_generate_long request fails
- */
-static int drbg_generate_long(struct drbg_state *drbg,
-			      unsigned char *buf, unsigned int buflen,
-			      const u8 *addtl, size_t addtl_len)
-{
-	unsigned int len = 0;
-	unsigned int slice = 0;
-	do {
-		int err = 0;
-		unsigned int chunk = 0;
-		slice = (buflen - len) / DRBG_MAX_REQUEST_BYTES;
-		chunk = slice ? DRBG_MAX_REQUEST_BYTES : (buflen - len);
-		mutex_lock(&drbg->drbg_mutex);
-		err = drbg_generate(drbg, buf + len, chunk, addtl, addtl_len);
-		mutex_unlock(&drbg->drbg_mutex);
-		if (0 > err)
-			return err;
-		len += chunk;
-	} while (slice > 0 && (len < buflen));
-	return 0;
-}
-
 static int drbg_prepare_hrng(struct drbg_state *drbg)
 {
 	/* We do not need an HRNG in test mode. */
 	if (drbg->test_entropylen != 0)
 		return 0;
@@ -674,11 +645,10 @@ static void drbg_kcapi_cleanup(struct crypto_tfm *tfm)
 	drbg_uninstantiate(crypto_tfm_ctx(tfm));
 }
 
 /*
  * Generate random numbers invoked by the kernel crypto API:
- * The API of the kernel crypto API is extended as follows:
  *
  * src is additional input supplied to the RNG.
  * slen is the length of src.
  * dst is the output buffer where random data is to be stored.
  * dlen is the length of dst.
@@ -687,11 +657,27 @@ static int drbg_kcapi_random(struct crypto_rng *tfm,
 			     const u8 *src, unsigned int slen,
 			     u8 *dst, unsigned int dlen)
 {
 	struct drbg_state *drbg = crypto_rng_ctx(tfm);
 
-	return drbg_generate_long(drbg, dst, dlen, src, slen);
+	/*
+	 * Break the request into multiple requests if needed, to avoid
+	 * exceeding the maximum request length of the core algorithm.
+	 */
+	do {
+		unsigned int n = min(dlen, DRBG_MAX_REQUEST_BYTES);
+		int err;
+
+		mutex_lock(&drbg->drbg_mutex);
+		err = drbg_generate(drbg, dst, n, src, slen);
+		mutex_unlock(&drbg->drbg_mutex);
+		if (err < 0)
+			return err;
+		dst += n;
+		dlen -= n;
+	} while (dlen);
+	return 0;
 }
 
 /* Seed (i.e. instantiate) or re-seed the DRBG. */
 static int drbg_kcapi_seed(struct crypto_rng *tfm,
 			   const u8 *seed, unsigned int slen, bool pr)
-- 
2.53.0

