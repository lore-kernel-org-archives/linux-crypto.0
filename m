Received: from mail-yw1-f201.google.com (mail-yw1-f201.google.com [209.85.128.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3D45D15AC5
	for <linux-crypto@vger.kernel.org>; Thu, 11 Jan 2024 12:33:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--ardb.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="RcmyVJnF"
Received: by mail-yw1-f201.google.com with SMTP id 00721157ae682-5f6f51cd7e8so73736667b3.1
        for <linux-crypto@vger.kernel.org>; Thu, 11 Jan 2024 04:33:30 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1704976410; x=1705581210; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=SpZJATqCZATuxaz2gilHI43oqOqQXViPLDcKIFXRnDk=;
        b=RcmyVJnFI51qaHWDNWFhRNKi0MenLXz/8BcAaQocmH6AhJrwI8wQrHodqULszDQuof
         7HIfCOaFYaMaj/5I+bXEEIvWSVTqwPqRoBtCFaCI+h82QV1gPdTEqjHlAHRH4Vd6+sqe
         +BDvqKicAx60/sr5tQrrVg2V7ihIE0ZGwz32CjTolPTEXOPz4c6gBh/keO+R2nuyxpOL
         JBRDBqiza8X/I4BOG06d9+zyT8aRxI6QNTUH75LO3xLpvOT7ijBQdEQAjF3d0wUqBGJE
         9zhaDoYRY7nh31igjQHlfTxWpWR8tgY7mTmtAWT1fGO9mEJK70c2ungFM6lNL3Kot5Ww
         U9oQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1704976410; x=1705581210;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=SpZJATqCZATuxaz2gilHI43oqOqQXViPLDcKIFXRnDk=;
        b=pDGDAMjUA12VYIFetuzrwEGr8cKxM545aILRtDoPSc9us+jVhkUYubiY07BiqOGTof
         7RfYSSawBJ68gMEJFHjCZYt2CcB73FZ3xUgR0JPKiYJjw/61eOUHf+GkU/3KSFHmgYi1
         PN4ZUByiKm1vYpDxQkLkCB+iKnu5nsXTaP2FTv/sOXzaVyz9h3rq8GpIm6gDnGGFobi9
         lUMH6AQxqP9qc98D+sLvTDoM17youVGzdcw0Bh4HiRn4J6Aar2YXvcdmgLBJp9vTXJJ/
         q1cE5RcruAZuHfeLqLhziuBjZrCGQuNir5z1rrxb42XDRk4jGR7FDRexsWyUt+TmMkTO
         1ifw==
X-Gm-Message-State: AOJu0YwpWRb0gGuOIYSDGuXKqi5KrMK2P6iJ2li0lMEjUq5wiaNAiTth
	lSJZW/w+FgASDnKUsReOFSn0twNc0BlDsTxsXQMpyGXa8/CVp/GlCAXHRSfGqewrYEfaSVxff1l
	0WfryAGrY6PtwJhaCJ4CiigJRa3ne/kmVFUVAWnYhqKv4VM+UruFT6d2MhFALULONz6garhM=
X-Google-Smtp-Source: AGHT+IGo7LQGrzOzQCR4+X6/oJt2wm+mswEhHOU19JfKuLn6FmFAQUiBNZva0xPOkw2+LytO1g8RQ1G4
X-Received: from palermo.c.googlers.com ([fda3:e722:ac3:cc00:28:9cb1:c0a8:118a])
 (user=ardb job=sendgmr) by 2002:a0d:c607:0:b0:5f9:4fa1:19cf with SMTP id
 i7-20020a0dc607000000b005f94fa119cfmr177135ywd.0.1704976410146; Thu, 11 Jan
 2024 04:33:30 -0800 (PST)
Date: Thu, 11 Jan 2024 13:33:06 +0100
In-Reply-To: <20240111123302.589910-10-ardb+git@google.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20240111123302.589910-10-ardb+git@google.com>
X-Developer-Key: i=ardb@kernel.org; a=openpgp; fpr=F43D03328115A198C90016883D200E9CA6329909
X-Developer-Signature: v=1; a=openpgp-sha256; l=5454; i=ardb@kernel.org;
 h=from:subject; bh=Odhmzeqpckz1VnXGZdxlxNlIGE9EbODByD1xmZr7qf4=;
 b=owGbwMvMwCFmkMcZplerG8N4Wi2JIXX+A8Yyk+Nr/jw6Jl3frJyz+zbXfzaPPyFsnV/6LxwUM
 Ntg2Ha0o5SFQYyDQVZMkUVg9t93O09PlKp1niULM4eVCWQIAxenAExkijYjw9wKDbODrTfWHj5m
 aLSoqPtE7x05Dgf1BVfSeyPvtLxm3sXI8CF9vqPA0gMikTVMW2RPsu3+Y8QqueJNp+reiRol1up y/AA=
X-Mailer: git-send-email 2.43.0.275.g3460e3d667-goog
Message-ID: <20240111123302.589910-13-ardb+git@google.com>
Subject: [PATCH 3/8] crypto: arm64/aes-ccm - Pass short inputs via stack buffer
From: Ard Biesheuvel <ardb+git@google.com>
To: linux-crypto@vger.kernel.org
Cc: ebiggers@kernel.org, herbert@gondor.apana.org.au, 
	Ard Biesheuvel <ardb@kernel.org>
Content-Type: text/plain; charset="UTF-8"

From: Ard Biesheuvel <ardb@kernel.org>

In preparation for optimizing the CCM core asm code using permutation
vectors and overlapping loads and stores, ensure that inputs shorter
than the size of a AES block are passed via a buffer on the stack, in a
way that positions the data at the end of a 16 byte buffer. This removes
the need for the asm code to reason about a rare corner case where the
tail of the data cannot be read/written using a single NEON load/store
instruction.

While at it, tweak the copyright header and authorship to bring it up to
date.

Signed-off-by: Ard Biesheuvel <ardb@kernel.org>
---
 arch/arm64/crypto/aes-ce-ccm-glue.c | 57 ++++++++++++++------
 1 file changed, 40 insertions(+), 17 deletions(-)

diff --git a/arch/arm64/crypto/aes-ce-ccm-glue.c b/arch/arm64/crypto/aes-ce-ccm-glue.c
index b177ebea7d09..2f4e6a318fcd 100644
--- a/arch/arm64/crypto/aes-ce-ccm-glue.c
+++ b/arch/arm64/crypto/aes-ce-ccm-glue.c
@@ -1,8 +1,11 @@
 // SPDX-License-Identifier: GPL-2.0-only
 /*
- * aes-ccm-glue.c - AES-CCM transform for ARMv8 with Crypto Extensions
+ * aes-ce-ccm-glue.c - AES-CCM transform for ARMv8 with Crypto Extensions
  *
- * Copyright (C) 2013 - 2017 Linaro Ltd <ard.biesheuvel@linaro.org>
+ * Copyright (C) 2013 - 2017 Linaro Ltd.
+ * Copyright (C) 2024 Google LLC
+ *
+ * Author: Ard Biesheuvel <ardb@kernel.org>
  */
 
 #include <asm/neon.h>
@@ -149,7 +152,7 @@ static int ccm_encrypt(struct aead_request *req)
 	struct crypto_aes_ctx *ctx = crypto_aead_ctx(aead);
 	struct skcipher_walk walk;
 	u8 __aligned(8) mac[AES_BLOCK_SIZE];
-	u8 buf[AES_BLOCK_SIZE];
+	u8 orig_iv[AES_BLOCK_SIZE];
 	u32 len = req->cryptlen;
 	int err;
 
@@ -158,7 +161,7 @@ static int ccm_encrypt(struct aead_request *req)
 		return err;
 
 	/* preserve the original iv for the final round */
-	memcpy(buf, req->iv, AES_BLOCK_SIZE);
+	memcpy(orig_iv, req->iv, AES_BLOCK_SIZE);
 
 	err = skcipher_walk_aead_encrypt(&walk, req, false);
 	if (unlikely(err))
@@ -171,16 +174,26 @@ static int ccm_encrypt(struct aead_request *req)
 
 	do {
 		u32 tail = walk.nbytes % AES_BLOCK_SIZE;
+		const u8 *src = walk.src.virt.addr;
+		u8 *dst = walk.dst.virt.addr;
+		u8 buf[AES_BLOCK_SIZE];
 
 		if (walk.nbytes == walk.total)
 			tail = 0;
 
-		ce_aes_ccm_encrypt(walk.dst.virt.addr, walk.src.virt.addr,
-				   walk.nbytes - tail, ctx->key_enc,
-				   num_rounds(ctx), mac, walk.iv);
+		if (unlikely(walk.total < AES_BLOCK_SIZE))
+			src = dst = memcpy(buf + sizeof(buf) - walk.total,
+					   src, walk.total);
+
+		ce_aes_ccm_encrypt(dst, src, walk.nbytes - tail,
+				   ctx->key_enc, num_rounds(ctx),
+				   mac, walk.iv);
+
+		if (unlikely(walk.total < AES_BLOCK_SIZE))
+			memcpy(walk.dst.virt.addr, dst, walk.total);
 
 		if (walk.nbytes == walk.total)
-			ce_aes_ccm_final(mac, buf, ctx->key_enc, num_rounds(ctx));
+			ce_aes_ccm_final(mac, orig_iv, ctx->key_enc, num_rounds(ctx));
 
 		if (walk.nbytes) {
 			err = skcipher_walk_done(&walk, tail);
@@ -206,7 +219,7 @@ static int ccm_decrypt(struct aead_request *req)
 	unsigned int authsize = crypto_aead_authsize(aead);
 	struct skcipher_walk walk;
 	u8 __aligned(8) mac[AES_BLOCK_SIZE];
-	u8 buf[AES_BLOCK_SIZE];
+	u8 orig_iv[AES_BLOCK_SIZE];
 	u32 len = req->cryptlen - authsize;
 	int err;
 
@@ -215,7 +228,7 @@ static int ccm_decrypt(struct aead_request *req)
 		return err;
 
 	/* preserve the original iv for the final round */
-	memcpy(buf, req->iv, AES_BLOCK_SIZE);
+	memcpy(orig_iv, req->iv, AES_BLOCK_SIZE);
 
 	err = skcipher_walk_aead_decrypt(&walk, req, false);
 	if (unlikely(err))
@@ -228,16 +241,26 @@ static int ccm_decrypt(struct aead_request *req)
 
 	do {
 		u32 tail = walk.nbytes % AES_BLOCK_SIZE;
+		const u8 *src = walk.src.virt.addr;
+		u8 *dst = walk.dst.virt.addr;
+		u8 buf[AES_BLOCK_SIZE];
 
 		if (walk.nbytes == walk.total)
 			tail = 0;
 
-		ce_aes_ccm_decrypt(walk.dst.virt.addr, walk.src.virt.addr,
-				   walk.nbytes - tail, ctx->key_enc,
-				   num_rounds(ctx), mac, walk.iv);
+		if (unlikely(walk.total < AES_BLOCK_SIZE))
+			src = dst = memcpy(buf + sizeof(buf) - walk.total,
+					   src, walk.total);
+
+		ce_aes_ccm_decrypt(dst, src, walk.nbytes - tail,
+				   ctx->key_enc, num_rounds(ctx),
+				   mac, walk.iv);
+
+		if (unlikely(walk.total < AES_BLOCK_SIZE))
+			memcpy(walk.dst.virt.addr, dst, walk.total);
 
 		if (walk.nbytes == walk.total)
-			ce_aes_ccm_final(mac, buf, ctx->key_enc, num_rounds(ctx));
+			ce_aes_ccm_final(mac, orig_iv, ctx->key_enc, num_rounds(ctx));
 
 		if (walk.nbytes) {
 			err = skcipher_walk_done(&walk, tail);
@@ -250,11 +273,11 @@ static int ccm_decrypt(struct aead_request *req)
 		return err;
 
 	/* compare calculated auth tag with the stored one */
-	scatterwalk_map_and_copy(buf, req->src,
+	scatterwalk_map_and_copy(orig_iv, req->src,
 				 req->assoclen + req->cryptlen - authsize,
 				 authsize, 0);
 
-	if (crypto_memneq(mac, buf, authsize))
+	if (crypto_memneq(mac, orig_iv, authsize))
 		return -EBADMSG;
 	return 0;
 }
@@ -293,6 +316,6 @@ module_init(aes_mod_init);
 module_exit(aes_mod_exit);
 
 MODULE_DESCRIPTION("Synchronous AES in CCM mode using ARMv8 Crypto Extensions");
-MODULE_AUTHOR("Ard Biesheuvel <ard.biesheuvel@linaro.org>");
+MODULE_AUTHOR("Ard Biesheuvel <ardb@kernel.org>");
 MODULE_LICENSE("GPL v2");
 MODULE_ALIAS_CRYPTO("ccm(aes)");
-- 
2.43.0.275.g3460e3d667-goog

