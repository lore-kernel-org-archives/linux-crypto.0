Return-Path: <SRS0=ZXsK=OT=vger.kernel.org=linux-crypto-owner@kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:54984 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726962AbeLJTty (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 10 Dec 2018 14:49:54 -0500
From: Eric Biggers <ebiggers@kernel.org>
To: linux-crypto@vger.kernel.org,
        Herbert Xu <herbert@gondor.apana.org.au>
Cc: PanBian <bianpan2016@163.com>
Subject: [PATCH] crypto: adiantum - fix leaking reference to hash algorithm
Date: Mon, 10 Dec 2018 11:45:58 -0800
Message-Id: <20181210194558.106364-1-ebiggers@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

From: Eric Biggers <ebiggers@google.com>

crypto_alg_mod_lookup() takes a reference to the hash algorithm but
crypto_init_shash_spawn() doesn't take ownership of it, hence the
reference needs to be dropped in adiantum_create().

Fixes: 059c2a4d8e16 ("crypto: adiantum - add Adiantum support")
Signed-off-by: Eric Biggers <ebiggers@google.com>
---
 crypto/adiantum.c | 9 +++++----
 1 file changed, 5 insertions(+), 4 deletions(-)

diff --git a/crypto/adiantum.c b/crypto/adiantum.c
index e62e34f5e389b..6651e713c45d6 100644
--- a/crypto/adiantum.c
+++ b/crypto/adiantum.c
@@ -564,10 +564,8 @@ static int adiantum_create(struct crypto_template *tmpl, struct rtattr **tb)
 	hash_alg = __crypto_shash_alg(_hash_alg);
 	err = crypto_init_shash_spawn(&ictx->hash_spawn, hash_alg,
 				      skcipher_crypto_instance(inst));
-	if (err) {
-		crypto_mod_put(_hash_alg);
-		goto out_drop_blockcipher;
-	}
+	if (err)
+		goto out_put_hash;
 
 	/* Check the set of algorithms */
 	if (!adiantum_supported_algorithms(streamcipher_alg, blockcipher_alg,
@@ -624,10 +622,13 @@ static int adiantum_create(struct crypto_template *tmpl, struct rtattr **tb)
 	if (err)
 		goto out_drop_hash;
 
+	crypto_mod_put(_hash_alg);
 	return 0;
 
 out_drop_hash:
 	crypto_drop_shash(&ictx->hash_spawn);
+out_put_hash:
+	crypto_mod_put(_hash_alg);
 out_drop_blockcipher:
 	crypto_drop_spawn(&ictx->blockcipher_spawn);
 out_drop_streamcipher:
-- 
2.20.0.rc2.403.gdbc3b29805-goog
