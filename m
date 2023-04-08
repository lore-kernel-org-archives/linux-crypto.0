Return-Path: <linux-crypto-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EEA4AC7619A
	for <linux-crypto@archiver.kernel.org>; Sat,  8 Apr 2023 15:27:44 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229839AbjDHP1n (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Sat, 8 Apr 2023 11:27:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53430 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229456AbjDHP1m (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Sat, 8 Apr 2023 11:27:42 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 38E1E10242
        for <linux-crypto@vger.kernel.org>; Sat,  8 Apr 2023 08:27:42 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id C88DE60B42
        for <linux-crypto@vger.kernel.org>; Sat,  8 Apr 2023 15:27:41 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0A452C4339E;
        Sat,  8 Apr 2023 15:27:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1680967661;
        bh=bK2+uHcwkOcS7KC2mPKun/4g3Ju7AJp9LMK7NB7oJOo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ezBDfxt5scEbismTj1XzDJhP4lTBvj058bXpTEj4wfnhZa93jaGhg5u/SotEJTOTh
         vy4uAHH7rPSSVEodOjwkyCj5WmutS3o5glG3GIgUWz4jRZUn7NBWQnfqGR+qXJvG8K
         5/an1Z8P64N84mv1voLUkMIkEHm07CgsA4+LP7++/c3sG3DTK87fB3hMMM3oqhUkT4
         GBiP3PJFLd2frNgqpkmrgnFY6J20BuwkaeAbY0gWy18usCqZFKOSvQQCq2dqOe9lBK
         Fkk1/5asCq4Ys5jOtW9CqFAEyJzj3LIhWx/haNYTPxKEjNWiJV4Dx/CPBv1AmqZW/D
         Vumv60syIhM8Q==
From:   Ard Biesheuvel <ardb@kernel.org>
To:     linux-crypto@vger.kernel.org
Cc:     Ard Biesheuvel <ardb@kernel.org>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Eric Biggers <ebiggers@kernel.org>,
        Kees Cook <keescook@chromium.org>
Subject: [PATCH 02/10] crypto: x86/aesni - Use RIP-relative addressing
Date:   Sat,  8 Apr 2023 17:27:14 +0200
Message-Id: <20230408152722.3975985-3-ardb@kernel.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230408152722.3975985-1-ardb@kernel.org>
References: <20230408152722.3975985-1-ardb@kernel.org>
MIME-Version: 1.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=1538; i=ardb@kernel.org; h=from:subject; bh=bK2+uHcwkOcS7KC2mPKun/4g3Ju7AJp9LMK7NB7oJOo=; b=owGbwMvMwCFmkMcZplerG8N4Wi2JIcWw/YJA4XOHeZMVD897ce34h+N2c3kWn4z+MaHjVbr3h ZuO8W//dZSyMIhxMMiKKbIIzP77bufpiVK1zrNkYeawMoEMYeDiFICJPDZh+Kff7Mb0/PLbxfvT s8znnN7x9Us+U2aD+8bcigNJt3r9++cw/BUx/5fy7UfBxZvuF5eb9Hy5L6+ze2MZz7Wi+i8m/2L z83gA
X-Developer-Key: i=ardb@kernel.org; a=openpgp; fpr=F43D03328115A198C90016883D200E9CA6329909
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Prefer RIP-relative addressing where possible, which removes the need
for boot time relocation fixups.

Signed-off-by: Ard Biesheuvel <ardb@kernel.org>
---
 arch/x86/crypto/aesni-intel_asm.S        | 2 +-
 arch/x86/crypto/aesni-intel_avx-x86_64.S | 6 +++---
 2 files changed, 4 insertions(+), 4 deletions(-)

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
index 0852ab573fd306ac..cb6acca1550b78a6 100644
--- a/arch/x86/crypto/aesni-intel_avx-x86_64.S
+++ b/arch/x86/crypto/aesni-intel_avx-x86_64.S
@@ -647,9 +647,9 @@ _get_AAD_rest0\@:
 	/* finalize: shift out the extra bytes we read, and align
 	left. since pslldq can only shift by an immediate, we use
 	vpshufb and an array of shuffle masks */
-	movq    %r12, %r11
-	salq    $4, %r11
-	vmovdqu  aad_shift_arr(%r11), \T1
+	leaq	aad_shift_arr(%rip), %r11
+	leaq	(%r11, %r12, 8), %r11
+	vmovdqu  (%r11, %r12, 8), \T1
 	vpshufb \T1, \T7, \T7
 _get_AAD_rest_final\@:
 	vpshufb SHUF_MASK(%rip), \T7, \T7
-- 
2.39.2

