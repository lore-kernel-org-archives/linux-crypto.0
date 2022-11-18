Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5F018C4332F
	for <linux-crypto@archiver.kernel.org>; Fri, 18 Nov 2022 09:04:12 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240803AbiKRJEL (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 18 Nov 2022 04:04:11 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54266 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241455AbiKRJEJ (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 18 Nov 2022 04:04:09 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AAF101143
        for <linux-crypto@vger.kernel.org>; Fri, 18 Nov 2022 01:04:08 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 3F0346230C
        for <linux-crypto@vger.kernel.org>; Fri, 18 Nov 2022 09:04:08 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7DCEAC433D7;
        Fri, 18 Nov 2022 09:04:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1668762247;
        bh=cS7/6QLD7TgC3YuEBW48zGmDobm+o6walAidsI/8OGs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=NjtJJyf8H7nZ96eNiOfXsu5McNg8JK5zV0FckJdxHo8dDY1NKgZewBSzMQLrYjZf3
         SQqLbctXfcuL4XCZjEr4uavRjOYolvNXe42Abn/F/cnd3krlFwnTV45bfevAgH6lz2
         80E4RvUb7RkdTzZHOgTv9LEbCVnQYW0qTa5lV++HqJfze5XVfPfOnukxyMG4ZvZP2c
         bvzL0z1nrfFSUJBVT39wzLqEq/rW2tK3pLR02zpLG/l4Ft48+lkJZwRcrj2jM57h2g
         SYPkpj0gY3Jbwk2oLs2tE28qGg4wJ32KKjk+N+YhFwrqqWe0BdS2uJe0A5YH6UVcba
         jS5k7ZOOtX3ZA==
From:   Eric Biggers <ebiggers@kernel.org>
To:     linux-crypto@vger.kernel.org
Cc:     x86@kernel.org, linux-arm-kernel@lists.infradead.org,
        Sami Tolvanen <samitolvanen@google.com>
Subject: [PATCH 01/11] crypto: x86/aegis128 - fix crash with CFI enabled
Date:   Fri, 18 Nov 2022 01:02:10 -0800
Message-Id: <20221118090220.398819-2-ebiggers@kernel.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221118090220.398819-1-ebiggers@kernel.org>
References: <20221118090220.398819-1-ebiggers@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

From: Eric Biggers <ebiggers@google.com>

Some functions in aegis128-aesni-asm.S are called via indirect function
calls.  These functions need to use SYM_TYPED_FUNC_START instead of
SYM_FUNC_START to cause type hashes to be emitted when the kernel is
built with CONFIG_CFI_CLANG=y.  Otherwise, the code crashes with a CFI
failure.

Fixes: 3c516f89e17e ("x86: Add support for CONFIG_CFI_CLANG")
Signed-off-by: Eric Biggers <ebiggers@google.com>
---
 arch/x86/crypto/aegis128-aesni-asm.S | 9 +++++----
 1 file changed, 5 insertions(+), 4 deletions(-)

diff --git a/arch/x86/crypto/aegis128-aesni-asm.S b/arch/x86/crypto/aegis128-aesni-asm.S
index b48ddebb47489..cdf3215ec272c 100644
--- a/arch/x86/crypto/aegis128-aesni-asm.S
+++ b/arch/x86/crypto/aegis128-aesni-asm.S
@@ -7,6 +7,7 @@
  */
 
 #include <linux/linkage.h>
+#include <linux/cfi_types.h>
 #include <asm/frame.h>
 
 #define STATE0	%xmm0
@@ -402,7 +403,7 @@ SYM_FUNC_END(crypto_aegis128_aesni_ad)
  * void crypto_aegis128_aesni_enc(void *state, unsigned int length,
  *                                const void *src, void *dst);
  */
-SYM_FUNC_START(crypto_aegis128_aesni_enc)
+SYM_TYPED_FUNC_START(crypto_aegis128_aesni_enc)
 	FRAME_BEGIN
 
 	cmp $0x10, LEN
@@ -499,7 +500,7 @@ SYM_FUNC_END(crypto_aegis128_aesni_enc)
  * void crypto_aegis128_aesni_enc_tail(void *state, unsigned int length,
  *                                     const void *src, void *dst);
  */
-SYM_FUNC_START(crypto_aegis128_aesni_enc_tail)
+SYM_TYPED_FUNC_START(crypto_aegis128_aesni_enc_tail)
 	FRAME_BEGIN
 
 	/* load the state: */
@@ -556,7 +557,7 @@ SYM_FUNC_END(crypto_aegis128_aesni_enc_tail)
  * void crypto_aegis128_aesni_dec(void *state, unsigned int length,
  *                                const void *src, void *dst);
  */
-SYM_FUNC_START(crypto_aegis128_aesni_dec)
+SYM_TYPED_FUNC_START(crypto_aegis128_aesni_dec)
 	FRAME_BEGIN
 
 	cmp $0x10, LEN
@@ -653,7 +654,7 @@ SYM_FUNC_END(crypto_aegis128_aesni_dec)
  * void crypto_aegis128_aesni_dec_tail(void *state, unsigned int length,
  *                                     const void *src, void *dst);
  */
-SYM_FUNC_START(crypto_aegis128_aesni_dec_tail)
+SYM_TYPED_FUNC_START(crypto_aegis128_aesni_dec_tail)
 	FRAME_BEGIN
 
 	/* load the state: */
-- 
2.38.1

