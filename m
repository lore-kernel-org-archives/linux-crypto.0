Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 70192C433FE
	for <linux-crypto@archiver.kernel.org>; Fri, 18 Nov 2022 09:04:21 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241668AbiKRJET (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 18 Nov 2022 04:04:19 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54344 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241436AbiKRJEM (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 18 Nov 2022 04:04:12 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EEECA82BC5
        for <linux-crypto@vger.kernel.org>; Fri, 18 Nov 2022 01:04:09 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 6890F623C0
        for <linux-crypto@vger.kernel.org>; Fri, 18 Nov 2022 09:04:09 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A7AB4C43147;
        Fri, 18 Nov 2022 09:04:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1668762248;
        bh=mJsH5L9LpAZtcysiSyHXhJEv09v85eGVUHWCSa6xvLc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=sA1CiL1XzosLH61OUxoCSm3C1QMDTQZshxtbEDoz3+1vk8+AzfNScnLOcD23KoKI9
         jwlUpcSmq8gdvTeTi9a6KxA/zMHVR3e4RquZ9PE1RaEpFHgAUvc2m6EFgsPERAmdME
         UUptYxUzbVxH0ID07b45ZnAGqEDvd1I+M4yKsuYMENsd0epuuXT148thCyt73NrWYn
         xqzYILvnzM0Nmng7KEa9BQfRu4POghIeyzzA0WBgxIMFnosIuCMgJviO9KeD0nUCeM
         2hvBJ2oddwzRv6RciknvcNnRF0+VttvJ9EzVg9iqfeBJY/+30QevbwQ8x47FO9JG2G
         o+jSLeehssCSA==
From:   Eric Biggers <ebiggers@kernel.org>
To:     linux-crypto@vger.kernel.org
Cc:     x86@kernel.org, linux-arm-kernel@lists.infradead.org,
        Sami Tolvanen <samitolvanen@google.com>
Subject: [PATCH 05/11] crypto: x86/sha256 - fix possible crash with CFI enabled
Date:   Fri, 18 Nov 2022 01:02:14 -0800
Message-Id: <20221118090220.398819-6-ebiggers@kernel.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221118090220.398819-1-ebiggers@kernel.org>
References: <20221118090220.398819-1-ebiggers@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

From: Eric Biggers <ebiggers@google.com>

sha256_transform_ssse3(), sha256_transform_avx(),
sha256_transform_rorx(), and sha256_transform_ni() are called via
indirect function calls.  These functions need to use
SYM_TYPED_FUNC_START instead of SYM_FUNC_START to cause type hashes to
be emitted when the kernel is built with CONFIG_CFI_CLANG=y.  Otherwise,
the code crashes with a CFI failure (if the compiler didn't happen to
optimize out the indirect calls).

Fixes: 3c516f89e17e ("x86: Add support for CONFIG_CFI_CLANG")
Signed-off-by: Eric Biggers <ebiggers@google.com>
---
 arch/x86/crypto/sha256-avx-asm.S   | 3 ++-
 arch/x86/crypto/sha256-avx2-asm.S  | 3 ++-
 arch/x86/crypto/sha256-ssse3-asm.S | 3 ++-
 arch/x86/crypto/sha256_ni_asm.S    | 3 ++-
 4 files changed, 8 insertions(+), 4 deletions(-)

diff --git a/arch/x86/crypto/sha256-avx-asm.S b/arch/x86/crypto/sha256-avx-asm.S
index 3baa1ec390974..06ea30c20828d 100644
--- a/arch/x86/crypto/sha256-avx-asm.S
+++ b/arch/x86/crypto/sha256-avx-asm.S
@@ -48,6 +48,7 @@
 ########################################################################
 
 #include <linux/linkage.h>
+#include <linux/cfi_types.h>
 
 ## assume buffers not aligned
 #define    VMOVDQ vmovdqu
@@ -346,7 +347,7 @@ a = TMP_
 ## arg 3 : Num blocks
 ########################################################################
 .text
-SYM_FUNC_START(sha256_transform_avx)
+SYM_TYPED_FUNC_START(sha256_transform_avx)
 .align 32
 	pushq   %rbx
 	pushq   %r12
diff --git a/arch/x86/crypto/sha256-avx2-asm.S b/arch/x86/crypto/sha256-avx2-asm.S
index 9bcdbc47b8b4b..2d2be531a11ed 100644
--- a/arch/x86/crypto/sha256-avx2-asm.S
+++ b/arch/x86/crypto/sha256-avx2-asm.S
@@ -49,6 +49,7 @@
 ########################################################################
 
 #include <linux/linkage.h>
+#include <linux/cfi_types.h>
 
 ## assume buffers not aligned
 #define	VMOVDQ vmovdqu
@@ -523,7 +524,7 @@ STACK_SIZE	= _CTX      + _CTX_SIZE
 ## arg 3 : Num blocks
 ########################################################################
 .text
-SYM_FUNC_START(sha256_transform_rorx)
+SYM_TYPED_FUNC_START(sha256_transform_rorx)
 .align 32
 	pushq	%rbx
 	pushq	%r12
diff --git a/arch/x86/crypto/sha256-ssse3-asm.S b/arch/x86/crypto/sha256-ssse3-asm.S
index c4a5db612c327..7db28839108dd 100644
--- a/arch/x86/crypto/sha256-ssse3-asm.S
+++ b/arch/x86/crypto/sha256-ssse3-asm.S
@@ -47,6 +47,7 @@
 ########################################################################
 
 #include <linux/linkage.h>
+#include <linux/cfi_types.h>
 
 ## assume buffers not aligned
 #define    MOVDQ movdqu
@@ -355,7 +356,7 @@ a = TMP_
 ## arg 3 : Num blocks
 ########################################################################
 .text
-SYM_FUNC_START(sha256_transform_ssse3)
+SYM_TYPED_FUNC_START(sha256_transform_ssse3)
 .align 32
 	pushq   %rbx
 	pushq   %r12
diff --git a/arch/x86/crypto/sha256_ni_asm.S b/arch/x86/crypto/sha256_ni_asm.S
index 94d50dd27cb53..47f93937f798a 100644
--- a/arch/x86/crypto/sha256_ni_asm.S
+++ b/arch/x86/crypto/sha256_ni_asm.S
@@ -54,6 +54,7 @@
  */
 
 #include <linux/linkage.h>
+#include <linux/cfi_types.h>
 
 #define DIGEST_PTR	%rdi	/* 1st arg */
 #define DATA_PTR	%rsi	/* 2nd arg */
@@ -97,7 +98,7 @@
 
 .text
 .align 32
-SYM_FUNC_START(sha256_ni_transform)
+SYM_TYPED_FUNC_START(sha256_ni_transform)
 
 	shl		$6, NUM_BLKS		/*  convert to bytes */
 	jz		.Ldone_hash
-- 
2.38.1

