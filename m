From: Jean Delvare <jdelvare@suse.de>
Subject: [PATCH] RSA: Don't select non-existent symbol
Date: Fri, 30 May 2014 14:02:04 +0200
Message-ID: <20140530140204.26738dbe@endymion.delvare>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Cc: Herbert Xu <herbert@gondor.apana.org.au>,
	"David S. Miller" <davem@davemloft.net>,
	Marek Vasut <marex@denx.de>
To: linux-crypto@vger.kernel.org, David Howells <dhowells@redhat.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:33577 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751782AbaE3MCI (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Fri, 30 May 2014 08:02:08 -0400
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

You can select MPILIB_EXTRA all you want, it doesn't exist ;-)

Surprised kconfig doesn't complain about that...

Signed-off-by: Jean Delvare <jdelvare@suse.de>
Acked-by: Marek Vasut <marex@denx.de>
Cc: David Howells <dhowells@redhat.com>
Cc: Herbert Xu <herbert@gondor.apana.org.au>
Cc: "David S. Miller" <davem@davemloft.net>
---
Resent with David Howells added to Cc.

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
