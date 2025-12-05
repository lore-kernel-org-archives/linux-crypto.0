Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0F5488821;
	Fri,  5 Dec 2025 05:15:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764911726; cv=none; b=J4LeSUfUh3ouSWl91MCjnBKfBW5D6uU0hIgfKL5pQO9qBjRsZh7XDGOvQYGBVRnak+T53iqQLVw/ZJgyd10XsZt9HRmiGJooX+JA/IPjntcYEpwN60DcPgxll4UBMKYVc666B3Y/SUbIA0/mG0zSimS6CSpxbFcOxBoQIdP7lvU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764911726; c=relaxed/simple;
	bh=xgHhtZumvdjfgw+FiqO7QtO6dDqWlaj3bgYCiBCj0QA=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=DOQKHabIvp8g/6o9vcxf5U+k+QMF9S4n4FKCHqz6+W/ogCCxsoMY1HBqdkMxTycAB8qe9EKnKKhIUzurD8ah5SEIm1r6c0KTFPXrCex7+yctLlFpSj2+BSdCMqunJ5coK33nYq2s83lcemUd4MboMARRB1dg0QrEOSuo1NHEr9k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=WnRFy2bZ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="WnRFy2bZ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 32207C4CEF1;
	Fri,  5 Dec 2025 05:15:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1764911725;
	bh=xgHhtZumvdjfgw+FiqO7QtO6dDqWlaj3bgYCiBCj0QA=;
	h=From:To:Cc:Subject:Date:From;
	b=WnRFy2bZBYkn0rxbOzfHdmHS4BUIb9vTylqt2xskQGg+7zm0bLm7Ek168t/+8nyFQ
	 uBlBUXb/v7CLxhZLF4lIvawzZmdCSl7fnC0uyjL5fvcYnov9k6MO2nqj3L5isgGdoK
	 Div1vM7pDWCUlLEc83Thg3PyC/RUTZ+cGld3X/QiGFRCO3QYSTOU2xUBCE7WNZMvDx
	 ZaMyVKUBBH6TpNV9NRDMjCPZVvhs2Dv33C5Wu5NvP0Wd1ER3rZQ5ImBwaMDo9caKND
	 J3MnCtX5vzROZlkmhWCwRZPX6xFVAajVKxMwHbWEsBNzKPXsu+9uRmoGSjrYhObK7V
	 MHVBqU0zqZrVQ==
From: Eric Biggers <ebiggers@kernel.org>
To: linux-crypto@vger.kernel.org
Cc: linux-kernel@vger.kernel.org,
	Ard Biesheuvel <ardb@kernel.org>,
	"Jason A . Donenfeld" <Jason@zx2c4.com>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	Eric Biggers <ebiggers@kernel.org>
Subject: [PATCH] lib/crypto: blake2s: Replace manual unrolling with unrolled_full
Date: Thu,  4 Dec 2025 21:11:55 -0800
Message-ID: <20251205051155.25274-1-ebiggers@kernel.org>
X-Mailer: git-send-email 2.52.0
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

As we're doing in the BLAKE2b code, use unrolled_full to make the
compiler handle the loop unrolling.  This simplifies the code slightly.
The generated object code is nearly the same with both gcc and clang.

Signed-off-by: Eric Biggers <ebiggers@kernel.org>
---
 lib/crypto/blake2s.c | 38 ++++++++++++++++----------------------
 1 file changed, 16 insertions(+), 22 deletions(-)

diff --git a/lib/crypto/blake2s.c b/lib/crypto/blake2s.c
index 6182c21ed943..71578a084742 100644
--- a/lib/crypto/blake2s.c
+++ b/lib/crypto/blake2s.c
@@ -12,10 +12,11 @@
 #include <linux/bug.h>
 #include <linux/export.h>
 #include <linux/kernel.h>
 #include <linux/module.h>
 #include <linux/string.h>
+#include <linux/unroll.h>
 #include <linux/types.h>
 
 static const u8 blake2s_sigma[10][16] = {
 	{ 0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15 },
 	{ 14, 10, 4, 8, 9, 15, 13, 6, 1, 12, 0, 2, 11, 7, 5, 3 },
@@ -69,33 +70,26 @@ blake2s_compress_generic(struct blake2s_ctx *ctx,
 	d = ror32(d ^ a, 8); \
 	c += d; \
 	b = ror32(b ^ c, 7); \
 } while (0)
 
-#define ROUND(r) do { \
-	G(r, 0, v[0], v[ 4], v[ 8], v[12]); \
-	G(r, 1, v[1], v[ 5], v[ 9], v[13]); \
-	G(r, 2, v[2], v[ 6], v[10], v[14]); \
-	G(r, 3, v[3], v[ 7], v[11], v[15]); \
-	G(r, 4, v[0], v[ 5], v[10], v[15]); \
-	G(r, 5, v[1], v[ 6], v[11], v[12]); \
-	G(r, 6, v[2], v[ 7], v[ 8], v[13]); \
-	G(r, 7, v[3], v[ 4], v[ 9], v[14]); \
-} while (0)
-		ROUND(0);
-		ROUND(1);
-		ROUND(2);
-		ROUND(3);
-		ROUND(4);
-		ROUND(5);
-		ROUND(6);
-		ROUND(7);
-		ROUND(8);
-		ROUND(9);
-
+		/*
+		 * Unroll the rounds loop to enable constant-folding of the
+		 * blake2s_sigma values.
+		 */
+		unrolled_full
+		for (int r = 0; r < 10; r++) {
+			G(r, 0, v[0], v[4], v[8], v[12]);
+			G(r, 1, v[1], v[5], v[9], v[13]);
+			G(r, 2, v[2], v[6], v[10], v[14]);
+			G(r, 3, v[3], v[7], v[11], v[15]);
+			G(r, 4, v[0], v[5], v[10], v[15]);
+			G(r, 5, v[1], v[6], v[11], v[12]);
+			G(r, 6, v[2], v[7], v[8], v[13]);
+			G(r, 7, v[3], v[4], v[9], v[14]);
+		}
 #undef G
-#undef ROUND
 
 		for (i = 0; i < 8; ++i)
 			ctx->h[i] ^= v[i] ^ v[i + 8];
 
 		data += BLAKE2S_BLOCK_SIZE;

base-commit: 43dfc13ca972988e620a6edb72956981b75ab6b0
-- 
2.52.0

