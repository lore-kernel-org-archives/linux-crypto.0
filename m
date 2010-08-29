From: Chuck Ebbert <cebbert@redhat.com>
Subject: [PATCH] crypto: FIPS requires algorithm self-tests
Date: Sun, 29 Aug 2010 17:47:56 -0400
Message-ID: <20100829174756.12637b28@katamari>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Cc: linux-crypto@vger.kernel.org
To: Herbert Xu <herbert@gondor.hengli.com.au>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:49051 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750986Ab0H2VuC (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Sun, 29 Aug 2010 17:50:02 -0400
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

crypto: FIPS requires algorithm self-tests

Signed-off-by: Chuck Ebbert <cebbert@redhat.com>
---

Patch is against the latest cryptodev tree.

--- vanilla-2.6.36-rc2-git5.orig/crypto/Kconfig
+++ vanilla-2.6.36-rc2-git5/crypto/Kconfig
@@ -23,13 +23,12 @@ comment "Crypto core or helper"
 
 config CRYPTO_FIPS
 	bool "FIPS 200 compliance"
-	depends on CRYPTO_ANSI_CPRNG
+	depends on CRYPTO_ANSI_CPRNG && !CRYPTO_MANAGER_DISABLE_TESTS
 	help
 	  This options enables the fips boot option which is
 	  required if you want to system to operate in a FIPS 200
 	  certification.  You should say no unless you know what
-	  this is. Note that CRYPTO_ANSI_CPRNG is required if this
-	  option is selected
+	  this is.
 
 config CRYPTO_ALGAPI
 	tristate
