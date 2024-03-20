Received: from smtp.jvdsn.com (smtp.jvdsn.com [129.153.194.31])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3F5B8184F
	for <linux-crypto@vger.kernel.org>; Wed, 20 Mar 2024 05:16:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=129.153.194.31
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1710911778; cv=none; b=hUegO692E41JSAtsSYOPbHDsHtPU3kouE3dSiBf05dPFkRHlmrPbVD8i9wL80jtNqodC5MzAxNob1J4PnlgaUy8xMsO1Hw+CG4LeBEiSI/FfT+Cw7jJzHELUQXD4M7DWzFOgEH+mIZPxkG8FWs3v1fKdWb/yRj4LWcOHiLed0dg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1710911778; c=relaxed/simple;
	bh=AYq5EvL8HBCmBYIoffjXcsjaj3rkXzD4RQWMgthaK1I=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version:Content-Type; b=jC96Fye+gf2sBwP5+E9hyVH5ejSDzhKS3xNmKyuv6EY1XoEDqlBtzxFXyboaTm2y2xobNIkT3TkXJpjU1xV9VKJwoh/HxsyfjchcthfEMKxoHWTMBIFo7ltxeBisqt0hl0O5tNw52A2rIVaw4O3SP1Xx/haE/QtP5ScFnCnR2k8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=jvdsn.com; spf=pass smtp.mailfrom=jvdsn.com; arc=none smtp.client-ip=129.153.194.31
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=jvdsn.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=jvdsn.com
From: Joachim Vandersmissen <git@jvdsn.com>
To: linux-crypto@vger.kernel.org,
	Herbert Xu <herbert@gondor.apana.org.au>
Cc: Vitaly Chikunov <vt@altlinux.org>,
	Joachim Vandersmissen <git@jvdsn.com>
Subject: [PATCH] crypto: ecc - update ecc_gen_privkey for FIPS 186-5
Date: Wed, 20 Mar 2024 00:13:38 -0500
Message-ID: <20240320051558.62868-1-git@jvdsn.com>
X-Mailer: git-send-email 2.44.0
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

FIPS 186-5 [1] was released approximately 1 year ago. The most
interesting change for ecc_gen_privkey is the removal of curves with
order < 224 bits. This is minimum is now checked in step 1. It is
unlikely that there is still any benefit in generating private keys for
curves with n < 224, as those curves provide less than 112 bits of
security strength and are therefore unsafe for any modern usage.

This patch also updates the documentation for __ecc_is_key_valid and
ecc_gen_privkey to clarify which FIPS 186-5 method is being used to
generate private keys. Previous documentation mentioned that "extra
random bits" was used. However, this did not match the code. Instead,
the code currently uses (and always has used) the "rejection sampling"
("testing candidates" in FIPS 186-4) method.

[1]: https://doi.org/10.6028/NIST.FIPS.186-5

Signed-off-by: Joachim Vandersmissen <git@jvdsn.com>
---
 crypto/ecc.c | 29 +++++++++++++++++------------
 1 file changed, 17 insertions(+), 12 deletions(-)

diff --git a/crypto/ecc.c b/crypto/ecc.c
index f53fb4d6af99..3581027e9f92 100644
--- a/crypto/ecc.c
+++ b/crypto/ecc.c
@@ -1416,6 +1416,12 @@ void ecc_point_mult_shamir(const struct ecc_point *result,
 }
 EXPORT_SYMBOL(ecc_point_mult_shamir);
 
+/*
+ * This function performs checks equivalent to Appendix A.4.2 of FIPS 186-5.
+ * Whereas A.4.2 results in an integer in the interval [1, n-1], this function
+ * ensures that the integer is in the range of [2, n-3]. We are slightly
+ * stricter because of the currently used scalar multiplication algorithm.
+ */
 static int __ecc_is_key_valid(const struct ecc_curve *curve,
 			      const u64 *private_key, unsigned int ndigits)
 {
@@ -1455,16 +1461,11 @@ int ecc_is_key_valid(unsigned int curve_id, unsigned int ndigits,
 EXPORT_SYMBOL(ecc_is_key_valid);
 
 /*
- * ECC private keys are generated using the method of extra random bits,
- * equivalent to that described in FIPS 186-4, Appendix B.4.1.
- *
- * d = (c mod(n–1)) + 1    where c is a string of random bits, 64 bits longer
- *                         than requested
- * 0 <= c mod(n-1) <= n-2  and implies that
- * 1 <= d <= n-1
+ * ECC private keys are generated using the method of rejection sampling,
+ * equivalent to that described in FIPS 186-5, Appendix A.2.2.
  *
  * This method generates a private key uniformly distributed in the range
- * [1, n-1].
+ * [2, n-3].
  */
 int ecc_gen_privkey(unsigned int curve_id, unsigned int ndigits, u64 *privkey)
 {
@@ -1474,12 +1475,15 @@ int ecc_gen_privkey(unsigned int curve_id, unsigned int ndigits, u64 *privkey)
 	unsigned int nbits = vli_num_bits(curve->n, ndigits);
 	int err;
 
-	/* Check that N is included in Table 1 of FIPS 186-4, section 6.1.1 */
-	if (nbits < 160 || ndigits > ARRAY_SIZE(priv))
+	/*
+	 * Step 1 & 2: check that N is included in Table 1 of FIPS 186-5,
+	 * section 6.1.1.
+	 */
+	if (nbits < 224 || ndigits > ARRAY_SIZE(priv))
 		return -EINVAL;
 
 	/*
-	 * FIPS 186-4 recommends that the private key should be obtained from a
+	 * FIPS 186-5 recommends that the private key should be obtained from a
 	 * RBG with a security strength equal to or greater than the security
 	 * strength associated with N.
 	 *
@@ -1492,12 +1496,13 @@ int ecc_gen_privkey(unsigned int curve_id, unsigned int ndigits, u64 *privkey)
 	if (crypto_get_default_rng())
 		return -EFAULT;
 
+	/* Step 3: obtain N returned_bits from the DRBG. */
 	err = crypto_rng_get_bytes(crypto_default_rng, (u8 *)priv, nbytes);
 	crypto_put_default_rng();
 	if (err)
 		return err;
 
-	/* Make sure the private key is in the valid range. */
+	/* Step 4: make sure the private key is in the valid range. */
 	if (__ecc_is_key_valid(curve, priv, ndigits))
 		return -EINVAL;
 
-- 
2.44.0

