From: Corentin Labbe <clabbe.montjoie@gmail.com>
Subject: [PATCH 07/11] crypto: mediatek - Use GCM IV size constant
Date: Tue, 22 Aug 2017 10:08:14 +0200
Message-ID: <20170822080818.12486-8-clabbe.montjoie@gmail.com>
References: <20170822080818.12486-1-clabbe.montjoie@gmail.com>
Cc: linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        linux-mediatek@lists.infradead.org, linuxppc-dev@lists.ozlabs.org,
        Corentin Labbe <clabbe.montjoie@gmail.com>
To: herbert@gondor.apana.org.au, davem@davemloft.net,
        tglx@linutronix.de, mingo@redhat.com, hpa@zytor.com,
        x86@kernel.org, horia.geanta@nxp.com, dan.douglass@nxp.com,
        thomas.lendacky@amd.com, gary.hook@amd.com, harsh@chelsio.com,
        matthias.bgg@gmail.com, leosilva@linux.vnet.ibm.com,
        pfsmorigo@linux.vnet.ibm.com, benh@kernel.crashing.org,
        paulus@samba.org, mpe@ellerman.id.au
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20170822080818.12486-1-clabbe.montjoie@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

This patch replace GCM IV size value by their constant name.

Signed-off-by: Corentin Labbe <clabbe.montjoie@gmail.com>
---
 drivers/crypto/mediatek/mtk-aes.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/crypto/mediatek/mtk-aes.c b/drivers/crypto/mediatek/mtk-aes.c
index 9e845e866dec..87e15b624f84 100644
--- a/drivers/crypto/mediatek/mtk-aes.c
+++ b/drivers/crypto/mediatek/mtk-aes.c
@@ -13,6 +13,7 @@
  */
 
 #include <crypto/aes.h>
+#include <crypto/gcm.h>
 #include "mtk-platform.h"
 
 #define AES_QUEUE_SIZE		512
@@ -1098,7 +1099,7 @@ static struct aead_alg aes_gcm_alg = {
 	.decrypt	= mtk_aes_gcm_decrypt,
 	.init		= mtk_aes_gcm_init,
 	.exit		= mtk_aes_gcm_exit,
-	.ivsize		= 12,
+	.ivsize		= GCM_AES_IV_SIZE,
 	.maxauthsize	= AES_BLOCK_SIZE,
 
 	.base = {
-- 
2.13.0
