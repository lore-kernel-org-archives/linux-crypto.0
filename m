Return-Path: <SRS0=b7+G=PP=vger.kernel.org=linux-crypto-owner@kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:46496 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726176AbfAGCtk (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Sun, 6 Jan 2019 21:49:40 -0500
From: Eric Biggers <ebiggers@kernel.org>
To: linux-crypto@vger.kernel.org,
        Herbert Xu <herbert@gondor.apana.org.au>
Subject: [PATCH 3/3] crypto: aead - set CRYPTO_TFM_NEED_KEY if ->setkey() fails
Date: Sun,  6 Jan 2019 18:47:44 -0800
Message-Id: <20190107024744.4952-4-ebiggers@kernel.org>
In-Reply-To: <20190107024744.4952-1-ebiggers@kernel.org>
References: <20190107024744.4952-1-ebiggers@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

From: Eric Biggers <ebiggers@google.com>

Some algorithms have a ->setkey() method that is not atomic, in the
sense that setting a key can fail after changes were already made to the
tfm context.  In this case, if a key was already set the tfm can end up
in a state that corresponds to neither the old key nor the new key.

For example, in gcm.c, if the kzalloc() fails due to lack of memory,
then the CTR part of GCM will have the new key but GHASH will not.

It's not feasible to make all ->setkey() methods atomic, especially ones
that have to key multiple sub-tfms.  Therefore, make the crypto API set
CRYPTO_TFM_NEED_KEY if ->setkey() fails, to prevent the tfm from being
used until a new key is set.

[Cc stable mainly because when introducing the NEED_KEY flag I changed
 AF_ALG to rely on it; and unlike in-kernel crypto API users, AF_ALG
 previously didn't have this problem.  So these "incompletely keyed"
 states became theoretically accessible via AF_ALG -- though, the
 opportunities for causing real mischief seem pretty limited.]

Fixes: dc26c17f743a ("crypto: aead - prevent using AEADs without setting key")
Cc: <stable@vger.kernel.org> # v4.16+
Signed-off-by: Eric Biggers <ebiggers@google.com>
---
 crypto/aead.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/crypto/aead.c b/crypto/aead.c
index 189c52d1f63ab..4908b5e846f0e 100644
--- a/crypto/aead.c
+++ b/crypto/aead.c
@@ -61,8 +61,10 @@ int crypto_aead_setkey(struct crypto_aead *tfm,
 	else
 		err = crypto_aead_alg(tfm)->setkey(tfm, key, keylen);
 
-	if (err)
+	if (unlikely(err)) {
+		crypto_aead_set_flags(tfm, CRYPTO_TFM_NEED_KEY);
 		return err;
+	}
 
 	crypto_aead_clear_flags(tfm, CRYPTO_TFM_NEED_KEY);
 	return 0;
-- 
2.20.1
