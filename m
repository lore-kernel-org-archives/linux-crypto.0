From: Stafford Horne <shorne@gmail.com>
Subject: [RFC PATCH 1/2] crypto: Fix -Wstringop-truncation warnings
Date: Sat, 23 Jun 2018 11:07:52 +0900
Message-ID: <20180623020753.27266-2-shorne@gmail.com>
References: <20180623020753.27266-1-shorne@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Cc: Greg KH <gregkh@linuxfoundation.org>, arnd@arndb.de,
        linux-crypto@vger.kernel.org, Stafford Horne <shorne@gmail.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>
To: LKML <linux-kernel@vger.kernel.org>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20180623020753.27266-1-shorne@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

As of GCC 9.0.0 the build is reporting warnings like:

    crypto/ablkcipher.c: In function ‘crypto_ablkcipher_report’:
    crypto/ablkcipher.c:374:2: warning: ‘strncpy’ specified bound 64 equals destination size [-Wstringop-truncation]
      strncpy(rblkcipher.geniv, alg->cra_ablkcipher.geniv ?: "<default>",
      ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
       sizeof(rblkcipher.geniv));
       ~~~~~~~~~~~~~~~~~~~~~~~~~

This means the strnycpy might create a non null terminated string.  Fix this by
limiting the size of the string copy to include the null terminator.

Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Arnd Bergmann <arnd@arndb.de>
Signed-off-by: Stafford Horne <shorne@gmail.com>
---
 crypto/ablkcipher.c | 4 ++--
 crypto/blkcipher.c  | 2 +-
 2 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/crypto/ablkcipher.c b/crypto/ablkcipher.c
index d880a4897159..972cd7c879f6 100644
--- a/crypto/ablkcipher.c
+++ b/crypto/ablkcipher.c
@@ -372,7 +372,7 @@ static int crypto_ablkcipher_report(struct sk_buff *skb, struct crypto_alg *alg)
 
 	strncpy(rblkcipher.type, "ablkcipher", sizeof(rblkcipher.type));
 	strncpy(rblkcipher.geniv, alg->cra_ablkcipher.geniv ?: "<default>",
-		sizeof(rblkcipher.geniv));
+		sizeof(rblkcipher.geniv) - 1);
 
 	rblkcipher.blocksize = alg->cra_blocksize;
 	rblkcipher.min_keysize = alg->cra_ablkcipher.min_keysize;
@@ -446,7 +446,7 @@ static int crypto_givcipher_report(struct sk_buff *skb, struct crypto_alg *alg)
 
 	strncpy(rblkcipher.type, "givcipher", sizeof(rblkcipher.type));
 	strncpy(rblkcipher.geniv, alg->cra_ablkcipher.geniv ?: "<built-in>",
-		sizeof(rblkcipher.geniv));
+		sizeof(rblkcipher.geniv) - 1);
 
 	rblkcipher.blocksize = alg->cra_blocksize;
 	rblkcipher.min_keysize = alg->cra_ablkcipher.min_keysize;
diff --git a/crypto/blkcipher.c b/crypto/blkcipher.c
index 01c0d4aa2563..f1644b5cf68c 100644
--- a/crypto/blkcipher.c
+++ b/crypto/blkcipher.c
@@ -511,7 +511,7 @@ static int crypto_blkcipher_report(struct sk_buff *skb, struct crypto_alg *alg)
 
 	strncpy(rblkcipher.type, "blkcipher", sizeof(rblkcipher.type));
 	strncpy(rblkcipher.geniv, alg->cra_blkcipher.geniv ?: "<default>",
-		sizeof(rblkcipher.geniv));
+		sizeof(rblkcipher.geniv) - 1);
 
 	rblkcipher.blocksize = alg->cra_blocksize;
 	rblkcipher.min_keysize = alg->cra_blkcipher.min_keysize;
-- 
2.17.0
