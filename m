Return-Path: <linux-crypto-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 209C8C4332F
	for <linux-crypto@archiver.kernel.org>; Wed,  1 Nov 2023 03:17:41 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229850AbjKADRl (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Tue, 31 Oct 2023 23:17:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35312 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231288AbjKADRj (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 31 Oct 2023 23:17:39 -0400
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4C7AFF3
        for <linux-crypto@vger.kernel.org>; Tue, 31 Oct 2023 20:17:37 -0700 (PDT)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D669DC433C7;
        Wed,  1 Nov 2023 03:17:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1698808656;
        bh=sReLZ0Z7Zj9czZY+zZ33Gk7AgbhKbpl4xaU6pZ28be4=;
        h=From:To:Cc:Subject:Date:From;
        b=LjRddgvZlIbFkt7KWrOi1S3wkhNmJEhReIMJKMfJfOhxSG5dW6eQW5oFHqcLgIiM2
         f6bVcAUbdf2jB+/Jokic5SB/YuRkQ0G/SQJ36IbhCq4QCsFYLGb9Zlbs1Ru5J0yUKM
         vZQDAqxv8XvL2gXt4IaDC/bBm9V0hrJUznyHH2zAisPwY4povHEetX902YQRe6YhbI
         27E/u/2GxFKp+5p9cv44bdQSl7TgULqPbIJJ8MQcKkQXJKR4gQZfS9Zf6uk43i+473
         jkfjSxgjbJcqmawMp5XsUOphmRTcfc+Ay9+EHeqMgbYQ4tN2LXQpf0S+EJq0GAhQPX
         vA/4NDtnOvMCw==
From:   Eric Biggers <ebiggers@kernel.org>
To:     linux-crypto@vger.kernel.org
Cc:     Roxana Nicolescu <roxana.nicolescu@canonical.com>
Subject: [PATCH v2] crypto: x86/sha1 - autoload if SHA-NI detected
Date:   Tue, 31 Oct 2023 20:17:24 -0700
Message-ID: <20231101031724.22940-1-ebiggers@kernel.org>
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

Reviewed-by: Roxana Nicolescu <roxana.nicolescu@canonical.com>
Signed-off-by: Eric Biggers <ebiggers@google.com>
---

v2: added #ifdef

 arch/x86/crypto/sha1_ssse3_glue.c | 7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

diff --git a/arch/x86/crypto/sha1_ssse3_glue.c b/arch/x86/crypto/sha1_ssse3_glue.c
index 959afa705e95c..ab8bc54f254d3 100644
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
 
@@ -21,20 +21,23 @@
 #include <linux/init.h>
 #include <linux/module.h>
 #include <linux/mm.h>
 #include <linux/types.h>
 #include <crypto/sha1.h>
 #include <crypto/sha1_base.h>
 #include <asm/cpu_device_id.h>
 #include <asm/simd.h>
 
 static const struct x86_cpu_id module_cpu_ids[] = {
+#ifdef CONFIG_AS_SHA1_NI
+	X86_MATCH_FEATURE(X86_FEATURE_SHA_NI, NULL),
+#endif
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

