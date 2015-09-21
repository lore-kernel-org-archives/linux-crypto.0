From: Sergey Senozhatsky <sergey.senozhatsky@gmail.com>
Subject: [RFC][PATCH 5/9] crypto/842: set CRYPTO_ALG_TFM_MAY_SHARE
Date: Mon, 21 Sep 2015 22:13:45 +0900
Message-ID: <1442841229-8122-6-git-send-email-sergey.senozhatsky@gmail.com>
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
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-pa0-f42.google.com ([209.85.220.42]:34192 "EHLO
	mail-pa0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932266AbbIUNPa (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Mon, 21 Sep 2015 09:15:30 -0400
In-Reply-To: <1442841229-8122-1-git-send-email-sergey.senozhatsky@gmail.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Signed-off-by: Sergey Senozhatsky <sergey.senozhatsky@gmail.com>
---
 crypto/842.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/crypto/842.c b/crypto/842.c
index 98e387e..579be68 100644
--- a/crypto/842.c
+++ b/crypto/842.c
@@ -56,7 +56,8 @@ static struct crypto_alg alg = {
 	.cra_name		= "842",
 	.cra_driver_name	= "842-generic",
 	.cra_priority		= 100,
-	.cra_flags		= CRYPTO_ALG_TYPE_COMPRESS,
+	.cra_flags		= CRYPTO_ALG_TYPE_COMPRESS |
+		CRYPTO_ALG_TFM_MAY_SHARE,
 	.cra_ctxsize		= sizeof(struct crypto842_ctx),
 	.cra_module		= THIS_MODULE,
 	.cra_u			= { .compress = {
-- 
2.6.0.rc2.10.gf4d9753
