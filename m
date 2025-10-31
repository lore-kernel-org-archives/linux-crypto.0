Received: from mail-wr1-f74.google.com (mail-wr1-f74.google.com [209.85.221.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 98554346FC4
	for <linux-crypto@vger.kernel.org>; Fri, 31 Oct 2025 10:40:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761907206; cv=none; b=VIf/VkIwQqKAWbaj4ltdScKEgxD7bE8L7KHxWZZ+kEsPdtCM3re1qCDGCWULNuYvv+/bWnRXonNaRHuyynla06QR2QyeP08w4AiMbHGofz6svXL5ghI6wnwuBEijY3w3a1kbu/3YBWHj0dkuYj3b5ZsBmlpWXX7mEnI7ArxzdiQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761907206; c=relaxed/simple;
	bh=L6keGmWhuHKNO+Dmu93z1gbDsfl8pX3Yp2RLDWDq9Y8=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=o5/Z9QtpuufmD0a9eKBgBzQTsWpLDtkPjQhjamVNCIdwLLsPV+rDh/2d4w66g93lWRBBtJMJo9cdBXlh/Bv6BEiHMu3xysdXpaKAnX6JFvj6fiaeJh+IB7GByz0AlvY1RfOCEVkcX32vM/krNQsnYo3XM4UEtNDC6Fl3ku4Kuew=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--ardb.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=4MAajkgP; arc=none smtp.client-ip=209.85.221.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--ardb.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="4MAajkgP"
Received: by mail-wr1-f74.google.com with SMTP id ffacd0b85a97d-429bd66fe65so743382f8f.0
        for <linux-crypto@vger.kernel.org>; Fri, 31 Oct 2025 03:40:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1761907202; x=1762512002; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=uPf4jH2Xq6YglmJt/Z/1H4uAG3AvOY53HgLQBHEzlps=;
        b=4MAajkgPegW8G7ldPwuNAvT81U7FBuWyd2HCinP8PncKlF+6au66Rjvz3lJUhiuZZe
         Bc6ww5xR6vZAB5kgJenOz/KQzrsfaUP8ongsIfeb3KDsQjgrZemkPH0USxJe+KJulU5r
         IIHXWnlrj7c31pKyr4p2DkphP//2QWfnuiLZ097r18RMip7Pw4f0fOQ3YX+3RavsRyYR
         yYl8e6jgJ8cG/XiDClFz6wH1OrDsltGAsD6mWVIVR3c30BW/Y8j5NYJMcuEibC0yG3rN
         3exSnw9uKRcbs/uuHnAzDk72S76dy0dEFToWSjibm/yn9GUM2XdXOS9B10lqAdVd6i1/
         uIWA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1761907202; x=1762512002;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=uPf4jH2Xq6YglmJt/Z/1H4uAG3AvOY53HgLQBHEzlps=;
        b=EaX5D00sNdXxg2fNZULcUfsh7SudoJXl9cTpIRT4bjHU+3ayPi5eBOQvTavemjyLPe
         2AomgL1o99vJWKxTxv7mmLCW9Jkg8unDxnaMdNWAuuU97tVJ3eZ3dJ8UknonovN4mJpa
         o1AN3NQjg3ZFBqUa/kXsw1lSbvehW8h9YOuNgemwuSnp0FgT7ZTuFeS69nC89R7ieoxN
         hvxwbi+RFAUgHmdxXhAJ5TG3rH5vQUAEKZyC2xxuTJQF/0L48Gbx7TBahuJ2/QmPcwyb
         cOm2zli3/RXzm0KoBX316mmGnP0HDp+cmVMDoTEUfqhiT7eEAQ5VwrxC4DR03hQO7MWD
         ArIw==
X-Forwarded-Encrypted: i=1; AJvYcCWiFVvjS9VDBZYYlwHTZJAHGGx9sPmh3BboJyN/NdOtaGn/WPmrigBo8VxNJpRBp8ameC0dsA8vYb+gEzs=@vger.kernel.org
X-Gm-Message-State: AOJu0YzNdXn3yzvA6roZptZEU9exMunEnijWEl5IFqMaRolEXSApl17/
	ttkSoHqkFEJayY+nwI6AMSc7b1fYHvmM9sqFlB6L2Ey6lFyyfj1MEodk/IOHWufMS+ZWzUNfHA=
	=
X-Google-Smtp-Source: AGHT+IHBWOfDUYQF0RJYz8tdd5VLz5W14AhZr9qm6OU728YrhW2RvtEkgtdUgRsapicAbOxJrTA/wCjg
X-Received: from wmcq27.prod.google.com ([2002:a05:600c:c11b:b0:46f:b32b:55f])
 (user=ardb job=prod-delivery.src-stubby-dispatcher) by 2002:a05:6000:430d:b0:3ea:e0fd:290a
 with SMTP id ffacd0b85a97d-429bd68322dmr2532065f8f.12.1761907202154; Fri, 31
 Oct 2025 03:40:02 -0700 (PDT)
Date: Fri, 31 Oct 2025 11:39:16 +0100
In-Reply-To: <20251031103858.529530-23-ardb+git@google.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20251031103858.529530-23-ardb+git@google.com>
X-Developer-Key: i=ardb@kernel.org; a=openpgp; fpr=F43D03328115A198C90016883D200E9CA6329909
X-Developer-Signature: v=1; a=openpgp-sha256; l=17484; i=ardb@kernel.org;
 h=from:subject; bh=ZhZahtwfNc9VdlqtoGJDsIW5NGC9QTCl2puzpufxwjY=;
 b=owGbwMvMwCVmkMcZplerG8N4Wi2JIZNl4u3XT5x0PzWdb+7d/Tb09vpLT49919h+/K62M1Op7
 8NKNafjHaUsDGJcDLJiiiwCs/++23l6olSt8yxZmDmsTCBDGLg4BWAiuUGMDHum7S8KXSUqPGHK
 nUdfDm9e0iLT48HaFDtvqpfm7mQOu30M/1SYmJuO33YsY5V0dVDfeT0j/9Gt1Zv0PhadSrn2V4r hEyMA
X-Mailer: git-send-email 2.51.1.930.gacf6e81ea2-goog
Message-ID: <20251031103858.529530-40-ardb+git@google.com>
Subject: [PATCH v4 17/21] crypto/arm64: sm4 - Switch to 'ksimd' scoped guard API
From: Ard Biesheuvel <ardb+git@google.com>
To: linux-arm-kernel@lists.infradead.org
Cc: linux-kernel@vger.kernel.org, linux-crypto@vger.kernel.org, 
	herbert@gondor.apana.org.au, ebiggers@kernel.org, 
	Ard Biesheuvel <ardb@kernel.org>
Content-Type: text/plain; charset="UTF-8"

From: Ard Biesheuvel <ardb@kernel.org>

Switch to the more abstract 'scoped_ksimd()' API, which will be modified
in a future patch to transparently allocate a kernel mode FP/SIMD state
buffer on the stack, so that kernel mode FP/SIMD code remains
preemptible in principe, but without the memory overhead that adds 528
bytes to the size of struct task_struct.

Reviewed-by: Eric Biggers <ebiggers@kernel.org>
Signed-off-by: Ard Biesheuvel <ardb@kernel.org>
---
 arch/arm64/crypto/sm4-ce-ccm-glue.c    |  38 ++--
 arch/arm64/crypto/sm4-ce-cipher-glue.c |  10 +-
 arch/arm64/crypto/sm4-ce-gcm-glue.c    |  53 +++--
 arch/arm64/crypto/sm4-ce-glue.c        | 214 +++++++++-----------
 arch/arm64/crypto/sm4-neon-glue.c      |  25 +--
 5 files changed, 149 insertions(+), 191 deletions(-)

diff --git a/arch/arm64/crypto/sm4-ce-ccm-glue.c b/arch/arm64/crypto/sm4-ce-ccm-glue.c
index e92cbdf1aaee..332f02167a96 100644
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
@@ -167,28 +166,25 @@ static int ccm_crypt(struct aead_request *req, struct skcipher_walk *walk,
 	memcpy(ctr0, walk->iv, SM4_BLOCK_SIZE);
 	crypto_inc(walk->iv, SM4_BLOCK_SIZE);
 
-	kernel_neon_begin();
+	scoped_ksimd() {
+		if (req->assoclen)
+			ccm_calculate_auth_mac(req, mac);
 
-	if (req->assoclen)
-		ccm_calculate_auth_mac(req, mac);
-
-	while (walk->nbytes) {
-		unsigned int tail = walk->nbytes % SM4_BLOCK_SIZE;
+		while (walk->nbytes) {
+			unsigned int tail = walk->nbytes % SM4_BLOCK_SIZE;
 
-		if (walk->nbytes == walk->total)
-			tail = 0;
+			if (walk->nbytes == walk->total)
+				tail = 0;
 
-		sm4_ce_ccm_crypt(rkey_enc, walk->dst.virt.addr,
-				 walk->src.virt.addr, walk->iv,
-				 walk->nbytes - tail, mac);
+			sm4_ce_ccm_crypt(rkey_enc, walk->dst.virt.addr,
+					 walk->src.virt.addr, walk->iv,
+					 walk->nbytes - tail, mac);
 
-		err = skcipher_walk_done(walk, tail);
+			err = skcipher_walk_done(walk, tail);
+		}
+		sm4_ce_ccm_final(rkey_enc, ctr0, mac);
 	}
 
-	sm4_ce_ccm_final(rkey_enc, ctr0, mac);
-
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
index 8f6fc8c33c3f..ef06f4f768a1 100644
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
 
@@ -149,31 +147,28 @@ static int gcm_crypt(struct aead_request *req, struct skcipher_walk *walk,
 	memcpy(iv, req->iv, GCM_IV_SIZE);
 	put_unaligned_be32(2, iv + GCM_IV_SIZE);
 
-	kernel_neon_begin();
+	scoped_ksimd() {
+		if (req->assoclen)
+			gcm_calculate_auth_mac(req, ghash);
 
-	if (req->assoclen)
-		gcm_calculate_auth_mac(req, ghash);
+		do {
+			unsigned int tail = walk->nbytes % SM4_BLOCK_SIZE;
+			const u8 *src = walk->src.virt.addr;
+			u8 *dst = walk->dst.virt.addr;
+			const u8 *l = NULL;
 
-	do {
-		unsigned int tail = walk->nbytes % SM4_BLOCK_SIZE;
-		const u8 *src = walk->src.virt.addr;
-		u8 *dst = walk->dst.virt.addr;
-		const u8 *l = NULL;
-
-		if (walk->nbytes == walk->total) {
-			l = (const u8 *)&lengths;
-			tail = 0;
-		}
-
-		sm4_ce_pmull_gcm_crypt(ctx->key.rkey_enc, dst, src, iv,
-				       walk->nbytes - tail, ghash,
-				       ctx->ghash_table, l);
-
-		err = skcipher_walk_done(walk, tail);
-	} while (walk->nbytes);
+			if (walk->nbytes == walk->total) {
+				l = (const u8 *)&lengths;
+				tail = 0;
+			}
 
-	kernel_neon_end();
+			sm4_ce_pmull_gcm_crypt(ctx->key.rkey_enc, dst, src, iv,
+					       walk->nbytes - tail, ghash,
+					       ctx->ghash_table, l);
 
+			err = skcipher_walk_done(walk, tail);
+		} while (walk->nbytes);
+	}
 	return err;
 }
 
diff --git a/arch/arm64/crypto/sm4-ce-glue.c b/arch/arm64/crypto/sm4-ce-glue.c
index 7a60e7b559dc..5569cece5a0b 100644
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
+				  crypto_sm4_fk, crypto_sm4_ck);
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
2.51.1.930.gacf6e81ea2-goog

