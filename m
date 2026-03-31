Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4698D13D51E;
	Tue, 31 Mar 2026 02:45:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774925142; cv=none; b=l5hqA3qJU+RKBEtQwuXPXPkkcdeC7Mfx4vW3LNzsltByBfEq0Fdzg6C8TCbn7ara1JwJdB1irUMucLHGxs7t2dwwxEs9LQjefVoU1HcjqFBuwv4oqI4m3ddZehAR994W6q8emV94U0GE2nkCHXxEXmIiHdVXPzOXmNEDpy1VHTE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774925142; c=relaxed/simple;
	bh=LxHDt1/WnyAbr3ZXIY+jsIxH8467Rt7tU6MbjaqQrZU=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=QMhYwqwV4gvxTtTJt19KIPLPT/zIzWwJH30JoJmrq8bOjWOeZkqgiBA8lVo42uYdC0zR5Y/x+oUeMu8p0I9k7gGEzx0QRaQZQOZ6EaxKMwST3lpJPDjRBSnaP3j+E/5VUU4V/mblTq3XQG4vqFemthvlWnoRJU8ZkrHJXAbb2sM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=TSpKj6zl; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="TSpKj6zl"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ACD5BC4CEF7;
	Tue, 31 Mar 2026 02:45:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1774925141;
	bh=LxHDt1/WnyAbr3ZXIY+jsIxH8467Rt7tU6MbjaqQrZU=;
	h=From:To:Cc:Subject:Date:From;
	b=TSpKj6zlJ5eokl7/Yjs0J7NjdEvpk4Z5RMXOtnVbXI04004oBgAdfohMIFNb7Er4e
	 wHCjZ2K6CZgAVpXwBot3qZgEgQx3Ims8TUUNhbcLSKj4N/wL9KUiGJPUd/+rEbFwQN
	 I7Q9NRPnskFqKikWER1ew2b3KorEV2bv9lJsgLnv14Lo/m4V79WwoiV2jeG5v4Bmnb
	 5dlFyuyQcEPaJJVfkZFZi4a9Wps+xBpHEi1Dcx0G3AQrfPDDhYOqRNg1ya4M7QhtQt
	 zz/NX+ps8LwQVgxwKP3pzwi+s/9w9fenUQBuTW8KlX7+nkBwd/YOeq7Lxkv8mV9ioR
	 uiATqrjAUYhdA==
From: Eric Biggers <ebiggers@kernel.org>
To: linux-crypto@vger.kernel.org
Cc: linux-kernel@vger.kernel.org,
	Ard Biesheuvel <ardb@kernel.org>,
	"Jason A . Donenfeld" <Jason@zx2c4.com>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	Eric Biggers <ebiggers@kernel.org>
Subject: [PATCH] lib/crypto: aesgcm: Don't disable IRQs during AES block encryption
Date: Mon, 30 Mar 2026 19:44:30 -0700
Message-ID: <20260331024430.51755-1-ebiggers@kernel.org>
X-Mailer: git-send-email 2.53.0
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

aes_encrypt() now uses AES instructions when available instead of always
using table-based code.  AES instructions are constant-time and don't
benefit from disabling IRQs as a constant-time hardening measure.

In fact, on two architectures (arm and riscv) disabling IRQs is
counterproductive because it prevents the AES instructions from being
used.  (See the may_use_simd() implementation on those architectures.)

Therefore, let's remove the IRQ disabling/enabling and leave the choice
of constant-time hardening measures to the AES library code.

Note that currently the arm table-based AES code (which runs on arm
kernels that don't have ARMv8 CE) disables IRQs, while the generic
table-based AES code does not.  So this does technically regress in
constant-time hardening when that generic code is used.  But as
discussed in commit a22fd0e3c495 ("lib/crypto: aes: Introduce improved
AES library") I think just leaving IRQs enabled is the right choice.
Disabling them is slow and can cause problems, and AES instructions
(which modern CPUs have) solve the problem in a much better way anyway.

Signed-off-by: Eric Biggers <ebiggers@kernel.org>
---
 lib/crypto/aesgcm.c | 25 +++----------------------
 1 file changed, 3 insertions(+), 22 deletions(-)

diff --git a/lib/crypto/aesgcm.c b/lib/crypto/aesgcm.c
index 8c7e74d2d147..1da31e1f747d 100644
--- a/lib/crypto/aesgcm.c
+++ b/lib/crypto/aesgcm.c
@@ -7,29 +7,10 @@
 
 #include <crypto/gcm.h>
 #include <crypto/utils.h>
 #include <linux/export.h>
 #include <linux/module.h>
-#include <asm/irqflags.h>
-
-static void aesgcm_encrypt_block(const struct aes_enckey *key, void *dst,
-				 const void *src)
-{
-	unsigned long flags;
-
-	/*
-	 * In AES-GCM, both the GHASH key derivation and the CTR mode
-	 * encryption operate on known plaintext, making them susceptible to
-	 * timing attacks on the encryption key. The AES library already
-	 * mitigates this risk to some extent by pulling the entire S-box into
-	 * the caches before doing any substitutions, but this strategy is more
-	 * effective when running with interrupts disabled.
-	 */
-	local_irq_save(flags);
-	aes_encrypt(key, dst, src);
-	local_irq_restore(flags);
-}
 
 /**
  * aesgcm_expandkey - Expands the AES and GHASH keys for the AES-GCM key
  *		      schedule
  *
@@ -51,11 +32,11 @@ int aesgcm_expandkey(struct aesgcm_ctx *ctx, const u8 *key,
 	      aes_prepareenckey(&ctx->aes_key, key, keysize);
 	if (ret)
 		return ret;
 
 	ctx->authsize = authsize;
-	aesgcm_encrypt_block(&ctx->aes_key, h, h);
+	aes_encrypt(&ctx->aes_key, h, h);
 	ghash_preparekey(&ctx->ghash_key, h);
 	memzero_explicit(h, sizeof(h));
 	return 0;
 }
 EXPORT_SYMBOL(aesgcm_expandkey);
@@ -96,11 +77,11 @@ static void aesgcm_mac(const struct aesgcm_ctx *ctx, const u8 *src, int src_len,
 	ghash_update(&ghash, (const u8 *)&tail, sizeof(tail));
 
 	ghash_final(&ghash, ghash_out);
 
 	ctr[3] = cpu_to_be32(1);
-	aesgcm_encrypt_block(&ctx->aes_key, enc_ctr, ctr);
+	aes_encrypt(&ctx->aes_key, enc_ctr, (const u8 *)ctr);
 	crypto_xor_cpy(authtag, ghash_out, enc_ctr, ctx->authsize);
 
 	memzero_explicit(ghash_out, sizeof(ghash_out));
 	memzero_explicit(enc_ctr, sizeof(enc_ctr));
 }
@@ -118,11 +99,11 @@ static void aesgcm_crypt(const struct aesgcm_ctx *ctx, u8 *dst, const u8 *src,
 		 * inadvertent IV reuse, which must be avoided at all cost for
 		 * stream ciphers such as AES-CTR. Given the range of 'int
 		 * len', this cannot happen, so no explicit test is necessary.
 		 */
 		ctr[3] = cpu_to_be32(n++);
-		aesgcm_encrypt_block(&ctx->aes_key, buf, ctr);
+		aes_encrypt(&ctx->aes_key, buf, (const u8 *)ctr);
 		crypto_xor_cpy(dst, src, buf, min(len, AES_BLOCK_SIZE));
 
 		dst += AES_BLOCK_SIZE;
 		src += AES_BLOCK_SIZE;
 		len -= AES_BLOCK_SIZE;

base-commit: d2a68aba8505ce88b39c34ecb3b707c776af79d4
prerequisite-patch-id: bb75bceea1086ce63912baf959cd010cdd451208
-- 
2.53.0

