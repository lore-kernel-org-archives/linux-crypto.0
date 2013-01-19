From: Jussi Kivilinna <jussi.kivilinna@mbnet.fi>
Subject: [PATCH 11/12] crypto: x86/sha1 - assembler clean-ups: use
 ENTRY/ENDPROC
Date: Sat, 19 Jan 2013 13:39:41 +0200
Message-ID: <20130119113941.22319.80526.stgit@localhost6.localdomain6>
References: <20130119113818.22319.26924.stgit@localhost6.localdomain6>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Cc: Herbert Xu <herbert@gondor.apana.org.au>,
	"David S. Miller" <davem@davemloft.net>
To: linux-crypto@vger.kernel.org
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from sd-mail-sa-01.sanoma.fi ([158.127.18.161]:58412 "EHLO
	sd-mail-sa-01.sanoma.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751909Ab3ASLjo (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Sat, 19 Jan 2013 06:39:44 -0500
In-Reply-To: <20130119113818.22319.26924.stgit@localhost6.localdomain6>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Signed-off-by: Jussi Kivilinna <jussi.kivilinna@mbnet.fi>
---
 arch/x86/crypto/sha1_ssse3_asm.S |   10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

diff --git a/arch/x86/crypto/sha1_ssse3_asm.S b/arch/x86/crypto/sha1_ssse3_asm.S
index 49d6987..a410950 100644
--- a/arch/x86/crypto/sha1_ssse3_asm.S
+++ b/arch/x86/crypto/sha1_ssse3_asm.S
@@ -28,6 +28,8 @@
  * (at your option) any later version.
  */
 
+#include <linux/linkage.h>
+
 #define CTX	%rdi	// arg1
 #define BUF	%rsi	// arg2
 #define CNT	%rdx	// arg3
@@ -69,10 +71,8 @@
  * param: function's name
  */
 .macro SHA1_VECTOR_ASM  name
-	.global	\name
-	.type	\name, @function
-	.align 32
-\name:
+	ENTRY(\name)
+
 	push	%rbx
 	push	%rbp
 	push	%r12
@@ -106,7 +106,7 @@
 	pop	%rbx
 	ret
 
-	.size	\name, .-\name
+	ENDPROC(\name)
 .endm
 
 /*
