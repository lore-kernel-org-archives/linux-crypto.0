From: Jussi Kivilinna <jussi.kivilinna@mbnet.fi>
Subject: [PATCH 09/12] crypto: x86/salsa20 - assembler cleanup,
 use ENTRY/ENDPROC for assember functions and rename ECRYPT_* to
 salsa20_*
Date: Sat, 19 Jan 2013 13:39:31 +0200
Message-ID: <20130119113931.22319.23067.stgit@localhost6.localdomain6>
References: <20130119113818.22319.26924.stgit@localhost6.localdomain6>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Cc: Herbert Xu <herbert@gondor.apana.org.au>,
	"David S. Miller" <davem@davemloft.net>
To: linux-crypto@vger.kernel.org
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from sd-mail-sa-01.sanoma.fi ([158.127.18.161]:58367 "EHLO
	sd-mail-sa-01.sanoma.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751909Ab3ASLjd (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Sat, 19 Jan 2013 06:39:33 -0500
In-Reply-To: <20130119113818.22319.26924.stgit@localhost6.localdomain6>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Signed-off-by: Jussi Kivilinna <jussi.kivilinna@mbnet.fi>
---
 arch/x86/crypto/salsa20-i586-asm_32.S   |   28 ++++++++++++++--------------
 arch/x86/crypto/salsa20-x86_64-asm_64.S |   28 +++++++++++++---------------
 arch/x86/crypto/salsa20_glue.c          |    5 -----
 3 files changed, 27 insertions(+), 34 deletions(-)

diff --git a/arch/x86/crypto/salsa20-i586-asm_32.S b/arch/x86/crypto/salsa20-i586-asm_32.S
index 72eb306..329452b 100644
--- a/arch/x86/crypto/salsa20-i586-asm_32.S
+++ b/arch/x86/crypto/salsa20-i586-asm_32.S
@@ -2,11 +2,12 @@
 # D. J. Bernstein
 # Public domain.
 
-# enter ECRYPT_encrypt_bytes
+#include <linux/linkage.h>
+
 .text
-.p2align 5
-.globl ECRYPT_encrypt_bytes
-ECRYPT_encrypt_bytes:
+
+# enter salsa20_encrypt_bytes
+ENTRY(salsa20_encrypt_bytes)
 	mov	%esp,%eax
 	and	$31,%eax
 	add	$256,%eax
@@ -933,11 +934,10 @@ ECRYPT_encrypt_bytes:
 	add	$64,%esi
 	# goto bytesatleast1
 	jmp	._bytesatleast1
-# enter ECRYPT_keysetup
-.text
-.p2align 5
-.globl ECRYPT_keysetup
-ECRYPT_keysetup:
+ENDPROC(salsa20_encrypt_bytes)
+
+# enter salsa20_keysetup
+ENTRY(salsa20_keysetup)
 	mov	%esp,%eax
 	and	$31,%eax
 	add	$256,%eax
@@ -1060,11 +1060,10 @@ ECRYPT_keysetup:
 	# leave
 	add	%eax,%esp
 	ret
-# enter ECRYPT_ivsetup
-.text
-.p2align 5
-.globl ECRYPT_ivsetup
-ECRYPT_ivsetup:
+ENDPROC(salsa20_keysetup)
+
+# enter salsa20_ivsetup
+ENTRY(salsa20_ivsetup)
 	mov	%esp,%eax
 	and	$31,%eax
 	add	$256,%eax
@@ -1112,3 +1111,4 @@ ECRYPT_ivsetup:
 	# leave
 	add	%eax,%esp
 	ret
+ENDPROC(salsa20_ivsetup)
diff --git a/arch/x86/crypto/salsa20-x86_64-asm_64.S b/arch/x86/crypto/salsa20-x86_64-asm_64.S
index 6214a9b..9279e0b 100644
--- a/arch/x86/crypto/salsa20-x86_64-asm_64.S
+++ b/arch/x86/crypto/salsa20-x86_64-asm_64.S
@@ -1,8 +1,7 @@
-# enter ECRYPT_encrypt_bytes
-.text
-.p2align 5
-.globl ECRYPT_encrypt_bytes
-ECRYPT_encrypt_bytes:
+#include <linux/linkage.h>
+
+# enter salsa20_encrypt_bytes
+ENTRY(salsa20_encrypt_bytes)
 	mov	%rsp,%r11
 	and	$31,%r11
 	add	$256,%r11
@@ -802,11 +801,10 @@ ECRYPT_encrypt_bytes:
 	# comment:fp stack unchanged by jump
 	# goto bytesatleast1
 	jmp	._bytesatleast1
-# enter ECRYPT_keysetup
-.text
-.p2align 5
-.globl ECRYPT_keysetup
-ECRYPT_keysetup:
+ENDPROC(salsa20_encrypt_bytes)
+
+# enter salsa20_keysetup
+ENTRY(salsa20_keysetup)
 	mov	%rsp,%r11
 	and	$31,%r11
 	add	$256,%r11
@@ -892,11 +890,10 @@ ECRYPT_keysetup:
 	mov	%rdi,%rax
 	mov	%rsi,%rdx
 	ret
-# enter ECRYPT_ivsetup
-.text
-.p2align 5
-.globl ECRYPT_ivsetup
-ECRYPT_ivsetup:
+ENDPROC(salsa20_keysetup)
+
+# enter salsa20_ivsetup
+ENTRY(salsa20_ivsetup)
 	mov	%rsp,%r11
 	and	$31,%r11
 	add	$256,%r11
@@ -918,3 +915,4 @@ ECRYPT_ivsetup:
 	mov	%rdi,%rax
 	mov	%rsi,%rdx
 	ret
+ENDPROC(salsa20_ivsetup)
diff --git a/arch/x86/crypto/salsa20_glue.c b/arch/x86/crypto/salsa20_glue.c
index a3a3c02..5e8e677 100644
--- a/arch/x86/crypto/salsa20_glue.c
+++ b/arch/x86/crypto/salsa20_glue.c
@@ -26,11 +26,6 @@
 #define SALSA20_MIN_KEY_SIZE  16U
 #define SALSA20_MAX_KEY_SIZE  32U
 
-// use the ECRYPT_* function names
-#define salsa20_keysetup        ECRYPT_keysetup
-#define salsa20_ivsetup         ECRYPT_ivsetup
-#define salsa20_encrypt_bytes   ECRYPT_encrypt_bytes
-
 struct salsa20_ctx
 {
 	u32 input[16];
