Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F137627BF99;
	Sun, 26 Oct 2025 05:53:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761457987; cv=none; b=ijt9TwFvqZcWEboemE5m2DNL1pSkCwnihMyB+qMa0O/5Q1zejCQHMrx61t5t2wEWiNt/qyMp67Khx9n53n/0vYInwMLPGX/DMoCC4axh3VPEVcGDorU8JHIPEPPVyePb3IWUCKejSqVSnHGNgX550dQRcKhV+q4E7fRotKOlANU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761457987; c=relaxed/simple;
	bh=9zIsMK25uFIFNUHHbNGygE2cNkGTDolXEFgcGk4aVRY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=uwFeFLkH6p/hT5G9Apo3JbCJ9djKzKpLr5pzyrGJvUeqrjqZS75O+U8u1QhUoCa2kSFxxb5Dx7VGzzUXV+kcofb7qqHBy8qkhZHgh77oES/TseJfdW3SM4uyz1sLRR48g2ny4LOQZietBN/LPoGTmQDAOC9ir/YWhL4hQygbAiU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=WDYfrzph; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="WDYfrzph"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8240BC116B1;
	Sun, 26 Oct 2025 05:53:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1761457986;
	bh=9zIsMK25uFIFNUHHbNGygE2cNkGTDolXEFgcGk4aVRY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=WDYfrzphOQ3g0yyOcjMGD4F33TFbRHE0Zl4C69qpePf9wpkyZmEPqTEZuzbheDXBz
	 Jvy6bwMOdxaPAAA4U1jgCh1ZX5iu4EfXhezJR6rTEtM9eKoXOoFNJEHeKOJ7hwZO9+
	 De8piST2FzwwIDo78tiVMiIEO4+/Txn5b39Hdt4I20B5JbbxgDBt2GsuD7eQQJC5/Z
	 BOA2JIAMY9gxw5kQdqOrIzTXLwfElT1SV3UU4vEEnBD4OIT4oP29iOYj3v6+KXn1h4
	 dad2FBacZM3UKvSe+dkF2IL/hKTEpdKw/8Fs7OxSH67WwjfYA1+eDPtO2w6DHKsDng
	 OBobBS/X6tmNA==
From: Eric Biggers <ebiggers@kernel.org>
To: linux-crypto@vger.kernel.org
Cc: David Howells <dhowells@redhat.com>,
	Ard Biesheuvel <ardb@kernel.org>,
	"Jason A . Donenfeld" <Jason@zx2c4.com>,
	Eric Biggers <ebiggers@kernel.org>,
	Holger Dengler <dengler@linux.ibm.com>,
	Harald Freudenberger <freude@linux.ibm.com>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	linux-arm-kernel@lists.infradead.org,
	linux-s390@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH v2 08/15] crypto: arm64/sha3 - Update sha3_ce_transform() to prepare for library
Date: Sat, 25 Oct 2025 22:50:25 -0700
Message-ID: <20251026055032.1413733-9-ebiggers@kernel.org>
X-Mailer: git-send-email 2.51.1.dirty
In-Reply-To: <20251026055032.1413733-1-ebiggers@kernel.org>
References: <20251026055032.1413733-1-ebiggers@kernel.org>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

- Use size_t lengths, to match the library.

- Pass the block size instead of digest size, and add support for the
  block size that SHAKE128 uses.  This allows the code to be used with
  SHAKE128 and SHAKE256, which don't have the concept of a digest size.
  SHAKE256 has the same block size as SHA3-256, but SHAKE128 has a
  unique block size.  Thus, there are now 5 supported block sizes.

Don't bother changing the "glue" code arm64_sha3_update() too much, as
it gets deleted when the SHA-3 code is migrated into lib/crypto/ anyway.

Reviewed-by: Ard Biesheuvel <ardb@kernel.org>
Signed-off-by: Eric Biggers <ebiggers@kernel.org>
---
 arch/arm64/crypto/sha3-ce-core.S | 67 ++++++++++++++++----------------
 arch/arm64/crypto/sha3-ce-glue.c | 11 +++---
 2 files changed, 39 insertions(+), 39 deletions(-)

diff --git a/arch/arm64/crypto/sha3-ce-core.S b/arch/arm64/crypto/sha3-ce-core.S
index 9c77313f5a608..b62bd714839b1 100644
--- a/arch/arm64/crypto/sha3-ce-core.S
+++ b/arch/arm64/crypto/sha3-ce-core.S
@@ -35,11 +35,15 @@
 	.macro	xar, rd, rn, rm, imm6
 	.inst	0xce800000 | .L\rd | (.L\rn << 5) | ((\imm6) << 10) | (.L\rm << 16)
 	.endm
 
 	/*
-	 * int sha3_ce_transform(u64 *st, const u8 *data, int blocks, int dg_size)
+	 * size_t sha3_ce_transform(struct sha3_state *state, const u8 *data,
+	 *			    size_t nblocks, size_t block_size)
+	 *
+	 * block_size is assumed to be one of 72 (SHA3-512), 104 (SHA3-384), 136
+	 * (SHA3-256 and SHAKE256), 144 (SHA3-224), or 168 (SHAKE128).
 	 */
 	.text
 SYM_FUNC_START(sha3_ce_transform)
 	/* load state */
 	add	x8, x0, #32
@@ -49,62 +53,59 @@ SYM_FUNC_START(sha3_ce_transform)
 	ld1	{v12.1d-v15.1d}, [x8], #32
 	ld1	{v16.1d-v19.1d}, [x8], #32
 	ld1	{v20.1d-v23.1d}, [x8], #32
 	ld1	{v24.1d}, [x8]
 
-0:	sub	w2, w2, #1
+0:	sub	x2, x2, #1
 	mov	w8, #24
 	adr_l	x9, .Lsha3_rcon
 
 	/* load input */
 	ld1	{v25.8b-v28.8b}, [x1], #32
-	ld1	{v29.8b-v31.8b}, [x1], #24
+	ld1	{v29.8b}, [x1], #8
 	eor	v0.8b, v0.8b, v25.8b
 	eor	v1.8b, v1.8b, v26.8b
 	eor	v2.8b, v2.8b, v27.8b
 	eor	v3.8b, v3.8b, v28.8b
 	eor	v4.8b, v4.8b, v29.8b
-	eor	v5.8b, v5.8b, v30.8b
-	eor	v6.8b, v6.8b, v31.8b
-
-	tbnz	x3, #6, 2f		// SHA3-512
 
 	ld1	{v25.8b-v28.8b}, [x1], #32
-	ld1	{v29.8b-v30.8b}, [x1], #16
-	eor	 v7.8b,  v7.8b, v25.8b
-	eor	 v8.8b,  v8.8b, v26.8b
-	eor	 v9.8b,  v9.8b, v27.8b
-	eor	v10.8b, v10.8b, v28.8b
-	eor	v11.8b, v11.8b, v29.8b
-	eor	v12.8b, v12.8b, v30.8b
+	eor	v5.8b, v5.8b, v25.8b
+	eor	v6.8b, v6.8b, v26.8b
+	eor	v7.8b, v7.8b, v27.8b
+	eor	v8.8b, v8.8b, v28.8b
+	cmp	x3, #72
+	b.eq	3f	/* SHA3-512 (block_size=72)? */
 
-	tbnz	x3, #4, 1f		// SHA3-384 or SHA3-224
+	ld1	{v25.8b-v28.8b}, [x1], #32
+	eor	v9.8b, v9.8b, v25.8b
+	eor	v10.8b, v10.8b, v26.8b
+	eor	v11.8b, v11.8b, v27.8b
+	eor	v12.8b, v12.8b, v28.8b
+	cmp	x3, #104
+	b.eq	3f	/* SHA3-384 (block_size=104)? */
 
-	// SHA3-256
 	ld1	{v25.8b-v28.8b}, [x1], #32
 	eor	v13.8b, v13.8b, v25.8b
 	eor	v14.8b, v14.8b, v26.8b
 	eor	v15.8b, v15.8b, v27.8b
 	eor	v16.8b, v16.8b, v28.8b
-	b	3f
-
-1:	tbz	x3, #2, 3f		// bit 2 cleared? SHA-384
+	cmp	x3, #144
+	b.lt	3f	/* SHA3-256 or SHAKE256 (block_size=136)? */
+	b.eq	2f	/* SHA3-224 (block_size=144)? */
 
-	// SHA3-224
+	/* SHAKE128 (block_size=168) */
 	ld1	{v25.8b-v28.8b}, [x1], #32
-	ld1	{v29.8b}, [x1], #8
-	eor	v13.8b, v13.8b, v25.8b
-	eor	v14.8b, v14.8b, v26.8b
-	eor	v15.8b, v15.8b, v27.8b
-	eor	v16.8b, v16.8b, v28.8b
-	eor	v17.8b, v17.8b, v29.8b
+	eor	v17.8b, v17.8b, v25.8b
+	eor	v18.8b, v18.8b, v26.8b
+	eor	v19.8b, v19.8b, v27.8b
+	eor	v20.8b, v20.8b, v28.8b
 	b	3f
-
-	// SHA3-512
-2:	ld1	{v25.8b-v26.8b}, [x1], #16
-	eor	 v7.8b,  v7.8b, v25.8b
-	eor	 v8.8b,  v8.8b, v26.8b
+2:
+	/* SHA3-224 (block_size=144) */
+	ld1	{v25.8b}, [x1], #8
+	eor	v17.8b, v17.8b, v25.8b
 
 3:	sub	w8, w8, #1
 
 	eor3	v29.16b,  v4.16b,  v9.16b, v14.16b
 	eor3	v26.16b,  v1.16b,  v6.16b, v11.16b
@@ -183,21 +184,21 @@ SYM_FUNC_START(sha3_ce_transform)
 
 	eor	 v0.16b,  v0.16b, v31.16b
 
 	cbnz	w8, 3b
 	cond_yield 4f, x8, x9
-	cbnz	w2, 0b
+	cbnz	x2, 0b
 
 	/* save state */
 4:	st1	{ v0.1d- v3.1d}, [x0], #32
 	st1	{ v4.1d- v7.1d}, [x0], #32
 	st1	{ v8.1d-v11.1d}, [x0], #32
 	st1	{v12.1d-v15.1d}, [x0], #32
 	st1	{v16.1d-v19.1d}, [x0], #32
 	st1	{v20.1d-v23.1d}, [x0], #32
 	st1	{v24.1d}, [x0]
-	mov	w0, w2
+	mov	x0, x2
 	ret
 SYM_FUNC_END(sha3_ce_transform)
 
 	.section	".rodata", "a"
 	.align		8
diff --git a/arch/arm64/crypto/sha3-ce-glue.c b/arch/arm64/crypto/sha3-ce-glue.c
index f5c8302349337..250f4fb76b472 100644
--- a/arch/arm64/crypto/sha3-ce-glue.c
+++ b/arch/arm64/crypto/sha3-ce-glue.c
@@ -26,30 +26,29 @@ MODULE_LICENSE("GPL v2");
 MODULE_ALIAS_CRYPTO("sha3-224");
 MODULE_ALIAS_CRYPTO("sha3-256");
 MODULE_ALIAS_CRYPTO("sha3-384");
 MODULE_ALIAS_CRYPTO("sha3-512");
 
-asmlinkage int sha3_ce_transform(u64 *st, const u8 *data, int blocks,
-				 int md_len);
+asmlinkage size_t sha3_ce_transform(struct sha3_state *state, const u8 *data,
+				    size_t nblocks, size_t block_size);
 
 static int arm64_sha3_update(struct shash_desc *desc, const u8 *data,
 			     unsigned int len)
 {
 	struct sha3_state *sctx = shash_desc_ctx(desc);
 	struct crypto_shash *tfm = desc->tfm;
-	unsigned int bs, ds;
+	unsigned int bs;
 	int blocks;
 
-	ds = crypto_shash_digestsize(tfm);
 	bs = crypto_shash_blocksize(tfm);
 	blocks = len / bs;
 	len -= blocks * bs;
 	do {
 		int rem;
 
 		kernel_neon_begin();
-		rem = sha3_ce_transform(sctx->st, data, blocks, ds);
+		rem = sha3_ce_transform(sctx, data, blocks, bs);
 		kernel_neon_end();
 		data += (blocks - rem) * bs;
 		blocks = rem;
 	} while (blocks);
 	return len;
@@ -72,11 +71,11 @@ static int sha3_finup(struct shash_desc *desc, const u8 *src, unsigned int len,
 	block[len++] = 0x06;
 	memset(block + len, 0, bs - len);
 	block[bs - 1] |= 0x80;
 
 	kernel_neon_begin();
-	sha3_ce_transform(sctx->st, block, 1, ds);
+	sha3_ce_transform(sctx, block, 1, bs);
 	kernel_neon_end();
 	memzero_explicit(block , sizeof(block));
 
 	for (i = 0; i < ds / 8; i++)
 		put_unaligned_le64(sctx->st[i], digest++);
-- 
2.51.1.dirty

