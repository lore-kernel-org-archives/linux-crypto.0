Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 224D535C192
	for <linux-crypto@vger.kernel.org>; Wed,  3 Dec 2025 16:38:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764779896; cv=none; b=j5RxM4YfYvQn1DBCqxi5M//g2a3Wn2JC6fn37Gpv7KXZLk/fQAO4Jy5JsesVGbJtqOQG3Szkk+fgDfMWR+hOsjY41lZY5I9zQqflYG4b2wP4keYK7qRi0AEBL60qKK4ZIDNszMapAxbEz5w571VA2XeEX/9tvoc3GWeyFUGTA7A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764779896; c=relaxed/simple;
	bh=yCZW0k1s7QqvGNZimr64T61+yvDWF6ufTV8hx1MABl0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=PQc+dW1NjdH0/yhxxEau5zQxKRGO30Fr+2tCzLn5sn9V0CxF88tWm9z0liHQbfb7dbo18bPJEp4OWzfo+H7mqKaoEqB2zYADwfhXQT5LEzhKVfD07e6WLHfqC/RivJCu8mlCB6rIU+hwNe101DxhUznxVe2PBBtokHaJSVdRvw4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=d/9xETx/; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="d/9xETx/"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F3AD5C16AAE;
	Wed,  3 Dec 2025 16:38:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1764779895;
	bh=yCZW0k1s7QqvGNZimr64T61+yvDWF6ufTV8hx1MABl0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=d/9xETx/8OgRcYRS0QR2I2GIyoeX0zFdEosetcOJOG/o+v3m36A/mp6O0uJtKLv/h
	 8EAL/HaO0UpQ5ENz7G9enQQgL46Y//mEm1HGl2RfeUpccwMzwLlVaHYb4bFqLP5woE
	 Q1lGdoEo61lFGFCbq96dOUCZyuvhP2o0Aw9aH68uowl1499wUHZm92+nyzxKwRQz6P
	 Nv9PImIDqJr2ylYcH/ELjni+TIfHQ2YlhUiQAdLCYMwK/K9NICmLMhQJZMXlGrhVxU
	 xOZJCOyERiWRlzIFcxkHFJtz3blZ34Gtqr0RgqhjQ3kRsFkCObqTH+UPK++aYep9/e
	 N25e/wgkCNsYA==
From: Ard Biesheuvel <ardb@kernel.org>
To: linux-crypto@vger.kernel.org
Cc: Ard Biesheuvel <ardb@kernel.org>,
	Arnd Bergmann <arnd@arndb.de>,
	Eric Biggers <ebiggers@kernel.org>,
	Herbert Xu <herbert@gondor.apana.org.au>
Subject: [PATCH 1/2] crypto/arm64: aes/xts - Using single ksimd scope to reduce stack bloat
Date: Wed,  3 Dec 2025 17:38:05 +0100
Message-ID: <20251203163803.157541-5-ardb@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20251203163803.157541-4-ardb@kernel.org>
References: <20251203163803.157541-4-ardb@kernel.org>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=7104; i=ardb@kernel.org; h=from:subject; bh=yCZW0k1s7QqvGNZimr64T61+yvDWF6ufTV8hx1MABl0=; b=owGbwMvMwCVmkMcZplerG8N4Wi2JIdMgPXcdh750etJ+5wX+7CcaTsySKEnu2j0hvF9Iu+nwz MTUTd4dpSwMYlwMsmKKLAKz/77beXqiVK3zLFmYOaxMIEMYuDgFYCLznBgZbqY9fL2BVf21B0fs 9Iq7Hp0tt/PcW9QDLL5p7TA/d+XUPYb/2RuvHYydzmxU+SW+wN7H+f4iWZazMT//F7z41s8c/3Y eDwA=
X-Developer-Key: i=ardb@kernel.org; a=openpgp; fpr=F43D03328115A198C90016883D200E9CA6329909
Content-Transfer-Encoding: 8bit

The ciphertext stealing logic in the AES-XTS implementation creates a
separate ksimd scope to call into the FP/SIMD core routines, and in some
cases (CONFIG_KASAN_STACK is one, but there might be others), the 528
byte kernel mode FP/SIMD buffer that is allocated inside this scope is
not shared with the preceding ksimd scope, resulting in unnecessary
stack bloat.

Considering that

a) the XTS ciphertext stealing logic is never called for block
   encryption use cases, and XTS is rarely used for anything else,

b) in the vast majority of cases, the entire input block is processed
   during the first iteration of the loop,

we can combine both ksimd scopes into a single one with no practical
impact on how often/how long FP/SIMD is en/disabled, allowing us to
reuse the same stack slot for both FP/SIMD routine calls.

Fixes: ba3c1b3b5ac9 ("crypto/arm64: aes-blk - Switch to 'ksimd' scoped guard API")
Signed-off-by: Ard Biesheuvel <ardb@kernel.org>
---
 arch/arm64/crypto/aes-glue.c        | 75 ++++++++++----------
 arch/arm64/crypto/aes-neonbs-glue.c | 44 ++++++------
 2 files changed, 57 insertions(+), 62 deletions(-)

diff --git a/arch/arm64/crypto/aes-glue.c b/arch/arm64/crypto/aes-glue.c
index b087b900d279..c51d4487e9e9 100644
--- a/arch/arm64/crypto/aes-glue.c
+++ b/arch/arm64/crypto/aes-glue.c
@@ -549,38 +549,37 @@ static int __maybe_unused xts_encrypt(struct skcipher_request *req)
 		tail = 0;
 	}
 
-	for (first = 1; walk.nbytes >= AES_BLOCK_SIZE; first = 0) {
-		int nbytes = walk.nbytes;
+	scoped_ksimd() {
+		for (first = 1; walk.nbytes >= AES_BLOCK_SIZE; first = 0) {
+			int nbytes = walk.nbytes;
 
-		if (walk.nbytes < walk.total)
-			nbytes &= ~(AES_BLOCK_SIZE - 1);
+			if (walk.nbytes < walk.total)
+				nbytes &= ~(AES_BLOCK_SIZE - 1);
 
-		scoped_ksimd()
 			aes_xts_encrypt(walk.dst.virt.addr, walk.src.virt.addr,
 					ctx->key1.key_enc, rounds, nbytes,
 					ctx->key2.key_enc, walk.iv, first);
-		err = skcipher_walk_done(&walk, walk.nbytes - nbytes);
-	}
+			err = skcipher_walk_done(&walk, walk.nbytes - nbytes);
+		}
 
-	if (err || likely(!tail))
-		return err;
+		if (err || likely(!tail))
+			return err;
 
-	dst = src = scatterwalk_ffwd(sg_src, req->src, req->cryptlen);
-	if (req->dst != req->src)
-		dst = scatterwalk_ffwd(sg_dst, req->dst, req->cryptlen);
+		dst = src = scatterwalk_ffwd(sg_src, req->src, req->cryptlen);
+		if (req->dst != req->src)
+			dst = scatterwalk_ffwd(sg_dst, req->dst, req->cryptlen);
 
-	skcipher_request_set_crypt(req, src, dst, AES_BLOCK_SIZE + tail,
-				   req->iv);
+		skcipher_request_set_crypt(req, src, dst, AES_BLOCK_SIZE + tail,
+					   req->iv);
 
-	err = skcipher_walk_virt(&walk, &subreq, false);
-	if (err)
-		return err;
+		err = skcipher_walk_virt(&walk, &subreq, false);
+		if (err)
+			return err;
 
-	scoped_ksimd()
 		aes_xts_encrypt(walk.dst.virt.addr, walk.src.virt.addr,
 				ctx->key1.key_enc, rounds, walk.nbytes,
 				ctx->key2.key_enc, walk.iv, first);
-
+	}
 	return skcipher_walk_done(&walk, 0);
 }
 
@@ -619,39 +618,37 @@ static int __maybe_unused xts_decrypt(struct skcipher_request *req)
 		tail = 0;
 	}
 
-	for (first = 1; walk.nbytes >= AES_BLOCK_SIZE; first = 0) {
-		int nbytes = walk.nbytes;
+	scoped_ksimd() {
+		for (first = 1; walk.nbytes >= AES_BLOCK_SIZE; first = 0) {
+			int nbytes = walk.nbytes;
 
-		if (walk.nbytes < walk.total)
-			nbytes &= ~(AES_BLOCK_SIZE - 1);
+			if (walk.nbytes < walk.total)
+				nbytes &= ~(AES_BLOCK_SIZE - 1);
 
-		scoped_ksimd()
 			aes_xts_decrypt(walk.dst.virt.addr, walk.src.virt.addr,
 					ctx->key1.key_dec, rounds, nbytes,
 					ctx->key2.key_enc, walk.iv, first);
-		err = skcipher_walk_done(&walk, walk.nbytes - nbytes);
-	}
+			err = skcipher_walk_done(&walk, walk.nbytes - nbytes);
+		}
 
-	if (err || likely(!tail))
-		return err;
-
-	dst = src = scatterwalk_ffwd(sg_src, req->src, req->cryptlen);
-	if (req->dst != req->src)
-		dst = scatterwalk_ffwd(sg_dst, req->dst, req->cryptlen);
+		if (err || likely(!tail))
+			return err;
 
-	skcipher_request_set_crypt(req, src, dst, AES_BLOCK_SIZE + tail,
-				   req->iv);
+		dst = src = scatterwalk_ffwd(sg_src, req->src, req->cryptlen);
+		if (req->dst != req->src)
+			dst = scatterwalk_ffwd(sg_dst, req->dst, req->cryptlen);
 
-	err = skcipher_walk_virt(&walk, &subreq, false);
-	if (err)
-		return err;
+		skcipher_request_set_crypt(req, src, dst, AES_BLOCK_SIZE + tail,
+					   req->iv);
 
+		err = skcipher_walk_virt(&walk, &subreq, false);
+		if (err)
+			return err;
 
-	scoped_ksimd()
 		aes_xts_decrypt(walk.dst.virt.addr, walk.src.virt.addr,
 				ctx->key1.key_dec, rounds, walk.nbytes,
 				ctx->key2.key_enc, walk.iv, first);
-
+	}
 	return skcipher_walk_done(&walk, 0);
 }
 
diff --git a/arch/arm64/crypto/aes-neonbs-glue.c b/arch/arm64/crypto/aes-neonbs-glue.c
index d496effb0a5b..cb87c8fc66b3 100644
--- a/arch/arm64/crypto/aes-neonbs-glue.c
+++ b/arch/arm64/crypto/aes-neonbs-glue.c
@@ -312,13 +312,13 @@ static int __xts_crypt(struct skcipher_request *req, bool encrypt,
 	if (err)
 		return err;
 
-	while (walk.nbytes >= AES_BLOCK_SIZE) {
-		int blocks = (walk.nbytes / AES_BLOCK_SIZE) & ~7;
-		out = walk.dst.virt.addr;
-		in = walk.src.virt.addr;
-		nbytes = walk.nbytes;
+	scoped_ksimd() {
+		while (walk.nbytes >= AES_BLOCK_SIZE) {
+			int blocks = (walk.nbytes / AES_BLOCK_SIZE) & ~7;
+			out = walk.dst.virt.addr;
+			in = walk.src.virt.addr;
+			nbytes = walk.nbytes;
 
-		scoped_ksimd() {
 			if (blocks >= 8) {
 				if (first == 1)
 					neon_aes_ecb_encrypt(walk.iv, walk.iv,
@@ -344,30 +344,28 @@ static int __xts_crypt(struct skcipher_request *req, bool encrypt,
 							     ctx->twkey, walk.iv, first);
 				nbytes = first = 0;
 			}
+			err = skcipher_walk_done(&walk, nbytes);
 		}
-		err = skcipher_walk_done(&walk, nbytes);
-	}
 
-	if (err || likely(!tail))
-		return err;
+		if (err || likely(!tail))
+			return err;
 
-	/* handle ciphertext stealing */
-	dst = src = scatterwalk_ffwd(sg_src, req->src, req->cryptlen);
-	if (req->dst != req->src)
-		dst = scatterwalk_ffwd(sg_dst, req->dst, req->cryptlen);
+		/* handle ciphertext stealing */
+		dst = src = scatterwalk_ffwd(sg_src, req->src, req->cryptlen);
+		if (req->dst != req->src)
+			dst = scatterwalk_ffwd(sg_dst, req->dst, req->cryptlen);
 
-	skcipher_request_set_crypt(req, src, dst, AES_BLOCK_SIZE + tail,
-				   req->iv);
+		skcipher_request_set_crypt(req, src, dst, AES_BLOCK_SIZE + tail,
+					   req->iv);
 
-	err = skcipher_walk_virt(&walk, req, false);
-	if (err)
-		return err;
+		err = skcipher_walk_virt(&walk, req, false);
+		if (err)
+			return err;
 
-	out = walk.dst.virt.addr;
-	in = walk.src.virt.addr;
-	nbytes = walk.nbytes;
+		out = walk.dst.virt.addr;
+		in = walk.src.virt.addr;
+		nbytes = walk.nbytes;
 
-	scoped_ksimd() {
 		if (encrypt)
 			neon_aes_xts_encrypt(out, in, ctx->cts.key_enc,
 					     ctx->key.rounds, nbytes, ctx->twkey,
-- 
2.47.3

