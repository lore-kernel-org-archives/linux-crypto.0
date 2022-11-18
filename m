Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E1B7BC43219
	for <linux-crypto@archiver.kernel.org>; Fri, 18 Nov 2022 09:04:22 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241704AbiKRJEW (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 18 Nov 2022 04:04:22 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54356 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241705AbiKRJEM (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 18 Nov 2022 04:04:12 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5204879931
        for <linux-crypto@vger.kernel.org>; Fri, 18 Nov 2022 01:04:10 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 89630623C1
        for <linux-crypto@vger.kernel.org>; Fri, 18 Nov 2022 09:04:09 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3CE0BC433D6;
        Fri, 18 Nov 2022 09:04:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1668762249;
        bh=NnbwjD/ex8fXbifBK9kxmybIvw2mJxpjvji26vXujDE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=jCfMsnWwuLZr2TZMX42ziZkf9YQUI/Z7eUjtM7+vmN99cHpcGLu8BoyYZNKSin29Q
         fGxnshtgoc/9/yDLFLEvCqu+dmCY44y3gUTofehfryzsGicymkxlJRvWcOzafSe7bR
         O+0+aHnGVahABEPC8PVOdy6wUJmDMFaMs3SG+yzlzgmtg9chTFSU5PY1zqX3oE6rn0
         HdtJBfAadfp4QGOozG5olUgrRaR/UzcUM8rx+AQ7bFrPrWMzygCCcJWZ+WCj7WiEag
         xGkZ2t7gmMPfzrRqraVIdDjSncz8/T2PdRKGzXB65iuxcp2jE92LWeR3TAePTE2GgF
         +AvIqUqoixt4w==
From:   Eric Biggers <ebiggers@kernel.org>
To:     linux-crypto@vger.kernel.org
Cc:     x86@kernel.org, linux-arm-kernel@lists.infradead.org,
        Sami Tolvanen <samitolvanen@google.com>
Subject: [PATCH 07/11] crypto: x86/sm3 - fix possible crash with CFI enabled
Date:   Fri, 18 Nov 2022 01:02:16 -0800
Message-Id: <20221118090220.398819-8-ebiggers@kernel.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221118090220.398819-1-ebiggers@kernel.org>
References: <20221118090220.398819-1-ebiggers@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

From: Eric Biggers <ebiggers@google.com>

sm3_transform_avx() is called via indirect function calls.  This
function needs to use SYM_TYPED_FUNC_START instead of SYM_FUNC_START to
cause type hashes to be emitted when the kernel is built with
CONFIG_CFI_CLANG=y.  Otherwise, the code crashes with a CFI failure (if
the compiler didn't happen to optimize out the indirect call).

Fixes: 3c516f89e17e ("x86: Add support for CONFIG_CFI_CLANG")
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

