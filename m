From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: [CRYPTO] tcrpyt: Get rid of change log in source
Date: Wed, 7 May 2008 22:21:39 +0800
Message-ID: <20080507142139.GB27932@gondor.apana.org.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
To: Linux Crypto Mailing List <linux-crypto@vger.kernel.org>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from rhun.apana.org.au ([64.62.148.172]:54498 "EHLO
	arnor.apana.org.au" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1755632AbYEGOVl (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Wed, 7 May 2008 10:21:41 -0400
Received: from gondolin.me.apana.org.au ([192.168.0.6] ident=mail)
	by arnor.apana.org.au with esmtp (Exim 4.63 #1 (Debian))
	id 1JtkWZ-0005kF-Lm
	for <linux-crypto@vger.kernel.org>; Thu, 08 May 2008 00:21:39 +1000
Received: from herbert by gondolin.me.apana.org.au with local (Exim 3.36 #1 (Debian))
	id 1JtkWZ-0007HL-00
	for <linux-crypto@vger.kernel.org>; Wed, 07 May 2008 22:21:39 +0800
Content-Disposition: inline
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Hi:

Before tcrypt drowns in change logs, let's get rid of them once
and for all.

commit 4e96a5d13beb851e6e00baec5c3a9eddcc03a2ac
Author: Herbert Xu <herbert@gondor.apana.org.au>
Date:   Wed May 7 22:19:38 2008 +0800

    [CRYPTO] tcrpyt: Get rid of change log in source
    
    Change logs should be kept in source control systems, not the source.
    This patch removes the change log from tcrpyt to stop people from
    extending it any more.
    
    Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>

diff --git a/crypto/tcrypt.c b/crypto/tcrypt.c
index 4d8aa2b..70f9ba7 100644
--- a/crypto/tcrypt.c
+++ b/crypto/tcrypt.c
@@ -13,14 +13,6 @@
  * Software Foundation; either version 2 of the License, or (at your option)
  * any later version.
  *
- * 2008-04-27 Added RIPEMD tests
- * 2007-11-13 Added GCM tests
- * 2007-11-13 Added AEAD support
- * 2007-11-06 Added SHA-224 and SHA-224-HMAC tests
- * 2006-12-07 Added SHA384 HMAC and SHA512 HMAC tests
- * 2004-08-09 Added cipher speed tests (Reyk Floeter <reyk@vantronix.net>)
- * 2003-09-14 Rewritten by Kartikey Mahendra Bhatt
- *
  */
 
 #include <linux/err.h>
diff --git a/crypto/tcrypt.h b/crypto/tcrypt.h
index 8906823..af91f0c 100644
--- a/crypto/tcrypt.h
+++ b/crypto/tcrypt.h
@@ -13,13 +13,6 @@
  * Software Foundation; either version 2 of the License, or (at your option)
  * any later version.
  *
- * 2008-04-27 Added RIPEMD tests
- * 2007-11-13 Added GCM tests
- * 2007-11-13 Added AEAD support
- * 2006-12-07 Added SHA384 HMAC and SHA512 HMAC tests
- * 2004-08-09 Cipher speed tests by Reyk Floeter <reyk@vantronix.net>
- * 2003-09-14 Changes by Kartikey Mahendra Bhatt
- *
  */
 #ifndef _CRYPTO_TCRYPT_H
 #define _CRYPTO_TCRYPT_H
-- 
Visit Openswan at http://www.openswan.org/
Email: Herbert Xu ~{PmV>HI~} <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
