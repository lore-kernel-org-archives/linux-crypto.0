From: Tudor Ambarus <tudor-dan.ambarus@nxp.com>
Subject: [PATCH 03/10] crypto: add CONFIG_ symbol for rsa helper
Date: Fri, 18 Mar 2016 20:32:00 +0200
Message-ID: <1458325927-14737-3-git-send-email-tudor-dan.ambarus@nxp.com>
References: <1458325927-14737-1-git-send-email-tudor-dan.ambarus@nxp.com>
Mime-Version: 1.0
Content-Type: text/plain
Cc: <linux-crypto@vger.kernel.org>, <smueller@chronox.de>,
	<horia.geanta@nxp.com>, Tudor Ambarus <tudor-dan.ambarus@nxp.com>
To: <herbert@gondor.apana.org.au>, <tadeusz.struk@intel.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-bn1bon0075.outbound.protection.outlook.com ([157.56.111.75]:23866
	"EHLO na01-bn1-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1750994AbcCRSsE (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Fri, 18 Mar 2016 14:48:04 -0400
In-Reply-To: <1458325927-14737-1-git-send-email-tudor-dan.ambarus@nxp.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

All RSA implementations can now use the key extract symbols
by selecting CRYPTO_RSA_HELPER.

Signed-off-by: Tudor Ambarus <tudor-dan.ambarus@nxp.com>
---
 crypto/Kconfig  | 8 ++++++--
 crypto/Makefile | 6 +++---
 2 files changed, 9 insertions(+), 5 deletions(-)

diff --git a/crypto/Kconfig b/crypto/Kconfig
index f6bfdda..2bdf882 100644
--- a/crypto/Kconfig
+++ b/crypto/Kconfig
@@ -93,11 +93,15 @@ config CRYPTO_AKCIPHER
 	select CRYPTO_AKCIPHER2
 	select CRYPTO_ALGAPI
 
-config CRYPTO_RSA
-	tristate "RSA algorithm"
+config CRYPTO_RSA_HELPER
+	bool "RSA key extract helper"
 	select CRYPTO_AKCIPHER
 	select MPILIB
 	select ASN1
+
+config CRYPTO_RSA
+	tristate "RSA algorithm"
+	select CRYPTO_RSA_HELPER
 	help
 	  Generic implementation of the RSA public key algorithm.
 
diff --git a/crypto/Makefile b/crypto/Makefile
index 4f4ef7e..d336d83 100644
--- a/crypto/Makefile
+++ b/crypto/Makefile
@@ -36,10 +36,10 @@ $(obj)/rsaprivkey-asn1.o: $(obj)/rsaprivkey-asn1.c $(obj)/rsaprivkey-asn1.h
 clean-files += rsapubkey-asn1.c rsapubkey-asn1.h
 clean-files += rsaprivkey-asn1.c rsaprivkey-asn1.h
 
-rsa_generic-y := rsapubkey-asn1.o
-rsa_generic-y += rsaprivkey-asn1.o
+crypto_rsa_helper-y += rsapubkey-asn1.o rsaprivkey-asn1.o rsa_helper.o
+obj-$(CONFIG_CRYPTO_RSA_HELPER) += crypto_rsa_helper.o
+
 rsa_generic-y += rsa.o
-rsa_generic-y += rsa_helper.o
 rsa_generic-y += rsa-pkcs1pad.o
 obj-$(CONFIG_CRYPTO_RSA) += rsa_generic.o
 
-- 
1.8.3.1
