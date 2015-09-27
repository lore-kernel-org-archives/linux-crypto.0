From: Geliang Tang <geliangtang@163.com>
Subject: [PATCH] crypto: blkcipher and ablkcipher should it be static
Date: Sun, 27 Sep 2015 22:47:05 +0800
Message-ID: <d1ae7b48c3c85404ceec994ab2762e947554e9eb.1443365135.git.geliangtang@163.com>
Cc: Geliang Tang <geliangtang@163.com>, linux-crypto@vger.kernel.org,
	linux-kernel@vger.kernel.org
To: Herbert Xu <herbert@gondor.apana.org.au>,
	"David S. Miller" <davem@davemloft.net>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from m50-135.163.com ([123.125.50.135]:42791 "EHLO m50-135.163.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755837AbbI0OxQ (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Sun, 27 Sep 2015 10:53:16 -0400
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Fixes the following sparse warnings:

 crypto/skcipher.c:94:5:
 warning: symbol 'crypto_init_skcipher_ops_blkcipher'
 was not declared. Should it be static?

 crypto/skcipher.c:185:5:
 warning: symbol 'crypto_init_skcipher_ops_ablkcipher'
 was not declared. Should it be static?

Signed-off-by: Geliang Tang <geliangtang@163.com>
---
 crypto/skcipher.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/crypto/skcipher.c b/crypto/skcipher.c
index dd5fc1b..7591928 100644
--- a/crypto/skcipher.c
+++ b/crypto/skcipher.c
@@ -91,7 +91,7 @@ static void crypto_exit_skcipher_ops_blkcipher(struct crypto_tfm *tfm)
 	crypto_free_blkcipher(*ctx);
 }
 
-int crypto_init_skcipher_ops_blkcipher(struct crypto_tfm *tfm)
+static int crypto_init_skcipher_ops_blkcipher(struct crypto_tfm *tfm)
 {
 	struct crypto_alg *calg = tfm->__crt_alg;
 	struct crypto_skcipher *skcipher = __crypto_skcipher_cast(tfm);
@@ -182,7 +182,7 @@ static void crypto_exit_skcipher_ops_ablkcipher(struct crypto_tfm *tfm)
 	crypto_free_ablkcipher(*ctx);
 }
 
-int crypto_init_skcipher_ops_ablkcipher(struct crypto_tfm *tfm)
+static int crypto_init_skcipher_ops_ablkcipher(struct crypto_tfm *tfm)
 {
 	struct crypto_alg *calg = tfm->__crt_alg;
 	struct crypto_skcipher *skcipher = __crypto_skcipher_cast(tfm);
-- 
2.5.0
