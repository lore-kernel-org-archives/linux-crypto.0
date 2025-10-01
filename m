Received: from mail-wm1-f73.google.com (mail-wm1-f73.google.com [209.85.128.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EE083313281
	for <linux-crypto@vger.kernel.org>; Wed,  1 Oct 2025 21:04:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.73
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1759352656; cv=none; b=j9PKKR303ZZ1YRDKkBT4PiYJ+/0LclTY9kIXMg5NrGfE51u7nAw/NzUDGeqxC/T4ZesQCJOlKi3+ga+OeuI5yGWG5TkKlzi1zi784rAI1+7ZaM3ScFCWQuXaNrzq277pFDeDybObGlHRgTumgSw6Di2qD/yMoAyVxqFCdnDGAS0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1759352656; c=relaxed/simple;
	bh=hzhBBv9qXLsX+gw2P3VFedRwF4INabNGQFsYtmOGp48=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=XjNh8yHPOMOrwjeybAnffa67XosDZG64iOtVc4z40bDP7QZhmD9tvIVEGtSUeT9fGNyghan4AxQO9O+FXlcuhsoHPTlskfxvoDM3KslGqJgqjNtTw9P0d+s+i/GuEiy/fUJbbhBmwIYSbthBUr9JTa9CUPehrfRuBqLD6Nonoy4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--ardb.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=P/dUx+i4; arc=none smtp.client-ip=209.85.128.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--ardb.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="P/dUx+i4"
Received: by mail-wm1-f73.google.com with SMTP id 5b1f17b1804b1-46e407c600eso1058845e9.3
        for <linux-crypto@vger.kernel.org>; Wed, 01 Oct 2025 14:04:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1759352652; x=1759957452; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=g+tkM5nzc98sysnyWW7NQQhabfH4eEjn64FzXa1tBKM=;
        b=P/dUx+i4C+XI8H1y4jWPTpXSwtOtKTdfFnxgzi9wrMTW/c1RVSom0l+yK1+1aEJaDE
         z3D4kp2QdwIvbuQ40cydlTX0v+htEzMPRLQQqVVCELMYFwp53HdJ4S1B8P5U4IwANLvj
         X1j49SMdLXQdGCYEUU6QBVBktz8Wn1p3KNVdmCuE/lb6GrkezQq2g2wTyqfLAwwGh9TR
         nWwJb795/+CEStZFKzpgy6u7nFQ40Lo8xEwSpBj2Yms4A2Loc5lBJVLFQ5xV31Xg9j+K
         3ipX3M+/Lak7/Rv/g24V56D1VzquxBla+yWBgro/E1eckVSRAsxDE9CqLn8tlbmNasUX
         0XZg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1759352652; x=1759957452;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=g+tkM5nzc98sysnyWW7NQQhabfH4eEjn64FzXa1tBKM=;
        b=bMQL5k2oRg0V5IglWFIFfc1UkcEiUfOozQ5z6mzyqZVosxBVHLJsioLESUjmn22QZW
         L9uMpnJve9HvjZ0JFzIvQJxVuuXZLGx0jUR82j0hrff9Gv7tnDQ5gDHAcNz7KZe/9EzD
         +9USQBrPPs6qPfGpsAxA3u+5P3eKkScupw7murWF8lI6TTYAdkLgzb8JH+L8jhIMuuZ+
         J2JT1v3VQmNllr1d06979rIwCRTKdkejK62YSt9f77xwpOf6EsuZGk96AeSfZLc0Lrtr
         ns8NSwyfEVB/xQm3+Yg+zBez+SNq3F93gNI3EGB2HIeDregXgqOtwsZ1S1MmUkLBVtV4
         moUg==
X-Gm-Message-State: AOJu0YzSRJ5DaXZG/E1zsSKiPjrWw7m+tc2oNUlc0XRYoKtvwccRX+Fi
	pu3Hh36T28gpQQWlZ4CWqsvK2+/7QKd4NEY1SkA3HXq/TJcELptvvKk/3xn18Od55BoNFznQ7Q=
	=
X-Google-Smtp-Source: AGHT+IGTbbGeB8Bf6LaYapNslqa0R16CPpjdm36/ci/sQr8CoJzBEl3ACSEhyCvHpEHmBBJvgnVs4JCM
X-Received: from wmbjt22.prod.google.com ([2002:a05:600c:5696:b0:46c:f222:92c9])
 (user=ardb job=prod-delivery.src-stubby-dispatcher) by 2002:a05:600c:3553:b0:46e:4b42:1dbe
 with SMTP id 5b1f17b1804b1-46e612de2eamr35990695e9.32.1759352652363; Wed, 01
 Oct 2025 14:04:12 -0700 (PDT)
Date: Wed,  1 Oct 2025 23:02:20 +0200
In-Reply-To: <20251001210201.838686-22-ardb+git@google.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20251001210201.838686-22-ardb+git@google.com>
X-Developer-Key: i=ardb@kernel.org; a=openpgp; fpr=F43D03328115A198C90016883D200E9CA6329909
X-Developer-Signature: v=1; a=openpgp-sha256; l=18083; i=ardb@kernel.org;
 h=from:subject; bh=OgGwE/LQY2w0L4dIZqEdIxr7D0ntO12+gElnEA3Y3HQ=;
 b=owGbwMvMwCVmkMcZplerG8N4Wi2JIePudNGgTOZFWiUGG2Z/P3Y+Pd/jc5v99Nt67KqxEv8cW
 FVfXuvsKGVhEONikBVTZBGY/ffdztMTpWqdZ8nCzGFlAhnCwMUpABO5Gcnwz2iC9/LvNlPuflkQ
 7RfebliozVPDX7tH31ZQp+POzCctnxkZ/oVtvSzF+urWht+/Bb+fCOGbe/11doTZijLHr58T7Yz WMwIA
X-Mailer: git-send-email 2.51.0.618.g983fd99d29-goog
Message-ID: <20251001210201.838686-40-ardb+git@google.com>
Subject: [PATCH v2 18/20] crypto/arm64: sm4 - Switch to 'ksimd' scoped guard API
From: Ard Biesheuvel <ardb+git@google.com>
To: linux-arm-kernel@lists.infradead.org
Cc: linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org, 
	herbert@gondor.apana.org.au, linux@armlinux.org.uk, 
	Ard Biesheuvel <ardb@kernel.org>, Marc Zyngier <maz@kernel.org>, Will Deacon <will@kernel.org>, 
	Mark Rutland <mark.rutland@arm.com>, Kees Cook <keescook@chromium.org>, 
	Catalin Marinas <catalin.marinas@arm.com>, Mark Brown <broonie@kernel.org>, 
	Eric Biggers <ebiggers@kernel.org>
Content-Type: text/plain; charset="UTF-8"

From: Ard Biesheuvel <ardb@kernel.org>

Signed-off-by: Ard Biesheuvel <ardb@kernel.org>
---
 arch/arm64/crypto/sm4-ce-ccm-glue.c    |  49 +++--
 arch/arm64/crypto/sm4-ce-cipher-glue.c |  10 +-
 arch/arm64/crypto/sm4-ce-gcm-glue.c    |  61 +++---
 arch/arm64/crypto/sm4-ce-glue.c        | 214 +++++++++-----------
 arch/arm64/crypto/sm4-neon-glue.c      |  25 +--
 5 files changed, 158 insertions(+), 201 deletions(-)

diff --git a/arch/arm64/crypto/sm4-ce-ccm-glue.c b/arch/arm64/crypto/sm4-ce-ccm-glue.c
index f9771ab2a05f..390facf909a0 100644
--- a/arch/arm64/crypto/sm4-ce-ccm-glue.c
+++ b/arch/arm64/crypto/sm4-ce-ccm-glue.c
@@ -11,7 +11,7 @@
 #include <linux/crypto.h>
 #include <linux/kernel.h>
 #include <linux/cpufeature.h>
-#include <asm/neon.h>
+#include <asm/simd.h>
 #include <crypto/scatterwalk.h>
 #include <crypto/internal/aead.h>
 #include <crypto/internal/skcipher.h>
@@ -35,10 +35,9 @@ static int ccm_setkey(struct crypto_aead *tfm, const u8 *key,
 	if (key_len != SM4_KEY_SIZE)
 		return -EINVAL;
 
-	kernel_neon_begin();
-	sm4_ce_expand_key(key, ctx->rkey_enc, ctx->rkey_dec,
-			  crypto_sm4_fk, crypto_sm4_ck);
-	kernel_neon_end();
+	scoped_ksimd()
+		sm4_ce_expand_key(key, ctx->rkey_enc, ctx->rkey_dec,
+				  crypto_sm4_fk, crypto_sm4_ck);
 
 	return 0;
 }
@@ -167,35 +166,33 @@ static int ccm_crypt(struct aead_request *req, struct skcipher_walk *walk,
 	memcpy(ctr0, walk->iv, SM4_BLOCK_SIZE);
 	crypto_inc(walk->iv, SM4_BLOCK_SIZE);
 
-	kernel_neon_begin();
+	scoped_ksimd() {
+		if (req->assoclen)
+			ccm_calculate_auth_mac(req, mac);
 
-	if (req->assoclen)
-		ccm_calculate_auth_mac(req, mac);
-
-	while (walk->nbytes && walk->nbytes != walk->total) {
-		unsigned int tail = walk->nbytes % SM4_BLOCK_SIZE;
+		while (walk->nbytes && walk->nbytes != walk->total) {
+			unsigned int tail = walk->nbytes % SM4_BLOCK_SIZE;
 
-		sm4_ce_ccm_crypt(rkey_enc, walk->dst.virt.addr,
-				 walk->src.virt.addr, walk->iv,
-				 walk->nbytes - tail, mac);
+			sm4_ce_ccm_crypt(rkey_enc, walk->dst.virt.addr,
+					 walk->src.virt.addr, walk->iv,
+					 walk->nbytes - tail, mac);
 
-		err = skcipher_walk_done(walk, tail);
-	}
+			err = skcipher_walk_done(walk, tail);
+		}
 
-	if (walk->nbytes) {
-		sm4_ce_ccm_crypt(rkey_enc, walk->dst.virt.addr,
-				 walk->src.virt.addr, walk->iv,
-				 walk->nbytes, mac);
+		if (walk->nbytes) {
+			sm4_ce_ccm_crypt(rkey_enc, walk->dst.virt.addr,
+					 walk->src.virt.addr, walk->iv,
+					 walk->nbytes, mac);
 
-		sm4_ce_ccm_final(rkey_enc, ctr0, mac);
+			sm4_ce_ccm_final(rkey_enc, ctr0, mac);
 
-		err = skcipher_walk_done(walk, 0);
-	} else {
-		sm4_ce_ccm_final(rkey_enc, ctr0, mac);
+			err = skcipher_walk_done(walk, 0);
+		} else {
+			sm4_ce_ccm_final(rkey_enc, ctr0, mac);
+		}
 	}
 
-	kernel_neon_end();
-
 	return err;
 }
 
diff --git a/arch/arm64/crypto/sm4-ce-cipher-glue.c b/arch/arm64/crypto/sm4-ce-cipher-glue.c
index c31d76fb5a17..bceec833ef4e 100644
--- a/arch/arm64/crypto/sm4-ce-cipher-glue.c
+++ b/arch/arm64/crypto/sm4-ce-cipher-glue.c
@@ -32,9 +32,8 @@ static void sm4_ce_encrypt(struct crypto_tfm *tfm, u8 *out, const u8 *in)
 	if (!crypto_simd_usable()) {
 		sm4_crypt_block(ctx->rkey_enc, out, in);
 	} else {
-		kernel_neon_begin();
-		sm4_ce_do_crypt(ctx->rkey_enc, out, in);
-		kernel_neon_end();
+		scoped_ksimd()
+			sm4_ce_do_crypt(ctx->rkey_enc, out, in);
 	}
 }
 
@@ -45,9 +44,8 @@ static void sm4_ce_decrypt(struct crypto_tfm *tfm, u8 *out, const u8 *in)
 	if (!crypto_simd_usable()) {
 		sm4_crypt_block(ctx->rkey_dec, out, in);
 	} else {
-		kernel_neon_begin();
-		sm4_ce_do_crypt(ctx->rkey_dec, out, in);
-		kernel_neon_end();
+		scoped_ksimd()
+			sm4_ce_do_crypt(ctx->rkey_dec, out, in);
 	}
 }
 
diff --git a/arch/arm64/crypto/sm4-ce-gcm-glue.c b/arch/arm64/crypto/sm4-ce-gcm-glue.c
index 170cd0151385..32a6ab669281 100644
--- a/arch/arm64/crypto/sm4-ce-gcm-glue.c
+++ b/arch/arm64/crypto/sm4-ce-gcm-glue.c
@@ -11,7 +11,7 @@
 #include <linux/crypto.h>
 #include <linux/kernel.h>
 #include <linux/cpufeature.h>
-#include <asm/neon.h>
+#include <asm/simd.h>
 #include <crypto/b128ops.h>
 #include <crypto/scatterwalk.h>
 #include <crypto/internal/aead.h>
@@ -48,13 +48,11 @@ static int gcm_setkey(struct crypto_aead *tfm, const u8 *key,
 	if (key_len != SM4_KEY_SIZE)
 		return -EINVAL;
 
-	kernel_neon_begin();
-
-	sm4_ce_expand_key(key, ctx->key.rkey_enc, ctx->key.rkey_dec,
-			  crypto_sm4_fk, crypto_sm4_ck);
-	sm4_ce_pmull_ghash_setup(ctx->key.rkey_enc, ctx->ghash_table);
-
-	kernel_neon_end();
+	scoped_ksimd() {
+		sm4_ce_expand_key(key, ctx->key.rkey_enc, ctx->key.rkey_dec,
+				crypto_sm4_fk, crypto_sm4_ck);
+		sm4_ce_pmull_ghash_setup(ctx->key.rkey_enc, ctx->ghash_table);
+	}
 	return 0;
 }
 
@@ -149,40 +147,35 @@ static int gcm_crypt(struct aead_request *req, struct skcipher_walk *walk,
 	memcpy(iv, req->iv, GCM_IV_SIZE);
 	put_unaligned_be32(2, iv + GCM_IV_SIZE);
 
-	kernel_neon_begin();
+	scoped_ksimd() {
+		if (req->assoclen)
+			gcm_calculate_auth_mac(req, ghash);
 
-	if (req->assoclen)
-		gcm_calculate_auth_mac(req, ghash);
+		while (walk->nbytes) {
+			unsigned int tail = walk->nbytes % SM4_BLOCK_SIZE;
+			const u8 *src = walk->src.virt.addr;
+			u8 *dst = walk->dst.virt.addr;
 
-	while (walk->nbytes) {
-		unsigned int tail = walk->nbytes % SM4_BLOCK_SIZE;
-		const u8 *src = walk->src.virt.addr;
-		u8 *dst = walk->dst.virt.addr;
+			if (walk->nbytes == walk->total) {
+				sm4_ce_pmull_gcm_crypt(ctx->key.rkey_enc, dst, src, iv,
+						       walk->nbytes, ghash,
+						       ctx->ghash_table,
+						       (const u8 *)&lengths);
+
+				return skcipher_walk_done(walk, 0);
+			}
 
-		if (walk->nbytes == walk->total) {
 			sm4_ce_pmull_gcm_crypt(ctx->key.rkey_enc, dst, src, iv,
-					       walk->nbytes, ghash,
-					       ctx->ghash_table,
-					       (const u8 *)&lengths);
+					       walk->nbytes - tail, ghash,
+					       ctx->ghash_table, NULL);
 
-			err = skcipher_walk_done(walk, 0);
-			goto out;
+			err = skcipher_walk_done(walk, tail);
 		}
 
-		sm4_ce_pmull_gcm_crypt(ctx->key.rkey_enc, dst, src, iv,
-				       walk->nbytes - tail, ghash,
-				       ctx->ghash_table, NULL);
-
-		err = skcipher_walk_done(walk, tail);
+		sm4_ce_pmull_gcm_crypt(ctx->key.rkey_enc, NULL, NULL, iv,
+				       walk->nbytes, ghash, ctx->ghash_table,
+				       (const u8 *)&lengths);
 	}
-
-	sm4_ce_pmull_gcm_crypt(ctx->key.rkey_enc, NULL, NULL, iv,
-			       walk->nbytes, ghash, ctx->ghash_table,
-			       (const u8 *)&lengths);
-
-out:
-	kernel_neon_end();
-
 	return err;
 }
 
diff --git a/arch/arm64/crypto/sm4-ce-glue.c b/arch/arm64/crypto/sm4-ce-glue.c
index 7a60e7b559dc..57ae3406257c 100644
--- a/arch/arm64/crypto/sm4-ce-glue.c
+++ b/arch/arm64/crypto/sm4-ce-glue.c
@@ -8,7 +8,7 @@
  * Copyright (C) 2022 Tianjia Zhang <tianjia.zhang@linux.alibaba.com>
  */
 
-#include <asm/neon.h>
+#include <asm/simd.h>
 #include <crypto/b128ops.h>
 #include <crypto/internal/hash.h>
 #include <crypto/internal/skcipher.h>
@@ -74,10 +74,9 @@ static int sm4_setkey(struct crypto_skcipher *tfm, const u8 *key,
 	if (key_len != SM4_KEY_SIZE)
 		return -EINVAL;
 
-	kernel_neon_begin();
-	sm4_ce_expand_key(key, ctx->rkey_enc, ctx->rkey_dec,
-			  crypto_sm4_fk, crypto_sm4_ck);
-	kernel_neon_end();
+	scoped_ksimd()
+		sm4_ce_expand_key(key, ctx->rkey_enc, ctx->rkey_dec,
+				crypto_sm4_fk, crypto_sm4_ck);
 	return 0;
 }
 
@@ -94,12 +93,12 @@ static int sm4_xts_setkey(struct crypto_skcipher *tfm, const u8 *key,
 	if (ret)
 		return ret;
 
-	kernel_neon_begin();
-	sm4_ce_expand_key(key, ctx->key1.rkey_enc,
-			  ctx->key1.rkey_dec, crypto_sm4_fk, crypto_sm4_ck);
-	sm4_ce_expand_key(&key[SM4_KEY_SIZE], ctx->key2.rkey_enc,
-			  ctx->key2.rkey_dec, crypto_sm4_fk, crypto_sm4_ck);
-	kernel_neon_end();
+	scoped_ksimd() {
+		sm4_ce_expand_key(key, ctx->key1.rkey_enc,
+				ctx->key1.rkey_dec, crypto_sm4_fk, crypto_sm4_ck);
+		sm4_ce_expand_key(&key[SM4_KEY_SIZE], ctx->key2.rkey_enc,
+				ctx->key2.rkey_dec, crypto_sm4_fk, crypto_sm4_ck);
+	}
 
 	return 0;
 }
@@ -117,16 +116,14 @@ static int sm4_ecb_do_crypt(struct skcipher_request *req, const u32 *rkey)
 		u8 *dst = walk.dst.virt.addr;
 		unsigned int nblks;
 
-		kernel_neon_begin();
-
-		nblks = BYTES2BLKS(nbytes);
-		if (nblks) {
-			sm4_ce_crypt(rkey, dst, src, nblks);
-			nbytes -= nblks * SM4_BLOCK_SIZE;
+		scoped_ksimd() {
+			nblks = BYTES2BLKS(nbytes);
+			if (nblks) {
+				sm4_ce_crypt(rkey, dst, src, nblks);
+				nbytes -= nblks * SM4_BLOCK_SIZE;
+			}
 		}
 
-		kernel_neon_end();
-
 		err = skcipher_walk_done(&walk, nbytes);
 	}
 
@@ -167,16 +164,14 @@ static int sm4_cbc_crypt(struct skcipher_request *req,
 
 		nblocks = nbytes / SM4_BLOCK_SIZE;
 		if (nblocks) {
-			kernel_neon_begin();
-
-			if (encrypt)
-				sm4_ce_cbc_enc(ctx->rkey_enc, dst, src,
-					       walk.iv, nblocks);
-			else
-				sm4_ce_cbc_dec(ctx->rkey_dec, dst, src,
-					       walk.iv, nblocks);
-
-			kernel_neon_end();
+			scoped_ksimd() {
+				if (encrypt)
+					sm4_ce_cbc_enc(ctx->rkey_enc, dst, src,
+						       walk.iv, nblocks);
+				else
+					sm4_ce_cbc_dec(ctx->rkey_dec, dst, src,
+						       walk.iv, nblocks);
+			}
 		}
 
 		err = skcipher_walk_done(&walk, nbytes % SM4_BLOCK_SIZE);
@@ -249,16 +244,14 @@ static int sm4_cbc_cts_crypt(struct skcipher_request *req, bool encrypt)
 	if (err)
 		return err;
 
-	kernel_neon_begin();
-
-	if (encrypt)
-		sm4_ce_cbc_cts_enc(ctx->rkey_enc, walk.dst.virt.addr,
-				   walk.src.virt.addr, walk.iv, walk.nbytes);
-	else
-		sm4_ce_cbc_cts_dec(ctx->rkey_dec, walk.dst.virt.addr,
-				   walk.src.virt.addr, walk.iv, walk.nbytes);
-
-	kernel_neon_end();
+	scoped_ksimd() {
+		if (encrypt)
+			sm4_ce_cbc_cts_enc(ctx->rkey_enc, walk.dst.virt.addr,
+					   walk.src.virt.addr, walk.iv, walk.nbytes);
+		else
+			sm4_ce_cbc_cts_dec(ctx->rkey_dec, walk.dst.virt.addr,
+					   walk.src.virt.addr, walk.iv, walk.nbytes);
+	}
 
 	return skcipher_walk_done(&walk, 0);
 }
@@ -288,28 +281,26 @@ static int sm4_ctr_crypt(struct skcipher_request *req)
 		u8 *dst = walk.dst.virt.addr;
 		unsigned int nblks;
 
-		kernel_neon_begin();
-
-		nblks = BYTES2BLKS(nbytes);
-		if (nblks) {
-			sm4_ce_ctr_enc(ctx->rkey_enc, dst, src, walk.iv, nblks);
-			dst += nblks * SM4_BLOCK_SIZE;
-			src += nblks * SM4_BLOCK_SIZE;
-			nbytes -= nblks * SM4_BLOCK_SIZE;
-		}
-
-		/* tail */
-		if (walk.nbytes == walk.total && nbytes > 0) {
-			u8 keystream[SM4_BLOCK_SIZE];
-
-			sm4_ce_crypt_block(ctx->rkey_enc, keystream, walk.iv);
-			crypto_inc(walk.iv, SM4_BLOCK_SIZE);
-			crypto_xor_cpy(dst, src, keystream, nbytes);
-			nbytes = 0;
+		scoped_ksimd() {
+			nblks = BYTES2BLKS(nbytes);
+			if (nblks) {
+				sm4_ce_ctr_enc(ctx->rkey_enc, dst, src, walk.iv, nblks);
+				dst += nblks * SM4_BLOCK_SIZE;
+				src += nblks * SM4_BLOCK_SIZE;
+				nbytes -= nblks * SM4_BLOCK_SIZE;
+			}
+
+			/* tail */
+			if (walk.nbytes == walk.total && nbytes > 0) {
+				u8 keystream[SM4_BLOCK_SIZE];
+
+				sm4_ce_crypt_block(ctx->rkey_enc, keystream, walk.iv);
+				crypto_inc(walk.iv, SM4_BLOCK_SIZE);
+				crypto_xor_cpy(dst, src, keystream, nbytes);
+				nbytes = 0;
+			}
 		}
 
-		kernel_neon_end();
-
 		err = skcipher_walk_done(&walk, nbytes);
 	}
 
@@ -359,18 +350,16 @@ static int sm4_xts_crypt(struct skcipher_request *req, bool encrypt)
 		if (nbytes < walk.total)
 			nbytes &= ~(SM4_BLOCK_SIZE - 1);
 
-		kernel_neon_begin();
-
-		if (encrypt)
-			sm4_ce_xts_enc(ctx->key1.rkey_enc, walk.dst.virt.addr,
-				       walk.src.virt.addr, walk.iv, nbytes,
-				       rkey2_enc);
-		else
-			sm4_ce_xts_dec(ctx->key1.rkey_dec, walk.dst.virt.addr,
-				       walk.src.virt.addr, walk.iv, nbytes,
-				       rkey2_enc);
-
-		kernel_neon_end();
+		scoped_ksimd() {
+			if (encrypt)
+				sm4_ce_xts_enc(ctx->key1.rkey_enc, walk.dst.virt.addr,
+						walk.src.virt.addr, walk.iv, nbytes,
+						rkey2_enc);
+			else
+				sm4_ce_xts_dec(ctx->key1.rkey_dec, walk.dst.virt.addr,
+						walk.src.virt.addr, walk.iv, nbytes,
+						rkey2_enc);
+		}
 
 		rkey2_enc = NULL;
 
@@ -395,18 +384,16 @@ static int sm4_xts_crypt(struct skcipher_request *req, bool encrypt)
 	if (err)
 		return err;
 
-	kernel_neon_begin();
-
-	if (encrypt)
-		sm4_ce_xts_enc(ctx->key1.rkey_enc, walk.dst.virt.addr,
-			       walk.src.virt.addr, walk.iv, walk.nbytes,
-			       rkey2_enc);
-	else
-		sm4_ce_xts_dec(ctx->key1.rkey_dec, walk.dst.virt.addr,
-			       walk.src.virt.addr, walk.iv, walk.nbytes,
-			       rkey2_enc);
-
-	kernel_neon_end();
+	scoped_ksimd() {
+		if (encrypt)
+			sm4_ce_xts_enc(ctx->key1.rkey_enc, walk.dst.virt.addr,
+					walk.src.virt.addr, walk.iv, walk.nbytes,
+					rkey2_enc);
+		else
+			sm4_ce_xts_dec(ctx->key1.rkey_dec, walk.dst.virt.addr,
+					walk.src.virt.addr, walk.iv, walk.nbytes,
+					rkey2_enc);
+	}
 
 	return skcipher_walk_done(&walk, 0);
 }
@@ -510,11 +497,9 @@ static int sm4_cbcmac_setkey(struct crypto_shash *tfm, const u8 *key,
 	if (key_len != SM4_KEY_SIZE)
 		return -EINVAL;
 
-	kernel_neon_begin();
-	sm4_ce_expand_key(key, ctx->key.rkey_enc, ctx->key.rkey_dec,
-			  crypto_sm4_fk, crypto_sm4_ck);
-	kernel_neon_end();
-
+	scoped_ksimd()
+		sm4_ce_expand_key(key, ctx->key.rkey_enc, ctx->key.rkey_dec,
+				crypto_sm4_fk, crypto_sm4_ck);
 	return 0;
 }
 
@@ -530,15 +515,13 @@ static int sm4_cmac_setkey(struct crypto_shash *tfm, const u8 *key,
 
 	memset(consts, 0, SM4_BLOCK_SIZE);
 
-	kernel_neon_begin();
-
-	sm4_ce_expand_key(key, ctx->key.rkey_enc, ctx->key.rkey_dec,
-			  crypto_sm4_fk, crypto_sm4_ck);
+	scoped_ksimd() {
+		sm4_ce_expand_key(key, ctx->key.rkey_enc, ctx->key.rkey_dec,
+				crypto_sm4_fk, crypto_sm4_ck);
 
-	/* encrypt the zero block */
-	sm4_ce_crypt_block(ctx->key.rkey_enc, (u8 *)consts, (const u8 *)consts);
-
-	kernel_neon_end();
+		/* encrypt the zero block */
+		sm4_ce_crypt_block(ctx->key.rkey_enc, (u8 *)consts, (const u8 *)consts);
+	}
 
 	/* gf(2^128) multiply zero-ciphertext with u and u^2 */
 	a = be64_to_cpu(consts[0].a);
@@ -568,18 +551,16 @@ static int sm4_xcbc_setkey(struct crypto_shash *tfm, const u8 *key,
 	if (key_len != SM4_KEY_SIZE)
 		return -EINVAL;
 
-	kernel_neon_begin();
-
-	sm4_ce_expand_key(key, ctx->key.rkey_enc, ctx->key.rkey_dec,
-			  crypto_sm4_fk, crypto_sm4_ck);
+	scoped_ksimd() {
+		sm4_ce_expand_key(key, ctx->key.rkey_enc, ctx->key.rkey_dec,
+				crypto_sm4_fk, crypto_sm4_ck);
 
-	sm4_ce_crypt_block(ctx->key.rkey_enc, key2, ks[0]);
-	sm4_ce_crypt(ctx->key.rkey_enc, ctx->consts, ks[1], 2);
+		sm4_ce_crypt_block(ctx->key.rkey_enc, key2, ks[0]);
+		sm4_ce_crypt(ctx->key.rkey_enc, ctx->consts, ks[1], 2);
 
-	sm4_ce_expand_key(key2, ctx->key.rkey_enc, ctx->key.rkey_dec,
-			  crypto_sm4_fk, crypto_sm4_ck);
-
-	kernel_neon_end();
+		sm4_ce_expand_key(key2, ctx->key.rkey_enc, ctx->key.rkey_dec,
+				crypto_sm4_fk, crypto_sm4_ck);
+	}
 
 	return 0;
 }
@@ -600,10 +581,9 @@ static int sm4_mac_update(struct shash_desc *desc, const u8 *p,
 	unsigned int nblocks = len / SM4_BLOCK_SIZE;
 
 	len %= SM4_BLOCK_SIZE;
-	kernel_neon_begin();
-	sm4_ce_mac_update(tctx->key.rkey_enc, ctx->digest, p,
-			  nblocks, false, true);
-	kernel_neon_end();
+	scoped_ksimd()
+		sm4_ce_mac_update(tctx->key.rkey_enc, ctx->digest, p,
+				nblocks, false, true);
 	return len;
 }
 
@@ -619,10 +599,9 @@ static int sm4_cmac_finup(struct shash_desc *desc, const u8 *src,
 		ctx->digest[len] ^= 0x80;
 		consts += SM4_BLOCK_SIZE;
 	}
-	kernel_neon_begin();
-	sm4_ce_mac_update(tctx->key.rkey_enc, ctx->digest, consts, 1,
-			  false, true);
-	kernel_neon_end();
+	scoped_ksimd()
+		sm4_ce_mac_update(tctx->key.rkey_enc, ctx->digest, consts, 1,
+				  false, true);
 	memcpy(out, ctx->digest, SM4_BLOCK_SIZE);
 	return 0;
 }
@@ -635,10 +614,9 @@ static int sm4_cbcmac_finup(struct shash_desc *desc, const u8 *src,
 
 	if (len) {
 		crypto_xor(ctx->digest, src, len);
-		kernel_neon_begin();
-		sm4_ce_crypt_block(tctx->key.rkey_enc, ctx->digest,
-				   ctx->digest);
-		kernel_neon_end();
+		scoped_ksimd()
+			sm4_ce_crypt_block(tctx->key.rkey_enc, ctx->digest,
+					   ctx->digest);
 	}
 	memcpy(out, ctx->digest, SM4_BLOCK_SIZE);
 	return 0;
diff --git a/arch/arm64/crypto/sm4-neon-glue.c b/arch/arm64/crypto/sm4-neon-glue.c
index e3500aca2d18..e944c2a2efb0 100644
--- a/arch/arm64/crypto/sm4-neon-glue.c
+++ b/arch/arm64/crypto/sm4-neon-glue.c
@@ -48,11 +48,8 @@ static int sm4_ecb_do_crypt(struct skcipher_request *req, const u32 *rkey)
 
 		nblocks = nbytes / SM4_BLOCK_SIZE;
 		if (nblocks) {
-			kernel_neon_begin();
-
-			sm4_neon_crypt(rkey, dst, src, nblocks);
-
-			kernel_neon_end();
+			scoped_ksimd()
+				sm4_neon_crypt(rkey, dst, src, nblocks);
 		}
 
 		err = skcipher_walk_done(&walk, nbytes % SM4_BLOCK_SIZE);
@@ -126,12 +123,9 @@ static int sm4_cbc_decrypt(struct skcipher_request *req)
 
 		nblocks = nbytes / SM4_BLOCK_SIZE;
 		if (nblocks) {
-			kernel_neon_begin();
-
-			sm4_neon_cbc_dec(ctx->rkey_dec, dst, src,
-					 walk.iv, nblocks);
-
-			kernel_neon_end();
+			scoped_ksimd()
+				sm4_neon_cbc_dec(ctx->rkey_dec, dst, src,
+						 walk.iv, nblocks);
 		}
 
 		err = skcipher_walk_done(&walk, nbytes % SM4_BLOCK_SIZE);
@@ -157,12 +151,9 @@ static int sm4_ctr_crypt(struct skcipher_request *req)
 
 		nblocks = nbytes / SM4_BLOCK_SIZE;
 		if (nblocks) {
-			kernel_neon_begin();
-
-			sm4_neon_ctr_crypt(ctx->rkey_enc, dst, src,
-					   walk.iv, nblocks);
-
-			kernel_neon_end();
+			scoped_ksimd()
+				sm4_neon_ctr_crypt(ctx->rkey_enc, dst, src,
+						   walk.iv, nblocks);
 
 			dst += nblocks * SM4_BLOCK_SIZE;
 			src += nblocks * SM4_BLOCK_SIZE;
-- 
2.51.0.618.g983fd99d29-goog

