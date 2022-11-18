Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B68ADC43217
	for <linux-crypto@archiver.kernel.org>; Fri, 18 Nov 2022 09:04:19 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241455AbiKRJES (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 18 Nov 2022 04:04:18 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54350 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241668AbiKRJEM (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 18 Nov 2022 04:04:12 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8870082BE3
        for <linux-crypto@vger.kernel.org>; Fri, 18 Nov 2022 01:04:10 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 3BC78B82264
        for <linux-crypto@vger.kernel.org>; Fri, 18 Nov 2022 09:04:09 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C2DACC4347C;
        Fri, 18 Nov 2022 09:04:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1668762247;
        bh=EUFYFfJ9l4ZaKrj6LXV97kZec7yb3+Tp3+VcEukdMMU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=LdHq6u+FefAz6sqdRMGRP2sqZkl9VC4fP+bPiqnr1f1vd+rYrC802N2JZ+S05iTFj
         m5GDvxmjSEJ/6tNb26QRuPs88bWdriJPWqwD+hANG7EaL9ACOj+XsYnjH+PG0nFTXz
         fkkpn9Y2OyonbOGH7fy2UBbCJgrhRw3cZwh94a4aphQOwWNZ0DX0ia3A5A2MDqsO7n
         /4m1QSBvVOCncqq4T5p78r8pnT3RJIv+BJX0EuLX4dRoPlrfMiXCMgaGI/4mLnSV0m
         2Zjo8aI+c/RsZfhgFIDLEDL5YwTW0KLyXnbBlRljLNTmh+6xYPqzIhVIBOaUq4tqY3
         EdFVaxelRx4uA==
From:   Eric Biggers <ebiggers@kernel.org>
To:     linux-crypto@vger.kernel.org
Cc:     x86@kernel.org, linux-arm-kernel@lists.infradead.org,
        Sami Tolvanen <samitolvanen@google.com>,
        Taehee Yoo <ap420073@gmail.com>
Subject: [PATCH 02/11] crypto: x86/aria - fix crash with CFI enabled
Date:   Fri, 18 Nov 2022 01:02:11 -0800
Message-Id: <20221118090220.398819-3-ebiggers@kernel.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221118090220.398819-1-ebiggers@kernel.org>
References: <20221118090220.398819-1-ebiggers@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

From: Eric Biggers <ebiggers@google.com>

Some functions in aria-aesni-avx-asm_64.S are called via indirect
function calls.  These functions need to use SYM_TYPED_FUNC_START
instead of SYM_FUNC_START to cause type hashes to be emitted when the
kernel is built with CONFIG_CFI_CLANG=y.  Otherwise, the code crashes
with a CFI failure.

Fixes: 3c516f89e17e ("x86: Add support for CONFIG_CFI_CLANG")
Cc: Taehee Yoo <ap420073@gmail.com>
Signed-off-by: Eric Biggers <ebiggers@google.com>
---
 arch/x86/crypto/aria-aesni-avx-asm_64.S | 13 +++++++------
 1 file changed, 7 insertions(+), 6 deletions(-)

diff --git a/arch/x86/crypto/aria-aesni-avx-asm_64.S b/arch/x86/crypto/aria-aesni-avx-asm_64.S
index c75fd7d015ed8..03ae4cd1d976a 100644
--- a/arch/x86/crypto/aria-aesni-avx-asm_64.S
+++ b/arch/x86/crypto/aria-aesni-avx-asm_64.S
@@ -7,6 +7,7 @@
  */
 
 #include <linux/linkage.h>
+#include <linux/cfi_types.h>
 #include <asm/frame.h>
 
 /* struct aria_ctx: */
@@ -913,7 +914,7 @@ SYM_FUNC_START_LOCAL(__aria_aesni_avx_crypt_16way)
 	RET;
 SYM_FUNC_END(__aria_aesni_avx_crypt_16way)
 
-SYM_FUNC_START(aria_aesni_avx_encrypt_16way)
+SYM_TYPED_FUNC_START(aria_aesni_avx_encrypt_16way)
 	/* input:
 	*      %rdi: ctx, CTX
 	*      %rsi: dst
@@ -938,7 +939,7 @@ SYM_FUNC_START(aria_aesni_avx_encrypt_16way)
 	RET;
 SYM_FUNC_END(aria_aesni_avx_encrypt_16way)
 
-SYM_FUNC_START(aria_aesni_avx_decrypt_16way)
+SYM_TYPED_FUNC_START(aria_aesni_avx_decrypt_16way)
 	/* input:
 	*      %rdi: ctx, CTX
 	*      %rsi: dst
@@ -1039,7 +1040,7 @@ SYM_FUNC_START_LOCAL(__aria_aesni_avx_ctr_gen_keystream_16way)
 	RET;
 SYM_FUNC_END(__aria_aesni_avx_ctr_gen_keystream_16way)
 
-SYM_FUNC_START(aria_aesni_avx_ctr_crypt_16way)
+SYM_TYPED_FUNC_START(aria_aesni_avx_ctr_crypt_16way)
 	/* input:
 	*      %rdi: ctx
 	*      %rsi: dst
@@ -1208,7 +1209,7 @@ SYM_FUNC_START_LOCAL(__aria_aesni_avx_gfni_crypt_16way)
 	RET;
 SYM_FUNC_END(__aria_aesni_avx_gfni_crypt_16way)
 
-SYM_FUNC_START(aria_aesni_avx_gfni_encrypt_16way)
+SYM_TYPED_FUNC_START(aria_aesni_avx_gfni_encrypt_16way)
 	/* input:
 	*      %rdi: ctx, CTX
 	*      %rsi: dst
@@ -1233,7 +1234,7 @@ SYM_FUNC_START(aria_aesni_avx_gfni_encrypt_16way)
 	RET;
 SYM_FUNC_END(aria_aesni_avx_gfni_encrypt_16way)
 
-SYM_FUNC_START(aria_aesni_avx_gfni_decrypt_16way)
+SYM_TYPED_FUNC_START(aria_aesni_avx_gfni_decrypt_16way)
 	/* input:
 	*      %rdi: ctx, CTX
 	*      %rsi: dst
@@ -1258,7 +1259,7 @@ SYM_FUNC_START(aria_aesni_avx_gfni_decrypt_16way)
 	RET;
 SYM_FUNC_END(aria_aesni_avx_gfni_decrypt_16way)
 
-SYM_FUNC_START(aria_aesni_avx_gfni_ctr_crypt_16way)
+SYM_TYPED_FUNC_START(aria_aesni_avx_gfni_ctr_crypt_16way)
 	/* input:
 	*      %rdi: ctx
 	*      %rsi: dst
-- 
2.38.1

