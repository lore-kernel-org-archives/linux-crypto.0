From: Ard Biesheuvel <ard.biesheuvel@linaro.org>
Subject: [RFC PATCH] crypto: algapi - make crypto_xor() and crypto_inc() alignment agnostic
Date: Mon, 30 Jan 2017 14:11:29 +0000
Message-ID: <1485785489-5116-1-git-send-email-ard.biesheuvel@linaro.org>
Cc: Ard Biesheuvel <ard.biesheuvel@linaro.org>
To: linux-crypto@vger.kernel.org, herbert@gondor.apana.org.au
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-wm0-f50.google.com ([74.125.82.50]:36524 "EHLO
        mail-wm0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932109AbdA3OLp (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 30 Jan 2017 09:11:45 -0500
Received: by mail-wm0-f50.google.com with SMTP id c85so216232861wmi.1
        for <linux-crypto@vger.kernel.org>; Mon, 30 Jan 2017 06:11:44 -0800 (PST)
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Instead of unconditionally forcing 4 byte alignment for all generic
chaining modes that rely on crypto_xor() or crypto_inc() (which may
result in unnecessary copying of data when the underlying hardware
can perform unaligned accesses efficiently), make those functions
deal with unaligned input explicitly, but only if the Kconfig symbol
HAVE_EFFICIENT_UNALIGNED_ACCESS is set. This will allow us to drop
the alignmasks from the CBC, CMAC, CTR, CTS, PCBC and SEQIV drivers.

For crypto_inc(), this simply involves making the 4-byte stride
conditional on HAVE_EFFICIENT_UNALIGNED_ACCESS being set, given that
it typically operates on 16 byte buffers.

For crypto_xor(), an algorithm is implemented that simply runs through
the input using the largest strides possible if unaligned accesses are
allowed. If they are not, an optimal sequence of memory accesses is
emitted that takes the relative alignment of the input buffers into
account, e.g., if the relative misalignment of dst and src is 4 bytes,
the entire xor operation will be completed using 4 byte loads and stores
(modulo unaligned bits at the start and end). Note that all expressions
involving startalign and misalign are simply eliminated by the compiler
if HAVE_EFFICIENT_UNALIGNED_ACCESS is defined.

Signed-off-by: Ard Biesheuvel <ard.biesheuvel@linaro.org>
---
 crypto/algapi.c | 102 ++++++++++++++++----
 crypto/cbc.c    |   3 -
 crypto/cmac.c   |   3 +-
 crypto/ctr.c    |   2 +-
 crypto/cts.c    |   3 -
 crypto/pcbc.c   |   3 -
 crypto/seqiv.c  |   2 -
 7 files changed, 87 insertions(+), 31 deletions(-)

diff --git a/crypto/algapi.c b/crypto/algapi.c
index df939b54b09f..771284473a97 100644
--- a/crypto/algapi.c
+++ b/crypto/algapi.c
@@ -961,32 +961,100 @@ void crypto_inc(u8 *a, unsigned int size)
 	__be32 *b = (__be32 *)(a + size);
 	u32 c;
 
-	for (; size >= 4; size -= 4) {
-		c = be32_to_cpu(*--b) + 1;
-		*b = cpu_to_be32(c);
-		if (c)
-			return;
-	}
+	if (IS_ENABLED(CONFIG_HAVE_EFFICIENT_UNALIGNED_ACCESS) ||
+	    !((unsigned long)b & (__alignof__(*b) - 1)))
+		for (; size >= 4; size -= 4) {
+			c = be32_to_cpu(*--b) + 1;
+			*b = cpu_to_be32(c);
+			if (c)
+				return;
+		}
 
 	crypto_inc_byte(a, size);
 }
 EXPORT_SYMBOL_GPL(crypto_inc);
 
-static inline void crypto_xor_byte(u8 *a, const u8 *b, unsigned int size)
+void crypto_xor(u8 *dst, const u8 *src, unsigned int len)
 {
-	for (; size; size--)
-		*a++ ^= *b++;
-}
+	const int size = sizeof(unsigned long);
+	const int mask = size - 1;
+	int misalign = ((unsigned long)dst ^ (unsigned long)src) & mask;
+	int startalign = ((unsigned long)dst | (unsigned long)src) & mask;
+
+	if (IS_ENABLED(CONFIG_HAVE_EFFICIENT_UNALIGNED_ACCESS))
+		misalign = startalign = 0;
+
+	while (len > 0) {
+		/*
+		 * Process as much data as we can using 4 or 8 byte strides
+		 * (depending on the size of unsigned long) if
+		 * a) we don't care about alignment, or
+		 * b) we do care about alignment, but dst and src are both
+		 *    suitably aligned
+		 */
+		if (startalign == 0) {
+			unsigned long *a = (unsigned long *)dst;
+			const unsigned long *b = (const unsigned long *)src;
+
+			dst += len & ~mask;
+			src += len & ~mask;
+
+			for (; len >= size; len -= size)
+				*a++ ^= *b++;
+		}
 
-void crypto_xor(u8 *dst, const u8 *src, unsigned int size)
-{
-	u32 *a = (u32 *)dst;
-	u32 *b = (u32 *)src;
+		if (IS_ENABLED(CONFIG_64BIT)) {
+			do {
+				u32 *a = (u32 *)dst;
+				const u32 *b = (u32 *)src;
+
+				if (len < sizeof(u32) ||
+				    (startalign & (sizeof(u32) - 1)) != 0)
+					break;
+
+				if (len >= size && misalign != sizeof(u32) &&
+				    (startalign & sizeof(u32)) == 0)
+					break;
+
+				*a ^= *b;
+				dst += sizeof(u32);
+				src += sizeof(u32);
+				len -= sizeof(u32);
+				startalign &= ~sizeof(u32);
+			} while (misalign == sizeof(u32));
+		}
 
-	for (; size >= 4; size -= 4)
-		*a++ ^= *b++;
+		do {
+			u16 *a = (u16 *)dst;
+			const u16 *b = (u16 *)src;
+
+			if (len < sizeof(u16) ||
+			    (startalign & (sizeof(u16) - 1)) != 0)
+				break;
 
-	crypto_xor_byte((u8 *)a, (u8 *)b, size);
+			if (len >= size && (startalign & sizeof(u16)) == 0 &&
+			    (misalign % sizeof(u32)) != sizeof(u16))
+				break;
+
+			*a ^= *b;
+			dst += sizeof(u16);
+			src += sizeof(u16);
+			len -= sizeof(u16);
+			startalign &= ~sizeof(u16);
+		} while ((misalign % sizeof(u32)) == sizeof(u16));
+
+		do {
+			if (len < sizeof(u8))
+				break;
+
+			if (len >= size && !(startalign & 1) && !(misalign & 1))
+				break;
+
+			*dst++ ^= *src++;
+			len -= sizeof(u8);
+			startalign &= ~sizeof(u8);
+		} while (misalign & 1);
+	}
 }
 EXPORT_SYMBOL_GPL(crypto_xor);
 
diff --git a/crypto/cbc.c b/crypto/cbc.c
index 68f751a41a84..bc160a3186dc 100644
--- a/crypto/cbc.c
+++ b/crypto/cbc.c
@@ -145,9 +145,6 @@ static int crypto_cbc_create(struct crypto_template *tmpl, struct rtattr **tb)
 	inst->alg.base.cra_blocksize = alg->cra_blocksize;
 	inst->alg.base.cra_alignmask = alg->cra_alignmask;
 
-	/* We access the data as u32s when xoring. */
-	inst->alg.base.cra_alignmask |= __alignof__(u32) - 1;
-
 	inst->alg.ivsize = alg->cra_blocksize;
 	inst->alg.min_keysize = alg->cra_cipher.cia_min_keysize;
 	inst->alg.max_keysize = alg->cra_cipher.cia_max_keysize;
diff --git a/crypto/cmac.c b/crypto/cmac.c
index 04080dca8f0c..16301f52858c 100644
--- a/crypto/cmac.c
+++ b/crypto/cmac.c
@@ -260,8 +260,7 @@ static int cmac_create(struct crypto_template *tmpl, struct rtattr **tb)
 	if (err)
 		goto out_free_inst;
 
-	/* We access the data as u32s when xoring. */
-	alignmask = alg->cra_alignmask | (__alignof__(u32) - 1);
+	alignmask = alg->cra_alignmask;
 	inst->alg.base.cra_alignmask = alignmask;
 	inst->alg.base.cra_priority = alg->cra_priority;
 	inst->alg.base.cra_blocksize = alg->cra_blocksize;
diff --git a/crypto/ctr.c b/crypto/ctr.c
index a9a7a44f2783..a4f4a8983169 100644
--- a/crypto/ctr.c
+++ b/crypto/ctr.c
@@ -209,7 +209,7 @@ static struct crypto_instance *crypto_ctr_alloc(struct rtattr **tb)
 	inst->alg.cra_flags = CRYPTO_ALG_TYPE_BLKCIPHER;
 	inst->alg.cra_priority = alg->cra_priority;
 	inst->alg.cra_blocksize = 1;
-	inst->alg.cra_alignmask = alg->cra_alignmask | (__alignof__(u32) - 1);
+	inst->alg.cra_alignmask = alg->cra_alignmask;
 	inst->alg.cra_type = &crypto_blkcipher_type;
 
 	inst->alg.cra_blkcipher.ivsize = alg->cra_blocksize;
diff --git a/crypto/cts.c b/crypto/cts.c
index a1335d6c35fb..243f591dc409 100644
--- a/crypto/cts.c
+++ b/crypto/cts.c
@@ -374,9 +374,6 @@ static int crypto_cts_create(struct crypto_template *tmpl, struct rtattr **tb)
 	inst->alg.base.cra_blocksize = alg->base.cra_blocksize;
 	inst->alg.base.cra_alignmask = alg->base.cra_alignmask;
 
-	/* We access the data as u32s when xoring. */
-	inst->alg.base.cra_alignmask |= __alignof__(u32) - 1;
-
 	inst->alg.ivsize = alg->base.cra_blocksize;
 	inst->alg.chunksize = crypto_skcipher_alg_chunksize(alg);
 	inst->alg.min_keysize = crypto_skcipher_alg_min_keysize(alg);
diff --git a/crypto/pcbc.c b/crypto/pcbc.c
index 11d248673ad4..29dd2b4a3b85 100644
--- a/crypto/pcbc.c
+++ b/crypto/pcbc.c
@@ -260,9 +260,6 @@ static int crypto_pcbc_create(struct crypto_template *tmpl, struct rtattr **tb)
 	inst->alg.base.cra_blocksize = alg->cra_blocksize;
 	inst->alg.base.cra_alignmask = alg->cra_alignmask;
 
-	/* We access the data as u32s when xoring. */
-	inst->alg.base.cra_alignmask |= __alignof__(u32) - 1;
-
 	inst->alg.ivsize = alg->cra_blocksize;
 	inst->alg.min_keysize = alg->cra_cipher.cia_min_keysize;
 	inst->alg.max_keysize = alg->cra_cipher.cia_max_keysize;
diff --git a/crypto/seqiv.c b/crypto/seqiv.c
index c7049231861f..570b7d1aa0ca 100644
--- a/crypto/seqiv.c
+++ b/crypto/seqiv.c
@@ -153,8 +153,6 @@ static int seqiv_aead_create(struct crypto_template *tmpl, struct rtattr **tb)
 	if (IS_ERR(inst))
 		return PTR_ERR(inst);
 
-	inst->alg.base.cra_alignmask |= __alignof__(u32) - 1;
-
 	spawn = aead_instance_ctx(inst);
 	alg = crypto_spawn_aead_alg(spawn);
 
-- 
2.7.4
