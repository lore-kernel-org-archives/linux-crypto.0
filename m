From: Ard Biesheuvel <ard.biesheuvel@linaro.org>
Subject: [PATCH v2] crypto: algapi - make crypto_xor() and crypto_inc() alignment agnostic
Date: Thu,  2 Feb 2017 15:56:28 +0000
Message-ID: <1486050988-20407-1-git-send-email-ard.biesheuvel@linaro.org>
Cc: Ard Biesheuvel <ard.biesheuvel@linaro.org>
To: linux-crypto@vger.kernel.org, herbert@gondor.apana.org.au,
        ebiggers3@gmail.com
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-wm0-f50.google.com ([74.125.82.50]:36584 "EHLO
        mail-wm0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751618AbdBBP4f (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 2 Feb 2017 10:56:35 -0500
Received: by mail-wm0-f50.google.com with SMTP id c85so96611472wmi.1
        for <linux-crypto@vger.kernel.org>; Thu, 02 Feb 2017 07:56:35 -0800 (PST)
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

I have greatly simplified the code, but it should still emit an optimal
sequence of loads and stores depending on the misalignment.

 crypto/algapi.c | 65 +++++++++++++++-----
 crypto/cbc.c    |  3 -
 crypto/cmac.c   |  3 +-
 crypto/ctr.c    |  2 +-
 crypto/cts.c    |  3 -
 crypto/pcbc.c   |  3 -
 crypto/seqiv.c  |  2 -
 7 files changed, 50 insertions(+), 31 deletions(-)

diff --git a/crypto/algapi.c b/crypto/algapi.c
index df939b54b09f..e05ed1c5f5d1 100644
--- a/crypto/algapi.c
+++ b/crypto/algapi.c
@@ -961,32 +961,63 @@ void crypto_inc(u8 *a, unsigned int size)
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
+	int delta = ((unsigned long)dst ^ (unsigned long)src) & (size - 1);
+	int misalign = 0;
+
+	if (!IS_ENABLED(CONFIG_HAVE_EFFICIENT_UNALIGNED_ACCESS) && delta) {
+		misalign = 1 << __ffs(delta);
+
+		/*
+		 * If we care about alignment, process as many bytes as
+		 * needed to advance dst and src to values whose alignments
+		 * equal their relative misalignment. This will allow us to
+		 * process the remainder of the input using optimal strides.
+		 */
+		while (((unsigned long)dst & (misalign - 1)) && len > 0) {
+			*dst++ ^= *src++;
+			len--;
+		}
+	}
 
-void crypto_xor(u8 *dst, const u8 *src, unsigned int size)
-{
-	u32 *a = (u32 *)dst;
-	u32 *b = (u32 *)src;
+	while (len >= size && !misalign) {
+		*(unsigned long *)dst ^= *(unsigned long *)src;
+		dst += size;
+		src += size;
+		len -= size;
+	}
 
-	for (; size >= 4; size -= 4)
-		*a++ ^= *b++;
+	while (IS_ENABLED(CONFIG_64BIT) && len >= 4 && !(misalign & 3)) {
+		*(u32 *)dst ^= *(u32 *)src;
+		dst += 4;
+		src += 4;
+		len -= 4;
+	}
+
+	while (len >= 2 && !(misalign & 1)) {
+		*(u16 *)dst ^= *(u16 *)src;
+		dst += 2;
+		src += 2;
+		len -= 2;
+	}
 
-	crypto_xor_byte((u8 *)a, (u8 *)b, size);
+	while (len--)
+		*dst++ ^= *src++;
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
