From: Jussi Kivilinna <jussi.kivilinna@mbnet.fi>
Subject: [PATCH 11/11] crypto: move arch/x86/include/asm/aes.h to
 arch/x86/include/asm/crypto/
Date: Mon, 18 Jun 2012 14:07:50 +0300
Message-ID: <20120618110750.28985.14539.stgit@localhost6.localdomain6>
References: <20120618110652.28985.70075.stgit@localhost6.localdomain6>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Cc: Herbert Xu <herbert@gondor.apana.org.au>,
	"David S. Miller" <davem@davemloft.net>
To: linux-crypto@vger.kernel.org
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from sd-mail-sa-01.sanoma.fi ([158.127.18.161]:60123 "EHLO
	sd-mail-sa-01.sanoma.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750802Ab2FRLHw (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Mon, 18 Jun 2012 07:07:52 -0400
In-Reply-To: <20120618110652.28985.70075.stgit@localhost6.localdomain6>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Move AES header to the new asm/crypto directory.

Signed-off-by: Jussi Kivilinna <jussi.kivilinna@mbnet.fi>
---
 arch/x86/crypto/aes_glue.c         |    2 +-
 arch/x86/crypto/aesni-intel_glue.c |    2 +-
 arch/x86/include/asm/aes.h         |   11 -----------
 arch/x86/include/asm/crypto/aes.h  |   11 +++++++++++
 4 files changed, 13 insertions(+), 13 deletions(-)
 delete mode 100644 arch/x86/include/asm/aes.h
 create mode 100644 arch/x86/include/asm/crypto/aes.h

diff --git a/arch/x86/crypto/aes_glue.c b/arch/x86/crypto/aes_glue.c
index 8efcf42..59b37de 100644
--- a/arch/x86/crypto/aes_glue.c
+++ b/arch/x86/crypto/aes_glue.c
@@ -5,7 +5,7 @@
 
 #include <linux/module.h>
 #include <crypto/aes.h>
-#include <asm/aes.h>
+#include <asm/crypto/aes.h>
 
 asmlinkage void aes_enc_blk(struct crypto_aes_ctx *ctx, u8 *out, const u8 *in);
 asmlinkage void aes_dec_blk(struct crypto_aes_ctx *ctx, u8 *out, const u8 *in);
diff --git a/arch/x86/crypto/aesni-intel_glue.c b/arch/x86/crypto/aesni-intel_glue.c
index 7c9d54d8..d662615 100644
--- a/arch/x86/crypto/aesni-intel_glue.c
+++ b/arch/x86/crypto/aesni-intel_glue.c
@@ -30,7 +30,7 @@
 #include <crypto/ctr.h>
 #include <asm/cpu_device_id.h>
 #include <asm/i387.h>
-#include <asm/aes.h>
+#include <asm/crypto/aes.h>
 #include <asm/crypto/ablk_helper.h>
 #include <crypto/scatterwalk.h>
 #include <crypto/internal/aead.h>
diff --git a/arch/x86/include/asm/aes.h b/arch/x86/include/asm/aes.h
deleted file mode 100644
index 80545a1..0000000
--- a/arch/x86/include/asm/aes.h
+++ /dev/null
@@ -1,11 +0,0 @@
-#ifndef ASM_X86_AES_H
-#define ASM_X86_AES_H
-
-#include <linux/crypto.h>
-#include <crypto/aes.h>
-
-void crypto_aes_encrypt_x86(struct crypto_aes_ctx *ctx, u8 *dst,
-			    const u8 *src);
-void crypto_aes_decrypt_x86(struct crypto_aes_ctx *ctx, u8 *dst,
-			    const u8 *src);
-#endif
diff --git a/arch/x86/include/asm/crypto/aes.h b/arch/x86/include/asm/crypto/aes.h
new file mode 100644
index 0000000..80545a1
--- /dev/null
+++ b/arch/x86/include/asm/crypto/aes.h
@@ -0,0 +1,11 @@
+#ifndef ASM_X86_AES_H
+#define ASM_X86_AES_H
+
+#include <linux/crypto.h>
+#include <crypto/aes.h>
+
+void crypto_aes_encrypt_x86(struct crypto_aes_ctx *ctx, u8 *dst,
+			    const u8 *src);
+void crypto_aes_decrypt_x86(struct crypto_aes_ctx *ctx, u8 *dst,
+			    const u8 *src);
+#endif
