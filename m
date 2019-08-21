Return-Path: <SRS0=bUM2=WR=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 255B6C3A59E
	for <linux-crypto@archiver.kernel.org>; Wed, 21 Aug 2019 14:33:05 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id E59CE22D6D
	for <linux-crypto@archiver.kernel.org>; Wed, 21 Aug 2019 14:33:04 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="IvQZirvy"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729168AbfHUOdE (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Wed, 21 Aug 2019 10:33:04 -0400
Received: from mail-wr1-f68.google.com ([209.85.221.68]:43926 "EHLO
        mail-wr1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728502AbfHUOdE (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 21 Aug 2019 10:33:04 -0400
Received: by mail-wr1-f68.google.com with SMTP id y8so2250988wrn.10
        for <linux-crypto@vger.kernel.org>; Wed, 21 Aug 2019 07:33:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=Fx4v5+pxRWU+v+BvHaZkcgPS3e4c7qTcjz3iyucazFw=;
        b=IvQZirvyJq+P+RO21JYYEshDe40ZRa0jFKH1cYxsPk7TjxNNCj7KKaBNe4aDRU1Cxf
         mQ+dceQbd3wVjhIg4672OGMrtz5Ylrk9qmjE8yl45zFDyly7En2pYw1juxGWNRImmijy
         iQhTGH4ohQuVsDANA+r/+FOhrXSs9l/46QPqPXo523RfEA3kWJocvQgkcLDdecAKtFFt
         7732r1Kb/JkmNrvWbKNvbac1KGGUlCq0h7MOJoWU2J7c/bYb2r7MSIjNJzNu6b+DxtCq
         qMt8dEAzroTsMUOg5SFunX7+iTcsinCc9am7R5Lkas4DFrhRbfSCZqtpXxVynDFecTeg
         Hfsw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=Fx4v5+pxRWU+v+BvHaZkcgPS3e4c7qTcjz3iyucazFw=;
        b=CQ/1SDoZraz+VIup2ds/FTfy+VueDRHlNQuxnJg4jQ0g+sloRBPqz3BRH7YU6W+lR8
         y9H8+UXxsJ7t3k1jKb3THqk3V9AcXXwdWOLGZ4Qbvm0E7Ie8gWJwRm8jWvIKq++oqDEV
         qUc+lli9kf6GIQq9QTbGsiEy8GLgU+vDQh7KJvkd8FjnPOg4vsF0bfdjL9nixxXw/TXn
         iU22ItT+CJ85yhlTW5EKOA9cLfGSc5c58vbOAaw5Qn60Cb8qhhevLQXqDxKjbrTkCrSW
         Zm5bFWHp0ut2QTxQUfSTKRApZe+RVaUtZczyqMl20QFNUDYpj7OqdNHfJLecZabU6Nlf
         EOBw==
X-Gm-Message-State: APjAAAULHAKwaPPuCtZn49bk60VcHwyfssb3ae0+Xuhw7RFGWqEErWA5
        CIufVbujI1OAAqpm8s38g7EosaVzbgyZlA==
X-Google-Smtp-Source: APXvYqwaYWQc8kr8UzJ3Ogvk12RTYdcdbdwS9VgbT3OylC+j4Uk7LdDy8iSWg0PIIWP0QeCeTNSyBw==
X-Received: by 2002:adf:ef48:: with SMTP id c8mr254746wrp.103.1566397981312;
        Wed, 21 Aug 2019 07:33:01 -0700 (PDT)
Received: from mba13.lan (adsl-103.109.242.1.tellas.gr. [109.242.1.103])
        by smtp.gmail.com with ESMTPSA id 16sm181427wmx.45.2019.08.21.07.32.59
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 21 Aug 2019 07:33:00 -0700 (PDT)
From:   Ard Biesheuvel <ard.biesheuvel@linaro.org>
To:     linux-crypto@vger.kernel.org
Cc:     herbert@gondor.apana.org.au, ebiggers@kernel.org,
        Ard Biesheuvel <ard.biesheuvel@linaro.org>
Subject: [PATCH 01/17] crypto: arm/aes - fix round key prototypes
Date:   Wed, 21 Aug 2019 17:32:37 +0300
Message-Id: <20190821143253.30209-2-ard.biesheuvel@linaro.org>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20190821143253.30209-1-ard.biesheuvel@linaro.org>
References: <20190821143253.30209-1-ard.biesheuvel@linaro.org>
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

