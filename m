Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1F84BC433FE
	for <linux-crypto@archiver.kernel.org>; Wed, 19 Jan 2022 09:31:27 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239791AbiASJb0 (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Wed, 19 Jan 2022 04:31:26 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:32896 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234544AbiASJbY (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 19 Jan 2022 04:31:24 -0500
Received: from sin.source.kernel.org (sin.source.kernel.org [IPv6:2604:1380:40e1:4800::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 76E5CC061574
        for <linux-crypto@vger.kernel.org>; Wed, 19 Jan 2022 01:31:23 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 2898ACE1C49
        for <linux-crypto@vger.kernel.org>; Wed, 19 Jan 2022 09:31:21 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3AEC0C004E1;
        Wed, 19 Jan 2022 09:31:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1642584679;
        bh=L2q8bGntulfdCDWGccXI5D0JvkDEk1cC3vPfOr9fYpA=;
        h=From:To:Cc:Subject:Date:From;
        b=hls1iYF14LXQcfzfqJhHkAzg92H03fNLJpkZGuLqJSoWdYsxjT0wQaUoULSyIGBMC
         jiGQfHanhgMhoCh0SiuAFN9sQ85hZPaL1WPkvv6jwI12jipwQaW+5s6GRXHoEWAH1P
         GxWuNi/u9baog7sAbEooK046d2ILMu4cRws8x1Ab5C5dK0qMy5x4FZ/DVnuOPNboXy
         cVHxK37fvY5Qy/KnZoRKjGTWN2RSHj5zo0dP/5zkfgZg/BK6QjB9xpTSe4FBUWw1zW
         LlNqmoeOOTnVDCNlFPXVPXB2xFnimTZjHWrSiPQBFgmovmMRceBSzJaf1I5BJbfLe3
         RKig1s7zC+e1g==
From:   Ard Biesheuvel <ardb@kernel.org>
To:     linux-crypto@vger.kernel.org
Cc:     herbert@gondor.apana.org.au, arnd@arndb.de,
        Ard Biesheuvel <ardb@kernel.org>
Subject: [PATCH] crypto: memneq: avoid implicit unaligned accesses
Date:   Wed, 19 Jan 2022 10:31:09 +0100
Message-Id: <20220119093109.1567314-1-ardb@kernel.org>
X-Mailer: git-send-email 2.30.2
MIME-Version: 1.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=3133; h=from:subject; bh=L2q8bGntulfdCDWGccXI5D0JvkDEk1cC3vPfOr9fYpA=; b=owEB7QES/pANAwAKAcNPIjmS2Y8kAcsmYgBh59pcB5eSl79xvFUSF+AuHsu53O4ancFJK7p0Z3O9 63XgjhmJAbMEAAEKAB0WIQT72WJ8QGnJQhU3VynDTyI5ktmPJAUCYefaXAAKCRDDTyI5ktmPJFJZDA C5/NvH58dh2fXfjrRbiC4Y8ju4vnjD1Fm/VKdGofdIo2ntgV+uPVYCBaf7Ui+WDtDs6GP+o9nTjW9p hh2HbBAGy7kIebLacvb5JYGsrkZuOIML3dbqmv6w1pUJ7qf4XtaIgqmcNoRHsr9bR/yJrOQEt3+tc9 b24Sno3pAy+NN/Rm222pVX2dvLjWlimv+jk5cOwQqQWCRiO7l2IFoR5BswQFBUckHIaX7zK4NessJr s/ELtAlLGBzUiX3sSeiSQztqd9Z4vwOaFUExDtgvQg0lWCWb5cKakHDJV486nYV2rZpZNIiTo4qfg6 mPHg0BJLMWOBx8EfzSCeKBAeRWMnwSgwGW2wyZn4+6lZTxQJenswq92yctY7VQ34ByOp3UV6srYUaI 3AKWWppxuRSbspw8qVEywRODTQT5+EMbJLEMZJnixzE8LtNy2Z9qVDZpUdCOgTOHPPwvSs74W/p6D2 FIFy71Bfpi0Zy9tloS4uMphh040QaIUNR3pW9IH9ot7FU=
X-Developer-Key: i=ardb@kernel.org; a=openpgp; fpr=F43D03328115A198C90016883D200E9CA6329909
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

The C standard does not support dereferencing pointers that are not
aligned with respect to the pointed-to type, and doing so is technically
undefined behavior, even if the underlying hardware supports it.

This means that conditionally dereferencing such pointers based on
whether CONFIG_HAVE_EFFICIENT_UNALIGNED_ACCESS=y is not the right thing
to do, and actually results in alignment faults on ARM, which are fixed
up on a slow path. Instead, we should use the unaligned accessors in
such cases: on architectures that don't care about alignment, they will
result in identical codegen whereas, e.g., codegen on ARM will avoid
doubleword loads and stores but use ordinary ones, which are able to
tolerate misalignment.

Link: https://lore.kernel.org/linux-crypto/CAHk-=wiKkdYLY0bv+nXrcJz3NH9mAqPAafX7PpW5EwVtxsEu7Q@mail.gmail.com/
Signed-off-by: Ard Biesheuvel <ardb@kernel.org>
---
 crypto/memneq.c | 22 +++++++++++++++-------
 1 file changed, 15 insertions(+), 7 deletions(-)

diff --git a/crypto/memneq.c b/crypto/memneq.c
index afed1bd16aee..fb11608b1ec1 100644
--- a/crypto/memneq.c
+++ b/crypto/memneq.c
@@ -60,6 +60,7 @@
  */
 
 #include <crypto/algapi.h>
+#include <asm/unaligned.h>
 
 #ifndef __HAVE_ARCH_CRYPTO_MEMNEQ
 
@@ -71,7 +72,8 @@ __crypto_memneq_generic(const void *a, const void *b, size_t size)
 
 #if defined(CONFIG_HAVE_EFFICIENT_UNALIGNED_ACCESS)
 	while (size >= sizeof(unsigned long)) {
-		neq |= *(unsigned long *)a ^ *(unsigned long *)b;
+		neq |= get_unaligned((unsigned long *)a) ^
+		       get_unaligned((unsigned long *)b);
 		OPTIMIZER_HIDE_VAR(neq);
 		a += sizeof(unsigned long);
 		b += sizeof(unsigned long);
@@ -95,18 +97,24 @@ static inline unsigned long __crypto_memneq_16(const void *a, const void *b)
 
 #ifdef CONFIG_HAVE_EFFICIENT_UNALIGNED_ACCESS
 	if (sizeof(unsigned long) == 8) {
-		neq |= *(unsigned long *)(a)   ^ *(unsigned long *)(b);
+		neq |= get_unaligned((unsigned long *)a) ^
+		       get_unaligned((unsigned long *)b);
 		OPTIMIZER_HIDE_VAR(neq);
-		neq |= *(unsigned long *)(a+8) ^ *(unsigned long *)(b+8);
+		neq |= get_unaligned((unsigned long *)(a + 8)) ^
+		       get_unaligned((unsigned long *)(b + 8));
 		OPTIMIZER_HIDE_VAR(neq);
 	} else if (sizeof(unsigned int) == 4) {
-		neq |= *(unsigned int *)(a)    ^ *(unsigned int *)(b);
+		neq |= get_unaligned((unsigned int *)a) ^
+		       get_unaligned((unsigned int *)b);
 		OPTIMIZER_HIDE_VAR(neq);
-		neq |= *(unsigned int *)(a+4)  ^ *(unsigned int *)(b+4);
+		neq |= get_unaligned((unsigned int *)(a + 4)) ^
+		       get_unaligned((unsigned int *)(b + 4));
 		OPTIMIZER_HIDE_VAR(neq);
-		neq |= *(unsigned int *)(a+8)  ^ *(unsigned int *)(b+8);
+		neq |= get_unaligned((unsigned int *)(a + 8)) ^
+		       get_unaligned((unsigned int *)(b + 8));
 		OPTIMIZER_HIDE_VAR(neq);
-		neq |= *(unsigned int *)(a+12) ^ *(unsigned int *)(b+12);
+		neq |= get_unaligned((unsigned int *)(a + 12)) ^
+		       get_unaligned((unsigned int *)(b + 12));
 		OPTIMIZER_HIDE_VAR(neq);
 	} else
 #endif /* CONFIG_HAVE_EFFICIENT_UNALIGNED_ACCESS */
-- 
2.30.2

