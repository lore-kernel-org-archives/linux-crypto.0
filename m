Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7CEB835C19B
	for <linux-crypto@vger.kernel.org>; Wed,  3 Dec 2025 16:38:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764779897; cv=none; b=aqt8nyu2aLkuoKNr5mgKHb0ez705BiDj1nPxNjXdgjgUAEMAPDmHT9GkSJusfpjifDglrd4ZzUf/jeWcxyNSYNREbImMsJbQEZO2oK8PyeHPg3T1FoXF1Yt+BVP5/egVJ4P2s+ePyjAFxmmpGJYi+UdvuE8BOaDtl5/S55CH7qs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764779897; c=relaxed/simple;
	bh=M/+8VYd6ZpFdCi7cFSzWiLIIh2NNULMpUe51rcgcCUg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=MFPiF5WvkE9nL9dcKnWWRBegdPdWImxbaWtMNmrLJZFxIfDYyNbnhlNp0tJdI4SNRidZAAPE6XMD6P0598A+fKwpXeIVhkWLozkaMlaLRS4dNPlbMLlSywCpYrt0UIlPB6Vn7a1cu0Y7LS8JEAI9FqpkYHfh+XDCpxWJ+NBADsY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=VHrED16c; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="VHrED16c"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4FB7BC116B1;
	Wed,  3 Dec 2025 16:38:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1764779897;
	bh=M/+8VYd6ZpFdCi7cFSzWiLIIh2NNULMpUe51rcgcCUg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=VHrED16cj1V44NQ0dakoQ5NC1HhXnPgejHaCK7xKQniSmyBO/j73cqniw47oShwVX
	 IPxilrFcRFp5esOTWXqugfQHQEfbPE058ja0lpsfQp7e7vdyPbqm1ivJI53ByaoGNy
	 m4jN7ypvaRQzapbvl1/ak6vyv+4H5my6GJvahJwktM1huIScYM1xMPFuX0PsBzfzWn
	 r8R+Vu5Ia8JwpMtpdJwD23mLcKLONoDx4SMLFTVDGTXGaHAHm0oS/F/4ASjqiqeNaj
	 u+LIVLbTx/uAJvLTCS/fFh6CeLykNxuzp6CNdxQHhNh1K3U3Yo1+BS6CHYdiJ6WXzk
	 CrEEt/B7oQzog==
From: Ard Biesheuvel <ardb@kernel.org>
To: linux-crypto@vger.kernel.org
Cc: Ard Biesheuvel <ardb@kernel.org>,
	Arnd Bergmann <arnd@arndb.de>,
	Eric Biggers <ebiggers@kernel.org>,
	Herbert Xu <herbert@gondor.apana.org.au>
Subject: [PATCH 2/2] crypto/arm64: sm4/xts: Merge ksimd scopes to reduce stack bloat
Date: Wed,  3 Dec 2025 17:38:06 +0100
Message-ID: <20251203163803.157541-6-ardb@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20251203163803.157541-4-ardb@kernel.org>
References: <20251203163803.157541-4-ardb@kernel.org>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=2549; i=ardb@kernel.org; h=from:subject; bh=M/+8VYd6ZpFdCi7cFSzWiLIIh2NNULMpUe51rcgcCUg=; b=owGbwMvMwCVmkMcZplerG8N4Wi2JIdMgPW9uuOgW3UxH96aE6tlZ4QvLhHnMTosoKBx4rmIY/ 5yxKbGjlIVBjItBVkyRRWD233c7T0+UqnWeJQszh5UJZAgDF6cATMTBjOGf+Q03W757x/+GcEqc aHrLedB9+f93YRkf2/LqUyLmFnx0Z2Ro+Oqlo3H4Q52U0fOP25YJOzjmhOakbvwVdrVf5FoD9wU mAA==
X-Developer-Key: i=ardb@kernel.org; a=openpgp; fpr=F43D03328115A198C90016883D200E9CA6329909
Content-Transfer-Encoding: 8bit

Merge the two ksimd scopes in the implementation of SM4-XTS to prevent
stack bloat in cases where the compiler fails to combine the stack slots
for the kernel mode FP/SIMD buffers.

Signed-off-by: Ard Biesheuvel <ardb@kernel.org>
---
 arch/arm64/crypto/sm4-ce-glue.c | 42 ++++++++++----------
 1 file changed, 20 insertions(+), 22 deletions(-)

diff --git a/arch/arm64/crypto/sm4-ce-glue.c b/arch/arm64/crypto/sm4-ce-glue.c
index 5569cece5a0b..0933ba45fbe7 100644
--- a/arch/arm64/crypto/sm4-ce-glue.c
+++ b/arch/arm64/crypto/sm4-ce-glue.c
@@ -346,11 +346,11 @@ static int sm4_xts_crypt(struct skcipher_request *req, bool encrypt)
 		tail = 0;
 	}
 
-	while ((nbytes = walk.nbytes) >= SM4_BLOCK_SIZE) {
-		if (nbytes < walk.total)
-			nbytes &= ~(SM4_BLOCK_SIZE - 1);
+	scoped_ksimd() {
+		while ((nbytes = walk.nbytes) >= SM4_BLOCK_SIZE) {
+			if (nbytes < walk.total)
+				nbytes &= ~(SM4_BLOCK_SIZE - 1);
 
-		scoped_ksimd() {
 			if (encrypt)
 				sm4_ce_xts_enc(ctx->key1.rkey_enc, walk.dst.virt.addr,
 						walk.src.virt.addr, walk.iv, nbytes,
@@ -359,32 +359,30 @@ static int sm4_xts_crypt(struct skcipher_request *req, bool encrypt)
 				sm4_ce_xts_dec(ctx->key1.rkey_dec, walk.dst.virt.addr,
 						walk.src.virt.addr, walk.iv, nbytes,
 						rkey2_enc);
-		}
 
-		rkey2_enc = NULL;
+			rkey2_enc = NULL;
 
-		err = skcipher_walk_done(&walk, walk.nbytes - nbytes);
-		if (err)
-			return err;
-	}
+			err = skcipher_walk_done(&walk, walk.nbytes - nbytes);
+			if (err)
+				return err;
+		}
 
-	if (likely(tail == 0))
-		return 0;
+		if (likely(tail == 0))
+			return 0;
 
-	/* handle ciphertext stealing */
+		/* handle ciphertext stealing */
 
-	dst = src = scatterwalk_ffwd(sg_src, req->src, subreq.cryptlen);
-	if (req->dst != req->src)
-		dst = scatterwalk_ffwd(sg_dst, req->dst, subreq.cryptlen);
+		dst = src = scatterwalk_ffwd(sg_src, req->src, subreq.cryptlen);
+		if (req->dst != req->src)
+			dst = scatterwalk_ffwd(sg_dst, req->dst, subreq.cryptlen);
 
-	skcipher_request_set_crypt(&subreq, src, dst, SM4_BLOCK_SIZE + tail,
-				   req->iv);
+		skcipher_request_set_crypt(&subreq, src, dst, SM4_BLOCK_SIZE + tail,
+					   req->iv);
 
-	err = skcipher_walk_virt(&walk, &subreq, false);
-	if (err)
-		return err;
+		err = skcipher_walk_virt(&walk, &subreq, false);
+		if (err)
+			return err;
 
-	scoped_ksimd() {
 		if (encrypt)
 			sm4_ce_xts_enc(ctx->key1.rkey_enc, walk.dst.virt.addr,
 					walk.src.virt.addr, walk.iv, walk.nbytes,
-- 
2.47.3

