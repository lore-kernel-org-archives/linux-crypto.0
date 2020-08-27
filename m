Return-Path: <SRS0=IKCX=CF=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.6 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 194A1C433E1
	for <linux-crypto@archiver.kernel.org>; Thu, 27 Aug 2020 17:31:21 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id C47D320791
	for <linux-crypto@archiver.kernel.org>; Thu, 27 Aug 2020 17:31:20 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="qHWIDg/K"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726236AbgH0RbU (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 27 Aug 2020 13:31:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58468 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726232AbgH0RbT (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 27 Aug 2020 13:31:19 -0400
Received: from mail-ej1-x644.google.com (mail-ej1-x644.google.com [IPv6:2a00:1450:4864:20::644])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EB799C061264
        for <linux-crypto@vger.kernel.org>; Thu, 27 Aug 2020 10:31:18 -0700 (PDT)
Received: by mail-ej1-x644.google.com with SMTP id j25so8746615ejk.9
        for <linux-crypto@vger.kernel.org>; Thu, 27 Aug 2020 10:31:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=g+AizLBaB1vaycb9Yd7N5pmFJOy+voLCfubMOWC2kw8=;
        b=qHWIDg/KttDgBVkFFmZ0kHk0ZPcKOgF+groQG9KG7LMQ1p4zhYMjDBg/SuOe3PZ+pP
         69Bo8hmh5nvgOiiNkgKIZRFhok/qo0u8BFcqmueiV1FeNth6z3qGJ2/cbZAvJDw0jPZx
         g5Pi0YMFtWwnZyRpvyGicqOF2/9nNOunIRpqdTHkG5zWPG+fvJrhO1hDn9F85HJkosA3
         22Zea/89ElTczZLOs0hZG3giF3AVf8YdhWdawMZLnQVFxrqHrA25eESa+YCb01FgGXZV
         P4ge8xTGZ+ic+dUYN4XSCC+adluFpaUCebQClXWnYPEjjxx3tJnX+e4CeZM9ZGs8+PL/
         6TUA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=g+AizLBaB1vaycb9Yd7N5pmFJOy+voLCfubMOWC2kw8=;
        b=qHTT8mcO31Wr8f6RBIvY/6mdaHHMfLE0ddMTND0zh+1pZt8yiEpIWs/aPkjgPnS4O5
         oYQcDYbszwyyl+q8IhCPkc9vIwxc5jwt9ddfOk5v3JqxhkBknES63bqwgHS0NXRiK4nh
         noBaI71B/f5ODdeb1cL+iXdL9udkvARA9goTn8Pp6vpEs1RMuDXcuPOa7qGMyLAztC2O
         /8SXmhdfKNQkEdYcXWXrNeqrorSTP/FKXPTpdsRIdSGrxq+fHWRvrmr6OXbP58qsOHyY
         mcrsMovvg/oIiZ4YCFAMUe2NhU1Gqocqsl3b7ilnRixYh/5J/86RVip8DKEicRDfkjMn
         UpLg==
X-Gm-Message-State: AOAM530k51C7xw7VQ9Tgrz5fXSRN/ZoHY6CNkGPAuUDGPwUckO01/rF2
        yxMFt/o2+HLtNGROzWts2nd8Kgw1KDgywA==
X-Google-Smtp-Source: ABdhPJzEt8ofoSgvOMi54gcrHGk8z+oeGL4lSrA9v93+R71SkPL12g4+4n/XvNQJOFBl5Z0vCzH6Lw==
X-Received: by 2002:a17:906:2ddb:: with SMTP id h27mr21780302eji.203.1598549476312;
        Thu, 27 Aug 2020 10:31:16 -0700 (PDT)
Received: from localhost.localdomain (93-103-18-160.static.t-2.net. [93.103.18.160])
        by smtp.gmail.com with ESMTPSA id n17sm1924626edo.46.2020.08.27.10.31.15
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 27 Aug 2020 10:31:15 -0700 (PDT)
From:   Uros Bizjak <ubizjak@gmail.com>
To:     linux-crypto@vger.kernel.org, x86@kernel.org
Cc:     Uros Bizjak <ubizjak@gmail.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH] crypto/x86: Use XORL r32,32 in curve25519-x86_64.c
Date:   Thu, 27 Aug 2020 19:30:58 +0200
Message-Id: <20200827173058.94519-1-ubizjak@gmail.com>
X-Mailer: git-send-email 2.26.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

x86_64 zero extends 32bit operations, so for 64bit operands,
XORL r32,r32 is functionally equal to XORL r64,r64, but avoids
a REX prefix byte when legacy registers are used.

Signed-off-by: Uros Bizjak <ubizjak@gmail.com>
Cc: Herbert Xu <herbert@gondor.apana.org.au>
Cc: "David S. Miller" <davem@davemloft.net>
---
 arch/x86/crypto/curve25519-x86_64.c | 68 ++++++++++++++---------------
 1 file changed, 34 insertions(+), 34 deletions(-)

diff --git a/arch/x86/crypto/curve25519-x86_64.c b/arch/x86/crypto/curve25519-x86_64.c
index 8acbb6584a37..a9edb6f8a0ba 100644
--- a/arch/x86/crypto/curve25519-x86_64.c
+++ b/arch/x86/crypto/curve25519-x86_64.c
@@ -45,11 +45,11 @@ static inline u64 add_scalar(u64 *out, const u64 *f1, u64 f2)
 
 	asm volatile(
 		/* Clear registers to propagate the carry bit */
-		"  xor %%r8, %%r8;"
-		"  xor %%r9, %%r9;"
-		"  xor %%r10, %%r10;"
-		"  xor %%r11, %%r11;"
-		"  xor %1, %1;"
+		"  xor %%r8d, %%r8d;"
+		"  xor %%r9d, %%r9d;"
+		"  xor %%r10d, %%r10d;"
+		"  xor %%r11d, %%r11d;"
+		"  xor %k1, %k1;"
 
 		/* Begin addition chain */
 		"  addq 0(%3), %0;"
@@ -93,7 +93,7 @@ static inline void fadd(u64 *out, const u64 *f1, const u64 *f2)
 		"  cmovc %0, %%rax;"
 
 		/* Step 2: Add carry*38 to the original sum */
-		"  xor %%rcx, %%rcx;"
+		"  xor %%ecx, %%ecx;"
 		"  add %%rax, %%r8;"
 		"  adcx %%rcx, %%r9;"
 		"  movq %%r9, 8(%1);"
@@ -165,28 +165,28 @@ static inline void fmul(u64 *out, const u64 *f1, const u64 *f2, u64 *tmp)
 
 		/* Compute src1[0] * src2 */
 		"  movq 0(%1), %%rdx;"
-		"  mulxq 0(%3), %%r8, %%r9;"       "  xor %%r10, %%r10;"     "  movq %%r8, 0(%0);"
+		"  mulxq 0(%3), %%r8, %%r9;"       "  xor %%r10d, %%r10d;"   "  movq %%r8, 0(%0);"
 		"  mulxq 8(%3), %%r10, %%r11;"     "  adox %%r9, %%r10;"     "  movq %%r10, 8(%0);"
 		"  mulxq 16(%3), %%rbx, %%r13;"    "  adox %%r11, %%rbx;"
 		"  mulxq 24(%3), %%r14, %%rdx;"    "  adox %%r13, %%r14;"    "  mov $0, %%rax;"
 		                                   "  adox %%rdx, %%rax;"
 		/* Compute src1[1] * src2 */
 		"  movq 8(%1), %%rdx;"
-		"  mulxq 0(%3), %%r8, %%r9;"       "  xor %%r10, %%r10;"     "  adcxq 8(%0), %%r8;"    "  movq %%r8, 8(%0);"
+		"  mulxq 0(%3), %%r8, %%r9;"       "  xor %%r10d, %%r10d;"   "  adcxq 8(%0), %%r8;"    "  movq %%r8, 8(%0);"
 		"  mulxq 8(%3), %%r10, %%r11;"     "  adox %%r9, %%r10;"     "  adcx %%rbx, %%r10;"    "  movq %%r10, 16(%0);"
 		"  mulxq 16(%3), %%rbx, %%r13;"    "  adox %%r11, %%rbx;"    "  adcx %%r14, %%rbx;"    "  mov $0, %%r8;"
 		"  mulxq 24(%3), %%r14, %%rdx;"    "  adox %%r13, %%r14;"    "  adcx %%rax, %%r14;"    "  mov $0, %%rax;"
 		                                   "  adox %%rdx, %%rax;"    "  adcx %%r8, %%rax;"
 		/* Compute src1[2] * src2 */
 		"  movq 16(%1), %%rdx;"
-		"  mulxq 0(%3), %%r8, %%r9;"       "  xor %%r10, %%r10;"    "  adcxq 16(%0), %%r8;"    "  movq %%r8, 16(%0);"
+		"  mulxq 0(%3), %%r8, %%r9;"       "  xor %%r10d, %%r10d;"   "  adcxq 16(%0), %%r8;"   "  movq %%r8, 16(%0);"
 		"  mulxq 8(%3), %%r10, %%r11;"     "  adox %%r9, %%r10;"     "  adcx %%rbx, %%r10;"    "  movq %%r10, 24(%0);"
 		"  mulxq 16(%3), %%rbx, %%r13;"    "  adox %%r11, %%rbx;"    "  adcx %%r14, %%rbx;"    "  mov $0, %%r8;"
 		"  mulxq 24(%3), %%r14, %%rdx;"    "  adox %%r13, %%r14;"    "  adcx %%rax, %%r14;"    "  mov $0, %%rax;"
 		                                   "  adox %%rdx, %%rax;"    "  adcx %%r8, %%rax;"
 		/* Compute src1[3] * src2 */
 		"  movq 24(%1), %%rdx;"
-		"  mulxq 0(%3), %%r8, %%r9;"       "  xor %%r10, %%r10;"    "  adcxq 24(%0), %%r8;"    "  movq %%r8, 24(%0);"
+		"  mulxq 0(%3), %%r8, %%r9;"       "  xor %%r10d, %%r10d;"   "  adcxq 24(%0), %%r8;"   "  movq %%r8, 24(%0);"
 		"  mulxq 8(%3), %%r10, %%r11;"     "  adox %%r9, %%r10;"     "  adcx %%rbx, %%r10;"    "  movq %%r10, 32(%0);"
 		"  mulxq 16(%3), %%rbx, %%r13;"    "  adox %%r11, %%rbx;"    "  adcx %%r14, %%rbx;"    "  movq %%rbx, 40(%0);"    "  mov $0, %%r8;"
 		"  mulxq 24(%3), %%r14, %%rdx;"    "  adox %%r13, %%r14;"    "  adcx %%rax, %%r14;"    "  movq %%r14, 48(%0);"    "  mov $0, %%rax;"
@@ -200,7 +200,7 @@ static inline void fmul(u64 *out, const u64 *f1, const u64 *f2, u64 *tmp)
 		/* Step 1: Compute dst + carry == tmp_hi * 38 + tmp_lo */
 		"  mov $38, %%rdx;"
 		"  mulxq 32(%1), %%r8, %%r13;"
-		"  xor %3, %3;"
+		"  xor %k3, %k3;"
 		"  adoxq 0(%1), %%r8;"
 		"  mulxq 40(%1), %%r9, %%rbx;"
 		"  adcx %%r13, %%r9;"
@@ -246,28 +246,28 @@ static inline void fmul2(u64 *out, const u64 *f1, const u64 *f2, u64 *tmp)
 
 		/* Compute src1[0] * src2 */
 		"  movq 0(%1), %%rdx;"
-		"  mulxq 0(%3), %%r8, %%r9;"       "  xor %%r10, %%r10;"     "  movq %%r8, 0(%0);"
+		"  mulxq 0(%3), %%r8, %%r9;"       "  xor %%r10d, %%r10d;"   "  movq %%r8, 0(%0);"
 		"  mulxq 8(%3), %%r10, %%r11;"     "  adox %%r9, %%r10;"     "  movq %%r10, 8(%0);"
 		"  mulxq 16(%3), %%rbx, %%r13;"    "  adox %%r11, %%rbx;"
 		"  mulxq 24(%3), %%r14, %%rdx;"    "  adox %%r13, %%r14;"    "  mov $0, %%rax;"
 		                                   "  adox %%rdx, %%rax;"
 		/* Compute src1[1] * src2 */
 		"  movq 8(%1), %%rdx;"
-		"  mulxq 0(%3), %%r8, %%r9;"       "  xor %%r10, %%r10;"     "  adcxq 8(%0), %%r8;"    "  movq %%r8, 8(%0);"
+		"  mulxq 0(%3), %%r8, %%r9;"       "  xor %%r10d, %%r10d;"   "  adcxq 8(%0), %%r8;"    "  movq %%r8, 8(%0);"
 		"  mulxq 8(%3), %%r10, %%r11;"     "  adox %%r9, %%r10;"     "  adcx %%rbx, %%r10;"    "  movq %%r10, 16(%0);"
 		"  mulxq 16(%3), %%rbx, %%r13;"    "  adox %%r11, %%rbx;"    "  adcx %%r14, %%rbx;"    "  mov $0, %%r8;"
 		"  mulxq 24(%3), %%r14, %%rdx;"    "  adox %%r13, %%r14;"    "  adcx %%rax, %%r14;"    "  mov $0, %%rax;"
 		                                   "  adox %%rdx, %%rax;"    "  adcx %%r8, %%rax;"
 		/* Compute src1[2] * src2 */
 		"  movq 16(%1), %%rdx;"
-		"  mulxq 0(%3), %%r8, %%r9;"       "  xor %%r10, %%r10;"    "  adcxq 16(%0), %%r8;"    "  movq %%r8, 16(%0);"
+		"  mulxq 0(%3), %%r8, %%r9;"       "  xor %%r10d, %%r10d;"   "  adcxq 16(%0), %%r8;"   "  movq %%r8, 16(%0);"
 		"  mulxq 8(%3), %%r10, %%r11;"     "  adox %%r9, %%r10;"     "  adcx %%rbx, %%r10;"    "  movq %%r10, 24(%0);"
 		"  mulxq 16(%3), %%rbx, %%r13;"    "  adox %%r11, %%rbx;"    "  adcx %%r14, %%rbx;"    "  mov $0, %%r8;"
 		"  mulxq 24(%3), %%r14, %%rdx;"    "  adox %%r13, %%r14;"    "  adcx %%rax, %%r14;"    "  mov $0, %%rax;"
 		                                   "  adox %%rdx, %%rax;"    "  adcx %%r8, %%rax;"
 		/* Compute src1[3] * src2 */
 		"  movq 24(%1), %%rdx;"
-		"  mulxq 0(%3), %%r8, %%r9;"       "  xor %%r10, %%r10;"    "  adcxq 24(%0), %%r8;"    "  movq %%r8, 24(%0);"
+		"  mulxq 0(%3), %%r8, %%r9;"       "  xor %%r10d, %%r10d;"   "  adcxq 24(%0), %%r8;"   "  movq %%r8, 24(%0);"
 		"  mulxq 8(%3), %%r10, %%r11;"     "  adox %%r9, %%r10;"     "  adcx %%rbx, %%r10;"    "  movq %%r10, 32(%0);"
 		"  mulxq 16(%3), %%rbx, %%r13;"    "  adox %%r11, %%rbx;"    "  adcx %%r14, %%rbx;"    "  movq %%rbx, 40(%0);"    "  mov $0, %%r8;"
 		"  mulxq 24(%3), %%r14, %%rdx;"    "  adox %%r13, %%r14;"    "  adcx %%rax, %%r14;"    "  movq %%r14, 48(%0);"    "  mov $0, %%rax;"
@@ -277,29 +277,29 @@ static inline void fmul2(u64 *out, const u64 *f1, const u64 *f2, u64 *tmp)
 
 		/* Compute src1[0] * src2 */
 		"  movq 32(%1), %%rdx;"
-		"  mulxq 32(%3), %%r8, %%r9;"       "  xor %%r10, %%r10;"     "  movq %%r8, 64(%0);"
-		"  mulxq 40(%3), %%r10, %%r11;"     "  adox %%r9, %%r10;"     "  movq %%r10, 72(%0);"
+		"  mulxq 32(%3), %%r8, %%r9;"      "  xor %%r10d, %%r10d;"   "  movq %%r8, 64(%0);"
+		"  mulxq 40(%3), %%r10, %%r11;"    "  adox %%r9, %%r10;"     "  movq %%r10, 72(%0);"
 		"  mulxq 48(%3), %%rbx, %%r13;"    "  adox %%r11, %%rbx;"
 		"  mulxq 56(%3), %%r14, %%rdx;"    "  adox %%r13, %%r14;"    "  mov $0, %%rax;"
 		                                   "  adox %%rdx, %%rax;"
 		/* Compute src1[1] * src2 */
 		"  movq 40(%1), %%rdx;"
-		"  mulxq 32(%3), %%r8, %%r9;"       "  xor %%r10, %%r10;"     "  adcxq 72(%0), %%r8;"    "  movq %%r8, 72(%0);"
-		"  mulxq 40(%3), %%r10, %%r11;"     "  adox %%r9, %%r10;"     "  adcx %%rbx, %%r10;"    "  movq %%r10, 80(%0);"
+		"  mulxq 32(%3), %%r8, %%r9;"      "  xor %%r10d, %%r10d;"   "  adcxq 72(%0), %%r8;"   "  movq %%r8, 72(%0);"
+		"  mulxq 40(%3), %%r10, %%r11;"    "  adox %%r9, %%r10;"     "  adcx %%rbx, %%r10;"    "  movq %%r10, 80(%0);"
 		"  mulxq 48(%3), %%rbx, %%r13;"    "  adox %%r11, %%rbx;"    "  adcx %%r14, %%rbx;"    "  mov $0, %%r8;"
 		"  mulxq 56(%3), %%r14, %%rdx;"    "  adox %%r13, %%r14;"    "  adcx %%rax, %%r14;"    "  mov $0, %%rax;"
 		                                   "  adox %%rdx, %%rax;"    "  adcx %%r8, %%rax;"
 		/* Compute src1[2] * src2 */
 		"  movq 48(%1), %%rdx;"
-		"  mulxq 32(%3), %%r8, %%r9;"       "  xor %%r10, %%r10;"    "  adcxq 80(%0), %%r8;"    "  movq %%r8, 80(%0);"
-		"  mulxq 40(%3), %%r10, %%r11;"     "  adox %%r9, %%r10;"     "  adcx %%rbx, %%r10;"    "  movq %%r10, 88(%0);"
+		"  mulxq 32(%3), %%r8, %%r9;"      "  xor %%r10d, %%r10d;"   "  adcxq 80(%0), %%r8;"   "  movq %%r8, 80(%0);"
+		"  mulxq 40(%3), %%r10, %%r11;"    "  adox %%r9, %%r10;"     "  adcx %%rbx, %%r10;"    "  movq %%r10, 88(%0);"
 		"  mulxq 48(%3), %%rbx, %%r13;"    "  adox %%r11, %%rbx;"    "  adcx %%r14, %%rbx;"    "  mov $0, %%r8;"
 		"  mulxq 56(%3), %%r14, %%rdx;"    "  adox %%r13, %%r14;"    "  adcx %%rax, %%r14;"    "  mov $0, %%rax;"
 		                                   "  adox %%rdx, %%rax;"    "  adcx %%r8, %%rax;"
 		/* Compute src1[3] * src2 */
 		"  movq 56(%1), %%rdx;"
-		"  mulxq 32(%3), %%r8, %%r9;"       "  xor %%r10, %%r10;"    "  adcxq 88(%0), %%r8;"    "  movq %%r8, 88(%0);"
-		"  mulxq 40(%3), %%r10, %%r11;"     "  adox %%r9, %%r10;"     "  adcx %%rbx, %%r10;"    "  movq %%r10, 96(%0);"
+		"  mulxq 32(%3), %%r8, %%r9;"      "  xor %%r10d, %%r10d;"   "  adcxq 88(%0), %%r8;"   "  movq %%r8, 88(%0);"
+		"  mulxq 40(%3), %%r10, %%r11;"    "  adox %%r9, %%r10;"     "  adcx %%rbx, %%r10;"    "  movq %%r10, 96(%0);"
 		"  mulxq 48(%3), %%rbx, %%r13;"    "  adox %%r11, %%rbx;"    "  adcx %%r14, %%rbx;"    "  movq %%rbx, 104(%0);"    "  mov $0, %%r8;"
 		"  mulxq 56(%3), %%r14, %%rdx;"    "  adox %%r13, %%r14;"    "  adcx %%rax, %%r14;"    "  movq %%r14, 112(%0);"    "  mov $0, %%rax;"
 		                                   "  adox %%rdx, %%rax;"    "  adcx %%r8, %%rax;"     "  movq %%rax, 120(%0);"
@@ -312,7 +312,7 @@ static inline void fmul2(u64 *out, const u64 *f1, const u64 *f2, u64 *tmp)
 		/* Step 1: Compute dst + carry == tmp_hi * 38 + tmp_lo */
 		"  mov $38, %%rdx;"
 		"  mulxq 32(%1), %%r8, %%r13;"
-		"  xor %3, %3;"
+		"  xor %k3, %k3;"
 		"  adoxq 0(%1), %%r8;"
 		"  mulxq 40(%1), %%r9, %%rbx;"
 		"  adcx %%r13, %%r9;"
@@ -345,7 +345,7 @@ static inline void fmul2(u64 *out, const u64 *f1, const u64 *f2, u64 *tmp)
 		/* Step 1: Compute dst + carry == tmp_hi * 38 + tmp_lo */
 		"  mov $38, %%rdx;"
 		"  mulxq 96(%1), %%r8, %%r13;"
-		"  xor %3, %3;"
+		"  xor %k3, %k3;"
 		"  adoxq 64(%1), %%r8;"
 		"  mulxq 104(%1), %%r9, %%rbx;"
 		"  adcx %%r13, %%r9;"
@@ -516,7 +516,7 @@ static inline void fsqr(u64 *out, const u64 *f, u64 *tmp)
 
 		/* Step 1: Compute all partial products */
 		"  movq 0(%1), %%rdx;"                                       /* f[0] */
-		"  mulxq 8(%1), %%r8, %%r14;"      "  xor %%r15, %%r15;"     /* f[1]*f[0] */
+		"  mulxq 8(%1), %%r8, %%r14;"      "  xor %%r15d, %%r15d;"   /* f[1]*f[0] */
 		"  mulxq 16(%1), %%r9, %%r10;"     "  adcx %%r14, %%r9;"     /* f[2]*f[0] */
 		"  mulxq 24(%1), %%rax, %%rcx;"    "  adcx %%rax, %%r10;"    /* f[3]*f[0] */
 		"  movq 24(%1), %%rdx;"                                      /* f[3] */
@@ -526,7 +526,7 @@ static inline void fsqr(u64 *out, const u64 *f, u64 *tmp)
 		"  mulxq 16(%1), %%rax, %%rcx;"    "  mov $0, %%r14;"        /* f[2]*f[1] */
 
 		/* Step 2: Compute two parallel carry chains */
-		"  xor %%r15, %%r15;"
+		"  xor %%r15d, %%r15d;"
 		"  adox %%rax, %%r10;"
 		"  adcx %%r8, %%r8;"
 		"  adox %%rcx, %%r11;"
@@ -563,7 +563,7 @@ static inline void fsqr(u64 *out, const u64 *f, u64 *tmp)
 		/* Step 1: Compute dst + carry == tmp_hi * 38 + tmp_lo */
 		"  mov $38, %%rdx;"
 		"  mulxq 32(%1), %%r8, %%r13;"
-		"  xor %%rcx, %%rcx;"
+		"  xor %%ecx, %%ecx;"
 		"  adoxq 0(%1), %%r8;"
 		"  mulxq 40(%1), %%r9, %%rbx;"
 		"  adcx %%r13, %%r9;"
@@ -607,7 +607,7 @@ static inline void fsqr2(u64 *out, const u64 *f, u64 *tmp)
 	asm volatile(
 		/* Step 1: Compute all partial products */
 		"  movq 0(%1), %%rdx;"                                       /* f[0] */
-		"  mulxq 8(%1), %%r8, %%r14;"      "  xor %%r15, %%r15;"     /* f[1]*f[0] */
+		"  mulxq 8(%1), %%r8, %%r14;"      "  xor %%r15d, %%r15d;"   /* f[1]*f[0] */
 		"  mulxq 16(%1), %%r9, %%r10;"     "  adcx %%r14, %%r9;"     /* f[2]*f[0] */
 		"  mulxq 24(%1), %%rax, %%rcx;"    "  adcx %%rax, %%r10;"    /* f[3]*f[0] */
 		"  movq 24(%1), %%rdx;"                                      /* f[3] */
@@ -617,7 +617,7 @@ static inline void fsqr2(u64 *out, const u64 *f, u64 *tmp)
 		"  mulxq 16(%1), %%rax, %%rcx;"    "  mov $0, %%r14;"        /* f[2]*f[1] */
 
 		/* Step 2: Compute two parallel carry chains */
-		"  xor %%r15, %%r15;"
+		"  xor %%r15d, %%r15d;"
 		"  adox %%rax, %%r10;"
 		"  adcx %%r8, %%r8;"
 		"  adox %%rcx, %%r11;"
@@ -647,7 +647,7 @@ static inline void fsqr2(u64 *out, const u64 *f, u64 *tmp)
 
 		/* Step 1: Compute all partial products */
 		"  movq 32(%1), %%rdx;"                                       /* f[0] */
-		"  mulxq 40(%1), %%r8, %%r14;"      "  xor %%r15, %%r15;"     /* f[1]*f[0] */
+		"  mulxq 40(%1), %%r8, %%r14;"     "  xor %%r15d, %%r15d;"   /* f[1]*f[0] */
 		"  mulxq 48(%1), %%r9, %%r10;"     "  adcx %%r14, %%r9;"     /* f[2]*f[0] */
 		"  mulxq 56(%1), %%rax, %%rcx;"    "  adcx %%rax, %%r10;"    /* f[3]*f[0] */
 		"  movq 56(%1), %%rdx;"                                      /* f[3] */
@@ -657,7 +657,7 @@ static inline void fsqr2(u64 *out, const u64 *f, u64 *tmp)
 		"  mulxq 48(%1), %%rax, %%rcx;"    "  mov $0, %%r14;"        /* f[2]*f[1] */
 
 		/* Step 2: Compute two parallel carry chains */
-		"  xor %%r15, %%r15;"
+		"  xor %%r15d, %%r15d;"
 		"  adox %%rax, %%r10;"
 		"  adcx %%r8, %%r8;"
 		"  adox %%rcx, %%r11;"
@@ -692,7 +692,7 @@ static inline void fsqr2(u64 *out, const u64 *f, u64 *tmp)
 		/* Step 1: Compute dst + carry == tmp_hi * 38 + tmp_lo */
 		"  mov $38, %%rdx;"
 		"  mulxq 32(%1), %%r8, %%r13;"
-		"  xor %%rcx, %%rcx;"
+		"  xor %%ecx, %%ecx;"
 		"  adoxq 0(%1), %%r8;"
 		"  mulxq 40(%1), %%r9, %%rbx;"
 		"  adcx %%r13, %%r9;"
@@ -725,7 +725,7 @@ static inline void fsqr2(u64 *out, const u64 *f, u64 *tmp)
 		/* Step 1: Compute dst + carry == tmp_hi * 38 + tmp_lo */
 		"  mov $38, %%rdx;"
 		"  mulxq 96(%1), %%r8, %%r13;"
-		"  xor %%rcx, %%rcx;"
+		"  xor %%ecx, %%ecx;"
 		"  adoxq 64(%1), %%r8;"
 		"  mulxq 104(%1), %%r9, %%rbx;"
 		"  adcx %%r13, %%r9;"
-- 
2.26.2

