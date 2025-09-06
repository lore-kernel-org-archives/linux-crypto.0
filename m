Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6D9AC2C1583;
	Sat,  6 Sep 2025 21:37:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757194625; cv=none; b=BWXl4Z9d8Z4KHl24jOtdx+0WDXZqFrTWLGGshN73mWa8Ks3n3DHrHfnGNUulkpjgRex/YGoxLYDzntEWUx6EQPKIrpkHe9Es/Ed6o2ahYqjNlksAY7oo2zHDme4zcJThDwPERmvomOFAfQBM0MrwH9BaRuollrIsMF1iSzBGxkY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757194625; c=relaxed/simple;
	bh=CQJ4knDhIHFMSRh4/nbpAJJmql9MOH99GJgLFyWdS58=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=fk9iYGNBqLzIrx3AzqDSrdE4ST33MYpsCnQYYh1KDPiOqRzHa6SrLC1icBgdU/sq9Q/2yuTf91GXaPRyjwCajg01ucHiGKl1CCsoGPCWQca59NMc/tHhFrfGccGOOuL6QQLTSxBnQRs3kIknP04ifEWnMQJaqa6yDLZcJ84dnJI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=vC0Kr4aV; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="vC0Kr4aV"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9174EC4CEF5;
	Sat,  6 Sep 2025 21:37:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1757194625;
	bh=CQJ4knDhIHFMSRh4/nbpAJJmql9MOH99GJgLFyWdS58=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=vC0Kr4aV2MDmbVpnymLdTPEZrGi3BkuR7l6W7PpSF5Hy0JlNrPuytbWgARqDEFWa4
	 ksLj7ObBc4HIiTFQnpZraghc+4ZAxZ7ioXuydpWTZ4MELVghPd1RD7aXGCEXCeaOW1
	 87lHedKJzwLvy+1jTtDOo8Q2kz37c7gTztVpg1RWvKqgWwEevXx4sJ2+upJpJHZY21
	 91QIKZ38fMjYyYaN9kYVmNqvpfM9y0gmOPzDzCCtqlbTDpSpjNvuyV5+kz2arf0ZSP
	 HiDCrFyj6R3DHGrZyUbp9crRNTK2/izTBCE0rBrWam6dUR+XIEPQqJFToXJz3e6yqz
	 BuxmwJBc/SW1Q==
From: Eric Biggers <ebiggers@kernel.org>
To: linux-crypto@vger.kernel.org
Cc: linux-kernel@vger.kernel.org,
	Ard Biesheuvel <ardb@kernel.org>,
	"Jason A . Donenfeld" <Jason@zx2c4.com>,
	Zhiqi Song <songzhiqi1@huawei.com>,
	Longfang Liu <liulongfang@huawei.com>,
	x86@kernel.org,
	linux-arm-kernel@lists.infradead.org,
	linuxppc-dev@lists.ozlabs.org,
	Eric Biggers <ebiggers@kernel.org>
Subject: [PATCH v2 09/12] lib/crypto: curve25519: Move a couple functions out-of-line
Date: Sat,  6 Sep 2025 14:35:20 -0700
Message-ID: <20250906213523.84915-10-ebiggers@kernel.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250906213523.84915-1-ebiggers@kernel.org>
References: <20250906213523.84915-1-ebiggers@kernel.org>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Move curve25519() and curve25519_generate_public() from curve25519.h to
curve25519.c.  There's no good reason for them to be inline.

Signed-off-by: Eric Biggers <ebiggers@kernel.org>
---
 include/crypto/curve25519.h | 28 +++-------------------------
 lib/crypto/curve25519.c     | 34 +++++++++++++++++++++++++++++++++-
 2 files changed, 36 insertions(+), 26 deletions(-)

diff --git a/include/crypto/curve25519.h b/include/crypto/curve25519.h
index 4e6dc840b1592..78aa5f28c847f 100644
--- a/include/crypto/curve25519.h
+++ b/include/crypto/curve25519.h
@@ -4,11 +4,10 @@
  */
 
 #ifndef CURVE25519_H
 #define CURVE25519_H
 
-#include <crypto/algapi.h> // For crypto_memneq.
 #include <linux/types.h>
 #include <linux/random.h>
 
 enum curve25519_lengths {
 	CURVE25519_KEY_SIZE = 32
@@ -26,37 +25,16 @@ void curve25519_arch(u8 out[CURVE25519_KEY_SIZE],
 		     const u8 point[CURVE25519_KEY_SIZE]);
 
 void curve25519_base_arch(u8 pub[CURVE25519_KEY_SIZE],
 			  const u8 secret[CURVE25519_KEY_SIZE]);
 
-static inline
 bool __must_check curve25519(u8 mypublic[CURVE25519_KEY_SIZE],
 			     const u8 secret[CURVE25519_KEY_SIZE],
-			     const u8 basepoint[CURVE25519_KEY_SIZE])
-{
-	if (IS_ENABLED(CONFIG_CRYPTO_ARCH_HAVE_LIB_CURVE25519))
-		curve25519_arch(mypublic, secret, basepoint);
-	else
-		curve25519_generic(mypublic, secret, basepoint);
-	return crypto_memneq(mypublic, curve25519_null_point,
-			     CURVE25519_KEY_SIZE);
-}
+			     const u8 basepoint[CURVE25519_KEY_SIZE]);
 
-static inline bool
-__must_check curve25519_generate_public(u8 pub[CURVE25519_KEY_SIZE],
-					const u8 secret[CURVE25519_KEY_SIZE])
-{
-	if (unlikely(!crypto_memneq(secret, curve25519_null_point,
-				    CURVE25519_KEY_SIZE)))
-		return false;
-
-	if (IS_ENABLED(CONFIG_CRYPTO_ARCH_HAVE_LIB_CURVE25519))
-		curve25519_base_arch(pub, secret);
-	else
-		curve25519_generic(pub, secret, curve25519_base_point);
-	return crypto_memneq(pub, curve25519_null_point, CURVE25519_KEY_SIZE);
-}
+bool __must_check curve25519_generate_public(u8 pub[CURVE25519_KEY_SIZE],
+					     const u8 secret[CURVE25519_KEY_SIZE]);
 
 static inline void curve25519_clamp_secret(u8 secret[CURVE25519_KEY_SIZE])
 {
 	secret[0] &= 248;
 	secret[31] = (secret[31] & 127) | 64;
diff --git a/lib/crypto/curve25519.c b/lib/crypto/curve25519.c
index 25f16777865bf..1b786389d714a 100644
--- a/lib/crypto/curve25519.c
+++ b/lib/crypto/curve25519.c
@@ -8,12 +8,44 @@
  *
  * Information: https://cr.yp.to/ecdh.html
  */
 
 #include <crypto/curve25519.h>
-#include <linux/module.h>
+#include <crypto/utils.h>
+#include <linux/export.h>
 #include <linux/init.h>
+#include <linux/module.h>
+
+bool __must_check
+curve25519(u8 mypublic[CURVE25519_KEY_SIZE],
+	   const u8 secret[CURVE25519_KEY_SIZE],
+	   const u8 basepoint[CURVE25519_KEY_SIZE])
+{
+	if (IS_ENABLED(CONFIG_CRYPTO_ARCH_HAVE_LIB_CURVE25519))
+		curve25519_arch(mypublic, secret, basepoint);
+	else
+		curve25519_generic(mypublic, secret, basepoint);
+	return crypto_memneq(mypublic, curve25519_null_point,
+			     CURVE25519_KEY_SIZE);
+}
+EXPORT_SYMBOL(curve25519);
+
+bool __must_check
+curve25519_generate_public(u8 pub[CURVE25519_KEY_SIZE],
+			   const u8 secret[CURVE25519_KEY_SIZE])
+{
+	if (unlikely(!crypto_memneq(secret, curve25519_null_point,
+				    CURVE25519_KEY_SIZE)))
+		return false;
+
+	if (IS_ENABLED(CONFIG_CRYPTO_ARCH_HAVE_LIB_CURVE25519))
+		curve25519_base_arch(pub, secret);
+	else
+		curve25519_generic(pub, secret, curve25519_base_point);
+	return crypto_memneq(pub, curve25519_null_point, CURVE25519_KEY_SIZE);
+}
+EXPORT_SYMBOL(curve25519_generate_public);
 
 static int __init curve25519_init(void)
 {
 	return 0;
 }
-- 
2.50.1

