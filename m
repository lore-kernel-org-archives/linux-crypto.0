From: Gary R Hook <gary.hook@amd.com>
Subject: [PATCH v3 1/3] crypto: ccp - Add a call to xts_check_key()
Date: Tue, 25 Jul 2017 14:21:23 -0500
Message-ID: <150101048380.39154.437528207365398357.stgit@sosxen.amd.com>
References: <150100997531.39154.470521200404215266.stgit@sosxen.amd.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Cc: thomas.lendacky@amd.com, herbert@gondor.apana.org.au,
        davem@davemloft.net
To: linux-crypto@vger.kernel.org
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-bl2nam02on0064.outbound.protection.outlook.com ([104.47.38.64]:49591
        "EHLO NAM02-BL2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1752846AbdGYTVb (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 25 Jul 2017 15:21:31 -0400
In-Reply-To: <150100997531.39154.470521200404215266.stgit@sosxen.amd.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Vet the key using the available standard function

Signed-off-by: Gary R Hook <gary.hook@amd.com>
---
 drivers/crypto/ccp/ccp-crypto-aes-xts.c |    9 ++++++++-
 1 file changed, 8 insertions(+), 1 deletion(-)

diff --git a/drivers/crypto/ccp/ccp-crypto-aes-xts.c b/drivers/crypto/ccp/ccp-crypto-aes-xts.c
index 3f26a415ef44..2b5d3a62fad9 100644
--- a/drivers/crypto/ccp/ccp-crypto-aes-xts.c
+++ b/drivers/crypto/ccp/ccp-crypto-aes-xts.c
@@ -16,6 +16,7 @@
 #include <linux/delay.h>
 #include <linux/scatterlist.h>
 #include <crypto/aes.h>
+#include <crypto/xts.h>
 #include <crypto/internal/skcipher.h>
 #include <crypto/scatterwalk.h>
 
@@ -97,7 +98,13 @@ static int ccp_aes_xts_complete(struct crypto_async_request *async_req, int ret)
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
