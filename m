Authentication-Results: smtp.subspace.kernel.org; dkim=none
Received: from abb.hmeau.com (abb.hmeau.com [144.6.53.87])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 18B281B3
	for <linux-crypto@vger.kernel.org>; Thu, 30 Nov 2023 04:28:01 -0800 (PST)
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.94.2 #2 (Debian))
	id 1r8g96-005IJp-Nl; Thu, 30 Nov 2023 20:27:57 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Thu, 30 Nov 2023 20:28:05 +0800
From: "Herbert Xu" <herbert@gondor.apana.org.au>
Date: Thu, 30 Nov 2023 20:28:05 +0800
Subject: [PATCH 8/19] crypto: ccp - Remove cfb and ofb
References: <ZWh/nV+g46zhURa9@gondor.apana.org.au>
To: Linux Crypto Mailing List <linux-crypto@vger.kernel.org>
Message-Id: <E1r8g96-005IJp-Nl@formenos.hmeau.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>

Remove the unused CFB/OFB implementation.

Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
---

 drivers/crypto/ccp/ccp-crypto-aes.c |   18 ------------------
 1 file changed, 18 deletions(-)

diff --git a/drivers/crypto/ccp/ccp-crypto-aes.c b/drivers/crypto/ccp/ccp-crypto-aes.c
index 918e223f21b6..d11daaf47f06 100644
--- a/drivers/crypto/ccp/ccp-crypto-aes.c
+++ b/drivers/crypto/ccp/ccp-crypto-aes.c
@@ -266,24 +266,6 @@ static struct ccp_aes_def aes_algs[] = {
 		.ivsize		= AES_BLOCK_SIZE,
 		.alg_defaults	= &ccp_aes_defaults,
 	},
-	{
-		.mode		= CCP_AES_MODE_CFB,
-		.version	= CCP_VERSION(3, 0),
-		.name		= "cfb(aes)",
-		.driver_name	= "cfb-aes-ccp",
-		.blocksize	= 1,
-		.ivsize		= AES_BLOCK_SIZE,
-		.alg_defaults	= &ccp_aes_defaults,
-	},
-	{
-		.mode		= CCP_AES_MODE_OFB,
-		.version	= CCP_VERSION(3, 0),
-		.name		= "ofb(aes)",
-		.driver_name	= "ofb-aes-ccp",
-		.blocksize	= 1,
-		.ivsize		= AES_BLOCK_SIZE,
-		.alg_defaults	= &ccp_aes_defaults,
-	},
 	{
 		.mode		= CCP_AES_MODE_CTR,
 		.version	= CCP_VERSION(3, 0),
