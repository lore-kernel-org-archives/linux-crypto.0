From: Nick Desaulniers <nick.desaulniers@gmail.com>
Subject: [PATCH] crypto: blkcipher: prefer strlcpy to strncpy
Date: Mon, 28 May 2018 22:44:43 -0700
Message-ID: <1527572683-26098-1-git-send-email-nick.desaulniers@gmail.com>
Cc: Nick Desaulniers <nick.desaulniers@gmail.com>,
        linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org
To: herbert@gondor.apana.org.au, davem@davemloft.net
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

Fixes stringop-truncation warnings from gcc-8.

Signed-off-by: Nick Desaulniers <nick.desaulniers@gmail.com>
---
 crypto/ablkcipher.c | 8 ++++----
 crypto/blkcipher.c  | 4 ++--
 2 files changed, 6 insertions(+), 6 deletions(-)

diff --git a/crypto/ablkcipher.c b/crypto/ablkcipher.c
index d880a48..e38867f 100644
--- a/crypto/ablkcipher.c
+++ b/crypto/ablkcipher.c
@@ -370,8 +370,8 @@ static int crypto_ablkcipher_report(struct sk_buff *skb, struct crypto_alg *alg)
 {
 	struct crypto_report_blkcipher rblkcipher;
 
-	strncpy(rblkcipher.type, "ablkcipher", sizeof(rblkcipher.type));
-	strncpy(rblkcipher.geniv, alg->cra_ablkcipher.geniv ?: "<default>",
+	strlcpy(rblkcipher.type, "ablkcipher", sizeof(rblkcipher.type));
+	strlcpy(rblkcipher.geniv, alg->cra_ablkcipher.geniv ?: "<default>",
 		sizeof(rblkcipher.geniv));
 
 	rblkcipher.blocksize = alg->cra_blocksize;
@@ -444,8 +444,8 @@ static int crypto_givcipher_report(struct sk_buff *skb, struct crypto_alg *alg)
 {
 	struct crypto_report_blkcipher rblkcipher;
 
-	strncpy(rblkcipher.type, "givcipher", sizeof(rblkcipher.type));
-	strncpy(rblkcipher.geniv, alg->cra_ablkcipher.geniv ?: "<built-in>",
+	strlcpy(rblkcipher.type, "givcipher", sizeof(rblkcipher.type));
+	strlcpy(rblkcipher.geniv, alg->cra_ablkcipher.geniv ?: "<built-in>",
 		sizeof(rblkcipher.geniv));
 
 	rblkcipher.blocksize = alg->cra_blocksize;
diff --git a/crypto/blkcipher.c b/crypto/blkcipher.c
index 01c0d4a..ee88e48 100644
--- a/crypto/blkcipher.c
+++ b/crypto/blkcipher.c
@@ -509,8 +509,8 @@ static int crypto_blkcipher_report(struct sk_buff *skb, struct crypto_alg *alg)
 {
 	struct crypto_report_blkcipher rblkcipher;
 
-	strncpy(rblkcipher.type, "blkcipher", sizeof(rblkcipher.type));
-	strncpy(rblkcipher.geniv, alg->cra_blkcipher.geniv ?: "<default>",
+	strlcpy(rblkcipher.type, "blkcipher", sizeof(rblkcipher.type));
+	strlcpy(rblkcipher.geniv, alg->cra_blkcipher.geniv ?: "<default>",
 		sizeof(rblkcipher.geniv));
 
 	rblkcipher.blocksize = alg->cra_blocksize;
-- 
2.7.4
