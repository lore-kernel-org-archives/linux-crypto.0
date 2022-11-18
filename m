Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1CB25C4321E
	for <linux-crypto@archiver.kernel.org>; Fri, 18 Nov 2022 19:46:39 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235465AbiKRTqg (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 18 Nov 2022 14:46:36 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58330 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235496AbiKRTqa (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 18 Nov 2022 14:46:30 -0500
Received: from sin.source.kernel.org (sin.source.kernel.org [IPv6:2604:1380:40e1:4800::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5D9538DA45
        for <linux-crypto@vger.kernel.org>; Fri, 18 Nov 2022 11:46:28 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 742E2CE2232
        for <linux-crypto@vger.kernel.org>; Fri, 18 Nov 2022 19:46:26 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 60099C43470;
        Fri, 18 Nov 2022 19:46:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1668800784;
        bh=1AOSU6xzPkyZPNezMVrPhaztVE44hJw1ys9zdKY6koM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=A+ktCSy592Yjx/NCkOseT3ZiTEEtueqN9gCPefhFCsZ7WThNX6ly9+2KQIdYpupDm
         LtqZdxpsDM1ViXm7uZFXm+wdrZZcvqW0zs20zoPzblN39ubY7N+kspDUSqMSlc3hL7
         S1YRE8ERG9kHtmcgr5c7dBVPzA/vu2Z6VTCDw9Nvl4DbWVOwZ8mEd1s44kfgC2V/e2
         1KieEmygbTqVoBhn4Kg52pRrOevsUYdzYV+MGC92TnIk1kvsG4eg4HesH4qgNT1HtG
         ukjQIlxdwsolBskgNvVR0UHY9lMwAWMOfXrs91QHaF2GHMKrmtg4i7f0Drx/OvU1nm
         JCiFvhpfmOvTw==
From:   Eric Biggers <ebiggers@kernel.org>
To:     linux-crypto@vger.kernel.org
Cc:     x86@kernel.org, linux-arm-kernel@lists.infradead.org,
        Sami Tolvanen <samitolvanen@google.com>,
        Taehee Yoo <ap420073@gmail.com>,
        "Peter Zijlstra (Intel)" <peterz@infradead.org>
Subject: [PATCH v2 02/12] crypto: x86/aria - fix crash with CFI enabled
Date:   Fri, 18 Nov 2022 11:44:11 -0800
Message-Id: <20221118194421.160414-3-ebiggers@kernel.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221118194421.160414-1-ebiggers@kernel.org>
References: <20221118194421.160414-1-ebiggers@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

From: Eric Biggers <ebiggers@google.com>

aria_aesni_avx_encrypt_16way(), aria_aesni_avx_decrypt_16way(),
aria_aesni_avx_ctr_crypt_16way(), aria_aesni_avx_gfni_encrypt_16way(),
aria_aesni_avx_gfni_decrypt_16way(), and
aria_aesni_avx_gfni_ctr_crypt_16way() are called via indirect function
calls.  Therefore they need to use SYM_TYPED_FUNC_START instead of
SYM_FUNC_START to cause their type hashes to be emitted when the kernel
is built with CONFIG_CFI_CLANG=y.  Otherwise, the code crashes with a
CFI failure.

Fixes: ccace936eec7 ("x86: Add types to indirectly called assembly functions")
Acked-by: Peter Zijlstra (Intel) <peterz@infradead.org>
Reviewed-by: Sami Tolvanen <samitolvanen@google.com>
Cc: Taehee Yoo <ap420073@gmail.com>
Signed-off-by: Eric Biggers <ebiggers@google.com>
---
 arch/x86/crypto/aria-aesni-avx-asm_64.S | 13 +++++++------
 1 file changed, 7 insertions(+), 6 deletions(-)

diff --git a/arch/x86/crypto/aria-aesni-avx-asm_64.S b/arch/x86/crypto/aria-aesni-avx-asm_64.S
index c75fd7d015ed8..03ae4cd1d976a 100644
--- a/arch/x86/crypto/aria-aesni-avx-asm_64.S
+++ b/arch/x86/crypto/aria-aesni-avx-asm_64.S
@@ -7,6 +7,7 @@
  */
 
 #include <linux/linkage.h>
+#include <linux/cfi_types.h>
 #include <asm/frame.h>
 
 /* struct aria_ctx: */
@@ -913,7 +914,7 @@ SYM_FUNC_START_LOCAL(__aria_aesni_avx_crypt_16way)
 	RET;
 SYM_FUNC_END(__aria_aesni_avx_crypt_16way)
 
-SYM_FUNC_START(aria_aesni_avx_encrypt_16way)
+SYM_TYPED_FUNC_START(aria_aesni_avx_encrypt_16way)
 	/* input:
 	*      %rdi: ctx, CTX
 	*      %rsi: dst
@@ -938,7 +939,7 @@ SYM_FUNC_START(aria_aesni_avx_encrypt_16way)
 	RET;
 SYM_FUNC_END(aria_aesni_avx_encrypt_16way)
 
-SYM_FUNC_START(aria_aesni_avx_decrypt_16way)
+SYM_TYPED_FUNC_START(aria_aesni_avx_decrypt_16way)
 	/* input:
 	*      %rdi: ctx, CTX
 	*      %rsi: dst
@@ -1039,7 +1040,7 @@ SYM_FUNC_START_LOCAL(__aria_aesni_avx_ctr_gen_keystream_16way)
 	RET;
 SYM_FUNC_END(__aria_aesni_avx_ctr_gen_keystream_16way)
 
-SYM_FUNC_START(aria_aesni_avx_ctr_crypt_16way)
+SYM_TYPED_FUNC_START(aria_aesni_avx_ctr_crypt_16way)
 	/* input:
 	*      %rdi: ctx
 	*      %rsi: dst
@@ -1208,7 +1209,7 @@ SYM_FUNC_START_LOCAL(__aria_aesni_avx_gfni_crypt_16way)
 	RET;
 SYM_FUNC_END(__aria_aesni_avx_gfni_crypt_16way)
 
-SYM_FUNC_START(aria_aesni_avx_gfni_encrypt_16way)
+SYM_TYPED_FUNC_START(aria_aesni_avx_gfni_encrypt_16way)
 	/* input:
 	*      %rdi: ctx, CTX
 	*      %rsi: dst
@@ -1233,7 +1234,7 @@ SYM_FUNC_START(aria_aesni_avx_gfni_encrypt_16way)
 	RET;
 SYM_FUNC_END(aria_aesni_avx_gfni_encrypt_16way)
 
-SYM_FUNC_START(aria_aesni_avx_gfni_decrypt_16way)
+SYM_TYPED_FUNC_START(aria_aesni_avx_gfni_decrypt_16way)
 	/* input:
 	*      %rdi: ctx, CTX
 	*      %rsi: dst
@@ -1258,7 +1259,7 @@ SYM_FUNC_START(aria_aesni_avx_gfni_decrypt_16way)
 	RET;
 SYM_FUNC_END(aria_aesni_avx_gfni_decrypt_16way)
 
-SYM_FUNC_START(aria_aesni_avx_gfni_ctr_crypt_16way)
+SYM_TYPED_FUNC_START(aria_aesni_avx_gfni_ctr_crypt_16way)
 	/* input:
 	*      %rdi: ctx
 	*      %rsi: dst
-- 
2.38.1

