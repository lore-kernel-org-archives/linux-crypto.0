Return-Path: <SRS0=EE7o=UX=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 261DFC43613
	for <linux-crypto@archiver.kernel.org>; Mon, 24 Jun 2019 07:38:37 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id E55B62089F
	for <linux-crypto@archiver.kernel.org>; Mon, 24 Jun 2019 07:38:36 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="hF0QGJa0"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727157AbfFXHig (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Mon, 24 Jun 2019 03:38:36 -0400
Received: from mail-wr1-f65.google.com ([209.85.221.65]:34495 "EHLO
        mail-wr1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727022AbfFXHig (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 24 Jun 2019 03:38:36 -0400
Received: by mail-wr1-f65.google.com with SMTP id k11so12738750wrl.1
        for <linux-crypto@vger.kernel.org>; Mon, 24 Jun 2019 00:38:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=wAWQ7z4x3fHIJa8oYIdIUVUZ8X0GMup0jVGwMgCujFU=;
        b=hF0QGJa0EKrqmqGReOhultCyL3T7Lc94boWKxcqo1ZItQdCX52u3asNMisj480Vg5e
         7UfxRMnlLyeDw2+ahncrvMrlCs+1L1eGcCq7JRUP/VA7yUkDfF+ZcSaaUSUkgjYWpOwo
         YYib/0t5uCcU7iEsyalLysWBb89isJPC6no61PFEGzArpdvnWh5T2ZD8nINsRRcVLkGU
         JWaRH0ZpfjyCDVnB5zK/mpY36aRIJzDG89JlC7IfCKIj4FTUVI+eMZnEzkA+MSsNBu4N
         BWEimYPojRFgjCY6ZXge9Iky92Z01AaQWcXaiq6rUO5PPkEduL9meQbU0esTqPaTKZRs
         8hjQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=wAWQ7z4x3fHIJa8oYIdIUVUZ8X0GMup0jVGwMgCujFU=;
        b=jD9jXS5PuUkWezAt2LhX/saJcffQoiD918jMd7nSaS/UCianF6y9eTtSWrj7nXA7Ez
         4PPyOGMujKpdcJbAu0ysn3IYUH+cjA0OtuVcWYN+/0xaf6K2y4+ZKKNHWmHPhHOvUMyW
         WTSOu/v2XVXVHfCrpdnn0qqKPh/F8p+ry1+CmqaA8nbZs3xMERcD/HvQ1OrHYzmbfbgL
         kQxSZCuZ9TDPrPLTzk3q5m8bRfAlWw44uYCLT1Os6E1jp2P/kkKEkNXs5mgqgcg8CjIj
         sh23PQRfX1mVYgxuARMAzkLIKgvksdiHmDk7u7kxWO5MaPR2abRSC9IFcR1s+z1ebl0n
         bk2Q==
X-Gm-Message-State: APjAAAUJ14Dl1j7KoV7WW/KVkTMJmNEirTkzU+2oUMR8FXyoJKcQbJy8
        XaksHFV7xicEDnrUuIBNEVhg5l2mQaMX2A==
X-Google-Smtp-Source: APXvYqyhq94Xtt1BZUu9O2FSpIRkHtUjvarRflFnPWKKC3GpcfB8rMCxkQt4epRSwNS9HOqGotEHVA==
X-Received: by 2002:a05:6000:128d:: with SMTP id f13mr21048752wrx.39.1561361913237;
        Mon, 24 Jun 2019 00:38:33 -0700 (PDT)
Received: from sudo.home ([2a01:cb1d:112:6f00:4866:7cdc:a930:8455])
        by smtp.gmail.com with ESMTPSA id 203sm7419280wmc.30.2019.06.24.00.38.32
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 24 Jun 2019 00:38:32 -0700 (PDT)
From:   Ard Biesheuvel <ard.biesheuvel@linaro.org>
To:     linux-crypto@vger.kernel.org
Cc:     linux-arm-kernel@lists.infradead.org,
        Ard Biesheuvel <ard.biesheuvel@linaro.org>,
        Eric Biggers <ebiggers@google.com>,
        Ondrej Mosnacek <omosnace@redhat.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Steve Capper <steve.capper@arm.com>
Subject: [PATCH 4/6] crypto: aegis128 - add support for SIMD acceleration
Date:   Mon, 24 Jun 2019 09:38:16 +0200
Message-Id: <20190624073818.29296-5-ard.biesheuvel@linaro.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190624073818.29296-1-ard.biesheuvel@linaro.org>
References: <20190624073818.29296-1-ard.biesheuvel@linaro.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Add some plumbing to allow the AEGIS128 code to be built with SIMD
routines for acceleration.

Signed-off-by: Ard Biesheuvel <ard.biesheuvel@linaro.org>
---
 crypto/aegis.h    | 14 +++----
 crypto/aegis128.c | 42 ++++++++++++++++++--
 2 files changed, 45 insertions(+), 11 deletions(-)

diff --git a/crypto/aegis.h b/crypto/aegis.h
index 3308066ddde0..6cb65a497ba2 100644
--- a/crypto/aegis.h
+++ b/crypto/aegis.h
@@ -35,23 +35,23 @@ static const union aegis_block crypto_aegis_const[2] = {
 	} },
 };
 
-static void crypto_aegis_block_xor(union aegis_block *dst,
-				   const union aegis_block *src)
+static inline void crypto_aegis_block_xor(union aegis_block *dst,
+					  const union aegis_block *src)
 {
 	dst->words64[0] ^= src->words64[0];
 	dst->words64[1] ^= src->words64[1];
 }
 
-static void crypto_aegis_block_and(union aegis_block *dst,
-				   const union aegis_block *src)
+static inline void crypto_aegis_block_and(union aegis_block *dst,
+					  const union aegis_block *src)
 {
 	dst->words64[0] &= src->words64[0];
 	dst->words64[1] &= src->words64[1];
 }
 
-static void crypto_aegis_aesenc(union aegis_block *dst,
-				const union aegis_block *src,
-				const union aegis_block *key)
+static inline void crypto_aegis_aesenc(union aegis_block *dst,
+				       const union aegis_block *src,
+				       const union aegis_block *key)
 {
 	const u8  *s  = src->bytes;
 	const u32 *t = crypto_ft_tab[0];
diff --git a/crypto/aegis128.c b/crypto/aegis128.c
index 4f8f1cdef129..1bbd3e49c890 100644
--- a/crypto/aegis128.c
+++ b/crypto/aegis128.c
@@ -8,6 +8,7 @@
 
 #include <crypto/algapi.h>
 #include <crypto/internal/aead.h>
+#include <crypto/internal/simd.h>
 #include <crypto/internal/skcipher.h>
 #include <crypto/scatterwalk.h>
 #include <linux/err.h>
@@ -15,6 +16,7 @@
 #include <linux/kernel.h>
 #include <linux/module.h>
 #include <linux/scatterlist.h>
+#include <asm/simd.h>
 
 #include "aegis.h"
 
@@ -40,6 +42,15 @@ struct aegis128_ops {
 			    const u8 *src, unsigned int size);
 };
 
+static bool have_simd;
+
+bool crypto_aegis128_have_simd(void);
+void crypto_aegis128_update_simd(struct aegis_state *state, const void *msg);
+void crypto_aegis128_encrypt_chunk_simd(struct aegis_state *state, u8 *dst,
+					const u8 *src, unsigned int size);
+void crypto_aegis128_decrypt_chunk_simd(struct aegis_state *state, u8 *dst,
+					const u8 *src, unsigned int size);
+
 static void crypto_aegis128_update(struct aegis_state *state)
 {
 	union aegis_block tmp;
@@ -55,12 +66,22 @@ static void crypto_aegis128_update(struct aegis_state *state)
 static void crypto_aegis128_update_a(struct aegis_state *state,
 				     const union aegis_block *msg)
 {
+	if (have_simd && crypto_simd_usable()) {
+		crypto_aegis128_update_simd(state, msg);
+		return;
+	}
+
 	crypto_aegis128_update(state);
 	crypto_aegis_block_xor(&state->blocks[0], msg);
 }
 
 static void crypto_aegis128_update_u(struct aegis_state *state, const void *msg)
 {
+	if (have_simd && crypto_simd_usable()) {
+		crypto_aegis128_update_simd(state, msg);
+		return;
+	}
+
 	crypto_aegis128_update(state);
 	crypto_xor(state->blocks[0].bytes, msg, AEGIS_BLOCK_SIZE);
 }
@@ -365,7 +386,7 @@ static void crypto_aegis128_crypt(struct aead_request *req,
 
 static int crypto_aegis128_encrypt(struct aead_request *req)
 {
-	static const struct aegis128_ops ops = {
+	const struct aegis128_ops *ops = &(struct aegis128_ops){
 		.skcipher_walk_init = skcipher_walk_aead_encrypt,
 		.crypt_chunk = crypto_aegis128_encrypt_chunk,
 	};
@@ -375,7 +396,12 @@ static int crypto_aegis128_encrypt(struct aead_request *req)
 	unsigned int authsize = crypto_aead_authsize(tfm);
 	unsigned int cryptlen = req->cryptlen;
 
-	crypto_aegis128_crypt(req, &tag, cryptlen, &ops);
+	if (have_simd && crypto_simd_usable())
+		ops = &(struct aegis128_ops){
+			.skcipher_walk_init = skcipher_walk_aead_encrypt,
+			.crypt_chunk = crypto_aegis128_encrypt_chunk_simd };
+
+	crypto_aegis128_crypt(req, &tag, cryptlen, ops);
 
 	scatterwalk_map_and_copy(tag.bytes, req->dst, req->assoclen + cryptlen,
 				 authsize, 1);
@@ -384,7 +410,7 @@ static int crypto_aegis128_encrypt(struct aead_request *req)
 
 static int crypto_aegis128_decrypt(struct aead_request *req)
 {
-	static const struct aegis128_ops ops = {
+	const struct aegis128_ops *ops = &(struct aegis128_ops){
 		.skcipher_walk_init = skcipher_walk_aead_decrypt,
 		.crypt_chunk = crypto_aegis128_decrypt_chunk,
 	};
@@ -398,7 +424,12 @@ static int crypto_aegis128_decrypt(struct aead_request *req)
 	scatterwalk_map_and_copy(tag.bytes, req->src, req->assoclen + cryptlen,
 				 authsize, 0);
 
-	crypto_aegis128_crypt(req, &tag, cryptlen, &ops);
+	if (have_simd && crypto_simd_usable())
+		ops = &(struct aegis128_ops){
+			.skcipher_walk_init = skcipher_walk_aead_decrypt,
+			.crypt_chunk = crypto_aegis128_decrypt_chunk_simd };
+
+	crypto_aegis128_crypt(req, &tag, cryptlen, ops);
 
 	return crypto_memneq(tag.bytes, zeros, authsize) ? -EBADMSG : 0;
 }
@@ -429,6 +460,9 @@ static struct aead_alg crypto_aegis128_alg = {
 
 static int __init crypto_aegis128_module_init(void)
 {
+	if (IS_ENABLED(CONFIG_CRYPTO_AEGIS128_SIMD))
+		have_simd = crypto_aegis128_have_simd();
+
 	return crypto_register_aead(&crypto_aegis128_alg);
 }
 
-- 
2.20.1

