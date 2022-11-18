Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 572D1C43219
	for <linux-crypto@archiver.kernel.org>; Fri, 18 Nov 2022 19:46:38 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235483AbiKRTqe (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 18 Nov 2022 14:46:34 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58358 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235465AbiKRTq3 (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 18 Nov 2022 14:46:29 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 83CAC8CFCC
        for <linux-crypto@vger.kernel.org>; Fri, 18 Nov 2022 11:46:26 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 0220C62779
        for <linux-crypto@vger.kernel.org>; Fri, 18 Nov 2022 19:46:26 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A245FC43146;
        Fri, 18 Nov 2022 19:46:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1668800785;
        bh=HdiSoWnZUTCZpmQjT2Un6tm8QTRonixjlwqY064EQSg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=nFUVKDQu84QOhgaSio7dWBuVl7bRghkrifp3HXo62eW9ILO3xqm2T04vi0Z4xxAJ7
         n6eojRyj2Kk68HPINIAorrqNaF+5kyNJXdXq5zWcK/cVfG3q8EeGiqARm3T+RGqSXW
         hOCeOmqUXt+q0H2UwCwDwK2UdriOXz8O3Kfae56ZkzjoiC84Hufd/jpwvuGCmhdjD7
         rXfWtNsg8XXpyo6wg+EWQs1otRvV5cN3WJw1fQxhIxmj5KcJPRIAD/+S6hhnRGPdZE
         CW2MCG72y4aDWei6QXJTrQ9rpq+Z9Jx5R67rz7LByV3Ttuq0i5YfVccY2x73D16fhx
         mQZgIX+FDE7MA==
From:   Eric Biggers <ebiggers@kernel.org>
To:     linux-crypto@vger.kernel.org
Cc:     x86@kernel.org, linux-arm-kernel@lists.infradead.org,
        Sami Tolvanen <samitolvanen@google.com>,
        "Peter Zijlstra (Intel)" <peterz@infradead.org>
Subject: [PATCH v2 06/12] crypto: x86/sha512 - fix possible crash with CFI enabled
Date:   Fri, 18 Nov 2022 11:44:15 -0800
Message-Id: <20221118194421.160414-7-ebiggers@kernel.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221118194421.160414-1-ebiggers@kernel.org>
References: <20221118194421.160414-1-ebiggers@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

From: Eric Biggers <ebiggers@google.com>

sha512_transform_ssse3(), sha512_transform_avx(), and
sha512_transform_rorx() are called via indirect function calls.
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
 arch/x86/crypto/sha512-avx-asm.S   | 3 ++-
 arch/x86/crypto/sha512-avx2-asm.S  | 3 ++-
 arch/x86/crypto/sha512-ssse3-asm.S | 3 ++-
 3 files changed, 6 insertions(+), 3 deletions(-)

diff --git a/arch/x86/crypto/sha512-avx-asm.S b/arch/x86/crypto/sha512-avx-asm.S
index 1fefe6dd3a9e2..b0984f19fdb40 100644
--- a/arch/x86/crypto/sha512-avx-asm.S
+++ b/arch/x86/crypto/sha512-avx-asm.S
@@ -48,6 +48,7 @@
 ########################################################################
 
 #include <linux/linkage.h>
+#include <linux/cfi_types.h>
 
 .text
 
@@ -273,7 +274,7 @@ frame_size = frame_WK + WK_SIZE
 # of SHA512 message blocks.
 # "blocks" is the message length in SHA512 blocks
 ########################################################################
-SYM_FUNC_START(sha512_transform_avx)
+SYM_TYPED_FUNC_START(sha512_transform_avx)
 	test msglen, msglen
 	je nowork
 
diff --git a/arch/x86/crypto/sha512-avx2-asm.S b/arch/x86/crypto/sha512-avx2-asm.S
index 5cdaab7d69015..b1ca99055ef99 100644
--- a/arch/x86/crypto/sha512-avx2-asm.S
+++ b/arch/x86/crypto/sha512-avx2-asm.S
@@ -50,6 +50,7 @@
 ########################################################################
 
 #include <linux/linkage.h>
+#include <linux/cfi_types.h>
 
 .text
 
@@ -565,7 +566,7 @@ frame_size = frame_CTX + CTX_SIZE
 # of SHA512 message blocks.
 # "blocks" is the message length in SHA512 blocks
 ########################################################################
-SYM_FUNC_START(sha512_transform_rorx)
+SYM_TYPED_FUNC_START(sha512_transform_rorx)
 	# Save GPRs
 	push	%rbx
 	push	%r12
diff --git a/arch/x86/crypto/sha512-ssse3-asm.S b/arch/x86/crypto/sha512-ssse3-asm.S
index b84c22e06c5f7..c06afb5270e5f 100644
--- a/arch/x86/crypto/sha512-ssse3-asm.S
+++ b/arch/x86/crypto/sha512-ssse3-asm.S
@@ -48,6 +48,7 @@
 ########################################################################
 
 #include <linux/linkage.h>
+#include <linux/cfi_types.h>
 
 .text
 
@@ -274,7 +275,7 @@ frame_size = frame_WK + WK_SIZE
 # of SHA512 message blocks.
 # "blocks" is the message length in SHA512 blocks.
 ########################################################################
-SYM_FUNC_START(sha512_transform_ssse3)
+SYM_TYPED_FUNC_START(sha512_transform_ssse3)
 
 	test msglen, msglen
 	je nowork
-- 
2.38.1

