From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: [PATCH 6/6] crypto: api - Remove linux/fips.h from internal.h
Date: Wed, 22 Apr 2015 13:25:59 +0800
Message-ID: <E1YknAd-00020G-BG@gondolin.me.apana.org.au>
References: <20150422052452.GA7553@gondor.apana.org.au>
To: Linux Crypto Mailing List <linux-crypto@vger.kernel.org>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from helcar.hengli.com.au ([209.40.204.226]:34238 "EHLO
	helcar.hengli.com.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757354AbbDVF0C (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Wed, 22 Apr 2015 01:26:02 -0400
Received: from gondolin.me.apana.org.au ([192.168.0.6])
	by norbury.hengli.com.au with esmtp (Exim 4.80 #3 (Debian))
	id 1YknAd-0005Sm-J2
	for <linux-crypto@vger.kernel.org>; Wed, 22 Apr 2015 15:25:59 +1000
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Now that all fips_enabled users are including linux/fips.h directly
instead of getting it through internal.h, we can remove the fips.h
inclusions from internal.h.

Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
---

 crypto/internal.h |    1 -
 1 file changed, 1 deletion(-)

diff --git a/crypto/internal.h b/crypto/internal.h
index ed7a70c..00e42a3 100644
--- a/crypto/internal.h
+++ b/crypto/internal.h
@@ -25,7 +25,6 @@
 #include <linux/notifier.h>
 #include <linux/rwsem.h>
 #include <linux/slab.h>
-#include <linux/fips.h>
 
 /* Crypto notification events. */
 enum {
