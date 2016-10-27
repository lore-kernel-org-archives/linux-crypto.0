From: Andrey Ryabinin <aryabinin@virtuozzo.com>
Subject: [PATCH stable 3.10.y 08/18] crypto: algif_skcipher - Add key check exception for cipher_null
Date: Thu, 27 Oct 2016 17:29:41 +0300
Message-ID: <1477578591-28924-9-git-send-email-aryabinin@virtuozzo.com>
References: <1477578591-28924-1-git-send-email-aryabinin@virtuozzo.com>
Mime-Version: 1.0
Content-Type: text/plain
Cc: Herbert Xu <herbert@gondor.apana.org.au>,
        <linux-crypto@vger.kernel.org>,
        Andrey Ryabinin <aryabinin@virtuozzo.com>
To: Willy Tarreau <w@1wt.eu>, <stable@vger.kernel.org>
Return-path: <stable-owner@vger.kernel.org>
In-Reply-To: <1477578591-28924-1-git-send-email-aryabinin@virtuozzo.com>
Sender: stable-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

From: Herbert Xu <herbert@gondor.apana.org.au>

commit 6e8d8ecf438792ecf7a3207488fb4eebc4edb040 upstream.

This patch adds an exception to the key check so that cipher_null
users may continue to use algif_skcipher without setting a key.

Cc: stable@vger.kernel.org
Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
Signed-off-by: Andrey Ryabinin <aryabinin@virtuozzo.com>
---
 crypto/algif_skcipher.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/crypto/algif_skcipher.c b/crypto/algif_skcipher.c
index db5f0f0..4677a45 100644
--- a/crypto/algif_skcipher.c
+++ b/crypto/algif_skcipher.c
@@ -759,7 +759,7 @@ static int skcipher_accept_parent(void *private, struct sock *sk)
 {
 	struct skcipher_tfm *tfm = private;
 
-	if (!tfm->has_key)
+	if (!tfm->has_key && crypto_ablkcipher_has_setkey(tfm->skcipher))
 		return -ENOKEY;
 
 	return skcipher_accept_parent_common(private, sk);
-- 
2.7.3
