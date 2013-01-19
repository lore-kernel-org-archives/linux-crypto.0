From: Jussi Kivilinna <jussi.kivilinna@mbnet.fi>
Subject: [PATCH 08/12] crypto: x86/ghash - assembler clean-up: use ENDPROC
 at end of assember functions
Date: Sat, 19 Jan 2013 13:39:26 +0200
Message-ID: <20130119113926.22319.64937.stgit@localhost6.localdomain6>
References: <20130119113818.22319.26924.stgit@localhost6.localdomain6>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Cc: Herbert Xu <herbert@gondor.apana.org.au>,
	"David S. Miller" <davem@davemloft.net>
To: linux-crypto@vger.kernel.org
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from sd-mail-sa-02.sanoma.fi ([158.127.18.162]:36895 "EHLO
	sd-mail-sa-02.sanoma.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751909Ab3ASLj2 (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Sat, 19 Jan 2013 06:39:28 -0500
In-Reply-To: <20130119113818.22319.26924.stgit@localhost6.localdomain6>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Signed-off-by: Jussi Kivilinna <jussi.kivilinn@mbnet.fi>
---
 arch/x86/crypto/ghash-clmulni-intel_asm.S |    4 ++++
 1 file changed, 4 insertions(+)

diff --git a/arch/x86/crypto/ghash-clmulni-intel_asm.S b/arch/x86/crypto/ghash-clmulni-intel_asm.S
index 1eb7f90..586f41a 100644
--- a/arch/x86/crypto/ghash-clmulni-intel_asm.S
+++ b/arch/x86/crypto/ghash-clmulni-intel_asm.S
@@ -94,6 +94,7 @@ __clmul_gf128mul_ble:
 	pxor T2, T1
 	pxor T1, DATA
 	ret
+ENDPROC(__clmul_gf128mul_ble)
 
 /* void clmul_ghash_mul(char *dst, const be128 *shash) */
 ENTRY(clmul_ghash_mul)
@@ -105,6 +106,7 @@ ENTRY(clmul_ghash_mul)
 	PSHUFB_XMM BSWAP DATA
 	movups DATA, (%rdi)
 	ret
+ENDPROC(clmul_ghash_mul)
 
 /*
  * void clmul_ghash_update(char *dst, const char *src, unsigned int srclen,
@@ -131,6 +133,7 @@ ENTRY(clmul_ghash_update)
 	movups DATA, (%rdi)
 .Lupdate_just_ret:
 	ret
+ENDPROC(clmul_ghash_update)
 
 /*
  * void clmul_ghash_setkey(be128 *shash, const u8 *key);
@@ -155,3 +158,4 @@ ENTRY(clmul_ghash_setkey)
 	pxor %xmm1, %xmm0
 	movups %xmm0, (%rdi)
 	ret
+ENDPROC(clmul_ghash_setkey)
