Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AE3AFC433FE
	for <linux-crypto@archiver.kernel.org>; Fri, 18 Nov 2022 19:46:45 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235220AbiKRTqo (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 18 Nov 2022 14:46:44 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58398 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235594AbiKRTqb (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 18 Nov 2022 14:46:31 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9E1F08CFDE
        for <linux-crypto@vger.kernel.org>; Fri, 18 Nov 2022 11:46:29 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 50C1CB824C8
        for <linux-crypto@vger.kernel.org>; Fri, 18 Nov 2022 19:46:28 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D64BCC433B5;
        Fri, 18 Nov 2022 19:46:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1668800787;
        bh=502XtfzzJCvn41Ye4mf8jH8Z9XzhNMTzAZtoz+ow1Mk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=SvwBQUsI23XQ04sTI+nMVJ/WdNE5SRFV0xg5sQjzZmEWJ1B+c7rFPuO1rZ6ZiApwe
         oN0DQyrJnBsRXkaoO9X8r3laLNge0EW+fgfc6La6YGGQKvYuLZobjj3n8AkCMhC8mf
         gOpZJOhwNEVzfBoL7N5xSXxS6HEVgx6G/y5WmkR3LGvn79IeLRXprShuZwm2R4cnRB
         G8PqvC13bsWK+9I4PZkHV/TLQhlxmBxO7JVrraQ7AwrR5n2+PHMp5YwEAsTxy55WQw
         VT6e73YReQNO5UW1oa5/5CTixIuDmDQIHWoGgQiiMGWEe7EVzdvKrUIl6Kw8W45yry
         I5s/S5nTK7/1g==
From:   Eric Biggers <ebiggers@kernel.org>
To:     linux-crypto@vger.kernel.org
Cc:     x86@kernel.org, linux-arm-kernel@lists.infradead.org,
        Sami Tolvanen <samitolvanen@google.com>,
        "Peter Zijlstra (Intel)" <peterz@infradead.org>
Subject: [PATCH v2 10/12] crypto: arm64/sm3 - fix possible crash with CFI enabled
Date:   Fri, 18 Nov 2022 11:44:19 -0800
Message-Id: <20221118194421.160414-11-ebiggers@kernel.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221118194421.160414-1-ebiggers@kernel.org>
References: <20221118194421.160414-1-ebiggers@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

From: Eric Biggers <ebiggers@google.com>

sm3_neon_transform() is called via indirect function calls.  Therefore
it needs to use SYM_TYPED_FUNC_START instead of SYM_FUNC_START to cause
its type hash to be emitted when the kernel is built with
CONFIG_CFI_CLANG=y.  Otherwise, the code crashes with a CFI failure (if
the compiler didn't happen to optimize out the indirect call).

Fixes: c50d32859e70 ("arm64: Add types to indirect called assembly functions")
Acked-by: Peter Zijlstra (Intel) <peterz@infradead.org>
Reviewed-by: Sami Tolvanen <samitolvanen@google.com>
Signed-off-by: Eric Biggers <ebiggers@google.com>
---
 arch/arm64/crypto/sm3-neon-core.S | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/arch/arm64/crypto/sm3-neon-core.S b/arch/arm64/crypto/sm3-neon-core.S
index 3e3b4e5c736fc..4357e0e51be38 100644
--- a/arch/arm64/crypto/sm3-neon-core.S
+++ b/arch/arm64/crypto/sm3-neon-core.S
@@ -9,6 +9,7 @@
  */
 
 #include <linux/linkage.h>
+#include <linux/cfi_types.h>
 #include <asm/assembler.h>
 
 /* Context structure */
@@ -351,7 +352,7 @@
 	 */
 	.text
 .align 3
-SYM_FUNC_START(sm3_neon_transform)
+SYM_TYPED_FUNC_START(sm3_neon_transform)
 	ldp		ra, rb, [RSTATE, #0]
 	ldp		rc, rd, [RSTATE, #8]
 	ldp		re, rf, [RSTATE, #16]
-- 
2.38.1

