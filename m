From: Josh Poimboeuf <jpoimboe@redhat.com>
Subject: [PATCH v5 04/10] x86/asm/crypto: Fix asmvalidate warnings for aesni-intel_asm.S
Date: Wed, 10 Jun 2015 07:06:12 -0500
Message-ID: <2183e9c5fa6d3a508c4407bee2b188892ab84558.1433937132.git.jpoimboe@redhat.com>
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
Received: from mx1.redhat.com ([209.132.183.28]:43715 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752109AbbFJMHL (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Wed, 10 Jun 2015 08:07:11 -0400
In-Reply-To: <cover.1433937132.git.jpoimboe@redhat.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Fix the following asmvalidate warnings:

   asmvalidate: arch/x86/crypto/aesni-intel_asm.o: aesni_set_key(): missing FP_SAVE/RESTORE macros
   asmvalidate: arch/x86/crypto/aesni-intel_asm.o: aesni_enc(): missing FP_SAVE/RESTORE macros
   asmvalidate: arch/x86/crypto/aesni-intel_asm.o: aesni_dec(): missing FP_SAVE/RESTORE macros
   asmvalidate: arch/x86/crypto/aesni-intel_asm.o: aesni_ecb_enc(): missing FP_SAVE/RESTORE macros
   asmvalidate: arch/x86/crypto/aesni-intel_asm.o: aesni_ecb_dec(): missing FP_SAVE/RESTORE macros
   asmvalidate: arch/x86/crypto/aesni-intel_asm.o: aesni_cbc_enc(): missing FP_SAVE/RESTORE macros
   asmvalidate: arch/x86/crypto/aesni-intel_asm.o: aesni_cbc_dec(): missing FP_SAVE/RESTORE macros
   asmvalidate: arch/x86/crypto/aesni-intel_asm.o: aesni_ctr_enc(): missing FP_SAVE/RESTORE macros
   asmvalidate: arch/x86/crypto/aesni-intel_asm.o: aesni_xts_crypt8(): missing FP_SAVE/RESTORE macros

These are all non-leaf callable functions, so save/restore the frame
pointer with FP_SAVE/RESTORE.

Signed-off-by: Josh Poimboeuf <jpoimboe@redhat.com>
Cc: linux-crypto@vger.kernel.org
Cc: Herbert Xu <herbert@gondor.apana.org.au>
Cc: "David S. Miller" <davem@davemloft.net>
---
 arch/x86/crypto/aesni-intel_asm.S | 19 +++++++++++++++++++
 1 file changed, 19 insertions(+)

diff --git a/arch/x86/crypto/aesni-intel_asm.S b/arch/x86/crypto/aesni-intel_asm.S
index 6bd2c6c..83465f9a 100644
--- a/arch/x86/crypto/aesni-intel_asm.S
+++ b/arch/x86/crypto/aesni-intel_asm.S
@@ -31,6 +31,7 @@
 
 #include <linux/linkage.h>
 #include <asm/inst.h>
+#include <asm/func.h>
 
 /*
  * The following macros are used to move an (un)aligned 16 byte value to/from
@@ -1800,6 +1801,7 @@ ENDPROC(_key_expansion_256b)
  *                   unsigned int key_len)
  */
 ENTRY(aesni_set_key)
+	FP_SAVE
 #ifndef __x86_64__
 	pushl KEYP
 	movl 8(%esp), KEYP		# ctx
@@ -1905,6 +1907,7 @@ ENTRY(aesni_set_key)
 #ifndef __x86_64__
 	popl KEYP
 #endif
+	FP_RESTORE
 	ret
 ENDPROC(aesni_set_key)
 
@@ -1912,6 +1915,7 @@ ENDPROC(aesni_set_key)
  * void aesni_enc(struct crypto_aes_ctx *ctx, u8 *dst, const u8 *src)
  */
 ENTRY(aesni_enc)
+	FP_SAVE
 #ifndef __x86_64__
 	pushl KEYP
 	pushl KLEN
@@ -1927,6 +1931,7 @@ ENTRY(aesni_enc)
 	popl KLEN
 	popl KEYP
 #endif
+	FP_RESTORE
 	ret
 ENDPROC(aesni_enc)
 
@@ -2101,6 +2106,7 @@ ENDPROC(_aesni_enc4)
  * void aesni_dec (struct crypto_aes_ctx *ctx, u8 *dst, const u8 *src)
  */
 ENTRY(aesni_dec)
+	FP_SAVE
 #ifndef __x86_64__
 	pushl KEYP
 	pushl KLEN
@@ -2117,6 +2123,7 @@ ENTRY(aesni_dec)
 	popl KLEN
 	popl KEYP
 #endif
+	FP_RESTORE
 	ret
 ENDPROC(aesni_dec)
 
@@ -2292,6 +2299,7 @@ ENDPROC(_aesni_dec4)
  *		      size_t len)
  */
 ENTRY(aesni_ecb_enc)
+	FP_SAVE
 #ifndef __x86_64__
 	pushl LEN
 	pushl KEYP
@@ -2342,6 +2350,7 @@ ENTRY(aesni_ecb_enc)
 	popl KEYP
 	popl LEN
 #endif
+	FP_RESTORE
 	ret
 ENDPROC(aesni_ecb_enc)
 
@@ -2350,6 +2359,7 @@ ENDPROC(aesni_ecb_enc)
  *		      size_t len);
  */
 ENTRY(aesni_ecb_dec)
+	FP_SAVE
 #ifndef __x86_64__
 	pushl LEN
 	pushl KEYP
@@ -2401,6 +2411,7 @@ ENTRY(aesni_ecb_dec)
 	popl KEYP
 	popl LEN
 #endif
+	FP_RESTORE
 	ret
 ENDPROC(aesni_ecb_dec)
 
@@ -2409,6 +2420,7 @@ ENDPROC(aesni_ecb_dec)
  *		      size_t len, u8 *iv)
  */
 ENTRY(aesni_cbc_enc)
+	FP_SAVE
 #ifndef __x86_64__
 	pushl IVP
 	pushl LEN
@@ -2443,6 +2455,7 @@ ENTRY(aesni_cbc_enc)
 	popl LEN
 	popl IVP
 #endif
+	FP_RESTORE
 	ret
 ENDPROC(aesni_cbc_enc)
 
@@ -2451,6 +2464,7 @@ ENDPROC(aesni_cbc_enc)
  *		      size_t len, u8 *iv)
  */
 ENTRY(aesni_cbc_dec)
+	FP_SAVE
 #ifndef __x86_64__
 	pushl IVP
 	pushl LEN
@@ -2534,6 +2548,7 @@ ENTRY(aesni_cbc_dec)
 	popl LEN
 	popl IVP
 #endif
+	FP_RESTORE
 	ret
 ENDPROC(aesni_cbc_dec)
 
@@ -2598,6 +2613,7 @@ ENDPROC(_aesni_inc)
  *		      size_t len, u8 *iv)
  */
 ENTRY(aesni_ctr_enc)
+	FP_SAVE
 	cmp $16, LEN
 	jb .Lctr_enc_just_ret
 	mov 480(KEYP), KLEN
@@ -2651,6 +2667,7 @@ ENTRY(aesni_ctr_enc)
 .Lctr_enc_ret:
 	movups IV, (IVP)
 .Lctr_enc_just_ret:
+	FP_RESTORE
 	ret
 ENDPROC(aesni_ctr_enc)
 
@@ -2677,6 +2694,7 @@ ENDPROC(aesni_ctr_enc)
  *			 bool enc, u8 *iv)
  */
 ENTRY(aesni_xts_crypt8)
+	FP_SAVE
 	cmpb $0, %cl
 	movl $0, %ecx
 	movl $240, %r10d
@@ -2777,6 +2795,7 @@ ENTRY(aesni_xts_crypt8)
 	pxor INC, STATE4
 	movdqu STATE4, 0x70(OUTP)
 
+	FP_RESTORE
 	ret
 ENDPROC(aesni_xts_crypt8)
 
-- 
2.1.0
