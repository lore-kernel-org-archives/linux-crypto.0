Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CBF85C433FE
	for <linux-crypto@archiver.kernel.org>; Fri, 18 Nov 2022 19:46:39 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235379AbiKRTqi (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 18 Nov 2022 14:46:38 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58328 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235521AbiKRTqa (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 18 Nov 2022 14:46:30 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B5F4B8D4A8
        for <linux-crypto@vger.kernel.org>; Fri, 18 Nov 2022 11:46:27 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 6C1E9B82504
        for <linux-crypto@vger.kernel.org>; Fri, 18 Nov 2022 19:46:26 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0B446C43145;
        Fri, 18 Nov 2022 19:46:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1668800785;
        bh=SJD1vbe3TbIhw+mwTcm5uBRYSsM1TzGphUBe1liqWrE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=XVl2DMLVSs2HOx7cBmnsYJTM66kDDvXWPb6kNYxobQXvoNILZHP5QWdeeXp/xZX69
         smMIgUE6p983K51FzNpAq24zTzSx+yVw1MMZc39NtTKCIdUkOb8MwdpH8QddBd+UCK
         aL7sM1o8a+PKgpxaxhSHsy/mIk8NQMdKyKLTVewufHX178cAhJ6ny04svwuucxOph/
         uWYJncSByfA3ZtSqI5L5308goQSDGqKieLiK0bRgUj8RU+nUeRK5IyvyoOQE0IwGhx
         GOtXnFByE0zD+Qwmp24fzNwaP90B6VIDExux0LOgPgYRJq8KqBFsYtsg/TygwvGxA8
         uOz10di6uwVgA==
From:   Eric Biggers <ebiggers@kernel.org>
To:     linux-crypto@vger.kernel.org
Cc:     x86@kernel.org, linux-arm-kernel@lists.infradead.org,
        Sami Tolvanen <samitolvanen@google.com>,
        "Peter Zijlstra (Intel)" <peterz@infradead.org>
Subject: [PATCH v2 04/12] crypto: x86/sha1 - fix possible crash with CFI enabled
Date:   Fri, 18 Nov 2022 11:44:13 -0800
Message-Id: <20221118194421.160414-5-ebiggers@kernel.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221118194421.160414-1-ebiggers@kernel.org>
References: <20221118194421.160414-1-ebiggers@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

From: Eric Biggers <ebiggers@google.com>

sha1_transform_ssse3(), sha1_transform_avx(), and sha1_ni_transform()
(but not sha1_transform_avx2()) are called via indirect function calls.
Therefore they need to use SYM_TYPED_FUNC_START instead of
SYM_FUNC_START to cause their type hashes to be emitted when the kernel
is built with CONFIG_CFI_CLANG=y.  Otherwise, the code crashes with a
CFI failure (if the compiler didn't happen to optimize out the indirect
calls).

Fixes: ccace936eec7 ("x86: Add types to indirectly called assembly functions")
Acked-by: Peter Zijlstra (Intel) <peterz@infradead.org>
Reviewed-by: Sami Tolvanen <samitolvanen@google.com>
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

