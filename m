From: Corentin Labbe <clabbe.montjoie@gmail.com>
Subject: [PATCH 08/11] crypto: chelsio - Use GCM IV size constant
Date: Tue, 22 Aug 2017 10:08:15 +0200
Message-ID: <20170822080818.12486-9-clabbe.montjoie@gmail.com>
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
 drivers/crypto/chelsio/chcr_algo.c | 9 +++++----
 1 file changed, 5 insertions(+), 4 deletions(-)

diff --git a/drivers/crypto/chelsio/chcr_algo.c b/drivers/crypto/chelsio/chcr_algo.c
index 0e8160701833..936bdd895efa 100644
--- a/drivers/crypto/chelsio/chcr_algo.c
+++ b/drivers/crypto/chelsio/chcr_algo.c
@@ -53,6 +53,7 @@
 #include <crypto/aes.h>
 #include <crypto/algapi.h>
 #include <crypto/hash.h>
+#include <crypto/gcm.h>
 #include <crypto/sha.h>
 #include <crypto/authenc.h>
 #include <crypto/ctr.h>
@@ -2534,9 +2535,9 @@ static struct sk_buff *create_gcm_wr(struct aead_request *req,
 	if (get_aead_subtype(tfm) ==
 	    CRYPTO_ALG_SUB_TYPE_AEAD_RFC4106) {
 		memcpy(reqctx->iv, aeadctx->salt, 4);
-		memcpy(reqctx->iv + 4, req->iv, 8);
+		memcpy(reqctx->iv + 4, req->iv, GCM_RFC4106_IV_SIZE);
 	} else {
-		memcpy(reqctx->iv, req->iv, 12);
+		memcpy(reqctx->iv, req->iv, GCM_AES_IV_SIZE);
 	}
 	*((unsigned int *)(reqctx->iv + 12)) = htonl(0x01);
 
@@ -3385,7 +3386,7 @@ static struct chcr_alg_template driver_algs[] = {
 						sizeof(struct chcr_aead_ctx) +
 						sizeof(struct chcr_gcm_ctx),
 			},
-			.ivsize = 12,
+			.ivsize = GCM_AES_IV_SIZE,
 			.maxauthsize = GHASH_DIGEST_SIZE,
 			.setkey = chcr_gcm_setkey,
 			.setauthsize = chcr_gcm_setauthsize,
@@ -3405,7 +3406,7 @@ static struct chcr_alg_template driver_algs[] = {
 						sizeof(struct chcr_gcm_ctx),
 
 			},
-			.ivsize = 8,
+			.ivsize = GCM_RFC4106_IV_SIZE,
 			.maxauthsize	= GHASH_DIGEST_SIZE,
 			.setkey = chcr_gcm_setkey,
 			.setauthsize	= chcr_4106_4309_setauthsize,
-- 
2.13.0
