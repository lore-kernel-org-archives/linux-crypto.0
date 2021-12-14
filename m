Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5DFD8C433F5
	for <linux-crypto@archiver.kernel.org>; Tue, 14 Dec 2021 16:02:06 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233304AbhLNQCF (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Tue, 14 Dec 2021 11:02:05 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54580 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231494AbhLNQCF (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 14 Dec 2021 11:02:05 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 15770C061574
        for <linux-crypto@vger.kernel.org>; Tue, 14 Dec 2021 08:02:05 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id A6233B8182A
        for <linux-crypto@vger.kernel.org>; Tue, 14 Dec 2021 16:02:03 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CA762C34604;
        Tue, 14 Dec 2021 16:02:01 +0000 (UTC)
Authentication-Results: smtp.kernel.org;
        dkim=pass (1024-bit key) header.d=zx2c4.com header.i=@zx2c4.com header.b="dTtZz6Jw"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=zx2c4.com; s=20210105;
        t=1639497720;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=GN8AfvkyGnKucv9ew61G1zbsj756Uw++AI3pyzxxucI=;
        b=dTtZz6JwUIDMreHYTwzlcNGdPcD+n5BNqxtINw1htdUIshIxFKZy6rjVm8v6DPCmL01Q6F
        F4qbRQgMb1GlI/ihozDpPW618clVwsPKiH8GPsYbu1dhUzZFUOa21L3k9dVuFJZS5UuDdP
        trEGheR9SsdNXR78CvaetDi1eKXIDlo=
Received: by mail.zx2c4.com (ZX2C4 Mail Server) with ESMTPSA id 37792bd5 (TLSv1.3:AEAD-AES256-GCM-SHA384:256:NO);
        Tue, 14 Dec 2021 16:02:00 +0000 (UTC)
From:   "Jason A. Donenfeld" <Jason@zx2c4.com>
To:     linux-crypto@vger.kernel.org,
        Herbert Xu <herbert@gondor.apana.org.au>
Cc:     "Jason A. Donenfeld" <Jason@zx2c4.com>,
        Mathias Krause <minipli@grsecurity.net>,
        Aymeric Fromherz <aymeric.fromherz@inria.fr>
Subject: [PATCH] crypto: x86/curve25519 - use in/out register constraints more precisely
Date:   Tue, 14 Dec 2021 17:01:46 +0100
Message-Id: <20211214160146.1073616-1-Jason@zx2c4.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Rather than passing all variables as modified, pass ones that are only
read into that parameter. This helps with old gcc versions when
alternatives are additionally used, and lets gcc's codegen be a little
bit more efficient. This also syncs up with the latest Vale/EverCrypt
output.

Reported-by: Mathias Krause <minipli@grsecurity.net>
Cc: Aymeric Fromherz <aymeric.fromherz@inria.fr>
Link: https://lore.kernel.org/wireguard/1554725710.1290070.1639240504281.JavaMail.zimbra@inria.fr/
Link: https://github.com/project-everest/hacl-star/pull/501
Signed-off-by: Jason A. Donenfeld <Jason@zx2c4.com>
---
 arch/x86/crypto/curve25519-x86_64.c | 767 ++++++++++++++++++----------
 1 file changed, 489 insertions(+), 278 deletions(-)

diff --git a/arch/x86/crypto/curve25519-x86_64.c b/arch/x86/crypto/curve25519-x86_64.c
index 38caf61cd5b7..d55fa9e9b9e6 100644
--- a/arch/x86/crypto/curve25519-x86_64.c
+++ b/arch/x86/crypto/curve25519-x86_64.c
@@ -64,10 +64,9 @@ static inline u64 add_scalar(u64 *out, const u64 *f1, u64 f2)
 
 		/* Return the carry bit in a register */
 		"  adcx %%r11, %1;"
-	: "+&r" (f2), "=&r" (carry_r)
-	: "r" (out), "r" (f1)
-	: "%r8", "%r9", "%r10", "%r11", "memory", "cc"
-	);
+		: "+&r"(f2), "=&r"(carry_r)
+		: "r"(out), "r"(f1)
+		: "%r8", "%r9", "%r10", "%r11", "memory", "cc");
 
 	return carry_r;
 }
@@ -108,10 +107,9 @@ static inline void fadd(u64 *out, const u64 *f1, const u64 *f2)
 		"  cmovc %0, %%rax;"
 		"  add %%rax, %%r8;"
 		"  movq %%r8, 0(%1);"
-	: "+&r" (f2)
-	: "r" (out), "r" (f1)
-	: "%rax", "%rcx", "%r8", "%r9", "%r10", "%r11", "memory", "cc"
-	);
+		: "+&r"(f2)
+		: "r"(out), "r"(f1)
+		: "%rax", "%rcx", "%r8", "%r9", "%r10", "%r11", "memory", "cc");
 }
 
 /* Computes the field subtraction of two field elements */
@@ -151,10 +149,9 @@ static inline void fsub(u64 *out, const u64 *f1, const u64 *f2)
 		"  movq %%r9, 8(%0);"
 		"  movq %%r10, 16(%0);"
 		"  movq %%r11, 24(%0);"
-	:
-	: "r" (out), "r" (f1), "r" (f2)
-	: "%rax", "%rcx", "%r8", "%r9", "%r10", "%r11", "memory", "cc"
-	);
+		:
+		: "r"(out), "r"(f1), "r"(f2)
+		: "%rax", "%rcx", "%r8", "%r9", "%r10", "%r11", "memory", "cc");
 }
 
 /* Computes a field multiplication: out <- f1 * f2
@@ -162,239 +159,400 @@ static inline void fsub(u64 *out, const u64 *f1, const u64 *f2)
 static inline void fmul(u64 *out, const u64 *f1, const u64 *f2, u64 *tmp)
 {
 	asm volatile(
+
 		/* Compute the raw multiplication: tmp <- src1 * src2 */
 
 		/* Compute src1[0] * src2 */
-		"  movq 0(%1), %%rdx;"
-		"  mulxq 0(%3), %%r8, %%r9;"       "  xor %%r10d, %%r10d;"   "  movq %%r8, 0(%0);"
-		"  mulxq 8(%3), %%r10, %%r11;"     "  adox %%r9, %%r10;"     "  movq %%r10, 8(%0);"
-		"  mulxq 16(%3), %%rbx, %%r13;"    "  adox %%r11, %%rbx;"
-		"  mulxq 24(%3), %%r14, %%rdx;"    "  adox %%r13, %%r14;"    "  mov $0, %%rax;"
-		                                   "  adox %%rdx, %%rax;"
+		"  movq 0(%0), %%rdx;"
+		"  mulxq 0(%1), %%r8, %%r9;"
+		"  xor %%r10d, %%r10d;"
+		"  movq %%r8, 0(%2);"
+		"  mulxq 8(%1), %%r10, %%r11;"
+		"  adox %%r9, %%r10;"
+		"  movq %%r10, 8(%2);"
+		"  mulxq 16(%1), %%rbx, %%r13;"
+		"  adox %%r11, %%rbx;"
+		"  mulxq 24(%1), %%r14, %%rdx;"
+		"  adox %%r13, %%r14;"
+		"  mov $0, %%rax;"
+		"  adox %%rdx, %%rax;"
+
 		/* Compute src1[1] * src2 */
-		"  movq 8(%1), %%rdx;"
-		"  mulxq 0(%3), %%r8, %%r9;"       "  xor %%r10d, %%r10d;"   "  adcxq 8(%0), %%r8;"    "  movq %%r8, 8(%0);"
-		"  mulxq 8(%3), %%r10, %%r11;"     "  adox %%r9, %%r10;"     "  adcx %%rbx, %%r10;"    "  movq %%r10, 16(%0);"
-		"  mulxq 16(%3), %%rbx, %%r13;"    "  adox %%r11, %%rbx;"    "  adcx %%r14, %%rbx;"    "  mov $0, %%r8;"
-		"  mulxq 24(%3), %%r14, %%rdx;"    "  adox %%r13, %%r14;"    "  adcx %%rax, %%r14;"    "  mov $0, %%rax;"
-		                                   "  adox %%rdx, %%rax;"    "  adcx %%r8, %%rax;"
+		"  movq 8(%0), %%rdx;"
+		"  mulxq 0(%1), %%r8, %%r9;"
+		"  xor %%r10d, %%r10d;"
+		"  adcxq 8(%2), %%r8;"
+		"  movq %%r8, 8(%2);"
+		"  mulxq 8(%1), %%r10, %%r11;"
+		"  adox %%r9, %%r10;"
+		"  adcx %%rbx, %%r10;"
+		"  movq %%r10, 16(%2);"
+		"  mulxq 16(%1), %%rbx, %%r13;"
+		"  adox %%r11, %%rbx;"
+		"  adcx %%r14, %%rbx;"
+		"  mov $0, %%r8;"
+		"  mulxq 24(%1), %%r14, %%rdx;"
+		"  adox %%r13, %%r14;"
+		"  adcx %%rax, %%r14;"
+		"  mov $0, %%rax;"
+		"  adox %%rdx, %%rax;"
+		"  adcx %%r8, %%rax;"
+
 		/* Compute src1[2] * src2 */
-		"  movq 16(%1), %%rdx;"
-		"  mulxq 0(%3), %%r8, %%r9;"       "  xor %%r10d, %%r10d;"   "  adcxq 16(%0), %%r8;"   "  movq %%r8, 16(%0);"
-		"  mulxq 8(%3), %%r10, %%r11;"     "  adox %%r9, %%r10;"     "  adcx %%rbx, %%r10;"    "  movq %%r10, 24(%0);"
-		"  mulxq 16(%3), %%rbx, %%r13;"    "  adox %%r11, %%rbx;"    "  adcx %%r14, %%rbx;"    "  mov $0, %%r8;"
-		"  mulxq 24(%3), %%r14, %%rdx;"    "  adox %%r13, %%r14;"    "  adcx %%rax, %%r14;"    "  mov $0, %%rax;"
-		                                   "  adox %%rdx, %%rax;"    "  adcx %%r8, %%rax;"
+		"  movq 16(%0), %%rdx;"
+		"  mulxq 0(%1), %%r8, %%r9;"
+		"  xor %%r10d, %%r10d;"
+		"  adcxq 16(%2), %%r8;"
+		"  movq %%r8, 16(%2);"
+		"  mulxq 8(%1), %%r10, %%r11;"
+		"  adox %%r9, %%r10;"
+		"  adcx %%rbx, %%r10;"
+		"  movq %%r10, 24(%2);"
+		"  mulxq 16(%1), %%rbx, %%r13;"
+		"  adox %%r11, %%rbx;"
+		"  adcx %%r14, %%rbx;"
+		"  mov $0, %%r8;"
+		"  mulxq 24(%1), %%r14, %%rdx;"
+		"  adox %%r13, %%r14;"
+		"  adcx %%rax, %%r14;"
+		"  mov $0, %%rax;"
+		"  adox %%rdx, %%rax;"
+		"  adcx %%r8, %%rax;"
+
 		/* Compute src1[3] * src2 */
-		"  movq 24(%1), %%rdx;"
-		"  mulxq 0(%3), %%r8, %%r9;"       "  xor %%r10d, %%r10d;"   "  adcxq 24(%0), %%r8;"   "  movq %%r8, 24(%0);"
-		"  mulxq 8(%3), %%r10, %%r11;"     "  adox %%r9, %%r10;"     "  adcx %%rbx, %%r10;"    "  movq %%r10, 32(%0);"
-		"  mulxq 16(%3), %%rbx, %%r13;"    "  adox %%r11, %%rbx;"    "  adcx %%r14, %%rbx;"    "  movq %%rbx, 40(%0);"    "  mov $0, %%r8;"
-		"  mulxq 24(%3), %%r14, %%rdx;"    "  adox %%r13, %%r14;"    "  adcx %%rax, %%r14;"    "  movq %%r14, 48(%0);"    "  mov $0, %%rax;"
-		                                   "  adox %%rdx, %%rax;"    "  adcx %%r8, %%rax;"     "  movq %%rax, 56(%0);"
+		"  movq 24(%0), %%rdx;"
+		"  mulxq 0(%1), %%r8, %%r9;"
+		"  xor %%r10d, %%r10d;"
+		"  adcxq 24(%2), %%r8;"
+		"  movq %%r8, 24(%2);"
+		"  mulxq 8(%1), %%r10, %%r11;"
+		"  adox %%r9, %%r10;"
+		"  adcx %%rbx, %%r10;"
+		"  movq %%r10, 32(%2);"
+		"  mulxq 16(%1), %%rbx, %%r13;"
+		"  adox %%r11, %%rbx;"
+		"  adcx %%r14, %%rbx;"
+		"  movq %%rbx, 40(%2);"
+		"  mov $0, %%r8;"
+		"  mulxq 24(%1), %%r14, %%rdx;"
+		"  adox %%r13, %%r14;"
+		"  adcx %%rax, %%r14;"
+		"  movq %%r14, 48(%2);"
+		"  mov $0, %%rax;"
+		"  adox %%rdx, %%rax;"
+		"  adcx %%r8, %%rax;"
+		"  movq %%rax, 56(%2);"
+
 		/* Line up pointers */
-		"  mov %0, %1;"
 		"  mov %2, %0;"
+		"  mov %3, %2;"
 
 		/* Wrap the result back into the field */
 
 		/* Step 1: Compute dst + carry == tmp_hi * 38 + tmp_lo */
 		"  mov $38, %%rdx;"
-		"  mulxq 32(%1), %%r8, %%r13;"
-		"  xor %k3, %k3;"
-		"  adoxq 0(%1), %%r8;"
-		"  mulxq 40(%1), %%r9, %%rbx;"
+		"  mulxq 32(%0), %%r8, %%r13;"
+		"  xor %k1, %k1;"
+		"  adoxq 0(%0), %%r8;"
+		"  mulxq 40(%0), %%r9, %%rbx;"
 		"  adcx %%r13, %%r9;"
-		"  adoxq 8(%1), %%r9;"
-		"  mulxq 48(%1), %%r10, %%r13;"
+		"  adoxq 8(%0), %%r9;"
+		"  mulxq 48(%0), %%r10, %%r13;"
 		"  adcx %%rbx, %%r10;"
-		"  adoxq 16(%1), %%r10;"
-		"  mulxq 56(%1), %%r11, %%rax;"
+		"  adoxq 16(%0), %%r10;"
+		"  mulxq 56(%0), %%r11, %%rax;"
 		"  adcx %%r13, %%r11;"
-		"  adoxq 24(%1), %%r11;"
-		"  adcx %3, %%rax;"
-		"  adox %3, %%rax;"
+		"  adoxq 24(%0), %%r11;"
+		"  adcx %1, %%rax;"
+		"  adox %1, %%rax;"
 		"  imul %%rdx, %%rax;"
 
 		/* Step 2: Fold the carry back into dst */
 		"  add %%rax, %%r8;"
-		"  adcx %3, %%r9;"
-		"  movq %%r9, 8(%0);"
-		"  adcx %3, %%r10;"
-		"  movq %%r10, 16(%0);"
-		"  adcx %3, %%r11;"
-		"  movq %%r11, 24(%0);"
+		"  adcx %1, %%r9;"
+		"  movq %%r9, 8(%2);"
+		"  adcx %1, %%r10;"
+		"  movq %%r10, 16(%2);"
+		"  adcx %1, %%r11;"
+		"  movq %%r11, 24(%2);"
 
 		/* Step 3: Fold the carry bit back in; guaranteed not to carry at this point */
 		"  mov $0, %%rax;"
 		"  cmovc %%rdx, %%rax;"
 		"  add %%rax, %%r8;"
-		"  movq %%r8, 0(%0);"
-	: "+&r" (tmp), "+&r" (f1), "+&r" (out), "+&r" (f2)
-	:
-	: "%rax", "%rdx", "%r8", "%r9", "%r10", "%r11", "%rbx", "%r13", "%r14", "memory", "cc"
-	);
+		"  movq %%r8, 0(%2);"
+		: "+&r"(f1), "+&r"(f2), "+&r"(tmp)
+		: "r"(out)
+		: "%rax", "%rbx", "%rdx", "%r8", "%r9", "%r10", "%r11", "%r13",
+		  "%r14", "memory", "cc");
 }
 
 /* Computes two field multiplications:
- * out[0] <- f1[0] * f2[0]
- * out[1] <- f1[1] * f2[1]
- * Uses the 16-element buffer tmp for intermediate results. */
+ *   out[0] <- f1[0] * f2[0]
+ *   out[1] <- f1[1] * f2[1]
+ * Uses the 16-element buffer tmp for intermediate results: */
 static inline void fmul2(u64 *out, const u64 *f1, const u64 *f2, u64 *tmp)
 {
 	asm volatile(
+
 		/* Compute the raw multiplication tmp[0] <- f1[0] * f2[0] */
 
 		/* Compute src1[0] * src2 */
-		"  movq 0(%1), %%rdx;"
-		"  mulxq 0(%3), %%r8, %%r9;"       "  xor %%r10d, %%r10d;"   "  movq %%r8, 0(%0);"
-		"  mulxq 8(%3), %%r10, %%r11;"     "  adox %%r9, %%r10;"     "  movq %%r10, 8(%0);"
-		"  mulxq 16(%3), %%rbx, %%r13;"    "  adox %%r11, %%rbx;"
-		"  mulxq 24(%3), %%r14, %%rdx;"    "  adox %%r13, %%r14;"    "  mov $0, %%rax;"
-		                                   "  adox %%rdx, %%rax;"
+		"  movq 0(%0), %%rdx;"
+		"  mulxq 0(%1), %%r8, %%r9;"
+		"  xor %%r10d, %%r10d;"
+		"  movq %%r8, 0(%2);"
+		"  mulxq 8(%1), %%r10, %%r11;"
+		"  adox %%r9, %%r10;"
+		"  movq %%r10, 8(%2);"
+		"  mulxq 16(%1), %%rbx, %%r13;"
+		"  adox %%r11, %%rbx;"
+		"  mulxq 24(%1), %%r14, %%rdx;"
+		"  adox %%r13, %%r14;"
+		"  mov $0, %%rax;"
+		"  adox %%rdx, %%rax;"
+
 		/* Compute src1[1] * src2 */
-		"  movq 8(%1), %%rdx;"
-		"  mulxq 0(%3), %%r8, %%r9;"       "  xor %%r10d, %%r10d;"   "  adcxq 8(%0), %%r8;"    "  movq %%r8, 8(%0);"
-		"  mulxq 8(%3), %%r10, %%r11;"     "  adox %%r9, %%r10;"     "  adcx %%rbx, %%r10;"    "  movq %%r10, 16(%0);"
-		"  mulxq 16(%3), %%rbx, %%r13;"    "  adox %%r11, %%rbx;"    "  adcx %%r14, %%rbx;"    "  mov $0, %%r8;"
-		"  mulxq 24(%3), %%r14, %%rdx;"    "  adox %%r13, %%r14;"    "  adcx %%rax, %%r14;"    "  mov $0, %%rax;"
-		                                   "  adox %%rdx, %%rax;"    "  adcx %%r8, %%rax;"
+		"  movq 8(%0), %%rdx;"
+		"  mulxq 0(%1), %%r8, %%r9;"
+		"  xor %%r10d, %%r10d;"
+		"  adcxq 8(%2), %%r8;"
+		"  movq %%r8, 8(%2);"
+		"  mulxq 8(%1), %%r10, %%r11;"
+		"  adox %%r9, %%r10;"
+		"  adcx %%rbx, %%r10;"
+		"  movq %%r10, 16(%2);"
+		"  mulxq 16(%1), %%rbx, %%r13;"
+		"  adox %%r11, %%rbx;"
+		"  adcx %%r14, %%rbx;"
+		"  mov $0, %%r8;"
+		"  mulxq 24(%1), %%r14, %%rdx;"
+		"  adox %%r13, %%r14;"
+		"  adcx %%rax, %%r14;"
+		"  mov $0, %%rax;"
+		"  adox %%rdx, %%rax;"
+		"  adcx %%r8, %%rax;"
+
 		/* Compute src1[2] * src2 */
-		"  movq 16(%1), %%rdx;"
-		"  mulxq 0(%3), %%r8, %%r9;"       "  xor %%r10d, %%r10d;"   "  adcxq 16(%0), %%r8;"   "  movq %%r8, 16(%0);"
-		"  mulxq 8(%3), %%r10, %%r11;"     "  adox %%r9, %%r10;"     "  adcx %%rbx, %%r10;"    "  movq %%r10, 24(%0);"
-		"  mulxq 16(%3), %%rbx, %%r13;"    "  adox %%r11, %%rbx;"    "  adcx %%r14, %%rbx;"    "  mov $0, %%r8;"
-		"  mulxq 24(%3), %%r14, %%rdx;"    "  adox %%r13, %%r14;"    "  adcx %%rax, %%r14;"    "  mov $0, %%rax;"
-		                                   "  adox %%rdx, %%rax;"    "  adcx %%r8, %%rax;"
+		"  movq 16(%0), %%rdx;"
+		"  mulxq 0(%1), %%r8, %%r9;"
+		"  xor %%r10d, %%r10d;"
+		"  adcxq 16(%2), %%r8;"
+		"  movq %%r8, 16(%2);"
+		"  mulxq 8(%1), %%r10, %%r11;"
+		"  adox %%r9, %%r10;"
+		"  adcx %%rbx, %%r10;"
+		"  movq %%r10, 24(%2);"
+		"  mulxq 16(%1), %%rbx, %%r13;"
+		"  adox %%r11, %%rbx;"
+		"  adcx %%r14, %%rbx;"
+		"  mov $0, %%r8;"
+		"  mulxq 24(%1), %%r14, %%rdx;"
+		"  adox %%r13, %%r14;"
+		"  adcx %%rax, %%r14;"
+		"  mov $0, %%rax;"
+		"  adox %%rdx, %%rax;"
+		"  adcx %%r8, %%rax;"
+
 		/* Compute src1[3] * src2 */
-		"  movq 24(%1), %%rdx;"
-		"  mulxq 0(%3), %%r8, %%r9;"       "  xor %%r10d, %%r10d;"   "  adcxq 24(%0), %%r8;"   "  movq %%r8, 24(%0);"
-		"  mulxq 8(%3), %%r10, %%r11;"     "  adox %%r9, %%r10;"     "  adcx %%rbx, %%r10;"    "  movq %%r10, 32(%0);"
-		"  mulxq 16(%3), %%rbx, %%r13;"    "  adox %%r11, %%rbx;"    "  adcx %%r14, %%rbx;"    "  movq %%rbx, 40(%0);"    "  mov $0, %%r8;"
-		"  mulxq 24(%3), %%r14, %%rdx;"    "  adox %%r13, %%r14;"    "  adcx %%rax, %%r14;"    "  movq %%r14, 48(%0);"    "  mov $0, %%rax;"
-		                                   "  adox %%rdx, %%rax;"    "  adcx %%r8, %%rax;"     "  movq %%rax, 56(%0);"
+		"  movq 24(%0), %%rdx;"
+		"  mulxq 0(%1), %%r8, %%r9;"
+		"  xor %%r10d, %%r10d;"
+		"  adcxq 24(%2), %%r8;"
+		"  movq %%r8, 24(%2);"
+		"  mulxq 8(%1), %%r10, %%r11;"
+		"  adox %%r9, %%r10;"
+		"  adcx %%rbx, %%r10;"
+		"  movq %%r10, 32(%2);"
+		"  mulxq 16(%1), %%rbx, %%r13;"
+		"  adox %%r11, %%rbx;"
+		"  adcx %%r14, %%rbx;"
+		"  movq %%rbx, 40(%2);"
+		"  mov $0, %%r8;"
+		"  mulxq 24(%1), %%r14, %%rdx;"
+		"  adox %%r13, %%r14;"
+		"  adcx %%rax, %%r14;"
+		"  movq %%r14, 48(%2);"
+		"  mov $0, %%rax;"
+		"  adox %%rdx, %%rax;"
+		"  adcx %%r8, %%rax;"
+		"  movq %%rax, 56(%2);"
 
 		/* Compute the raw multiplication tmp[1] <- f1[1] * f2[1] */
 
 		/* Compute src1[0] * src2 */
-		"  movq 32(%1), %%rdx;"
-		"  mulxq 32(%3), %%r8, %%r9;"      "  xor %%r10d, %%r10d;"   "  movq %%r8, 64(%0);"
-		"  mulxq 40(%3), %%r10, %%r11;"    "  adox %%r9, %%r10;"     "  movq %%r10, 72(%0);"
-		"  mulxq 48(%3), %%rbx, %%r13;"    "  adox %%r11, %%rbx;"
-		"  mulxq 56(%3), %%r14, %%rdx;"    "  adox %%r13, %%r14;"    "  mov $0, %%rax;"
-		                                   "  adox %%rdx, %%rax;"
+		"  movq 32(%0), %%rdx;"
+		"  mulxq 32(%1), %%r8, %%r9;"
+		"  xor %%r10d, %%r10d;"
+		"  movq %%r8, 64(%2);"
+		"  mulxq 40(%1), %%r10, %%r11;"
+		"  adox %%r9, %%r10;"
+		"  movq %%r10, 72(%2);"
+		"  mulxq 48(%1), %%rbx, %%r13;"
+		"  adox %%r11, %%rbx;"
+		"  mulxq 56(%1), %%r14, %%rdx;"
+		"  adox %%r13, %%r14;"
+		"  mov $0, %%rax;"
+		"  adox %%rdx, %%rax;"
+
 		/* Compute src1[1] * src2 */
-		"  movq 40(%1), %%rdx;"
-		"  mulxq 32(%3), %%r8, %%r9;"      "  xor %%r10d, %%r10d;"   "  adcxq 72(%0), %%r8;"   "  movq %%r8, 72(%0);"
-		"  mulxq 40(%3), %%r10, %%r11;"    "  adox %%r9, %%r10;"     "  adcx %%rbx, %%r10;"    "  movq %%r10, 80(%0);"
-		"  mulxq 48(%3), %%rbx, %%r13;"    "  adox %%r11, %%rbx;"    "  adcx %%r14, %%rbx;"    "  mov $0, %%r8;"
-		"  mulxq 56(%3), %%r14, %%rdx;"    "  adox %%r13, %%r14;"    "  adcx %%rax, %%r14;"    "  mov $0, %%rax;"
-		                                   "  adox %%rdx, %%rax;"    "  adcx %%r8, %%rax;"
+		"  movq 40(%0), %%rdx;"
+		"  mulxq 32(%1), %%r8, %%r9;"
+		"  xor %%r10d, %%r10d;"
+		"  adcxq 72(%2), %%r8;"
+		"  movq %%r8, 72(%2);"
+		"  mulxq 40(%1), %%r10, %%r11;"
+		"  adox %%r9, %%r10;"
+		"  adcx %%rbx, %%r10;"
+		"  movq %%r10, 80(%2);"
+		"  mulxq 48(%1), %%rbx, %%r13;"
+		"  adox %%r11, %%rbx;"
+		"  adcx %%r14, %%rbx;"
+		"  mov $0, %%r8;"
+		"  mulxq 56(%1), %%r14, %%rdx;"
+		"  adox %%r13, %%r14;"
+		"  adcx %%rax, %%r14;"
+		"  mov $0, %%rax;"
+		"  adox %%rdx, %%rax;"
+		"  adcx %%r8, %%rax;"
+
 		/* Compute src1[2] * src2 */
-		"  movq 48(%1), %%rdx;"
-		"  mulxq 32(%3), %%r8, %%r9;"      "  xor %%r10d, %%r10d;"   "  adcxq 80(%0), %%r8;"   "  movq %%r8, 80(%0);"
-		"  mulxq 40(%3), %%r10, %%r11;"    "  adox %%r9, %%r10;"     "  adcx %%rbx, %%r10;"    "  movq %%r10, 88(%0);"
-		"  mulxq 48(%3), %%rbx, %%r13;"    "  adox %%r11, %%rbx;"    "  adcx %%r14, %%rbx;"    "  mov $0, %%r8;"
-		"  mulxq 56(%3), %%r14, %%rdx;"    "  adox %%r13, %%r14;"    "  adcx %%rax, %%r14;"    "  mov $0, %%rax;"
-		                                   "  adox %%rdx, %%rax;"    "  adcx %%r8, %%rax;"
+		"  movq 48(%0), %%rdx;"
+		"  mulxq 32(%1), %%r8, %%r9;"
+		"  xor %%r10d, %%r10d;"
+		"  adcxq 80(%2), %%r8;"
+		"  movq %%r8, 80(%2);"
+		"  mulxq 40(%1), %%r10, %%r11;"
+		"  adox %%r9, %%r10;"
+		"  adcx %%rbx, %%r10;"
+		"  movq %%r10, 88(%2);"
+		"  mulxq 48(%1), %%rbx, %%r13;"
+		"  adox %%r11, %%rbx;"
+		"  adcx %%r14, %%rbx;"
+		"  mov $0, %%r8;"
+		"  mulxq 56(%1), %%r14, %%rdx;"
+		"  adox %%r13, %%r14;"
+		"  adcx %%rax, %%r14;"
+		"  mov $0, %%rax;"
+		"  adox %%rdx, %%rax;"
+		"  adcx %%r8, %%rax;"
+
 		/* Compute src1[3] * src2 */
-		"  movq 56(%1), %%rdx;"
-		"  mulxq 32(%3), %%r8, %%r9;"      "  xor %%r10d, %%r10d;"   "  adcxq 88(%0), %%r8;"   "  movq %%r8, 88(%0);"
-		"  mulxq 40(%3), %%r10, %%r11;"    "  adox %%r9, %%r10;"     "  adcx %%rbx, %%r10;"    "  movq %%r10, 96(%0);"
-		"  mulxq 48(%3), %%rbx, %%r13;"    "  adox %%r11, %%rbx;"    "  adcx %%r14, %%rbx;"    "  movq %%rbx, 104(%0);"    "  mov $0, %%r8;"
-		"  mulxq 56(%3), %%r14, %%rdx;"    "  adox %%r13, %%r14;"    "  adcx %%rax, %%r14;"    "  movq %%r14, 112(%0);"    "  mov $0, %%rax;"
-		                                   "  adox %%rdx, %%rax;"    "  adcx %%r8, %%rax;"     "  movq %%rax, 120(%0);"
+		"  movq 56(%0), %%rdx;"
+		"  mulxq 32(%1), %%r8, %%r9;"
+		"  xor %%r10d, %%r10d;"
+		"  adcxq 88(%2), %%r8;"
+		"  movq %%r8, 88(%2);"
+		"  mulxq 40(%1), %%r10, %%r11;"
+		"  adox %%r9, %%r10;"
+		"  adcx %%rbx, %%r10;"
+		"  movq %%r10, 96(%2);"
+		"  mulxq 48(%1), %%rbx, %%r13;"
+		"  adox %%r11, %%rbx;"
+		"  adcx %%r14, %%rbx;"
+		"  movq %%rbx, 104(%2);"
+		"  mov $0, %%r8;"
+		"  mulxq 56(%1), %%r14, %%rdx;"
+		"  adox %%r13, %%r14;"
+		"  adcx %%rax, %%r14;"
+		"  movq %%r14, 112(%2);"
+		"  mov $0, %%rax;"
+		"  adox %%rdx, %%rax;"
+		"  adcx %%r8, %%rax;"
+		"  movq %%rax, 120(%2);"
+
 		/* Line up pointers */
-		"  mov %0, %1;"
 		"  mov %2, %0;"
+		"  mov %3, %2;"
 
 		/* Wrap the results back into the field */
 
 		/* Step 1: Compute dst + carry == tmp_hi * 38 + tmp_lo */
 		"  mov $38, %%rdx;"
-		"  mulxq 32(%1), %%r8, %%r13;"
-		"  xor %k3, %k3;"
-		"  adoxq 0(%1), %%r8;"
-		"  mulxq 40(%1), %%r9, %%rbx;"
+		"  mulxq 32(%0), %%r8, %%r13;"
+		"  xor %k1, %k1;"
+		"  adoxq 0(%0), %%r8;"
+		"  mulxq 40(%0), %%r9, %%rbx;"
 		"  adcx %%r13, %%r9;"
-		"  adoxq 8(%1), %%r9;"
-		"  mulxq 48(%1), %%r10, %%r13;"
+		"  adoxq 8(%0), %%r9;"
+		"  mulxq 48(%0), %%r10, %%r13;"
 		"  adcx %%rbx, %%r10;"
-		"  adoxq 16(%1), %%r10;"
-		"  mulxq 56(%1), %%r11, %%rax;"
+		"  adoxq 16(%0), %%r10;"
+		"  mulxq 56(%0), %%r11, %%rax;"
 		"  adcx %%r13, %%r11;"
-		"  adoxq 24(%1), %%r11;"
-		"  adcx %3, %%rax;"
-		"  adox %3, %%rax;"
+		"  adoxq 24(%0), %%r11;"
+		"  adcx %1, %%rax;"
+		"  adox %1, %%rax;"
 		"  imul %%rdx, %%rax;"
 
 		/* Step 2: Fold the carry back into dst */
 		"  add %%rax, %%r8;"
-		"  adcx %3, %%r9;"
-		"  movq %%r9, 8(%0);"
-		"  adcx %3, %%r10;"
-		"  movq %%r10, 16(%0);"
-		"  adcx %3, %%r11;"
-		"  movq %%r11, 24(%0);"
+		"  adcx %1, %%r9;"
+		"  movq %%r9, 8(%2);"
+		"  adcx %1, %%r10;"
+		"  movq %%r10, 16(%2);"
+		"  adcx %1, %%r11;"
+		"  movq %%r11, 24(%2);"
 
 		/* Step 3: Fold the carry bit back in; guaranteed not to carry at this point */
 		"  mov $0, %%rax;"
 		"  cmovc %%rdx, %%rax;"
 		"  add %%rax, %%r8;"
-		"  movq %%r8, 0(%0);"
+		"  movq %%r8, 0(%2);"
 
 		/* Step 1: Compute dst + carry == tmp_hi * 38 + tmp_lo */
 		"  mov $38, %%rdx;"
-		"  mulxq 96(%1), %%r8, %%r13;"
-		"  xor %k3, %k3;"
-		"  adoxq 64(%1), %%r8;"
-		"  mulxq 104(%1), %%r9, %%rbx;"
+		"  mulxq 96(%0), %%r8, %%r13;"
+		"  xor %k1, %k1;"
+		"  adoxq 64(%0), %%r8;"
+		"  mulxq 104(%0), %%r9, %%rbx;"
 		"  adcx %%r13, %%r9;"
-		"  adoxq 72(%1), %%r9;"
-		"  mulxq 112(%1), %%r10, %%r13;"
+		"  adoxq 72(%0), %%r9;"
+		"  mulxq 112(%0), %%r10, %%r13;"
 		"  adcx %%rbx, %%r10;"
-		"  adoxq 80(%1), %%r10;"
-		"  mulxq 120(%1), %%r11, %%rax;"
+		"  adoxq 80(%0), %%r10;"
+		"  mulxq 120(%0), %%r11, %%rax;"
 		"  adcx %%r13, %%r11;"
-		"  adoxq 88(%1), %%r11;"
-		"  adcx %3, %%rax;"
-		"  adox %3, %%rax;"
+		"  adoxq 88(%0), %%r11;"
+		"  adcx %1, %%rax;"
+		"  adox %1, %%rax;"
 		"  imul %%rdx, %%rax;"
 
 		/* Step 2: Fold the carry back into dst */
 		"  add %%rax, %%r8;"
-		"  adcx %3, %%r9;"
-		"  movq %%r9, 40(%0);"
-		"  adcx %3, %%r10;"
-		"  movq %%r10, 48(%0);"
-		"  adcx %3, %%r11;"
-		"  movq %%r11, 56(%0);"
+		"  adcx %1, %%r9;"
+		"  movq %%r9, 40(%2);"
+		"  adcx %1, %%r10;"
+		"  movq %%r10, 48(%2);"
+		"  adcx %1, %%r11;"
+		"  movq %%r11, 56(%2);"
 
 		/* Step 3: Fold the carry bit back in; guaranteed not to carry at this point */
 		"  mov $0, %%rax;"
 		"  cmovc %%rdx, %%rax;"
 		"  add %%rax, %%r8;"
-		"  movq %%r8, 32(%0);"
-	: "+&r" (tmp), "+&r" (f1), "+&r" (out), "+&r" (f2)
-	:
-	: "%rax", "%rdx", "%r8", "%r9", "%r10", "%r11", "%rbx", "%r13", "%r14", "memory", "cc"
-	);
+		"  movq %%r8, 32(%2);"
+		: "+&r"(f1), "+&r"(f2), "+&r"(tmp)
+		: "r"(out)
+		: "%rax", "%rbx", "%rdx", "%r8", "%r9", "%r10", "%r11", "%r13",
+		  "%r14", "memory", "cc");
 }
 
-/* Computes the field multiplication of four-element f1 with value in f2 */
+/* Computes the field multiplication of four-element f1 with value in f2
+ * Requires f2 to be smaller than 2^17 */
 static inline void fmul_scalar(u64 *out, const u64 *f1, u64 f2)
 {
 	register u64 f2_r asm("rdx") = f2;
 
 	asm volatile(
 		/* Compute the raw multiplication of f1*f2 */
-		"  mulxq 0(%2), %%r8, %%rcx;"      /* f1[0]*f2 */
-		"  mulxq 8(%2), %%r9, %%rbx;"      /* f1[1]*f2 */
+		"  mulxq 0(%2), %%r8, %%rcx;" /* f1[0]*f2 */
+		"  mulxq 8(%2), %%r9, %%rbx;" /* f1[1]*f2 */
 		"  add %%rcx, %%r9;"
 		"  mov $0, %%rcx;"
-		"  mulxq 16(%2), %%r10, %%r13;"    /* f1[2]*f2 */
+		"  mulxq 16(%2), %%r10, %%r13;" /* f1[2]*f2 */
 		"  adcx %%rbx, %%r10;"
-		"  mulxq 24(%2), %%r11, %%rax;"    /* f1[3]*f2 */
+		"  mulxq 24(%2), %%r11, %%rax;" /* f1[3]*f2 */
 		"  adcx %%r13, %%r11;"
 		"  adcx %%rcx, %%rax;"
 
@@ -418,17 +576,17 @@ static inline void fmul_scalar(u64 *out, const u64 *f1, u64 f2)
 		"  cmovc %%rdx, %%rax;"
 		"  add %%rax, %%r8;"
 		"  movq %%r8, 0(%1);"
-	: "+&r" (f2_r)
-	: "r" (out), "r" (f1)
-	: "%rax", "%rcx", "%r8", "%r9", "%r10", "%r11", "%rbx", "%r13", "memory", "cc"
-	);
+		: "+&r"(f2_r)
+		: "r"(out), "r"(f1)
+		: "%rax", "%rbx", "%rcx", "%r8", "%r9", "%r10", "%r11", "%r13",
+		  "memory", "cc");
 }
 
 /* Computes p1 <- bit ? p2 : p1 in constant time */
 static inline void cswap2(u64 bit, const u64 *p1, const u64 *p2)
 {
 	asm volatile(
-		/* Invert the polarity of bit to match cmov expectations */
+		/* Transfer bit into CF flag */
 		"  add $18446744073709551615, %0;"
 
 		/* cswap p1[0], p2[0] */
@@ -502,10 +660,9 @@ static inline void cswap2(u64 bit, const u64 *p1, const u64 *p2)
 		"  cmovc %%r10, %%r9;"
 		"  movq %%r8, 56(%1);"
 		"  movq %%r9, 56(%2);"
-	: "+&r" (bit)
-	: "r" (p1), "r" (p2)
-	: "%r8", "%r9", "%r10", "memory", "cc"
-	);
+		: "+&r"(bit)
+		: "r"(p1), "r"(p2)
+		: "%r8", "%r9", "%r10", "memory", "cc");
 }
 
 /* Computes the square of a field element: out <- f * f
@@ -516,15 +673,22 @@ static inline void fsqr(u64 *out, const u64 *f, u64 *tmp)
 		/* Compute the raw multiplication: tmp <- f * f */
 
 		/* Step 1: Compute all partial products */
-		"  movq 0(%1), %%rdx;"                                       /* f[0] */
-		"  mulxq 8(%1), %%r8, %%r14;"      "  xor %%r15d, %%r15d;"   /* f[1]*f[0] */
-		"  mulxq 16(%1), %%r9, %%r10;"     "  adcx %%r14, %%r9;"     /* f[2]*f[0] */
-		"  mulxq 24(%1), %%rax, %%rcx;"    "  adcx %%rax, %%r10;"    /* f[3]*f[0] */
-		"  movq 24(%1), %%rdx;"                                      /* f[3] */
-		"  mulxq 8(%1), %%r11, %%rbx;"     "  adcx %%rcx, %%r11;"    /* f[1]*f[3] */
-		"  mulxq 16(%1), %%rax, %%r13;"    "  adcx %%rax, %%rbx;"    /* f[2]*f[3] */
-		"  movq 8(%1), %%rdx;"             "  adcx %%r15, %%r13;"    /* f1 */
-		"  mulxq 16(%1), %%rax, %%rcx;"    "  mov $0, %%r14;"        /* f[2]*f[1] */
+		"  movq 0(%0), %%rdx;" /* f[0] */
+		"  mulxq 8(%0), %%r8, %%r14;"
+		"  xor %%r15d, %%r15d;" /* f[1]*f[0] */
+		"  mulxq 16(%0), %%r9, %%r10;"
+		"  adcx %%r14, %%r9;" /* f[2]*f[0] */
+		"  mulxq 24(%0), %%rax, %%rcx;"
+		"  adcx %%rax, %%r10;" /* f[3]*f[0] */
+		"  movq 24(%0), %%rdx;" /* f[3] */
+		"  mulxq 8(%0), %%r11, %%rbx;"
+		"  adcx %%rcx, %%r11;" /* f[1]*f[3] */
+		"  mulxq 16(%0), %%rax, %%r13;"
+		"  adcx %%rax, %%rbx;" /* f[2]*f[3] */
+		"  movq 8(%0), %%rdx;"
+		"  adcx %%r15, %%r13;" /* f1 */
+		"  mulxq 16(%0), %%rax, %%rcx;"
+		"  mov $0, %%r14;" /* f[2]*f[1] */
 
 		/* Step 2: Compute two parallel carry chains */
 		"  xor %%r15d, %%r15d;"
@@ -542,39 +706,50 @@ static inline void fsqr(u64 *out, const u64 *f, u64 *tmp)
 		"  adcx %%r14, %%r14;"
 
 		/* Step 3: Compute intermediate squares */
-		"  movq 0(%1), %%rdx;"     "  mulx %%rdx, %%rax, %%rcx;"    /* f[0]^2 */
-		                           "  movq %%rax, 0(%0);"
-		"  add %%rcx, %%r8;"       "  movq %%r8, 8(%0);"
-		"  movq 8(%1), %%rdx;"     "  mulx %%rdx, %%rax, %%rcx;"    /* f[1]^2 */
-		"  adcx %%rax, %%r9;"      "  movq %%r9, 16(%0);"
-		"  adcx %%rcx, %%r10;"     "  movq %%r10, 24(%0);"
-		"  movq 16(%1), %%rdx;"    "  mulx %%rdx, %%rax, %%rcx;"    /* f[2]^2 */
-		"  adcx %%rax, %%r11;"     "  movq %%r11, 32(%0);"
-		"  adcx %%rcx, %%rbx;"     "  movq %%rbx, 40(%0);"
-		"  movq 24(%1), %%rdx;"    "  mulx %%rdx, %%rax, %%rcx;"    /* f[3]^2 */
-		"  adcx %%rax, %%r13;"     "  movq %%r13, 48(%0);"
-		"  adcx %%rcx, %%r14;"     "  movq %%r14, 56(%0);"
+		"  movq 0(%0), %%rdx;"
+		"  mulx %%rdx, %%rax, %%rcx;" /* f[0]^2 */
+		"  movq %%rax, 0(%1);"
+		"  add %%rcx, %%r8;"
+		"  movq %%r8, 8(%1);"
+		"  movq 8(%0), %%rdx;"
+		"  mulx %%rdx, %%rax, %%rcx;" /* f[1]^2 */
+		"  adcx %%rax, %%r9;"
+		"  movq %%r9, 16(%1);"
+		"  adcx %%rcx, %%r10;"
+		"  movq %%r10, 24(%1);"
+		"  movq 16(%0), %%rdx;"
+		"  mulx %%rdx, %%rax, %%rcx;" /* f[2]^2 */
+		"  adcx %%rax, %%r11;"
+		"  movq %%r11, 32(%1);"
+		"  adcx %%rcx, %%rbx;"
+		"  movq %%rbx, 40(%1);"
+		"  movq 24(%0), %%rdx;"
+		"  mulx %%rdx, %%rax, %%rcx;" /* f[3]^2 */
+		"  adcx %%rax, %%r13;"
+		"  movq %%r13, 48(%1);"
+		"  adcx %%rcx, %%r14;"
+		"  movq %%r14, 56(%1);"
 
 		/* Line up pointers */
-		"  mov %0, %1;"
-		"  mov %2, %0;"
+		"  mov %1, %0;"
+		"  mov %2, %1;"
 
 		/* Wrap the result back into the field */
 
 		/* Step 1: Compute dst + carry == tmp_hi * 38 + tmp_lo */
 		"  mov $38, %%rdx;"
-		"  mulxq 32(%1), %%r8, %%r13;"
+		"  mulxq 32(%0), %%r8, %%r13;"
 		"  xor %%ecx, %%ecx;"
-		"  adoxq 0(%1), %%r8;"
-		"  mulxq 40(%1), %%r9, %%rbx;"
+		"  adoxq 0(%0), %%r8;"
+		"  mulxq 40(%0), %%r9, %%rbx;"
 		"  adcx %%r13, %%r9;"
-		"  adoxq 8(%1), %%r9;"
-		"  mulxq 48(%1), %%r10, %%r13;"
+		"  adoxq 8(%0), %%r9;"
+		"  mulxq 48(%0), %%r10, %%r13;"
 		"  adcx %%rbx, %%r10;"
-		"  adoxq 16(%1), %%r10;"
-		"  mulxq 56(%1), %%r11, %%rax;"
+		"  adoxq 16(%0), %%r10;"
+		"  mulxq 56(%0), %%r11, %%rax;"
 		"  adcx %%r13, %%r11;"
-		"  adoxq 24(%1), %%r11;"
+		"  adoxq 24(%0), %%r11;"
 		"  adcx %%rcx, %%rax;"
 		"  adox %%rcx, %%rax;"
 		"  imul %%rdx, %%rax;"
@@ -582,40 +757,47 @@ static inline void fsqr(u64 *out, const u64 *f, u64 *tmp)
 		/* Step 2: Fold the carry back into dst */
 		"  add %%rax, %%r8;"
 		"  adcx %%rcx, %%r9;"
-		"  movq %%r9, 8(%0);"
+		"  movq %%r9, 8(%1);"
 		"  adcx %%rcx, %%r10;"
-		"  movq %%r10, 16(%0);"
+		"  movq %%r10, 16(%1);"
 		"  adcx %%rcx, %%r11;"
-		"  movq %%r11, 24(%0);"
+		"  movq %%r11, 24(%1);"
 
 		/* Step 3: Fold the carry bit back in; guaranteed not to carry at this point */
 		"  mov $0, %%rax;"
 		"  cmovc %%rdx, %%rax;"
 		"  add %%rax, %%r8;"
-		"  movq %%r8, 0(%0);"
-	: "+&r" (tmp), "+&r" (f), "+&r" (out)
-	:
-	: "%rax", "%rcx", "%rdx", "%r8", "%r9", "%r10", "%r11", "%rbx", "%r13", "%r14", "%r15", "memory", "cc"
-	);
+		"  movq %%r8, 0(%1);"
+		: "+&r"(f), "+&r"(tmp)
+		: "r"(out)
+		: "%rax", "%rbx", "%rcx", "%rdx", "%r8", "%r9", "%r10", "%r11",
+		  "%r13", "%r14", "%r15", "memory", "cc");
 }
 
 /* Computes two field squarings:
- * out[0] <- f[0] * f[0]
- * out[1] <- f[1] * f[1]
+ *   out[0] <- f[0] * f[0]
+ *   out[1] <- f[1] * f[1]
  * Uses the 16-element buffer tmp for intermediate results */
 static inline void fsqr2(u64 *out, const u64 *f, u64 *tmp)
 {
 	asm volatile(
 		/* Step 1: Compute all partial products */
-		"  movq 0(%1), %%rdx;"                                       /* f[0] */
-		"  mulxq 8(%1), %%r8, %%r14;"      "  xor %%r15d, %%r15d;"   /* f[1]*f[0] */
-		"  mulxq 16(%1), %%r9, %%r10;"     "  adcx %%r14, %%r9;"     /* f[2]*f[0] */
-		"  mulxq 24(%1), %%rax, %%rcx;"    "  adcx %%rax, %%r10;"    /* f[3]*f[0] */
-		"  movq 24(%1), %%rdx;"                                      /* f[3] */
-		"  mulxq 8(%1), %%r11, %%rbx;"     "  adcx %%rcx, %%r11;"    /* f[1]*f[3] */
-		"  mulxq 16(%1), %%rax, %%r13;"    "  adcx %%rax, %%rbx;"    /* f[2]*f[3] */
-		"  movq 8(%1), %%rdx;"             "  adcx %%r15, %%r13;"    /* f1 */
-		"  mulxq 16(%1), %%rax, %%rcx;"    "  mov $0, %%r14;"        /* f[2]*f[1] */
+		"  movq 0(%0), %%rdx;" /* f[0] */
+		"  mulxq 8(%0), %%r8, %%r14;"
+		"  xor %%r15d, %%r15d;" /* f[1]*f[0] */
+		"  mulxq 16(%0), %%r9, %%r10;"
+		"  adcx %%r14, %%r9;" /* f[2]*f[0] */
+		"  mulxq 24(%0), %%rax, %%rcx;"
+		"  adcx %%rax, %%r10;" /* f[3]*f[0] */
+		"  movq 24(%0), %%rdx;" /* f[3] */
+		"  mulxq 8(%0), %%r11, %%rbx;"
+		"  adcx %%rcx, %%r11;" /* f[1]*f[3] */
+		"  mulxq 16(%0), %%rax, %%r13;"
+		"  adcx %%rax, %%rbx;" /* f[2]*f[3] */
+		"  movq 8(%0), %%rdx;"
+		"  adcx %%r15, %%r13;" /* f1 */
+		"  mulxq 16(%0), %%rax, %%rcx;"
+		"  mov $0, %%r14;" /* f[2]*f[1] */
 
 		/* Step 2: Compute two parallel carry chains */
 		"  xor %%r15d, %%r15d;"
@@ -633,29 +815,47 @@ static inline void fsqr2(u64 *out, const u64 *f, u64 *tmp)
 		"  adcx %%r14, %%r14;"
 
 		/* Step 3: Compute intermediate squares */
-		"  movq 0(%1), %%rdx;"     "  mulx %%rdx, %%rax, %%rcx;"    /* f[0]^2 */
-		                           "  movq %%rax, 0(%0);"
-		"  add %%rcx, %%r8;"       "  movq %%r8, 8(%0);"
-		"  movq 8(%1), %%rdx;"     "  mulx %%rdx, %%rax, %%rcx;"    /* f[1]^2 */
-		"  adcx %%rax, %%r9;"      "  movq %%r9, 16(%0);"
-		"  adcx %%rcx, %%r10;"     "  movq %%r10, 24(%0);"
-		"  movq 16(%1), %%rdx;"    "  mulx %%rdx, %%rax, %%rcx;"    /* f[2]^2 */
-		"  adcx %%rax, %%r11;"     "  movq %%r11, 32(%0);"
-		"  adcx %%rcx, %%rbx;"     "  movq %%rbx, 40(%0);"
-		"  movq 24(%1), %%rdx;"    "  mulx %%rdx, %%rax, %%rcx;"    /* f[3]^2 */
-		"  adcx %%rax, %%r13;"     "  movq %%r13, 48(%0);"
-		"  adcx %%rcx, %%r14;"     "  movq %%r14, 56(%0);"
+		"  movq 0(%0), %%rdx;"
+		"  mulx %%rdx, %%rax, %%rcx;" /* f[0]^2 */
+		"  movq %%rax, 0(%1);"
+		"  add %%rcx, %%r8;"
+		"  movq %%r8, 8(%1);"
+		"  movq 8(%0), %%rdx;"
+		"  mulx %%rdx, %%rax, %%rcx;" /* f[1]^2 */
+		"  adcx %%rax, %%r9;"
+		"  movq %%r9, 16(%1);"
+		"  adcx %%rcx, %%r10;"
+		"  movq %%r10, 24(%1);"
+		"  movq 16(%0), %%rdx;"
+		"  mulx %%rdx, %%rax, %%rcx;" /* f[2]^2 */
+		"  adcx %%rax, %%r11;"
+		"  movq %%r11, 32(%1);"
+		"  adcx %%rcx, %%rbx;"
+		"  movq %%rbx, 40(%1);"
+		"  movq 24(%0), %%rdx;"
+		"  mulx %%rdx, %%rax, %%rcx;" /* f[3]^2 */
+		"  adcx %%rax, %%r13;"
+		"  movq %%r13, 48(%1);"
+		"  adcx %%rcx, %%r14;"
+		"  movq %%r14, 56(%1);"
 
 		/* Step 1: Compute all partial products */
-		"  movq 32(%1), %%rdx;"                                       /* f[0] */
-		"  mulxq 40(%1), %%r8, %%r14;"     "  xor %%r15d, %%r15d;"   /* f[1]*f[0] */
-		"  mulxq 48(%1), %%r9, %%r10;"     "  adcx %%r14, %%r9;"     /* f[2]*f[0] */
-		"  mulxq 56(%1), %%rax, %%rcx;"    "  adcx %%rax, %%r10;"    /* f[3]*f[0] */
-		"  movq 56(%1), %%rdx;"                                      /* f[3] */
-		"  mulxq 40(%1), %%r11, %%rbx;"     "  adcx %%rcx, %%r11;"    /* f[1]*f[3] */
-		"  mulxq 48(%1), %%rax, %%r13;"    "  adcx %%rax, %%rbx;"    /* f[2]*f[3] */
-		"  movq 40(%1), %%rdx;"             "  adcx %%r15, %%r13;"    /* f1 */
-		"  mulxq 48(%1), %%rax, %%rcx;"    "  mov $0, %%r14;"        /* f[2]*f[1] */
+		"  movq 32(%0), %%rdx;" /* f[0] */
+		"  mulxq 40(%0), %%r8, %%r14;"
+		"  xor %%r15d, %%r15d;" /* f[1]*f[0] */
+		"  mulxq 48(%0), %%r9, %%r10;"
+		"  adcx %%r14, %%r9;" /* f[2]*f[0] */
+		"  mulxq 56(%0), %%rax, %%rcx;"
+		"  adcx %%rax, %%r10;" /* f[3]*f[0] */
+		"  movq 56(%0), %%rdx;" /* f[3] */
+		"  mulxq 40(%0), %%r11, %%rbx;"
+		"  adcx %%rcx, %%r11;" /* f[1]*f[3] */
+		"  mulxq 48(%0), %%rax, %%r13;"
+		"  adcx %%rax, %%rbx;" /* f[2]*f[3] */
+		"  movq 40(%0), %%rdx;"
+		"  adcx %%r15, %%r13;" /* f1 */
+		"  mulxq 48(%0), %%rax, %%rcx;"
+		"  mov $0, %%r14;" /* f[2]*f[1] */
 
 		/* Step 2: Compute two parallel carry chains */
 		"  xor %%r15d, %%r15d;"
@@ -673,37 +873,48 @@ static inline void fsqr2(u64 *out, const u64 *f, u64 *tmp)
 		"  adcx %%r14, %%r14;"
 
 		/* Step 3: Compute intermediate squares */
-		"  movq 32(%1), %%rdx;"     "  mulx %%rdx, %%rax, %%rcx;"    /* f[0]^2 */
-		                           "  movq %%rax, 64(%0);"
-		"  add %%rcx, %%r8;"       "  movq %%r8, 72(%0);"
-		"  movq 40(%1), %%rdx;"     "  mulx %%rdx, %%rax, %%rcx;"    /* f[1]^2 */
-		"  adcx %%rax, %%r9;"      "  movq %%r9, 80(%0);"
-		"  adcx %%rcx, %%r10;"     "  movq %%r10, 88(%0);"
-		"  movq 48(%1), %%rdx;"    "  mulx %%rdx, %%rax, %%rcx;"    /* f[2]^2 */
-		"  adcx %%rax, %%r11;"     "  movq %%r11, 96(%0);"
-		"  adcx %%rcx, %%rbx;"     "  movq %%rbx, 104(%0);"
-		"  movq 56(%1), %%rdx;"    "  mulx %%rdx, %%rax, %%rcx;"    /* f[3]^2 */
-		"  adcx %%rax, %%r13;"     "  movq %%r13, 112(%0);"
-		"  adcx %%rcx, %%r14;"     "  movq %%r14, 120(%0);"
+		"  movq 32(%0), %%rdx;"
+		"  mulx %%rdx, %%rax, %%rcx;" /* f[0]^2 */
+		"  movq %%rax, 64(%1);"
+		"  add %%rcx, %%r8;"
+		"  movq %%r8, 72(%1);"
+		"  movq 40(%0), %%rdx;"
+		"  mulx %%rdx, %%rax, %%rcx;" /* f[1]^2 */
+		"  adcx %%rax, %%r9;"
+		"  movq %%r9, 80(%1);"
+		"  adcx %%rcx, %%r10;"
+		"  movq %%r10, 88(%1);"
+		"  movq 48(%0), %%rdx;"
+		"  mulx %%rdx, %%rax, %%rcx;" /* f[2]^2 */
+		"  adcx %%rax, %%r11;"
+		"  movq %%r11, 96(%1);"
+		"  adcx %%rcx, %%rbx;"
+		"  movq %%rbx, 104(%1);"
+		"  movq 56(%0), %%rdx;"
+		"  mulx %%rdx, %%rax, %%rcx;" /* f[3]^2 */
+		"  adcx %%rax, %%r13;"
+		"  movq %%r13, 112(%1);"
+		"  adcx %%rcx, %%r14;"
+		"  movq %%r14, 120(%1);"
 
 		/* Line up pointers */
-		"  mov %0, %1;"
-		"  mov %2, %0;"
+		"  mov %1, %0;"
+		"  mov %2, %1;"
 
 		/* Step 1: Compute dst + carry == tmp_hi * 38 + tmp_lo */
 		"  mov $38, %%rdx;"
-		"  mulxq 32(%1), %%r8, %%r13;"
+		"  mulxq 32(%0), %%r8, %%r13;"
 		"  xor %%ecx, %%ecx;"
-		"  adoxq 0(%1), %%r8;"
-		"  mulxq 40(%1), %%r9, %%rbx;"
+		"  adoxq 0(%0), %%r8;"
+		"  mulxq 40(%0), %%r9, %%rbx;"
 		"  adcx %%r13, %%r9;"
-		"  adoxq 8(%1), %%r9;"
-		"  mulxq 48(%1), %%r10, %%r13;"
+		"  adoxq 8(%0), %%r9;"
+		"  mulxq 48(%0), %%r10, %%r13;"
 		"  adcx %%rbx, %%r10;"
-		"  adoxq 16(%1), %%r10;"
-		"  mulxq 56(%1), %%r11, %%rax;"
+		"  adoxq 16(%0), %%r10;"
+		"  mulxq 56(%0), %%r11, %%rax;"
 		"  adcx %%r13, %%r11;"
-		"  adoxq 24(%1), %%r11;"
+		"  adoxq 24(%0), %%r11;"
 		"  adcx %%rcx, %%rax;"
 		"  adox %%rcx, %%rax;"
 		"  imul %%rdx, %%rax;"
@@ -711,32 +922,32 @@ static inline void fsqr2(u64 *out, const u64 *f, u64 *tmp)
 		/* Step 2: Fold the carry back into dst */
 		"  add %%rax, %%r8;"
 		"  adcx %%rcx, %%r9;"
-		"  movq %%r9, 8(%0);"
+		"  movq %%r9, 8(%1);"
 		"  adcx %%rcx, %%r10;"
-		"  movq %%r10, 16(%0);"
+		"  movq %%r10, 16(%1);"
 		"  adcx %%rcx, %%r11;"
-		"  movq %%r11, 24(%0);"
+		"  movq %%r11, 24(%1);"
 
 		/* Step 3: Fold the carry bit back in; guaranteed not to carry at this point */
 		"  mov $0, %%rax;"
 		"  cmovc %%rdx, %%rax;"
 		"  add %%rax, %%r8;"
-		"  movq %%r8, 0(%0);"
+		"  movq %%r8, 0(%1);"
 
 		/* Step 1: Compute dst + carry == tmp_hi * 38 + tmp_lo */
 		"  mov $38, %%rdx;"
-		"  mulxq 96(%1), %%r8, %%r13;"
+		"  mulxq 96(%0), %%r8, %%r13;"
 		"  xor %%ecx, %%ecx;"
-		"  adoxq 64(%1), %%r8;"
-		"  mulxq 104(%1), %%r9, %%rbx;"
+		"  adoxq 64(%0), %%r8;"
+		"  mulxq 104(%0), %%r9, %%rbx;"
 		"  adcx %%r13, %%r9;"
-		"  adoxq 72(%1), %%r9;"
-		"  mulxq 112(%1), %%r10, %%r13;"
+		"  adoxq 72(%0), %%r9;"
+		"  mulxq 112(%0), %%r10, %%r13;"
 		"  adcx %%rbx, %%r10;"
-		"  adoxq 80(%1), %%r10;"
-		"  mulxq 120(%1), %%r11, %%rax;"
+		"  adoxq 80(%0), %%r10;"
+		"  mulxq 120(%0), %%r11, %%rax;"
 		"  adcx %%r13, %%r11;"
-		"  adoxq 88(%1), %%r11;"
+		"  adoxq 88(%0), %%r11;"
 		"  adcx %%rcx, %%rax;"
 		"  adox %%rcx, %%rax;"
 		"  imul %%rdx, %%rax;"
@@ -744,21 +955,21 @@ static inline void fsqr2(u64 *out, const u64 *f, u64 *tmp)
 		/* Step 2: Fold the carry back into dst */
 		"  add %%rax, %%r8;"
 		"  adcx %%rcx, %%r9;"
-		"  movq %%r9, 40(%0);"
+		"  movq %%r9, 40(%1);"
 		"  adcx %%rcx, %%r10;"
-		"  movq %%r10, 48(%0);"
+		"  movq %%r10, 48(%1);"
 		"  adcx %%rcx, %%r11;"
-		"  movq %%r11, 56(%0);"
+		"  movq %%r11, 56(%1);"
 
 		/* Step 3: Fold the carry bit back in; guaranteed not to carry at this point */
 		"  mov $0, %%rax;"
 		"  cmovc %%rdx, %%rax;"
 		"  add %%rax, %%r8;"
-		"  movq %%r8, 32(%0);"
-	: "+&r" (tmp), "+&r" (f), "+&r" (out)
-	:
-	: "%rax", "%rcx", "%rdx", "%r8", "%r9", "%r10", "%r11", "%rbx", "%r13", "%r14", "%r15", "memory", "cc"
-	);
+		"  movq %%r8, 32(%1);"
+		: "+&r"(f), "+&r"(tmp)
+		: "r"(out)
+		: "%rax", "%rbx", "%rcx", "%rdx", "%r8", "%r9", "%r10", "%r11",
+		  "%r13", "%r14", "%r15", "memory", "cc");
 }
 
 static void point_add_and_double(u64 *q, u64 *p01_tmp1, u64 *tmp2)
-- 
2.34.1

