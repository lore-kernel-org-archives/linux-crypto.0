Received: from abb.hmeau.com (abb.hmeau.com [144.6.53.87])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 55D221DFF0
	for <linux-crypto@vger.kernel.org>; Sat,  8 Mar 2025 12:53:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=144.6.53.87
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741438400; cv=none; b=Ls20kJU+Sop83oyD/RwTRxFetUBTJTGCQBVtZcDRzMRvMlMIXzgaXe/ZIxfdJlP2hnEBpCwV/JloDZZuI/mSWPExYBPNnRmyaTgGzvCXKlA+c6B5Z0OrcOPeJM6cdPd30XuzPi3f4bcZFfKoaOqgIann5c6CiNoXzlQMcjDlhgc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741438400; c=relaxed/simple;
	bh=vZWVifJRjH/Lc96YeyJLRPfqffDQB7o7/HzGrIXBYu8=;
	h=Date:From:To:Subject:Message-ID:MIME-Version:Content-Type:
	 Content-Disposition; b=I4fcv++KXqL22ZqOX7eWv+JIdkrHA6MaVv1kICrVu/Ekx7D/Tfdpj9Kny7ua0qu2N6mVOqvDfoqJqbTZgsD9ihvGUbcmMeeSGB3YXCmDvJptJBssACsXuhx+U4kQm2MNZwzIvppblkSNLB9sBNQ2rwqEOw6LyeZrU4Q0brAbiQY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au; spf=pass smtp.mailfrom=gondor.apana.org.au; dkim=pass (2048-bit key) header.d=hmeau.com header.i=@hmeau.com header.b=cyXVlVoF; arc=none smtp.client-ip=144.6.53.87
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=hmeau.com header.i=@hmeau.com header.b="cyXVlVoF"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=hmeau.com;
	s=formenos; h=Content-Type:MIME-Version:Message-ID:Subject:To:From:Date:
	Sender:Reply-To:Cc:Content-Transfer-Encoding:Content-ID:Content-Description:
	Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:
	In-Reply-To:References:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=Vx5OmdqE/Wrunz3calnSQTGYvEKbuDnLHokWU41W/e0=; b=cyXVlVoFRv/Kqwv1PxbxegGQX1
	RGAxwLcW/zLs0t4iFrmW9bbFiLKt5CsHJF5OVvzQLfGx0cBDcAfns2L07RAczp3hSvhMvabGujTsw
	4OC/an99f5VuFRja51EQ87J9jRytODI4A2E+HaYwmGVzP1II069c4pTM9ch9UBk2510iRda9FHPkj
	r8LUDv7wY8RVMNFCVFQ7Kb+ns1CqUPaGejPoloxrZKd5LCAgz3tBUE1RwgWRhitwyF0EXyoavKxHq
	XGXviK4WeDw8632BkHQjs+KjRwpJu6+xIDw0ubosUwBtc61gztL5yLHWPAZlFq1qFwEXF/+QuNZw9
	lftjrv6w==;
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.96 #2 (Debian))
	id 1tqtg1-004rCY-1m;
	Sat, 08 Mar 2025 20:53:14 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Sat, 08 Mar 2025 20:53:13 +0800
Date: Sat, 8 Mar 2025 20:53:13 +0800
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Linux Crypto Mailing List <linux-crypto@vger.kernel.org>
Subject: [PATCH] crypto: skcipher - Make skcipher_walk src.virt.addr const
Message-ID: <Z8w9uScE4PHqL2Vr@gondor.apana.org.au>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

This patch is based on the scatterwalk_next/memcpy_sglist patch
series.

---8<---
Mark the src.virt.addr field in struct skcipher_walk as a pointer
to const data.  This guarantees that the user won't modify the data
which should be done through dst.virt.addr to ensure that flushing
is done when necessary.

Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
---
 arch/arm/crypto/aes-ce-glue.c          |  2 +-
 arch/arm64/crypto/aes-neonbs-glue.c    |  3 ++-
 arch/powerpc/crypto/aes-gcm-p10-glue.c |  6 +++---
 arch/powerpc/crypto/aes_ctr.c          |  2 +-
 arch/sparc/crypto/aes_glue.c           |  2 +-
 arch/x86/crypto/des3_ede_glue.c        |  2 +-
 crypto/ctr.c                           | 10 ++++-----
 crypto/lrw.c                           |  2 +-
 crypto/pcbc.c                          | 28 +++++++++++++-------------
 crypto/xctr.c                          |  2 +-
 crypto/xts.c                           |  2 +-
 include/crypto/ctr.h                   |  2 +-
 include/crypto/internal/skcipher.h     |  2 +-
 13 files changed, 33 insertions(+), 32 deletions(-)

diff --git a/arch/arm/crypto/aes-ce-glue.c b/arch/arm/crypto/aes-ce-glue.c
index 21df5e7f51f9..1cf61f51e766 100644
--- a/arch/arm/crypto/aes-ce-glue.c
+++ b/arch/arm/crypto/aes-ce-glue.c
@@ -399,9 +399,9 @@ static int ctr_encrypt(struct skcipher_request *req)
 	}
 	if (walk.nbytes) {
 		u8 __aligned(8) tail[AES_BLOCK_SIZE];
+		const u8 *tsrc = walk.src.virt.addr;
 		unsigned int nbytes = walk.nbytes;
 		u8 *tdst = walk.dst.virt.addr;
-		u8 *tsrc = walk.src.virt.addr;
 
 		/*
 		 * Tell aes_ctr_encrypt() to process a tail block.
diff --git a/arch/arm64/crypto/aes-neonbs-glue.c b/arch/arm64/crypto/aes-neonbs-glue.c
index 46425e7b9755..c4a623e86593 100644
--- a/arch/arm64/crypto/aes-neonbs-glue.c
+++ b/arch/arm64/crypto/aes-neonbs-glue.c
@@ -287,7 +287,8 @@ static int __xts_crypt(struct skcipher_request *req, bool encrypt,
 	struct skcipher_walk walk;
 	int nbytes, err;
 	int first = 1;
-	u8 *out, *in;
+	const u8 *in;
+	u8 *out;
 
 	if (req->cryptlen < AES_BLOCK_SIZE)
 		return -EINVAL;
diff --git a/arch/powerpc/crypto/aes-gcm-p10-glue.c b/arch/powerpc/crypto/aes-gcm-p10-glue.c
index 679f52794baf..85f4fd4b1bdc 100644
--- a/arch/powerpc/crypto/aes-gcm-p10-glue.c
+++ b/arch/powerpc/crypto/aes-gcm-p10-glue.c
@@ -35,9 +35,9 @@ MODULE_ALIAS_CRYPTO("aes");
 asmlinkage int aes_p10_set_encrypt_key(const u8 *userKey, const int bits,
 				       void *key);
 asmlinkage void aes_p10_encrypt(const u8 *in, u8 *out, const void *key);
-asmlinkage void aes_p10_gcm_encrypt(u8 *in, u8 *out, size_t len,
+asmlinkage void aes_p10_gcm_encrypt(const u8 *in, u8 *out, size_t len,
 				    void *rkey, u8 *iv, void *Xi);
-asmlinkage void aes_p10_gcm_decrypt(u8 *in, u8 *out, size_t len,
+asmlinkage void aes_p10_gcm_decrypt(const u8 *in, u8 *out, size_t len,
 				    void *rkey, u8 *iv, void *Xi);
 asmlinkage void gcm_init_htable(unsigned char htable[], unsigned char Xi[]);
 asmlinkage void gcm_ghash_p10(unsigned char *Xi, unsigned char *Htable,
@@ -261,7 +261,7 @@ static int p10_aes_gcm_crypt(struct aead_request *req, u8 *riv,
 		return ret;
 
 	while ((nbytes = walk.nbytes) > 0 && ret == 0) {
-		u8 *src = walk.src.virt.addr;
+		const u8 *src = walk.src.virt.addr;
 		u8 *dst = walk.dst.virt.addr;
 		u8 buf[AES_BLOCK_SIZE];
 
diff --git a/arch/powerpc/crypto/aes_ctr.c b/arch/powerpc/crypto/aes_ctr.c
index 9a3da8cd62f3..3da75f42529a 100644
--- a/arch/powerpc/crypto/aes_ctr.c
+++ b/arch/powerpc/crypto/aes_ctr.c
@@ -69,9 +69,9 @@ static int p8_aes_ctr_setkey(struct crypto_skcipher *tfm, const u8 *key,
 static void p8_aes_ctr_final(const struct p8_aes_ctr_ctx *ctx,
 			     struct skcipher_walk *walk)
 {
+	const u8 *src = walk->src.virt.addr;
 	u8 *ctrblk = walk->iv;
 	u8 keystream[AES_BLOCK_SIZE];
-	u8 *src = walk->src.virt.addr;
 	u8 *dst = walk->dst.virt.addr;
 	unsigned int nbytes = walk->nbytes;
 
diff --git a/arch/sparc/crypto/aes_glue.c b/arch/sparc/crypto/aes_glue.c
index e3d2138ff9e2..683150830356 100644
--- a/arch/sparc/crypto/aes_glue.c
+++ b/arch/sparc/crypto/aes_glue.c
@@ -321,7 +321,7 @@ static void ctr_crypt_final(const struct crypto_sparc64_aes_ctx *ctx,
 {
 	u8 *ctrblk = walk->iv;
 	u64 keystream[AES_BLOCK_SIZE / sizeof(u64)];
-	u8 *src = walk->src.virt.addr;
+	const u8 *src = walk->src.virt.addr;
 	u8 *dst = walk->dst.virt.addr;
 	unsigned int nbytes = walk->nbytes;
 
diff --git a/arch/x86/crypto/des3_ede_glue.c b/arch/x86/crypto/des3_ede_glue.c
index e88439d3828e..34600f90d8a6 100644
--- a/arch/x86/crypto/des3_ede_glue.c
+++ b/arch/x86/crypto/des3_ede_glue.c
@@ -73,7 +73,7 @@ static int ecb_crypt(struct skcipher_request *req, const u32 *expkey)
 	err = skcipher_walk_virt(&walk, req, false);
 
 	while ((nbytes = walk.nbytes)) {
-		u8 *wsrc = walk.src.virt.addr;
+		const u8 *wsrc = walk.src.virt.addr;
 		u8 *wdst = walk.dst.virt.addr;
 
 		/* Process four block batch */
diff --git a/crypto/ctr.c b/crypto/ctr.c
index 73c0d6e53b2f..97a947b0a876 100644
--- a/crypto/ctr.c
+++ b/crypto/ctr.c
@@ -33,7 +33,7 @@ static void crypto_ctr_crypt_final(struct skcipher_walk *walk,
 	u8 *ctrblk = walk->iv;
 	u8 tmp[MAX_CIPHER_BLOCKSIZE + MAX_CIPHER_ALIGNMASK];
 	u8 *keystream = PTR_ALIGN(tmp + 0, alignmask + 1);
-	u8 *src = walk->src.virt.addr;
+	const u8 *src = walk->src.virt.addr;
 	u8 *dst = walk->dst.virt.addr;
 	unsigned int nbytes = walk->nbytes;
 
@@ -50,7 +50,7 @@ static int crypto_ctr_crypt_segment(struct skcipher_walk *walk,
 		   crypto_cipher_alg(tfm)->cia_encrypt;
 	unsigned int bsize = crypto_cipher_blocksize(tfm);
 	u8 *ctrblk = walk->iv;
-	u8 *src = walk->src.virt.addr;
+	const u8 *src = walk->src.virt.addr;
 	u8 *dst = walk->dst.virt.addr;
 	unsigned int nbytes = walk->nbytes;
 
@@ -77,20 +77,20 @@ static int crypto_ctr_crypt_inplace(struct skcipher_walk *walk,
 	unsigned int bsize = crypto_cipher_blocksize(tfm);
 	unsigned long alignmask = crypto_cipher_alignmask(tfm);
 	unsigned int nbytes = walk->nbytes;
+	u8 *dst = walk->dst.virt.addr;
 	u8 *ctrblk = walk->iv;
-	u8 *src = walk->src.virt.addr;
 	u8 tmp[MAX_CIPHER_BLOCKSIZE + MAX_CIPHER_ALIGNMASK];
 	u8 *keystream = PTR_ALIGN(tmp + 0, alignmask + 1);
 
 	do {
 		/* create keystream */
 		fn(crypto_cipher_tfm(tfm), keystream, ctrblk);
-		crypto_xor(src, keystream, bsize);
+		crypto_xor(dst, keystream, bsize);
 
 		/* increment counter in counterblock */
 		crypto_inc(ctrblk, bsize);
 
-		src += bsize;
+		dst += bsize;
 	} while ((nbytes -= bsize) >= bsize);
 
 	return nbytes;
diff --git a/crypto/lrw.c b/crypto/lrw.c
index e216fbf2b786..391ae0f7641f 100644
--- a/crypto/lrw.c
+++ b/crypto/lrw.c
@@ -167,7 +167,7 @@ static int lrw_xor_tweak(struct skcipher_request *req, bool second_pass)
 
 	while (w.nbytes) {
 		unsigned int avail = w.nbytes;
-		be128 *wsrc;
+		const be128 *wsrc;
 		be128 *wdst;
 
 		wsrc = w.src.virt.addr;
diff --git a/crypto/pcbc.c b/crypto/pcbc.c
index cbfb3ac14b3a..9d2e56d6744a 100644
--- a/crypto/pcbc.c
+++ b/crypto/pcbc.c
@@ -22,8 +22,8 @@ static int crypto_pcbc_encrypt_segment(struct skcipher_request *req,
 				       struct crypto_cipher *tfm)
 {
 	int bsize = crypto_cipher_blocksize(tfm);
+	const u8 *src = walk->src.virt.addr;
 	unsigned int nbytes = walk->nbytes;
-	u8 *src = walk->src.virt.addr;
 	u8 *dst = walk->dst.virt.addr;
 	u8 * const iv = walk->iv;
 
@@ -45,17 +45,17 @@ static int crypto_pcbc_encrypt_inplace(struct skcipher_request *req,
 {
 	int bsize = crypto_cipher_blocksize(tfm);
 	unsigned int nbytes = walk->nbytes;
-	u8 *src = walk->src.virt.addr;
+	u8 *dst = walk->dst.virt.addr;
 	u8 * const iv = walk->iv;
 	u8 tmpbuf[MAX_CIPHER_BLOCKSIZE];
 
 	do {
-		memcpy(tmpbuf, src, bsize);
-		crypto_xor(iv, src, bsize);
-		crypto_cipher_encrypt_one(tfm, src, iv);
-		crypto_xor_cpy(iv, tmpbuf, src, bsize);
+		memcpy(tmpbuf, dst, bsize);
+		crypto_xor(iv, dst, bsize);
+		crypto_cipher_encrypt_one(tfm, dst, iv);
+		crypto_xor_cpy(iv, tmpbuf, dst, bsize);
 
-		src += bsize;
+		dst += bsize;
 	} while ((nbytes -= bsize) >= bsize);
 
 	return nbytes;
@@ -89,8 +89,8 @@ static int crypto_pcbc_decrypt_segment(struct skcipher_request *req,
 				       struct crypto_cipher *tfm)
 {
 	int bsize = crypto_cipher_blocksize(tfm);
+	const u8 *src = walk->src.virt.addr;
 	unsigned int nbytes = walk->nbytes;
-	u8 *src = walk->src.virt.addr;
 	u8 *dst = walk->dst.virt.addr;
 	u8 * const iv = walk->iv;
 
@@ -112,17 +112,17 @@ static int crypto_pcbc_decrypt_inplace(struct skcipher_request *req,
 {
 	int bsize = crypto_cipher_blocksize(tfm);
 	unsigned int nbytes = walk->nbytes;
-	u8 *src = walk->src.virt.addr;
+	u8 *dst = walk->dst.virt.addr;
 	u8 * const iv = walk->iv;
 	u8 tmpbuf[MAX_CIPHER_BLOCKSIZE] __aligned(__alignof__(u32));
 
 	do {
-		memcpy(tmpbuf, src, bsize);
-		crypto_cipher_decrypt_one(tfm, src, src);
-		crypto_xor(src, iv, bsize);
-		crypto_xor_cpy(iv, src, tmpbuf, bsize);
+		memcpy(tmpbuf, dst, bsize);
+		crypto_cipher_decrypt_one(tfm, dst, dst);
+		crypto_xor(dst, iv, bsize);
+		crypto_xor_cpy(iv, dst, tmpbuf, bsize);
 
-		src += bsize;
+		dst += bsize;
 	} while ((nbytes -= bsize) >= bsize);
 
 	return nbytes;
diff --git a/crypto/xctr.c b/crypto/xctr.c
index 6ed9c85ededa..9c536ab6d2e5 100644
--- a/crypto/xctr.c
+++ b/crypto/xctr.c
@@ -78,7 +78,7 @@ static int crypto_xctr_crypt_inplace(struct skcipher_walk *walk,
 		   crypto_cipher_alg(tfm)->cia_encrypt;
 	unsigned long alignmask = crypto_cipher_alignmask(tfm);
 	unsigned int nbytes = walk->nbytes;
-	u8 *data = walk->src.virt.addr;
+	u8 *data = walk->dst.virt.addr;
 	u8 tmp[XCTR_BLOCKSIZE + MAX_CIPHER_ALIGNMASK];
 	u8 *keystream = PTR_ALIGN(tmp + 0, alignmask + 1);
 	__le32 ctr32 = cpu_to_le32(byte_ctr / XCTR_BLOCKSIZE + 1);
diff --git a/crypto/xts.c b/crypto/xts.c
index 821060ede2cf..31529c9ef08f 100644
--- a/crypto/xts.c
+++ b/crypto/xts.c
@@ -99,7 +99,7 @@ static int xts_xor_tweak(struct skcipher_request *req, bool second_pass,
 
 	while (w.nbytes) {
 		unsigned int avail = w.nbytes;
-		le128 *wsrc;
+		const le128 *wsrc;
 		le128 *wdst;
 
 		wsrc = w.src.virt.addr;
diff --git a/include/crypto/ctr.h b/include/crypto/ctr.h
index a1c66d1001af..da1ee73e9ce9 100644
--- a/include/crypto/ctr.h
+++ b/include/crypto/ctr.h
@@ -34,8 +34,8 @@ static inline int crypto_ctr_encrypt_walk(struct skcipher_request *req,
 	err = skcipher_walk_virt(&walk, req, false);
 
 	while (walk.nbytes > 0) {
+		const u8 *src = walk.src.virt.addr;
 		u8 *dst = walk.dst.virt.addr;
-		u8 *src = walk.src.virt.addr;
 		int nbytes = walk.nbytes;
 		int tail = 0;
 
diff --git a/include/crypto/internal/skcipher.h b/include/crypto/internal/skcipher.h
index c705124432c5..a958ab0636ad 100644
--- a/include/crypto/internal/skcipher.h
+++ b/include/crypto/internal/skcipher.h
@@ -59,7 +59,7 @@ struct skcipher_walk {
 		/* Virtual address of the source. */
 		struct {
 			struct {
-				void *const addr;
+				const void *const addr;
 			} virt;
 		} src;
 
-- 
2.39.5

-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
