From: efremov@linux.com
Subject: [PATCH v2] crypto: skcipher: remove the exporting of skcipher_walk_next
Date: Tue, 19 Jun 2018 23:23:57 +0300
Message-ID: <20180619202357.10805-1-efremov@linux.com>
References: <20180617174959.29864-1-efremov@linux.com>
Cc: Eric Biggers <ebiggers3@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
        ldv-project@linuxtesting.org, Denis Efremov <efremov@linux.com>
To: Herbert Xu <herbert@gondor.apana.org.au>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20180617174959.29864-1-efremov@linux.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

The function skcipher_walk_next declared as static and marked as
EXPORT_SYMBOL_GPL. It's a bit confusing for internal function to be
exported. The area of visibility for such function is its .c file
and all other modules. Other *.c files of the same module can't use it,
despite all other modules can. Relying on the fact that this is the
internal function and it's not a crucial part of the API, the patch
just removes the EXPORT_SYMBOL_GPL marking of skcipher_walk_next.

Found by Linux Driver Verification project (linuxtesting.org).

Signed-off-by: Denis Efremov <efremov@linux.com>
---
 crypto/skcipher.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/crypto/skcipher.c b/crypto/skcipher.c
index 0fe2a2923ad0..7d6a49fe3047 100644
--- a/crypto/skcipher.c
+++ b/crypto/skcipher.c
@@ -387,7 +387,6 @@ static int skcipher_walk_next(struct skcipher_walk *walk)
 	}
 	return err;
 }
-EXPORT_SYMBOL_GPL(skcipher_walk_next);
 
 static int skcipher_copy_iv(struct skcipher_walk *walk)
 {
-- 
2.17.1
