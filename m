From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: [CRYPTO] api: Proc functions should be marked as unused
Date: Thu, 29 Mar 2007 17:40:13 +1000
Message-ID: <20070329074013.GA14428@gondor.apana.org.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
To: Linux Crypto Mailing List <linux-crypto@vger.kernel.org>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from rhun.apana.org.au ([64.62.148.172]:2273 "EHLO
	arnor.apana.org.au" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753301AbXC2HkR (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Thu, 29 Mar 2007 03:40:17 -0400
Received: from gondolin.me.apana.org.au ([192.168.0.6] ident=mail)
	by arnor.apana.org.au with esmtp (Exim 4.50 #1 (Debian))
	id 1HWpF0-0004Y2-8C
	for <linux-crypto@vger.kernel.org>; Thu, 29 Mar 2007 17:40:14 +1000
Received: from herbert by gondolin.me.apana.org.au with local (Exim 3.36 #1 (Debian))
	id 1HWpEz-0003kw-00
	for <linux-crypto@vger.kernel.org>; Thu, 29 Mar 2007 17:40:13 +1000
Content-Disposition: inline
Sender: linux-crypto-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

Hi:

I'm adding this patch to the cryptodev-2.6 tree.

[CRYPTO] api: Proc functions should be marked as unused

The proc functions were incorrectly marked as used rather than unused.
They may be unused if proc is disabled.

Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>

Cheers,
-- 
Visit Openswan at http://www.openswan.org/
Email: Herbert Xu ~{PmV>HI~} <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
--
diff --git a/crypto/blkcipher.c b/crypto/blkcipher.c
--- a/crypto/blkcipher.c
+++ b/crypto/blkcipher.c
@@ -386,7 +386,7 @@ static int crypto_init_blkcipher_ops(str
 }
 
 static void crypto_blkcipher_show(struct seq_file *m, struct crypto_alg *alg)
-	__attribute_used__;
+	__attribute__ ((unused));
 static void crypto_blkcipher_show(struct seq_file *m, struct crypto_alg *alg)
 {
 	seq_printf(m, "type         : blkcipher\n");
diff --git a/crypto/hash.c b/crypto/hash.c
--- a/crypto/hash.c
+++ b/crypto/hash.c
@@ -41,7 +41,7 @@ static int crypto_init_hash_ops(struct c
 }
 
 static void crypto_hash_show(struct seq_file *m, struct crypto_alg *alg)
-	__attribute_used__;
+	__attribute__ ((unused));
 static void crypto_hash_show(struct seq_file *m, struct crypto_alg *alg)
 {
 	seq_printf(m, "type         : hash\n");
