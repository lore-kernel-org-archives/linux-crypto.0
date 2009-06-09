From: Chuck Ebbert <cebbert@redhat.com>
Subject: [patch 3/3] crypto: padlock-aes: enable on 64-bit kernels
Date: Tue, 9 Jun 2009 10:39:07 -0400
Message-ID: <20090609103907.1903878c@dhcp-100-2-144.bos.redhat.com>
References: <20090609103533.0c334594@dhcp-100-2-144.bos.redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Cc: Herbert Xu <herbert@gondor.apana.org.au>,
	linux-kernel@vger.kernel.org, linux-crypto@vger.kernel.org,
	Sebastian Andrzej Siewior <sebastian@breakpoint.cc>
To: Harald Welte <HaraldWelte@viatech.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mx2.redhat.com ([66.187.237.31]:48650 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750880AbZFIOkA (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Tue, 9 Jun 2009 10:40:00 -0400
In-Reply-To: <20090609103533.0c334594@dhcp-100-2-144.bos.redhat.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

From: Sebastian Andrzej Siewior <sebastian@breakpoint.cc>
crypto: padlock-aes: enable on 64-bit kernels

The only required change now is using the right push/pop instruction
on x86-64. Taken from the original patch by Sebastian Andrzej Siewior.
(Added a dependency on X86.)

Signed-off-by: Sebastian Andrzej Siewior <sebastian@breakpoint.cc>
Signed-off-by: Chuck Ebbert <cebbert@redhat.com>

diff --git a/drivers/crypto/Kconfig b/drivers/crypto/Kconfig
--- a/drivers/crypto/Kconfig
+++ b/drivers/crypto/Kconfig
@@ -12,7 +12,7 @@ if CRYPTO_HW
 
 config CRYPTO_DEV_PADLOCK
 	tristate "Support for VIA PadLock ACE"
-	depends on X86_32 && !UML
+	depends on X86 && !UML 
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
