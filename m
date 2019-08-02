Return-Path: <SRS0=PsuD=V6=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.9 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1D73DC32753
	for <linux-crypto@archiver.kernel.org>; Fri,  2 Aug 2019 15:15:38 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id DE09B21726
	for <linux-crypto@archiver.kernel.org>; Fri,  2 Aug 2019 15:15:37 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="xAV1eWOX"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726043AbfHBPPh (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 2 Aug 2019 11:15:37 -0400
Received: from mail-wr1-f65.google.com ([209.85.221.65]:39972 "EHLO
        mail-wr1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728719AbfHBPPg (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 2 Aug 2019 11:15:36 -0400
Received: by mail-wr1-f65.google.com with SMTP id r1so77523917wrl.7
        for <linux-crypto@vger.kernel.org>; Fri, 02 Aug 2019 08:15:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=WBpXCKjdfq1yPU+OJBvQfW6gPuB8RZ7Tc8kFP902ZIM=;
        b=xAV1eWOXnKSlyjUUvRgQczTqwhWrBaoCDZpN2QvpQFkUN5fWbg0w46FwfkU4HxyzWJ
         Its1EPcaWIbX23Dw7v9IphRu1JxcNgVEsDjjOc5F9C8EPW/HLBZAk+vMQvaMqiG79tJ/
         FjfAtHvxSr8y4AJE321zj8RzdXGeqLF1Jju1UW0epWiHjo32SIAezDBQs8wA37ffThoH
         XXtqhONDI8bgRvzrRJNypLOQQUolWdYQdkwNJ6dn1YtM92t/fvz9qmBaFy2RFnKg6q+Q
         ggYy5epCLi3BG4/INN0u/4fAYr0hasfZlpM0vBXfIc26aL6/H03EgxavxHzh/N6zdVl8
         6xUQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=WBpXCKjdfq1yPU+OJBvQfW6gPuB8RZ7Tc8kFP902ZIM=;
        b=jWqk3bNNAJcWTR2qLDE+zZHYMYuYeM6vtDsBE7iWJbDKF/+Skp+jBLltOHBDQ+9vfu
         m6bhsmIvGrj7AMMNlXmrKySTxaEg9/9s4sIGux11qAQ26OaVYVTNlL+v0MnPEYdGjZ5k
         tlySbJ5gkE4lYmiK7VhzH6bz+dTH7guOoYKdaGPEui1FQhdQ2i5tlM983hxVO9QiRGH3
         N4rZ3uqKKEgPW9qdOmyVEqi6pvvw2mkR9qeQidw5ROKA69VC41Aej4SjJtkEWnWE++nA
         TRTqqCWO1+eWtPACgg9QIEXqhvxjcgo7XdwAryrgBJChOHsuBsxxssk5qZMRaj5X9dg6
         i4ng==
X-Gm-Message-State: APjAAAXsszRF+Iek+jsFwcM8YkIXmNJFIFd+3dvB8z589fS+ZuVcUSWK
        Jqym1jKsvrI6+T+dFU36E6BilHoeBrvRsg==
X-Google-Smtp-Source: APXvYqx1VZyrzud4LFLAsIkPbAiZprbq1Hht9eMYEiZcNUN7CL0zbAYG+dUodFq8V/Df0HuKGicBVg==
X-Received: by 2002:a5d:668e:: with SMTP id l14mr89119870wru.156.1564758934848;
        Fri, 02 Aug 2019 08:15:34 -0700 (PDT)
Received: from localhost.localdomain ([2a02:587:a424:b400:cc84:8d83:a434:dd7])
        by smtp.gmail.com with ESMTPSA id o3sm63294321wrs.59.2019.08.02.08.15.33
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Fri, 02 Aug 2019 08:15:34 -0700 (PDT)
From:   Ard Biesheuvel <ard.biesheuvel@linaro.org>
To:     linux-crypto@vger.kernel.org
Cc:     herbert@gondor.apana.org.au, ebiggers@kernel.org,
        Ard Biesheuvel <ard.biesheuvel@linaro.org>
Subject: [PATCH resend 1/3] crypto: aegis128 - add support for SIMD acceleration
Date:   Fri,  2 Aug 2019 18:15:08 +0300
Message-Id: <20190802151510.17074-2-ard.biesheuvel@linaro.org>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20190802151510.17074-1-ard.biesheuvel@linaro.org>
References: <20190802151510.17074-1-ard.biesheuvel@linaro.org>
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Add some plumbing to allow the AEGIS128 code to be built with SIMD
routines for acceleration.

Reviewed-by: Ondrej Mosnacek <omosnace@redhat.com>
Signed-off-by: Ard Biesheuvel <ard.biesheuvel@linaro.org>
Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
---
 crypto/Makefile                        |  1 +
 crypto/{aegis128.c => aegis128-core.c} | 52 ++++++++++++++++++--
 2 files changed, 49 insertions(+), 4 deletions(-)

diff --git a/crypto/Makefile b/crypto/Makefile
index cfcc954e59f9..92e985714ff6 100644
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
diff --git a/crypto/aegis128.c b/crypto/aegis128-core.c
similarity index 89%
rename from crypto/aegis128.c
rename to crypto/aegis128-core.c
index 32840d5e7f65..fa69e99968e2 100644
--- a/crypto/aegis128.c
+++ b/crypto/aegis128-core.c
@@ -8,6 +8,7 @@
 
 #include <crypto/algapi.h>
 #include <crypto/internal/aead.h>
+#include <crypto/internal/simd.h>
 #include <crypto/internal/skcipher.h>
 #include <crypto/scatterwalk.h>
 #include <linux/err.h>
@@ -16,6 +17,8 @@
 #include <linux/module.h>
 #include <linux/scatterlist.h>
 
+#include <asm/simd.h>
+
 #include "aegis.h"
 
 #define AEGIS128_NONCE_SIZE 16
@@ -40,6 +43,24 @@ struct aegis128_ops {
 			    const u8 *src, unsigned int size);
 };
 
+static bool have_simd;
+
+static bool aegis128_do_simd(void)
+{
+#ifdef CONFIG_CRYPTO_AEGIS128_SIMD
+	if (have_simd)
+		return crypto_simd_usable();
+#endif
+	return false;
+}
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
@@ -55,12 +76,22 @@ static void crypto_aegis128_update(struct aegis_state *state)
 static void crypto_aegis128_update_a(struct aegis_state *state,
 				     const union aegis_block *msg)
 {
+	if (aegis128_do_simd()) {
+		crypto_aegis128_update_simd(state, msg);
+		return;
+	}
+
 	crypto_aegis128_update(state);
 	crypto_aegis_block_xor(&state->blocks[0], msg);
 }
 
 static void crypto_aegis128_update_u(struct aegis_state *state, const void *msg)
 {
+	if (aegis128_do_simd()) {
+		crypto_aegis128_update_simd(state, msg);
+		return;
+	}
+
 	crypto_aegis128_update(state);
 	crypto_xor(state->blocks[0].bytes, msg, AEGIS_BLOCK_SIZE);
 }
@@ -365,7 +396,7 @@ static void crypto_aegis128_crypt(struct aead_request *req,
 
 static int crypto_aegis128_encrypt(struct aead_request *req)
 {
-	static const struct aegis128_ops ops = {
+	const struct aegis128_ops *ops = &(struct aegis128_ops){
 		.skcipher_walk_init = skcipher_walk_aead_encrypt,
 		.crypt_chunk = crypto_aegis128_encrypt_chunk,
 	};
@@ -375,7 +406,12 @@ static int crypto_aegis128_encrypt(struct aead_request *req)
 	unsigned int authsize = crypto_aead_authsize(tfm);
 	unsigned int cryptlen = req->cryptlen;
 
-	crypto_aegis128_crypt(req, &tag, cryptlen, &ops);
+	if (aegis128_do_simd())
+		ops = &(struct aegis128_ops){
+			.skcipher_walk_init = skcipher_walk_aead_encrypt,
+			.crypt_chunk = crypto_aegis128_encrypt_chunk_simd };
+
+	crypto_aegis128_crypt(req, &tag, cryptlen, ops);
 
 	scatterwalk_map_and_copy(tag.bytes, req->dst, req->assoclen + cryptlen,
 				 authsize, 1);
@@ -384,7 +420,7 @@ static int crypto_aegis128_encrypt(struct aead_request *req)
 
 static int crypto_aegis128_decrypt(struct aead_request *req)
 {
-	static const struct aegis128_ops ops = {
+	const struct aegis128_ops *ops = &(struct aegis128_ops){
 		.skcipher_walk_init = skcipher_walk_aead_decrypt,
 		.crypt_chunk = crypto_aegis128_decrypt_chunk,
 	};
@@ -398,7 +434,12 @@ static int crypto_aegis128_decrypt(struct aead_request *req)
 	scatterwalk_map_and_copy(tag.bytes, req->src, req->assoclen + cryptlen,
 				 authsize, 0);
 
-	crypto_aegis128_crypt(req, &tag, cryptlen, &ops);
+	if (aegis128_do_simd())
+		ops = &(struct aegis128_ops){
+			.skcipher_walk_init = skcipher_walk_aead_decrypt,
+			.crypt_chunk = crypto_aegis128_decrypt_chunk_simd };
+
+	crypto_aegis128_crypt(req, &tag, cryptlen, ops);
 
 	return crypto_memneq(tag.bytes, zeros, authsize) ? -EBADMSG : 0;
 }
@@ -429,6 +470,9 @@ static struct aead_alg crypto_aegis128_alg = {
 
 static int __init crypto_aegis128_module_init(void)
 {
+	if (IS_ENABLED(CONFIG_CRYPTO_AEGIS128_SIMD))
+		have_simd = crypto_aegis128_have_simd();
+
 	return crypto_register_aead(&crypto_aegis128_alg);
 }
 
-- 
2.17.1

