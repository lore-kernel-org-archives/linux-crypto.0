From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: [PATCH 4/6] crypto: tcrypt - Include linux/fips.h for fips_enabled
Date: Wed, 22 Apr 2015 13:25:57 +0800
Message-ID: <E1YknAb-0001zh-4k@gondolin.me.apana.org.au>
References: <20150422052452.GA7553@gondor.apana.org.au>
To: Linux Crypto Mailing List <linux-crypto@vger.kernel.org>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from helcar.hengli.com.au ([209.40.204.226]:59938 "EHLO
	helcar.hengli.com.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757349AbbDVFZ7 (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Wed, 22 Apr 2015 01:25:59 -0400
Received: from gondolin.me.apana.org.au ([192.168.0.6])
	by norbury.hengli.com.au with esmtp (Exim 4.80 #3 (Debian))
	id 1YknAb-0005SM-9W
	for <linux-crypto@vger.kernel.org>; Wed, 22 Apr 2015 15:25:57 +1000
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

All users of fips_enabled should include linux/fips.h directly
instead of getting it through internal.h which is reserved for
internal crypto API implementors.

Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
---

 crypto/tcrypt.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/crypto/tcrypt.c b/crypto/tcrypt.c
index bf41c34..22cdd61 100644
--- a/crypto/tcrypt.c
+++ b/crypto/tcrypt.c
@@ -24,6 +24,7 @@
 
 #include <crypto/hash.h>
 #include <linux/err.h>
+#include <linux/fips.h>
 #include <linux/init.h>
 #include <linux/gfp.h>
 #include <linux/module.h>
@@ -34,7 +35,6 @@
 #include <linux/timex.h>
 #include <linux/interrupt.h>
 #include "tcrypt.h"
-#include "internal.h"
 
 /*
  * Need slab memory for testing (size in number of pages).
