From: Valentin Rothberg <valentinrothberg@gmail.com>
Subject: [PATCH] aesni-intel_glue.c: remove unnecessary #define
Date: Tue, 21 Oct 2014 11:35:32 +0200
Message-ID: <1413884132-9776-1-git-send-email-valentinrothberg@gmail.com>
Cc: tglx@linutronix.de, linux-crypto@vger.kernel.org,
	Valentin Rothberg <valentinrothberg@gmail.com>
To: herbert@gondor.apana.org.au, davem@davemloft.net
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-wg0-f42.google.com ([74.125.82.42]:59539 "EHLO
	mail-wg0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750978AbaJUJmx (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Tue, 21 Oct 2014 05:42:53 -0400
Received: by mail-wg0-f42.google.com with SMTP id z12so868608wgg.25
        for <linux-crypto@vger.kernel.org>; Tue, 21 Oct 2014 02:42:48 -0700 (PDT)
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

The CPP identifier 'HAS_PCBC' is defined when the Kconfig
option CRYPTO_PCBC is set as 'y' or 'm', and is further
used in two ifdef blocks to conditionally compile source
code. This indirection hides the actual Kconfig dependency
and complicates readability. Moreover, it's inconsistent
with the rest of the ifdef blocks in the file, which
directly reference Kconfig options.

This patch removes 'HAS_PCBC' and replaces its occurrences
with the actual dependency on 'CRYPTO_PCBC' being set as
'y' or 'm'.

Signed-off-by: Valentin Rothberg <valentinrothberg@gmail.com>
---
 arch/x86/crypto/aesni-intel_glue.c | 8 ++------
 1 file changed, 2 insertions(+), 6 deletions(-)

diff --git a/arch/x86/crypto/aesni-intel_glue.c b/arch/x86/crypto/aesni-intel_glue.c
index a7ccd57..8279ac5 100644
--- a/arch/x86/crypto/aesni-intel_glue.c
+++ b/arch/x86/crypto/aesni-intel_glue.c
@@ -43,10 +43,6 @@
 #include <asm/crypto/glue_helper.h>
 #endif
 
-#if defined(CONFIG_CRYPTO_PCBC) || defined(CONFIG_CRYPTO_PCBC_MODULE)
-#define HAS_PCBC
-#endif
-
 /* This data is stored at the end of the crypto_tfm struct.
  * It's a type of per "session" data storage location.
  * This needs to be 16 byte aligned.
@@ -547,7 +543,7 @@ static int ablk_ctr_init(struct crypto_tfm *tfm)
 
 #endif
 
-#ifdef HAS_PCBC
+#if IS_ENABLED(CONFIG_CRYPTO_PCBC)
 static int ablk_pcbc_init(struct crypto_tfm *tfm)
 {
 	return ablk_init_common(tfm, "fpu(pcbc(__driver-aes-aesni))");
@@ -1377,7 +1373,7 @@ static struct crypto_alg aesni_algs[] = { {
 		},
 	},
 #endif
-#ifdef HAS_PCBC
+#if IS_ENABLED(CONFIG_CRYPTO_PCBC)
 }, {
 	.cra_name		= "pcbc(aes)",
 	.cra_driver_name	= "pcbc-aes-aesni",
-- 
1.9.1
