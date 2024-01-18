Received: from mail-yw1-f201.google.com (mail-yw1-f201.google.com [209.85.128.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7C0A02C843
	for <linux-crypto@vger.kernel.org>; Thu, 18 Jan 2024 17:07:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705597667; cv=none; b=WctVfWIxGd5NTsHv2w6lCA7m8+P7a+kUGbXf3cOaLRG4qkOenEb3nmLE1kGsGv24sDBvFQdvcJy27gaK+jNao3FVcWUOcUr1fxYTHz73tZxdu/0O0xbMj7QwA7z5YQS0pSs4RIHrybcdooGniflKpx7HCjpzs1FAkometXrr6t8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705597667; c=relaxed/simple;
	bh=pZ8oCY0r84RIgsUexJP/p9VeZlb6wrHZvW0eZmjWFv4=;
	h=Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Gm-Message-State:X-Google-Smtp-Source:X-Received:Date:
	 In-Reply-To:Mime-Version:References:X-Developer-Key:
	 X-Developer-Signature:X-Mailer:Message-ID:Subject:From:To:Cc:
	 Content-Type; b=Z8EdrWVddVx5RJZqZVXyo+h1ZIOmlnu6qGsJ9jSwNUwtP2QN6GNSlH40EiEbTnrIO5r/5vmj1aPvIiOF/TckFTYvWzu840JSGfbodVDNsngjXrujY/ZwN81lkYzOYyz37vxwEPxQHwQFlKPSIB3Noshe45+/MK9FUamCAXsNEeM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--ardb.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=E7+PNovl; arc=none smtp.client-ip=209.85.128.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--ardb.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="E7+PNovl"
Received: by mail-yw1-f201.google.com with SMTP id 00721157ae682-5fba6d7da06so101705407b3.0
        for <linux-crypto@vger.kernel.org>; Thu, 18 Jan 2024 09:07:45 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1705597664; x=1706202464; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=HuhFJOxH8jB0ctCigCFsGkMCnb5I3c+w8zCI/ra5sf0=;
        b=E7+PNovljKBeZW72Ks1zI6CXuo+AQXQVwdo6dhqlsUQt59L/LlymiYoQGmkmIhNjRm
         fZtMqS4XUIhNgMKqZEPEjZvk+Yuvm1FNn3+hHdYsT4AfIWvvubCGiMt6v5c166G489Hk
         ukU4JA4B+lTn8GNcw7beoXmXucrCsNHUCrOgw7CxgZ19Wd+pxOjeBBiydksqFSqyh+80
         2Wy4Ia+J+ynsnuBDbBMjjiI6NuAwFWEN/B9PRb1OlKkNChbCwQN5nFabC5VWlRpX+jG2
         j9Wgj+WSxTJfOpMscLMi2XsO2qTxKDxzbUC4XWSntvcw4KLMxxhmTEpB/q6tKOGXscs1
         x16A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1705597664; x=1706202464;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=HuhFJOxH8jB0ctCigCFsGkMCnb5I3c+w8zCI/ra5sf0=;
        b=wpc7hKpmOMuMgN9dd/HtyEmyR2AmhrWlrPTslndrz0gTq16/S4Iccyme0ZPbVRR3Qe
         CmCosnXgf0oVOJN1vRHVsvSnzW7bwpeRF3Sc7E+lVCCPFXFdaypkzqK63tEFeSZ/EQA1
         jVjuPAPv/hynTEOU+VgUSOAvWYLx6SdpxAUQZsoDTqy4gQZePYG1ms6aGsceBN46nV9N
         noDmPEAv5sQeHZCuXVFRmufb2VKz2ddy230cUumvpieMbo5Q6X2if/486PHTuf4p1yKC
         OFBdT4NerBMXHGQWDJPLEEnQJUZO9Adq43VzcTH7+kHsu1xZGo7txcw/YYEMTT7YvIXV
         WlkQ==
X-Gm-Message-State: AOJu0YyInTqGthl2AfheRCOGlX7J61wQQnNZrQmRQn4qYOUpOvWdKYHK
	1ZjS8VK6pMoSA8VSkmteuY7ll8YwZ6WGJpfiTLFvfbFkHJ1IEfLgXIOF6gckzEBLc6ZCIado5xs
	HGM9JSSjJUM2DiQGYa28WOtbY1oxJsdoCto0AY+I+B0q+RTQUsmQMN41VA70REjGQnQbnca7HLO
	4BCWMaVcYMWqpILCqrNUQ6FafB1UR8fg==
X-Google-Smtp-Source: AGHT+IHXIK11si6qpGYUlCmD+oq280gtATie85QcyK9Mxc34DtzJbmZzVV1q5MDX7rFIFjUSn+rdziXZ
X-Received: from palermo.c.googlers.com ([fda3:e722:ac3:cc00:28:9cb1:c0a8:118a])
 (user=ardb job=sendgmr) by 2002:a25:abd1:0:b0:dc2:5237:81c7 with SMTP id
 v75-20020a25abd1000000b00dc2523781c7mr501414ybi.3.1705597664418; Thu, 18 Jan
 2024 09:07:44 -0800 (PST)
Date: Thu, 18 Jan 2024 18:06:32 +0100
In-Reply-To: <20240118170628.3049797-10-ardb+git@google.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20240118170628.3049797-10-ardb+git@google.com>
X-Developer-Key: i=ardb@kernel.org; a=openpgp; fpr=F43D03328115A198C90016883D200E9CA6329909
X-Developer-Signature: v=1; a=openpgp-sha256; l=5464; i=ardb@kernel.org;
 h=from:subject; bh=9yJ/w8NC+Jc2jXxJ0qx2wj4/busGKuIzmC9B7mGx820=;
 b=owGbwMvMwCFmkMcZplerG8N4Wi2JIXVl1IxNVR4LrN92Gf07P+PPrdSjhonituv2md69yDf3g
 GP9hsTpHaUsDGIcDLJiiiwCs/++23l6olSt8yxZmDmsTCBDGLg4BWAi7/MYGR4/7G+RY/gTYDiF
 a8kWluy99o7r71ouSM2fNf/65NlN7MIMf7jufJe6eibBYOGJLw0rJYwfs+QZ2T4/VZzF5/tPnrc 3lx0A
X-Mailer: git-send-email 2.43.0.381.gb435a96ce8-goog
Message-ID: <20240118170628.3049797-13-ardb+git@google.com>
Subject: [PATCH v2 3/8] crypto: arm64/aes-ccm - Pass short inputs via stack buffer
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
index b177ebea7d09..4710e59075f5 100644
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
+		if (unlikely(walk.nbytes < AES_BLOCK_SIZE))
+			src = dst = memcpy(&buf[sizeof(buf) - walk.nbytes],
+					   src, walk.nbytes);
+
+		ce_aes_ccm_encrypt(dst, src, walk.nbytes - tail,
+				   ctx->key_enc, num_rounds(ctx),
+				   mac, walk.iv);
+
+		if (unlikely(walk.nbytes < AES_BLOCK_SIZE))
+			memcpy(walk.dst.virt.addr, dst, walk.nbytes);
 
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
+		if (unlikely(walk.nbytes < AES_BLOCK_SIZE))
+			src = dst = memcpy(&buf[sizeof(buf) - walk.nbytes],
+					   src, walk.nbytes);
+
+		ce_aes_ccm_decrypt(dst, src, walk.nbytes - tail,
+				   ctx->key_enc, num_rounds(ctx),
+				   mac, walk.iv);
+
+		if (unlikely(walk.nbytes < AES_BLOCK_SIZE))
+			memcpy(walk.dst.virt.addr, dst, walk.nbytes);
 
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
2.43.0.381.gb435a96ce8-goog

