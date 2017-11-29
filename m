From: Corentin Labbe <clabbe.montjoie@gmail.com>
Subject: [PATCH RFC 3/4] crypto: virtio: convert to new crypto engine API
Date: Wed, 29 Nov 2017 09:41:20 +0100
Message-ID: <20171129084121.9385-4-clabbe.montjoie@gmail.com>
References: <20171129084121.9385-1-clabbe.montjoie@gmail.com>
Cc: linux-arm-kernel@lists.infradead.org, linux-crypto@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        virtualization@lists.linux-foundation.org,
        Corentin Labbe <clabbe.montjoie@gmail.com>
To: herbert@gondor.apana.org.au, alexandre.torgue@st.com,
        arei.gonglei@huawei.com, davem@davemloft.net, jasowang@redhat.com,
        mcoquelin.stm32@gmail.com, mst@redhat.com, fabien.dessenne@st.com
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20171129084121.9385-1-clabbe.montjoie@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

This patch convert the driver to the new crypto engine API.

Signed-off-by: Corentin Labbe <clabbe.montjoie@gmail.com>
---
 drivers/crypto/virtio/virtio_crypto_algs.c   | 15 ++++++++++-----
 drivers/crypto/virtio/virtio_crypto_common.h |  2 +-
 drivers/crypto/virtio/virtio_crypto_core.c   |  3 ---
 3 files changed, 11 insertions(+), 9 deletions(-)

diff --git a/drivers/crypto/virtio/virtio_crypto_algs.c b/drivers/crypto/virtio/virtio_crypto_algs.c
index abe8c15450df..a2ac7a08247f 100644
--- a/drivers/crypto/virtio/virtio_crypto_algs.c
+++ b/drivers/crypto/virtio/virtio_crypto_algs.c
@@ -29,6 +29,7 @@
 
 
 struct virtio_crypto_ablkcipher_ctx {
+	struct crypto_engine_reqctx enginectx;
 	struct virtio_crypto *vcrypto;
 	struct crypto_tfm *tfm;
 
@@ -491,7 +492,7 @@ static int virtio_crypto_ablkcipher_encrypt(struct ablkcipher_request *req)
 	vc_sym_req->ablkcipher_req = req;
 	vc_sym_req->encrypt = true;
 
-	return crypto_transfer_cipher_request_to_engine(data_vq->engine, req);
+	return crypto_transfer_request_to_engine(data_vq->engine, &req->base);
 }
 
 static int virtio_crypto_ablkcipher_decrypt(struct ablkcipher_request *req)
@@ -511,7 +512,7 @@ static int virtio_crypto_ablkcipher_decrypt(struct ablkcipher_request *req)
 	vc_sym_req->ablkcipher_req = req;
 	vc_sym_req->encrypt = false;
 
-	return crypto_transfer_cipher_request_to_engine(data_vq->engine, req);
+	return crypto_transfer_request_to_engine(data_vq->engine, &req->base);
 }
 
 static int virtio_crypto_ablkcipher_init(struct crypto_tfm *tfm)
@@ -521,6 +522,9 @@ static int virtio_crypto_ablkcipher_init(struct crypto_tfm *tfm)
 	tfm->crt_ablkcipher.reqsize = sizeof(struct virtio_crypto_sym_request);
 	ctx->tfm = tfm;
 
+	ctx->enginectx.op.do_one_request = virtio_crypto_ablkcipher_crypt_req;
+	ctx->enginectx.op.prepare_request = NULL;
+	ctx->enginectx.op.unprepare_request = NULL;
 	return 0;
 }
 
@@ -539,8 +543,9 @@ static void virtio_crypto_ablkcipher_exit(struct crypto_tfm *tfm)
 
 int virtio_crypto_ablkcipher_crypt_req(
 	struct crypto_engine *engine,
-	struct ablkcipher_request *req)
+	struct crypto_async_request *areq)
 {
+	struct ablkcipher_request *req = ablkcipher_request_cast(areq);
 	struct virtio_crypto_sym_request *vc_sym_req =
 				ablkcipher_request_ctx(req);
 	struct virtio_crypto_request *vc_req = &vc_sym_req->base;
@@ -561,8 +566,8 @@ static void virtio_crypto_ablkcipher_finalize_req(
 	struct ablkcipher_request *req,
 	int err)
 {
-	crypto_finalize_cipher_request(vc_sym_req->base.dataq->engine,
-					req, err);
+	crypto_finalize_request(vc_sym_req->base.dataq->engine,
+				&req->base, err);
 	kzfree(vc_sym_req->iv);
 	virtcrypto_clear_request(&vc_sym_req->base);
 }
diff --git a/drivers/crypto/virtio/virtio_crypto_common.h b/drivers/crypto/virtio/virtio_crypto_common.h
index e976539a05d9..0d51f6ce226d 100644
--- a/drivers/crypto/virtio/virtio_crypto_common.h
+++ b/drivers/crypto/virtio/virtio_crypto_common.h
@@ -108,7 +108,7 @@ int virtcrypto_dev_start(struct virtio_crypto *vcrypto);
 void virtcrypto_dev_stop(struct virtio_crypto *vcrypto);
 int virtio_crypto_ablkcipher_crypt_req(
 	struct crypto_engine *engine,
-	struct ablkcipher_request *req);
+	struct crypto_async_request *req);
 
 void
 virtcrypto_clear_request(struct virtio_crypto_request *vc_req);
diff --git a/drivers/crypto/virtio/virtio_crypto_core.c b/drivers/crypto/virtio/virtio_crypto_core.c
index ff1410a32c2b..83326986c113 100644
--- a/drivers/crypto/virtio/virtio_crypto_core.c
+++ b/drivers/crypto/virtio/virtio_crypto_core.c
@@ -111,9 +111,6 @@ static int virtcrypto_find_vqs(struct virtio_crypto *vi)
 			ret = -ENOMEM;
 			goto err_engine;
 		}
-
-		vi->data_vq[i].engine->cipher_one_request =
-			virtio_crypto_ablkcipher_crypt_req;
 	}
 
 	kfree(names);
-- 
2.13.6
