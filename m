Return-Path: <linux-crypto-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 66A7BC4332F
	for <linux-crypto@archiver.kernel.org>; Sun, 29 Oct 2023 05:16:06 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229486AbjJ2FQG (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Sun, 29 Oct 2023 01:16:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47026 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229446AbjJ2FQF (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Sun, 29 Oct 2023 01:16:05 -0400
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EC106C6
        for <linux-crypto@vger.kernel.org>; Sat, 28 Oct 2023 22:16:02 -0700 (PDT)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 840A5C433C9;
        Sun, 29 Oct 2023 05:16:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1698556562;
        bh=p3d3RHusl9dhI/UjgjiAh0bt3K3uBII4eYJeLQ6pnMw=;
        h=From:To:Cc:Subject:Date:From;
        b=qZDaiPOB26JR1ojNke7jiADc7I+JiXS7EiB7o50Bx8o3GgHiArSKCSqS8dpOzpjD4
         XaBWgfNIsMArOr02ZU61O1AYQJY9RmLz/2Lwrq6L2ByfrRuA6CPo8xtgzjD4cAb7TH
         TpnuiCWxHvxobVzdgRAH8ELRvxAAuQzjD6xssYKui51Z/jJpjMIDkEodd2dkqcndO3
         aECpAFhWSHeMEjtV5qJA8Kf2Mu9YZ9TOfOa80yYIGaDXyg/2510zQcjWBCZdWTk4pL
         Wl2c4wtORIE00YSuUiMeBhUhyyAAlkOd2NggGHzcQgcznAUt5PrWn/9VdAarfIwalP
         NGazSbHN6cOEQ==
From:   Eric Biggers <ebiggers@kernel.org>
To:     linux-crypto@vger.kernel.org
Cc:     Roxana Nicolescu <roxana.nicolescu@canonical.com>
Subject: [PATCH] crypto: x86/sha256 - autoload if SHA-NI detected
Date:   Sat, 28 Oct 2023 22:15:55 -0700
Message-ID: <20231029051555.157720-1-ebiggers@kernel.org>
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

Cc: Roxana Nicolescu <roxana.nicolescu@canonical.com>
Signed-off-by: Eric Biggers <ebiggers@google.com>
---
 arch/x86/crypto/sha256_ssse3_glue.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/arch/x86/crypto/sha256_ssse3_glue.c b/arch/x86/crypto/sha256_ssse3_glue.c
index 4c0383a90e11..a135cf9baca3 100644
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
@@ -38,20 +38,21 @@
 #include <crypto/sha2.h>
 #include <crypto/sha256_base.h>
 #include <linux/string.h>
 #include <asm/cpu_device_id.h>
 #include <asm/simd.h>
 
 asmlinkage void sha256_transform_ssse3(struct sha256_state *state,
 				       const u8 *data, int blocks);
 
 static const struct x86_cpu_id module_cpu_ids[] = {
+	X86_MATCH_FEATURE(X86_FEATURE_SHA_NI, NULL),
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

