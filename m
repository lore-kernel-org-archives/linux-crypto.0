From: Corentin Labbe <clabbe.montjoie@gmail.com>
Subject: [PATCH 09/11] crypto: omap - Use GCM IV size constant
Date: Tue, 22 Aug 2017 10:08:16 +0200
Message-ID: <20170822080818.12486-10-clabbe.montjoie@gmail.com>
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
 drivers/crypto/omap-aes-gcm.c | 7 ++++---
 drivers/crypto/omap-aes.c     | 5 +++--
 2 files changed, 7 insertions(+), 5 deletions(-)

diff --git a/drivers/crypto/omap-aes-gcm.c b/drivers/crypto/omap-aes-gcm.c
index 7d4f8a4be6d8..9b8f1c752168 100644
--- a/drivers/crypto/omap-aes-gcm.c
+++ b/drivers/crypto/omap-aes-gcm.c
@@ -18,6 +18,7 @@
 #include <linux/omap-dma.h>
 #include <linux/interrupt.h>
 #include <crypto/aes.h>
+#include <crypto/gcm.h>
 #include <crypto/scatterwalk.h>
 #include <crypto/skcipher.h>
 #include <crypto/internal/aead.h>
@@ -311,7 +312,7 @@ static int omap_aes_gcm_crypt(struct aead_request *req, unsigned long mode)
 	int err, assoclen;
 
 	memset(rctx->auth_tag, 0, sizeof(rctx->auth_tag));
-	memcpy(rctx->iv + 12, &counter, 4);
+	memcpy(rctx->iv + GCM_AES_IV_SIZE, &counter, 4);
 
 	err = do_encrypt_iv(req, (u32 *)rctx->auth_tag, (u32 *)rctx->iv);
 	if (err)
@@ -339,7 +340,7 @@ int omap_aes_gcm_encrypt(struct aead_request *req)
 {
 	struct omap_aes_reqctx *rctx = aead_request_ctx(req);
 
-	memcpy(rctx->iv, req->iv, 12);
+	memcpy(rctx->iv, req->iv, GCM_AES_IV_SIZE);
 	return omap_aes_gcm_crypt(req, FLAGS_ENCRYPT | FLAGS_GCM);
 }
 
@@ -347,7 +348,7 @@ int omap_aes_gcm_decrypt(struct aead_request *req)
 {
 	struct omap_aes_reqctx *rctx = aead_request_ctx(req);
 
-	memcpy(rctx->iv, req->iv, 12);
+	memcpy(rctx->iv, req->iv, GCM_AES_IV_SIZE);
 	return omap_aes_gcm_crypt(req, FLAGS_GCM);
 }
 
diff --git a/drivers/crypto/omap-aes.c b/drivers/crypto/omap-aes.c
index c376a3ee7c2c..1f3686a1ebfa 100644
--- a/drivers/crypto/omap-aes.c
+++ b/drivers/crypto/omap-aes.c
@@ -35,6 +35,7 @@
 #include <linux/interrupt.h>
 #include <crypto/scatterwalk.h>
 #include <crypto/aes.h>
+#include <crypto/gcm.h>
 #include <crypto/engine.h>
 #include <crypto/internal/skcipher.h>
 #include <crypto/internal/aead.h>
@@ -767,7 +768,7 @@ static struct aead_alg algs_aead_gcm[] = {
 	},
 	.init		= omap_aes_gcm_cra_init,
 	.exit		= omap_aes_gcm_cra_exit,
-	.ivsize		= 12,
+	.ivsize		= GCM_AES_IV_SIZE,
 	.maxauthsize	= AES_BLOCK_SIZE,
 	.setkey		= omap_aes_gcm_setkey,
 	.encrypt	= omap_aes_gcm_encrypt,
@@ -788,7 +789,7 @@ static struct aead_alg algs_aead_gcm[] = {
 	.init		= omap_aes_gcm_cra_init,
 	.exit		= omap_aes_gcm_cra_exit,
 	.maxauthsize	= AES_BLOCK_SIZE,
-	.ivsize		= 8,
+	.ivsize		= GCM_RFC4106_IV_SIZE,
 	.setkey		= omap_aes_4106gcm_setkey,
 	.encrypt	= omap_aes_4106gcm_encrypt,
 	.decrypt	= omap_aes_4106gcm_decrypt,
-- 
2.13.0
