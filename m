From: Gonglei <arei.gonglei@huawei.com>
Subject: [PATCH] virtio-crypto: support crypto engine framework
Date: Tue, 27 Dec 2016 14:49:07 +0800
Message-ID: <1482821347-47664-1-git-send-email-arei.gonglei@huawei.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Cc: Herbert Xu <herbert@gondor.apana.org.au>,
	"Michael S . Tsirkin" <mst@redhat.com>,
	Baolin Wang <baolin.wang@linaro.org>, longpeng2@huawei.com,
	wu.wubin@huawei.com
To: <linux-kernel@vger.kernel.org>,
	<virtualization@lists.linux-foundation.org>, <linux-crypto@vger.kernel.org>
Return-path: <virtualization-bounces@lists.linux-foundation.org>
List-Unsubscribe: <https://lists.linuxfoundation.org/mailman/options/virtualization>,
	<mailto:virtualization-request@lists.linux-foundation.org?subject=unsubscribe>
List-Archive: <http://lists.linuxfoundation.org/pipermail/virtualization/>
List-Post: <mailto:virtualization@lists.linux-foundation.org>
List-Help: <mailto:virtualization-request@lists.linux-foundation.org?subject=help>
List-Subscribe: <https://lists.linuxfoundation.org/mailman/listinfo/virtualization>,
	<mailto:virtualization-request@lists.linux-foundation.org?subject=subscribe>
Sender: virtualization-bounces@lists.linux-foundation.org
Errors-To: virtualization-bounces@lists.linux-foundation.org
List-Id: linux-crypto.vger.kernel.org

crypto engine was introduced since 'commit 735d37b5424b ("crypto: engine
- Introduce the block request crypto engine framework")' which uses work
queue to realize the asynchronous processing for ablk_cipher and ahash.

For virtio-crypto device, I register an engine for each
data virtqueue so that we can use the capability of
multiple data queues in future.

Cc: Baolin Wang <baolin.wang@linaro.org>
Cc: Herbert Xu <herbert@gondor.apana.org.au>
Cc: Michael S. Tsirkin <mst@redhat.com>
Signed-off-by: Gonglei <arei.gonglei@huawei.com>
---
 drivers/crypto/virtio/Kconfig                |  1 +
 drivers/crypto/virtio/virtio_crypto_algs.c   | 52 ++++++++++++-------
 drivers/crypto/virtio/virtio_crypto_common.h | 16 ++++++
 drivers/crypto/virtio/virtio_crypto_core.c   | 74 ++++++++++++++++++++++++++--
 4 files changed, 121 insertions(+), 22 deletions(-)

diff --git a/drivers/crypto/virtio/Kconfig b/drivers/crypto/virtio/Kconfig
index d80f733..5db0749 100644
--- a/drivers/crypto/virtio/Kconfig
+++ b/drivers/crypto/virtio/Kconfig
@@ -4,6 +4,7 @@ config CRYPTO_DEV_VIRTIO
 	select CRYPTO_AEAD
 	select CRYPTO_AUTHENC
 	select CRYPTO_BLKCIPHER
+	select CRYPTO_ENGINE
 	default m
 	help
 	  This driver provides support for virtio crypto device. If you
diff --git a/drivers/crypto/virtio/virtio_crypto_algs.c b/drivers/crypto/virtio/virtio_crypto_algs.c
index c2374df..970d0ca 100644
--- a/drivers/crypto/virtio/virtio_crypto_algs.c
+++ b/drivers/crypto/virtio/virtio_crypto_algs.c
@@ -288,8 +288,7 @@ static int virtio_crypto_ablkcipher_setkey(struct crypto_ablkcipher *tfm,
 static int
 __virtio_crypto_ablkcipher_do_req(struct virtio_crypto_request *vc_req,
 		struct ablkcipher_request *req,
-		struct data_queue *data_vq,
-		__u8 op)
+		struct data_queue *data_vq)
 {
 	struct crypto_ablkcipher *tfm = crypto_ablkcipher_reqtfm(req);
 	unsigned int ivsize = crypto_ablkcipher_ivsize(tfm);
@@ -329,7 +328,7 @@ static int virtio_crypto_ablkcipher_setkey(struct crypto_ablkcipher *tfm,
 	vc_req->req_data = req_data;
 	vc_req->type = VIRTIO_CRYPTO_SYM_OP_CIPHER;
 	/* Head of operation */
-	if (op) {
+	if (vc_req->encrypt) {
 		req_data->header.session_id =
 			cpu_to_le64(ctx->enc_sess_info.session_id);
 		req_data->header.opcode =
@@ -424,19 +423,15 @@ static int virtio_crypto_ablkcipher_encrypt(struct ablkcipher_request *req)
 	struct virtio_crypto_ablkcipher_ctx *ctx = crypto_ablkcipher_ctx(atfm);
 	struct virtio_crypto_request *vc_req = ablkcipher_request_ctx(req);
 	struct virtio_crypto *vcrypto = ctx->vcrypto;
-	int ret;
 	/* Use the first data virtqueue as default */
 	struct data_queue *data_vq = &vcrypto->data_vq[0];
 
 	vc_req->ablkcipher_ctx = ctx;
 	vc_req->ablkcipher_req = req;
-	ret = __virtio_crypto_ablkcipher_do_req(vc_req, req, data_vq, 1);
-	if (ret < 0) {
-		pr_err("virtio_crypto: Encryption failed!\n");
-		return ret;
-	}
+	vc_req->encrypt = true;
+	vc_req->dataq = data_vq;
 
-	return -EINPROGRESS;
+	return crypto_transfer_cipher_request_to_engine(data_vq->engine, req);
 }
 
 static int virtio_crypto_ablkcipher_decrypt(struct ablkcipher_request *req)
@@ -445,20 +440,16 @@ static int virtio_crypto_ablkcipher_decrypt(struct ablkcipher_request *req)
 	struct virtio_crypto_ablkcipher_ctx *ctx = crypto_ablkcipher_ctx(atfm);
 	struct virtio_crypto_request *vc_req = ablkcipher_request_ctx(req);
 	struct virtio_crypto *vcrypto = ctx->vcrypto;
-	int ret;
 	/* Use the first data virtqueue as default */
 	struct data_queue *data_vq = &vcrypto->data_vq[0];
 
 	vc_req->ablkcipher_ctx = ctx;
 	vc_req->ablkcipher_req = req;
 
-	ret = __virtio_crypto_ablkcipher_do_req(vc_req, req, data_vq, 0);
-	if (ret < 0) {
-		pr_err("virtio_crypto: Decryption failed!\n");
-		return ret;
-	}
+	vc_req->encrypt = false;
+	vc_req->dataq = data_vq;
 
-	return -EINPROGRESS;
+	return crypto_transfer_cipher_request_to_engine(data_vq->engine, req);
 }
 
 static int virtio_crypto_ablkcipher_init(struct crypto_tfm *tfm)
@@ -484,6 +475,33 @@ static void virtio_crypto_ablkcipher_exit(struct crypto_tfm *tfm)
 	ctx->vcrypto = NULL;
 }
 
+int virtio_crypto_ablkcipher_crypt_req(
+	struct crypto_engine *engine,
+	struct ablkcipher_request *req)
+{
+	struct virtio_crypto_request *vc_req = ablkcipher_request_ctx(req);
+	struct data_queue *data_vq = vc_req->dataq;
+	int ret;
+
+	ret = __virtio_crypto_ablkcipher_do_req(vc_req, req, data_vq);
+	if (ret < 0)
+		return ret;
+
+	virtqueue_kick(data_vq->vq);
+
+	return 0;
+}
+
+void virtio_crypto_ablkcipher_finalize_req(
+	struct virtio_crypto_request *vc_req,
+	struct ablkcipher_request *req,
+	int err)
+{
+	crypto_finalize_cipher_request(vc_req->dataq->engine, req, err);
+
+	virtcrypto_clear_request(vc_req);
+}
+
 static struct crypto_alg virtio_crypto_algs[] = { {
 	.cra_name = "cbc(aes)",
 	.cra_driver_name = "virtio_crypto_aes_cbc",
diff --git a/drivers/crypto/virtio/virtio_crypto_common.h b/drivers/crypto/virtio/virtio_crypto_common.h
index 3d6566b..da6d8c0 100644
--- a/drivers/crypto/virtio/virtio_crypto_common.h
+++ b/drivers/crypto/virtio/virtio_crypto_common.h
@@ -25,6 +25,7 @@
 #include <crypto/aead.h>
 #include <crypto/aes.h>
 #include <crypto/authenc.h>
+#include <crypto/engine.h>
 
 
 /* Internal representation of a data virtqueue */
@@ -37,6 +38,8 @@ struct data_queue {
 
 	/* Name of the tx queue: dataq.$index */
 	char name[32];
+
+	struct crypto_engine *engine;
 };
 
 struct virtio_crypto {
@@ -97,6 +100,9 @@ struct virtio_crypto_request {
 	struct virtio_crypto_op_data_req *req_data;
 	struct scatterlist **sgs;
 	uint8_t *iv;
+	/* Encryption? */
+	bool encrypt;
+	struct data_queue *dataq;
 };
 
 int virtcrypto_devmgr_add_dev(struct virtio_crypto *vcrypto_dev);
@@ -110,6 +116,16 @@ struct virtio_crypto_request {
 struct virtio_crypto *virtcrypto_get_dev_node(int node);
 int virtcrypto_dev_start(struct virtio_crypto *vcrypto);
 void virtcrypto_dev_stop(struct virtio_crypto *vcrypto);
+int virtio_crypto_ablkcipher_crypt_req(
+	struct crypto_engine *engine,
+	struct ablkcipher_request *req);
+void virtio_crypto_ablkcipher_finalize_req(
+	struct virtio_crypto_request *vc_req,
+	struct ablkcipher_request *req,
+	int err);
+
+void
+virtcrypto_clear_request(struct virtio_crypto_request *vc_req);
 
 static inline int virtio_crypto_get_current_node(void)
 {
diff --git a/drivers/crypto/virtio/virtio_crypto_core.c b/drivers/crypto/virtio/virtio_crypto_core.c
index fe70ec8..b5b1533 100644
--- a/drivers/crypto/virtio/virtio_crypto_core.c
+++ b/drivers/crypto/virtio/virtio_crypto_core.c
@@ -25,7 +25,7 @@
 #include "virtio_crypto_common.h"
 
 
-static void
+void
 virtcrypto_clear_request(struct virtio_crypto_request *vc_req)
 {
 	if (vc_req) {
@@ -66,12 +66,12 @@ static void virtcrypto_dataq_callback(struct virtqueue *vq)
 					break;
 				}
 				ablk_req = vc_req->ablkcipher_req;
-				virtcrypto_clear_request(vc_req);
 
 				spin_unlock_irqrestore(
 					&vcrypto->data_vq[qid].lock, flags);
 				/* Finish the encrypt or decrypt process */
-				ablk_req->base.complete(&ablk_req->base, error);
+				virtio_crypto_ablkcipher_finalize_req(vc_req,
+				    ablk_req, error);
 				spin_lock_irqsave(
 					&vcrypto->data_vq[qid].lock, flags);
 			}
@@ -87,6 +87,7 @@ static int virtcrypto_find_vqs(struct virtio_crypto *vi)
 	int ret = -ENOMEM;
 	int i, total_vqs;
 	const char **names;
+	struct device *dev = &vi->vdev->dev;
 
 	/*
 	 * We expect 1 data virtqueue, followed by
@@ -128,6 +129,15 @@ static int virtcrypto_find_vqs(struct virtio_crypto *vi)
 	for (i = 0; i < vi->max_data_queues; i++) {
 		spin_lock_init(&vi->data_vq[i].lock);
 		vi->data_vq[i].vq = vqs[i];
+		/* Initialize crypto engine */
+		vi->data_vq[i].engine = crypto_engine_alloc_init(dev, 1);
+		if (!vi->data_vq[i].engine) {
+			ret = -ENOMEM;
+			goto err_engine;
+		}
+
+		vi->data_vq[i].engine->cipher_one_request =
+			virtio_crypto_ablkcipher_crypt_req;
 	}
 
 	kfree(names);
@@ -136,6 +146,7 @@ static int virtcrypto_find_vqs(struct virtio_crypto *vi)
 
 	return 0;
 
+err_engine:
 err_find:
 	kfree(names);
 err_names:
@@ -269,6 +280,38 @@ static int virtcrypto_update_status(struct virtio_crypto *vcrypto)
 	return 0;
 }
 
+static int virtcrypto_start_crypto_engines(struct virtio_crypto *vcrypto)
+{
+	int32_t i;
+	int ret;
+
+	for (i = 0; i < vcrypto->max_data_queues; i++) {
+		if (vcrypto->data_vq[i].engine) {
+			ret = crypto_engine_start(vcrypto->data_vq[i].engine);
+			if (ret)
+				goto err;
+		}
+	}
+
+	return 0;
+
+err:
+	while (--i >= 0)
+		if (vcrypto->data_vq[i].engine)
+			crypto_engine_exit(vcrypto->data_vq[i].engine);
+
+	return ret;
+}
+
+static void virtcrypto_clear_crypto_engines(struct virtio_crypto *vcrypto)
+{
+	u32 i;
+
+	for (i = 0; i < vcrypto->max_data_queues; i++)
+		if (vcrypto->data_vq[i].engine)
+			crypto_engine_exit(vcrypto->data_vq[i].engine);
+}
+
 static void virtcrypto_del_vqs(struct virtio_crypto *vcrypto)
 {
 	struct virtio_device *vdev = vcrypto->vdev;
@@ -355,14 +398,21 @@ static int virtcrypto_probe(struct virtio_device *vdev)
 		dev_err(&vdev->dev, "Failed to initialize vqs.\n");
 		goto free_dev;
 	}
+
+	err = virtcrypto_start_crypto_engines(vcrypto);
+	if (err)
+		goto free_vqs;
+
 	virtio_device_ready(vdev);
 
 	err = virtcrypto_update_status(vcrypto);
 	if (err)
-		goto free_vqs;
+		goto free_engines;
 
 	return 0;
 
+free_engines:
+	virtcrypto_clear_crypto_engines(vcrypto);
 free_vqs:
 	vcrypto->vdev->config->reset(vdev);
 	virtcrypto_del_vqs(vcrypto);
@@ -398,6 +448,7 @@ static void virtcrypto_remove(struct virtio_device *vdev)
 		virtcrypto_dev_stop(vcrypto);
 	vdev->config->reset(vdev);
 	virtcrypto_free_unused_reqs(vcrypto);
+	virtcrypto_clear_crypto_engines(vcrypto);
 	virtcrypto_del_vqs(vcrypto);
 	virtcrypto_devmgr_rm_dev(vcrypto);
 	kfree(vcrypto);
@@ -420,6 +471,7 @@ static int virtcrypto_freeze(struct virtio_device *vdev)
 	if (virtcrypto_dev_started(vcrypto))
 		virtcrypto_dev_stop(vcrypto);
 
+	virtcrypto_clear_crypto_engines(vcrypto);
 	virtcrypto_del_vqs(vcrypto);
 	return 0;
 }
@@ -433,14 +485,26 @@ static int virtcrypto_restore(struct virtio_device *vdev)
 	if (err)
 		return err;
 
+	err = virtcrypto_start_crypto_engines(vcrypto);
+	if (err)
+		goto free_vqs;
+
 	virtio_device_ready(vdev);
+
 	err = virtcrypto_dev_start(vcrypto);
 	if (err) {
 		dev_err(&vdev->dev, "Failed to start virtio crypto device.\n");
-		return -EFAULT;
+		goto free_engines;
 	}
 
 	return 0;
+
+free_engines:
+	virtcrypto_clear_crypto_engines(vcrypto);
+free_vqs:
+	vcrypto->vdev->config->reset(vdev);
+	virtcrypto_del_vqs(vcrypto);
+	return err;
 }
 #endif
 
-- 
1.8.3.1
