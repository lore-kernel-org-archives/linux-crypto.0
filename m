Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 38880155A30;
	Sat, 17 May 2025 02:25:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747448718; cv=none; b=BtiGsgn5ZQYSHwzj058d/Yr857MBegCp0QvPEMOdIZkcqa2oXHZjainIe01vLu/GEj8+TB4TW6am+CemV0zSjHSXB4ttT98Ky9bfdHmvilzo0+OQZj+3Chmz+AMPeAS/8FZ6ZS8oD0JZGdS8z9yrYengVtbzeV+rVBQ9M1RbFfE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747448718; c=relaxed/simple;
	bh=3e9dMx8TONdupA1e08zfixVPVRX4LqDVpRilevWdVaU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=eNlw1MaEVv48sk/vGjIz59AeLM6xUUqRBSXL6BY1xR51Ar7E9RVy6IBKjiiI0nLgV+aj5Ujk+LbbWMj9NFDYJuVsJ/WksOanjtArEXxRvaWZjXG1DTn0aFN/NwBXhmHFVs0AP0FbyACj8Y3I/mvZsA6JlZuekQK/19cJ5MWrfJw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=aJrdv3VM; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="aJrdv3VM"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 49FB0C4CEEF;
	Sat, 17 May 2025 02:25:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1747448717;
	bh=3e9dMx8TONdupA1e08zfixVPVRX4LqDVpRilevWdVaU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=aJrdv3VMNlbtKAARwnCNkOGb8l1N9/cWUK+uQ1Zpop9HmWeiJ4VzY6Uuap9mRxoao
	 XkhXMvdATmK5j3P9WTUEBuc3E5x3i+Hw4N8yFmbbolhSTic7u3ZtdkclOZsa3icnfT
	 VMV1z+kkqMLOSWJXo5GITfi7fv4hig+XQZCw1mZmIhU8uhPs1qURausHt2D5R9DtHB
	 4UKW1En6je8mfg0Z4X3JSjBuD8U6MpgXaRHIPfNNfiDhLf5IwgR/qUDrT/zozqwk4m
	 6h+0rB23OIOV4MecogJInh3pD3qBeEm48/YFiysMxvaGQXrJlwI7oPV5hDgqsaKRh9
	 ojDKbL4guIWtA==
From: Eric Biggers <ebiggers@kernel.org>
To: linux-crypto@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH 2/8] Revert "crypto: lib/sha256 - Use generic block helper"
Date: Fri, 16 May 2025 19:24:22 -0700
Message-ID: <20250517022428.401622-3-ebiggers@kernel.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250517022428.401622-1-ebiggers@kernel.org>
References: <20250517022428.401622-1-ebiggers@kernel.org>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Eric Biggers <ebiggers@google.com>

This reverts commit 3007e90572d0c5fd409c3d2fa8cedcbd5cb06d4b which got
pushed out despite being nacked.

BLOCK_HASH_UPDATE_BLOCKS makes the code harder to read and isn't really
worth it.  The *_generic() functions are needed for shash.

Signed-off-by: Eric Biggers <ebiggers@google.com>
---
 include/crypto/internal/sha2.h |  7 ++++
 lib/crypto/sha256.c            | 71 +++++++++++++++++++++++++++++-----
 2 files changed, 68 insertions(+), 10 deletions(-)

diff --git a/include/crypto/internal/sha2.h b/include/crypto/internal/sha2.h
index b9bccd3ff57fc..fff156f66edc3 100644
--- a/include/crypto/internal/sha2.h
+++ b/include/crypto/internal/sha2.h
@@ -8,10 +8,17 @@
 #include <linux/compiler_attributes.h>
 #include <linux/string.h>
 #include <linux/types.h>
 #include <linux/unaligned.h>
 
+void sha256_update_generic(struct sha256_state *sctx,
+			   const u8 *data, size_t len);
+void sha256_final_generic(struct sha256_state *sctx,
+			  u8 out[SHA256_DIGEST_SIZE]);
+void sha224_final_generic(struct sha256_state *sctx,
+			  u8 out[SHA224_DIGEST_SIZE]);
+
 #if IS_ENABLED(CONFIG_CRYPTO_ARCH_HAVE_LIB_SHA256)
 bool sha256_is_arch_optimized(void);
 #else
 static inline bool sha256_is_arch_optimized(void)
 {
diff --git a/lib/crypto/sha256.c b/lib/crypto/sha256.c
index 107e5162507a7..2ced29efa181c 100644
--- a/lib/crypto/sha256.c
+++ b/lib/crypto/sha256.c
@@ -9,11 +9,10 @@
  * Copyright (c) Andrew McDonald <andrew@mcdonald.org.uk>
  * Copyright (c) 2002 James Morris <jmorris@intercode.com.au>
  * Copyright (c) 2014 Red Hat Inc.
  */
 
-#include <crypto/internal/blockhash.h>
 #include <crypto/internal/sha2.h>
 #include <linux/kernel.h>
 #include <linux/module.h>
 #include <linux/string.h>
 
@@ -30,44 +29,75 @@ static inline bool sha256_purgatory(void)
 {
 	return __is_defined(__DISABLE_EXPORTS);
 }
 
 static inline void sha256_blocks(u32 state[SHA256_STATE_WORDS], const u8 *data,
-				 size_t nblocks)
+				 size_t nblocks, bool force_generic)
 {
-	sha256_choose_blocks(state, data, nblocks, sha256_purgatory(), false);
+	sha256_choose_blocks(state, data, nblocks,
+			     force_generic || sha256_purgatory(), false);
 }
 
-void sha256_update(struct sha256_state *sctx, const u8 *data, size_t len)
+static inline void __sha256_update(struct sha256_state *sctx, const u8 *data,
+				   size_t len, bool force_generic)
 {
 	size_t partial = sctx->count % SHA256_BLOCK_SIZE;
 
 	sctx->count += len;
-	BLOCK_HASH_UPDATE_BLOCKS(sha256_blocks, sctx->ctx.state, data, len,
-				 SHA256_BLOCK_SIZE, sctx->buf, partial);
+
+	if (partial + len >= SHA256_BLOCK_SIZE) {
+		size_t nblocks;
+
+		if (partial) {
+			size_t l = SHA256_BLOCK_SIZE - partial;
+
+			memcpy(&sctx->buf[partial], data, l);
+			data += l;
+			len -= l;
+
+			sha256_blocks(sctx->state, sctx->buf, 1, force_generic);
+		}
+
+		nblocks = len / SHA256_BLOCK_SIZE;
+		len %= SHA256_BLOCK_SIZE;
+
+		if (nblocks) {
+			sha256_blocks(sctx->state, data, nblocks,
+				      force_generic);
+			data += nblocks * SHA256_BLOCK_SIZE;
+		}
+		partial = 0;
+	}
+	if (len)
+		memcpy(&sctx->buf[partial], data, len);
+}
+
+void sha256_update(struct sha256_state *sctx, const u8 *data, size_t len)
+{
+	__sha256_update(sctx, data, len, false);
 }
 EXPORT_SYMBOL(sha256_update);
 
 static inline void __sha256_final(struct sha256_state *sctx, u8 *out,
-				  size_t digest_size)
+				  size_t digest_size, bool force_generic)
 {
 	size_t partial = sctx->count % SHA256_BLOCK_SIZE;
 
 	sha256_finup(&sctx->ctx, sctx->buf, partial, out, digest_size,
-		     sha256_purgatory(), false);
+		     force_generic || sha256_purgatory(), false);
 	memzero_explicit(sctx, sizeof(*sctx));
 }
 
 void sha256_final(struct sha256_state *sctx, u8 out[SHA256_DIGEST_SIZE])
 {
-	__sha256_final(sctx, out, SHA256_DIGEST_SIZE);
+	__sha256_final(sctx, out, SHA256_DIGEST_SIZE, false);
 }
 EXPORT_SYMBOL(sha256_final);
 
 void sha224_final(struct sha256_state *sctx, u8 out[SHA224_DIGEST_SIZE])
 {
-	__sha256_final(sctx, out, SHA224_DIGEST_SIZE);
+	__sha256_final(sctx, out, SHA224_DIGEST_SIZE, false);
 }
 EXPORT_SYMBOL(sha224_final);
 
 void sha256(const u8 *data, size_t len, u8 out[SHA256_DIGEST_SIZE])
 {
@@ -77,7 +107,28 @@ void sha256(const u8 *data, size_t len, u8 out[SHA256_DIGEST_SIZE])
 	sha256_update(&sctx, data, len);
 	sha256_final(&sctx, out);
 }
 EXPORT_SYMBOL(sha256);
 
+#if IS_ENABLED(CONFIG_CRYPTO_SHA256) && !defined(__DISABLE_EXPORTS)
+void sha256_update_generic(struct sha256_state *sctx,
+			   const u8 *data, size_t len)
+{
+	__sha256_update(sctx, data, len, true);
+}
+EXPORT_SYMBOL(sha256_update_generic);
+
+void sha256_final_generic(struct sha256_state *sctx, u8 out[SHA256_DIGEST_SIZE])
+{
+	__sha256_final(sctx, out, SHA256_DIGEST_SIZE, true);
+}
+EXPORT_SYMBOL(sha256_final_generic);
+
+void sha224_final_generic(struct sha256_state *sctx, u8 out[SHA224_DIGEST_SIZE])
+{
+	__sha256_final(sctx, out, SHA224_DIGEST_SIZE, true);
+}
+EXPORT_SYMBOL(sha224_final_generic);
+#endif
+
 MODULE_DESCRIPTION("SHA-256 Algorithm");
 MODULE_LICENSE("GPL");
-- 
2.49.0

