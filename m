Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9AD3BC433FE
	for <linux-crypto@archiver.kernel.org>; Fri, 18 Nov 2022 19:46:33 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235446AbiKRTqb (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 18 Nov 2022 14:46:31 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58330 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235350AbiKRTq3 (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 18 Nov 2022 14:46:29 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 83B708CF37
        for <linux-crypto@vger.kernel.org>; Fri, 18 Nov 2022 11:46:26 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id A99506276A
        for <linux-crypto@vger.kernel.org>; Fri, 18 Nov 2022 19:46:25 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5721AC43147;
        Fri, 18 Nov 2022 19:46:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1668800785;
        bh=qDEd6yjezAEKyeXhBgJqixcDjy7TkZZTMaumiYQZh3k=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=DBEPBR4DRSkF+Kb1ECCcGEn1Ubxv/dV/G+6aLXG4NvyXwplXEooeAdrG7XPZwaYKc
         j87GJp+ZztUXH6b6/DMu4YSbJ8g+K59EA+CgWzOtZmwy2FOtkx48JOpq4AP0jXjfQN
         UtvJ/BBhly38i9XphhacRGk0DiblV3Z0LH8hjnUfHIfI0Gh263SU4JMObQi6CM+hIq
         ZG7DoKNkPXOe+xxFWl5yy0iWYViMKuFKVcq1fPmKEXFbpHUEKCkDUHBQzOweqZDsnC
         nf14oYLw5fn3Szd9kQAPbtzdNC0zvehuAIhFTpydcbjgt8DcoAJB2GsZ2xvGZVieRa
         QjlqG1okzjFWA==
From:   Eric Biggers <ebiggers@kernel.org>
To:     linux-crypto@vger.kernel.org
Cc:     x86@kernel.org, linux-arm-kernel@lists.infradead.org,
        Sami Tolvanen <samitolvanen@google.com>,
        "Peter Zijlstra (Intel)" <peterz@infradead.org>
Subject: [PATCH v2 05/12] crypto: x86/sha256 - fix possible crash with CFI enabled
Date:   Fri, 18 Nov 2022 11:44:14 -0800
Message-Id: <20221118194421.160414-6-ebiggers@kernel.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221118194421.160414-1-ebiggers@kernel.org>
References: <20221118194421.160414-1-ebiggers@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

From: Eric Biggers <ebiggers@google.com>

sha256_transform_ssse3(), sha256_transform_avx(),
sha256_transform_rorx(), and sha256_ni_transform() are called via
indirect function calls.  Therefore they need to use
SYM_TYPED_FUNC_START instead of SYM_FUNC_START to cause their type
hashes to be emitted when the kernel is built with CONFIG_CFI_CLANG=y.
Otherwise, the code crashes with a CFI failure (if the compiler didn't
happen to optimize out the indirect calls).

Fixes: ccace936eec7 ("x86: Add types to indirectly called assembly functions")
Acked-by: Peter Zijlstra (Intel) <peterz@infradead.org>
Reviewed-by: Sami Tolvanen <samitolvanen@google.com>
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

