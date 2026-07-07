Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DC92B318EE1;
	Tue,  7 Jul 2026 05:37:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783402638; cv=none; b=GP93RHfOXrOfdOMKcHnPOeG0HDeqk2aJ6MQbNyoEBUwD5tSND1K2X03DzU9deuQ0SKBAAqSGYTcTN2OTA/SKsuHU4oHJ5kn09MVRPXrF/GA0+qzZWnvh8mPywaRmYCkOCJSkSIUzEJOj2EjKx+9blcr76fOaEh7RWO6bokbxBH0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783402638; c=relaxed/simple;
	bh=qRVbeMHQIgKBuBvwC+VZfTvOVZa0b0JMyDrIVWyQ5XM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=iKZnHquGP7YqelzgPOtxEITshaY3VzcQgs45dfJz+hSmqxTbLAi6tE+Rn++sdneUoITKadzMLQHCqLn0yQhpGaWptJLMiEFAqGLii+dSA7G9IpoBCD93gTadXUf13VQqmSZqWpcG3p+tyFME21lQFmPStIceXtVdkgryHWU0snU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=alkNYFcw; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="alkNYFcw"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A7AA21F00A3D;
	Tue,  7 Jul 2026 05:37:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1783402636;
	bh=s3r/R0HSzBMVaIfI5wbMCf0m4oFLbX9Bxf0nwryh6aI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=alkNYFcwYqvml3gK+eYXni+O2H5f/MIE9Lb53rj8wTPGeTGOm+oqlu4yHO/pDETMC
	 3fl8uKsS1rvbSGp4vTSeD08fKgTAoS32YTVOxeTcFFWn1MUHGahq7aVHJcilH0TIGA
	 laFJl+gERWwaW6iHpD2+k0Yt7su8NUJZysEn+VoTNvdvnlmqSnEaYeCY5JjgBhLlkO
	 fTh7pUttwCyN3dEHKAXDpyjl2k6mWQxWUMOR4LG/qj/T0mdj7hbzcmzWto+2b9LwYz
	 RDTeyFfbaCP7jLZhX1+VUBVG5D6uHR76amL2uh/hy9nJjcaAcQaA169eeoUFiBOALI
	 yLcvCc/MUTbrA==
From: Eric Biggers <ebiggers@kernel.org>
To: linux-crypto@vger.kernel.org
Cc: linux-kernel@vger.kernel.org,
	Eric Biggers <ebiggers@kernel.org>
Subject: [PATCH 01/33] crypto: xts - Split out __xts_verify_key() helper
Date: Mon,  6 Jul 2026 22:34:31 -0700
Message-ID: <20260707053503.209874-2-ebiggers@kernel.org>
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

Make the AES-XTS key verification code callable by the crypto library by
splitting out a helper function that doesn't use crypto_skcipher.

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
2.54.0

