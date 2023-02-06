Return-Path: <linux-crypto-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BAD1EC61DA4
	for <linux-crypto@archiver.kernel.org>; Mon,  6 Feb 2023 03:31:54 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229523AbjBFDbx (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Sun, 5 Feb 2023 22:31:53 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40586 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229460AbjBFDbx (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Sun, 5 Feb 2023 22:31:53 -0500
Received: from aib29gb122.yyz1.oracleemaildelivery.com (aib29gb122.yyz1.oracleemaildelivery.com [192.29.72.122])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 105B614214
        for <linux-crypto@vger.kernel.org>; Sun,  5 Feb 2023 19:31:52 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; s=oci-2023;
 d=n8pjl.ca;
 h=Date:To:From:Subject:Message-Id:MIME-Version:Sender;
 bh=u7pdwP/3oyBlzQgNDoODdl5XTVcgq9zSeMGjx0xoxT4=;
 b=g1hgqx7Mvhdx836I7K1rJTWykZ7E7SlIAInvOQS8CLf8jo/WejRQpmK3+fjMz4ikvdZGxoxoiTpT
   j1Pa27eOeTMPstuaQchHCleBQ+d45FZelOGjRwIC10LSb4BwmIJXfp8Oej8Ih3Nf5gLFPwCGi7Xq
   sUD6LdobA/l4QmM1+/PJfqNlqA0QGWY6aeLsPNDJECqezyGmPbyO0vAB8PitYeyuOkFhEvgAt0kh
   Ep15Fg999qDQtBb9Ia67EtQP1DeJnma1cYgOFJCvosB85pvmrSqKYob6+khEBdQNwGONmwIajH60
   Ai513ipB3JrRoUUqcgrrbFRxLL7E1jdrfx2iZw==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; s=prod-yyz-20200204;
 d=yyz1.rp.oracleemaildelivery.com;
 h=Date:To:From:Subject:Message-Id:MIME-Version:Sender;
 bh=u7pdwP/3oyBlzQgNDoODdl5XTVcgq9zSeMGjx0xoxT4=;
 b=pGfmFL07yRiwtUw3LKA2uzwnuN7trpTibZl9BdJWRSmnB2D6dSZXWixEC3mk0xxb9YLN3GBgdrra
   GyRBLNZ4bIYELcCyZfUpWl3zdFoBv2hmYb1sAsRfnB1rVytPzpF5v10TmpngO3+WdYorIVqFYdWu
   eTGuSbRIun0IsryPeb/rRgOTJzkyfgtAUr/z42fJ3rFpYOhIoITmRNAeV7S364SmEvb8yNeXdQ6h
   a2L5e/P+oVPGqM2zlUGNYvB7DA0jRp1w4nJaNU+zMqvnh9zkicXmNgW+OYzH3OVcyd1/izmxmHFz
   8ypDKdIz/YUH+qW/POX9n+jhtNbUz03d9GpDMA==
Received: by omta-ad1-fd1-101-ca-toronto-1.omtaad1.vcndpyyz.oraclevcn.com
 (Oracle Communications Messaging Server 8.1.0.1.20230123 64bit (built Jan 23
 2023))
 with ESMTPS id <0RPN00LZT353JPA0@omta-ad1-fd1-101-ca-toronto-1.omtaad1.vcndpyyz.oraclevcn.com> for
 linux-crypto@vger.kernel.org; Mon, 06 Feb 2023 03:31:51 +0000 (GMT)
From:   Peter Lafreniere <peter@n8pjl.ca>
To:     linux-crypto@vger.kernel.org
Cc:     Peter Lafreniere <peter@n8pjl.ca>, x86@kernel.org,
        jussi.kivilinna@mbnet.fi
Subject: [PATCH 1/3] crypto: x86/twofish-3way - Remove unused encode parameter
Date:   Sun,  5 Feb 2023 22:31:33 -0500
Message-id: <5fb76bfe51ed23aa0e8a36aece76510d85bddfb2.1675653010.git.peter@n8pjl.ca>
X-Mailer: git-send-email 2.39.1
In-reply-to: <cover.1675653010.git.peter@n8pjl.ca>
References: <cover.1675653010.git.peter@n8pjl.ca>
MIME-version: 1.0
Content-transfer-encoding: 8bit
Reporting-Meta: AAFM0bY0qh8/6zbmsPQzEX+WOYHeLRhAzCfu1eznTJ2bOIpFPUo5XCr17EtjzhYF
 ut6+H4y7kaUVFnofIfQMlKq4IAriR8XX+JzEooOuidZgt6M2zx+ipYiQ+EysciHJ
 4dmKNjc2zrFdE1cIBsDhTYQnGrXDkcykQQuTafUMGEklD28XNGIv33AYYa3cty55
 BtndZckSp9kD0P+ePySIaoeJbNbVuVd+opjJvH4yby6fmFM0BdHWLajFgWJgiwK5
 le6ETDef06u2byn6pitIK5wIwExDkRa61JF4WsAASuODR6NdKErwgbcdzorG19cF
 U7JXYp0m3ecc4DJ53/Jd8Y4AWTTY3IgyGmZcU6Y2CIliJKuwDI5DR0tWUO+DVxpg
 FWoKfbND/5XaIaznATUGTRWFmeUqvNUOhXKbo2GrrukPxxhWu7ygoKnqOSSBPZM=
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

__twofish_enc_blk_3way() takes a third parameter which is always
hardcoded to false. Remove it to simplify twofish_enc_blk_3way.

There are also callers in other x86 crypto modules. Modify those to
call the assembly function directly.

Signed-off-by: Peter Lafreniere <peter@n8pjl.ca>
---
 arch/x86/crypto/twofish-x86_64-asm_64-3way.S | 18 ++----------------
 arch/x86/crypto/twofish.h                    |  3 +--
 arch/x86/crypto/twofish_avx_glue.c           |  5 -----
 arch/x86/crypto/twofish_glue_3way.c          |  7 +------
 4 files changed, 4 insertions(+), 29 deletions(-)

diff --git a/arch/x86/crypto/twofish-x86_64-asm_64-3way.S b/arch/x86/crypto/twofish-x86_64-asm_64-3way.S
index d2288bf38a8a..fa11513dbbf1 100644
--- a/arch/x86/crypto/twofish-x86_64-asm_64-3way.S
+++ b/arch/x86/crypto/twofish-x86_64-asm_64-3way.S
@@ -220,18 +220,16 @@
 	rorq $32,			RAB2; \
 	outunpack3(mov, RIO, 2, RAB, 2);
 
-SYM_FUNC_START(__twofish_enc_blk_3way)
+SYM_FUNC_START(twofish_enc_blk_3way)
 	/* input:
 	 *	%rdi: ctx, CTX
 	 *	%rsi: dst
 	 *	%rdx: src, RIO
-	 *	%rcx: bool, if true: xor output
 	 */
 	pushq %r13;
 	pushq %r12;
 	pushq %rbx;
 
-	pushq %rcx; /* bool xor */
 	pushq %rsi; /* dst */
 
 	inpack_enc3();
@@ -248,10 +246,6 @@ SYM_FUNC_START(__twofish_enc_blk_3way)
 	pop_cd();
 
 	popq RIO; /* dst */
-	popq RT1; /* bool xor */
-
-	testb RT1bl, RT1bl;
-	jnz .L__enc_xor3;
 
 	outunpack_enc3(mov);
 
@@ -259,15 +253,7 @@ SYM_FUNC_START(__twofish_enc_blk_3way)
 	popq %r12;
 	popq %r13;
 	RET;
-
-.L__enc_xor3:
-	outunpack_enc3(xor);
-
-	popq %rbx;
-	popq %r12;
-	popq %r13;
-	RET;
-SYM_FUNC_END(__twofish_enc_blk_3way)
+SYM_FUNC_END(twofish_enc_blk_3way)
 
 SYM_FUNC_START(twofish_dec_blk_3way)
 	/* input:
diff --git a/arch/x86/crypto/twofish.h b/arch/x86/crypto/twofish.h
index 12df400e6d53..feb0a6f820a6 100644
--- a/arch/x86/crypto/twofish.h
+++ b/arch/x86/crypto/twofish.h
@@ -11,8 +11,7 @@ asmlinkage void twofish_enc_blk(const void *ctx, u8 *dst, const u8 *src);
 asmlinkage void twofish_dec_blk(const void *ctx, u8 *dst, const u8 *src);
 
 /* 3-way parallel cipher functions */
-asmlinkage void __twofish_enc_blk_3way(const void *ctx, u8 *dst, const u8 *src,
-				       bool xor);
+asmlinkage void twofish_enc_blk_3way(const void *ctx, u8 *dst, const u8 *src);
 asmlinkage void twofish_dec_blk_3way(const void *ctx, u8 *dst, const u8 *src);
 
 /* helpers from twofish_x86_64-3way module */
diff --git a/arch/x86/crypto/twofish_avx_glue.c b/arch/x86/crypto/twofish_avx_glue.c
index 3eb3440b477a..257a79f4cb58 100644
--- a/arch/x86/crypto/twofish_avx_glue.c
+++ b/arch/x86/crypto/twofish_avx_glue.c
@@ -33,11 +33,6 @@ static int twofish_setkey_skcipher(struct crypto_skcipher *tfm,
 	return twofish_setkey(&tfm->base, key, keylen);
 }
 
-static inline void twofish_enc_blk_3way(const void *ctx, u8 *dst, const u8 *src)
-{
-	__twofish_enc_blk_3way(ctx, dst, src, false);
-}
-
 static int ecb_encrypt(struct skcipher_request *req)
 {
 	ECB_WALK_START(req, TF_BLOCK_SIZE, TWOFISH_PARALLEL_BLOCKS);
diff --git a/arch/x86/crypto/twofish_glue_3way.c b/arch/x86/crypto/twofish_glue_3way.c
index 90454cf18e0d..c331c4ca9363 100644
--- a/arch/x86/crypto/twofish_glue_3way.c
+++ b/arch/x86/crypto/twofish_glue_3way.c
@@ -15,7 +15,7 @@
 #include "twofish.h"
 #include "ecb_cbc_helpers.h"
 
-EXPORT_SYMBOL_GPL(__twofish_enc_blk_3way);
+EXPORT_SYMBOL_GPL(twofish_enc_blk_3way);
 EXPORT_SYMBOL_GPL(twofish_dec_blk_3way);
 
 static int twofish_setkey_skcipher(struct crypto_skcipher *tfm,
@@ -24,11 +24,6 @@ static int twofish_setkey_skcipher(struct crypto_skcipher *tfm,
 	return twofish_setkey(&tfm->base, key, keylen);
 }
 
-static inline void twofish_enc_blk_3way(const void *ctx, u8 *dst, const u8 *src)
-{
-	__twofish_enc_blk_3way(ctx, dst, src, false);
-}
-
 void twofish_dec_blk_cbc_3way(const void *ctx, u8 *dst, const u8 *src)
 {
 	u8 buf[2][TF_BLOCK_SIZE];
-- 
2.39.1

