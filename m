Return-Path: <linux-crypto-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7C7DCC4332F
	for <linux-crypto@archiver.kernel.org>; Wed,  1 Nov 2023 03:18:34 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231288AbjKADSe (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Tue, 31 Oct 2023 23:18:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56264 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231253AbjKADSe (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 31 Oct 2023 23:18:34 -0400
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8F68FB4
        for <linux-crypto@vger.kernel.org>; Tue, 31 Oct 2023 20:18:31 -0700 (PDT)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2994AC433C7;
        Wed,  1 Nov 2023 03:18:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1698808711;
        bh=WXCxlJvxLrPB5tDNuDb6jmrpbDV0GAeFah2jy4QfnjI=;
        h=From:To:Cc:Subject:Date:From;
        b=KlipbVnQ4PsCCKU54jVYpCwj6t1wiBrymB54B7zyStSZiveTnlwZOqOyx67s9SIAw
         hlr4ObJKkOAINQZU+PVSN5NpWBs0oOrJ48ArmtouJCT6KyEfQEbj+7NmFsN8szi/yk
         ZWHMYE01RRJFKsu/spgw62bPVvA8hTRO7bIwSmXSuWnXTIxmr2kCfgPv9W8vT0+QFH
         miHF6bkrCxF17EZbn0HkMzu1BWt9bqRQErLwchLZEsevGnHSIASsnUyZFYdfVva0/f
         eXLHI7diWJIJqywQI8KJTJgrcX1oW5Vqz78O8NSAXEqMhh7S9lDnuppy6febpznzRl
         kCkklYIgI10fA==
From:   Eric Biggers <ebiggers@kernel.org>
To:     linux-crypto@vger.kernel.org
Cc:     Roxana Nicolescu <roxana.nicolescu@canonical.com>
Subject: [PATCH v2] crypto: x86/sha256 - autoload if SHA-NI detected
Date:   Tue, 31 Oct 2023 20:18:11 -0700
Message-ID: <20231101031811.23028-1-ebiggers@kernel.org>
X-Mailer: git-send-email 2.42.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

From: Eric Biggers <ebiggers@google.com>

The x86 SHA-256 module contains four implementations: SSSE3, AVX, AVX2,
and SHA-NI.  Commit 1c43c0f1f84a ("crypto: x86/sha - load modules based
on CPU features") made the module be autoloaded when SSSE3, AVX, or AVX2
is detected.  The omission of SHA-NI appears to be an oversight, perhaps
because of the outdated file-level comment.  This patch fixes this,
though in practice this makes no difference because SSSE3 is a subset of
the other three features anyway.  Indeed, sha256_ni_transform() executes
SSSE3 instructions such as pshufb.

Reviewed-by: Roxana Nicolescu <roxana.nicolescu@canonical.com>
Signed-off-by: Eric Biggers <ebiggers@google.com>
---

v2: added #ifdef

 arch/x86/crypto/sha256_ssse3_glue.c | 7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

diff --git a/arch/x86/crypto/sha256_ssse3_glue.c b/arch/x86/crypto/sha256_ssse3_glue.c
index 4c0383a90e114..e04a43d9f7d55 100644
--- a/arch/x86/crypto/sha256_ssse3_glue.c
+++ b/arch/x86/crypto/sha256_ssse3_glue.c
@@ -1,15 +1,15 @@
 /*
  * Cryptographic API.
  *
- * Glue code for the SHA256 Secure Hash Algorithm assembler
- * implementation using supplemental SSE3 / AVX / AVX2 instructions.
+ * Glue code for the SHA256 Secure Hash Algorithm assembler implementations
+ * using SSSE3, AVX, AVX2, and SHA-NI instructions.
  *
  * This file is based on sha256_generic.c
  *
  * Copyright (C) 2013 Intel Corporation.
  *
  * Author:
  *     Tim Chen <tim.c.chen@linux.intel.com>
  *
  * This program is free software; you can redistribute it and/or modify it
  * under the terms of the GNU General Public License as published by the Free
@@ -38,20 +38,23 @@
 #include <crypto/sha2.h>
 #include <crypto/sha256_base.h>
 #include <linux/string.h>
 #include <asm/cpu_device_id.h>
 #include <asm/simd.h>
 
 asmlinkage void sha256_transform_ssse3(struct sha256_state *state,
 				       const u8 *data, int blocks);
 
 static const struct x86_cpu_id module_cpu_ids[] = {
+#ifdef CONFIG_AS_SHA256_NI
+	X86_MATCH_FEATURE(X86_FEATURE_SHA_NI, NULL),
+#endif
 	X86_MATCH_FEATURE(X86_FEATURE_AVX2, NULL),
 	X86_MATCH_FEATURE(X86_FEATURE_AVX, NULL),
 	X86_MATCH_FEATURE(X86_FEATURE_SSSE3, NULL),
 	{}
 };
 MODULE_DEVICE_TABLE(x86cpu, module_cpu_ids);
 
 static int _sha256_update(struct shash_desc *desc, const u8 *data,
 			  unsigned int len, sha256_block_fn *sha256_xform)
 {

base-commit: f2b88bab69c86d4dab2bfd25a0e741d7df411f7a
-- 
2.42.0

