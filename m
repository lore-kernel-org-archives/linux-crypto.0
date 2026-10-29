Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793252842;
	b=oS+lZM5E10x6fK0Eqr0qtYlobzQvI7QS7v55jOxDMrAUJ+Oi5o9kmCgHfAyUoSgzVJSv
	 QKnnSuDSdy4mBPjz7Vupl7I74ux/s/BA0H3ye8v/ETazm9Gbif1ajdPu01vUFuE1joG+/
	 jtOK/xJLvFdNOuaXo9UT/yiBVjrydUtka9ehYpcZmc8Mx18oqSctve8OVKrqoeO/V70Zy
	 a5YV/+bN+mLfAr/QFpAgHfYeYmMNpxbxsN235eYWVJaJOw810bj7NKOQGhIcT4lfii5vT
	 RXu9z7RE3tH9cny64JsJq1WJIki3+JqDEmRq3IwIzuLYKO/BYL49kAYsNJBcybwYRkQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793252842;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:MIME-Version:Content-Transfer-Encoding;
	bh=5bF6x9nIaZX0MzHQd3Qqs2l/KPxiYvlaThjguQZpF/k=;
	b=31lTSrdDnTufPvZ/xM61qpRAkLtqI+mYKht38RGLPo3lnKcNRmSEQxjGFnS97jeA0qWk
	 NJWrRuErSVr5ZLw4k6FQOEckRPEC5zFjJdwULsCuSHvKK+xUrRHXY8L3Z/Ay4e6CVunv6
	 FKaSqsjCNH+xBnNktrkxM/Xpv04TdYpKc2pe7qfhEkmz+DLxsk17NjzrJdOHku6mn7i4F
	 T0/p0RnxpSLB9ON2o0CkWIQdXh3/pYnaLIJwL0Rr85NngocnAwiEbA+e9A08v7teFXjSQ
	 rw7CYhhcpyPku4P2dps3rN8nQnv7kKIJpZc9NWddrgp7QX839q+B0ZMKub49wnBACjQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=Hiz3i9GM;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A077A606A31A
	for <linux-crypto@vger.kernel.org>; Thu, 29 Oct 2026 05:47:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=Hiz3i9GM
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 217801F01825;
	Thu, 29 Oct 2026 05:47:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793252842;
	bh=5bF6x9nIaZX0MzHQd3Qqs2l/KPxiYvlaThjguQZpF/k=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Hiz3i9GMTFthlL3O7xDT8YNKhSRXVSBEegtIm4pBp1nV8NrWPOIDm5zInqTekNVep
	 a3+S7HHkDKiexQQUM8KS7r59d9i8P67Mlw492/sJVSwLuxP9hWQahCuwDBcdWGEmRw
	 u4TbZKRgZQTRomR4d9etGTJzHV05Cx1rENzzoXFy4dZu1k2hldu778nYnl28oTd18R
	 iLibnvi+yb+Cj3WycSCP3UOZJOGxGvhtNB89dBsUdnNrD4xEnED4T9T+OBRaQ8r5Eb
	 U1IEueOt+gnnjsWgK2Q9RQ6I024yvCkoa/e1mfyjDcgQMyvnRO0jPgfUXZuwUJ1Mj1
	 oIreQjrf2ZJ0g==
From: Eric Biggers <ebiggers@kernel.org>
To: linux-crypto@vger.kernel.org
Cc: Ard Biesheuvel <ardb@kernel.org>,
	"Jason A . Donenfeld" <Jason@zx2c4.com>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	Eric Biggers <ebiggers@kernel.org>
Subject: [PATCH 1/3] lib/crypto: mldsa: Check pk_len before doing pointer arithmetic
Date: Wed, 28 Oct 2026 22:45:32 -0700
Message-ID: <20261029054534.68481-2-ebiggers@kernel.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261029054534.68481-1-ebiggers@kernel.org>
References: <20261029054534.68481-1-ebiggers@kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Post: <mailto:linux-crypto@vger.kernel.org>
List-Help: <mailto:linux-crypto+help@vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-crypto+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Though common in the kernel and benign in practice (not even triggering
UBSAN warnings), taking an address past the end of an array is undefined
behavior according to the C specification.

Therefore, compute &pk[RHO_LEN] only after pk_len has been validated,
since pk_len could be less than RHO_LEN if an incorrectly sized public
key is provided.

(Also fix a typo that isn't worth its own commit.)

Fixes: 64edccea594c ("lib/crypto: Add ML-DSA verification support")
Signed-off-by: Eric Biggers <ebiggers@kernel.org>
---
 lib/crypto/mldsa.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/lib/crypto/mldsa.c b/lib/crypto/mldsa.c
index c96fddc4e7dcf..68a1b432315b1 100644
--- a/lib/crypto/mldsa.c
+++ b/lib/crypto/mldsa.c
@@ -306,7 +306,7 @@ static const u8 *decode_t1_elem(struct mldsa_ring_elem *out,
  * Reference: FIPS 204 Algorithm 27, sigDecode.
  *
  * This also validates that the coefficients of z are in range, corresponding
- * the infinity norm check at the end of Algorithm 8, ML-DSA.Verify_internal.
+ * to the infinity norm check at the end of Algorithm 8, ML-DSA.Verify_internal.
  *
  * Finally, this also converts z to NTT form.
  */
@@ -533,7 +533,7 @@ int mldsa_verify(enum mldsa_alg alg, const u8 *sig, size_t sig_len,
 	/* For now this just does pure ML-DSA with an empty context string. */
 	static const u8 msg_prefix[2] = { /* dom_sep= */ 0, /* ctx_len= */ 0 };
 	const u8 *ctilde; /* The signer's commitment hash */
-	const u8 *t1_encoded = &pk[RHO_LEN]; /* Next encoded element of t_1 */
+	const u8 *t1_encoded; /* Next encoded element of t_1 */
 	u8 *h; /* The signer's hint vector, length k * N */
 	size_t w1_enc_len;
 
@@ -587,6 +587,7 @@ int mldsa_verify(enum mldsa_alg alg, const u8 *sig, size_t sig_len,
 	 * The computation is the same for each of the k rows.  Just do each row
 	 * before moving on to the next, resulting in only one loop over k.
 	 */
+	t1_encoded = &pk[RHO_LEN];
 	for (int i = 0; i < k; i++) {
 		/*
 		 * tmp = NTT(A) * NTT(z) * 2^-32
-- 
2.56.0

