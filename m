From: Corentin Labbe <clabbe.montjoie@gmail.com>
Subject: [PATCH 03/11] crypto: ccp - Use GCM IV size constant
Date: Tue, 22 Aug 2017 10:08:10 +0200
Message-ID: <20170822080818.12486-4-clabbe.montjoie@gmail.com>
References: <20170822080818.12486-1-clabbe.montjoie@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Cc: linux-kernel@vger.kernel.org, Corentin Labbe <clabbe.montjoie@gmail.com>,
 linux-crypto@vger.kernel.org, linux-mediatek@lists.infradead.org,
 linuxppc-dev@lists.ozlabs.org, linux-arm-kernel@lists.infradead.org
To: herbert@gondor.apana.org.au, davem@davemloft.net, tglx@linutronix.de,
 mingo@redhat.com, hpa@zytor.com, x86@kernel.org, horia.geanta@nxp.com,
 dan.douglass@nxp.com, thomas.lendacky@amd.com, gary.hook@amd.com,
 harsh@chelsio.com, matthias.bgg@gmail.com, leosilva@linux.vnet.ibm.com,
 pfsmorigo@linux.vnet.ibm.com, benh@kernel.crashing.org, paulus@samba.org,
 mpe@ellerman.id.au
Return-path: <linux-arm-kernel-bounces+linux-arm-kernel=m.gmane.org@lists.infradead.org>
In-Reply-To: <20170822080818.12486-1-clabbe.montjoie@gmail.com>
List-Unsubscribe: <http://lists.infradead.org/mailman/options/linux-arm-kernel>,
 <mailto:linux-arm-kernel-request@lists.infradead.org?subject=unsubscribe>
List-Archive: <http://lists.infradead.org/pipermail/linux-arm-kernel/>
List-Post: <mailto:linux-arm-kernel@lists.infradead.org>
List-Help: <mailto:linux-arm-kernel-request@lists.infradead.org?subject=help>
List-Subscribe: <http://lists.infradead.org/mailman/listinfo/linux-arm-kernel>,
 <mailto:linux-arm-kernel-request@lists.infradead.org?subject=subscribe>
Sender: "linux-arm-kernel" <linux-arm-kernel-bounces@lists.infradead.org>
Errors-To: linux-arm-kernel-bounces+linux-arm-kernel=m.gmane.org@lists.infradead.org
List-Id: linux-crypto.vger.kernel.org

This patch replace GCM IV size value by their constant name.

Signed-off-by: Corentin Labbe <clabbe.montjoie@gmail.com>
---
 drivers/crypto/ccp/ccp-crypto-aes-galois.c | 9 ++++-----
 1 file changed, 4 insertions(+), 5 deletions(-)

diff --git a/drivers/crypto/ccp/ccp-crypto-aes-galois.c b/drivers/crypto/ccp/ccp-crypto-aes-galois.c
index 52313524a4dd..ff02b713c6f6 100644
--- a/drivers/crypto/ccp/ccp-crypto-aes-galois.c
+++ b/drivers/crypto/ccp/ccp-crypto-aes-galois.c
@@ -19,13 +19,12 @@
 #include <crypto/algapi.h>
 #include <crypto/aes.h>
 #include <crypto/ctr.h>
+#include <crypto/gcm.h>
 #include <crypto/scatterwalk.h>
 #include <linux/delay.h>
 
 #include "ccp-crypto.h"
 
-#define	AES_GCM_IVSIZE	12
-
 static int ccp_aes_gcm_complete(struct crypto_async_request *async_req, int ret)
 {
 	return ret;
@@ -95,9 +94,9 @@ static int ccp_aes_gcm_crypt(struct aead_request *req, bool encrypt)
 	 */
 
 	/* Prepare the IV: 12 bytes + an integer (counter) */
-	memcpy(rctx->iv, req->iv, AES_GCM_IVSIZE);
+	memcpy(rctx->iv, req->iv, GCM_AES_IV_SIZE);
 	for (i = 0; i < 3; i++)
-		rctx->iv[i + AES_GCM_IVSIZE] = 0;
+		rctx->iv[i + GCM_AES_IV_SIZE] = 0;
 	rctx->iv[AES_BLOCK_SIZE - 1] = 1;
 
 	/* Set up a scatterlist for the IV */
@@ -160,7 +159,7 @@ static struct aead_alg ccp_aes_gcm_defaults = {
 	.encrypt = ccp_aes_gcm_encrypt,
 	.decrypt = ccp_aes_gcm_decrypt,
 	.init = ccp_aes_gcm_cra_init,
-	.ivsize = AES_GCM_IVSIZE,
+	.ivsize = GCM_AES_IV_SIZE,
 	.maxauthsize = AES_BLOCK_SIZE,
 	.base = {
 		.cra_flags	= CRYPTO_ALG_TYPE_ABLKCIPHER |
-- 
2.13.0
