Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-19.0 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 21F6BC43219
	for <linux-crypto@archiver.kernel.org>; Thu, 31 Dec 2020 17:25:33 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id EFB40223E4
	for <linux-crypto@archiver.kernel.org>; Thu, 31 Dec 2020 17:25:32 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727163AbgLaRZc (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 31 Dec 2020 12:25:32 -0500
Received: from mail.kernel.org ([198.145.29.99]:55050 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727143AbgLaRZc (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 31 Dec 2020 12:25:32 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 63070223DB;
        Thu, 31 Dec 2020 17:24:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1609435478;
        bh=OKQ0fd2bs8JpVACCWAKpCv690JDohzIxTKiett1tB0c=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=LfO6hvg5RvBIyJk4eO2xtneHGeHkm/UDL5614+p4YAgxQi97Y51nqykHSZbkscsDP
         wDIaMKrl69R3xHA2nE8P7LkYyOKR3lOtEuD+S8Sm2d4WgGd6bXI63dW8qXAQcpt/8R
         +WwXftgPFp9WZt+EMmwrcw+5NqfGfe0R0jESZGTdLcakeLH4+8OHI/l1aCljM3MTw9
         T/SEml8IoQNklqS1Xtvv4jBXwWN7n8VA7POPMI0laTY38Rn41f2Z+ySg8sEE3F4neK
         TL35WRnp5WOZGhhOdWp5YC5XkJf7dtXW6Uiucb4I+UAGEWxCBG9lvkCyOEmwC1RMPy
         A2L75UgpCjZ2g==
From:   Ard Biesheuvel <ardb@kernel.org>
To:     linux-crypto@vger.kernel.org
Cc:     Ard Biesheuvel <ardb@kernel.org>, Megha Dey <megha.dey@intel.com>,
        Eric Biggers <ebiggers@kernel.org>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Milan Broz <gmazyland@gmail.com>,
        Mike Snitzer <snitzer@redhat.com>
Subject: [PATCH 21/21] crypto: x86 - use local headers for x86 specific shared declarations
Date:   Thu, 31 Dec 2020 18:23:37 +0100
Message-Id: <20201231172337.23073-22-ardb@kernel.org>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20201231172337.23073-1-ardb@kernel.org>
References: <20201231172337.23073-1-ardb@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

The Camellia, Serpent and Twofish related header files only contain
declarations that are shared between different implementations of the
respective algorithms residing under arch/x86/crypto, and none of their
contents should be used elsewhere. So move the header files into the
same location, and use local #includes instead.

Signed-off-by: Ard Biesheuvel <ardb@kernel.org>
---
 arch/x86/{include/asm => }/crypto/camellia.h     | 0
 arch/x86/crypto/camellia_aesni_avx2_glue.c       | 2 +-
 arch/x86/crypto/camellia_aesni_avx_glue.c        | 2 +-
 arch/x86/crypto/camellia_glue.c                  | 2 +-
 arch/x86/{include/asm => }/crypto/serpent-avx.h  | 0
 arch/x86/{include/asm => }/crypto/serpent-sse2.h | 0
 arch/x86/crypto/serpent_avx2_glue.c              | 2 +-
 arch/x86/crypto/serpent_avx_glue.c               | 2 +-
 arch/x86/crypto/serpent_sse2_glue.c              | 2 +-
 arch/x86/{include/asm => }/crypto/twofish.h      | 0
 arch/x86/crypto/twofish_avx_glue.c               | 2 +-
 arch/x86/crypto/twofish_glue_3way.c              | 2 +-
 12 files changed, 8 insertions(+), 8 deletions(-)

diff --git a/arch/x86/include/asm/crypto/camellia.h b/arch/x86/crypto/camellia.h
similarity index 100%
rename from arch/x86/include/asm/crypto/camellia.h
rename to arch/x86/crypto/camellia.h
diff --git a/arch/x86/crypto/camellia_aesni_avx2_glue.c b/arch/x86/crypto/camellia_aesni_avx2_glue.c
index ef5c0f094584..e7e4d64e9577 100644
--- a/arch/x86/crypto/camellia_aesni_avx2_glue.c
+++ b/arch/x86/crypto/camellia_aesni_avx2_glue.c
@@ -5,7 +5,6 @@
  * Copyright © 2013 Jussi Kivilinna <jussi.kivilinna@mbnet.fi>
  */
 
-#include <asm/crypto/camellia.h>
 #include <crypto/algapi.h>
 #include <crypto/internal/simd.h>
 #include <linux/crypto.h>
@@ -13,6 +12,7 @@
 #include <linux/module.h>
 #include <linux/types.h>
 
+#include "camellia.h"
 #include "ecb_cbc_helpers.h"
 
 #define CAMELLIA_AESNI_PARALLEL_BLOCKS 16
diff --git a/arch/x86/crypto/camellia_aesni_avx_glue.c b/arch/x86/crypto/camellia_aesni_avx_glue.c
index 68fed0a79889..c7ccf63e741e 100644
--- a/arch/x86/crypto/camellia_aesni_avx_glue.c
+++ b/arch/x86/crypto/camellia_aesni_avx_glue.c
@@ -5,7 +5,6 @@
  * Copyright © 2012-2013 Jussi Kivilinna <jussi.kivilinna@iki.fi>
  */
 
-#include <asm/crypto/camellia.h>
 #include <crypto/algapi.h>
 #include <crypto/internal/simd.h>
 #include <linux/crypto.h>
@@ -13,6 +12,7 @@
 #include <linux/module.h>
 #include <linux/types.h>
 
+#include "camellia.h"
 #include "ecb_cbc_helpers.h"
 
 #define CAMELLIA_AESNI_PARALLEL_BLOCKS 16
diff --git a/arch/x86/crypto/camellia_glue.c b/arch/x86/crypto/camellia_glue.c
index 6c314bb46211..8ecd796e2afd 100644
--- a/arch/x86/crypto/camellia_glue.c
+++ b/arch/x86/crypto/camellia_glue.c
@@ -14,8 +14,8 @@
 #include <linux/module.h>
 #include <linux/types.h>
 #include <crypto/algapi.h>
-#include <asm/crypto/camellia.h>
 
+#include "camellia.h"
 #include "ecb_cbc_helpers.h"
 
 /* regular block cipher functions */
diff --git a/arch/x86/include/asm/crypto/serpent-avx.h b/arch/x86/crypto/serpent-avx.h
similarity index 100%
rename from arch/x86/include/asm/crypto/serpent-avx.h
rename to arch/x86/crypto/serpent-avx.h
diff --git a/arch/x86/include/asm/crypto/serpent-sse2.h b/arch/x86/crypto/serpent-sse2.h
similarity index 100%
rename from arch/x86/include/asm/crypto/serpent-sse2.h
rename to arch/x86/crypto/serpent-sse2.h
diff --git a/arch/x86/crypto/serpent_avx2_glue.c b/arch/x86/crypto/serpent_avx2_glue.c
index 261c9ac2d762..ccf0b5fa4933 100644
--- a/arch/x86/crypto/serpent_avx2_glue.c
+++ b/arch/x86/crypto/serpent_avx2_glue.c
@@ -12,8 +12,8 @@
 #include <crypto/algapi.h>
 #include <crypto/internal/simd.h>
 #include <crypto/serpent.h>
-#include <asm/crypto/serpent-avx.h>
 
+#include "serpent-avx.h"
 #include "ecb_cbc_helpers.h"
 
 #define SERPENT_AVX2_PARALLEL_BLOCKS 16
diff --git a/arch/x86/crypto/serpent_avx_glue.c b/arch/x86/crypto/serpent_avx_glue.c
index 5fe01d2a5b1d..6c248e1ea4ef 100644
--- a/arch/x86/crypto/serpent_avx_glue.c
+++ b/arch/x86/crypto/serpent_avx_glue.c
@@ -15,8 +15,8 @@
 #include <crypto/algapi.h>
 #include <crypto/internal/simd.h>
 #include <crypto/serpent.h>
-#include <asm/crypto/serpent-avx.h>
 
+#include "serpent-avx.h"
 #include "ecb_cbc_helpers.h"
 
 /* 8-way parallel cipher functions */
diff --git a/arch/x86/crypto/serpent_sse2_glue.c b/arch/x86/crypto/serpent_sse2_glue.c
index e28d60949c16..d78f37e9b2cf 100644
--- a/arch/x86/crypto/serpent_sse2_glue.c
+++ b/arch/x86/crypto/serpent_sse2_glue.c
@@ -20,8 +20,8 @@
 #include <crypto/b128ops.h>
 #include <crypto/internal/simd.h>
 #include <crypto/serpent.h>
-#include <asm/crypto/serpent-sse2.h>
 
+#include "serpent-sse2.h"
 #include "ecb_cbc_helpers.h"
 
 static int serpent_setkey_skcipher(struct crypto_skcipher *tfm,
diff --git a/arch/x86/include/asm/crypto/twofish.h b/arch/x86/crypto/twofish.h
similarity index 100%
rename from arch/x86/include/asm/crypto/twofish.h
rename to arch/x86/crypto/twofish.h
diff --git a/arch/x86/crypto/twofish_avx_glue.c b/arch/x86/crypto/twofish_avx_glue.c
index 6ce198f808a5..3eb3440b477a 100644
--- a/arch/x86/crypto/twofish_avx_glue.c
+++ b/arch/x86/crypto/twofish_avx_glue.c
@@ -15,8 +15,8 @@
 #include <crypto/algapi.h>
 #include <crypto/internal/simd.h>
 #include <crypto/twofish.h>
-#include <asm/crypto/twofish.h>
 
+#include "twofish.h"
 #include "ecb_cbc_helpers.h"
 
 #define TWOFISH_PARALLEL_BLOCKS 8
diff --git a/arch/x86/crypto/twofish_glue_3way.c b/arch/x86/crypto/twofish_glue_3way.c
index d1fdefa5195a..03725696397c 100644
--- a/arch/x86/crypto/twofish_glue_3way.c
+++ b/arch/x86/crypto/twofish_glue_3way.c
@@ -5,7 +5,6 @@
  * Copyright (c) 2011 Jussi Kivilinna <jussi.kivilinna@mbnet.fi>
  */
 
-#include <asm/crypto/twofish.h>
 #include <crypto/algapi.h>
 #include <crypto/twofish.h>
 #include <linux/crypto.h>
@@ -13,6 +12,7 @@
 #include <linux/module.h>
 #include <linux/types.h>
 
+#include "twofish.h"
 #include "ecb_cbc_helpers.h"
 
 EXPORT_SYMBOL_GPL(__twofish_enc_blk_3way);
-- 
2.17.1

