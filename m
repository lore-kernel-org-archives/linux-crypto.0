Return-Path: <SRS0=EZcf=VA=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 63BCFC0650E
	for <linux-crypto@archiver.kernel.org>; Wed,  3 Jul 2019 08:55:55 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 34490218A3
	for <linux-crypto@archiver.kernel.org>; Wed,  3 Jul 2019 08:55:55 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="j+ah9BNm"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727117AbfGCIzy (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Wed, 3 Jul 2019 04:55:54 -0400
Received: from mail-lj1-f193.google.com ([209.85.208.193]:35427 "EHLO
        mail-lj1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727056AbfGCIzy (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 3 Jul 2019 04:55:54 -0400
Received: by mail-lj1-f193.google.com with SMTP id x25so1543321ljh.2
        for <linux-crypto@vger.kernel.org>; Wed, 03 Jul 2019 01:55:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=0fVbORBssKTSmGXRjvmUxfKfBoYD/bE6Q8sFKbLJI8w=;
        b=j+ah9BNm/A4kR31qTRHCv8KJCJ6Mt8KE+NjsT7g9S8kU6tgHHWKTlf2oGNtNoorg5F
         RIbWzEmkbvUYq3KmZIQWzyhvqw3CUrbkQqvP3ODbkbrkiDz3ffVvm/jRQiaxfqy3jJeW
         8aRRP5ZoeLXTAmHZe2j2v2tQbR8JioNdqaMc5YeuIOF20KwHMAvqCyz4Ey9iYfLGkmdP
         9G0A/T45WOeOTH81BX4aXLzarsKxJrCOV1y+21003yZVFBzk+zRNmGcZVQ+W+tpbaCeh
         9HmJLGMkqEaQwfkzXiTdYuK8qNtLZ2XlJiNOYk0L1Gd2IJWOZcF+7CvlWFK+kwTd8Ouy
         NNFw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=0fVbORBssKTSmGXRjvmUxfKfBoYD/bE6Q8sFKbLJI8w=;
        b=IBPWu0X4pmh8GKEMUdX8uBI+W2fACjmQJyxDoed0TDomdAk1GBYvyVs4VT9NmO25Gs
         b8jlpX2q4/TiA0+1nAAc9CMc8rcGxSW4+TwTHDxAq+llU0GPdFUI+Yzcttr+H8gsemTA
         +yovYNIbvBDV5mymjN8BAbj+V7zQalnncoTB+HsbtY289cxY653z7i1ss796AjL+PWrJ
         hXTwEt1L7mn29ac1++Bxqef+etofgliQMZ7OH/gtkitCsXUQ8jD+veyXy+38qNsHomtT
         QJ9P5MfdCVceAtEiBk12ruCBLV1PAY3KPQAbiCTAbQuiTBhPcmKiE/Bxyp1PdeF6pHAL
         GCoQ==
X-Gm-Message-State: APjAAAVxuyS0/W01eZTc057ywNjZFG1GCR5FDoXLunxsowk59QbTrpEB
        nfoDbn/k3YMdwa5SeJ8ZDn/ami+cnwNGkKwt
X-Google-Smtp-Source: APXvYqwxwZjwDZbF8fxJU45AERm3NlCllokwaNW12TvgZS4DAVEZJMv7ak5HpPs9L5oPGeu4MPLjfA==
X-Received: by 2002:a2e:5b94:: with SMTP id m20mr20271076lje.7.1562144151988;
        Wed, 03 Jul 2019 01:55:51 -0700 (PDT)
Received: from e111045-lin.arm.com (89-212-78-239.static.t-2.net. [89.212.78.239])
        by smtp.gmail.com with ESMTPSA id h4sm354529ljj.31.2019.07.03.01.55.50
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Wed, 03 Jul 2019 01:55:51 -0700 (PDT)
From:   Ard Biesheuvel <ard.biesheuvel@linaro.org>
To:     linux-crypto@vger.kernel.org
Cc:     Ard Biesheuvel <ard.biesheuvel@linaro.org>,
        Eric Biggers <ebiggers@google.com>,
        Ondrej Mosnacek <omosnace@redhat.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Steve Capper <steve.capper@arm.com>,
        Milan Broz <gmazyland@gmail.com>
Subject: [PATCH v4 5/7] crypto: aegis128 - add support for SIMD acceleration
Date:   Wed,  3 Jul 2019 10:55:10 +0200
Message-Id: <20190703085512.13915-6-ard.biesheuvel@linaro.org>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20190703085512.13915-1-ard.biesheuvel@linaro.org>
References: <20190703085512.13915-1-ard.biesheuvel@linaro.org>
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Add some plumbing to allow the AEGIS128 code to be built with SIMD
routines for acceleration.

Reviewed-by: Ondrej Mosnacek <omosnace@redhat.com>
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
2.17.1

