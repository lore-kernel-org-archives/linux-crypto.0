From: Geert Uytterhoeven <geert@linux-m68k.org>
Subject: [PATCH 1/3] compiler-gcc.h: Introduce __optimize function attribute
Date: Thu,  1 Feb 2018 11:21:58 +0100
Message-ID: <1517480520-4465-1-git-send-email-geert@linux-m68k.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Cc: Arnd Bergmann <arnd@arndb.de>,
        Andrew Morton <akpm@linux-foundation.org>,
        linux-crypto@vger.kernel.org, linux-sparse@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Geert Uytterhoeven <geert@linux-m68k.org>
To: Herbert Xu <herbert@gondor.apana.org.au>,
        "David S . Miller" <davem@davemloft.net>,
        Christopher Li <sparse@chrisli.org>,
        Ard Biesheuvel <ard.biesheuvel@linaro.org>,
        Tom Lendacky <thomas.lendacky@amd.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from andre.telenet-ops.be ([195.130.132.53]:46118 "EHLO
        andre.telenet-ops.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751774AbeBAKWI (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 1 Feb 2018 05:22:08 -0500
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Create a new function attribute __optimize, which allows to specify an
optimization level on a per-function basis.

Signed-off-by: Geert Uytterhoeven <geert@linux-m68k.org>
---
I assume this is supported as of gcc-4.4:
  - gcc version 4.3.3 (GCC): warning: ‘__optimize__’ attribute directive
    ignored
  - gcc version 4.4.7 (Ubuntu/Linaro 4.4.7-1ubuntu2): OK
---
 include/linux/compiler-gcc.h | 4 ++++
 include/linux/compiler.h     | 4 ++++
 2 files changed, 8 insertions(+)

diff --git a/include/linux/compiler-gcc.h b/include/linux/compiler-gcc.h
index 631354acfa720475..0a278a527944ad2f 100644
--- a/include/linux/compiler-gcc.h
+++ b/include/linux/compiler-gcc.h
@@ -196,6 +196,10 @@
 #endif /* __CHECKER__ */
 #endif /* GCC_VERSION >= 40300 */
 
+#if GCC_VERSION >= 40400
+#define __optimize(level)	__attribute__((__optimize__(level)))
+#endif /* GCC_VERSION >= 40400 */
+
 #if GCC_VERSION >= 40500
 
 #ifndef __CHECKER__
diff --git a/include/linux/compiler.h b/include/linux/compiler.h
index 52e611ab9a6cf6fd..5ff818e9a836e898 100644
--- a/include/linux/compiler.h
+++ b/include/linux/compiler.h
@@ -271,6 +271,10 @@ static __always_inline void __write_once_size(volatile void *p, void *res, int s
 
 #endif /* __ASSEMBLY__ */
 
+#ifndef __optimize
+# define __optimize(level)
+#endif
+
 /* Compile time object size, -1 for unknown */
 #ifndef __compiletime_object_size
 # define __compiletime_object_size(obj) -1
-- 
2.7.4
