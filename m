Return-Path: <SRS0=ziyG=YE=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 42122C47404
	for <linux-crypto@archiver.kernel.org>; Fri, 11 Oct 2019 17:09:35 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 141D6214E0
	for <linux-crypto@archiver.kernel.org>; Fri, 11 Oct 2019 17:09:35 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="AbwEIQB3"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728449AbfJKRJe (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 11 Oct 2019 13:09:34 -0400
Received: from mail-wr1-f68.google.com ([209.85.221.68]:35059 "EHLO
        mail-wr1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728086AbfJKRJe (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 11 Oct 2019 13:09:34 -0400
Received: by mail-wr1-f68.google.com with SMTP id v8so12754235wrt.2
        for <linux-crypto@vger.kernel.org>; Fri, 11 Oct 2019 10:09:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=tKcWa8kiCmuQGLJUVnadD6vpBI/OKGXQya0413QFYWE=;
        b=AbwEIQB37g1f04wuqsM97MyCuc35DWJL8ZCKfdWIOwtQn3ocjNaf5rPNNLr0dtl/h7
         +hJvre0mj01P8zRciGlQ7nxOPjp2nkeN2R5HuY1hV4QrggO8cTOwXC0FXhpeYSQoG/3r
         CGrmga21odEtNf6IYWiBbXUC5hnQRG9G8PmnsFuIOznnuuhzWhj5t4IIyHqtDvp89RFY
         TCeWLYLxaN/I++IBymsejrniYKHgPGH2uTM5pmhOzfxFhSYCShrhOpfnk657PpdcUK80
         E2kfb4u5elGOZyemRd7rxYIHZIvcbH4Q65XJjIwxYqQ66WHE+mV/pg60ufnF6/GoBiJB
         bMHA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=tKcWa8kiCmuQGLJUVnadD6vpBI/OKGXQya0413QFYWE=;
        b=gf+zrIVztOUmfYw6FxILayDrmQ3KLhitETwyp56M/gg8eWnunkh2I3S2JpL5e/JUWM
         aELJxMms5aL7WOgUDHudZa3z+X6ygOz45rF0jik+z3FMr6I51S0b02ctV2XBB4+zxzZ/
         HIz+g0d8/7tzAuZFTop39brTkaD0Zs/VJqnRxntprHo7xJMldaI7+Bn+OBCZMR2roHxy
         kbrG5HzT5rIzCLGhCR4lqQ0RHmek5d72sNd4S5GcPnDZ9KO1zmcg7wd/v3VYJPIpTx+/
         Hq8ioZ4uqO88JqxhztOIke05QCkyPAkdd5MAl/Y4QPRnHXxRR16Q6k5wiC5VzBC0kcv8
         nxUw==
X-Gm-Message-State: APjAAAUdDH4FHuE587CJXaZzL6da9j8W8zcdC0Fkdw8E98yEowoxbWs4
        71WCt+f4aOasOM9HuNOqBFEjBGxePU6/+g==
X-Google-Smtp-Source: APXvYqxY3qHWRYIaXSoDLi4qk+VvGdqQk21dysGqo4N7ySiaAiXxVg5jLIDOVni+KGW4XmiMX+bRYw==
X-Received: by 2002:a5d:4ec1:: with SMTP id s1mr13562167wrv.42.1570813770511;
        Fri, 11 Oct 2019 10:09:30 -0700 (PDT)
Received: from localhost.localdomain (91-167-84-221.subs.proxad.net. [91.167.84.221])
        by smtp.gmail.com with ESMTPSA id f9sm11876875wre.74.2019.10.11.10.09.29
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 11 Oct 2019 10:09:29 -0700 (PDT)
From:   Ard Biesheuvel <ard.biesheuvel@linaro.org>
To:     linux-crypto@vger.kernel.org
Cc:     linux-arm-kernel@lists.infradead.org, herbert@gondor.apana.org.au,
        Ard Biesheuvel <ard.biesheuvel@linaro.org>
Subject: [PATCH 2/2] crypto: aegis128 - duplicate init() and final() hooks in SIMD code
Date:   Fri, 11 Oct 2019 19:08:23 +0200
Message-Id: <20191011170823.6713-3-ard.biesheuvel@linaro.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20191011170823.6713-1-ard.biesheuvel@linaro.org>
References: <20191011170823.6713-1-ard.biesheuvel@linaro.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

In order to speed up aegis128 processing even more, duplicate the init()
and final() routines as SIMD versions in their entirety. This results
in a 2x speedup on ARM Cortex-A57 for ~1500 byte inputs (using AES
instructions).

Signed-off-by: Ard Biesheuvel <ard.biesheuvel@linaro.org>
---
 crypto/aegis128-core.c       | 38 ++++++++++-----
 crypto/aegis128-neon-inner.c | 49 ++++++++++++++++++++
 crypto/aegis128-neon.c       | 22 +++++++++
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
index f05310ca22aa..16d2e806eb47 100644
--- a/crypto/aegis128-neon-inner.c
+++ b/crypto/aegis128-neon-inner.c
@@ -132,6 +132,34 @@ void preload_sbox(void)
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
@@ -210,3 +238,24 @@ void crypto_aegis128_decrypt_chunk_neon(void *state, void *dst, const void *src,
 
 	aegis128_save_state_neon(st, state);
 }
+
+void crypto_aegis128_final_neon(void *state, void *tag_xor,
+				uint64_t assocbits, uint64_t cryptbits)
+{
+	struct aegis128_state st = aegis128_load_state_neon(state);
+	union {
+		uint64_t	pair[2];
+		uint8x16_t	v;
+	} t = {{ assocbits, cryptbits }};
+	uint8x16_t tag;
+	int i;
+
+	t.v ^= st.v[3];
+
+	for (i = 0; i < 7; i++)
+		st = aegis128_update_neon(st, t.v);
+
+	tag = vld1q_u8(tag_xor);
+	tag ^= st.v[0] ^ st.v[1] ^ st.v[2] ^ st.v[3] ^ st.v[4];
+	vst1q_u8(tag_xor, tag);
+}
diff --git a/crypto/aegis128-neon.c b/crypto/aegis128-neon.c
index 751f9c195aa4..5b37b04b8ad4 100644
--- a/crypto/aegis128-neon.c
+++ b/crypto/aegis128-neon.c
@@ -8,11 +8,14 @@
 
 #include "aegis.h"
 
+void crypto_aegis128_init_neon(void *state, const void *key, const u8 *iv);
 void crypto_aegis128_update_neon(void *state, const void *msg);
 void crypto_aegis128_encrypt_chunk_neon(void *state, void *dst, const void *src,
 					unsigned int size);
 void crypto_aegis128_decrypt_chunk_neon(void *state, void *dst, const void *src,
 					unsigned int size);
+void crypto_aegis128_final_neon(void *state, void *tag_xor,
+				uint64_t assocbits, uint64_t cryptbits);
 
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
@@ -47,3 +59,13 @@ void crypto_aegis128_decrypt_chunk_simd(union aegis_block *state, u8 *dst,
 	crypto_aegis128_decrypt_chunk_neon(state, dst, src, size);
 	kernel_neon_end();
 }
+
+void crypto_aegis128_final_simd(union aegis_block *state,
+				union aegis_block *tag_xor,
+				u64 assoclen, u64 cryptlen)
+{
+	kernel_neon_begin();
+	crypto_aegis128_final_neon(state, tag_xor, cpu_to_le64(8 * assoclen),
+				   cpu_to_le64(8 * cryptlen));
+	kernel_neon_end();
+}
-- 
2.20.1

