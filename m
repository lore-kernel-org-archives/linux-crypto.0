From: Eric Biggers <ebiggers3@gmail.com>
Subject: [RFC PATCH 3/9] crypto: mcryptd - pass through absence of ->setkey()
Date: Wed,  3 Jan 2018 11:16:24 -0800
Message-ID: <20180103191630.79917-4-ebiggers3@gmail.com>
References: <20180103191630.79917-1-ebiggers3@gmail.com>
Cc: Herbert Xu <herbert@gondor.apana.org.au>,
        "David S . Miller" <davem@davemloft.net>,
        Eric Biggers <ebiggers@google.com>
To: linux-crypto@vger.kernel.org
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-io0-f195.google.com ([209.85.223.195]:37017 "EHLO
        mail-io0-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750831AbeACTS2 (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 3 Jan 2018 14:18:28 -0500
Received: by mail-io0-f195.google.com with SMTP id n14so3146864iob.4
        for <linux-crypto@vger.kernel.org>; Wed, 03 Jan 2018 11:18:27 -0800 (PST)
In-Reply-To: <20180103191630.79917-1-ebiggers3@gmail.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

From: Eric Biggers <ebiggers@google.com>

When the mcryptd template is used to wrap an unkeyed hash algorithm,
don't install a ->setkey() method to the mcryptd instance.  This change
is necessary for mcryptd to keep working with unkeyed hash algorithms
once we start enforcing that ->setkey() is called when present.

Cc: stable@vger.kernel.org
Signed-off-by: Eric Biggers <ebiggers@google.com>
---
 crypto/mcryptd.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/crypto/mcryptd.c b/crypto/mcryptd.c
index 2908382861ee..ace346b976b3 100644
--- a/crypto/mcryptd.c
+++ b/crypto/mcryptd.c
@@ -534,7 +534,8 @@ static int mcryptd_create_hash(struct crypto_template *tmpl, struct rtattr **tb,
 	inst->alg.finup  = mcryptd_hash_finup_enqueue;
 	inst->alg.export = mcryptd_hash_export;
 	inst->alg.import = mcryptd_hash_import;
-	inst->alg.setkey = mcryptd_hash_setkey;
+	if (crypto_hash_alg_has_setkey(halg))
+		inst->alg.setkey = mcryptd_hash_setkey;
 	inst->alg.digest = mcryptd_hash_digest_enqueue;
 
 	err = ahash_register_instance(tmpl, inst);
-- 
2.15.1.620.gb9897f4670-goog
