Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7FB4BC4332F
	for <linux-crypto@archiver.kernel.org>; Fri, 18 Nov 2022 09:04:50 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241734AbiKRJEt (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 18 Nov 2022 04:04:49 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54402 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241715AbiKRJER (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 18 Nov 2022 04:04:17 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 971278A17A
        for <linux-crypto@vger.kernel.org>; Fri, 18 Nov 2022 01:04:12 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 2E9EDB82269
        for <linux-crypto@vger.kernel.org>; Fri, 18 Nov 2022 09:04:11 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C609FC433D7;
        Fri, 18 Nov 2022 09:04:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1668762249;
        bh=wyK4erNXYZLb0gGezT+2lcL+zroMKoz8h7GycCvuO2k=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=NqABtUTYY1aVx9PfXGJq58Dbdt7rDMgcoP+hSxU5ThNarF3tRMyvrwQwAEkXDGUO5
         tiJ5U6LMLR0lV4JumLMkHK8INpJW3VIBKbH25sTBOZ87643hheINT8JJZJRVNf2TJF
         Avmp31f8rb9nVNMm7VPa6EXaX/IeeMYxx0SdXLQ4veF50FCyygcXgJzJ0h/mNWUiz0
         nXsrpByKTHAWcFIFVyfqlGKRd3pquE2LM5zke5eFjTEU3S7TFTNO9O/gQ3AjOeWI8Y
         mPsBOdZcHGDb2+C+DgTlFSdpfjQy/mk723T/7DJTGcpPCtgOYlXcdr21Vaz+4C3FCr
         kxX8ORTboM8rw==
From:   Eric Biggers <ebiggers@kernel.org>
To:     linux-crypto@vger.kernel.org
Cc:     x86@kernel.org, linux-arm-kernel@lists.infradead.org,
        Sami Tolvanen <samitolvanen@google.com>
Subject: [PATCH 09/11] crypto: arm64/sm3 - fix possible crash with CFI enabled
Date:   Fri, 18 Nov 2022 01:02:18 -0800
Message-Id: <20221118090220.398819-10-ebiggers@kernel.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221118090220.398819-1-ebiggers@kernel.org>
References: <20221118090220.398819-1-ebiggers@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

From: Eric Biggers <ebiggers@google.com>

sm3_neon_transform() is called via indirect function calls.  This
function needs to use SYM_TYPED_FUNC_START instead of SYM_FUNC_START to
cause type hashes to be emitted when the kernel is built with
CONFIG_CFI_CLANG=y.  Otherwise, the code crashes with a CFI failure (if
the compiler didn't happen to optimize out the indirect call).

Fixes: c50d32859e70 ("arm64: Add types to indirect called assembly functions")
Signed-off-by: Eric Biggers <ebiggers@google.com>
---
 arch/arm64/crypto/sm3-neon-core.S | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/arm64/crypto/sm3-neon-core.S b/arch/arm64/crypto/sm3-neon-core.S
index 3e3b4e5c736fc..8abea1d39ddd9 100644
--- a/arch/arm64/crypto/sm3-neon-core.S
+++ b/arch/arm64/crypto/sm3-neon-core.S
@@ -9,7 +9,7 @@
  */
 
 #include <linux/linkage.h>
-#include <asm/assembler.h>
+#include <linux/cfi_types.h>
 
 /* Context structure */
 
@@ -351,7 +351,7 @@
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

