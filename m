From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: [PATCH 11/16] crypto: shash - Use finup in default digest
Date: Thu, 09 Jul 2009 12:53:57 +0800
Message-ID: <E1MOldt-0005X0-EV@gondolin.me.apana.org.au>
References: <20090709045052.GA21092@gondor.apana.org.au>
To: Linux Crypto Mailing List <linux-crypto@vger.kernel.org>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from rhun.apana.org.au ([64.62.148.172]:44869 "EHLO
	arnor.apana.org.au" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1756893AbZGIEx7 (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Thu, 9 Jul 2009 00:53:59 -0400
Received: from gondolin.me.apana.org.au ([192.168.0.6])
	by arnor.apana.org.au with esmtp (Exim 4.63 #1 (Debian))
	id 1MOldt-0006Eg-Oz
	for <linux-crypto@vger.kernel.org>; Thu, 09 Jul 2009 14:53:57 +1000
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

crypto: shash - Use finup in default digest

This patch simplifies the default digest function by using finup.

Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
---

 crypto/shash.c |    3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/crypto/shash.c b/crypto/shash.c
index 3d24242..7832310 100644
--- a/crypto/shash.c
+++ b/crypto/shash.c
@@ -154,8 +154,7 @@ static int shash_digest_unaligned(struct shash_desc *desc, const u8 *data,
 				  unsigned int len, u8 *out)
 {
 	return crypto_shash_init(desc) ?:
-	       crypto_shash_update(desc, data, len) ?:
-	       crypto_shash_final(desc, out);
+	       crypto_shash_finup(desc, data, len, out);
 }
 
 int crypto_shash_digest(struct shash_desc *desc, const u8 *data,
