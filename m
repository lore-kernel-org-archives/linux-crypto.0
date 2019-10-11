Return-Path: <SRS0=ziyG=YE=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8584BECE58C
	for <linux-crypto@archiver.kernel.org>; Fri, 11 Oct 2019 17:09:33 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 56764206A1
	for <linux-crypto@archiver.kernel.org>; Fri, 11 Oct 2019 17:09:33 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="apJ0GA9s"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728431AbfJKRJc (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 11 Oct 2019 13:09:32 -0400
Received: from mail-wm1-f65.google.com ([209.85.128.65]:39723 "EHLO
        mail-wm1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728449AbfJKRJc (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 11 Oct 2019 13:09:32 -0400
Received: by mail-wm1-f65.google.com with SMTP id v17so10912092wml.4
        for <linux-crypto@vger.kernel.org>; Fri, 11 Oct 2019 10:09:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=3dT5xeg+W/abI4zH3wzED14fHVMhPnQCtSYtaVYmbAk=;
        b=apJ0GA9s8TIf+XqhnX3fcyr614dCtpruEjBkG0gxLeU9xA3fh7RxI8oqyEzc9kk3i1
         6O2SIz7jn2HKKlPCUUh3zZ21EW+wS4Au7E1JQHyArgLyuWvlIu7eZStQDE7cGbidKIGa
         Ztex0oLLfJQRoiPlYITZKw1wFY2C0FBrSf4NMjhTE61Xu/8M2HnzAMlCWedB521kqpps
         jOOgoA2ZCUSYef5swrsWfLMGAy0ZnTmPZvhvXIW3PIeFDjHI2HE/Dt0VmU4OzkA7uXet
         19aG20hPJUUV/wa1Xht1wrT287YKDowb+BinMIA+SwFCCa6svPDU0nu0gnDfisHgOfqd
         zJKQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=3dT5xeg+W/abI4zH3wzED14fHVMhPnQCtSYtaVYmbAk=;
        b=jp6ke0A40XjyiQktieuCEjhCNy+HNlpLvoW4GXgfCn7LzOkUHYoWXWPIL4/5ulyCMH
         f6iVQmYNi1hi/LgLoAU9yF2ugeFE1YleJUdj0KI4RvPZTvJkFnRVwoalYOp8AYj/w89C
         lJjTivj/9tEkDS6JUvrywhqmxjOoLG6TsdF5022Pp2080ZWAUwLxbwLn69gf3je0O8VH
         +MIYUFAuNCsicpzGrnlrc7yuqJW/TppOoZ+ReLnTtYohaiLnayGLtAyXrh8coS2zK1Ot
         A66iSfqBaOOueasu6OOYLy27tvQ9S8JZIVMrIFLxNrV5LxDMloXtZmyfIt8GNAZ4Pi1c
         Ud0w==
X-Gm-Message-State: APjAAAWZRqOqTfBVNVELZWDNuQibiUMC2tf+x4zMC+baUf3/iLLn4oEI
        QZKfXwcZ28kTPjhHz57SyIq5h/C1vKvaIA==
X-Google-Smtp-Source: APXvYqxNZuXDIfJfBDc7cNa62DKfqWGbvM/skXG4YSOilCu7Shxfe3VRWO+A4HmwmbyBrHGANp+jFg==
X-Received: by 2002:a1c:1d15:: with SMTP id d21mr3998509wmd.5.1570813769234;
        Fri, 11 Oct 2019 10:09:29 -0700 (PDT)
Received: from localhost.localdomain (91-167-84-221.subs.proxad.net. [91.167.84.221])
        by smtp.gmail.com with ESMTPSA id f9sm11876875wre.74.2019.10.11.10.09.28
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 11 Oct 2019 10:09:28 -0700 (PDT)
From:   Ard Biesheuvel <ard.biesheuvel@linaro.org>
To:     linux-crypto@vger.kernel.org
Cc:     linux-arm-kernel@lists.infradead.org, herbert@gondor.apana.org.au,
        Ard Biesheuvel <ard.biesheuvel@linaro.org>
Subject: [PATCH 1/2] crypto: aegis128 - avoid function pointers for parameterization
Date:   Fri, 11 Oct 2019 19:08:22 +0200
Message-Id: <20191011170823.6713-2-ard.biesheuvel@linaro.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20191011170823.6713-1-ard.biesheuvel@linaro.org>
References: <20191011170823.6713-1-ard.biesheuvel@linaro.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Instead of passing around an ops structure with function pointers,
which forces indirect calls to be used, refactor the code slightly
so we can use ordinary function calls. At the same time, switch to
a static key to decide whether or not the SIMD code path may be used.

Signed-off-by: Ard Biesheuvel <ard.biesheuvel@linaro.org>
---
 crypto/aegis128-core.c | 105 +++++++++-----------
 1 file changed, 46 insertions(+), 59 deletions(-)

diff --git a/crypto/aegis128-core.c b/crypto/aegis128-core.c
index 80e73611bd5c..fe7ab66dd8f9 100644
--- a/crypto/aegis128-core.c
+++ b/crypto/aegis128-core.c
@@ -13,6 +13,7 @@
 #include <crypto/scatterwalk.h>
 #include <linux/err.h>
 #include <linux/init.h>
+#include <linux/jump_label.h>
 #include <linux/kernel.h>
 #include <linux/module.h>
 #include <linux/scatterlist.h>
@@ -35,15 +36,7 @@ struct aegis_ctx {
 	union aegis_block key;
 };
 
-struct aegis128_ops {
-	int (*skcipher_walk_init)(struct skcipher_walk *walk,
-				  struct aead_request *req, bool atomic);
-
-	void (*crypt_chunk)(struct aegis_state *state, u8 *dst,
-			    const u8 *src, unsigned int size);
-};
-
-static bool have_simd;
+static __ro_after_init DEFINE_STATIC_KEY_FALSE(have_simd);
 
 static const union aegis_block crypto_aegis_const[2] = {
 	{ .words64 = {
@@ -59,7 +52,7 @@ static const union aegis_block crypto_aegis_const[2] = {
 static bool aegis128_do_simd(void)
 {
 #ifdef CONFIG_CRYPTO_AEGIS128_SIMD
-	if (have_simd)
+	if (static_branch_likely(&have_simd))
 		return crypto_simd_usable();
 #endif
 	return false;
@@ -323,25 +316,27 @@ static void crypto_aegis128_process_ad(struct aegis_state *state,
 	}
 }
 
-static void crypto_aegis128_process_crypt(struct aegis_state *state,
-					  struct aead_request *req,
-					  const struct aegis128_ops *ops)
+static __always_inline
+int crypto_aegis128_process_crypt(struct aegis_state *state,
+				  struct aead_request *req,
+				  struct skcipher_walk *walk,
+				  void (*crypt)(struct aegis_state *state,
+					        u8 *dst, const u8 *src,
+					        unsigned int size))
 {
-	struct skcipher_walk walk;
+	int err = 0;
 
-	ops->skcipher_walk_init(&walk, req, false);
+	while (walk->nbytes) {
+		unsigned int nbytes = walk->nbytes;
 
-	while (walk.nbytes) {
-		unsigned int nbytes = walk.nbytes;
+		if (nbytes < walk->total)
+			nbytes = round_down(nbytes, walk->stride);
 
-		if (nbytes < walk.total)
-			nbytes = round_down(nbytes, walk.stride);
+		crypt(state, walk->dst.virt.addr, walk->src.virt.addr, nbytes);
 
-		ops->crypt_chunk(state, walk.dst.virt.addr, walk.src.virt.addr,
-				 nbytes);
-
-		skcipher_walk_done(&walk, walk.nbytes - nbytes);
+		err = skcipher_walk_done(walk, walk->nbytes - nbytes);
 	}
+	return err;
 }
 
 static void crypto_aegis128_final(struct aegis_state *state,
@@ -390,39 +385,27 @@ static int crypto_aegis128_setauthsize(struct crypto_aead *tfm,
 	return 0;
 }
 
-static void crypto_aegis128_crypt(struct aead_request *req,
-				  union aegis_block *tag_xor,
-				  unsigned int cryptlen,
-				  const struct aegis128_ops *ops)
+static int crypto_aegis128_encrypt(struct aead_request *req)
 {
 	struct crypto_aead *tfm = crypto_aead_reqtfm(req);
+	union aegis_block tag = {};
+	unsigned int authsize = crypto_aead_authsize(tfm);
 	struct aegis_ctx *ctx = crypto_aead_ctx(tfm);
+	unsigned int cryptlen = req->cryptlen;
+	struct skcipher_walk walk;
 	struct aegis_state state;
 
 	crypto_aegis128_init(&state, &ctx->key, req->iv);
 	crypto_aegis128_process_ad(&state, req->src, req->assoclen);
-	crypto_aegis128_process_crypt(&state, req, ops);
-	crypto_aegis128_final(&state, tag_xor, req->assoclen, cryptlen);
-}
-
-static int crypto_aegis128_encrypt(struct aead_request *req)
-{
-	const struct aegis128_ops *ops = &(struct aegis128_ops){
-		.skcipher_walk_init = skcipher_walk_aead_encrypt,
-		.crypt_chunk = crypto_aegis128_encrypt_chunk,
-	};
-
-	struct crypto_aead *tfm = crypto_aead_reqtfm(req);
-	union aegis_block tag = {};
-	unsigned int authsize = crypto_aead_authsize(tfm);
-	unsigned int cryptlen = req->cryptlen;
 
+	skcipher_walk_aead_encrypt(&walk, req, false);
 	if (aegis128_do_simd())
-		ops = &(struct aegis128_ops){
-			.skcipher_walk_init = skcipher_walk_aead_encrypt,
-			.crypt_chunk = crypto_aegis128_encrypt_chunk_simd };
-
-	crypto_aegis128_crypt(req, &tag, cryptlen, ops);
+		crypto_aegis128_process_crypt(&state, req, &walk,
+					      crypto_aegis128_encrypt_chunk_simd);
+	else
+		crypto_aegis128_process_crypt(&state, req, &walk,
+					      crypto_aegis128_encrypt_chunk);
+	crypto_aegis128_final(&state, &tag, req->assoclen, cryptlen);
 
 	scatterwalk_map_and_copy(tag.bytes, req->dst, req->assoclen + cryptlen,
 				 authsize, 1);
@@ -431,26 +414,29 @@ static int crypto_aegis128_encrypt(struct aead_request *req)
 
 static int crypto_aegis128_decrypt(struct aead_request *req)
 {
-	const struct aegis128_ops *ops = &(struct aegis128_ops){
-		.skcipher_walk_init = skcipher_walk_aead_decrypt,
-		.crypt_chunk = crypto_aegis128_decrypt_chunk,
-	};
 	static const u8 zeros[AEGIS128_MAX_AUTH_SIZE] = {};
-
 	struct crypto_aead *tfm = crypto_aead_reqtfm(req);
 	union aegis_block tag;
 	unsigned int authsize = crypto_aead_authsize(tfm);
 	unsigned int cryptlen = req->cryptlen - authsize;
+	struct aegis_ctx *ctx = crypto_aead_ctx(tfm);
+	struct skcipher_walk walk;
+	struct aegis_state state;
 
 	scatterwalk_map_and_copy(tag.bytes, req->src, req->assoclen + cryptlen,
 				 authsize, 0);
 
-	if (aegis128_do_simd())
-		ops = &(struct aegis128_ops){
-			.skcipher_walk_init = skcipher_walk_aead_decrypt,
-			.crypt_chunk = crypto_aegis128_decrypt_chunk_simd };
+	crypto_aegis128_init(&state, &ctx->key, req->iv);
+	crypto_aegis128_process_ad(&state, req->src, req->assoclen);
 
-	crypto_aegis128_crypt(req, &tag, cryptlen, ops);
+	skcipher_walk_aead_decrypt(&walk, req, false);
+	if (aegis128_do_simd())
+		crypto_aegis128_process_crypt(&state, req, &walk,
+					      crypto_aegis128_decrypt_chunk_simd);
+	else
+		crypto_aegis128_process_crypt(&state, req, &walk,
+					      crypto_aegis128_decrypt_chunk);
+	crypto_aegis128_final(&state, &tag, req->assoclen, cryptlen);
 
 	return crypto_memneq(tag.bytes, zeros, authsize) ? -EBADMSG : 0;
 }
@@ -481,8 +467,9 @@ static struct aead_alg crypto_aegis128_alg = {
 
 static int __init crypto_aegis128_module_init(void)
 {
-	if (IS_ENABLED(CONFIG_CRYPTO_AEGIS128_SIMD))
-		have_simd = crypto_aegis128_have_simd();
+	if (IS_ENABLED(CONFIG_CRYPTO_AEGIS128_SIMD) &&
+	    crypto_aegis128_have_simd())
+		static_branch_enable(&have_simd);
 
 	return crypto_register_aead(&crypto_aegis128_alg);
 }
-- 
2.20.1

