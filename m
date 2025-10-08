Received: from mail-wm1-f74.google.com (mail-wm1-f74.google.com [209.85.128.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B666C2FAC14
	for <linux-crypto@vger.kernel.org>; Wed,  8 Oct 2025 15:47:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1759938429; cv=none; b=FeGRAOnRf/LnuOBUywMk1g57L7ICiv3UOGIV+Am0zDDSYoA9kIwiS/RO0pDzIZdu2er9eHvb06JU/s5xHPe7HSblTQ7NoWDTpboU1l/VqbCGJ/lZJVhui3BWMjKYiUp/rbcK8J6ZqTQFb180QvS477zYzbqslKEaOvMPyQcimXQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1759938429; c=relaxed/simple;
	bh=MtZS01j2WfludD2fnJ5sd0Wl0jM+Sxa7nGKfIhIUi1A=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=WIWjMyO2jht5K0el8rryM7QS4oqBRU4wsvPrE6n96W88lNcxDMlWBP//ztCVEn65l8bAB9iFwWswujGVEEICTcFPbLiMnvbxT2u9qgurHv0gco207eREdqcetZ3UHDWkXLwvKDEWpZH/Ol0xFbqEiDWadJVBwUBeCcaS23t9suM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--ardb.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=BoCEnnNP; arc=none smtp.client-ip=209.85.128.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--ardb.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="BoCEnnNP"
Received: by mail-wm1-f74.google.com with SMTP id 5b1f17b1804b1-46e25f5ed85so49313765e9.3
        for <linux-crypto@vger.kernel.org>; Wed, 08 Oct 2025 08:47:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1759938424; x=1760543224; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=8ZT9tgOoTUzUgeWgcfcZEHsGVCngyDkvjIERfXOEyEU=;
        b=BoCEnnNPwfwBomg/Bof0bn0slaDiv86SAT4/MycP+p7Ncej6jhLuhxNhyQ6OZWii/S
         6lXxPJn4KOGQdHAkrx8B0rrF6LGLw7yHKN9iRewoSdLyIveXyNX82yoU8F8yNgUqAc23
         P3J0CUJswMV62Xxq21wM3ztJZhaqiHNVrVHguPpQJW1THJxBaZZgGMpmfB33McVyQztN
         55Hog1QSMV2/zHMQj2t/bxoFfmA8d+M0lZg/R9hiWk/Psm7EKnfiMesLtMTR4bnMaV1T
         1ZOi6BNZs/R+9FLOhm9L7IRUcQit8FztVA6eiPUU50jecwWInEAE+YFoiDyAhjqOs/kW
         nkqA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1759938424; x=1760543224;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=8ZT9tgOoTUzUgeWgcfcZEHsGVCngyDkvjIERfXOEyEU=;
        b=cCisqxVHTaT1UE83Qx9sneYN8BufUkzZ++4dVM76VSDgrwzUw5vElbK2iH2Nb03KGd
         iMIsiyy2Hmf14WscUDFoFvt2zIWfmDWDDW/KfG1fWbFkM5F9DTXzoR7Kz11D+3/JlgKT
         KRxiGxO2bdtI9gsYgJugwSJX2ybrdC+N7JpSdNk7EdwGAmiHF+cVwXGdLSZXZxkFr5x6
         qc9VzRFnGHi0J4h21aJ/pISthgtMABHaJdyz2299wlLT3WHMv6pbJJZSD7btFmY/U3h6
         Yy1qvUQCoCjI7BiJXicg7saDP8M3vHU0SYHLOf1pKyup6eZGmLdfcj7xja1R2KU9JprA
         Z6IQ==
X-Forwarded-Encrypted: i=1; AJvYcCXQhpqaFZjppizsvifi+FVlaxb3O17o9eA+MhRvFtMqDeJ0FVctfkp+18SHhBUWUm2zSycbvDt6E/Ois64=@vger.kernel.org
X-Gm-Message-State: AOJu0YyDCL7zurpx/3YK19Mp5QhWGeNHVeb4a7fSDf2QoAMrD98u9aLJ
	oaglWLiYKnG+FQ0XKfXCI595aHc6Rd0YbdPyiPOZQRcdq7bn7wo+hhB7x/qGokYBAqGWK2m4bQ=
	=
X-Google-Smtp-Source: AGHT+IEC3/ADIk3U2uUD8KKtjU1+4hdim3vbK4dfDLBhgiS25kKiN4BPtS5PBsG6WxrUE6u65KzHoVVT
X-Received: from wmhf4.prod.google.com ([2002:a7b:cc04:0:b0:45f:28be:a3aa])
 (user=ardb job=prod-delivery.src-stubby-dispatcher) by 2002:a05:600c:4ec8:b0:46d:27b7:e7e5
 with SMTP id 5b1f17b1804b1-46fa9b08d79mr24052095e9.32.1759938423837; Wed, 08
 Oct 2025 08:47:03 -0700 (PDT)
Date: Wed,  8 Oct 2025 17:45:51 +0200
In-Reply-To: <20251008154533.3089255-23-ardb+git@google.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20251008154533.3089255-23-ardb+git@google.com>
X-Developer-Key: i=ardb@kernel.org; a=openpgp; fpr=F43D03328115A198C90016883D200E9CA6329909
X-Developer-Signature: v=1; a=openpgp-sha256; l=17484; i=ardb@kernel.org;
 h=from:subject; bh=GGuWmKmmCk1mbfGpeGHXwnYhEo3fZJDcJH39NGQosfM=;
 b=owGbwMvMwCVmkMcZplerG8N4Wi2JIeNZu1/I2aj2R5OmtBg1b2XTEIzNvWJTaJovuqZy/oQy6
 SuJd2Q6SlkYxLgYZMUUWQRm/3238/REqVrnWbIwc1iZQIYwcHEKwEQaHBn+BzT+3X5SouNR2HHN
 Fokz3F7rjzFXM069MfnjlV/Pu6atMGD4Z7XCuNh/I+8k9Z+fmpgmsS651Sk1/0P48ZaZKYqTMru /cAIA
X-Mailer: git-send-email 2.51.0.710.ga91ca5db03-goog
Message-ID: <20251008154533.3089255-40-ardb+git@google.com>
Subject: [PATCH v3 17/21] crypto/arm64: sm4 - Switch to 'ksimd' scoped guard API
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
2.51.0.710.ga91ca5db03-goog

