From: Adrian-Ken Rueegsegger <rueegsegger@swiss-it.ch>
Subject: [PATCH 5/5][CRYPTO] RIPEMD: Add Kconfig entries for extended RIPEMD hash algorithms
Date: Wed,  7 May 2008 23:58:39 +0200
Message-ID: <1210197519-18432-6-git-send-email-rueegsegger@swiss-it.ch>
References: <>
 <1210197519-18432-1-git-send-email-rueegsegger@swiss-it.ch>
 <1210197519-18432-2-git-send-email-rueegsegger@swiss-it.ch>
 <1210197519-18432-3-git-send-email-rueegsegger@swiss-it.ch>
 <1210197519-18432-4-git-send-email-rueegsegger@swiss-it.ch>
 <1210197519-18432-5-git-send-email-rueegsegger@swiss-it.ch>
Cc: linux-crypto@vger.kernel.org,
	Adrian-Ken Rueegsegger <rueegsegger@swiss-it.ch>
To: herbert@gondor.apana.org.au
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from zux006-004-203.adsl.green.ch ([81.6.4.203]:2383 "EHLO
	mailx.swiss-it.ch" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758601AbYEGV6t (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Wed, 7 May 2008 17:58:49 -0400
In-Reply-To: <1210197519-18432-5-git-send-email-rueegsegger@swiss-it.ch>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

This patch adds Kconfig entries for RIPEMD-256 and RIPEMD-320.
---
 crypto/Kconfig |   25 +++++++++++++++++++++++++
 1 files changed, 25 insertions(+), 0 deletions(-)

diff --git a/crypto/Kconfig b/crypto/Kconfig
index cfc521a..5963a95 100644
--- a/crypto/Kconfig
+++ b/crypto/Kconfig
@@ -264,6 +264,31 @@ config CRYPTO_RMD160
     to be used as a secure replacement for the 128-bit hash functions
     MD4, MD5 and it's predecessor RIPEMD (not to be confused with RIPEMD-128).
 
+    It's speed is comparable to SHA1 and there are no known attacks against
+    RIPEMD-160.
+
+    Developed by Hans Dobbertin, Antoon Bosselaers and Bart Preneel.
+    See <http://home.esat.kuleuven.be/~bosselae/ripemd160.html>
+
+config CRYPTO_RMD256
+  tristate "RIPEMD-256 digest algorithm"
+  select CRYPTO_ALGAPI
+  help
+    RIPEMD-256 is an optional extension of RIPEMD-128 with a 256 bit hash.
+    It is intended for applications that require longer hash-results, without
+    needing a larger security level (than RIPEMD-128).
+
+    Developed by Hans Dobbertin, Antoon Bosselaers and Bart Preneel.
+    See <http://home.esat.kuleuven.be/~bosselae/ripemd160.html>
+
+config CRYPTO_RMD320
+  tristate "RIPEMD-320 digest algorithm"
+  select CRYPTO_ALGAPI
+  help
+    RIPEMD-320 is an optional extension of RIPEMD-160 with a 320 bit hash.
+    It is intended for applications that require longer hash-results, without
+    needing a larger security level (than RIPEMD-160).
+
     Developed by Hans Dobbertin, Antoon Bosselaers and Bart Preneel.
     See <http://home.esat.kuleuven.be/~bosselae/ripemd160.html>
 
-- 
1.5.2.5

