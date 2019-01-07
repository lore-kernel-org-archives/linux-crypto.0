Return-Path: <SRS0=b7+G=PP=vger.kernel.org=linux-crypto-owner@kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:54816 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726245AbfAGDHy (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Sun, 6 Jan 2019 22:07:54 -0500
From: Eric Biggers <ebiggers@kernel.org>
To: linux-crypto@vger.kernel.org,
        Herbert Xu <herbert@gondor.apana.org.au>
Subject: [PATCH] crypto: shash - require neither or both ->export() and ->import()
Date: Sun,  6 Jan 2019 19:07:20 -0800
Message-Id: <20190107030720.9971-1-ebiggers@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

From: Eric Biggers <ebiggers@google.com>

Prevent registering shash algorithms that implement ->export() but not
->import(), or ->import() but not ->export().  Such cases don't make
sense and could confuse the check that shash_prepare_alg() does for just
->export().

I don't believe this affects any existing algorithms; this is just
preventing future mistakes.

Signed-off-by: Eric Biggers <ebiggers@google.com>
---
 crypto/shash.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/crypto/shash.c b/crypto/shash.c
index 40311ccad3fae..2bffdecf1f837 100644
--- a/crypto/shash.c
+++ b/crypto/shash.c
@@ -472,6 +472,9 @@ static int shash_prepare_alg(struct shash_alg *alg)
 	    alg->statesize > HASH_MAX_STATESIZE)
 		return -EINVAL;
 
+	if ((alg->export && !alg->import) || (alg->import && !alg->export))
+		return -EINVAL;
+
 	base->cra_type = &crypto_shash_type;
 	base->cra_flags &= ~CRYPTO_ALG_TYPE_MASK;
 	base->cra_flags |= CRYPTO_ALG_TYPE_SHASH;
-- 
2.20.1
