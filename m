Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6970F239E76;
	Sat, 14 Mar 2026 17:35:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773509756; cv=none; b=iEtt3gW0hFu/MrHUs5LwrV+4ssfUd4rC4jjsQdWhD+5VCI/vGIes+3Y87md0J5f2Oj/zKkM54YoGy/c56n62bch3x2yziFC6uXFTP4/+qu4Mjt/9Vzm3qzUUK0gb+2ozPZrs6aq/L4haouANfDq7M1TzmyQMKamJZ3oxV52J4ko=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773509756; c=relaxed/simple;
	bh=+e71JxLMdeYDcE8yIAsCr0/P60ySLNS2qVdjZT/waCQ=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=JnKNZyxmkmlitaQypMcU3f1VLkH2/plfjcv8MwVMKPTnqa0E3jMaczeVYa6FsTipxPeDdPu/tc9oZL8/EuA+Z4s4qfAgn1As6V8FtWmET1zRUAVLBPnaEnPI+pyumU+dLTGcXoKJlguL5hwiOk2wNK4ltdSX/kqqOcTE6vkHhm0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=PPBuDH+v; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="PPBuDH+v"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A65CDC116C6;
	Sat, 14 Mar 2026 17:35:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1773509756;
	bh=+e71JxLMdeYDcE8yIAsCr0/P60ySLNS2qVdjZT/waCQ=;
	h=From:To:Cc:Subject:Date:From;
	b=PPBuDH+vb1X8oIE7pdpT8Gc3OUUI7O9daa7DkFAGYgJyZvQ9/90VMQDW5PbB1FFAR
	 +mMCQhFpy7NWdmX66c0mxas/rsiPkAlEMFsSeSdwlrMtrV9o8NIfeYM/b11lEHc6/o
	 iSlhW0/m4ijkmhFCajhzb4s6pX/0ZTQIRn1628AF1UK+Bb6liHdEyB7lVbKhlklSai
	 XAtCtJ00VENUQDDLV48RtGn1t0cyojWrH2xp7QBhwFxKz/V8/Nwm04mWdiUc5A/6jy
	 R1c9os9n0ZZRk6hzvE8RQzbjHrxaAMZnL8/8jBfPm24UBl0rk+/GODj4b1FGnAdimN
	 HVSRa7fAI1QmA==
From: Eric Biggers <ebiggers@kernel.org>
To: linux-crypto@vger.kernel.org
Cc: linux-kernel@vger.kernel.org,
	Ard Biesheuvel <ardb@kernel.org>,
	"Jason A . Donenfeld" <Jason@zx2c4.com>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	Eric Biggers <ebiggers@kernel.org>
Subject: [PATCH] lib/crypto: Remove unused file blockhash.h
Date: Sat, 14 Mar 2026 10:35:26 -0700
Message-ID: <20260314173526.17349-1-ebiggers@kernel.org>
X-Mailer: git-send-email 2.53.0
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

For a short time this file was used by the SHA-256 and Poly1305 library
code, but they are no longer using it.  Remove this unused file.

Signed-off-by: Eric Biggers <ebiggers@kernel.org>
---

This patch is targeting libcrypto-next

 include/crypto/internal/blockhash.h | 52 -----------------------------
 1 file changed, 52 deletions(-)
 delete mode 100644 include/crypto/internal/blockhash.h

diff --git a/include/crypto/internal/blockhash.h b/include/crypto/internal/blockhash.h
deleted file mode 100644
index 52d9d4c82493d..0000000000000
--- a/include/crypto/internal/blockhash.h
+++ /dev/null
@@ -1,52 +0,0 @@
-/* SPDX-License-Identifier: GPL-2.0-or-later */
-/*
- * Handle partial blocks for block hash.
- *
- * Copyright (c) 2015 Linaro Ltd <ard.biesheuvel@linaro.org>
- * Copyright (c) 2025 Herbert Xu <herbert@gondor.apana.org.au>
- */
-
-#ifndef _CRYPTO_INTERNAL_BLOCKHASH_H
-#define _CRYPTO_INTERNAL_BLOCKHASH_H
-
-#include <linux/string.h>
-#include <linux/types.h>
-
-#define BLOCK_HASH_UPDATE_BASE(block_fn, state, src, nbytes, bs, dv,	\
-			       buf, buflen)				\
-	({								\
-		typeof(block_fn) *_block_fn = &(block_fn);		\
-		typeof(state + 0) _state = (state);			\
-		unsigned int _buflen = (buflen);			\
-		size_t _nbytes = (nbytes);				\
-		unsigned int _bs = (bs);				\
-		const u8 *_src = (src);					\
-		u8 *_buf = (buf);					\
-		while ((_buflen + _nbytes) >= _bs) {			\
-			const u8 *data = _src;				\
-			size_t len = _nbytes;				\
-			size_t blocks;					\
-			int remain;					\
-			if (_buflen) {					\
-				remain = _bs - _buflen;			\
-				memcpy(_buf + _buflen, _src, remain);	\
-				data = _buf;				\
-				len = _bs;				\
-			}						\
-			remain = len % bs;				\
-			blocks = (len - remain) / (dv);			\
-			(*_block_fn)(_state, data, blocks);		\
-			_src += len - remain - _buflen;			\
-			_nbytes -= len - remain - _buflen;		\
-			_buflen = 0;					\
-		}							\
-		memcpy(_buf + _buflen, _src, _nbytes);			\
-		_buflen += _nbytes;					\
-	})
-
-#define BLOCK_HASH_UPDATE(block, state, src, nbytes, bs, buf, buflen) \
-	BLOCK_HASH_UPDATE_BASE(block, state, src, nbytes, bs, 1, buf, buflen)
-#define BLOCK_HASH_UPDATE_BLOCKS(block, state, src, nbytes, bs, buf, buflen) \
-	BLOCK_HASH_UPDATE_BASE(block, state, src, nbytes, bs, bs, buf, buflen)
-
-#endif	/* _CRYPTO_INTERNAL_BLOCKHASH_H */

base-commit: ce260754bb435aea18e6a1a1ce3759249013f5a4
-- 
2.53.0

