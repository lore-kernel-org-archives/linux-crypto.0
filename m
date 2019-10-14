Return-Path: <SRS0=VKJi=YH=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.9 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9A393ECE58E
	for <linux-crypto@archiver.kernel.org>; Mon, 14 Oct 2019 16:16:56 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 69FB42133F
	for <linux-crypto@archiver.kernel.org>; Mon, 14 Oct 2019 16:16:56 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="ropoQQyZ"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728931AbfJNQQz (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Mon, 14 Oct 2019 12:16:55 -0400
Received: from mail-wm1-f66.google.com ([209.85.128.66]:55954 "EHLO
        mail-wm1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1732278AbfJNQQz (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 14 Oct 2019 12:16:55 -0400
Received: by mail-wm1-f66.google.com with SMTP id a6so17873324wma.5
        for <linux-crypto@vger.kernel.org>; Mon, 14 Oct 2019 09:16:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=IpqwZs59nyi92LNM6KIZI+WaiWKBSPMKiEsrKFRiIIQ=;
        b=ropoQQyZtGHuwo63cXLCu0UHmNi3J3G0O3/6hGn/jCZ8k2yn5blG9AbNTOgLWawfN/
         gnyYYtlbMMcYEqrdCPnifs3H4TaPZtx6MrMc6m6MZ2vh/sqvCueoWAgTivlT39idODkK
         MJjSxRiF0ZHO1SuAS9qGJcarbxYxUx2dRTat7JQ3mcOjWI/XP+0Zup6u4PNnUJ2Nw+Xe
         5bPgcg4OlLhXxVT+a+usv3V3UI98oQHNKSgcVGca/AQuYDDpItaUmBaxfKxQlJkoO2uw
         OrcLjnI7oI+fYWuZgyVMAxwLrdv+LATzz2E9LlPVSpy3ZRSnDJVU5vR1b8UtPyULeQGA
         ngWw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=IpqwZs59nyi92LNM6KIZI+WaiWKBSPMKiEsrKFRiIIQ=;
        b=sHFZkTl9+zcGWFuC+VM/MR8aAinekZX+53FV87LqNQniO2ugnhjLGf2GZ6Gf+KiDAF
         hYpH2Ax/O5Eylx5CFPi+WbsnJXCFOiMlBR8qce5YOXcLy0eMiN2D9wxcKslQ3jehVgex
         kmNIobnaG7C/WnidEd4jSt4xQ1Gedh3zS9Qqe6dNlH23uegNynZ8ZnoAGiM/iQfbv8+z
         2BopQmM3rgQ/eqF+foLloFreaJx4koqIjXymOxP8LT/X7rvsYLRBhMjTdksVzop4CV5k
         mlH+I12+wPEEMmYpyskk0vkTzthOJOnWYqwUeiuejdS3j1hi7n2IiyUOUgqZ6RDeuIeM
         wS1Q==
X-Gm-Message-State: APjAAAUG9rq+rfL5yBco7iihqY6Jd9pfUZq4Bc/TWAUq6gU7pTla9NiI
        cSj72r5RuB/I5Er0Ja/lsQmJ2oJdHD5UbA==
X-Google-Smtp-Source: APXvYqxZxQhFWBsmtL0WslRvh3I5uRBH3fe6rYKEQkXGdDmX+4c9gnRs80V9LP2Ughujf0e7h9vdmg==
X-Received: by 2002:a1c:740a:: with SMTP id p10mr16573764wmc.90.1571069812884;
        Mon, 14 Oct 2019 09:16:52 -0700 (PDT)
Received: from localhost.localdomain (aaubervilliers-681-1-23-27.w90-88.abo.wanadoo.fr. [90.88.143.27])
        by smtp.gmail.com with ESMTPSA id a14sm17308655wmm.44.2019.10.14.09.16.51
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 14 Oct 2019 09:16:51 -0700 (PDT)
From:   Ard Biesheuvel <ard.biesheuvel@linaro.org>
To:     linux-crypto@vger.kernel.org
Cc:     linux-arm-kernel@lists.infradead.org, herbert@gondor.apana.org.au,
        Ard Biesheuvel <ard.biesheuvel@linaro.org>
Subject: [PATCH v2 2/2] crypto: aegis128 - duplicate init() and final() hooks in SIMD code
Date:   Mon, 14 Oct 2019 18:16:45 +0200
Message-Id: <20191014161645.1961-3-ard.biesheuvel@linaro.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20191014161645.1961-1-ard.biesheuvel@linaro.org>
References: <20191014161645.1961-1-ard.biesheuvel@linaro.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

In order to speed up aegis128 processing even more, duplicate the init()
and final() routines as SIMD versions in their entirety. This results
in a 2x speedup on ARM Cortex-A57 for ~1500 byte packets (using AES
instructions).

Signed-off-by: Ard Biesheuvel <ard.biesheuvel@linaro.org>
---
 crypto/aegis128-core.c       | 38 ++++++++++-----
 crypto/aegis128-neon-inner.c | 50 ++++++++++++++++++++
 crypto/aegis128-neon.c       | 21 ++++++++
 3 files changed, 97 insertions(+), 12 deletions(-)

diff --git a/crypto/aegis128-core.c b/crypto/aegis128-core.c
index fe7ab66dd8f9..71c11cb5bad1 100644
--- a/crypto/aegis128-core.c
+++ b/crypto/aegis128-core.c
@@ -60,10 +60,16 @@ static bool aegis128_do_simd(void)
 
 bool crypto_aegis128_have_simd(void);
 void crypto_aegis128_update_simd(struct aegis_state *state, const void *msg);
+void crypto_aegis128_init_simd(struct aegis_state *state,
+			       const union aegis_block *key,
+			       const u8 *iv);
 void crypto_aegis128_encrypt_chunk_simd(struct aegis_state *state, u8 *dst,
 					const u8 *src, unsigned int size);
 void crypto_aegis128_decrypt_chunk_simd(struct aegis_state *state, u8 *dst,
 					const u8 *src, unsigned int size);
+void crypto_aegis128_final_simd(struct aegis_state *state,
+				union aegis_block *tag_xor,
+				u64 assoclen, u64 cryptlen);
 
 static void crypto_aegis128_update(struct aegis_state *state)
 {
@@ -395,17 +401,21 @@ static int crypto_aegis128_encrypt(struct aead_request *req)
 	struct skcipher_walk walk;
 	struct aegis_state state;
 
-	crypto_aegis128_init(&state, &ctx->key, req->iv);
-	crypto_aegis128_process_ad(&state, req->src, req->assoclen);
-
 	skcipher_walk_aead_encrypt(&walk, req, false);
-	if (aegis128_do_simd())
+	if (aegis128_do_simd()) {
+		crypto_aegis128_init_simd(&state, &ctx->key, req->iv);
+		crypto_aegis128_process_ad(&state, req->src, req->assoclen);
 		crypto_aegis128_process_crypt(&state, req, &walk,
 					      crypto_aegis128_encrypt_chunk_simd);
-	else
+		crypto_aegis128_final_simd(&state, &tag, req->assoclen,
+					   cryptlen);
+	} else {
+		crypto_aegis128_init(&state, &ctx->key, req->iv);
+		crypto_aegis128_process_ad(&state, req->src, req->assoclen);
 		crypto_aegis128_process_crypt(&state, req, &walk,
 					      crypto_aegis128_encrypt_chunk);
-	crypto_aegis128_final(&state, &tag, req->assoclen, cryptlen);
+		crypto_aegis128_final(&state, &tag, req->assoclen, cryptlen);
+	}
 
 	scatterwalk_map_and_copy(tag.bytes, req->dst, req->assoclen + cryptlen,
 				 authsize, 1);
@@ -426,17 +436,21 @@ static int crypto_aegis128_decrypt(struct aead_request *req)
 	scatterwalk_map_and_copy(tag.bytes, req->src, req->assoclen + cryptlen,
 				 authsize, 0);
 
-	crypto_aegis128_init(&state, &ctx->key, req->iv);
-	crypto_aegis128_process_ad(&state, req->src, req->assoclen);
-
 	skcipher_walk_aead_decrypt(&walk, req, false);
-	if (aegis128_do_simd())
+	if (aegis128_do_simd()) {
+		crypto_aegis128_init_simd(&state, &ctx->key, req->iv);
+		crypto_aegis128_process_ad(&state, req->src, req->assoclen);
 		crypto_aegis128_process_crypt(&state, req, &walk,
 					      crypto_aegis128_decrypt_chunk_simd);
-	else
+		crypto_aegis128_final_simd(&state, &tag, req->assoclen,
+					   cryptlen);
+	} else {
+		crypto_aegis128_init(&state, &ctx->key, req->iv);
+		crypto_aegis128_process_ad(&state, req->src, req->assoclen);
 		crypto_aegis128_process_crypt(&state, req, &walk,
 					      crypto_aegis128_decrypt_chunk);
-	crypto_aegis128_final(&state, &tag, req->assoclen, cryptlen);
+		crypto_aegis128_final(&state, &tag, req->assoclen, cryptlen);
+	}
 
 	return crypto_memneq(tag.bytes, zeros, authsize) ? -EBADMSG : 0;
 }
diff --git a/crypto/aegis128-neon-inner.c b/crypto/aegis128-neon-inner.c
index f05310ca22aa..2a660ac1bc3a 100644
--- a/crypto/aegis128-neon-inner.c
+++ b/crypto/aegis128-neon-inner.c
@@ -132,6 +132,36 @@ void preload_sbox(void)
 	    :: "r"(crypto_aes_sbox));
 }
 
+void crypto_aegis128_init_neon(void *state, const void *key, const void *iv)
+{
+	static const uint8_t const0[] = {
+		0x00, 0x01, 0x01, 0x02, 0x03, 0x05, 0x08, 0x0d,
+		0x15, 0x22, 0x37, 0x59, 0x90, 0xe9, 0x79, 0x62,
+	};
+	static const uint8_t const1[] = {
+		0xdb, 0x3d, 0x18, 0x55, 0x6d, 0xc2, 0x2f, 0xf1,
+		0x20, 0x11, 0x31, 0x42, 0x73, 0xb5, 0x28, 0xdd,
+	};
+	uint8x16_t k = vld1q_u8(key);
+	uint8x16_t kiv = k ^ vld1q_u8(iv);
+	struct aegis128_state st = {{
+		kiv,
+		vld1q_u8(const1),
+		vld1q_u8(const0),
+		k ^ vld1q_u8(const0),
+		k ^ vld1q_u8(const1),
+	}};
+	int i;
+
+	preload_sbox();
+
+	for (i = 0; i < 5; i++) {
+		st = aegis128_update_neon(st, k);
+		st = aegis128_update_neon(st, kiv);
+	}
+	aegis128_save_state_neon(st, state);
+}
+
 void crypto_aegis128_update_neon(void *state, const void *msg)
 {
 	struct aegis128_state st = aegis128_load_state_neon(state);
@@ -210,3 +240,23 @@ void crypto_aegis128_decrypt_chunk_neon(void *state, void *dst, const void *src,
 
 	aegis128_save_state_neon(st, state);
 }
+
+void crypto_aegis128_final_neon(void *state, void *tag_xor, uint64_t assoclen,
+				uint64_t cryptlen)
+{
+	struct aegis128_state st = aegis128_load_state_neon(state);
+	uint8x16_t v;
+	int i;
+
+	preload_sbox();
+
+	v = st.v[3] ^ (uint8x16_t)vcombine_u64(vmov_n_u64(8 * assoclen),
+					       vmov_n_u64(8 * cryptlen));
+
+	for (i = 0; i < 7; i++)
+		st = aegis128_update_neon(st, v);
+
+	v = vld1q_u8(tag_xor);
+	v ^= st.v[0] ^ st.v[1] ^ st.v[2] ^ st.v[3] ^ st.v[4];
+	vst1q_u8(tag_xor, v);
+}
diff --git a/crypto/aegis128-neon.c b/crypto/aegis128-neon.c
index 751f9c195aa4..8271b1fa0fbc 100644
--- a/crypto/aegis128-neon.c
+++ b/crypto/aegis128-neon.c
@@ -8,11 +8,14 @@
 
 #include "aegis.h"
 
+void crypto_aegis128_init_neon(void *state, const void *key, const void *iv);
 void crypto_aegis128_update_neon(void *state, const void *msg);
 void crypto_aegis128_encrypt_chunk_neon(void *state, void *dst, const void *src,
 					unsigned int size);
 void crypto_aegis128_decrypt_chunk_neon(void *state, void *dst, const void *src,
 					unsigned int size);
+void crypto_aegis128_final_neon(void *state, void *tag_xor, uint64_t assoclen,
+				uint64_t cryptlen);
 
 int aegis128_have_aes_insn __ro_after_init;
 
@@ -25,6 +28,15 @@ bool crypto_aegis128_have_simd(void)
 	return IS_ENABLED(CONFIG_ARM64);
 }
 
+void crypto_aegis128_init_simd(union aegis_block *state,
+			       const union aegis_block *key,
+			       const u8 *iv)
+{
+	kernel_neon_begin();
+	crypto_aegis128_init_neon(state, key, iv);
+	kernel_neon_end();
+}
+
 void crypto_aegis128_update_simd(union aegis_block *state, const void *msg)
 {
 	kernel_neon_begin();
@@ -47,3 +59,12 @@ void crypto_aegis128_decrypt_chunk_simd(union aegis_block *state, u8 *dst,
 	crypto_aegis128_decrypt_chunk_neon(state, dst, src, size);
 	kernel_neon_end();
 }
+
+void crypto_aegis128_final_simd(union aegis_block *state,
+				union aegis_block *tag_xor,
+				u64 assoclen, u64 cryptlen)
+{
+	kernel_neon_begin();
+	crypto_aegis128_final_neon(state, tag_xor, assoclen, cryptlen);
+	kernel_neon_end();
+}
-- 
2.20.1

