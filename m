Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-19.3 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9B4A8C43332
	for <linux-crypto@archiver.kernel.org>; Sat, 16 Jan 2021 17:15:40 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 7835D20732
	for <linux-crypto@archiver.kernel.org>; Sat, 16 Jan 2021 17:15:40 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728112AbhAPRPN (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Sat, 16 Jan 2021 12:15:13 -0500
Received: from mail.kernel.org ([198.145.29.99]:60678 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728023AbhAPRPH (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Sat, 16 Jan 2021 12:15:07 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id DD3D023107;
        Sat, 16 Jan 2021 16:48:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1610815699;
        bh=OZCqrHXkTaE+BCXdhJyQVBUL0FDU6yPJa0OzY+AB9fM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ZPasbbUg+3IFSgZTgirjIp6ix/fkoeHLOKDHrw1tCULL3BzMh+LRfmue9rZE5ryLh
         Q/XiP/9kFw01fbDyd2O1sfPBpQ7sxEfb1LRI+DflDSifciNiUjpDnXm/PwPoUUqeX0
         +YJIChgHRz8ZI5VrcdWOePgvOgj5VitmlaMDHxlctaYZPJwVC8BQrrbjgtmQEXen7X
         7lTh1KEV2W7IqpPGa9P3fXW/eDhEcwKM3diCsp9U+xJSYzeG4MIKisKwMpx0P9iWom
         +WbGwBLSopqrm6oHR7t+RrH3SknUjegi8ayEA8oPyxIs4vBVcG8DOuwuuseD0xJiEf
         HRyKDmmPdweFw==
From:   Ard Biesheuvel <ardb@kernel.org>
To:     linux-crypto@vger.kernel.org
Cc:     Ard Biesheuvel <ardb@kernel.org>, Megha Dey <megha.dey@intel.com>,
        Eric Biggers <ebiggers@google.com>,
        Herbert Xu <herbert@gondor.apana.org.au>
Subject: [PATCH 2/2] crypto: aesni - release FPU during skcipher walk API calls
Date:   Sat, 16 Jan 2021 17:48:10 +0100
Message-Id: <20210116164810.21192-3-ardb@kernel.org>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20210116164810.21192-1-ardb@kernel.org>
References: <20210116164810.21192-1-ardb@kernel.org>
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Taking ownership of the FPU in kernel mode disables preemption, and
this may result in excessive scheduling blackouts if the size of the
data being processed on the FPU is unbounded.

Given that taking and releasing the FPU is cheap these days on x86, we
can limit the impact of this issue easily for skcipher implementations,
by moving the FPU begin/end calls inside the skcipher walk processing
loop. Considering that skcipher walks operate on at most one page at a
time, doing so fully mitigates this issue.

This also permits the skcipher walk logic to use non-atomic kmalloc()
calls etc so we can change the 'atomic' bool argument in the calls to
skcipher_walk_virt() to false as well.

Signed-off-by: Ard Biesheuvel <ardb@kernel.org>
---
 arch/x86/crypto/aesni-intel_glue.c | 73 +++++++++-----------
 1 file changed, 32 insertions(+), 41 deletions(-)

diff --git a/arch/x86/crypto/aesni-intel_glue.c b/arch/x86/crypto/aesni-intel_glue.c
index d96685457196..2144e54a6c89 100644
--- a/arch/x86/crypto/aesni-intel_glue.c
+++ b/arch/x86/crypto/aesni-intel_glue.c
@@ -283,16 +283,16 @@ static int ecb_encrypt(struct skcipher_request *req)
 	unsigned int nbytes;
 	int err;
 
-	err = skcipher_walk_virt(&walk, req, true);
+	err = skcipher_walk_virt(&walk, req, false);
 
-	kernel_fpu_begin();
 	while ((nbytes = walk.nbytes)) {
+		kernel_fpu_begin();
 		aesni_ecb_enc(ctx, walk.dst.virt.addr, walk.src.virt.addr,
 			      nbytes & AES_BLOCK_MASK);
+		kernel_fpu_end();
 		nbytes &= AES_BLOCK_SIZE - 1;
 		err = skcipher_walk_done(&walk, nbytes);
 	}
-	kernel_fpu_end();
 
 	return err;
 }
@@ -305,16 +305,16 @@ static int ecb_decrypt(struct skcipher_request *req)
 	unsigned int nbytes;
 	int err;
 
-	err = skcipher_walk_virt(&walk, req, true);
+	err = skcipher_walk_virt(&walk, req, false);
 
-	kernel_fpu_begin();
 	while ((nbytes = walk.nbytes)) {
+		kernel_fpu_begin();
 		aesni_ecb_dec(ctx, walk.dst.virt.addr, walk.src.virt.addr,
 			      nbytes & AES_BLOCK_MASK);
+		kernel_fpu_end();
 		nbytes &= AES_BLOCK_SIZE - 1;
 		err = skcipher_walk_done(&walk, nbytes);
 	}
-	kernel_fpu_end();
 
 	return err;
 }
@@ -327,16 +327,16 @@ static int cbc_encrypt(struct skcipher_request *req)
 	unsigned int nbytes;
 	int err;
 
-	err = skcipher_walk_virt(&walk, req, true);
+	err = skcipher_walk_virt(&walk, req, false);
 
-	kernel_fpu_begin();
 	while ((nbytes = walk.nbytes)) {
+		kernel_fpu_begin();
 		aesni_cbc_enc(ctx, walk.dst.virt.addr, walk.src.virt.addr,
 			      nbytes & AES_BLOCK_MASK, walk.iv);
+		kernel_fpu_end();
 		nbytes &= AES_BLOCK_SIZE - 1;
 		err = skcipher_walk_done(&walk, nbytes);
 	}
-	kernel_fpu_end();
 
 	return err;
 }
@@ -349,16 +349,16 @@ static int cbc_decrypt(struct skcipher_request *req)
 	unsigned int nbytes;
 	int err;
 
-	err = skcipher_walk_virt(&walk, req, true);
+	err = skcipher_walk_virt(&walk, req, false);
 
-	kernel_fpu_begin();
 	while ((nbytes = walk.nbytes)) {
+		kernel_fpu_begin();
 		aesni_cbc_dec(ctx, walk.dst.virt.addr, walk.src.virt.addr,
 			      nbytes & AES_BLOCK_MASK, walk.iv);
+		kernel_fpu_end();
 		nbytes &= AES_BLOCK_SIZE - 1;
 		err = skcipher_walk_done(&walk, nbytes);
 	}
-	kernel_fpu_end();
 
 	return err;
 }
@@ -476,21 +476,6 @@ static int cts_cbc_decrypt(struct skcipher_request *req)
 }
 
 #ifdef CONFIG_X86_64
-static void ctr_crypt_final(struct crypto_aes_ctx *ctx,
-			    struct skcipher_walk *walk)
-{
-	u8 *ctrblk = walk->iv;
-	u8 keystream[AES_BLOCK_SIZE];
-	u8 *src = walk->src.virt.addr;
-	u8 *dst = walk->dst.virt.addr;
-	unsigned int nbytes = walk->nbytes;
-
-	aesni_enc(ctx, keystream, ctrblk);
-	crypto_xor_cpy(dst, keystream, src, nbytes);
-
-	crypto_inc(ctrblk, AES_BLOCK_SIZE);
-}
-
 static void aesni_ctr_enc_avx_tfm(struct crypto_aes_ctx *ctx, u8 *out,
 			      const u8 *in, unsigned int len, u8 *iv)
 {
@@ -512,27 +497,33 @@ static int ctr_crypt(struct skcipher_request *req)
 {
 	struct crypto_skcipher *tfm = crypto_skcipher_reqtfm(req);
 	struct crypto_aes_ctx *ctx = aes_ctx(crypto_skcipher_ctx(tfm));
+	u8 keystream[AES_BLOCK_SIZE];
 	struct skcipher_walk walk;
 	unsigned int nbytes;
 	int err;
 
-	err = skcipher_walk_virt(&walk, req, true);
+	err = skcipher_walk_virt(&walk, req, false);
 
-	kernel_fpu_begin();
-	while ((nbytes = walk.nbytes) >= AES_BLOCK_SIZE) {
-		static_call(aesni_ctr_enc_tfm)(ctx, walk.dst.virt.addr,
-					       walk.src.virt.addr,
-					       nbytes & AES_BLOCK_MASK,
-					       walk.iv);
-		nbytes &= AES_BLOCK_SIZE - 1;
+	while ((nbytes = walk.nbytes) > 0) {
+		kernel_fpu_begin();
+		if (nbytes & AES_BLOCK_MASK)
+			static_call(aesni_ctr_enc_tfm)(ctx, walk.dst.virt.addr,
+						       walk.src.virt.addr,
+						       nbytes & AES_BLOCK_MASK,
+						       walk.iv);
+		nbytes &= ~AES_BLOCK_MASK;
+
+		if (walk.nbytes == walk.total && nbytes > 0) {
+			aesni_enc(ctx, keystream, walk.iv);
+			crypto_xor_cpy(walk.dst.virt.addr + walk.nbytes - nbytes,
+				       walk.src.virt.addr + walk.nbytes - nbytes,
+				       keystream, nbytes);
+			crypto_inc(walk.iv, AES_BLOCK_SIZE);
+			nbytes = 0;
+		}
+		kernel_fpu_end();
 		err = skcipher_walk_done(&walk, nbytes);
 	}
-	if (walk.nbytes) {
-		ctr_crypt_final(ctx, &walk);
-		err = skcipher_walk_done(&walk, 0);
-	}
-	kernel_fpu_end();
-
 	return err;
 }
 
-- 
2.17.1

