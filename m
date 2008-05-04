From: Adrian-Ken Rueegsegger <rueegsegger@swiss-it.ch>
Subject: [PATCH 3/3][CRYPTO] RIPEMD: add Kconfig entries for RIPEMD hash algorithms.
Date: Sun,  4 May 2008 17:03:33 +0200
Message-ID: <1209913413-8229-4-git-send-email-rueegsegger@swiss-it.ch>
References: <>
 <1209913413-8229-1-git-send-email-rueegsegger@swiss-it.ch>
 <1209913413-8229-2-git-send-email-rueegsegger@swiss-it.ch>
 <1209913413-8229-3-git-send-email-rueegsegger@swiss-it.ch>
Cc: linux-crypto@vger.kernel.org,
	Adrian-Ken Rueegsegger <rueegsegger@swiss-it.ch>
To: herbert@gondor.apana.org.au
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from zux006-004-203.adsl.green.ch ([81.6.4.203]:2530 "EHLO
	mailx.swiss-it.ch" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751966AbYEDPDk (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Sun, 4 May 2008 11:03:40 -0400
In-Reply-To: <1209913413-8229-3-git-send-email-rueegsegger@swiss-it.ch>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

This  patch adds Kconfig entries for RIPEMD-128 and
RIPEMD-160.

Signed-off-by: Adrian-Ken Rueegsegger <rueegsegger@swiss-it.ch>
---
 crypto/Kconfig |   26 ++++++++++++++++++++++++++
 1 files changed, 26 insertions(+), 0 deletions(-)

diff --git a/crypto/Kconfig b/crypto/Kconfig
index 864456c..cfc521a 100644
--- a/crypto/Kconfig
+++ b/crypto/Kconfig
@@ -241,6 +241,32 @@ config CRYPTO_MICHAEL_MIC
 	  should not be used for other purposes because of the weakness
 	  of the algorithm.
 
+config CRYPTO_RMD128
+  tristate "RIPEMD-128 digest algorithm"
+  select CRYPTO_ALGAPI
+  help
+    RIPEMD-128 (ISO/IEC 10118-3:2004).
+
+    RIPEMD-128 is a 128-bit cryptographic hash function. It should only
+    to be used as a secure replacement for RIPEMD. For other use cases
+    RIPEMD-160 should be used.
+
+    Developed by Hans Dobbertin, Antoon Bosselaers and Bart Preneel.
+    See <http://home.esat.kuleuven.be/~bosselae/ripemd160.html>
+
+config CRYPTO_RMD160
+  tristate "RIPEMD-160 digest algorithm"
+  select CRYPTO_ALGAPI
+  help
+    RIPEMD-160 (ISO/IEC 10118-3:2004).
+
+    RIPEMD-160 is a 160-bit cryptographic hash function. It is intended
+    to be used as a secure replacement for the 128-bit hash functions
+    MD4, MD5 and it's predecessor RIPEMD (not to be confused with RIPEMD-128).
+
+    Developed by Hans Dobbertin, Antoon Bosselaers and Bart Preneel.
+    See <http://home.esat.kuleuven.be/~bosselae/ripemd160.html>
+
 config CRYPTO_SHA1
 	tristate "SHA1 digest algorithm"
 	select CRYPTO_ALGAPI
-- 
1.5.2.5

