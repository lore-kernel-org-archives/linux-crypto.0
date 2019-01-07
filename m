Return-Path: <SRS0=b7+G=PP=vger.kernel.org=linux-crypto-owner@kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:55186 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726245AbfAGDIY (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Sun, 6 Jan 2019 22:08:24 -0500
From: Eric Biggers <ebiggers@kernel.org>
To: linux-crypto@vger.kernel.org,
        Herbert Xu <herbert@gondor.apana.org.au>
Subject: [PATCH] crypto: shash - remove pointless checks of shash_alg::{export,import}
Date: Sun,  6 Jan 2019 19:08:01 -0800
Message-Id: <20190107030801.10096-1-ebiggers@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

From: Eric Biggers <ebiggers@google.com>

crypto_init_shash_ops_async() only gives the ahash tfm non-NULL
->export() and ->import() if the underlying shash alg has these
non-NULL.  This doesn't make sense because when an shash algorithm is
registered, shash_prepare_alg() sets a default ->export() and ->import()
if the implementor didn't provide them.  And elsewhere it's assumed that
all shash algs and ahash tfms have non-NULL ->export() and ->import().

Therefore, remove these unnecessary, always-true conditions.

Signed-off-by: Eric Biggers <ebiggers@google.com>
---
 crypto/shash.c | 6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)

diff --git a/crypto/shash.c b/crypto/shash.c
index 2bffdecf1f837..15b369c4745f6 100644
--- a/crypto/shash.c
+++ b/crypto/shash.c
@@ -388,10 +388,8 @@ int crypto_init_shash_ops_async(struct crypto_tfm *tfm)
 	crypto_ahash_set_flags(crt, crypto_shash_get_flags(shash) &
 				    CRYPTO_TFM_NEED_KEY);
 
-	if (alg->export)
-		crt->export = shash_async_export;
-	if (alg->import)
-		crt->import = shash_async_import;
+	crt->export = shash_async_export;
+	crt->import = shash_async_import;
 
 	crt->reqsize = sizeof(struct shash_desc) + crypto_shash_descsize(shash);
 
-- 
2.20.1
