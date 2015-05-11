From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: [PATCH 9/24] crypto: blkcipher - Include crypto/aead.h
Date: Mon, 11 May 2015 17:47:49 +0800
Message-ID: <E1YrkJR-0001BN-AQ@gondolin.me.apana.org.au>
References: <20150511094444.GA4260@gondor.apana.org.au>
To: Linux Crypto Mailing List <linux-crypto@vger.kernel.org>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from helcar.hengli.com.au ([209.40.204.226]:56852 "EHLO
	helcar.hengli.com.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752981AbbEKJrw (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Mon, 11 May 2015 05:47:52 -0400
Received: from gondolin.me.apana.org.au ([192.168.0.6])
	by norbury.hengli.com.au with esmtp (Exim 4.80 #3 (Debian))
	id 1YrkJR-0000Fa-Ih
	for <linux-crypto@vger.kernel.org>; Mon, 11 May 2015 19:47:49 +1000
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

All users of AEAD should include crypto/aead.h instead of
include/linux/crypto.h.

Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
---

 crypto/blkcipher.c |    1 +
 1 file changed, 1 insertion(+)

diff --git a/crypto/blkcipher.c b/crypto/blkcipher.c
index 0122bec..11b9814 100644
--- a/crypto/blkcipher.c
+++ b/crypto/blkcipher.c
@@ -14,6 +14,7 @@
  *
  */
 
+#include <crypto/aead.h>
 #include <crypto/internal/skcipher.h>
 #include <crypto/scatterwalk.h>
 #include <linux/errno.h>
