From: Gary R Hook <gary.hook@amd.com>
Subject: [PATCH v2 1/4] crypto: ccp - Add a call to xts_check_key()
Date: Fri, 21 Jul 2017 14:04:45 -0500
Message-ID: <150066388557.49973.11588709638848954248.stgit@sosxen.amd.com>
References: <150066355075.49973.1565434199212056832.stgit@sosxen.amd.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Cc: thomas.lendacky@amd.com, herbert@gondor.apana.org.au,
        davem@davemloft.net
To: linux-crypto@vger.kernel.org
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-co1nam03on0081.outbound.protection.outlook.com ([104.47.40.81]:24639
        "EHLO NAM03-CO1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1754640AbdGUTEy (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 21 Jul 2017 15:04:54 -0400
In-Reply-To: <150066355075.49973.1565434199212056832.stgit@sosxen.amd.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Vet the key using the available standard function

Signed-off-by: Gary R Hook <gary.hook@amd.com>
---
 drivers/crypto/ccp/ccp-crypto-aes-xts.c |    9 ++++++++-
 1 file changed, 8 insertions(+), 1 deletion(-)

diff --git a/drivers/crypto/ccp/ccp-crypto-aes-xts.c b/drivers/crypto/ccp/ccp-crypto-aes-xts.c
index 58a4244b4752..4a313f62dbea 100644
--- a/drivers/crypto/ccp/ccp-crypto-aes-xts.c
+++ b/drivers/crypto/ccp/ccp-crypto-aes-xts.c
@@ -15,6 +15,7 @@
 #include <linux/delay.h>
 #include <linux/scatterlist.h>
 #include <crypto/aes.h>
+#include <crypto/xts.h>
 #include <crypto/internal/skcipher.h>
 #include <crypto/scatterwalk.h>
 
@@ -96,7 +97,13 @@ static int ccp_aes_xts_complete(struct crypto_async_request *async_req, int ret)
 static int ccp_aes_xts_setkey(struct crypto_ablkcipher *tfm, const u8 *key,
 			      unsigned int key_len)
 {
-	struct ccp_ctx *ctx = crypto_tfm_ctx(crypto_ablkcipher_tfm(tfm));
+	struct crypto_tfm *xfm = crypto_ablkcipher_tfm(tfm);
+	struct ccp_ctx *ctx = crypto_tfm_ctx(xfm);
+	int ret;
+
+	ret = xts_check_key(xfm, key, key_len);
+	if (ret)
+		return ret;
 
 	/* Only support 128-bit AES key with a 128-bit Tweak key,
 	 * otherwise use the fallback
