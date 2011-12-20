From: Jussi Kivilinna <jussi.kivilinna@mbnet.fi>
Subject: [PATCH] crypto - serpent-sse2: change transpose_4x4 to only use
 integer instructions
Date: Tue, 20 Dec 2011 12:58:06 +0200
Message-ID: <20111220105806.21682.30810.stgit@localhost6.localdomain6>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Cc: Herbert Xu <herbert@gondor.apana.org.au>,
	"David S. Miller" <davem@davemloft.net>
To: linux-crypto@vger.kernel.org
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from sd-mail-sa-02.sanoma.fi ([158.127.18.162]:37754 "EHLO
	sd-mail-sa-02.sanoma.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751104Ab1LTK6J (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Tue, 20 Dec 2011 05:58:09 -0500
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Matrix transpose macro in serpent-sse2 uses mix of SSE2 integer and SSE floating
point instructions, which might cause performance penality on some CPUs.

This patch replaces transpose_4x4 macro with version that uses only SSE2
integer instructions.

Signed-off-by: Jussi Kivilinna <jussi.kivilinna@mbnet.fi>
---
 arch/x86/crypto/serpent-sse2-i586-asm_32.S   |   29 ++++++++++++--------------
 arch/x86/crypto/serpent-sse2-x86_64-asm_64.S |   29 ++++++++++++--------------
 2 files changed, 26 insertions(+), 32 deletions(-)

diff --git a/arch/x86/crypto/serpent-sse2-i586-asm_32.S b/arch/x86/crypto/serpent-sse2-i586-asm_32.S
index 4e37677..c00053d 100644
--- a/arch/x86/crypto/serpent-sse2-i586-asm_32.S
+++ b/arch/x86/crypto/serpent-sse2-i586-asm_32.S
@@ -463,23 +463,20 @@
 	pand x0,		x4; \
 	pxor x2,		x4;
 
-#define transpose_4x4(x0, x1, x2, x3, t1, t2, t3) \
-	movdqa x2,		t3; \
-	movdqa x0,		t1; \
-	unpcklps x3,		t3; \
+#define transpose_4x4(x0, x1, x2, x3, t0, t1, t2) \
 	movdqa x0,		t2; \
-	unpcklps x1,		t1; \
-	unpckhps x1,		t2; \
-	movdqa t3,		x1; \
-	unpckhps x3,		x2; \
-	movdqa t1,		x0; \
-	movhlps t1,		x1; \
-	movdqa t2,		t1; \
-	movlhps t3,		x0; \
-	movlhps x2,		t1; \
-	movhlps t2,		x2; \
-	movdqa x2,		x3; \
-	movdqa t1,		x2;
+	punpckldq x1,		x0; \
+	punpckhdq x1,		t2; \
+	movdqa x2,		t1; \
+	punpckhdq x3,		x2; \
+	punpckldq x3,		t1; \
+	movdqa x0,		x1; \
+	punpcklqdq t1,		x0; \
+	punpckhqdq t1,		x1; \
+	movdqa t2,		x3; \
+	punpcklqdq x2,		t2; \
+	punpckhqdq x2,		x3; \
+	movdqa t2,		x2;
 
 #define read_blocks(in, x0, x1, x2, x3, t0, t1, t2) \
 	movdqu (0*4*4)(in),	x0; \
diff --git a/arch/x86/crypto/serpent-sse2-x86_64-asm_64.S b/arch/x86/crypto/serpent-sse2-x86_64-asm_64.S
index 7f24a15..3ee1ff0 100644
--- a/arch/x86/crypto/serpent-sse2-x86_64-asm_64.S
+++ b/arch/x86/crypto/serpent-sse2-x86_64-asm_64.S
@@ -585,23 +585,20 @@
 	get_key(i, 1, RK1); \
 	SBOX ## _2(x0 ## 2, x1 ## 2, x2 ## 2, x3 ## 2, x4 ## 2); \
 
-#define transpose_4x4(x0, x1, x2, x3, t1, t2, t3) \
-	movdqa x2,		t3; \
-	movdqa x0,		t1; \
-	unpcklps x3,		t3; \
+#define transpose_4x4(x0, x1, x2, x3, t0, t1, t2) \
 	movdqa x0,		t2; \
-	unpcklps x1,		t1; \
-	unpckhps x1,		t2; \
-	movdqa t3,		x1; \
-	unpckhps x3,		x2; \
-	movdqa t1,		x0; \
-	movhlps t1,		x1; \
-	movdqa t2,		t1; \
-	movlhps t3,		x0; \
-	movlhps x2,		t1; \
-	movhlps t2,		x2; \
-	movdqa x2,		x3; \
-	movdqa t1,		x2;
+	punpckldq x1,		x0; \
+	punpckhdq x1,		t2; \
+	movdqa x2,		t1; \
+	punpckhdq x3,		x2; \
+	punpckldq x3,		t1; \
+	movdqa x0,		x1; \
+	punpcklqdq t1,		x0; \
+	punpckhqdq t1,		x1; \
+	movdqa t2,		x3; \
+	punpcklqdq x2,		t2; \
+	punpckhqdq x2,		x3; \
+	movdqa t2,		x2;
 
 #define read_blocks(in, x0, x1, x2, x3, t0, t1, t2) \
 	movdqu (0*4*4)(in),	x0; \
