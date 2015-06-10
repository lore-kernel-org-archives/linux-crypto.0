From: Josh Poimboeuf <jpoimboe@redhat.com>
Subject: [PATCH v5 05/10] x86/asm/crypto: Fix asmvalidate warnings for ghash-clmulni-intel_asm.S
Date: Wed, 10 Jun 2015 07:06:13 -0500
Message-ID: <ec7741be9007b218965cec5c9a04d871b3dbd297.1433937132.git.jpoimboe@redhat.com>
References: <cover.1433937132.git.jpoimboe@redhat.com>
Cc: Michal Marek <mmarek@suse.cz>,
	Peter Zijlstra <peterz@infradead.org>,
	Andy Lutomirski <luto@kernel.org>,
	Borislav Petkov <bp@alien8.de>,
	Linus Torvalds <torvalds@linux-foundation.org>,
	Andi Kleen <andi@firstfloor.org>, x86@kernel.org,
	live-patching@vger.kernel.org, linux-kernel@vger.kernel.org,
	linux-crypto@vger.kernel.org,
	Herbert Xu <herbert@gondor.apana.org.au>,
	"David S. Miller" <davem@davemloft.net>
To: Thomas Gleixner <tglx@linutronix.de>,
	Ingo Molnar <mingo@redhat.com>,
	"H. Peter Anvin" <hpa@zytor.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:37564 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932613AbbFJMHN (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Wed, 10 Jun 2015 08:07:13 -0400
In-Reply-To: <cover.1433937132.git.jpoimboe@redhat.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Fix the following asmvalidate warnings:

   asmvalidate: arch/x86/crypto/ghash-clmulni-intel_asm.o: clmul_ghash_mul(): missing FP_SAVE/RESTORE macros
   asmvalidate: arch/x86/crypto/ghash-clmulni-intel_asm.o: clmul_ghash_update(): missing FP_SAVE/RESTORE macros

These are non-leaf callable functions, so save/restore the frame pointer
with FP_SAVE/RESTORE.

Signed-off-by: Josh Poimboeuf <jpoimboe@redhat.com>
Cc: linux-crypto@vger.kernel.org
Cc: Herbert Xu <herbert@gondor.apana.org.au>
Cc: "David S. Miller" <davem@davemloft.net>
---
 arch/x86/crypto/ghash-clmulni-intel_asm.S | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/arch/x86/crypto/ghash-clmulni-intel_asm.S b/arch/x86/crypto/ghash-clmulni-intel_asm.S
index 5d1e007..e5b76b1 100644
--- a/arch/x86/crypto/ghash-clmulni-intel_asm.S
+++ b/arch/x86/crypto/ghash-clmulni-intel_asm.S
@@ -18,6 +18,7 @@
 
 #include <linux/linkage.h>
 #include <asm/inst.h>
+#include <asm/func.h>
 
 .data
 
@@ -94,6 +95,7 @@ ENDPROC(__clmul_gf128mul_ble)
 
 /* void clmul_ghash_mul(char *dst, const u128 *shash) */
 ENTRY(clmul_ghash_mul)
+	FP_SAVE
 	movups (%rdi), DATA
 	movups (%rsi), SHASH
 	movaps .Lbswap_mask, BSWAP
@@ -101,6 +103,7 @@ ENTRY(clmul_ghash_mul)
 	call __clmul_gf128mul_ble
 	PSHUFB_XMM BSWAP DATA
 	movups DATA, (%rdi)
+	FP_RESTORE
 	ret
 ENDPROC(clmul_ghash_mul)
 
@@ -109,6 +112,7 @@ ENDPROC(clmul_ghash_mul)
  *			   const u128 *shash);
  */
 ENTRY(clmul_ghash_update)
+	FP_SAVE
 	cmp $16, %rdx
 	jb .Lupdate_just_ret	# check length
 	movaps .Lbswap_mask, BSWAP
@@ -128,5 +132,6 @@ ENTRY(clmul_ghash_update)
 	PSHUFB_XMM BSWAP DATA
 	movups DATA, (%rdi)
 .Lupdate_just_ret:
+	FP_RESTORE
 	ret
 ENDPROC(clmul_ghash_update)
-- 
2.1.0
