From: Ard Biesheuvel <ard.biesheuvel@linaro.org>
Subject: [PATCH 2/2] crypto/algapi - make crypto_xor() take separate dst and src arguments
Date: Mon, 10 Jul 2017 14:45:48 +0100
Message-ID: <20170710134548.20234-3-ard.biesheuvel@linaro.org>
References: <20170710134548.20234-1-ard.biesheuvel@linaro.org>
Cc: davem@davemloft.net, dm-devel@redhat.com,
        johannes@sipsolutions.net, linux-wireless@vger.kernel.org,
        agk@redhat.com, snitzer@redhat.com,
        Ard Biesheuvel <ard.biesheuvel@linaro.org>
To: linux-crypto@vger.kernel.org, herbert@gondor.apana.org.au,
        ebiggers@google.com
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-wr0-f174.google.com ([209.85.128.174]:36564 "EHLO
        mail-wr0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932202AbdGJNq1 (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 10 Jul 2017 09:46:27 -0400
Received: by mail-wr0-f174.google.com with SMTP id c11so139624131wrc.3
        for <linux-crypto@vger.kernel.org>; Mon, 10 Jul 2017 06:46:21 -0700 (PDT)
In-Reply-To: <20170710134548.20234-1-ard.biesheuvel@linaro.org>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

There are quite a number of occurrences in the kernel of the pattern

    if (dst != src)
            memcpy(dst, src, walk.total % AES_BLOCK_SIZE);
    crypto_xor(dst, final, walk.total % AES_BLOCK_SIZE);

or

    crypto_xor(keystream, src, nbytes);
    memcpy(dst, keystream, nbytes);

where crypto_xor() is preceded or followed by a memcpy() invocation
that is only there because crypto_xor() uses its output parameter as
one of the inputs. To avoid having to add new instances of this pattern
in the arm64 code, which will be refactored to implement non-SIMD
fallbacks, split the output and first input operands in crypto_xor().

While we're at it, fold in the memcpy()s that can now be made redundant.

Signed-off-by: Ard Biesheuvel <ard.biesheuvel@linaro.org>
---
 arch/arm/crypto/aes-ce-glue.c       |  4 +---
 arch/arm/crypto/aes-neonbs-glue.c   |  9 +++------
 arch/arm64/crypto/aes-glue.c        |  8 ++++----
 arch/arm64/crypto/aes-neonbs-glue.c |  9 +++------
 arch/sparc/crypto/aes_glue.c        |  3 +--
 arch/x86/crypto/aesni-intel_glue.c  |  4 ++--
 arch/x86/crypto/blowfish_glue.c     |  3 +--
 arch/x86/crypto/cast5_avx_glue.c    |  3 +--
 arch/x86/crypto/des3_ede_glue.c     |  3 +--
 crypto/ccm.c                        |  2 +-
 crypto/chacha20_generic.c           |  4 ++--
 crypto/cmac.c                       |  8 ++++----
 crypto/ctr.c                        |  7 +++----
 crypto/cts.c                        |  4 ++--
 crypto/gcm.c                        |  4 ++--
 crypto/ghash-generic.c              |  2 +-
 crypto/keywrap.c                    |  4 ++--
 crypto/pcbc.c                       | 20 ++++++++------------
 crypto/salsa20_generic.c            |  4 ++--
 crypto/seqiv.c                      |  2 +-
 crypto/xcbc.c                       |  8 ++++----
 drivers/crypto/vmx/aes_ctr.c        |  3 +--
 drivers/md/dm-crypt.c               | 19 +++++++++----------
 include/crypto/algapi.h             | 10 ++++++----
 include/crypto/cbc.h                | 10 +++++-----
 net/mac80211/fils_aead.c            |  6 +++---
 26 files changed, 73 insertions(+), 90 deletions(-)

diff --git a/arch/arm/crypto/aes-ce-glue.c b/arch/arm/crypto/aes-ce-glue.c
index 0f966a8ca1ce..10374324ab25 100644
--- a/arch/arm/crypto/aes-ce-glue.c
+++ b/arch/arm/crypto/aes-ce-glue.c
@@ -285,9 +285,7 @@ static int ctr_encrypt(struct skcipher_request *req)
 
 		ce_aes_ctr_encrypt(tail, NULL, (u8 *)ctx->key_enc,
 				   num_rounds(ctx), blocks, walk.iv);
-		if (tdst != tsrc)
-			memcpy(tdst, tsrc, nbytes);
-		crypto_xor(tdst, tail, nbytes);
+		crypto_xor(tdst, tsrc, tail, nbytes);
 		err = skcipher_walk_done(&walk, 0);
 	}
 	kernel_neon_end();
diff --git a/arch/arm/crypto/aes-neonbs-glue.c b/arch/arm/crypto/aes-neonbs-glue.c
index c76377961444..86f3c2c0d179 100644
--- a/arch/arm/crypto/aes-neonbs-glue.c
+++ b/arch/arm/crypto/aes-neonbs-glue.c
@@ -218,12 +218,9 @@ static int ctr_encrypt(struct skcipher_request *req)
 				  ctx->rk, ctx->rounds, blocks, walk.iv, final);
 
 		if (final) {
-			u8 *dst = walk.dst.virt.addr + blocks * AES_BLOCK_SIZE;
-			u8 *src = walk.src.virt.addr + blocks * AES_BLOCK_SIZE;
-
-			if (dst != src)
-				memcpy(dst, src, walk.total % AES_BLOCK_SIZE);
-			crypto_xor(dst, final, walk.total % AES_BLOCK_SIZE);
+			crypto_xor(walk.dst.virt.addr + blocks * AES_BLOCK_SIZE,
+				   walk.src.virt.addr + blocks * AES_BLOCK_SIZE,
+				   final, walk.total % AES_BLOCK_SIZE);
 
 			err = skcipher_walk_done(&walk, 0);
 			break;
diff --git a/arch/arm64/crypto/aes-glue.c b/arch/arm64/crypto/aes-glue.c
index bcf596b0197e..eb93eccda503 100644
--- a/arch/arm64/crypto/aes-glue.c
+++ b/arch/arm64/crypto/aes-glue.c
@@ -241,9 +241,7 @@ static int ctr_encrypt(struct skcipher_request *req)
 
 		aes_ctr_encrypt(tail, NULL, (u8 *)ctx->key_enc, rounds,
 				blocks, walk.iv, first);
-		if (tdst != tsrc)
-			memcpy(tdst, tsrc, nbytes);
-		crypto_xor(tdst, tail, nbytes);
+		crypto_xor(tdst, tsrc, tail, nbytes);
 		err = skcipher_walk_done(&walk, 0);
 	}
 	kernel_neon_end();
@@ -493,7 +491,9 @@ static int mac_update(struct shash_desc *desc, const u8 *p, unsigned int len)
 		l = min(len, AES_BLOCK_SIZE - ctx->len);
 
 		if (l <= AES_BLOCK_SIZE) {
-			crypto_xor(ctx->dg + ctx->len, p, l);
+			u8 *dg = ctx->dg + ctx->len;
+
+			crypto_xor(dg, dg, p, l);
 			ctx->len += l;
 			len -= l;
 			p += l;
diff --git a/arch/arm64/crypto/aes-neonbs-glue.c b/arch/arm64/crypto/aes-neonbs-glue.c
index db2501d93550..9906daa543bc 100644
--- a/arch/arm64/crypto/aes-neonbs-glue.c
+++ b/arch/arm64/crypto/aes-neonbs-glue.c
@@ -221,12 +221,9 @@ static int ctr_encrypt(struct skcipher_request *req)
 				  ctx->rk, ctx->rounds, blocks, walk.iv, final);
 
 		if (final) {
-			u8 *dst = walk.dst.virt.addr + blocks * AES_BLOCK_SIZE;
-			u8 *src = walk.src.virt.addr + blocks * AES_BLOCK_SIZE;
-
-			if (dst != src)
-				memcpy(dst, src, walk.total % AES_BLOCK_SIZE);
-			crypto_xor(dst, final, walk.total % AES_BLOCK_SIZE);
+			crypto_xor(walk.dst.virt.addr + blocks * AES_BLOCK_SIZE,
+				   walk.src.virt.addr + blocks * AES_BLOCK_SIZE,
+				   final, walk.total % AES_BLOCK_SIZE);
 
 			err = skcipher_walk_done(&walk, 0);
 			break;
diff --git a/arch/sparc/crypto/aes_glue.c b/arch/sparc/crypto/aes_glue.c
index c90930de76ba..e5f87bd3f7df 100644
--- a/arch/sparc/crypto/aes_glue.c
+++ b/arch/sparc/crypto/aes_glue.c
@@ -344,8 +344,7 @@ static void ctr_crypt_final(struct crypto_sparc64_aes_ctx *ctx,
 
 	ctx->ops->ecb_encrypt(&ctx->key[0], (const u64 *)ctrblk,
 			      keystream, AES_BLOCK_SIZE);
-	crypto_xor((u8 *) keystream, src, nbytes);
-	memcpy(dst, keystream, nbytes);
+	crypto_xor(dst, (u8 *) keystream, src, nbytes);
 	crypto_inc(ctrblk, AES_BLOCK_SIZE);
 }
 
diff --git a/arch/x86/crypto/aesni-intel_glue.c b/arch/x86/crypto/aesni-intel_glue.c
index 4a55cdcdc008..dda9279133ed 100644
--- a/arch/x86/crypto/aesni-intel_glue.c
+++ b/arch/x86/crypto/aesni-intel_glue.c
@@ -475,8 +475,8 @@ static void ctr_crypt_final(struct crypto_aes_ctx *ctx,
 	unsigned int nbytes = walk->nbytes;
 
 	aesni_enc(ctx, keystream, ctrblk);
-	crypto_xor(keystream, src, nbytes);
-	memcpy(dst, keystream, nbytes);
+	crypto_xor(dst, keystream, src, nbytes);
+
 	crypto_inc(ctrblk, AES_BLOCK_SIZE);
 }
 
diff --git a/arch/x86/crypto/blowfish_glue.c b/arch/x86/crypto/blowfish_glue.c
index 17c05531dfd1..26426ef70fb9 100644
--- a/arch/x86/crypto/blowfish_glue.c
+++ b/arch/x86/crypto/blowfish_glue.c
@@ -271,8 +271,7 @@ static void ctr_crypt_final(struct bf_ctx *ctx, struct blkcipher_walk *walk)
 	unsigned int nbytes = walk->nbytes;
 
 	blowfish_enc_blk(ctx, keystream, ctrblk);
-	crypto_xor(keystream, src, nbytes);
-	memcpy(dst, keystream, nbytes);
+	crypto_xor(dst, keystream, src, nbytes);
 
 	crypto_inc(ctrblk, BF_BLOCK_SIZE);
 }
diff --git a/arch/x86/crypto/cast5_avx_glue.c b/arch/x86/crypto/cast5_avx_glue.c
index 8648158f3916..68fe7ce7234b 100644
--- a/arch/x86/crypto/cast5_avx_glue.c
+++ b/arch/x86/crypto/cast5_avx_glue.c
@@ -256,8 +256,7 @@ static void ctr_crypt_final(struct blkcipher_desc *desc,
 	unsigned int nbytes = walk->nbytes;
 
 	__cast5_encrypt(ctx, keystream, ctrblk);
-	crypto_xor(keystream, src, nbytes);
-	memcpy(dst, keystream, nbytes);
+	crypto_xor(dst, keystream, src, nbytes);
 
 	crypto_inc(ctrblk, CAST5_BLOCK_SIZE);
 }
diff --git a/arch/x86/crypto/des3_ede_glue.c b/arch/x86/crypto/des3_ede_glue.c
index d6fc59aaaadf..e31ecab2467f 100644
--- a/arch/x86/crypto/des3_ede_glue.c
+++ b/arch/x86/crypto/des3_ede_glue.c
@@ -277,8 +277,7 @@ static void ctr_crypt_final(struct des3_ede_x86_ctx *ctx,
 	unsigned int nbytes = walk->nbytes;
 
 	des3_ede_enc_blk(ctx, keystream, ctrblk);
-	crypto_xor(keystream, src, nbytes);
-	memcpy(dst, keystream, nbytes);
+	crypto_xor(dst, keystream, src, nbytes);
 
 	crypto_inc(ctrblk, DES3_EDE_BLOCK_SIZE);
 }
diff --git a/crypto/ccm.c b/crypto/ccm.c
index 1ce37ae0ce56..356d6ab9b386 100644
--- a/crypto/ccm.c
+++ b/crypto/ccm.c
@@ -888,7 +888,7 @@ static int crypto_cbcmac_digest_update(struct shash_desc *pdesc, const u8 *p,
 	while (len > 0) {
 		unsigned int l = min(len, bs - ctx->len);
 
-		crypto_xor(dg + ctx->len, p, l);
+		crypto_xor(dg + ctx->len, dg + ctx->len, p, l);
 		ctx->len +=l;
 		len -= l;
 		p += l;
diff --git a/crypto/chacha20_generic.c b/crypto/chacha20_generic.c
index 8b3c04d625c3..1dbbc14f61e1 100644
--- a/crypto/chacha20_generic.c
+++ b/crypto/chacha20_generic.c
@@ -29,13 +29,13 @@ static void chacha20_docrypt(u32 *state, u8 *dst, const u8 *src,
 
 	while (bytes >= CHACHA20_BLOCK_SIZE) {
 		chacha20_block(state, stream);
-		crypto_xor(dst, stream, CHACHA20_BLOCK_SIZE);
+		crypto_xor(dst, dst, stream, CHACHA20_BLOCK_SIZE);
 		bytes -= CHACHA20_BLOCK_SIZE;
 		dst += CHACHA20_BLOCK_SIZE;
 	}
 	if (bytes) {
 		chacha20_block(state, stream);
-		crypto_xor(dst, stream, bytes);
+		crypto_xor(dst, dst, stream, bytes);
 	}
 }
 
diff --git a/crypto/cmac.c b/crypto/cmac.c
index 16301f52858c..088ac93461af 100644
--- a/crypto/cmac.c
+++ b/crypto/cmac.c
@@ -143,7 +143,7 @@ static int crypto_cmac_digest_update(struct shash_desc *pdesc, const u8 *p,
 	len -= bs - ctx->len;
 	p += bs - ctx->len;
 
-	crypto_xor(prev, odds, bs);
+	crypto_xor(prev, prev, odds, bs);
 	crypto_cipher_encrypt_one(tfm, prev, prev);
 
 	/* clearing the length */
@@ -151,7 +151,7 @@ static int crypto_cmac_digest_update(struct shash_desc *pdesc, const u8 *p,
 
 	/* encrypting the rest of data */
 	while (len > bs) {
-		crypto_xor(prev, p, bs);
+		crypto_xor(prev, prev, p, bs);
 		crypto_cipher_encrypt_one(tfm, prev, prev);
 		p += bs;
 		len -= bs;
@@ -194,8 +194,8 @@ static int crypto_cmac_digest_final(struct shash_desc *pdesc, u8 *out)
 		offset += bs;
 	}
 
-	crypto_xor(prev, odds, bs);
-	crypto_xor(prev, consts + offset, bs);
+	crypto_xor(prev, prev, odds, bs);
+	crypto_xor(prev, prev, consts + offset, bs);
 
 	crypto_cipher_encrypt_one(tfm, out, prev);
 
diff --git a/crypto/ctr.c b/crypto/ctr.c
index 477d9226ccaa..48ce70ecda5e 100644
--- a/crypto/ctr.c
+++ b/crypto/ctr.c
@@ -65,8 +65,7 @@ static void crypto_ctr_crypt_final(struct blkcipher_walk *walk,
 	unsigned int nbytes = walk->nbytes;
 
 	crypto_cipher_encrypt_one(tfm, keystream, ctrblk);
-	crypto_xor(keystream, src, nbytes);
-	memcpy(dst, keystream, nbytes);
+	crypto_xor(dst, keystream, src, nbytes);
 
 	crypto_inc(ctrblk, bsize);
 }
@@ -85,7 +84,7 @@ static int crypto_ctr_crypt_segment(struct blkcipher_walk *walk,
 	do {
 		/* create keystream */
 		fn(crypto_cipher_tfm(tfm), dst, ctrblk);
-		crypto_xor(dst, src, bsize);
+		crypto_xor(dst, dst, src, bsize);
 
 		/* increment counter in counterblock */
 		crypto_inc(ctrblk, bsize);
@@ -113,7 +112,7 @@ static int crypto_ctr_crypt_inplace(struct blkcipher_walk *walk,
 	do {
 		/* create keystream */
 		fn(crypto_cipher_tfm(tfm), keystream, ctrblk);
-		crypto_xor(src, keystream, bsize);
+		crypto_xor(src, src, keystream, bsize);
 
 		/* increment counter in counterblock */
 		crypto_inc(ctrblk, bsize);
diff --git a/crypto/cts.c b/crypto/cts.c
index 243f591dc409..88db6be89799 100644
--- a/crypto/cts.c
+++ b/crypto/cts.c
@@ -198,13 +198,13 @@ static int cts_cbc_decrypt(struct skcipher_request *req)
 	/* 1. Decrypt Cn-1 (s) to create Dn */
 	scatterwalk_map_and_copy(d + bsize, sg, 0, bsize, 0);
 	space = crypto_cts_reqctx_space(req);
-	crypto_xor(d + bsize, space, bsize);
+	crypto_xor(d + bsize, d + bsize, space, bsize);
 	/* 2. Pad Cn with zeros at the end to create C of length BB */
 	memset(d, 0, bsize);
 	scatterwalk_map_and_copy(d, req->src, offset, lastn, 0);
 	/* 3. Exclusive-or Dn with C to create Xn */
 	/* 4. Select the first Ln bytes of Xn to create Pn */
-	crypto_xor(d + bsize, d, lastn);
+	crypto_xor(d + bsize, d + bsize, d, lastn);
 
 	/* 5. Append the tail (BB - Ln) bytes of Xn to Cn to create En */
 	memcpy(d + lastn, d + bsize + lastn, bsize - lastn);
diff --git a/crypto/gcm.c b/crypto/gcm.c
index b7ad808be3d4..d9abf2880d92 100644
--- a/crypto/gcm.c
+++ b/crypto/gcm.c
@@ -457,7 +457,7 @@ static int gcm_enc_copy_hash(struct aead_request *req, u32 flags)
 	struct crypto_aead *aead = crypto_aead_reqtfm(req);
 	u8 *auth_tag = pctx->auth_tag;
 
-	crypto_xor(auth_tag, pctx->iauth_tag, 16);
+	crypto_xor(auth_tag, auth_tag, pctx->iauth_tag, 16);
 	scatterwalk_map_and_copy(auth_tag, req->dst,
 				 req->assoclen + req->cryptlen,
 				 crypto_aead_authsize(aead), 1);
@@ -514,7 +514,7 @@ static int crypto_gcm_verify(struct aead_request *req)
 	unsigned int authsize = crypto_aead_authsize(aead);
 	unsigned int cryptlen = req->cryptlen - authsize;
 
-	crypto_xor(auth_tag, iauth_tag, 16);
+	crypto_xor(auth_tag, auth_tag, iauth_tag, 16);
 	scatterwalk_map_and_copy(iauth_tag, req->src,
 				 req->assoclen + cryptlen, authsize, 0);
 	return crypto_memneq(iauth_tag, auth_tag, authsize) ? -EBADMSG : 0;
diff --git a/crypto/ghash-generic.c b/crypto/ghash-generic.c
index 12ad3e3a84e3..9998c98b300c 100644
--- a/crypto/ghash-generic.c
+++ b/crypto/ghash-generic.c
@@ -74,7 +74,7 @@ static int ghash_update(struct shash_desc *desc,
 	}
 
 	while (srclen >= GHASH_BLOCK_SIZE) {
-		crypto_xor(dst, src, GHASH_BLOCK_SIZE);
+		crypto_xor(dst, dst, src, GHASH_BLOCK_SIZE);
 		gf128mul_4k_lle((be128 *)dst, ctx->gf128);
 		src += GHASH_BLOCK_SIZE;
 		srclen -= GHASH_BLOCK_SIZE;
diff --git a/crypto/keywrap.c b/crypto/keywrap.c
index 72014f963ba7..a5d0615d316b 100644
--- a/crypto/keywrap.c
+++ b/crypto/keywrap.c
@@ -187,7 +187,7 @@ static int crypto_kw_decrypt(struct blkcipher_desc *desc,
 			/* perform KW operation: get counter as byte string */
 			crypto_kw_cpu_to_be64(t, tbe);
 			/* perform KW operation: modify IV with counter */
-			crypto_xor(block->A, tbe, SEMIBSIZE);
+			crypto_xor(block->A, block->A, tbe, SEMIBSIZE);
 			t--;
 			/* perform KW operation: decrypt block */
 			crypto_cipher_decrypt_one(child, (u8*)block,
@@ -279,7 +279,7 @@ static int crypto_kw_encrypt(struct blkcipher_desc *desc,
 			/* perform KW operation: get counter as byte string */
 			crypto_kw_cpu_to_be64(t, tbe);
 			/* perform KW operation: modify IV with counter */
-			crypto_xor(block->A, tbe, SEMIBSIZE);
+			crypto_xor(block->A, block->A, tbe, SEMIBSIZE);
 			t++;
 
 			/* Copy block->R into place */
diff --git a/crypto/pcbc.c b/crypto/pcbc.c
index 29dd2b4a3b85..bd4a08e619d8 100644
--- a/crypto/pcbc.c
+++ b/crypto/pcbc.c
@@ -53,10 +53,9 @@ static int crypto_pcbc_encrypt_segment(struct skcipher_request *req,
 	u8 *iv = walk->iv;
 
 	do {
-		crypto_xor(iv, src, bsize);
+		crypto_xor(iv, iv, src, bsize);
 		crypto_cipher_encrypt_one(tfm, dst, iv);
-		memcpy(iv, dst, bsize);
-		crypto_xor(iv, src, bsize);
+		crypto_xor(iv, dst, src, bsize);
 
 		src += bsize;
 		dst += bsize;
@@ -77,10 +76,9 @@ static int crypto_pcbc_encrypt_inplace(struct skcipher_request *req,
 
 	do {
 		memcpy(tmpbuf, src, bsize);
-		crypto_xor(iv, src, bsize);
+		crypto_xor(iv, iv, src, bsize);
 		crypto_cipher_encrypt_one(tfm, src, iv);
-		memcpy(iv, tmpbuf, bsize);
-		crypto_xor(iv, src, bsize);
+		crypto_xor(iv, tmpbuf, src, bsize);
 
 		src += bsize;
 	} while ((nbytes -= bsize) >= bsize);
@@ -126,9 +124,8 @@ static int crypto_pcbc_decrypt_segment(struct skcipher_request *req,
 
 	do {
 		crypto_cipher_decrypt_one(tfm, dst, src);
-		crypto_xor(dst, iv, bsize);
-		memcpy(iv, src, bsize);
-		crypto_xor(iv, dst, bsize);
+		crypto_xor(dst, dst, iv, bsize);
+		crypto_xor(iv, dst, src, bsize);
 
 		src += bsize;
 		dst += bsize;
@@ -152,9 +149,8 @@ static int crypto_pcbc_decrypt_inplace(struct skcipher_request *req,
 	do {
 		memcpy(tmpbuf, src, bsize);
 		crypto_cipher_decrypt_one(tfm, src, src);
-		crypto_xor(src, iv, bsize);
-		memcpy(iv, tmpbuf, bsize);
-		crypto_xor(iv, src, bsize);
+		crypto_xor(src, src, iv, bsize);
+		crypto_xor(iv, src, tmpbuf, bsize);
 
 		src += bsize;
 	} while ((nbytes -= bsize) >= bsize);
diff --git a/crypto/salsa20_generic.c b/crypto/salsa20_generic.c
index f550b5d94630..2e59b2c1bcaf 100644
--- a/crypto/salsa20_generic.c
+++ b/crypto/salsa20_generic.c
@@ -152,11 +152,11 @@ static void salsa20_encrypt_bytes(struct salsa20_ctx *ctx, u8 *dst,
 			ctx->input[9]++;
 
 		if (bytes <= 64) {
-			crypto_xor(dst, buf, bytes);
+			crypto_xor(dst, dst, buf, bytes);
 			return;
 		}
 
-		crypto_xor(dst, buf, 64);
+		crypto_xor(dst, dst, buf, 64);
 		bytes -= 64;
 		dst += 64;
 	}
diff --git a/crypto/seqiv.c b/crypto/seqiv.c
index 570b7d1aa0ca..23a6c1d50f06 100644
--- a/crypto/seqiv.c
+++ b/crypto/seqiv.c
@@ -105,7 +105,7 @@ static int seqiv_aead_encrypt(struct aead_request *req)
 			       req->cryptlen - ivsize, info);
 	aead_request_set_ad(subreq, req->assoclen + ivsize);
 
-	crypto_xor(info, ctx->salt, ivsize);
+	crypto_xor(info, info, ctx->salt, ivsize);
 	scatterwalk_map_and_copy(info, req->dst, req->assoclen, ivsize, 1);
 
 	err = crypto_aead_encrypt(subreq);
diff --git a/crypto/xcbc.c b/crypto/xcbc.c
index df90b332554c..addf37e54b1d 100644
--- a/crypto/xcbc.c
+++ b/crypto/xcbc.c
@@ -116,7 +116,7 @@ static int crypto_xcbc_digest_update(struct shash_desc *pdesc, const u8 *p,
 	len -= bs - ctx->len;
 	p += bs - ctx->len;
 
-	crypto_xor(prev, odds, bs);
+	crypto_xor(prev, prev, odds, bs);
 	crypto_cipher_encrypt_one(tfm, prev, prev);
 
 	/* clearing the length */
@@ -124,7 +124,7 @@ static int crypto_xcbc_digest_update(struct shash_desc *pdesc, const u8 *p,
 
 	/* encrypting the rest of data */
 	while (len > bs) {
-		crypto_xor(prev, p, bs);
+		crypto_xor(prev, prev, p, bs);
 		crypto_cipher_encrypt_one(tfm, prev, prev);
 		p += bs;
 		len -= bs;
@@ -166,8 +166,8 @@ static int crypto_xcbc_digest_final(struct shash_desc *pdesc, u8 *out)
 		offset += bs;
 	}
 
-	crypto_xor(prev, odds, bs);
-	crypto_xor(prev, consts + offset, bs);
+	crypto_xor(prev, prev, odds, bs);
+	crypto_xor(prev, prev, consts + offset, bs);
 
 	crypto_cipher_encrypt_one(tfm, out, prev);
 
diff --git a/drivers/crypto/vmx/aes_ctr.c b/drivers/crypto/vmx/aes_ctr.c
index 9c26d9e8dbea..15a23f7e2e24 100644
--- a/drivers/crypto/vmx/aes_ctr.c
+++ b/drivers/crypto/vmx/aes_ctr.c
@@ -104,8 +104,7 @@ static void p8_aes_ctr_final(struct p8_aes_ctr_ctx *ctx,
 	pagefault_enable();
 	preempt_enable();
 
-	crypto_xor(keystream, src, nbytes);
-	memcpy(dst, keystream, nbytes);
+	crypto_xor(dst, keystream, src, nbytes);
 	crypto_inc(ctrblk, AES_BLOCK_SIZE);
 }
 
diff --git a/drivers/md/dm-crypt.c b/drivers/md/dm-crypt.c
index ebf9e72d479b..0434b6b3adfe 100644
--- a/drivers/md/dm-crypt.c
+++ b/drivers/md/dm-crypt.c
@@ -660,7 +660,7 @@ static int crypt_iv_lmk_post(struct crypt_config *cc, u8 *iv,
 
 	/* Tweak the first block of plaintext sector */
 	if (!r)
-		crypto_xor(dst + sg->offset, iv, cc->iv_size);
+		crypto_xor(dst + sg->offset, dst + sg->offset, iv, cc->iv_size);
 
 	kunmap_atomic(dst);
 	return r;
@@ -745,9 +745,8 @@ static int crypt_iv_tcw_whitening(struct crypt_config *cc,
 	int i, r;
 
 	/* xor whitening with sector number */
-	memcpy(buf, tcw->whitening, TCW_WHITENING_SIZE);
-	crypto_xor(buf, (u8 *)&sector, 8);
-	crypto_xor(&buf[8], (u8 *)&sector, 8);
+	crypto_xor(buf, tcw->whitening, (u8 *)&sector, 8);
+	crypto_xor(&buf[8], tcw->whitening + 8, (u8 *)&sector, 8);
 
 	/* calculate crc32 for every 32bit part and xor it */
 	desc->tfm = tcw->crc32_tfm;
@@ -763,12 +762,12 @@ static int crypt_iv_tcw_whitening(struct crypt_config *cc,
 		if (r)
 			goto out;
 	}
-	crypto_xor(&buf[0], &buf[12], 4);
-	crypto_xor(&buf[4], &buf[8], 4);
+	crypto_xor(&buf[0], &buf[0], &buf[12], 4);
+	crypto_xor(&buf[4], &buf[4], &buf[8], 4);
 
 	/* apply whitening (8 bytes) to whole sector */
 	for (i = 0; i < ((1 << SECTOR_SHIFT) / 8); i++)
-		crypto_xor(data + i * 8, buf, 8);
+		crypto_xor(data + i * 8, data + i * 8, buf, 8);
 out:
 	memzero_explicit(buf, sizeof(buf));
 	return r;
@@ -792,10 +791,10 @@ static int crypt_iv_tcw_gen(struct crypt_config *cc, u8 *iv,
 	}
 
 	/* Calculate IV */
-	memcpy(iv, tcw->iv_seed, cc->iv_size);
-	crypto_xor(iv, (u8 *)&sector, 8);
+	crypto_xor(iv, tcw->iv_seed, (u8 *)&sector, 8);
 	if (cc->iv_size > 8)
-		crypto_xor(&iv[8], (u8 *)&sector, cc->iv_size - 8);
+		crypto_xor(&iv[8], tcw->iv_seed + 8, (u8 *)&sector,
+			   cc->iv_size - 8);
 
 	return r;
 }
diff --git a/include/crypto/algapi.h b/include/crypto/algapi.h
index fd547f946bf8..1d650cbd76aa 100644
--- a/include/crypto/algapi.h
+++ b/include/crypto/algapi.h
@@ -194,20 +194,22 @@ static inline unsigned int crypto_queue_len(struct crypto_queue *queue)
 void crypto_inc(u8 *a, unsigned int size);
 void __crypto_xor(u8 *dst, const u8 *src1, const u8 *src2, unsigned int size);
 
-static inline void crypto_xor(u8 *dst, const u8 *src, unsigned int size)
+static inline void crypto_xor(u8 *dst, const u8 *src1, const u8 *src2,
+			      unsigned int size)
 {
 	if (IS_ENABLED(CONFIG_HAVE_EFFICIENT_UNALIGNED_ACCESS) &&
 	    __builtin_constant_p(size) &&
 	    (size % sizeof(unsigned long)) == 0) {
 		unsigned long *d = (unsigned long *)dst;
-		unsigned long *s = (unsigned long *)src;
+		unsigned long *s1 = (unsigned long *)src1;
+		unsigned long *s2 = (unsigned long *)src2;
 
 		while (size > 0) {
-			*d++ ^= *s++;
+			*d++ = *s1++ ^ *s2++;
 			size -= sizeof(unsigned long);
 		}
 	} else {
-		__crypto_xor(dst, dst, src, size);
+		__crypto_xor(dst, src1, src2, size);
 	}
 }
 
diff --git a/include/crypto/cbc.h b/include/crypto/cbc.h
index f5b8bfc22e6d..ed0dd28aa766 100644
--- a/include/crypto/cbc.h
+++ b/include/crypto/cbc.h
@@ -28,7 +28,7 @@ static inline int crypto_cbc_encrypt_segment(
 	u8 *iv = walk->iv;
 
 	do {
-		crypto_xor(iv, src, bsize);
+		crypto_xor(iv, iv, src, bsize);
 		fn(tfm, iv, dst);
 		memcpy(iv, dst, bsize);
 
@@ -49,7 +49,7 @@ static inline int crypto_cbc_encrypt_inplace(
 	u8 *iv = walk->iv;
 
 	do {
-		crypto_xor(src, iv, bsize);
+		crypto_xor(src, src, iv, bsize);
 		fn(tfm, src, src);
 		iv = src;
 
@@ -94,7 +94,7 @@ static inline int crypto_cbc_decrypt_segment(
 
 	do {
 		fn(tfm, src, dst);
-		crypto_xor(dst, iv, bsize);
+		crypto_xor(dst, dst, iv, bsize);
 		iv = src;
 
 		src += bsize;
@@ -123,11 +123,11 @@ static inline int crypto_cbc_decrypt_inplace(
 		fn(tfm, src, src);
 		if ((nbytes -= bsize) < bsize)
 			break;
-		crypto_xor(src, src - bsize, bsize);
+		crypto_xor(src, src, src - bsize, bsize);
 		src -= bsize;
 	}
 
-	crypto_xor(src, walk->iv, bsize);
+	crypto_xor(src, src, walk->iv, bsize);
 	memcpy(walk->iv, last_iv, bsize);
 
 	return nbytes;
diff --git a/net/mac80211/fils_aead.c b/net/mac80211/fils_aead.c
index 3cfb1e2ab7ac..a63804f2f1ae 100644
--- a/net/mac80211/fils_aead.c
+++ b/net/mac80211/fils_aead.c
@@ -41,7 +41,7 @@ static int aes_s2v(struct crypto_shash *tfm,
 		/* D = dbl(D) xor AES_CMAC(K, Si) */
 		gf_mulx(d); /* dbl */
 		crypto_shash_digest(desc, addr[i], len[i], tmp);
-		crypto_xor(d, tmp, AES_BLOCK_SIZE);
+		crypto_xor(d, d, tmp, AES_BLOCK_SIZE);
 	}
 
 	crypto_shash_init(desc);
@@ -50,13 +50,13 @@ static int aes_s2v(struct crypto_shash *tfm,
 		/* len(Sn) >= 128 */
 		/* T = Sn xorend D */
 		crypto_shash_update(desc, addr[i], len[i] - AES_BLOCK_SIZE);
-		crypto_xor(d, addr[i] + len[i] - AES_BLOCK_SIZE,
+		crypto_xor(d, d, addr[i] + len[i] - AES_BLOCK_SIZE,
 			   AES_BLOCK_SIZE);
 	} else {
 		/* len(Sn) < 128 */
 		/* T = dbl(D) xor pad(Sn) */
 		gf_mulx(d); /* dbl */
-		crypto_xor(d, addr[i], len[i]);
+		crypto_xor(d, d, addr[i], len[i]);
 		d[len[i]] ^= 0x80;
 	}
 	/* V = AES-CMAC(K, T) */
-- 
2.9.3
