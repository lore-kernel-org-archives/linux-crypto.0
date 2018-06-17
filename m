From: efremov@linux.com
Subject: [PATCH] crypto: skcipher: remove static declaration of export function
Date: Sun, 17 Jun 2018 20:49:59 +0300
Message-ID: <20180617174959.29864-1-efremov@linux.com>
Cc: "David S. Miller" <davem@davemloft.net>,
        linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
        ldv-project@linuxtesting.org, Denis Efremov <efremov@linux.com>
To: Herbert Xu <herbert@gondor.apana.org.au>
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

The function skcipher_walk_next declared as static and marked as
EXPORT_SYMBOL. It's a bit confusing since export symbol means that
we want others to use this function. The area of visibility for such
function is its .c file and all other modules. Other *.c files of the
same module can't use it, despite all other modules can. Relying on
that such behavior was not the original intention, the patch just
removes the static keyword.

Found by Linux Driver Verification project (linuxtesting.org).

Signed-off-by: Denis Efremov <efremov@linux.com>
---
 crypto/skcipher.c                  | 4 +---
 include/crypto/internal/skcipher.h | 1 +
 2 files changed, 2 insertions(+), 3 deletions(-)

diff --git a/crypto/skcipher.c b/crypto/skcipher.c
index 0fe2a2923ad0..d28d2f2be562 100644
--- a/crypto/skcipher.c
+++ b/crypto/skcipher.c
@@ -44,8 +44,6 @@ struct skcipher_walk_buffer {
 	u8 buffer[];
 };
 
-static int skcipher_walk_next(struct skcipher_walk *walk);
-
 static inline void skcipher_unmap(struct scatter_walk *walk, void *vaddr)
 {
 	if (PageHighMem(scatterwalk_page(walk)))
@@ -335,7 +333,7 @@ static int skcipher_next_fast(struct skcipher_walk *walk)
 	return 0;
 }
 
-static int skcipher_walk_next(struct skcipher_walk *walk)
+int skcipher_walk_next(struct skcipher_walk *walk)
 {
 	unsigned int bsize;
 	unsigned int n;
diff --git a/include/crypto/internal/skcipher.h b/include/crypto/internal/skcipher.h
index e42f7063f245..8602684d912b 100644
--- a/include/crypto/internal/skcipher.h
+++ b/include/crypto/internal/skcipher.h
@@ -154,6 +154,7 @@ int skcipher_walk_aead_encrypt(struct skcipher_walk *walk,
 int skcipher_walk_aead_decrypt(struct skcipher_walk *walk,
 			       struct aead_request *req, bool atomic);
 void skcipher_walk_complete(struct skcipher_walk *walk, int err);
+int skcipher_walk_next(struct skcipher_walk *walk);
 
 static inline void ablkcipher_request_complete(struct ablkcipher_request *req,
 					       int err)
-- 
2.17.1
