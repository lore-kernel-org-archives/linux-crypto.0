From: Joonsoo Kim <js1304@gmail.com>
Subject: [PATCH RFC 7/7] crypto/lzo: add CRYPTO_ALG_SCOMPRESS_DECOMP_NOCTX cra_flags
Date: Mon,  4 Jan 2016 13:46:58 +0900
Message-ID: <1451882819-2810-8-git-send-email-iamjoonsoo.kim@lge.com>
References: <1451882819-2810-1-git-send-email-iamjoonsoo.kim@lge.com>
Cc: "David S. Miller" <davem@davemloft.net>,
	Weigang Li <weigang.li@intel.com>,
	Sergey Senozhatsky <sergey.senozhatsky.work@gmail.com>,
	Minchan Kim <minchan@kernel.org>, linux-crypto@vger.kernel.org,
	linux-kernel@vger.kernel.org, Joonsoo Kim <iamjoonsoo.kim@lge.com>
To: Herbert Xu <herbert@gondor.apana.org.au>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-pf0-f179.google.com ([209.85.192.179]:36086 "EHLO
	mail-pf0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752732AbcADErk (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Sun, 3 Jan 2016 23:47:40 -0500
In-Reply-To: <1451882819-2810-1-git-send-email-iamjoonsoo.kim@lge.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Signed-off-by: Joonsoo Kim <iamjoonsoo.kim@lge.com>
---
 crypto/lzo.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/crypto/lzo.c b/crypto/lzo.c
index 47998e9..90afbf9 100644
--- a/crypto/lzo.c
+++ b/crypto/lzo.c
@@ -142,7 +142,8 @@ static struct scomp_alg scomp = {
 	.base			= {
 		.cra_name	= "lzo",
 		.cra_driver_name= "lzo-scomp",
-		.cra_flags	= CRYPTO_ALG_TYPE_SCOMPRESS,
+		.cra_flags	= CRYPTO_ALG_TYPE_SCOMPRESS |
+					CRYPTO_ALG_SCOMPRESS_DECOMP_NOCTX,
 		.cra_module	= THIS_MODULE,
 	}
 };
-- 
1.9.1
