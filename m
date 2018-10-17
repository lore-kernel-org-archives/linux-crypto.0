Return-Path: <SRS0=Iqog=M5=vger.kernel.org=linux-crypto-owner@kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:55434 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727173AbeJQOMn (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 17 Oct 2018 10:12:43 -0400
From: Eric Biggers <ebiggers@kernel.org>
To: linux-crypto@vger.kernel.org,
        Herbert Xu <herbert@gondor.apana.org.au>
Cc: Ard Biesheuvel <ard.biesheuvel@linaro.org>,
        Paul Crowley <paulcrowley@google.com>
Subject: [PATCH v2 1/2] crypto: aes_ti - disable interrupts while accessing S-box
Date: Tue, 16 Oct 2018 23:18:12 -0700
Message-Id: <20181017061813.32751-2-ebiggers@kernel.org>
In-Reply-To: <20181017061813.32751-1-ebiggers@kernel.org>
References: <20181017061813.32751-1-ebiggers@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

From: Eric Biggers <ebiggers@google.com>

In the "aes-fixed-time" AES implementation, disable interrupts while
accessing the S-box, in order to make cache-timing attacks more
difficult.  Previously it was possible for the CPU to be interrupted
while the S-box was loaded into L1 cache, potentially evicting the
cachelines and causing later table lookups to be time-variant.

In tests I did on x86 and ARM, this doesn't affect performance
significantly.  Responsiveness is potentially a concern, but interrupts
are only disabled for a single AES block.

Note that even after this change, the implementation still isn't
necessarily guaranteed to be constant-time; see
https://cr.yp.to/antiforgery/cachetiming-20050414.pdf for a discussion
of the many difficulties involved in writing truly constant-time AES
software.  But it's valuable to make such attacks more difficult.

Signed-off-by: Eric Biggers <ebiggers@google.com>
---
 crypto/aes_ti.c | 18 ++++++++++++++++++
 1 file changed, 18 insertions(+)

diff --git a/crypto/aes_ti.c b/crypto/aes_ti.c
index 03023b2290e8..1ff9785b30f5 100644
--- a/crypto/aes_ti.c
+++ b/crypto/aes_ti.c
@@ -269,6 +269,7 @@ static void aesti_encrypt(struct crypto_tfm *tfm, u8 *out, const u8 *in)
 	const u32 *rkp = ctx->key_enc + 4;
 	int rounds = 6 + ctx->key_length / 4;
 	u32 st0[4], st1[4];
+	unsigned long flags;
 	int round;
 
 	st0[0] = ctx->key_enc[0] ^ get_unaligned_le32(in);
@@ -276,6 +277,12 @@ static void aesti_encrypt(struct crypto_tfm *tfm, u8 *out, const u8 *in)
 	st0[2] = ctx->key_enc[2] ^ get_unaligned_le32(in + 8);
 	st0[3] = ctx->key_enc[3] ^ get_unaligned_le32(in + 12);
 
+	/*
+	 * Temporarily disable interrupts to avoid races where cachelines are
+	 * evicted when the CPU is interrupted to do something else.
+	 */
+	local_irq_save(flags);
+
 	st0[0] ^= __aesti_sbox[ 0] ^ __aesti_sbox[128];
 	st0[1] ^= __aesti_sbox[32] ^ __aesti_sbox[160];
 	st0[2] ^= __aesti_sbox[64] ^ __aesti_sbox[192];
@@ -300,6 +307,8 @@ static void aesti_encrypt(struct crypto_tfm *tfm, u8 *out, const u8 *in)
 	put_unaligned_le32(subshift(st1, 1) ^ rkp[5], out + 4);
 	put_unaligned_le32(subshift(st1, 2) ^ rkp[6], out + 8);
 	put_unaligned_le32(subshift(st1, 3) ^ rkp[7], out + 12);
+
+	local_irq_restore(flags);
 }
 
 static void aesti_decrypt(struct crypto_tfm *tfm, u8 *out, const u8 *in)
@@ -308,6 +317,7 @@ static void aesti_decrypt(struct crypto_tfm *tfm, u8 *out, const u8 *in)
 	const u32 *rkp = ctx->key_dec + 4;
 	int rounds = 6 + ctx->key_length / 4;
 	u32 st0[4], st1[4];
+	unsigned long flags;
 	int round;
 
 	st0[0] = ctx->key_dec[0] ^ get_unaligned_le32(in);
@@ -315,6 +325,12 @@ static void aesti_decrypt(struct crypto_tfm *tfm, u8 *out, const u8 *in)
 	st0[2] = ctx->key_dec[2] ^ get_unaligned_le32(in + 8);
 	st0[3] = ctx->key_dec[3] ^ get_unaligned_le32(in + 12);
 
+	/*
+	 * Temporarily disable interrupts to avoid races where cachelines are
+	 * evicted when the CPU is interrupted to do something else.
+	 */
+	local_irq_save(flags);
+
 	st0[0] ^= __aesti_inv_sbox[ 0] ^ __aesti_inv_sbox[128];
 	st0[1] ^= __aesti_inv_sbox[32] ^ __aesti_inv_sbox[160];
 	st0[2] ^= __aesti_inv_sbox[64] ^ __aesti_inv_sbox[192];
@@ -339,6 +355,8 @@ static void aesti_decrypt(struct crypto_tfm *tfm, u8 *out, const u8 *in)
 	put_unaligned_le32(inv_subshift(st1, 1) ^ rkp[5], out + 4);
 	put_unaligned_le32(inv_subshift(st1, 2) ^ rkp[6], out + 8);
 	put_unaligned_le32(inv_subshift(st1, 3) ^ rkp[7], out + 12);
+
+	local_irq_restore(flags);
 }
 
 static struct crypto_alg aes_alg = {
-- 
2.19.1
