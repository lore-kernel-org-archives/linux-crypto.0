From: Stafford Horne <shorne@gmail.com>
Subject: [PATCH v2 1/2] crypto: Fix -Wstringop-truncation warnings
Date: Mon, 25 Jun 2018 21:45:37 +0900
Message-ID: <20180625124538.21051-2-shorne@gmail.com>
References: <20180625124538.21051-1-shorne@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Cc: Greg KH <gregkh@linuxfoundation.org>, arnd@arndb.de,
        Eric Biggers <ebiggers3@gmail.com>,
        linux-crypto@vger.kernel.org, Stafford Horne <shorne@gmail.com>,
        Max Filippov <jcmvbkbc@gmail.com>,
        Nick Desaulniers <nick.desaulniers@gmail.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>
To: LKML <linux-kernel@vger.kernel.org>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20180625124538.21051-1-shorne@gmail.com>
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
explicitly performing '\0' termination.

Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Arnd Bergmann <arnd@arndb.de>
Cc: Max Filippov <jcmvbkbc@gmail.com>
Cc: Eric Biggers <ebiggers3@gmail.com>
Cc: Nick Desaulniers <nick.desaulniers@gmail.com>
Signed-off-by: Stafford Horne <shorne@gmail.com>
---
 crypto/ablkcipher.c | 2 ++
 crypto/blkcipher.c  | 1 +
 2 files changed, 3 insertions(+)

diff --git a/crypto/ablkcipher.c b/crypto/ablkcipher.c
index d880a4897159..1edb5000d783 100644
--- a/crypto/ablkcipher.c
+++ b/crypto/ablkcipher.c
@@ -373,6 +373,7 @@ static int crypto_ablkcipher_report(struct sk_buff *skb, struct crypto_alg *alg)
 	strncpy(rblkcipher.type, "ablkcipher", sizeof(rblkcipher.type));
 	strncpy(rblkcipher.geniv, alg->cra_ablkcipher.geniv ?: "<default>",
 		sizeof(rblkcipher.geniv));
+	rblkcipher.geniv[sizeof(rblkcipher.geniv) - 1] = '\0';
 
 	rblkcipher.blocksize = alg->cra_blocksize;
 	rblkcipher.min_keysize = alg->cra_ablkcipher.min_keysize;
@@ -447,6 +448,7 @@ static int crypto_givcipher_report(struct sk_buff *skb, struct crypto_alg *alg)
 	strncpy(rblkcipher.type, "givcipher", sizeof(rblkcipher.type));
 	strncpy(rblkcipher.geniv, alg->cra_ablkcipher.geniv ?: "<built-in>",
 		sizeof(rblkcipher.geniv));
+	rblkcipher.geniv[sizeof(rblkcipher.geniv) - 1] = '\0';
 
 	rblkcipher.blocksize = alg->cra_blocksize;
 	rblkcipher.min_keysize = alg->cra_ablkcipher.min_keysize;
diff --git a/crypto/blkcipher.c b/crypto/blkcipher.c
index 01c0d4aa2563..dd4dcab3766a 100644
--- a/crypto/blkcipher.c
+++ b/crypto/blkcipher.c
@@ -512,6 +512,7 @@ static int crypto_blkcipher_report(struct sk_buff *skb, struct crypto_alg *alg)
 	strncpy(rblkcipher.type, "blkcipher", sizeof(rblkcipher.type));
 	strncpy(rblkcipher.geniv, alg->cra_blkcipher.geniv ?: "<default>",
 		sizeof(rblkcipher.geniv));
+	rblkcipher.geniv[sizeof(rblkcipher.geniv) - 1] = '\0';
 
 	rblkcipher.blocksize = alg->cra_blocksize;
 	rblkcipher.min_keysize = alg->cra_blkcipher.min_keysize;
-- 
2.17.0
