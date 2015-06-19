From: Tadeusz Struk <tadeusz.struk@intel.com>
Subject: [PATCH] crypto: fix invalid select for AKCIPHER
Date: Fri, 19 Jun 2015 10:27:39 -0700
Message-ID: <20150619172739.13509.80660.stgit@tstruk-mobl1>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Cc: andreas.ruprecht@fau.de, linux-crypto@vger.kernel.org,
	tadeusz.struk@intel.com
To: herbert@gondor.apana.org.au
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mga14.intel.com ([192.55.52.115]:41532 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752813AbbFSR1s (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Fri, 19 Jun 2015 13:27:48 -0400
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Should be CRYPTO_AKCIPHER instead of AKCIPHER

Reported-by: Andreas Ruprecht <andreas.ruprecht@fau.de>
Signed-off-by: Tadeusz Struk <tadeusz.struk@intel.com>
---
 crypto/Kconfig |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/crypto/Kconfig b/crypto/Kconfig
index 6c79ef0..b4cfc57 100644
--- a/crypto/Kconfig
+++ b/crypto/Kconfig
@@ -102,7 +102,7 @@ config CRYPTO_AKCIPHER
 
 config CRYPTO_RSA
 	tristate "RSA algorithm"
-	select AKCIPHER
+	select CRYPTO_AKCIPHER
 	select MPILIB
 	select ASN1
 	help
