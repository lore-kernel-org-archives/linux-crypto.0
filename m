Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3BE9BC433FE
	for <linux-crypto@archiver.kernel.org>; Fri, 18 Nov 2022 09:04:19 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241719AbiKRJER (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 18 Nov 2022 04:04:17 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54342 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241455AbiKRJEM (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 18 Nov 2022 04:04:12 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EEDDA7EC8F
        for <linux-crypto@vger.kernel.org>; Fri, 18 Nov 2022 01:04:09 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 431F1623BD
        for <linux-crypto@vger.kernel.org>; Fri, 18 Nov 2022 09:04:09 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EC565C43146;
        Fri, 18 Nov 2022 09:04:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1668762249;
        bh=cvZrVNyaorZiFckp5I/DQO2Na69JdiQKH9GTwngz5kw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Txbmq1+8Os6ha8bRpkOEpMYl4yfovwRGORc/Q36bVbY0f/kt0jgLZs757o5lelPUR
         M4/GAy/RPij5/oInIsOl55+yuMlU2sQFJ05AcXKY4PudJAEycWR9iXNmcx1h5h3YNR
         209MaRi+OoMvgNO4JI6rRGhf58knvpGrLNL6l5Kryv6wNaau6jo0dH5ItNYO++N6F1
         PgC/p10LMij1YENAKkUG7CjntqP+312yJl+rZHiDardnnksxhPWLC1/rZoymXxqI5v
         dJORoyoJ2st87QAEJ/29Yi/9ygXONH/V34yN4BAKpsyZDJUpXzhspBzN7sSC19jbu0
         KFZ777WpuVDDw==
From:   Eric Biggers <ebiggers@kernel.org>
To:     linux-crypto@vger.kernel.org
Cc:     x86@kernel.org, linux-arm-kernel@lists.infradead.org,
        Sami Tolvanen <samitolvanen@google.com>
Subject: [PATCH 06/11] crypto: x86/sha512 - fix possible crash with CFI enabled
Date:   Fri, 18 Nov 2022 01:02:15 -0800
Message-Id: <20221118090220.398819-7-ebiggers@kernel.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221118090220.398819-1-ebiggers@kernel.org>
References: <20221118090220.398819-1-ebiggers@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

From: Eric Biggers <ebiggers@google.com>

sha512_transform_rorx(), sha512_transform_ssse3(), and
sha512_transform_avx() are called via indirect function calls.  These
functions need to use SYM_TYPED_FUNC_START instead of SYM_FUNC_START to
cause type hashes to be emitted when the kernel is built with
CONFIG_CFI_CLANG=y.  Otherwise, the code crashes with a CFI failure (if
the compiler didn't happen to optimize out the indirect calls).

Fixes: 3c516f89e17e ("x86: Add support for CONFIG_CFI_CLANG")
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

