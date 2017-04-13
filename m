From: Christophe JAILLET <christophe.jaillet@wanadoo.fr>
Subject: [PATCH 2/2] crypto: chcr - Fix error checking
Date: Thu, 13 Apr 2017 14:14:30 +0200
Message-ID: <a0f6ad87c1b9e04304e2ff4b4ddad92e7415f21f.1492085165.git.christophe.jaillet@wanadoo.fr>
References: <cover.1492085165.git.christophe.jaillet@wanadoo.fr>
Cc: linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
        kernel-janitors@vger.kernel.org,
        Christophe JAILLET <christophe.jaillet@wanadoo.fr>
To: herbert@gondor.apana.org.au, davem@davemloft.net,
        harsh@chelsio.com, hariprasad@chelsio.com
Return-path: <kernel-janitors-owner@vger.kernel.org>
In-Reply-To: <cover.1492085165.git.christophe.jaillet@wanadoo.fr>
Sender: kernel-janitors-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

If 'chcr_alloc_shash()' a few lines above fails, 'base_hash' can be an
error pointer when we 'goto out'.
So checking for NULL here is not enough because it is likely that
'chcr_free_shash' will crash if we pass an error pointer.

Signed-off-by: Christophe JAILLET <christophe.jaillet@wanadoo.fr>
---
Another solution, amybe safer, would be to instrument 'chcr_free_shash' or
'crypto_free_shash' to accept an error pointer and return immediatelly in
such a case.
---
 drivers/crypto/chelsio/chcr_algo.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/crypto/chelsio/chcr_algo.c b/drivers/crypto/chelsio/chcr_algo.c
index f19590ac8775..41750b97f43c 100644
--- a/drivers/crypto/chelsio/chcr_algo.c
+++ b/drivers/crypto/chelsio/chcr_algo.c
@@ -2351,7 +2351,7 @@ static int chcr_authenc_setkey(struct crypto_aead *authenc, const u8 *key,
 	}
 out:
 	aeadctx->enckey_len = 0;
-	if (base_hash)
+	if (!IS_ERR_OR_NULL(base_hash))
 		chcr_free_shash(base_hash);
 	return -EINVAL;
 }
-- 
2.11.0

