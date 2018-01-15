From: Arnd Bergmann <arnd@arndb.de>
Subject: [PATCH] crypto: aes-generic - fix aes-generic regression on powerpc
Date: Mon, 15 Jan 2018 16:55:37 +0100
Message-ID: <20180115155550.210622-1-arnd@arndb.de>
Cc: Ard Biesheuvel <ard.biesheuvel@linaro.org>,
        Richard Biener <rguenther@suse.de>,
        Jakub Jelinek <jakub@gcc.gnu.org>,
        linux-crypto@vger.kernel.org,
        Segher Boessenkool <segher@kernel.crashing.org>,
        Arnd Bergmann <arnd@arndb.de>, linux-kernel@vger.kernel.org
To: Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mout.kundenserver.de ([217.72.192.74]:51707 "EHLO
        mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S933820AbeAOP43 (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 15 Jan 2018 10:56:29 -0500
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

My last bugfix added -Os on the command line, which unfortunately caused
a build regression on powerpc in some configurations.

I've done some more analysis of the original problem and found slightly
different workaround that avoids this regression and also results in
better performance on gcc-7.0: -fcode-hoisting is an optimization step
that got added in gcc-7 and that for all gcc-7 versions causes worse
performance.

This disables -fcode-hoisting on all compilers that understand the option.
For gcc-7.1 and 7.2 I found the same performance as my previous patch
(using -Os), in gcc-7.0 it was even better. On gcc-8 I could see no
change in performance from this patch. In theory, code hoisting should
not be able make things better for the AES cipher, so leaving it
disabled for gcc-8 only serves to simplify the Makefile change.

Reported-by: kbuild test robot <fengguang.wu@intel.com>
Link: https://www.mail-archive.com/linux-crypto@vger.kernel.org/msg30418.html
Link: https://gcc.gnu.org/bugzilla/show_bug.cgi?id=83356
Link: https://gcc.gnu.org/bugzilla/show_bug.cgi?id=83651
Fixes: 148b974deea9 ("crypto: aes-generic - build with -Os on gcc-7+")
Signed-off-by: Arnd Bergmann <arnd@arndb.de>
---
 crypto/Makefile | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/crypto/Makefile b/crypto/Makefile
index daa69360e054..4223f9965db1 100644
--- a/crypto/Makefile
+++ b/crypto/Makefile
@@ -99,7 +99,7 @@ obj-$(CONFIG_CRYPTO_TWOFISH_COMMON) += twofish_common.o
 obj-$(CONFIG_CRYPTO_SERPENT) += serpent_generic.o
 CFLAGS_serpent_generic.o := $(call cc-option,-fsched-pressure)  # https://gcc.gnu.org/bugzilla/show_bug.cgi?id=79149
 obj-$(CONFIG_CRYPTO_AES) += aes_generic.o
-CFLAGS_aes_generic.o := $(call cc-ifversion, -ge, 0701, -Os) # https://gcc.gnu.org/bugzilla/show_bug.cgi?id=83356
+CFLAGS_aes_generic.o := $(call cc-option,fno-code-hosting) # https://gcc.gnu.org/bugzilla/show_bug.cgi?id=83356
 obj-$(CONFIG_CRYPTO_AES_TI) += aes_ti.o
 obj-$(CONFIG_CRYPTO_CAMELLIA) += camellia_generic.o
 obj-$(CONFIG_CRYPTO_CAST_COMMON) += cast_common.o
-- 
2.9.0
