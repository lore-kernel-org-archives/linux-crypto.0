From: Harald Welte <HaraldWelte@viatech.com>
Subject: [PATCH] Enable VIA PadLock on x86_64
Date: Mon, 11 May 2009 00:03:41 +0800
Message-ID: <20090510160341.GH12152@prithivi.gnumonks.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: herbert@gondor.apana.org.au
To: linux-crypto@vger.kernel.org
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from ganesha.gnumonks.org ([213.95.27.120]:48522 "EHLO
	ganesha.gnumonks.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752504AbZEJQD6 (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Sun, 10 May 2009 12:03:58 -0400
Content-Disposition: inline
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

[CRYPTO] Support VIA PadLock hardware crypto on x86-64

The VIA Nano CPU supports x86_64, so it is now wrong to assume PadLock 
would only exist on X86_32 builds.

This patch just alters Kconfig to reflect this fact, as well as a trivial
one-line fix to an assembly statement in padlock-aes.c

Signed-off-by: Harald Welte <HaraldWelte@viatech.com>

diff --git a/drivers/crypto/Kconfig b/drivers/crypto/Kconfig
index 01afd75..39eedd4 100644
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
index 3f0fdd1..d3f6e32 100644
--- a/drivers/crypto/padlock-aes.c
+++ b/drivers/crypto/padlock-aes.c
@@ -154,7 +154,11 @@ static inline void padlock_reset_key(struct cword *cword)
 	int cpu = raw_smp_processor_id();
 
 	if (cword != per_cpu(last_cword, cpu))
+#ifdef CONFIG_X86_32
 		asm volatile ("pushfl; popfl");
+#else
+		asm volatile ("pushf; popf");
+#endif
 }
 
 static inline void padlock_store_cword(struct cword *cword)

-- 
- Harald Welte <HaraldWelte@viatech.com>	    http://linux.via.com.tw/
============================================================================
VIA Open Source Liaison
