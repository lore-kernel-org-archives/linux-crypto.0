Return-Path: <linux-crypto-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6F25CC4332F
	for <linux-crypto@archiver.kernel.org>; Sun, 29 Oct 2023 05:15:53 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229451AbjJ2FPu (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Sun, 29 Oct 2023 01:15:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56120 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229446AbjJ2FPt (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Sun, 29 Oct 2023 01:15:49 -0400
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 92946C6
        for <linux-crypto@vger.kernel.org>; Sat, 28 Oct 2023 22:15:47 -0700 (PDT)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 05154C433C8;
        Sun, 29 Oct 2023 05:15:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1698556547;
        bh=f2aR0ASqxkAXYzJk61M5LPUuYNd0Y8xQhqI2Sfn09BI=;
        h=From:To:Cc:Subject:Date:From;
        b=S92VMpkET8yGjwHvguiasYNUZ1DY7ayH47nmVn8NfWVq1ouaModTM7+jWpES8sJTu
         sXhR85wnGVyb2v3fflxmxKC4dBc6OWilQINVNzKmKDooz1apl1g64DkvvNfTOfxjUY
         xwoO10sweuZJoXB4l4bwyNbiTqprxbsDcWllXwOnDyA+KzsenbZZMTp+plVNG6tpco
         KUO1e0sH8nSQQw1m41FCt/Rq5FZ7cbx1lIzIBQxALBmDfYsu0n8RdZG/pkrKLqsMKW
         Sucj0aB9jIj2z6cBr8dWRV5RvKSj7E2hbqCuGUT4cW5vNLysNExZrZfVRGKT0QfMHo
         9NqFxvwAc29+w==
From:   Eric Biggers <ebiggers@kernel.org>
To:     linux-crypto@vger.kernel.org
Cc:     Roxana Nicolescu <roxana.nicolescu@canonical.com>
Subject: [PATCH] crypto: x86/sha1 - autoload if SHA-NI detected
Date:   Sat, 28 Oct 2023 22:15:35 -0700
Message-ID: <20231029051535.157605-1-ebiggers@kernel.org>
X-Mailer: git-send-email 2.42.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

From: Eric Biggers <ebiggers@google.com>

The x86 SHA-1 module contains four implementations: SSSE3, AVX, AVX2,
and SHA-NI.  Commit 1c43c0f1f84a ("crypto: x86/sha - load modules based
on CPU features") made the module be autoloaded when SSSE3, AVX, or AVX2
is detected.  The omission of SHA-NI appears to be an oversight, perhaps
because of the outdated file-level comment.  This patch fixes this,
though in practice this makes no difference because SSSE3 is a subset of
the other three features anyway.  Indeed, sha1_ni_transform() executes
SSSE3 instructions such as pshufb.

Cc: Roxana Nicolescu <roxana.nicolescu@canonical.com>
Signed-off-by: Eric Biggers <ebiggers@google.com>
---
 arch/x86/crypto/sha1_ssse3_glue.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/arch/x86/crypto/sha1_ssse3_glue.c b/arch/x86/crypto/sha1_ssse3_glue.c
index 959afa705e95..d88991f2cb3a 100644
--- a/arch/x86/crypto/sha1_ssse3_glue.c
+++ b/arch/x86/crypto/sha1_ssse3_glue.c
@@ -1,16 +1,16 @@
 // SPDX-License-Identifier: GPL-2.0-or-later
 /*
  * Cryptographic API.
  *
- * Glue code for the SHA1 Secure Hash Algorithm assembler implementation using
- * Supplemental SSE3 instructions.
+ * Glue code for the SHA1 Secure Hash Algorithm assembler implementations
+ * using SSSE3, AVX, AVX2, and SHA-NI instructions.
  *
  * This file is based on sha1_generic.c
  *
  * Copyright (c) Alan Smithee.
  * Copyright (c) Andrew McDonald <andrew@mcdonald.org.uk>
  * Copyright (c) Jean-Francois Dive <jef@linuxbe.org>
  * Copyright (c) Mathias Krause <minipli@googlemail.com>
  * Copyright (c) Chandramouli Narayanan <mouli@linux.intel.com>
  */
 
@@ -21,20 +21,21 @@
 #include <linux/init.h>
 #include <linux/module.h>
 #include <linux/mm.h>
 #include <linux/types.h>
 #include <crypto/sha1.h>
 #include <crypto/sha1_base.h>
 #include <asm/cpu_device_id.h>
 #include <asm/simd.h>
 
 static const struct x86_cpu_id module_cpu_ids[] = {
+	X86_MATCH_FEATURE(X86_FEATURE_SHA_NI, NULL),
 	X86_MATCH_FEATURE(X86_FEATURE_AVX2, NULL),
 	X86_MATCH_FEATURE(X86_FEATURE_AVX, NULL),
 	X86_MATCH_FEATURE(X86_FEATURE_SSSE3, NULL),
 	{}
 };
 MODULE_DEVICE_TABLE(x86cpu, module_cpu_ids);
 
 static int sha1_update(struct shash_desc *desc, const u8 *data,
 			     unsigned int len, sha1_block_fn *sha1_xform)
 {

base-commit: f2b88bab69c86d4dab2bfd25a0e741d7df411f7a
-- 
2.42.0

