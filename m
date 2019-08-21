Return-Path: <SRS0=bUM2=WR=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 90F4DC3A59E
	for <linux-crypto@archiver.kernel.org>; Wed, 21 Aug 2019 14:33:07 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 5DC82216F4
	for <linux-crypto@archiver.kernel.org>; Wed, 21 Aug 2019 14:33:07 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="GaAOKLbS"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728502AbfHUOdH (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Wed, 21 Aug 2019 10:33:07 -0400
Received: from mail-wr1-f66.google.com ([209.85.221.66]:40882 "EHLO
        mail-wr1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728980AbfHUOdG (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 21 Aug 2019 10:33:06 -0400
Received: by mail-wr1-f66.google.com with SMTP id c3so2257291wrd.7
        for <linux-crypto@vger.kernel.org>; Wed, 21 Aug 2019 07:33:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=iouKzcU6vzz3J8Cw/jp3uuc+QHFS3Cf59HMMjSOOWbs=;
        b=GaAOKLbSlqipMH664RibEBtkwaszXHKiJcIXNSxoGR2IKNaSLiCl+ZQRMV+pUHajNM
         AJJGpuZNdY4qtB5wtVvjrkXhsOBUVERYoOMnQ3A3WghV0M3auzU0mkoI3O1tUNxvmfH8
         RRpLRD3JDtzP0ra4wG/pa9IxxmpCrcBH7aEDeHXWx8rI1XWAwnysIif0iMEpc1dXK6fK
         bAh0oAQ5UFL0AZWkdymwGxM627A5XO03Ne1NYsPIfilIWQmZT8GXOo8TVwHm36AJ9Lft
         iWDLLQZ4Eohc+acV+HCGe7G89gyGs+GB2o7ahnEDKSFDAb6Gk0cMENLZeZehtxIEii6o
         xFQQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=iouKzcU6vzz3J8Cw/jp3uuc+QHFS3Cf59HMMjSOOWbs=;
        b=NkPievD5lD46PHBK3rNzBBmIoVbKKhPdySYHleAzCliIsFIUKQxn7cKhHkHjQ/T5nl
         BG8UdFMGjLBAk8R8tIizTkBoyl3Qi5q+2MnFWh5DoYtxRC4xfOX1OaDRiwU7PobGl5+6
         QyrYnVWA4eEGR0JitzlZP2dh3ehHWbdDNFVtWWgXWcplRTZSnFRYZGEh5pEuFtfpxTkZ
         tzHzHaVlMyvug6JmfUtJ5H2aVDtypwgYunMJWSre2CXX/7ByF2rWscIkxdwtECOysK+3
         rzyW9o3K0IgBTQ3EmcV3f9QWhdwHuKOeN5uJ8KCGoAuG/n7vSaRzneVXQdVCSekdPuK1
         domQ==
X-Gm-Message-State: APjAAAUR1l2X3l2mckwZjKp8/VwSqUGalneYlJ5A1L8BDOx6k0WAEl9+
        ji3EBTbMfB4QVQQ2EaAhs/uP7go8N4sVaQ==
X-Google-Smtp-Source: APXvYqx5IygQm8uLjljUyCwssozERTjNUUPudRR4xvfnJ1e5iXBzE6gnH5t4eTEDFaNE0iE4iKmqMQ==
X-Received: by 2002:adf:fe85:: with SMTP id l5mr38995702wrr.5.1566397982854;
        Wed, 21 Aug 2019 07:33:02 -0700 (PDT)
Received: from mba13.lan (adsl-103.109.242.1.tellas.gr. [109.242.1.103])
        by smtp.gmail.com with ESMTPSA id 16sm181427wmx.45.2019.08.21.07.33.01
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 21 Aug 2019 07:33:02 -0700 (PDT)
From:   Ard Biesheuvel <ard.biesheuvel@linaro.org>
To:     linux-crypto@vger.kernel.org
Cc:     herbert@gondor.apana.org.au, ebiggers@kernel.org,
        Ard Biesheuvel <ard.biesheuvel@linaro.org>
Subject: [PATCH 02/17] crypto: arm/aes-ce - yield the SIMD unit between scatterwalk steps
Date:   Wed, 21 Aug 2019 17:32:38 +0300
Message-Id: <20190821143253.30209-3-ard.biesheuvel@linaro.org>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20190821143253.30209-1-ard.biesheuvel@linaro.org>
References: <20190821143253.30209-1-ard.biesheuvel@linaro.org>
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

