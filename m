From: Jean Delvare <jdelvare@suse.de>
Subject: [PATCH] RSA: Don't select non-existent symbol
Date: Thu, 22 May 2014 18:25:15 +0200
Message-ID: <20140522182515.626f0728@endymion.delvare>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Cc: Herbert Xu <herbert@gondor.apana.org.au>,
	"David S. Miller" <davem@davemloft.net>
To: linux-crypto@vger.kernel.org
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:44464 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751247AbaEVQZT (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Thu, 22 May 2014 12:25:19 -0400
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

You can select MPILIB_EXTRA all you want, it doesn't exist ;-)

Surprised kconfig doesn't complain about that...

Signed-off-by: Jean Delvare <jdelvare@suse.de>
Cc: Herbert Xu <herbert@gondor.apana.org.au>
Cc: "David S. Miller" <davem@davemloft.net>
---
 crypto/asymmetric_keys/Kconfig |    1 -
 1 file changed, 1 deletion(-)

--- linux-3.15-rc6.orig/crypto/asymmetric_keys/Kconfig	2014-03-31 05:40:15.000000000 +0200
+++ linux-3.15-rc6/crypto/asymmetric_keys/Kconfig	2014-05-22 18:17:27.988688934 +0200
@@ -22,7 +22,6 @@ config ASYMMETRIC_PUBLIC_KEY_SUBTYPE
 
 config PUBLIC_KEY_ALGO_RSA
 	tristate "RSA public-key algorithm"
-	select MPILIB_EXTRA
 	select MPILIB
 	help
 	  This option enables support for the RSA algorithm (PKCS#1, RFC3447).

-- 
Jean Delvare
SUSE L3 Support
