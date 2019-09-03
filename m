Return-Path: <SRS0=7iXC=W6=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 77302C3A5A2
	for <linux-crypto@archiver.kernel.org>; Tue,  3 Sep 2019 16:43:46 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 48C2F22CED
	for <linux-crypto@archiver.kernel.org>; Tue,  3 Sep 2019 16:43:46 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="Sb9MFKJ0"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729944AbfICQnp (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Tue, 3 Sep 2019 12:43:45 -0400
Received: from mail-pg1-f193.google.com ([209.85.215.193]:44396 "EHLO
        mail-pg1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728854AbfICQnp (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 3 Sep 2019 12:43:45 -0400
Received: by mail-pg1-f193.google.com with SMTP id i18so9438172pgl.11
        for <linux-crypto@vger.kernel.org>; Tue, 03 Sep 2019 09:43:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=Fx4v5+pxRWU+v+BvHaZkcgPS3e4c7qTcjz3iyucazFw=;
        b=Sb9MFKJ0VTpOMdAaIDKGLEN+urYU1FAvCQhGv/1iiAcyuNVIQMlvPFbQ+yRPi5z6ol
         6OeVX4iSO586BHzUEODaOlIuiFizylSW1+gBRQxVWNIRRIUIgn87cQyvOqF/u0kEuyWN
         vaCv5vqLI9So4WFmkSt8DOHreep0kuyCh8tjWNi9+r4oDzyHwr+dmXWlf1wcu2qzY+5A
         fNa2Pa0HVP6hW6WHfgxE80lizQTHIsIWwDFLzv/IOJBip+iRpGGbfMPu0x1Pm5u/Q/w2
         p3fxjKyJhkkLiSqutDXWWDU/BEZDJxyfaBw6/8E3ia8hWGtetmVl9/zpusL3rU6nhgC2
         fhpg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=Fx4v5+pxRWU+v+BvHaZkcgPS3e4c7qTcjz3iyucazFw=;
        b=Nr7MSU/QZFx9xZ2ntbI2Ln9Ehr2X9UW6n+1RllhpE/QeEswQTeSQrCPCOcxcKHV6yo
         w44EPwt/scpH9PC30WoGp4mcvDJ9aNUrcMGBUAzcLebsQb8+gExfSCikfVXI78ZZKUaj
         MzkHSKV6Mto7/lbiTkUGuwKDf0NGvQYEsN3XUOssMJHnbU8AT4hD5hqtpsHQr0RXbPcz
         5e5aRwKL07vjHvw+QOajkc1ZTgUe1GNsgmQtxil2U7OVwegV+4FVCX5kDPMxz3s2gj1z
         aDqK++JqdTjEx7g6mBNPZm1c3o+AUbAwwUfhc3ZDm+07AfeTRF9snxqnDQ78bP3dcGIM
         ic9A==
X-Gm-Message-State: APjAAAWPpbImezCiltxqcjERi1KlwSoYo207qlRw7qCeL20V+gjabRA+
        bK8g0nCjXFzTF7+IS0EtWHkLEiNt3y33K9GN
X-Google-Smtp-Source: APXvYqzdAm4G62gCcPN3By7wR8crgVsVVrtsyuyIy5HaTQ7EFL9d7mHhnE6nK1rhrcb9ZXW0CDRISw==
X-Received: by 2002:a63:2a08:: with SMTP id q8mr30781007pgq.415.1567529024176;
        Tue, 03 Sep 2019 09:43:44 -0700 (PDT)
Received: from e111045-lin.nice.arm.com ([104.133.8.102])
        by smtp.gmail.com with ESMTPSA id b126sm20311847pfb.110.2019.09.03.09.43.42
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 03 Sep 2019 09:43:43 -0700 (PDT)
From:   Ard Biesheuvel <ard.biesheuvel@linaro.org>
To:     linux-crypto@vger.kernel.org
Cc:     herbert@gondor.apana.org.au, ebiggers@kernel.org,
        Ard Biesheuvel <ard.biesheuvel@linaro.org>
Subject: [PATCH v2 01/17] crypto: arm/aes - fix round key prototypes
Date:   Tue,  3 Sep 2019 09:43:23 -0700
Message-Id: <20190903164339.27984-2-ard.biesheuvel@linaro.org>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20190903164339.27984-1-ard.biesheuvel@linaro.org>
References: <20190903164339.27984-1-ard.biesheuvel@linaro.org>
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

The AES round keys are arrays of u32s in native endianness now, so
update the function prototypes accordingly.

Signed-off-by: Ard Biesheuvel <ard.biesheuvel@linaro.org>
---
 arch/arm/crypto/aes-ce-core.S | 18 ++++-----
 arch/arm/crypto/aes-ce-glue.c | 40 ++++++++++----------
 2 files changed, 29 insertions(+), 29 deletions(-)

diff --git a/arch/arm/crypto/aes-ce-core.S b/arch/arm/crypto/aes-ce-core.S
index 425000232d49..1e0d45183590 100644
--- a/arch/arm/crypto/aes-ce-core.S
+++ b/arch/arm/crypto/aes-ce-core.S
@@ -154,9 +154,9 @@ ENDPROC(aes_decrypt_3x)
 	.endm
 
 	/*
-	 * aes_ecb_encrypt(u8 out[], u8 const in[], u8 const rk[], int rounds,
+	 * aes_ecb_encrypt(u8 out[], u8 const in[], u32 const rk[], int rounds,
 	 *		   int blocks)
-	 * aes_ecb_decrypt(u8 out[], u8 const in[], u8 const rk[], int rounds,
+	 * aes_ecb_decrypt(u8 out[], u8 const in[], u32 const rk[], int rounds,
 	 *		   int blocks)
 	 */
 ENTRY(ce_aes_ecb_encrypt)
@@ -212,9 +212,9 @@ ENTRY(ce_aes_ecb_decrypt)
 ENDPROC(ce_aes_ecb_decrypt)
 
 	/*
-	 * aes_cbc_encrypt(u8 out[], u8 const in[], u8 const rk[], int rounds,
+	 * aes_cbc_encrypt(u8 out[], u8 const in[], u32 const rk[], int rounds,
 	 *		   int blocks, u8 iv[])
-	 * aes_cbc_decrypt(u8 out[], u8 const in[], u8 const rk[], int rounds,
+	 * aes_cbc_decrypt(u8 out[], u8 const in[], u32 const rk[], int rounds,
 	 *		   int blocks, u8 iv[])
 	 */
 ENTRY(ce_aes_cbc_encrypt)
@@ -272,7 +272,7 @@ ENTRY(ce_aes_cbc_decrypt)
 ENDPROC(ce_aes_cbc_decrypt)
 
 	/*
-	 * aes_ctr_encrypt(u8 out[], u8 const in[], u8 const rk[], int rounds,
+	 * aes_ctr_encrypt(u8 out[], u8 const in[], u32 const rk[], int rounds,
 	 *		   int blocks, u8 ctr[])
 	 */
 ENTRY(ce_aes_ctr_encrypt)
@@ -349,10 +349,10 @@ ENTRY(ce_aes_ctr_encrypt)
 ENDPROC(ce_aes_ctr_encrypt)
 
 	/*
-	 * aes_xts_encrypt(u8 out[], u8 const in[], u8 const rk1[], int rounds,
-	 *		   int blocks, u8 iv[], u8 const rk2[], int first)
-	 * aes_xts_decrypt(u8 out[], u8 const in[], u8 const rk1[], int rounds,
-	 *		   int blocks, u8 iv[], u8 const rk2[], int first)
+	 * aes_xts_encrypt(u8 out[], u8 const in[], u32 const rk1[], int rounds,
+	 *		   int blocks, u8 iv[], u32 const rk2[], int first)
+	 * aes_xts_decrypt(u8 out[], u8 const in[], u32 const rk1[], int rounds,
+	 *		   int blocks, u8 iv[], u32 const rk2[], int first)
 	 */
 
 	.macro		next_tweak, out, in, const, tmp
diff --git a/arch/arm/crypto/aes-ce-glue.c b/arch/arm/crypto/aes-ce-glue.c
index a7265d0a7063..75d2ff03a63e 100644
--- a/arch/arm/crypto/aes-ce-glue.c
+++ b/arch/arm/crypto/aes-ce-glue.c
@@ -25,25 +25,25 @@ MODULE_LICENSE("GPL v2");
 asmlinkage u32 ce_aes_sub(u32 input);
 asmlinkage void ce_aes_invert(void *dst, void *src);
 
-asmlinkage void ce_aes_ecb_encrypt(u8 out[], u8 const in[], u8 const rk[],
+asmlinkage void ce_aes_ecb_encrypt(u8 out[], u8 const in[], u32 const rk[],
 				   int rounds, int blocks);
-asmlinkage void ce_aes_ecb_decrypt(u8 out[], u8 const in[], u8 const rk[],
+asmlinkage void ce_aes_ecb_decrypt(u8 out[], u8 const in[], u32 const rk[],
 				   int rounds, int blocks);
 
-asmlinkage void ce_aes_cbc_encrypt(u8 out[], u8 const in[], u8 const rk[],
+asmlinkage void ce_aes_cbc_encrypt(u8 out[], u8 const in[], u32 const rk[],
 				   int rounds, int blocks, u8 iv[]);
-asmlinkage void ce_aes_cbc_decrypt(u8 out[], u8 const in[], u8 const rk[],
+asmlinkage void ce_aes_cbc_decrypt(u8 out[], u8 const in[], u32 const rk[],
 				   int rounds, int blocks, u8 iv[]);
 
-asmlinkage void ce_aes_ctr_encrypt(u8 out[], u8 const in[], u8 const rk[],
+asmlinkage void ce_aes_ctr_encrypt(u8 out[], u8 const in[], u32 const rk[],
 				   int rounds, int blocks, u8 ctr[]);
 
-asmlinkage void ce_aes_xts_encrypt(u8 out[], u8 const in[], u8 const rk1[],
+asmlinkage void ce_aes_xts_encrypt(u8 out[], u8 const in[], u32 const rk1[],
 				   int rounds, int blocks, u8 iv[],
-				   u8 const rk2[], int first);
-asmlinkage void ce_aes_xts_decrypt(u8 out[], u8 const in[], u8 const rk1[],
+				   u32 const rk2[], int first);
+asmlinkage void ce_aes_xts_decrypt(u8 out[], u8 const in[], u32 const rk1[],
 				   int rounds, int blocks, u8 iv[],
-				   u8 const rk2[], int first);
+				   u32 const rk2[], int first);
 
 struct aes_block {
 	u8 b[AES_BLOCK_SIZE];
@@ -182,7 +182,7 @@ static int ecb_encrypt(struct skcipher_request *req)
 	kernel_neon_begin();
 	while ((blocks = (walk.nbytes / AES_BLOCK_SIZE))) {
 		ce_aes_ecb_encrypt(walk.dst.virt.addr, walk.src.virt.addr,
-				   (u8 *)ctx->key_enc, num_rounds(ctx), blocks);
+				   ctx->key_enc, num_rounds(ctx), blocks);
 		err = skcipher_walk_done(&walk, walk.nbytes % AES_BLOCK_SIZE);
 	}
 	kernel_neon_end();
@@ -202,7 +202,7 @@ static int ecb_decrypt(struct skcipher_request *req)
 	kernel_neon_begin();
 	while ((blocks = (walk.nbytes / AES_BLOCK_SIZE))) {
 		ce_aes_ecb_decrypt(walk.dst.virt.addr, walk.src.virt.addr,
-				   (u8 *)ctx->key_dec, num_rounds(ctx), blocks);
+				   ctx->key_dec, num_rounds(ctx), blocks);
 		err = skcipher_walk_done(&walk, walk.nbytes % AES_BLOCK_SIZE);
 	}
 	kernel_neon_end();
@@ -222,7 +222,7 @@ static int cbc_encrypt(struct skcipher_request *req)
 	kernel_neon_begin();
 	while ((blocks = (walk.nbytes / AES_BLOCK_SIZE))) {
 		ce_aes_cbc_encrypt(walk.dst.virt.addr, walk.src.virt.addr,
-				   (u8 *)ctx->key_enc, num_rounds(ctx), blocks,
+				   ctx->key_enc, num_rounds(ctx), blocks,
 				   walk.iv);
 		err = skcipher_walk_done(&walk, walk.nbytes % AES_BLOCK_SIZE);
 	}
@@ -243,7 +243,7 @@ static int cbc_decrypt(struct skcipher_request *req)
 	kernel_neon_begin();
 	while ((blocks = (walk.nbytes / AES_BLOCK_SIZE))) {
 		ce_aes_cbc_decrypt(walk.dst.virt.addr, walk.src.virt.addr,
-				   (u8 *)ctx->key_dec, num_rounds(ctx), blocks,
+				   ctx->key_dec, num_rounds(ctx), blocks,
 				   walk.iv);
 		err = skcipher_walk_done(&walk, walk.nbytes % AES_BLOCK_SIZE);
 	}
@@ -263,7 +263,7 @@ static int ctr_encrypt(struct skcipher_request *req)
 	kernel_neon_begin();
 	while ((blocks = (walk.nbytes / AES_BLOCK_SIZE))) {
 		ce_aes_ctr_encrypt(walk.dst.virt.addr, walk.src.virt.addr,
-				   (u8 *)ctx->key_enc, num_rounds(ctx), blocks,
+				   ctx->key_enc, num_rounds(ctx), blocks,
 				   walk.iv);
 		err = skcipher_walk_done(&walk, walk.nbytes % AES_BLOCK_SIZE);
 	}
@@ -278,8 +278,8 @@ static int ctr_encrypt(struct skcipher_request *req)
 		 */
 		blocks = -1;
 
-		ce_aes_ctr_encrypt(tail, NULL, (u8 *)ctx->key_enc,
-				   num_rounds(ctx), blocks, walk.iv);
+		ce_aes_ctr_encrypt(tail, NULL, ctx->key_enc, num_rounds(ctx),
+				   blocks, walk.iv);
 		crypto_xor_cpy(tdst, tsrc, tail, nbytes);
 		err = skcipher_walk_done(&walk, 0);
 	}
@@ -324,8 +324,8 @@ static int xts_encrypt(struct skcipher_request *req)
 	kernel_neon_begin();
 	for (first = 1; (blocks = (walk.nbytes / AES_BLOCK_SIZE)); first = 0) {
 		ce_aes_xts_encrypt(walk.dst.virt.addr, walk.src.virt.addr,
-				   (u8 *)ctx->key1.key_enc, rounds, blocks,
-				   walk.iv, (u8 *)ctx->key2.key_enc, first);
+				   ctx->key1.key_enc, rounds, blocks, walk.iv,
+				   ctx->key2.key_enc, first);
 		err = skcipher_walk_done(&walk, walk.nbytes % AES_BLOCK_SIZE);
 	}
 	kernel_neon_end();
@@ -346,8 +346,8 @@ static int xts_decrypt(struct skcipher_request *req)
 	kernel_neon_begin();
 	for (first = 1; (blocks = (walk.nbytes / AES_BLOCK_SIZE)); first = 0) {
 		ce_aes_xts_decrypt(walk.dst.virt.addr, walk.src.virt.addr,
-				   (u8 *)ctx->key1.key_dec, rounds, blocks,
-				   walk.iv, (u8 *)ctx->key2.key_enc, first);
+				   ctx->key1.key_dec, rounds, blocks, walk.iv,
+				   ctx->key2.key_enc, first);
 		err = skcipher_walk_done(&walk, walk.nbytes % AES_BLOCK_SIZE);
 	}
 	kernel_neon_end();
-- 
2.17.1

