From: Geert Uytterhoeven <geert@linux-m68k.org>
Subject: [PATCH 2/3] compiler-gcc.h: __nostackprotector needs gcc-4.4 and up
Date: Thu,  1 Feb 2018 11:21:59 +0100
Message-ID: <1517480520-4465-2-git-send-email-geert@linux-m68k.org>
References: <1517480520-4465-1-git-send-email-geert@linux-m68k.org>
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
Received: from baptiste.telenet-ops.be ([195.130.132.51]:33010 "EHLO
        baptiste.telenet-ops.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752023AbeBAKWI (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 1 Feb 2018 05:22:08 -0500
In-Reply-To: <1517480520-4465-1-git-send-email-geert@linux-m68k.org>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Gcc versions before 4.4 do not recognize the __optimize__ compiler
attribute:

    warning: ‘__optimize__’ attribute directive ignored

Fixes: 7375ae3a0b79ea07 ("compiler-gcc.h: Introduce __nostackprotector function attribute")
Signed-off-by: Geert Uytterhoeven <geert@linux-m68k.org>
---
Can anyone please verify this?
Apparently __nostackprotector is used on x86 only, which is usually
served by modern compilers.
---
 include/linux/compiler-gcc.h | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/include/linux/compiler-gcc.h b/include/linux/compiler-gcc.h
index 0a278a527944ad2f..73bc63e0a1c4b664 100644
--- a/include/linux/compiler-gcc.h
+++ b/include/linux/compiler-gcc.h
@@ -167,8 +167,6 @@
 
 #if GCC_VERSION >= 40100
 # define __compiletime_object_size(obj) __builtin_object_size(obj, 0)
-
-#define __nostackprotector	__attribute__((__optimize__("no-stack-protector")))
 #endif
 
 #if GCC_VERSION >= 40300
@@ -198,6 +196,7 @@
 
 #if GCC_VERSION >= 40400
 #define __optimize(level)	__attribute__((__optimize__(level)))
+#define __nostackprotector	__optimize("no-stack-protector")
 #endif /* GCC_VERSION >= 40400 */
 
 #if GCC_VERSION >= 40500
-- 
2.7.4
