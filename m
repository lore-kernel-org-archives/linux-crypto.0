Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D1214C43217
	for <linux-crypto@archiver.kernel.org>; Fri, 18 Nov 2022 09:04:22 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241530AbiKRJEV (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 18 Nov 2022 04:04:21 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54352 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241704AbiKRJEM (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 18 Nov 2022 04:04:12 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EEF7382BC9
        for <linux-crypto@vger.kernel.org>; Fri, 18 Nov 2022 01:04:09 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 1BB78623BB
        for <linux-crypto@vger.kernel.org>; Fri, 18 Nov 2022 09:04:09 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 62593C433D7;
        Fri, 18 Nov 2022 09:04:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1668762248;
        bh=izas7t+6oGMs9+g/37vH55gFtFtlIMabHc0IYfz658Q=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Zf8+T9vZhJ4QB3orc2MRN4ra0Ac9rGJfEPJ53UqrkXAPvoo44QU3Vu7eUy/ch24I7
         AHTqR9zvBWC12+JTY29n6NBcr/crrWNjbKxqztDHjwYgRxaSX0vApyVLgdTFYBvK9K
         u8ZUFQFlt3bCQZaUO3BbD1owS0hPOpx6hlKuuCg70BSYk4ueI5RtPQGXwn2RVzFox8
         GzUw7yvAArNuDMULWjziqgd/Fppz6Z06e9j76DD8YaV215kQb8yzTnR2Kut3QniMxe
         nQ9MSxd0vciqlDwuWJoAHQnwgwQ5BxxvLWpg/DGL60PQ8I3KfUp8J0Ge6kvK9xzTsg
         6iLV/zxHtLD2w==
From:   Eric Biggers <ebiggers@kernel.org>
To:     linux-crypto@vger.kernel.org
Cc:     x86@kernel.org, linux-arm-kernel@lists.infradead.org,
        Sami Tolvanen <samitolvanen@google.com>
Subject: [PATCH 04/11] crypto: x86/sha1 - fix possible crash with CFI enabled
Date:   Fri, 18 Nov 2022 01:02:13 -0800
Message-Id: <20221118090220.398819-5-ebiggers@kernel.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221118090220.398819-1-ebiggers@kernel.org>
References: <20221118090220.398819-1-ebiggers@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

From: Eric Biggers <ebiggers@google.com>

sha1_transform_ssse3(), sha1_transform_avx(), and sha1_ni_transform()
(but not sha1_transform_avx2()) are called via indirect function calls.
These functions need to use SYM_TYPED_FUNC_START instead of
SYM_FUNC_START to cause type hashes to be emitted when the kernel is
built with CONFIG_CFI_CLANG=y.  Otherwise, the code crashes with a CFI
failure (if the compiler didn't happen to optimize out the indirect
calls).

Fixes: 3c516f89e17e ("x86: Add support for CONFIG_CFI_CLANG")
Signed-off-by: Eric Biggers <ebiggers@google.com>
---
 arch/x86/crypto/sha1_ni_asm.S    | 3 ++-
 arch/x86/crypto/sha1_ssse3_asm.S | 3 ++-
 2 files changed, 4 insertions(+), 2 deletions(-)

diff --git a/arch/x86/crypto/sha1_ni_asm.S b/arch/x86/crypto/sha1_ni_asm.S
index 2f94ec0e763bf..3cae5a1bb3d6e 100644
--- a/arch/x86/crypto/sha1_ni_asm.S
+++ b/arch/x86/crypto/sha1_ni_asm.S
@@ -54,6 +54,7 @@
  */
 
 #include <linux/linkage.h>
+#include <linux/cfi_types.h>
 
 #define DIGEST_PTR	%rdi	/* 1st arg */
 #define DATA_PTR	%rsi	/* 2nd arg */
@@ -93,7 +94,7 @@
  */
 .text
 .align 32
-SYM_FUNC_START(sha1_ni_transform)
+SYM_TYPED_FUNC_START(sha1_ni_transform)
 	push		%rbp
 	mov		%rsp, %rbp
 	sub		$FRAME_SIZE, %rsp
diff --git a/arch/x86/crypto/sha1_ssse3_asm.S b/arch/x86/crypto/sha1_ssse3_asm.S
index 263f916362e02..f54988c80eb40 100644
--- a/arch/x86/crypto/sha1_ssse3_asm.S
+++ b/arch/x86/crypto/sha1_ssse3_asm.S
@@ -25,6 +25,7 @@
  */
 
 #include <linux/linkage.h>
+#include <linux/cfi_types.h>
 
 #define CTX	%rdi	// arg1
 #define BUF	%rsi	// arg2
@@ -67,7 +68,7 @@
  * param: function's name
  */
 .macro SHA1_VECTOR_ASM  name
-	SYM_FUNC_START(\name)
+	SYM_TYPED_FUNC_START(\name)
 
 	push	%rbx
 	push	%r12
-- 
2.38.1

