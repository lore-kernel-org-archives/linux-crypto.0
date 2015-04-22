From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: [PATCH 5/6] crypto: testmgr - Include linux/fips.h for fips_enabled
Date: Wed, 22 Apr 2015 13:25:58 +0800
Message-ID: <E1YknAc-0001zy-86@gondolin.me.apana.org.au>
References: <20150422052452.GA7553@gondor.apana.org.au>
To: Linux Crypto Mailing List <linux-crypto@vger.kernel.org>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from helcar.hengli.com.au ([209.40.204.226]:34448 "EHLO
	helcar.hengli.com.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757335AbbDVF0B (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Wed, 22 Apr 2015 01:26:01 -0400
Received: from gondolin.me.apana.org.au ([192.168.0.6])
	by norbury.hengli.com.au with esmtp (Exim 4.80 #3 (Debian))
	id 1YknAc-0005SV-Ca
	for <linux-crypto@vger.kernel.org>; Wed, 22 Apr 2015 15:25:58 +1000
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

All users of fips_enabled should include linux/fips.h directly
instead of getting it through internal.h.

Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
---

 crypto/testmgr.c |    1 +
 1 file changed, 1 insertion(+)

diff --git a/crypto/testmgr.c b/crypto/testmgr.c
index f9bce3d..18b7d49 100644
--- a/crypto/testmgr.c
+++ b/crypto/testmgr.c
@@ -22,6 +22,7 @@
 
 #include <crypto/hash.h>
 #include <linux/err.h>
+#include <linux/fips.h>
 #include <linux/module.h>
 #include <linux/scatterlist.h>
 #include <linux/slab.h>
