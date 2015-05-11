From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: [PATCH 4/24] crypto: caam - Include internal/aead.h
Date: Mon, 11 May 2015 17:47:43 +0800
Message-ID: <E1YrkJL-00018k-F6@gondolin.me.apana.org.au>
References: <20150511094444.GA4260@gondor.apana.org.au>
To: Linux Crypto Mailing List <linux-crypto@vger.kernel.org>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from helcar.hengli.com.au ([209.40.204.226]:51375 "EHLO
	helcar.hengli.com.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752224AbbEKJrq (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Mon, 11 May 2015 05:47:46 -0400
Received: from gondolin.me.apana.org.au ([192.168.0.6])
	by norbury.hengli.com.au with esmtp (Exim 4.80 #3 (Debian))
	id 1YrkJL-0000Df-Kx
	for <linux-crypto@vger.kernel.org>; Mon, 11 May 2015 19:47:43 +1000
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

All AEAD implementations must include internal/aead.h in order
to access required helpers.

Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
---

 drivers/crypto/caam/compat.h |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/crypto/caam/compat.h b/drivers/crypto/caam/compat.h
index acd7743..f57f395 100644
--- a/drivers/crypto/caam/compat.h
+++ b/drivers/crypto/caam/compat.h
@@ -32,7 +32,7 @@
 #include <crypto/des.h>
 #include <crypto/sha.h>
 #include <crypto/md5.h>
-#include <crypto/aead.h>
+#include <crypto/internal/aead.h>
 #include <crypto/authenc.h>
 #include <crypto/scatterwalk.h>
 #include <crypto/internal/skcipher.h>
