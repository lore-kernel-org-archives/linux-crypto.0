From: Corentin Labbe <clabbe.montjoie-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: [PATCH v2 4/6] crypto: virtio: convert to new crypto
 engine API
Date: Fri, 26 Jan 2018 20:15:32 +0100
Message-ID: <20180126191534.17569-5-clabbe.montjoie@gmail.com>
References: <20180126191534.17569-1-clabbe.montjoie@gmail.com>
Reply-To: clabbe.montjoie-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Cc: linux-arm-kernel-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org,
	linux-crypto-u79uwXL29TY76Z2rM5mHXA@public.gmane.org,
	linux-doc-u79uwXL29TY76Z2rM5mHXA@public.gmane.org,
	linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org,
	virtualization-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org,
	linux-sunxi-/JYPxA39Uh5TLH3MbocFFw@public.gmane.org,
	Corentin Labbe <clabbe.montjoie-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
To: alexandre.torgue-qxv4g6HH51o@public.gmane.org,
	arei.gonglei-hv44wF8Li93QT0dZR+AlfA@public.gmane.org,
	corbet-T1hC0tSOHrs@public.gmane.org,
	davem-fT/PcQaiUtIeIZ0/mPfg9Q@public.gmane.org,
	herbert-lOAM2aK0SrRLBo1qDEOMRrpzq4S04n8Q@public.gmane.org,
	jasowang-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org,
	mcoquelin.stm32-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org,
	mst-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org,
	fabien.dessenne-qxv4g6HH51o@public.gmane.org
Return-path: <linux-sunxi+bncBD7YLCN32UNBB475VXJQKGQEZLAY6FA-/JYPxA39Uh5TLH3MbocFFw@public.gmane.org>
Sender: linux-sunxi-/JYPxA39Uh5TLH3MbocFFw@public.gmane.org
In-Reply-To: <20180126191534.17569-1-clabbe.montjoie-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
List-Post: <https://groups.google.com/group/linux-sunxi/post>, <mailto:linux-sunxi-/JYPxA39Uh5TLH3MbocFFw@public.gmane.org>
List-Help: <https://groups.google.com/support/>, <mailto:linux-sunxi+help-/JYPxA39Uh5TLH3MbocFFw@public.gmane.org>
List-Archive: <https://groups.google.com/group/linux-sunxi
List-Subscribe: <https://groups.google.com/group/linux-sunxi/subscribe>, <mailto:linux-sunxi+subscribe-/JYPxA39Uh5TLH3MbocFFw@public.gmane.org>
List-Unsubscribe: <mailto:googlegroups-manage+1076902468213+unsubscribe-/JYPxA39Uh5TLH3MbocFFw@public.gmane.org>,
 <https://groups.google.com/group/linux-sunxi/subscribe>
List-Id: linux-crypto.vger.kernel.org

This patch convert the driver to the new crypto engine API.

Signed-off-by: Corentin Labbe <clabbe.montjoie-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
---
 drivers/crypto/virtio/virtio_crypto_algs.c   | 16 ++++++++++------
 drivers/crypto/virtio/virtio_crypto_common.h |  3 +--
 drivers/crypto/virtio/virtio_crypto_core.c   |  3 ---
 3 files changed, 11 insertions(+), 11 deletions(-)

diff --git a/drivers/crypto/virtio/virtio_crypto_algs.c b/drivers/crypto/virtio/virtio_crypto_algs.c
index abe8c15450df..ba190cfa7aa1 100644
--- a/drivers/crypto/virtio/virtio_crypto_algs.c
+++ b/drivers/crypto/virtio/virtio_crypto_algs.c
@@ -29,6 +29,7 @@
 
 
 struct virtio_crypto_ablkcipher_ctx {
+	struct crypto_engine_ctx enginectx;
 	struct virtio_crypto *vcrypto;
 	struct crypto_tfm *tfm;
 
@@ -491,7 +492,7 @@ static int virtio_crypto_ablkcipher_encrypt(struct ablkcipher_request *req)
 	vc_sym_req->ablkcipher_req = req;
 	vc_sym_req->encrypt = true;
 
-	return crypto_transfer_cipher_request_to_engine(data_vq->engine, req);
+	return crypto_transfer_ablkcipher_request_to_engine(data_vq->engine, req);
 }
 
 static int virtio_crypto_ablkcipher_decrypt(struct ablkcipher_request *req)
@@ -511,7 +512,7 @@ static int virtio_crypto_ablkcipher_decrypt(struct ablkcipher_request *req)
 	vc_sym_req->ablkcipher_req = req;
 	vc_sym_req->encrypt = false;
 
-	return crypto_transfer_cipher_request_to_engine(data_vq->engine, req);
+	return crypto_transfer_ablkcipher_request_to_engine(data_vq->engine, req);
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
 
@@ -538,9 +542,9 @@ static void virtio_crypto_ablkcipher_exit(struct crypto_tfm *tfm)
 }
 
 int virtio_crypto_ablkcipher_crypt_req(
-	struct crypto_engine *engine,
-	struct ablkcipher_request *req)
+	struct crypto_engine *engine, void *vreq)
 {
+	struct ablkcipher_request *req = container_of(vreq, struct ablkcipher_request, base);
 	struct virtio_crypto_sym_request *vc_sym_req =
 				ablkcipher_request_ctx(req);
 	struct virtio_crypto_request *vc_req = &vc_sym_req->base;
@@ -561,8 +565,8 @@ static void virtio_crypto_ablkcipher_finalize_req(
 	struct ablkcipher_request *req,
 	int err)
 {
-	crypto_finalize_cipher_request(vc_sym_req->base.dataq->engine,
-					req, err);
+	crypto_finalize_ablkcipher_request(vc_sym_req->base.dataq->engine,
+					   req, err);
 	kzfree(vc_sym_req->iv);
 	virtcrypto_clear_request(&vc_sym_req->base);
 }
diff --git a/drivers/crypto/virtio/virtio_crypto_common.h b/drivers/crypto/virtio/virtio_crypto_common.h
index e976539a05d9..72621bd67211 100644
--- a/drivers/crypto/virtio/virtio_crypto_common.h
+++ b/drivers/crypto/virtio/virtio_crypto_common.h
@@ -107,8 +107,7 @@ struct virtio_crypto *virtcrypto_get_dev_node(int node);
 int virtcrypto_dev_start(struct virtio_crypto *vcrypto);
 void virtcrypto_dev_stop(struct virtio_crypto *vcrypto);
 int virtio_crypto_ablkcipher_crypt_req(
-	struct crypto_engine *engine,
-	struct ablkcipher_request *req);
+	struct crypto_engine *engine, void *vreq);
 
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
