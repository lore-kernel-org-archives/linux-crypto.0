From: Ondrej Mosnacek <omosnacek@gmail.com>
Subject: [PATCH] crypto: skcipher - Fix skcipher_walk_aead_common
Date: Thu, 23 Nov 2017 13:49:06 +0100
Message-ID: <20171123124906.15754-1-omosnacek@gmail.com>
Cc: Ondrej Mosnacek <omosnacek@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        linux-crypto@vger.kernel.org, stable@vger.kernel.org
To: Herbert Xu <herbert@gondor.apana.org.au>
Return-path: <stable-owner@vger.kernel.org>
Sender: stable-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

The skcipher_walk_aead_common function calls scatterwalk_copychunks on
the input and output walks to skip the associated data. If the AD end
at an SG list entry boundary, then after these calls the walks will
still be pointing to the end of the skipped region.

These offsets are later checked for alignment in skcipher_walk_next,
so the skcipher_walk may detect the alignment incorrectly.

This patch fixes it by calling scatterwalk_done after the copychunks
calls to ensure that the offsets refer to the right SG list entry.

Fixes: b286d8b1a690 ("crypto: skcipher - Add skcipher walk interface")
Cc: <stable@vger.kernel.org>
Signed-off-by: Ondrej Mosnacek <omosnacek@gmail.com>
---
 crypto/skcipher.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/crypto/skcipher.c b/crypto/skcipher.c
index 4faa0fd53b0c..6c45ed536664 100644
--- a/crypto/skcipher.c
+++ b/crypto/skcipher.c
@@ -517,6 +517,9 @@ static int skcipher_walk_aead_common(struct skcipher_walk *walk,
 	scatterwalk_copychunks(NULL, &walk->in, req->assoclen, 2);
 	scatterwalk_copychunks(NULL, &walk->out, req->assoclen, 2);
 
+	scatterwalk_done(&walk->in, 0, walk->total);
+	scatterwalk_done(&walk->out, 0, walk->total);
+
 	walk->iv = req->iv;
 	walk->oiv = req->iv;
 
-- 
2.14.1
