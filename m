Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2D114C4167B
	for <linux-crypto@archiver.kernel.org>; Fri, 18 Nov 2022 19:46:39 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241316AbiKRTqh (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 18 Nov 2022 14:46:37 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58362 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235467AbiKRTq3 (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 18 Nov 2022 14:46:29 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B15E88CFFB
        for <linux-crypto@vger.kernel.org>; Fri, 18 Nov 2022 11:46:26 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 4C4966277E
        for <linux-crypto@vger.kernel.org>; Fri, 18 Nov 2022 19:46:26 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ED9CCC433D7;
        Fri, 18 Nov 2022 19:46:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1668800786;
        bh=kMW+VagvP+m/FfoCh7s6tC3GVUtFQvTJqaIKESW1UH4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=JjeVGn8nldBI641WZBxQtxPLNepo8CQPS8YNSbUU43cGsQ3/2Ak+xN3DP1rAfDoEB
         JLzx4iADDlNubhwQTePqull+hV/RL/S6w1I6lt5C9kGxk5YI1DD4oAEW94eyE0hYLT
         ZAYE3smvPyy2nuJIh7wAUNwJk2etU9xN9S390jiSJC9A5VWDBKDWHdht9NHeSzRUl4
         w5TVIhkvTvCg8a9vsG9SR7HKwc1MHeSpma80kkxCn7SKUgMAVp6OxkZLc33ifmiowD
         ySn88t/8XZEo950gVGmL5UkxFamcR0rGJA20hFtTe7n0DXetlJDzg8Lcv/bL3nFUd4
         5iuZ5lz/Ji5Xg==
From:   Eric Biggers <ebiggers@kernel.org>
To:     linux-crypto@vger.kernel.org
Cc:     x86@kernel.org, linux-arm-kernel@lists.infradead.org,
        Sami Tolvanen <samitolvanen@google.com>,
        "Peter Zijlstra (Intel)" <peterz@infradead.org>
Subject: [PATCH v2 07/12] crypto: x86/sm3 - fix possible crash with CFI enabled
Date:   Fri, 18 Nov 2022 11:44:16 -0800
Message-Id: <20221118194421.160414-8-ebiggers@kernel.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221118194421.160414-1-ebiggers@kernel.org>
References: <20221118194421.160414-1-ebiggers@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

From: Eric Biggers <ebiggers@google.com>

sm3_transform_avx() is called via indirect function calls.  Therefore it
needs to use SYM_TYPED_FUNC_START instead of SYM_FUNC_START to cause its
type hash to be emitted when the kernel is built with
CONFIG_CFI_CLANG=y.  Otherwise, the code crashes with a CFI failure (if
the compiler didn't happen to optimize out the indirect call).

Fixes: ccace936eec7 ("x86: Add types to indirectly called assembly functions")
Acked-by: Peter Zijlstra (Intel) <peterz@infradead.org>
Reviewed-by: Sami Tolvanen <samitolvanen@google.com>
Signed-off-by: Eric Biggers <ebiggers@google.com>
---
 arch/x86/crypto/sm3-avx-asm_64.S | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/arch/x86/crypto/sm3-avx-asm_64.S b/arch/x86/crypto/sm3-avx-asm_64.S
index b12b9efb5ec51..8fc5ac681fd63 100644
--- a/arch/x86/crypto/sm3-avx-asm_64.S
+++ b/arch/x86/crypto/sm3-avx-asm_64.S
@@ -12,6 +12,7 @@
  */
 
 #include <linux/linkage.h>
+#include <linux/cfi_types.h>
 #include <asm/frame.h>
 
 /* Context structure */
@@ -328,7 +329,7 @@
  *                        const u8 *data, int nblocks);
  */
 .align 16
-SYM_FUNC_START(sm3_transform_avx)
+SYM_TYPED_FUNC_START(sm3_transform_avx)
 	/* input:
 	 *	%rdi: ctx, CTX
 	 *	%rsi: data (64*nblks bytes)
-- 
2.38.1

