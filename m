Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1246F22A4EA;
	Tue,  8 Jul 2025 19:41:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752003712; cv=none; b=C1rh6+U7wv8sMG34JYofGCxrVqYNdL170g3eH31dnpSbwhKY4hIY9R0ztK5QX9ywtCGCzssFGMw4xxMIvDtogSoYAgmSUK/KI88OkaVv3jqKkEG+BsU2BafwyGgJB+J363rWGJWzZZIZacePXY9eAhh8Y/nFuKyOU++xsXdDBik=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752003712; c=relaxed/simple;
	bh=+yh9rZue4KGBASAWkz2WqG1QhGu6p6nelYvHSKxXk2w=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=hFqIlghkM9EbopVW40Ah1uRg9qi23714awoeFFQexT5TURW4lN4UBSPQwZlccm8u7nB2AnLvFQ9IGMzaS0XkqknNM6+sVUP09/ybuC9UIK8tKWywnMXe6Dglwa8eUlOx2aNAKuVZNUcCQWOxWlyvByeRl0Uj2FEL/7seYlqZyQQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=EoArbtNj; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="EoArbtNj"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 427FEC4CEF6;
	Tue,  8 Jul 2025 19:41:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1752003711;
	bh=+yh9rZue4KGBASAWkz2WqG1QhGu6p6nelYvHSKxXk2w=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=EoArbtNjRCOlF3hIAD6+wxNpggOXgqAJIfep9N2Y7DPZjvbLQcYkI/gwTasMHUI7c
	 VM/i34On5/KHsd70ZgZGuxtLpDIem3B1GmIteVByZgWMtjycfUCg4zkhMQkrfM6pq1
	 IiUU98uNttXf35xMxppX8ZHhan4VbL9hPCk5tH2hAB1fDE7BLzKZ1NDvFFJfgkkEgn
	 uHwqVAXRj+OFh+M0+CAF2xZYpOJ3qw9q+52VOZH0zSDlRdKBzQ8ffDGignle4wqU/C
	 fxAV1KOw8DOYiuVyO+L6XvWSV4gTsdDxuXN3rSKH4J8jSB2UztZlllx9t5LTAcnsgd
	 hgAVbs5VFH3Sg==
From: Eric Biggers <ebiggers@kernel.org>
To: linux-crypto@vger.kernel.org
Cc: linux-kernel@vger.kernel.org,
	x86@kernel.org,
	linux-rt-devel@lists.linux.dev,
	Eric Biggers <ebiggers@kernel.org>,
	stable@vger.kernel.org
Subject: [PATCH 2/2] crypto: x86/aegis - Add missing error checks
Date: Tue,  8 Jul 2025 12:38:29 -0700
Message-ID: <20250708193829.656988-3-ebiggers@kernel.org>
X-Mailer: git-send-email 2.50.0
In-Reply-To: <20250708193829.656988-1-ebiggers@kernel.org>
References: <20250708193829.656988-1-ebiggers@kernel.org>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

The skcipher_walk functions can allocate memory and can fail, so
checking for errors is necessary.

Fixes: 1d373d4e8e15 ("crypto: x86 - Add optimized AEGIS implementations")
Cc: stable@vger.kernel.org
Signed-off-by: Eric Biggers <ebiggers@kernel.org>
---
 arch/x86/crypto/aegis128-aesni-glue.c | 36 +++++++++++++++++++--------
 1 file changed, 25 insertions(+), 11 deletions(-)

diff --git a/arch/x86/crypto/aegis128-aesni-glue.c b/arch/x86/crypto/aegis128-aesni-glue.c
index 3cb5c193038bb..f1adfba1a76ea 100644
--- a/arch/x86/crypto/aegis128-aesni-glue.c
+++ b/arch/x86/crypto/aegis128-aesni-glue.c
@@ -102,14 +102,16 @@ static void crypto_aegis128_aesni_process_ad(
 		memset(buf.bytes + pos, 0, AEGIS128_BLOCK_SIZE - pos);
 		aegis128_aesni_ad(state, buf.bytes, AEGIS128_BLOCK_SIZE);
 	}
 }
 
-static __always_inline void
+static __always_inline int
 crypto_aegis128_aesni_process_crypt(struct aegis_state *state,
 				    struct skcipher_walk *walk, bool enc)
 {
+	int err = 0;
+
 	while (walk->nbytes >= AEGIS128_BLOCK_SIZE) {
 		if (enc)
 			aegis128_aesni_enc(state, walk->src.virt.addr,
 					   walk->dst.virt.addr,
 					   round_down(walk->nbytes,
@@ -118,11 +120,12 @@ crypto_aegis128_aesni_process_crypt(struct aegis_state *state,
 			aegis128_aesni_dec(state, walk->src.virt.addr,
 					   walk->dst.virt.addr,
 					   round_down(walk->nbytes,
 						      AEGIS128_BLOCK_SIZE));
 		kernel_fpu_end();
-		skcipher_walk_done(walk, walk->nbytes % AEGIS128_BLOCK_SIZE);
+		err = skcipher_walk_done(walk,
+					 walk->nbytes % AEGIS128_BLOCK_SIZE);
 		kernel_fpu_begin();
 	}
 
 	if (walk->nbytes) {
 		if (enc)
@@ -132,13 +135,14 @@ crypto_aegis128_aesni_process_crypt(struct aegis_state *state,
 		else
 			aegis128_aesni_dec_tail(state, walk->src.virt.addr,
 						walk->dst.virt.addr,
 						walk->nbytes);
 		kernel_fpu_end();
-		skcipher_walk_done(walk, 0);
+		err = skcipher_walk_done(walk, 0);
 		kernel_fpu_begin();
 	}
+	return err;
 }
 
 static struct aegis_ctx *crypto_aegis128_aesni_ctx(struct crypto_aead *aead)
 {
 	u8 *ctx = crypto_aead_ctx(aead);
@@ -167,43 +171,50 @@ static int crypto_aegis128_aesni_setauthsize(struct crypto_aead *tfm,
 	if (authsize < AEGIS128_MIN_AUTH_SIZE)
 		return -EINVAL;
 	return 0;
 }
 
-static __always_inline void
+static __always_inline int
 crypto_aegis128_aesni_crypt(struct aead_request *req,
 			    struct aegis_block *tag_xor,
 			    unsigned int cryptlen, bool enc)
 {
 	struct crypto_aead *tfm = crypto_aead_reqtfm(req);
 	struct aegis_ctx *ctx = crypto_aegis128_aesni_ctx(tfm);
 	struct skcipher_walk walk;
 	struct aegis_state state;
+	int err;
 
 	if (enc)
-		skcipher_walk_aead_encrypt(&walk, req, false);
+		err = skcipher_walk_aead_encrypt(&walk, req, false);
 	else
-		skcipher_walk_aead_decrypt(&walk, req, false);
+		err = skcipher_walk_aead_decrypt(&walk, req, false);
+	if (err)
+		return err;
 
 	kernel_fpu_begin();
 
 	aegis128_aesni_init(&state, &ctx->key, req->iv);
 	crypto_aegis128_aesni_process_ad(&state, req->src, req->assoclen);
-	crypto_aegis128_aesni_process_crypt(&state, &walk, enc);
-	aegis128_aesni_final(&state, tag_xor, req->assoclen, cryptlen);
-
+	err = crypto_aegis128_aesni_process_crypt(&state, &walk, enc);
+	if (err == 0)
+		aegis128_aesni_final(&state, tag_xor, req->assoclen, cryptlen);
 	kernel_fpu_end();
+	return err;
 }
 
 static int crypto_aegis128_aesni_encrypt(struct aead_request *req)
 {
 	struct crypto_aead *tfm = crypto_aead_reqtfm(req);
 	struct aegis_block tag = {};
 	unsigned int authsize = crypto_aead_authsize(tfm);
 	unsigned int cryptlen = req->cryptlen;
+	int err;
 
-	crypto_aegis128_aesni_crypt(req, &tag, cryptlen, true);
+	err = crypto_aegis128_aesni_crypt(req, &tag, cryptlen, true);
+	if (err)
+		return err;
 
 	scatterwalk_map_and_copy(tag.bytes, req->dst,
 				 req->assoclen + cryptlen, authsize, 1);
 	return 0;
 }
@@ -214,15 +225,18 @@ static int crypto_aegis128_aesni_decrypt(struct aead_request *req)
 
 	struct crypto_aead *tfm = crypto_aead_reqtfm(req);
 	struct aegis_block tag;
 	unsigned int authsize = crypto_aead_authsize(tfm);
 	unsigned int cryptlen = req->cryptlen - authsize;
+	int err;
 
 	scatterwalk_map_and_copy(tag.bytes, req->src,
 				 req->assoclen + cryptlen, authsize, 0);
 
-	crypto_aegis128_aesni_crypt(req, &tag, cryptlen, false);
+	err = crypto_aegis128_aesni_crypt(req, &tag, cryptlen, false);
+	if (err)
+		return err;
 
 	return crypto_memneq(tag.bytes, zeros.bytes, authsize) ? -EBADMSG : 0;
 }
 
 static struct aead_alg crypto_aegis128_aesni_alg = {
-- 
2.50.0

