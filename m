Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9A80E2DF3F2;
	Mon, 30 Jun 2025 16:09:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751299767; cv=none; b=E/am9IFqg3QmhGaB9LDD137+e2jEigfa4253hGNuz3Kfwu/K1aSwvfuiRNczSCZnlG8vNgVkInKdZI5rVZKV9Wr6eJvuvMXSWJAW1CmHSL8OcgThzA16n1rWP6fBpptdsYdggDGooHnjUhknJWded1MQpK3m957DeM56ceZFx3k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751299767; c=relaxed/simple;
	bh=hI7/9MXXn63qxg1DA2W2CAE23ZWS/FopAAuRjD/xhFs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=F9JjkLiN4rygUuCCv8nzepMt+H+ALVY0pdBzgUw138nzFhsP10Z5zGuNgx51j7Hmv9HORR13WCLZscdoTj7lhzr5BUFqc5Byug8RzJGSCKkATdU0H/Hhby3m2rXHtxMBJHn1aVqBdtq6iMA1sOOokoHe2AQSv8FLrEEJF5UBfkA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=oN5D7nM6; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="oN5D7nM6"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D4921C4CEF2;
	Mon, 30 Jun 2025 16:09:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1751299767;
	bh=hI7/9MXXn63qxg1DA2W2CAE23ZWS/FopAAuRjD/xhFs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=oN5D7nM68TGKPGZYZfUCmR2idT6QSU/9V6Bm4Nd+BH4W3ccbIdeb6eX7QizYZe7ce
	 b1C5ugHHJ0UyxkvLvqKHVwgxGKT2tGHhB6SkNjeJGS9EyxEhNmgQq5gaTCKepPBrbJ
	 5/KKuQsavBRZWjviiWq9Uc2bjEiTbU9DMXo7pTiwZtgmTIrc/Rb1onnm2pYpEKE2nL
	 jc5sTkLpA1W6qHTjKTlNmOXhKDDJcBdsrgZFT2ZZcVkciO2+Tsu4E2Cq1YITmIm7m9
	 uWHqbWEOtWiMOYhvUlspb4D980aEHInjhTTJMzcxAAfrmqYalRCh3cKOmAFJLmFBiN
	 uueT2Z+/VqTzA==
From: Eric Biggers <ebiggers@kernel.org>
To: linux-crypto@vger.kernel.org
Cc: linux-kernel@vger.kernel.org,
	linux-arm-kernel@lists.infradead.org,
	linux-mips@vger.kernel.org,
	linuxppc-dev@lists.ozlabs.org,
	linux-riscv@lists.infradead.org,
	linux-s390@vger.kernel.org,
	sparclinux@vger.kernel.org,
	x86@kernel.org,
	Ard Biesheuvel <ardb@kernel.org>,
	"Jason A . Donenfeld" <Jason@zx2c4.com>,
	Eric Biggers <ebiggers@kernel.org>
Subject: [PATCH v2 13/14] lib/crypto: sha256: Sync sha256_update() with sha512_update()
Date: Mon, 30 Jun 2025 09:06:44 -0700
Message-ID: <20250630160645.3198-14-ebiggers@kernel.org>
X-Mailer: git-send-email 2.50.0
In-Reply-To: <20250630160645.3198-1-ebiggers@kernel.org>
References: <20250630160645.3198-1-ebiggers@kernel.org>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

The BLOCK_HASH_UPDATE_BLOCKS macro is difficult to read.  For now, let's
just write the update explicitly in the straightforward way, mirroring
sha512_update().  It's possible that we'll bring back a macro for this
later, but it needs to be properly justified and hopefully a bit more
readable.

Signed-off-by: Eric Biggers <ebiggers@kernel.org>
---
 lib/crypto/sha256.c | 28 +++++++++++++++++++++++++---
 1 file changed, 25 insertions(+), 3 deletions(-)

diff --git a/lib/crypto/sha256.c b/lib/crypto/sha256.c
index 68936d5cd7745..808438d4f4278 100644
--- a/lib/crypto/sha256.c
+++ b/lib/crypto/sha256.c
@@ -8,11 +8,10 @@
  * Copyright (c) 2014 Red Hat Inc.
  * Copyright 2025 Google LLC
  */
 
 #include <crypto/hmac.h>
-#include <crypto/internal/blockhash.h>
 #include <crypto/sha2.h>
 #include <linux/export.h>
 #include <linux/kernel.h>
 #include <linux/module.h>
 #include <linux/string.h>
@@ -178,12 +177,35 @@ EXPORT_SYMBOL_GPL(sha256_init);
 void __sha256_update(struct __sha256_ctx *ctx, const u8 *data, size_t len)
 {
 	size_t partial = ctx->bytecount % SHA256_BLOCK_SIZE;
 
 	ctx->bytecount += len;
-	BLOCK_HASH_UPDATE_BLOCKS(sha256_blocks, &ctx->state, data, len,
-				 SHA256_BLOCK_SIZE, ctx->buf, partial);
+
+	if (partial + len >= SHA256_BLOCK_SIZE) {
+		size_t nblocks;
+
+		if (partial) {
+			size_t l = SHA256_BLOCK_SIZE - partial;
+
+			memcpy(&ctx->buf[partial], data, l);
+			data += l;
+			len -= l;
+
+			sha256_blocks(&ctx->state, ctx->buf, 1);
+		}
+
+		nblocks = len / SHA256_BLOCK_SIZE;
+		len %= SHA256_BLOCK_SIZE;
+
+		if (nblocks) {
+			sha256_blocks(&ctx->state, data, nblocks);
+			data += nblocks * SHA256_BLOCK_SIZE;
+		}
+		partial = 0;
+	}
+	if (len)
+		memcpy(&ctx->buf[partial], data, len);
 }
 EXPORT_SYMBOL(__sha256_update);
 
 static void __sha256_final(struct __sha256_ctx *ctx,
 			   u8 *out, size_t digest_size)
-- 
2.50.0

