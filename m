Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E565B3CA4B5;
	Wed, 15 Jul 2026 22:12:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784153563; cv=none; b=tUXhzMb6dKzCOsAU7WOqR3NtwpX80nsH/jrrVdo7fRKexjgkAbDISDe0wOWRScCrnBlez9fZo7xpFdAUkzFWBGyjFV8mz3iGDKrZichnR+gXSVgRl+uQjbKM7BwPmUCtkijS5Pxs2Tbx7uxNZXcfPm4Lt9hfuUCo92cynnjyptQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784153563; c=relaxed/simple;
	bh=vcyKlJQHPIPuRbCVeQ/g/VqSOzD+7aQkkW0DwKizObg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=O2kKf4puyG3xMNNnG4q6QFEFhECR/7YM7vVNuEy423rSKXQyfPQ6M7u/5n+jNgmd4MZRt4QwTrqVIn2Ng6SqQUtFlBABnfqXNMGjVt6owt4u5O5tqC2DKwvkzT+3HgGa+nhraT5UyWJef+Z8cjNGOvcof7eh98HbVSnlahF7boM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=OZsEF732; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="OZsEF732"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 906D81F00A3A;
	Wed, 15 Jul 2026 22:12:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1784153561;
	bh=KBF7xnXXskNhZdtypClNKzXj4L01VOmK1znJnUbNEc4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=OZsEF732wTphtRuoaSdJLJMHBxSAdepl1Y32kmvMGU3AY62vT4/B2FxgjWJUkDAeK
	 WT1LK2epy6ps6Eoar15cew3GEIz1Kw4l3jwtCBnoVygNP38/YHnH4MgD0cF/934GOV
	 AjwLQlQVFgRMHt8Y3PxSmLHCzRXttlrsTMP+ytkq1lQM+bp1p8t43CGCnUS8I14NAA
	 +Y3596xHsFPISX1YBQR3eIX0BOPJq6Cit4XE0TdW2mC1RH/M29jdmshJFEQD5dKzL+
	 Dt/E1BPIuhAd2vYHGakRUrEE0LA8eK2mw64Fa+ZQIM31p9HDeMpDWREMXUh1b0OOMa
	 oG3atdCgIqMCQ==
From: Eric Biggers <ebiggers@kernel.org>
To: linux-crypto@vger.kernel.org
Cc: linux-kernel@vger.kernel.org,
	Ard Biesheuvel <ardb@kernel.org>,
	"Jason A . Donenfeld" <Jason@zx2c4.com>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	Thomas Huth <thuth@redhat.com>,
	Eric Biggers <ebiggers@kernel.org>
Subject: [PATCH v2 01/13] crypto: xts - Split out __xts_verify_key() helper
Date: Wed, 15 Jul 2026 15:11:41 -0700
Message-ID: <20260715221153.246410-2-ebiggers@kernel.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260715221153.246410-1-ebiggers@kernel.org>
References: <20260715221153.246410-1-ebiggers@kernel.org>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Make the AES-XTS key verification code callable by the crypto library by
splitting out a helper function that doesn't use crypto_skcipher.

Reviewed-by: Thomas Huth <thuth@redhat.com>
Signed-off-by: Eric Biggers <ebiggers@kernel.org>
---
 include/crypto/xts.h | 18 ++++++++++++++----
 1 file changed, 14 insertions(+), 4 deletions(-)

diff --git a/include/crypto/xts.h b/include/crypto/xts.h
index 15b16c4853d8..16aef89f021f 100644
--- a/include/crypto/xts.h
+++ b/include/crypto/xts.h
@@ -7,9 +7,9 @@
 #include <linux/fips.h>
 
 #define XTS_BLOCK_SIZE 16
+#define XTS_FORBID_WEAK_KEYS (1 << 0)
 
-static inline int xts_verify_key(struct crypto_skcipher *tfm,
-				 const u8 *key, unsigned int keylen)
+static inline int __xts_verify_key(const u8 *key, size_t keylen, int flags)
 {
 	/*
 	 * key consists of keys of equal size concatenated, therefore
@@ -29,12 +29,22 @@ static inline int xts_verify_key(struct crypto_skcipher *tfm,
 	 * Ensure that the AES and tweak key are not identical when
 	 * in FIPS mode or the FORBID_WEAK_KEYS flag is set.
 	 */
-	if ((fips_enabled || (crypto_skcipher_get_flags(tfm) &
-			      CRYPTO_TFM_REQ_FORBID_WEAK_KEYS)) &&
+	if ((fips_enabled || (flags & XTS_FORBID_WEAK_KEYS)) &&
 	    !crypto_memneq(key, key + (keylen / 2), keylen / 2))
 		return -EINVAL;
 
 	return 0;
 }
 
+static inline int xts_verify_key(struct crypto_skcipher *tfm, const u8 *key,
+				 unsigned int keylen)
+{
+	int flags = (crypto_skcipher_get_flags(tfm) &
+		     CRYPTO_TFM_REQ_FORBID_WEAK_KEYS) ?
+			    XTS_FORBID_WEAK_KEYS :
+			    0;
+
+	return __xts_verify_key(key, keylen, flags);
+}
+
 #endif  /* _CRYPTO_XTS_H */
-- 
2.55.0

