From: Sebastian Andrzej Siewior <sebastian@breakpoint.cc>
Subject: [PATCH 2/2] crypto/padlock: enable on x86_64
Date: Sat, 14 Mar 2009 12:24:03 +0100
Message-ID: <1237029843-28076-3-git-send-email-sebastian@breakpoint.cc>
References: <49B83002.9040705@tobiasvolk.de>
Cc: tglx@linutronix.de, mingo@redhat.com, hpa@zytor.com,
	linux-kernel@vger.kernel.org, herbert@gondor.apana.org.au,
	mail@tobiasvolk.de,
	Sebastian Andrzej Siewior <sebastian@breakpoint.cc>
To: linux-crypto@vger.kernel.org
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from Chamillionaire.breakpoint.cc ([85.10.199.196]:60025 "EHLO
	Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752990AbZCNLYI (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Sat, 14 Mar 2009 07:24:08 -0400
In-Reply-To: <49B83002.9040705@tobiasvolk.de>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

almost everything stays the same, we need just to use the extended registers
on the bit variant.

Signed-off-by: Sebastian Andrzej Siewior <sebastian@breakpoint.cc>
---
 drivers/crypto/Kconfig       |    2 +-
 drivers/crypto/padlock-aes.c |   13 +++++++++++++
 2 files changed, 14 insertions(+), 1 deletions(-)

diff --git a/drivers/crypto/Kconfig b/drivers/crypto/Kconfig
index e522144..62ed61b 100644
--- a/drivers/crypto/Kconfig
+++ b/drivers/crypto/Kconfig
@@ -12,7 +12,7 @@ if CRYPTO_HW
 
 config CRYPTO_DEV_PADLOCK
 	tristate "Support for VIA PadLock ACE"
-	depends on X86_32 && !UML
+	depends on !UML
 	select CRYPTO_ALGAPI
 	help
 	  Some VIA processors come with an integrated crypto engine
diff --git a/drivers/crypto/padlock-aes.c b/drivers/crypto/padlock-aes.c
index 3f0fdd1..ddd27c7 100644
--- a/drivers/crypto/padlock-aes.c
+++ b/drivers/crypto/padlock-aes.c
@@ -154,7 +154,11 @@ static inline void padlock_reset_key(struct cword *cword)
 	int cpu = raw_smp_processor_id();
 
 	if (cword != per_cpu(last_cword, cpu))
+#ifndef CONFIG_X86_64
 		asm volatile ("pushfl; popfl");
+#else
+		asm volatile ("pushfq; popfq");
+#endif
 }
 
 static inline void padlock_store_cword(struct cword *cword)
@@ -208,10 +212,19 @@ static inline void padlock_xcrypt_ecb(const u8 *input, u8 *output, void *key,
 
 	asm volatile ("test $1, %%cl;"
 		      "je 1f;"
+#ifndef CONFIG_X86_64
 		      "lea -1(%%ecx), %%eax;"
 		      "mov $1, %%ecx;"
+#else
+		      "lea -1(%%rcx), %%rax;"
+		      "mov $1, %%rcx;"
+#endif
 		      ".byte 0xf3,0x0f,0xa7,0xc8;"	/* rep xcryptecb */
+#ifndef CONFIG_X86_64
 		      "mov %%eax, %%ecx;"
+#else
+		      "mov %%rax, %%rcx;"
+#endif
 		      "1:"
 		      ".byte 0xf3,0x0f,0xa7,0xc8"	/* rep xcryptecb */
 		      : "+S"(input), "+D"(output)
-- 
1.6.2

