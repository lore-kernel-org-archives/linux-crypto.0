Return-Path: <linux-crypto-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CD818C61DA4
	for <linux-crypto@archiver.kernel.org>; Mon,  6 Feb 2023 03:32:27 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229533AbjBFDc1 (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Sun, 5 Feb 2023 22:32:27 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40678 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229460AbjBFDc0 (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Sun, 5 Feb 2023 22:32:26 -0500
Received: from aib29gb125.yyz1.oracleemaildelivery.com (aib29gb125.yyz1.oracleemaildelivery.com [192.29.72.125])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 744B414214
        for <linux-crypto@vger.kernel.org>; Sun,  5 Feb 2023 19:32:25 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; s=oci-2023;
 d=n8pjl.ca;
 h=Date:To:From:Subject:Message-Id:MIME-Version:Sender;
 bh=ZtmSC+ucqFQV9IcCq8FgHtVQ8AfPSZnLwQrC7fNgyE8=;
 b=N7Va+MXQ0mEyNItsXXObEquNvza5rIqmA9TiL8yOQk2qs2mlJxL5DXuzeOityUPJ0mVreJ6dLymf
   qfaxB6n80eI+6zonQ0O5nsmJRYr5DCg2CCWEHD9iJOjkHnuyHfYk81leXZe/tNWXdXpZSYVjlujj
   eCH/fXsGIu6X4OlKctvxB/ipiXtJvCkldwuIpDLkYroeFuVB4UHfxg42YhG0IS3GAY0zvBiiaQ4/
   QnOThJ2CvQ/+pKOS+7wD0n18f6zVEgFs6COmQh4VK3ilH7UYmGfcYAwCCgf3HPfuVWRik5vF3vTf
   SzzVm/cctkWKIDi94TQbOihQvp2T9WaNcfvEsQ==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; s=prod-yyz-20200204;
 d=yyz1.rp.oracleemaildelivery.com;
 h=Date:To:From:Subject:Message-Id:MIME-Version:Sender;
 bh=ZtmSC+ucqFQV9IcCq8FgHtVQ8AfPSZnLwQrC7fNgyE8=;
 b=nO1aQ9LGhlgYVuY9I16OTfnwEL0J4o4UvQii1LL/E4U0M+SNSadcEIwZT8rxh6coQIl+MQDIp/CL
   K3muAl3wCXWYjmZsJlgHaXi7q9DW3nhChrBO15gIx4p0vP5UymlhhaoqmqQYeSmRlYCqI4KhMGEk
   /hfNsOOgm4W14tw4j/LpFOYsA5MESXw6RBpJfUKvh6gALbWAlGZdfAyAsBTYbvNHhFf4DCPq8y/U
   eUCBUxh/y8U+yIgEyE/0tPVKnYmZq9uWvQjZIi/5X3GEhJFCAI6U9S8pk9HMMJCvb/lqVGJT646b
   qpfRN/BHELryd9C4/UeC4z30u4dCFRrUyJ9WDw==
Received: by omta-ad1-fd2-102-ca-toronto-1.omtaad1.vcndpyyz.oraclevcn.com
 (Oracle Communications Messaging Server 8.1.0.1.20230123 64bit (built Jan 23
 2023))
 with ESMTPS id <0RPN00O663607Q90@omta-ad1-fd2-102-ca-toronto-1.omtaad1.vcndpyyz.oraclevcn.com> for
 linux-crypto@vger.kernel.org; Mon, 06 Feb 2023 03:32:24 +0000 (GMT)
From:   Peter Lafreniere <peter@n8pjl.ca>
To:     linux-crypto@vger.kernel.org
Cc:     Peter Lafreniere <peter@n8pjl.ca>, x86@kernel.org,
        jussi.kivilinna@mbnet.fi
Subject: [PATCH 2/3] crypto: x86/twofish-3way - Perform cbc xor in assembly
Date:   Sun,  5 Feb 2023 22:31:34 -0500
Message-id: <80b492462c1741c384f326a01856791a517bc251.1675653010.git.peter@n8pjl.ca>
X-Mailer: git-send-email 2.39.1
In-reply-to: <cover.1675653010.git.peter@n8pjl.ca>
References: <cover.1675653010.git.peter@n8pjl.ca>
MIME-version: 1.0
Content-transfer-encoding: 8bit
Reporting-Meta: AAFM0bY0qh8/6zbmsPQzEX+WOYHeLRhAzCfu1eznTJ2bOIpFPUo5XCr17EtjzhYF
 ut6+H4y7kaUVFnofIfQclKq4IAriR8XX+Jxgh1uK15MEfN9a97Sjp2qLpv1mGxkl
 eyMVcrL5oEMLKbGEz6Z9lYPICf8TZA5ko0rcFrlmrCmR9tsn+7OlRncNkx83HILI
 oqtKwvlCBzqcEIi1eVy1VWcwvJZAHz8xb3oXo2YxhIr6z0VH9KM9koYv6ocS8Vro
 getiybh91Eg6KVlQlYKLZb0/LMP3AHgCPTbl44JAxa1J76gF9h82OfNwYkxME4D/
 mS1lryDh+cx3BFA9sY28b0vCkhDuE3yGm+fjqvMkIf27FVkAQz+rKR0KSz1qP6Yz
 lVbcpaLg5KTZSgKXdr8YJEfsNVC7YdoBspsnXF1BLIZj1geDNRL7v+jpg0okYnM=
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Optimize twofish-3way cbc decryption by keeping intermediate results in
registers until computations are finished, rather than storing in
assembly, then immediately reloading them in glue code. Additionally,
keeping all operations in assembly can avoid a memcpy() call when the
decryption is being done in place.

cbc decoding speedups: (tcrypt mode=202 on a znver1)
64B: +7.7%, 128B: +6.3%, 256B: +6.8%

Signed-off-by: Peter Lafreniere <peter@n8pjl.ca>
---
 arch/x86/crypto/twofish-x86_64-asm_64-3way.S | 33 ++++++++++++++++++--
 arch/x86/crypto/twofish.h                    | 16 ++++++++--
 arch/x86/crypto/twofish_glue_3way.c          | 15 +--------
 3 files changed, 45 insertions(+), 19 deletions(-)

diff --git a/arch/x86/crypto/twofish-x86_64-asm_64-3way.S b/arch/x86/crypto/twofish-x86_64-asm_64-3way.S
index fa11513dbbf1..29e0fe664386 100644
--- a/arch/x86/crypto/twofish-x86_64-asm_64-3way.S
+++ b/arch/x86/crypto/twofish-x86_64-asm_64-3way.S
@@ -220,6 +220,20 @@
 	rorq $32,			RAB2; \
 	outunpack3(mov, RIO, 2, RAB, 2);
 
+#define outunpack_cbc_dec3() \
+	rorq $32,			RCD0; \
+	rorq $32,			RCD1; \
+	xorq (RT1),			RCD1; \
+	rorq $32,			RCD2; \
+	xorq 16(RT1),			RCD2; \
+	outunpack3(mov, RIO, 0, RCD, 0); \
+	rorq $32,			RAB0; \
+	rorq $32,			RAB1; \
+	xorq 8(RT1),			RAB1; \
+	rorq $32,			RAB2; \
+	xorq 24(RT1),			RAB2; \
+	outunpack3(mov, RIO, 2, RAB, 2);
+
 SYM_FUNC_START(twofish_enc_blk_3way)
 	/* input:
 	 *	%rdi: ctx, CTX
@@ -255,17 +269,20 @@ SYM_FUNC_START(twofish_enc_blk_3way)
 	RET;
 SYM_FUNC_END(twofish_enc_blk_3way)
 
-SYM_FUNC_START(twofish_dec_blk_3way)
+SYM_FUNC_START(__twofish_dec_blk_3way)
 	/* input:
 	 *	%rdi: ctx, CTX
 	 *	%rsi: dst
 	 *	%rdx: src, RIO
+	 *	%rcx: cbc (bool)
 	 */
 	pushq %r13;
 	pushq %r12;
 	pushq %rbx;
 
 	pushq %rsi; /* dst */
+	pushq %rdx; /* src */
+	pushq %rcx; /* cbc */
 
 	inpack_dec3();
 
@@ -280,12 +297,24 @@ SYM_FUNC_START(twofish_dec_blk_3way)
 	decrypt_cycle3(RAB, CD, 0);
 	pop_cd();
 
+	popq RT0; /* cbc */
+	popq RT1; /* src */
 	popq RIO; /* dst */
 
+	testq RT0, RT0;
+	jnz .L_dec_cbc;
+
 	outunpack_dec3();
 
 	popq %rbx;
 	popq %r12;
 	popq %r13;
 	RET;
-SYM_FUNC_END(twofish_dec_blk_3way)
+
+.L_dec_cbc:
+	outunpack_cbc_dec3();
+	popq %rbx;
+	popq %r12;
+	popq %r13;
+	RET;
+SYM_FUNC_END(__twofish_dec_blk_3way)
diff --git a/arch/x86/crypto/twofish.h b/arch/x86/crypto/twofish.h
index feb0a6f820a6..ede02a8b36d4 100644
--- a/arch/x86/crypto/twofish.h
+++ b/arch/x86/crypto/twofish.h
@@ -12,9 +12,19 @@ asmlinkage void twofish_dec_blk(const void *ctx, u8 *dst, const u8 *src);
 
 /* 3-way parallel cipher functions */
 asmlinkage void twofish_enc_blk_3way(const void *ctx, u8 *dst, const u8 *src);
-asmlinkage void twofish_dec_blk_3way(const void *ctx, u8 *dst, const u8 *src);
+asmlinkage void __twofish_dec_blk_3way(const void *ctx, u8 *dst,
+				       const u8 *src, bool cbc);
 
-/* helpers from twofish_x86_64-3way module */
-extern void twofish_dec_blk_cbc_3way(const void *ctx, u8 *dst, const u8 *src);
+/* helpers for use of __twofish_dec_blk_3way() */
+static inline void twofish_dec_blk_3way(const void *ctx, u8 *dst,
+					const u8 *src)
+{
+	return __twofish_dec_blk_3way(ctx, dst, src, false);
+}
+static inline void twofish_dec_blk_cbc_3way(const void *ctx, u8 *dst,
+					    const u8 *src)
+{
+	return __twofish_dec_blk_3way(ctx, dst, src, true);
+}
 
 #endif /* ASM_X86_TWOFISH_H */
diff --git a/arch/x86/crypto/twofish_glue_3way.c b/arch/x86/crypto/twofish_glue_3way.c
index c331c4ca9363..1f6944620dc5 100644
--- a/arch/x86/crypto/twofish_glue_3way.c
+++ b/arch/x86/crypto/twofish_glue_3way.c
@@ -16,7 +16,7 @@
 #include "ecb_cbc_helpers.h"
 
 EXPORT_SYMBOL_GPL(twofish_enc_blk_3way);
-EXPORT_SYMBOL_GPL(twofish_dec_blk_3way);
+EXPORT_SYMBOL_GPL(__twofish_dec_blk_3way);
 
 static int twofish_setkey_skcipher(struct crypto_skcipher *tfm,
 				   const u8 *key, unsigned int keylen)
@@ -24,19 +24,6 @@ static int twofish_setkey_skcipher(struct crypto_skcipher *tfm,
 	return twofish_setkey(&tfm->base, key, keylen);
 }
 
-void twofish_dec_blk_cbc_3way(const void *ctx, u8 *dst, const u8 *src)
-{
-	u8 buf[2][TF_BLOCK_SIZE];
-	const u8 *s = src;
-
-	if (dst == src)
-		s = memcpy(buf, src, sizeof(buf));
-	twofish_dec_blk_3way(ctx, dst, src);
-	crypto_xor(dst + TF_BLOCK_SIZE, s, sizeof(buf));
-
-}
-EXPORT_SYMBOL_GPL(twofish_dec_blk_cbc_3way);
-
 static int ecb_encrypt(struct skcipher_request *req)
 {
 	ECB_WALK_START(req, TF_BLOCK_SIZE, -1);
-- 
2.39.1

