From: Sergey Senozhatsky <sergey.senozhatsky@gmail.com>
Subject: [RFC][PATCH 3/9] crypto/lz4: set CRYPTO_ALG_TFM_MAY_SHARE
Date: Mon, 21 Sep 2015 22:13:43 +0900
Message-ID: <1442841229-8122-4-git-send-email-sergey.senozhatsky@gmail.com>
References: <1442553564-3476-1-git-send-email-iamjoonsoo.kim@lge.com>
 <1442841229-8122-1-git-send-email-sergey.senozhatsky@gmail.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
	Minchan Kim <minchan@kernel.org>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	"David S. Miller" <davem@davemloft.net>,
	Stephan Mueller <smueller@chronox.de>,
	Joonsoo Kim <iamjoonsoo.kim@lge.com>,
	Sergey Senozhatsky <sergey.senozhatsky.work@gmail.com>,
	Sergey Senozhatsky <sergey.senozhatsky@gmail.com>,
	linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org
To: Joonsoo Kim <js1304@gmail.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1442841229-8122-1-git-send-email-sergey.senozhatsky@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

Signed-off-by: Sergey Senozhatsky <sergey.senozhatsky@gmail.com>
---
 crypto/lz4.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/crypto/lz4.c b/crypto/lz4.c
index aefbcea..ca48de1 100644
--- a/crypto/lz4.c
+++ b/crypto/lz4.c
@@ -78,7 +78,8 @@ static int lz4_decompress_crypto(struct crypto_tfm *tfm, const u8 *src,
 
 static struct crypto_alg alg_lz4 = {
 	.cra_name		= "lz4",
-	.cra_flags		= CRYPTO_ALG_TYPE_COMPRESS,
+	.cra_flags		= CRYPTO_ALG_TYPE_COMPRESS |
+		CRYPTO_ALG_TFM_MAY_SHARE,
 	.cra_ctxsize		= sizeof(struct lz4_ctx),
 	.cra_module		= THIS_MODULE,
 	.cra_list		= LIST_HEAD_INIT(alg_lz4.cra_list),
-- 
2.6.0.rc2.10.gf4d9753
