From: Corentin Labbe <clabbe.montjoie@gmail.com>
Subject: [PATCH 04/11] crypto: nx - Use GCM IV size constant
Date: Tue, 22 Aug 2017 10:08:11 +0200
Message-ID: <20170822080818.12486-5-clabbe.montjoie@gmail.com>
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
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-wr0-f194.google.com ([209.85.128.194]:34227 "EHLO
        mail-wr0-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932230AbdHVIKk (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 22 Aug 2017 04:10:40 -0400
In-Reply-To: <20170822080818.12486-1-clabbe.montjoie@gmail.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

This patch replace GCM IV size value by their constant name.

Signed-off-by: Corentin Labbe <clabbe.montjoie@gmail.com>
---
 drivers/crypto/nx/nx-aes-gcm.c | 9 +++++----
 1 file changed, 5 insertions(+), 4 deletions(-)

diff --git a/drivers/crypto/nx/nx-aes-gcm.c b/drivers/crypto/nx/nx-aes-gcm.c
index abd465f479c4..a810596b97c2 100644
--- a/drivers/crypto/nx/nx-aes-gcm.c
+++ b/drivers/crypto/nx/nx-aes-gcm.c
@@ -22,6 +22,7 @@
 #include <crypto/internal/aead.h>
 #include <crypto/aes.h>
 #include <crypto/algapi.h>
+#include <crypto/gcm.h>
 #include <crypto/scatterwalk.h>
 #include <linux/module.h>
 #include <linux/types.h>
@@ -433,7 +434,7 @@ static int gcm_aes_nx_encrypt(struct aead_request *req)
 	struct nx_gcm_rctx *rctx = aead_request_ctx(req);
 	char *iv = rctx->iv;
 
-	memcpy(iv, req->iv, 12);
+	memcpy(iv, req->iv, GCM_AES_IV_SIZE);
 
 	return gcm_aes_nx_crypt(req, 1, req->assoclen);
 }
@@ -443,7 +444,7 @@ static int gcm_aes_nx_decrypt(struct aead_request *req)
 	struct nx_gcm_rctx *rctx = aead_request_ctx(req);
 	char *iv = rctx->iv;
 
-	memcpy(iv, req->iv, 12);
+	memcpy(iv, req->iv, GCM_AES_IV_SIZE);
 
 	return gcm_aes_nx_crypt(req, 0, req->assoclen);
 }
@@ -498,7 +499,7 @@ struct aead_alg nx_gcm_aes_alg = {
 	},
 	.init        = nx_crypto_ctx_aes_gcm_init,
 	.exit        = nx_crypto_ctx_aead_exit,
-	.ivsize      = 12,
+	.ivsize      = GCM_AES_IV_SIZE,
 	.maxauthsize = AES_BLOCK_SIZE,
 	.setkey      = gcm_aes_nx_set_key,
 	.encrypt     = gcm_aes_nx_encrypt,
@@ -516,7 +517,7 @@ struct aead_alg nx_gcm4106_aes_alg = {
 	},
 	.init        = nx_crypto_ctx_aes_gcm_init,
 	.exit        = nx_crypto_ctx_aead_exit,
-	.ivsize      = 8,
+	.ivsize      = GCM_RFC4106_IV_SIZE,
 	.maxauthsize = AES_BLOCK_SIZE,
 	.setkey      = gcm4106_aes_nx_set_key,
 	.setauthsize = gcm4106_aes_nx_setauthsize,
-- 
2.13.0
