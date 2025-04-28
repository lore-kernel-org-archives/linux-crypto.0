Received: from abb.hmeau.com (abb.hmeau.com [144.6.53.87])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E58B419AD5C
	for <linux-crypto@vger.kernel.org>; Mon, 28 Apr 2025 04:56:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=144.6.53.87
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745816171; cv=none; b=TBmwrCL1r4XbmBfGuOv0F6ubrwPoHKjRDkCvue3QDVhWUEGP+3HKonqOUObWzm6cG6vtOL2kZtm+6Y7uNOdCKSedIWExvPhPOlg8dx4BYhlbSiT0tTo5ikrpDSAQg24dwizhQgPGqPLEW4x0OW2MqHDBTqgOlwnUbUFebbUci5E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745816171; c=relaxed/simple;
	bh=GSgpElAODLSIY0isZ3Egr44EVzY3+OlE8M5z3NX0H/I=;
	h=Date:Message-Id:In-Reply-To:References:From:Subject:To; b=sHs7X7H5z4xt3DNefAwKToPChEPUALN4eBj/PpcsD2UjsCwfRl10xu8Z71kOILju4mz0Hfn/JDoBnszI2fTMMtXvQuHePy3iCmcBxD2H63KkbBM332pZhviLuzXddN8d9CsRlSteu4gJiXxh58KBHH+yCu+t2JALNqAveS6AzQg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au; spf=pass smtp.mailfrom=gondor.apana.org.au; dkim=pass (2048-bit key) header.d=hmeau.com header.i=@hmeau.com header.b=Zno7TNz3; arc=none smtp.client-ip=144.6.53.87
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=hmeau.com header.i=@hmeau.com header.b="Zno7TNz3"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=hmeau.com;
	s=formenos; h=To:Subject:From:References:In-Reply-To:Message-Id:Date:Sender:
	Reply-To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=LK86qJrMBaZMAoaw9iegwb6jADcyWFxm0O3RWWUcPuQ=; b=Zno7TNz3RjDThj100AMDGS+yXn
	c3hXc9NtjJYXERSOdT8J7I4lC772qq6fj0Lgb2cDABNu1XJMgCq3/ATZgNmaa2dvHgWHlhSq/EVv/
	6H11xN9u06dKmLHGWsJn4z1o9NdaCNvAt1oSSFpIV668n24oPNJ1rFHHHZVERbS4hxDByNa2Ncp1l
	yR5ScQrv7w5zCoo04Kw8dKZgYJ9EdCJPnFhTPTx9G7uGf1NQgBZ+6Ud8DiSO2hTzm2knf1nSKzumq
	l1Lnk3CCm3eYXh2ZgFpUgx4L/2gsz59EXHO+cVNwTP0Pr2B7D2x85XHVW35DDL6fwaxVMN2eBNDnN
	5J8JPGPw==;
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.96 #2 (Debian))
	id 1u9GXF-001WEk-04;
	Mon, 28 Apr 2025 12:56:06 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Mon, 28 Apr 2025 12:56:05 +0800
Date: Mon, 28 Apr 2025 12:56:05 +0800
Message-Id: <5e58f9adebc4c9b38bffbf38aca8149bee229e78.1745815528.git.herbert@gondor.apana.org.au>
In-Reply-To: <cover.1745815528.git.herbert@gondor.apana.org.au>
References: <cover.1745815528.git.herbert@gondor.apana.org.au>
From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: [v4 PATCH 01/11] crypto: lib/sha256 - Move partial block handling out
To: Linux Crypto Mailing List <linux-crypto@vger.kernel.org>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>

Extract the common partial block handling into a helper macro
that can be reused by other library code.

Also delete the unused sha256_base_do_finalize function.

Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
---
 include/crypto/internal/blockhash.h | 52 +++++++++++++++++++++++++++++
 include/crypto/sha2.h               |  9 +++--
 include/crypto/sha256_base.h        | 38 ++-------------------
 3 files changed, 62 insertions(+), 37 deletions(-)
 create mode 100644 include/crypto/internal/blockhash.h

diff --git a/include/crypto/internal/blockhash.h b/include/crypto/internal/blockhash.h
new file mode 100644
index 000000000000..52d9d4c82493
--- /dev/null
+++ b/include/crypto/internal/blockhash.h
@@ -0,0 +1,52 @@
+/* SPDX-License-Identifier: GPL-2.0-or-later */
+/*
+ * Handle partial blocks for block hash.
+ *
+ * Copyright (c) 2015 Linaro Ltd <ard.biesheuvel@linaro.org>
+ * Copyright (c) 2025 Herbert Xu <herbert@gondor.apana.org.au>
+ */
+
+#ifndef _CRYPTO_INTERNAL_BLOCKHASH_H
+#define _CRYPTO_INTERNAL_BLOCKHASH_H
+
+#include <linux/string.h>
+#include <linux/types.h>
+
+#define BLOCK_HASH_UPDATE_BASE(block_fn, state, src, nbytes, bs, dv,	\
+			       buf, buflen)				\
+	({								\
+		typeof(block_fn) *_block_fn = &(block_fn);		\
+		typeof(state + 0) _state = (state);			\
+		unsigned int _buflen = (buflen);			\
+		size_t _nbytes = (nbytes);				\
+		unsigned int _bs = (bs);				\
+		const u8 *_src = (src);					\
+		u8 *_buf = (buf);					\
+		while ((_buflen + _nbytes) >= _bs) {			\
+			const u8 *data = _src;				\
+			size_t len = _nbytes;				\
+			size_t blocks;					\
+			int remain;					\
+			if (_buflen) {					\
+				remain = _bs - _buflen;			\
+				memcpy(_buf + _buflen, _src, remain);	\
+				data = _buf;				\
+				len = _bs;				\
+			}						\
+			remain = len % bs;				\
+			blocks = (len - remain) / (dv);			\
+			(*_block_fn)(_state, data, blocks);		\
+			_src += len - remain - _buflen;			\
+			_nbytes -= len - remain - _buflen;		\
+			_buflen = 0;					\
+		}							\
+		memcpy(_buf + _buflen, _src, _nbytes);			\
+		_buflen += _nbytes;					\
+	})
+
+#define BLOCK_HASH_UPDATE(block, state, src, nbytes, bs, buf, buflen) \
+	BLOCK_HASH_UPDATE_BASE(block, state, src, nbytes, bs, 1, buf, buflen)
+#define BLOCK_HASH_UPDATE_BLOCKS(block, state, src, nbytes, bs, buf, buflen) \
+	BLOCK_HASH_UPDATE_BASE(block, state, src, nbytes, bs, bs, buf, buflen)
+
+#endif	/* _CRYPTO_INTERNAL_BLOCKHASH_H */
diff --git a/include/crypto/sha2.h b/include/crypto/sha2.h
index abbd882f7849..f873c2207b1e 100644
--- a/include/crypto/sha2.h
+++ b/include/crypto/sha2.h
@@ -71,8 +71,13 @@ struct crypto_sha256_state {
 };
 
 struct sha256_state {
-	u32 state[SHA256_DIGEST_SIZE / 4];
-	u64 count;
+	union {
+		struct crypto_sha256_state ctx;
+		struct {
+			u32 state[SHA256_DIGEST_SIZE / 4];
+			u64 count;
+		};
+	};
 	u8 buf[SHA256_BLOCK_SIZE];
 };
 
diff --git a/include/crypto/sha256_base.h b/include/crypto/sha256_base.h
index 08cd5e41d4fd..9f284bed5a51 100644
--- a/include/crypto/sha256_base.h
+++ b/include/crypto/sha256_base.h
@@ -8,6 +8,7 @@
 #ifndef _CRYPTO_SHA256_BASE_H
 #define _CRYPTO_SHA256_BASE_H
 
+#include <crypto/internal/blockhash.h>
 #include <crypto/internal/hash.h>
 #include <crypto/sha2.h>
 #include <linux/math.h>
@@ -40,35 +41,10 @@ static inline int lib_sha256_base_do_update(struct sha256_state *sctx,
 					    sha256_block_fn *block_fn)
 {
 	unsigned int partial = sctx->count % SHA256_BLOCK_SIZE;
-	struct crypto_sha256_state *state = (void *)sctx;
 
 	sctx->count += len;
-
-	if (unlikely((partial + len) >= SHA256_BLOCK_SIZE)) {
-		int blocks;
-
-		if (partial) {
-			int p = SHA256_BLOCK_SIZE - partial;
-
-			memcpy(sctx->buf + partial, data, p);
-			data += p;
-			len -= p;
-
-			block_fn(state, sctx->buf, 1);
-		}
-
-		blocks = len / SHA256_BLOCK_SIZE;
-		len %= SHA256_BLOCK_SIZE;
-
-		if (blocks) {
-			block_fn(state, data, blocks);
-			data += blocks * SHA256_BLOCK_SIZE;
-		}
-		partial = 0;
-	}
-	if (len)
-		memcpy(sctx->buf + partial, data, len);
-
+	BLOCK_HASH_UPDATE_BLOCKS(block_fn, &sctx->ctx, data, len,
+				 SHA256_BLOCK_SIZE, sctx->buf, partial);
 	return 0;
 }
 
@@ -140,14 +116,6 @@ static inline int lib_sha256_base_do_finalize(struct sha256_state *sctx,
 	return lib_sha256_base_do_finup(state, sctx->buf, partial, block_fn);
 }
 
-static inline int sha256_base_do_finalize(struct shash_desc *desc,
-					  sha256_block_fn *block_fn)
-{
-	struct sha256_state *sctx = shash_desc_ctx(desc);
-
-	return lib_sha256_base_do_finalize(sctx, block_fn);
-}
-
 static inline int __sha256_base_finish(u32 state[SHA256_DIGEST_SIZE / 4],
 				       u8 *out, unsigned int digest_size)
 {
-- 
2.39.5

