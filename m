Return-Path: <SRS0=7iXC=W6=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 33B44C3A5A2
	for <linux-crypto@archiver.kernel.org>; Tue,  3 Sep 2019 16:43:48 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 00AFA22CED
	for <linux-crypto@archiver.kernel.org>; Tue,  3 Sep 2019 16:43:48 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="BrLC5uJN"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730057AbfICQnr (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Tue, 3 Sep 2019 12:43:47 -0400
Received: from mail-pl1-f194.google.com ([209.85.214.194]:43513 "EHLO
        mail-pl1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728854AbfICQnr (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 3 Sep 2019 12:43:47 -0400
Received: by mail-pl1-f194.google.com with SMTP id 4so8119413pld.10
        for <linux-crypto@vger.kernel.org>; Tue, 03 Sep 2019 09:43:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=iouKzcU6vzz3J8Cw/jp3uuc+QHFS3Cf59HMMjSOOWbs=;
        b=BrLC5uJN4eOQS0EJ3ZdfeNolv1hkywi9MM4+6XIxCE8Yt9tSb3YBOrd5LKrmVYFSLd
         ghyuGXYVA3RuWF21bD1Fk3ifO3IScM5Tm2dCUk9H4dA2AjzsMX4VAS1XsxrFkeDNRiC1
         K7xmYTJIeSc1Mrv7Qd9wLRek6cMN8WGdWf7h/mh8MCW08A7bVttBdyxZk2sZYlqCgl/f
         reCV+gkX1LTqVLYU3GIvnJdV60QZt4BcyUk0XcERV+LMSk8pjDgRxi8vDe/PM8b6yd4q
         rKrdyMc7Mn5fpZfgNXph243dKvcVwHXmoDMNLr6qn4mH62qoqgsP68lmLE+7lVk0dK8U
         zMkA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=iouKzcU6vzz3J8Cw/jp3uuc+QHFS3Cf59HMMjSOOWbs=;
        b=H/lRM81V58JFzXHm2luSOc7PJI/eOApqtdB4yPkYej+itPFgIp3Kh1euqEp73PkwvB
         T9rF7e4DlH/C587SnWEuPeQmb3WEXupO7zeiqR2o6gbwu162/fn2stq8bSpy2jJYbLtB
         ABxSkbpRGJhGWaDi7I9pWmBQdrvSqYUlgpGkfJCQfdTAQIbOaZGcP8gtwUnQF/MNa4xa
         Mb01vtgebnOdWgA+iHx7bY0xjLh4oxy+TTS0zR9xy8lNpiMFU1iubxWAip6D3ogqoifa
         1LZfQdREgckaiohG3h2wU3k0qdMsTQ0CPCd64xFzJdAytHZ/fRmcWPiC2UXgcEe8RHb4
         7NRA==
X-Gm-Message-State: APjAAAVuGdiEOnmi4u43f2nq6VmKXQzUqVyxRvaVsreQPsD6ydi1eSRx
        uKGjD5LI+9uAZDBAaNjFP/m8Z0eii0TMiIdC
X-Google-Smtp-Source: APXvYqyglBS77KvKLzQSxxFKJC+JGrOFZMBXGPhpE79nK8Wd9c1u4DvLvkLgPjwj6mjjCH2qsHBzCw==
X-Received: by 2002:a17:902:543:: with SMTP id 61mr36243602plf.20.1567529025930;
        Tue, 03 Sep 2019 09:43:45 -0700 (PDT)
Received: from e111045-lin.nice.arm.com ([104.133.8.102])
        by smtp.gmail.com with ESMTPSA id b126sm20311847pfb.110.2019.09.03.09.43.44
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 03 Sep 2019 09:43:45 -0700 (PDT)
From:   Ard Biesheuvel <ard.biesheuvel@linaro.org>
To:     linux-crypto@vger.kernel.org
Cc:     herbert@gondor.apana.org.au, ebiggers@kernel.org,
        Ard Biesheuvel <ard.biesheuvel@linaro.org>
Subject: [PATCH v2 02/17] crypto: arm/aes-ce - yield the SIMD unit between scatterwalk steps
Date:   Tue,  3 Sep 2019 09:43:24 -0700
Message-Id: <20190903164339.27984-3-ard.biesheuvel@linaro.org>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20190903164339.27984-1-ard.biesheuvel@linaro.org>
References: <20190903164339.27984-1-ard.biesheuvel@linaro.org>
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Reduce the scope of the kernel_neon_begin/end regions so that the SIMD
unit is released (and thus preemption re-enabled) if the crypto operation
cannot be completed in a single scatterwalk step. This avoids scheduling
blackouts due to preemption being enabled for unbounded periods, resulting
in a more responsive system.

After this change, we can also permit the cipher_walk infrastructure to
sleep, so set the 'atomic' parameter to skcipher_walk_virt() to false as
well.

Signed-off-by: Ard Biesheuvel <ard.biesheuvel@linaro.org>
---
 arch/arm/crypto/aes-ce-glue.c     | 47 ++++++++++----------
 arch/arm/crypto/aes-neonbs-glue.c | 22 ++++-----
 2 files changed, 34 insertions(+), 35 deletions(-)

diff --git a/arch/arm/crypto/aes-ce-glue.c b/arch/arm/crypto/aes-ce-glue.c
index 75d2ff03a63e..486e862ae34a 100644
--- a/arch/arm/crypto/aes-ce-glue.c
+++ b/arch/arm/crypto/aes-ce-glue.c
@@ -177,15 +177,15 @@ static int ecb_encrypt(struct skcipher_request *req)
 	unsigned int blocks;
 	int err;
 
-	err = skcipher_walk_virt(&walk, req, true);
+	err = skcipher_walk_virt(&walk, req, false);
 
-	kernel_neon_begin();
 	while ((blocks = (walk.nbytes / AES_BLOCK_SIZE))) {
+		kernel_neon_begin();
 		ce_aes_ecb_encrypt(walk.dst.virt.addr, walk.src.virt.addr,
 				   ctx->key_enc, num_rounds(ctx), blocks);
+		kernel_neon_end();
 		err = skcipher_walk_done(&walk, walk.nbytes % AES_BLOCK_SIZE);
 	}
-	kernel_neon_end();
 	return err;
 }
 
@@ -197,15 +197,15 @@ static int ecb_decrypt(struct skcipher_request *req)
 	unsigned int blocks;
 	int err;
 
-	err = skcipher_walk_virt(&walk, req, true);
+	err = skcipher_walk_virt(&walk, req, false);
 
-	kernel_neon_begin();
 	while ((blocks = (walk.nbytes / AES_BLOCK_SIZE))) {
+		kernel_neon_begin();
 		ce_aes_ecb_decrypt(walk.dst.virt.addr, walk.src.virt.addr,
 				   ctx->key_dec, num_rounds(ctx), blocks);
+		kernel_neon_end();
 		err = skcipher_walk_done(&walk, walk.nbytes % AES_BLOCK_SIZE);
 	}
-	kernel_neon_end();
 	return err;
 }
 
@@ -217,16 +217,16 @@ static int cbc_encrypt(struct skcipher_request *req)
 	unsigned int blocks;
 	int err;
 
-	err = skcipher_walk_virt(&walk, req, true);
+	err = skcipher_walk_virt(&walk, req, false);
 
-	kernel_neon_begin();
 	while ((blocks = (walk.nbytes / AES_BLOCK_SIZE))) {
+		kernel_neon_begin();
 		ce_aes_cbc_encrypt(walk.dst.virt.addr, walk.src.virt.addr,
 				   ctx->key_enc, num_rounds(ctx), blocks,
 				   walk.iv);
+		kernel_neon_end();
 		err = skcipher_walk_done(&walk, walk.nbytes % AES_BLOCK_SIZE);
 	}
-	kernel_neon_end();
 	return err;
 }
 
@@ -238,16 +238,16 @@ static int cbc_decrypt(struct skcipher_request *req)
 	unsigned int blocks;
 	int err;
 
-	err = skcipher_walk_virt(&walk, req, true);
+	err = skcipher_walk_virt(&walk, req, false);
 
-	kernel_neon_begin();
 	while ((blocks = (walk.nbytes / AES_BLOCK_SIZE))) {
+		kernel_neon_begin();
 		ce_aes_cbc_decrypt(walk.dst.virt.addr, walk.src.virt.addr,
 				   ctx->key_dec, num_rounds(ctx), blocks,
 				   walk.iv);
+		kernel_neon_end();
 		err = skcipher_walk_done(&walk, walk.nbytes % AES_BLOCK_SIZE);
 	}
-	kernel_neon_end();
 	return err;
 }
 
@@ -258,13 +258,14 @@ static int ctr_encrypt(struct skcipher_request *req)
 	struct skcipher_walk walk;
 	int err, blocks;
 
-	err = skcipher_walk_virt(&walk, req, true);
+	err = skcipher_walk_virt(&walk, req, false);
 
-	kernel_neon_begin();
 	while ((blocks = (walk.nbytes / AES_BLOCK_SIZE))) {
+		kernel_neon_begin();
 		ce_aes_ctr_encrypt(walk.dst.virt.addr, walk.src.virt.addr,
 				   ctx->key_enc, num_rounds(ctx), blocks,
 				   walk.iv);
+		kernel_neon_end();
 		err = skcipher_walk_done(&walk, walk.nbytes % AES_BLOCK_SIZE);
 	}
 	if (walk.nbytes) {
@@ -278,13 +279,13 @@ static int ctr_encrypt(struct skcipher_request *req)
 		 */
 		blocks = -1;
 
+		kernel_neon_begin();
 		ce_aes_ctr_encrypt(tail, NULL, ctx->key_enc, num_rounds(ctx),
 				   blocks, walk.iv);
+		kernel_neon_end();
 		crypto_xor_cpy(tdst, tsrc, tail, nbytes);
 		err = skcipher_walk_done(&walk, 0);
 	}
-	kernel_neon_end();
-
 	return err;
 }
 
@@ -319,17 +320,16 @@ static int xts_encrypt(struct skcipher_request *req)
 	struct skcipher_walk walk;
 	unsigned int blocks;
 
-	err = skcipher_walk_virt(&walk, req, true);
+	err = skcipher_walk_virt(&walk, req, false);
 
-	kernel_neon_begin();
 	for (first = 1; (blocks = (walk.nbytes / AES_BLOCK_SIZE)); first = 0) {
+		kernel_neon_begin();
 		ce_aes_xts_encrypt(walk.dst.virt.addr, walk.src.virt.addr,
 				   ctx->key1.key_enc, rounds, blocks, walk.iv,
 				   ctx->key2.key_enc, first);
+		kernel_neon_end();
 		err = skcipher_walk_done(&walk, walk.nbytes % AES_BLOCK_SIZE);
 	}
-	kernel_neon_end();
-
 	return err;
 }
 
@@ -341,17 +341,16 @@ static int xts_decrypt(struct skcipher_request *req)
 	struct skcipher_walk walk;
 	unsigned int blocks;
 
-	err = skcipher_walk_virt(&walk, req, true);
+	err = skcipher_walk_virt(&walk, req, false);
 
-	kernel_neon_begin();
 	for (first = 1; (blocks = (walk.nbytes / AES_BLOCK_SIZE)); first = 0) {
+		kernel_neon_begin();
 		ce_aes_xts_decrypt(walk.dst.virt.addr, walk.src.virt.addr,
 				   ctx->key1.key_dec, rounds, blocks, walk.iv,
 				   ctx->key2.key_enc, first);
+		kernel_neon_end();
 		err = skcipher_walk_done(&walk, walk.nbytes % AES_BLOCK_SIZE);
 	}
-	kernel_neon_end();
-
 	return err;
 }
 
diff --git a/arch/arm/crypto/aes-neonbs-glue.c b/arch/arm/crypto/aes-neonbs-glue.c
index 45cd9818791e..9000d0796d5e 100644
--- a/arch/arm/crypto/aes-neonbs-glue.c
+++ b/arch/arm/crypto/aes-neonbs-glue.c
@@ -90,9 +90,8 @@ static int __ecb_crypt(struct skcipher_request *req,
 	struct skcipher_walk walk;
 	int err;
 
-	err = skcipher_walk_virt(&walk, req, true);
+	err = skcipher_walk_virt(&walk, req, false);
 
-	kernel_neon_begin();
 	while (walk.nbytes >= AES_BLOCK_SIZE) {
 		unsigned int blocks = walk.nbytes / AES_BLOCK_SIZE;
 
@@ -100,12 +99,13 @@ static int __ecb_crypt(struct skcipher_request *req,
 			blocks = round_down(blocks,
 					    walk.stride / AES_BLOCK_SIZE);
 
+		kernel_neon_begin();
 		fn(walk.dst.virt.addr, walk.src.virt.addr, ctx->rk,
 		   ctx->rounds, blocks);
+		kernel_neon_end();
 		err = skcipher_walk_done(&walk,
 					 walk.nbytes - blocks * AES_BLOCK_SIZE);
 	}
-	kernel_neon_end();
 
 	return err;
 }
@@ -159,9 +159,8 @@ static int cbc_decrypt(struct skcipher_request *req)
 	struct skcipher_walk walk;
 	int err;
 
-	err = skcipher_walk_virt(&walk, req, true);
+	err = skcipher_walk_virt(&walk, req, false);
 
-	kernel_neon_begin();
 	while (walk.nbytes >= AES_BLOCK_SIZE) {
 		unsigned int blocks = walk.nbytes / AES_BLOCK_SIZE;
 
@@ -169,13 +168,14 @@ static int cbc_decrypt(struct skcipher_request *req)
 			blocks = round_down(blocks,
 					    walk.stride / AES_BLOCK_SIZE);
 
+		kernel_neon_begin();
 		aesbs_cbc_decrypt(walk.dst.virt.addr, walk.src.virt.addr,
 				  ctx->key.rk, ctx->key.rounds, blocks,
 				  walk.iv);
+		kernel_neon_end();
 		err = skcipher_walk_done(&walk,
 					 walk.nbytes - blocks * AES_BLOCK_SIZE);
 	}
-	kernel_neon_end();
 
 	return err;
 }
@@ -223,9 +223,8 @@ static int ctr_encrypt(struct skcipher_request *req)
 	u8 buf[AES_BLOCK_SIZE];
 	int err;
 
-	err = skcipher_walk_virt(&walk, req, true);
+	err = skcipher_walk_virt(&walk, req, false);
 
-	kernel_neon_begin();
 	while (walk.nbytes > 0) {
 		unsigned int blocks = walk.nbytes / AES_BLOCK_SIZE;
 		u8 *final = (walk.total % AES_BLOCK_SIZE) ? buf : NULL;
@@ -236,8 +235,10 @@ static int ctr_encrypt(struct skcipher_request *req)
 			final = NULL;
 		}
 
+		kernel_neon_begin();
 		aesbs_ctr_encrypt(walk.dst.virt.addr, walk.src.virt.addr,
 				  ctx->rk, ctx->rounds, blocks, walk.iv, final);
+		kernel_neon_end();
 
 		if (final) {
 			u8 *dst = walk.dst.virt.addr + blocks * AES_BLOCK_SIZE;
@@ -252,7 +253,6 @@ static int ctr_encrypt(struct skcipher_request *req)
 		err = skcipher_walk_done(&walk,
 					 walk.nbytes - blocks * AES_BLOCK_SIZE);
 	}
-	kernel_neon_end();
 
 	return err;
 }
@@ -329,7 +329,6 @@ static int __xts_crypt(struct skcipher_request *req,
 
 	crypto_cipher_encrypt_one(ctx->tweak_tfm, walk.iv, walk.iv);
 
-	kernel_neon_begin();
 	while (walk.nbytes >= AES_BLOCK_SIZE) {
 		unsigned int blocks = walk.nbytes / AES_BLOCK_SIZE;
 
@@ -337,12 +336,13 @@ static int __xts_crypt(struct skcipher_request *req,
 			blocks = round_down(blocks,
 					    walk.stride / AES_BLOCK_SIZE);
 
+		kernel_neon_begin();
 		fn(walk.dst.virt.addr, walk.src.virt.addr, ctx->key.rk,
 		   ctx->key.rounds, blocks, walk.iv);
+		kernel_neon_end();
 		err = skcipher_walk_done(&walk,
 					 walk.nbytes - blocks * AES_BLOCK_SIZE);
 	}
-	kernel_neon_end();
 
 	return err;
 }
-- 
2.17.1

