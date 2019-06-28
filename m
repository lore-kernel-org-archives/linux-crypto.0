Return-Path: <SRS0=Fqdl=U3=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id ADE31C4321A
	for <linux-crypto@archiver.kernel.org>; Fri, 28 Jun 2019 17:08:15 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 7D3522083B
	for <linux-crypto@archiver.kernel.org>; Fri, 28 Jun 2019 17:08:15 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="dylM1cg7"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726664AbfF1RIP (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 28 Jun 2019 13:08:15 -0400
Received: from mail-wr1-f67.google.com ([209.85.221.67]:35272 "EHLO
        mail-wr1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726408AbfF1RIO (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 28 Jun 2019 13:08:14 -0400
Received: by mail-wr1-f67.google.com with SMTP id f15so7074634wrp.2
        for <linux-crypto@vger.kernel.org>; Fri, 28 Jun 2019 10:08:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=DpYBBxjAx1YtpMPXritgbrmgXHp5nJSIahreGWzBl5Q=;
        b=dylM1cg7/XvGgbqu9jTEQUa4YABFX3yXo2JdydXDsQquN/7IGUsfuWAWNeEOytWD9N
         9RwPiqeAnKMqfjeKp9/DeF9RxO7FGAwpqWlYyeZbDvXu09XxLVtAE6PjjfU8D+HUOnBq
         56yQgyLhF8p5vL7h1xwzkIkgJZnPx5MHay8AhdrOXMJVqZuH1jmJ53eSmhBWWk+QnZqx
         SFaMGGUaJxT/NPb+oWdexDpWYwWxZsazPODAkX6plrXqA2scRQ8U7nBZKONwPThWglrx
         b0/5+/YWGd118QA9D7YaGibrvfcSGObkMFz3rkIbBnQK9BImI5UbsHADpW9Ckg5bNU++
         mc/g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=DpYBBxjAx1YtpMPXritgbrmgXHp5nJSIahreGWzBl5Q=;
        b=KFECzV1zZoVHxmUiju0nn7P3hg5mtj6NN3th27T9Tr5TNDQ9usCWj/68RD+eN+1Hjy
         PpfL2SO7pRKRX7zRZ5+uscRLFOabTVcWQxiYj1+K92+Yd5tuLp5ou+q286jupIvBQfF7
         avin9neU01c4DR+kQpAD8nI7vKOov3v4xej1kbCR8v2TTTVgsH5NRKp9+GcIE5y9SUuw
         llshbjIntlxavSDoDd3OZ1lPzuKRs3lKvVbTA4ufcSE09XNkGWw8uQ+VcGe+7Mrku3JI
         u8UTE95ggOdo/i9+yb4epyW6q+w8NZ+lm+DdVdBKKScPG5BUyarcudDDtWGpH5DCSAgJ
         wQOg==
X-Gm-Message-State: APjAAAV7NnZrkhzGyVtAAxx6I/oBR5cz0hDLA7/qxB+hMRMXnaYukng0
        ZNKaSF2pQxiSiC5LTFZvaSnYoVLF2ClHdg==
X-Google-Smtp-Source: APXvYqwJmVuNQ0kJ/lqv+SFWifdchW1eVgEgmWB6+A6Ui32RURN/BeItct3tFbgZaCpJ/LR/Ehs1Cg==
X-Received: by 2002:adf:e9c6:: with SMTP id l6mr9228673wrn.216.1561741691816;
        Fri, 28 Jun 2019 10:08:11 -0700 (PDT)
Received: from localhost.localdomain (laubervilliers-657-1-83-120.w92-154.abo.wanadoo.fr. [92.154.90.120])
        by smtp.gmail.com with ESMTPSA id c15sm3833251wrd.88.2019.06.28.10.08.10
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Fri, 28 Jun 2019 10:08:11 -0700 (PDT)
From:   Ard Biesheuvel <ard.biesheuvel@linaro.org>
To:     linux-crypto@vger.kernel.org
Cc:     Ard Biesheuvel <ard.biesheuvel@linaro.org>,
        Eric Biggers <ebiggers@google.com>,
        Ondrej Mosnacek <omosnace@redhat.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Steve Capper <steve.capper@arm.com>,
        Milan Broz <gmazyland@gmail.com>
Subject: [PATCH v2 5/7] crypto: aegis128 - add support for SIMD acceleration
Date:   Fri, 28 Jun 2019 19:07:44 +0200
Message-Id: <20190628170746.28768-6-ard.biesheuvel@linaro.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190628170746.28768-1-ard.biesheuvel@linaro.org>
References: <20190628170746.28768-1-ard.biesheuvel@linaro.org>
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
 crypto/Makefile                        |  1 +
 crypto/aegis.h                         | 14 +++----
 crypto/{aegis128.c => aegis128-core.c} | 42 ++++++++++++++++++--
 3 files changed, 46 insertions(+), 11 deletions(-)

diff --git a/crypto/Makefile b/crypto/Makefile
index 93375e124ff7..362a36f0bd2f 100644
--- a/crypto/Makefile
+++ b/crypto/Makefile
@@ -90,6 +90,7 @@ obj-$(CONFIG_CRYPTO_GCM) += gcm.o
 obj-$(CONFIG_CRYPTO_CCM) += ccm.o
 obj-$(CONFIG_CRYPTO_CHACHA20POLY1305) += chacha20poly1305.o
 obj-$(CONFIG_CRYPTO_AEGIS128) += aegis128.o
+aegis128-y := aegis128-core.o
 obj-$(CONFIG_CRYPTO_PCRYPT) += pcrypt.o
 obj-$(CONFIG_CRYPTO_CRYPTD) += cryptd.o
 obj-$(CONFIG_CRYPTO_DES) += des_generic.o
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
diff --git a/crypto/aegis128.c b/crypto/aegis128-core.c
similarity index 89%
rename from crypto/aegis128.c
rename to crypto/aegis128-core.c
index 32840d5e7f65..f815b4685156 100644
--- a/crypto/aegis128.c
+++ b/crypto/aegis128-core.c
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

