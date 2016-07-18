From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: [PATCH] crypto: testmgr - Print akcipher algorithm name
Date: Mon, 18 Jul 2016 18:20:10 +0800
Message-ID: <20160718102010.GA13711@gondor.apana.org.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
To: Linux Crypto Mailing List <linux-crypto@vger.kernel.org>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from helcar.hengli.com.au ([209.40.204.226]:36035 "EHLO
	helcar.hengli.com.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751459AbcGRKUT (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Mon, 18 Jul 2016 06:20:19 -0400
Content-Disposition: inline
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

When an akcipher test fails, we don't know which algorithm failed
because the name is not printed.  This patch fixes this.

Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>

diff --git a/crypto/testmgr.c b/crypto/testmgr.c
index 769cc2a..5c9d5a5 100644
--- a/crypto/testmgr.c
+++ b/crypto/testmgr.c
@@ -2034,6 +2034,8 @@ free_xbuf:
 static int test_akcipher(struct crypto_akcipher *tfm, const char *alg,
 			 struct akcipher_testvec *vecs, unsigned int tcount)
 {
+	const char *algo =
+		crypto_tfm_alg_driver_name(crypto_akcipher_tfm(tfm));
 	int ret, i;
 
 	for (i = 0; i < tcount; i++) {
@@ -2041,8 +2043,8 @@ static int test_akcipher(struct crypto_akcipher *tfm, const char *alg,
 		if (!ret)
 			continue;
 
-		pr_err("alg: akcipher: test failed on vector %d, err=%d\n",
-		       i + 1, ret);
+		pr_err("alg: akcipher: test %d failed for %s, err=%d\n",
+		       i + 1, algo, ret);
 		return ret;
 	}
 	return 0;
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
