Return-Path: <linux-crypto-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CE5ECC7619A
	for <linux-crypto@archiver.kernel.org>; Wed, 12 Apr 2023 11:00:58 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229559AbjDLLA5 (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Wed, 12 Apr 2023 07:00:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55740 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229659AbjDLLAy (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 12 Apr 2023 07:00:54 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5A0666A7A
        for <linux-crypto@vger.kernel.org>; Wed, 12 Apr 2023 04:00:51 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id EA42C63256
        for <linux-crypto@vger.kernel.org>; Wed, 12 Apr 2023 11:00:50 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3EA4DC433EF;
        Wed, 12 Apr 2023 11:00:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1681297250;
        bh=byw+Jg+9hm2CvseYnTXzAmr7kwzuwBHIZKxwiR9Q0+o=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=aM4VIu+FVsk96+BslgqN+KILMrukQfXkAuNyuwHHu+B3jDUJ2gMQUo5DVBZUAyE0W
         LIxKifrZuQsxW0WTIZ057R2MraWs2z8xbBb8emJhwE5qDAQi9P8ZMS+evWzmWoMPj4
         9s3xViA8jP7c2V+gUVhrbg7vtxO9jrRfSylUxMi44mhaVypGOcNcfbLvfj9BF3+zaY
         BB3IiVJ/jskHfCISa5gBLyNUFpGqUgLEMU8Wz0SaIlNlecsXzWd3aXqrSqk+gbFiSE
         OJF4AS+2NiTcf3GsWYyjg77ssj6Ve0VVQTITwHvk/l780OZRSif0A2RYabWz9YhFbW
         oWvNM0EaQU05A==
From:   Ard Biesheuvel <ardb@kernel.org>
To:     linux-crypto@vger.kernel.org
Cc:     Ard Biesheuvel <ardb@kernel.org>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Eric Biggers <ebiggers@kernel.org>,
        Kees Cook <keescook@chromium.org>
Subject: [PATCH v2 02/13] crypto: x86/aesni - Use RIP-relative addressing
Date:   Wed, 12 Apr 2023 13:00:24 +0200
Message-Id: <20230412110035.361447-3-ardb@kernel.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230412110035.361447-1-ardb@kernel.org>
References: <20230412110035.361447-1-ardb@kernel.org>
MIME-Version: 1.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=3052; i=ardb@kernel.org; h=from:subject; bh=byw+Jg+9hm2CvseYnTXzAmr7kwzuwBHIZKxwiR9Q0+o=; b=owGbwMvMwCFmkMcZplerG8N4Wi2JIcWs32X+8z4Lho07d+nsFRLsXmJ4f0vVbk11p1WGH7Sl+ PZdPJ7ZUcrCIMbBICumyCIw+++7nacnStU6z5KFmcPKBDKEgYtTACYS+IGRYdGpL6Xsu7Lb/m5T teuWXcLWeWm/7w0/1bN5Vx4vXNFZqcTIcOxPyMxdhTLvc6587u+zCzi66PzN+tjdBgfNnsxInSl exwwA
X-Developer-Key: i=ardb@kernel.org; a=openpgp; fpr=F43D03328115A198C90016883D200E9CA6329909
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Prefer RIP-relative addressing where possible, which removes the need
for boot time relocation fixups. In the GCM case, we can get rid of the
oversized permutation array entirely while at it.

Signed-off-by: Ard Biesheuvel <ardb@kernel.org>
---
 arch/x86/crypto/aesni-intel_asm.S        |  2 +-
 arch/x86/crypto/aesni-intel_avx-x86_64.S | 36 ++++----------------
 2 files changed, 8 insertions(+), 30 deletions(-)

diff --git a/arch/x86/crypto/aesni-intel_asm.S b/arch/x86/crypto/aesni-intel_asm.S
index 837c1e0aa0217783..ca99a2274d551015 100644
--- a/arch/x86/crypto/aesni-intel_asm.S
+++ b/arch/x86/crypto/aesni-intel_asm.S
@@ -2717,7 +2717,7 @@ SYM_FUNC_END(aesni_cts_cbc_dec)
  *	BSWAP_MASK == endian swapping mask
  */
 SYM_FUNC_START_LOCAL(_aesni_inc_init)
-	movaps .Lbswap_mask, BSWAP_MASK
+	movaps .Lbswap_mask(%rip), BSWAP_MASK
 	movaps IV, CTR
 	pshufb BSWAP_MASK, CTR
 	mov $1, TCTR_LOW
diff --git a/arch/x86/crypto/aesni-intel_avx-x86_64.S b/arch/x86/crypto/aesni-intel_avx-x86_64.S
index 0852ab573fd306ac..b6ca80f188ff9418 100644
--- a/arch/x86/crypto/aesni-intel_avx-x86_64.S
+++ b/arch/x86/crypto/aesni-intel_avx-x86_64.S
@@ -154,30 +154,6 @@ SHIFT_MASK:      .octa     0x0f0e0d0c0b0a09080706050403020100
 ALL_F:           .octa     0xffffffffffffffffffffffffffffffff
                  .octa     0x00000000000000000000000000000000
 
-.section .rodata
-.align 16
-.type aad_shift_arr, @object
-.size aad_shift_arr, 272
-aad_shift_arr:
-        .octa     0xffffffffffffffffffffffffffffffff
-        .octa     0xffffffffffffffffffffffffffffff0C
-        .octa     0xffffffffffffffffffffffffffff0D0C
-        .octa     0xffffffffffffffffffffffffff0E0D0C
-        .octa     0xffffffffffffffffffffffff0F0E0D0C
-        .octa     0xffffffffffffffffffffff0C0B0A0908
-        .octa     0xffffffffffffffffffff0D0C0B0A0908
-        .octa     0xffffffffffffffffff0E0D0C0B0A0908
-        .octa     0xffffffffffffffff0F0E0D0C0B0A0908
-        .octa     0xffffffffffffff0C0B0A090807060504
-        .octa     0xffffffffffff0D0C0B0A090807060504
-        .octa     0xffffffffff0E0D0C0B0A090807060504
-        .octa     0xffffffff0F0E0D0C0B0A090807060504
-        .octa     0xffffff0C0B0A09080706050403020100
-        .octa     0xffff0D0C0B0A09080706050403020100
-        .octa     0xff0E0D0C0B0A09080706050403020100
-        .octa     0x0F0E0D0C0B0A09080706050403020100
-
-
 .text
 
 
@@ -646,11 +622,13 @@ _get_AAD_rest4\@:
 _get_AAD_rest0\@:
 	/* finalize: shift out the extra bytes we read, and align
 	left. since pslldq can only shift by an immediate, we use
-	vpshufb and an array of shuffle masks */
-	movq    %r12, %r11
-	salq    $4, %r11
-	vmovdqu  aad_shift_arr(%r11), \T1
-	vpshufb \T1, \T7, \T7
+	vpshufb and a pair of shuffle masks */
+	leaq	ALL_F(%rip), %r11
+	subq	%r12, %r11
+	vmovdqu	16(%r11), \T1
+	andq	$~3, %r11
+	vpshufb (%r11), \T7, \T7
+	vpand	\T1, \T7, \T7
 _get_AAD_rest_final\@:
 	vpshufb SHUF_MASK(%rip), \T7, \T7
 	vpxor   \T8, \T7, \T7
-- 
2.39.2

