From: Ard Biesheuvel <ard.biesheuvel@linaro.org>
Subject: [PATCH v3] crypto: algapi - make crypto_xor() and crypto_inc() alignment agnostic
Date: Sun,  5 Feb 2017 10:06:12 +0000
Message-ID: <1486289172-18604-1-git-send-email-ard.biesheuvel@linaro.org>
Cc: herbert@gondor.apana.org.au, Jason@zx2c4.com,
        Ard Biesheuvel <ard.biesheuvel@linaro.org>
To: linux-crypto@vger.kernel.org, ebiggers3@gmail.com
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-wr0-f175.google.com ([209.85.128.175]:33754 "EHLO
        mail-wr0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751774AbdBEKGn (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Sun, 5 Feb 2017 05:06:43 -0500
Received: by mail-wr0-f175.google.com with SMTP id i10so8975911wrb.0
        for <linux-crypto@vger.kernel.org>; Sun, 05 Feb 2017 02:06:42 -0800 (PST)
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
involving misalign are simply eliminated by the compiler when
HAVE_EFFICIENT_UNALIGNED_ACCESS is defined.

Signed-off-by: Ard Biesheuvel <ard.biesheuvel@linaro.org>
---
v3: fix thinko in processing of unaligned leading chunk
    inline common case where the input size is a constant multiple of the word
    size on architectures with h/w handling of unaligned accesses

 crypto/algapi.c         | 68 ++++++++++++++------
 crypto/cbc.c            |  3 -
 crypto/cmac.c           |  3 +-
 crypto/ctr.c            |  2 +-
 crypto/cts.c            |  3 -
 crypto/pcbc.c           |  3 -
 crypto/seqiv.c          |  2 -
 include/crypto/algapi.h | 20 +++++-
 8 files changed, 70 insertions(+), 34 deletions(-)

diff --git a/crypto/algapi.c b/crypto/algapi.c
index 1fad2a6b3bbb..6b52e8f0b95f 100644
--- a/crypto/algapi.c
+++ b/crypto/algapi.c
@@ -962,34 +962,66 @@ void crypto_inc(u8 *a, unsigned int size)
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
+void __crypto_xor(u8 *dst, const u8 *src, unsigned int len)
 {
-	for (; size; size--)
-		*a++ ^= *b++;
-}
+	int relalign = 0;
+
+	if (!IS_ENABLED(CONFIG_HAVE_EFFICIENT_UNALIGNED_ACCESS)) {
+		int size = sizeof(unsigned long);
+		int d = ((unsigned long)dst ^ (unsigned long)src) & (size - 1);
+
+		relalign = d ? 1 << __ffs(d) : size;
+
+		/*
+		 * If we care about alignment, process as many bytes as
+		 * needed to advance dst and src to values whose alignments
+		 * equal their relative alignment. This will allow us to
+		 * process the remainder of the input using optimal strides.
+		 */
+		while (((unsigned long)dst & (relalign - 1)) && len > 0) {
+			*dst++ ^= *src++;
+			len--;
+		}
+	}
 
-void crypto_xor(u8 *dst, const u8 *src, unsigned int size)
-{
-	u32 *a = (u32 *)dst;
-	u32 *b = (u32 *)src;
+	while (IS_ENABLED(CONFIG_64BIT) && len >= 8 && !(relalign & 7)) {
+		*(u64 *)dst ^= *(u64 *)src;
+		dst += 8;
+		src += 8;
+		len -= 8;
+	}
 
-	for (; size >= 4; size -= 4)
-		*a++ ^= *b++;
+	while (len >= 4 && !(relalign & 3)) {
+		*(u32 *)dst ^= *(u32 *)src;
+		dst += 4;
+		src += 4;
+		len -= 4;
+	}
+
+	while (len >= 2 && !(relalign & 1)) {
+		*(u16 *)dst ^= *(u16 *)src;
+		dst += 2;
+		src += 2;
+		len -= 2;
+	}
 
-	crypto_xor_byte((u8 *)a, (u8 *)b, size);
+	while (len--)
+		*dst++ ^= *src++;
 }
-EXPORT_SYMBOL_GPL(crypto_xor);
+EXPORT_SYMBOL_GPL(__crypto_xor);
 
 unsigned int crypto_alg_extsize(struct crypto_alg *alg)
 {
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
 
diff --git a/include/crypto/algapi.h b/include/crypto/algapi.h
index 404e9558e879..ebe4ded0c55d 100644
--- a/include/crypto/algapi.h
+++ b/include/crypto/algapi.h
@@ -191,9 +191,25 @@ static inline unsigned int crypto_queue_len(struct crypto_queue *queue)
 	return queue->qlen;
 }
 
-/* These functions require the input/output to be aligned as u32. */
 void crypto_inc(u8 *a, unsigned int size);
-void crypto_xor(u8 *dst, const u8 *src, unsigned int size);
+void __crypto_xor(u8 *dst, const u8 *src, unsigned int size);
+
+static inline void crypto_xor(u8 *dst, const u8 *src, unsigned int size)
+{
+	if (IS_ENABLED(CONFIG_HAVE_EFFICIENT_UNALIGNED_ACCESS) &&
+	    __builtin_constant_p(size) &&
+	    (size % sizeof(unsigned long)) == 0) {
+		unsigned long *d = (unsigned long *)dst;
+		unsigned long *s = (unsigned long *)src;
+
+		while (size > 0) {
+			*d++ ^= *s++;
+			size -= sizeof(unsigned long);
+		}
+	} else {
+		__crypto_xor(dst, src, size);
+	}
+}
 
 int blkcipher_walk_done(struct blkcipher_desc *desc,
 			struct blkcipher_walk *walk, int err);
-- 
2.7.4
