From: Jussi Kivilinna <jussi.kivilinna@iki.fi>
Subject: [PATCH] crypto: x86: restore avx2_supported check
Date: Tue, 03 Sep 2013 16:49:47 +0300
Message-ID: <20130903134947.5366.51429.stgit@localhost6.localdomain6>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Cc: Herbert Xu <herbert@gondor.apana.org.au>
To: linux-crypto@vger.kernel.org
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from sypressi.dnainternet.net ([83.102.40.135]:55358 "EHLO
	sypressi.dnainternet.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932886Ab3ICNtv (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Tue, 3 Sep 2013 09:49:51 -0400
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Commit 3d387ef08c4 (Revert "crypto: blowfish - add AVX2/x86_64 implementation
of blowfish cipher") reverted too much as it removed the 'assembler supports
AVX2' check and therefore disabled remaining AVX2 implementations of Camellia
and Serpent. Patch restores the check and enables these implementations.

Signed-off-by: Jussi Kivilinna <jussi.kivilinna@iki.fi>
---
 arch/x86/crypto/Makefile |    2 ++
 1 file changed, 2 insertions(+)

diff --git a/arch/x86/crypto/Makefile b/arch/x86/crypto/Makefile
index 7d6ba9d..75b08e1e 100644
--- a/arch/x86/crypto/Makefile
+++ b/arch/x86/crypto/Makefile
@@ -3,6 +3,8 @@
 #
 
 avx_supported := $(call as-instr,vpxor %xmm0$(comma)%xmm0$(comma)%xmm0,yes,no)
+avx2_supported := $(call as-instr,vpgatherdd %ymm0$(comma)(%eax$(comma)%ymm1\
+				$(comma)4)$(comma)%ymm2,yes,no)
 
 obj-$(CONFIG_CRYPTO_ABLK_HELPER_X86) += ablk_helper.o
 obj-$(CONFIG_CRYPTO_GLUE_HELPER_X86) += glue_helper.o
