From: Eric Biggers <ebiggers3@gmail.com>
Subject: [RFC PATCH 2/9] crypto: cryptd - pass through absence of ->setkey()
Date: Wed,  3 Jan 2018 11:16:23 -0800
Message-ID: <20180103191630.79917-3-ebiggers3@gmail.com>
References: <20180103191630.79917-1-ebiggers3@gmail.com>
Cc: Herbert Xu <herbert@gondor.apana.org.au>,
        "David S . Miller" <davem@davemloft.net>,
        Eric Biggers <ebiggers@google.com>
To: linux-crypto@vger.kernel.org
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-io0-f195.google.com ([209.85.223.195]:37016 "EHLO
        mail-io0-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750912AbeACTS1 (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 3 Jan 2018 14:18:27 -0500
Received: by mail-io0-f195.google.com with SMTP id n14so3146825iob.4
        for <linux-crypto@vger.kernel.org>; Wed, 03 Jan 2018 11:18:26 -0800 (PST)
In-Reply-To: <20180103191630.79917-1-ebiggers3@gmail.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

From: Eric Biggers <ebiggers@google.com>

When the cryptd template is used to wrap an unkeyed hash algorithm,
don't install a ->setkey() method to the cryptd instance.  This change
is necessary for cryptd to keep working with unkeyed hash algorithms
once we start enforcing that ->setkey() is called when present.

Cc: stable@vger.kernel.org
Signed-off-by: Eric Biggers <ebiggers@google.com>
---
 crypto/cryptd.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/crypto/cryptd.c b/crypto/cryptd.c
index 552e3a86e829..457ae3e66a41 100644
--- a/crypto/cryptd.c
+++ b/crypto/cryptd.c
@@ -914,7 +914,8 @@ static int cryptd_create_hash(struct crypto_template *tmpl, struct rtattr **tb,
 	inst->alg.finup  = cryptd_hash_finup_enqueue;
 	inst->alg.export = cryptd_hash_export;
 	inst->alg.import = cryptd_hash_import;
-	inst->alg.setkey = cryptd_hash_setkey;
+	if (crypto_shash_alg_has_setkey(salg))
+		inst->alg.setkey = cryptd_hash_setkey;
 	inst->alg.digest = cryptd_hash_digest_enqueue;
 
 	err = ahash_register_instance(tmpl, inst);
-- 
2.15.1.620.gb9897f4670-goog
