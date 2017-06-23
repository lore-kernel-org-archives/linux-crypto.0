From: Xin Zeng <xin.zeng@intel.com>
Subject: [PATCH] crypto: virtio - Refacotor virtio_crypto driver for new virito crypto services
Date: Fri, 23 Jun 2017 11:31:19 -0400
Message-ID: <1498231879-3795-1-git-send-email-xin.zeng@intel.com>
Cc: linux-crypto@vger.kernel.org, arei.gonglei@huawei.com,
        Xin Zeng <xin.zeng@intel.com>
To: herbert@gondor.apana.org.au, virtio-dev@lists.oasis-open.org
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mga09.intel.com ([134.134.136.24]:53346 "EHLO mga09.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752066AbdFWPdl (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 23 Jun 2017 11:33:41 -0400
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

In current virtio crypto device driver, some common data structures and
implementations that should be used by other virtio crypto algorithms
(e.g. asymmetric crypto algorithms) introduce symmetric crypto algorithms
specific implementations.
This patch refactors these pieces of code so that they can be reused by
other virtio crypto algorithms.

Acked-by: Gonglei <arei.gonglei@huawei.com>
Signed-off-by: Xin Zeng <xin.zeng@intel.com>
---
 drivers/crypto/virtio/virtio_crypto_algs.c   | 109 +++++++++++++++++++++------
 drivers/crypto/virtio/virtio_crypto_common.h |  22 +-----
 drivers/crypto/virtio/virtio_crypto_core.c   |  37 ++-------
 3 files changed, 98 insertions(+), 70 deletions(-)

diff --git a/drivers/crypto/virtio/virtio_crypto_algs.c b/drivers/crypto/virtio/virtio_crypto_algs.c
index 49defda..5035b0d 100644
--- a/drivers/crypto/virtio/virtio_crypto_algs.c
+++ b/drivers/crypto/virtio/virtio_crypto_algs.c
@@ -27,12 +27,68 @@
 #include <uapi/linux/virtio_crypto.h>
 #include "virtio_crypto_common.h"
 
+
+struct virtio_crypto_ablkcipher_ctx {
+	struct virtio_crypto *vcrypto;
+	struct crypto_tfm *tfm;
+
+	struct virtio_crypto_sym_session_info enc_sess_info;
+	struct virtio_crypto_sym_session_info dec_sess_info;
+};
+
+struct virtio_crypto_sym_request {
+	struct virtio_crypto_request base;
+
+	/* Cipher or aead */
+	uint32_t type;
+	struct virtio_crypto_ablkcipher_ctx *ablkcipher_ctx;
+	struct ablkcipher_request *ablkcipher_req;
+	uint8_t *iv;
+	/* Encryption? */
+	bool encrypt;
+};
+
 /*
  * The algs_lock protects the below global virtio_crypto_active_devs
  * and crypto algorithms registion.
  */
 static DEFINE_MUTEX(algs_lock);
 static unsigned int virtio_crypto_active_devs;
+static void virtio_crypto_ablkcipher_finalize_req(
+	struct virtio_crypto_sym_request *vc_sym_req,
+	struct ablkcipher_request *req,
+	int err);
+
+static void virtio_crypto_dataq_sym_callback
+		(struct virtio_crypto_request *vc_req, int len)
+{
+	struct virtio_crypto_sym_request *vc_sym_req =
+		container_of(vc_req, struct virtio_crypto_sym_request, base);
+	struct ablkcipher_request *ablk_req;
+	int error;
+
+	/* Finish the encrypt or decrypt process */
+	if (vc_sym_req->type == VIRTIO_CRYPTO_SYM_OP_CIPHER) {
+		switch (vc_req->status) {
+		case VIRTIO_CRYPTO_OK:
+			error = 0;
+			break;
+		case VIRTIO_CRYPTO_INVSESS:
+		case VIRTIO_CRYPTO_ERR:
+			error = -EINVAL;
+			break;
+		case VIRTIO_CRYPTO_BADMSG:
+			error = -EBADMSG;
+			break;
+		default:
+			error = -EIO;
+			break;
+		}
+		ablk_req = vc_sym_req->ablkcipher_req;
+		virtio_crypto_ablkcipher_finalize_req(vc_sym_req,
+							ablk_req, error);
+	}
+}
 
 static u64 virtio_crypto_alg_sg_nents_length(struct scatterlist *sg)
 {
@@ -286,13 +342,14 @@ static int virtio_crypto_ablkcipher_setkey(struct crypto_ablkcipher *tfm,
 }
 
 static int
-__virtio_crypto_ablkcipher_do_req(struct virtio_crypto_request *vc_req,
+__virtio_crypto_ablkcipher_do_req(struct virtio_crypto_sym_request *vc_sym_req,
 		struct ablkcipher_request *req,
 		struct data_queue *data_vq)
 {
 	struct crypto_ablkcipher *tfm = crypto_ablkcipher_reqtfm(req);
+	struct virtio_crypto_ablkcipher_ctx *ctx = vc_sym_req->ablkcipher_ctx;
+	struct virtio_crypto_request *vc_req = &vc_sym_req->base;
 	unsigned int ivsize = crypto_ablkcipher_ivsize(tfm);
-	struct virtio_crypto_ablkcipher_ctx *ctx = vc_req->ablkcipher_ctx;
 	struct virtio_crypto *vcrypto = ctx->vcrypto;
 	struct virtio_crypto_op_data_req *req_data;
 	int src_nents, dst_nents;
@@ -326,9 +383,9 @@ __virtio_crypto_ablkcipher_do_req(struct virtio_crypto_request *vc_req,
 	}
 
 	vc_req->req_data = req_data;
-	vc_req->type = VIRTIO_CRYPTO_SYM_OP_CIPHER;
+	vc_sym_req->type = VIRTIO_CRYPTO_SYM_OP_CIPHER;
 	/* Head of operation */
-	if (vc_req->encrypt) {
+	if (vc_sym_req->encrypt) {
 		req_data->header.session_id =
 			cpu_to_le64(ctx->enc_sess_info.session_id);
 		req_data->header.opcode =
@@ -383,7 +440,7 @@ __virtio_crypto_ablkcipher_do_req(struct virtio_crypto_request *vc_req,
 	memcpy(iv, req->info, ivsize);
 	sg_init_one(&iv_sg, iv, ivsize);
 	sgs[num_out++] = &iv_sg;
-	vc_req->iv = iv;
+	vc_sym_req->iv = iv;
 
 	/* Source data */
 	for (i = 0; i < src_nents; i++)
@@ -421,15 +478,18 @@ static int virtio_crypto_ablkcipher_encrypt(struct ablkcipher_request *req)
 {
 	struct crypto_ablkcipher *atfm = crypto_ablkcipher_reqtfm(req);
 	struct virtio_crypto_ablkcipher_ctx *ctx = crypto_ablkcipher_ctx(atfm);
-	struct virtio_crypto_request *vc_req = ablkcipher_request_ctx(req);
+	struct virtio_crypto_sym_request *vc_sym_req =
+				ablkcipher_request_ctx(req);
+	struct virtio_crypto_request *vc_req = &vc_sym_req->base;
 	struct virtio_crypto *vcrypto = ctx->vcrypto;
 	/* Use the first data virtqueue as default */
 	struct data_queue *data_vq = &vcrypto->data_vq[0];
 
-	vc_req->ablkcipher_ctx = ctx;
-	vc_req->ablkcipher_req = req;
-	vc_req->encrypt = true;
 	vc_req->dataq = data_vq;
+	vc_req->alg_cb = virtio_crypto_dataq_sym_callback;
+	vc_sym_req->ablkcipher_ctx = ctx;
+	vc_sym_req->ablkcipher_req = req;
+	vc_sym_req->encrypt = true;
 
 	return crypto_transfer_cipher_request_to_engine(data_vq->engine, req);
 }
@@ -438,16 +498,18 @@ static int virtio_crypto_ablkcipher_decrypt(struct ablkcipher_request *req)
 {
 	struct crypto_ablkcipher *atfm = crypto_ablkcipher_reqtfm(req);
 	struct virtio_crypto_ablkcipher_ctx *ctx = crypto_ablkcipher_ctx(atfm);
-	struct virtio_crypto_request *vc_req = ablkcipher_request_ctx(req);
+	struct virtio_crypto_sym_request *vc_sym_req =
+				ablkcipher_request_ctx(req);
+	struct virtio_crypto_request *vc_req = &vc_sym_req->base;
 	struct virtio_crypto *vcrypto = ctx->vcrypto;
 	/* Use the first data virtqueue as default */
 	struct data_queue *data_vq = &vcrypto->data_vq[0];
 
-	vc_req->ablkcipher_ctx = ctx;
-	vc_req->ablkcipher_req = req;
-
-	vc_req->encrypt = false;
 	vc_req->dataq = data_vq;
+	vc_req->alg_cb = virtio_crypto_dataq_sym_callback;
+	vc_sym_req->ablkcipher_ctx = ctx;
+	vc_sym_req->ablkcipher_req = req;
+	vc_sym_req->encrypt = false;
 
 	return crypto_transfer_cipher_request_to_engine(data_vq->engine, req);
 }
@@ -456,7 +518,7 @@ static int virtio_crypto_ablkcipher_init(struct crypto_tfm *tfm)
 {
 	struct virtio_crypto_ablkcipher_ctx *ctx = crypto_tfm_ctx(tfm);
 
-	tfm->crt_ablkcipher.reqsize = sizeof(struct virtio_crypto_request);
+	tfm->crt_ablkcipher.reqsize = sizeof(struct virtio_crypto_sym_request);
 	ctx->tfm = tfm;
 
 	return 0;
@@ -479,11 +541,13 @@ int virtio_crypto_ablkcipher_crypt_req(
 	struct crypto_engine *engine,
 	struct ablkcipher_request *req)
 {
-	struct virtio_crypto_request *vc_req = ablkcipher_request_ctx(req);
+	struct virtio_crypto_sym_request *vc_sym_req =
+				ablkcipher_request_ctx(req);
+	struct virtio_crypto_request *vc_req = &vc_sym_req->base;
 	struct data_queue *data_vq = vc_req->dataq;
 	int ret;
 
-	ret = __virtio_crypto_ablkcipher_do_req(vc_req, req, data_vq);
+	ret = __virtio_crypto_ablkcipher_do_req(vc_sym_req, req, data_vq);
 	if (ret < 0)
 		return ret;
 
@@ -492,14 +556,15 @@ int virtio_crypto_ablkcipher_crypt_req(
 	return 0;
 }
 
-void virtio_crypto_ablkcipher_finalize_req(
-	struct virtio_crypto_request *vc_req,
+static void virtio_crypto_ablkcipher_finalize_req(
+	struct virtio_crypto_sym_request *vc_sym_req,
 	struct ablkcipher_request *req,
 	int err)
 {
-	crypto_finalize_cipher_request(vc_req->dataq->engine, req, err);
-
-	virtcrypto_clear_request(vc_req);
+	crypto_finalize_cipher_request(vc_sym_req->base.dataq->engine,
+					req, err);
+	kzfree(vc_sym_req->iv);
+	virtcrypto_clear_request(&vc_sym_req->base);
 }
 
 static struct crypto_alg virtio_crypto_algs[] = { {
diff --git a/drivers/crypto/virtio/virtio_crypto_common.h b/drivers/crypto/virtio/virtio_crypto_common.h
index da6d8c0..e976539 100644
--- a/drivers/crypto/virtio/virtio_crypto_common.h
+++ b/drivers/crypto/virtio/virtio_crypto_common.h
@@ -83,26 +83,16 @@ struct virtio_crypto_sym_session_info {
 	__u64 session_id;
 };
 
-struct virtio_crypto_ablkcipher_ctx {
-	struct virtio_crypto *vcrypto;
-	struct crypto_tfm *tfm;
-
-	struct virtio_crypto_sym_session_info enc_sess_info;
-	struct virtio_crypto_sym_session_info dec_sess_info;
-};
+struct virtio_crypto_request;
+typedef void (*virtio_crypto_data_callback)
+		(struct virtio_crypto_request *vc_req, int len);
 
 struct virtio_crypto_request {
-	/* Cipher or aead */
-	uint32_t type;
 	uint8_t status;
-	struct virtio_crypto_ablkcipher_ctx *ablkcipher_ctx;
-	struct ablkcipher_request *ablkcipher_req;
 	struct virtio_crypto_op_data_req *req_data;
 	struct scatterlist **sgs;
-	uint8_t *iv;
-	/* Encryption? */
-	bool encrypt;
 	struct data_queue *dataq;
+	virtio_crypto_data_callback alg_cb;
 };
 
 int virtcrypto_devmgr_add_dev(struct virtio_crypto *vcrypto_dev);
@@ -119,10 +109,6 @@ void virtcrypto_dev_stop(struct virtio_crypto *vcrypto);
 int virtio_crypto_ablkcipher_crypt_req(
 	struct crypto_engine *engine,
 	struct ablkcipher_request *req);
-void virtio_crypto_ablkcipher_finalize_req(
-	struct virtio_crypto_request *vc_req,
-	struct ablkcipher_request *req,
-	int err);
 
 void
 virtcrypto_clear_request(struct virtio_crypto_request *vc_req);
diff --git a/drivers/crypto/virtio/virtio_crypto_core.c b/drivers/crypto/virtio/virtio_crypto_core.c
index 21472e4..5752d4c 100644
--- a/drivers/crypto/virtio/virtio_crypto_core.c
+++ b/drivers/crypto/virtio/virtio_crypto_core.c
@@ -29,7 +29,6 @@ void
 virtcrypto_clear_request(struct virtio_crypto_request *vc_req)
 {
 	if (vc_req) {
-		kzfree(vc_req->iv);
 		kzfree(vc_req->req_data);
 		kfree(vc_req->sgs);
 	}
@@ -41,40 +40,18 @@ static void virtcrypto_dataq_callback(struct virtqueue *vq)
 	struct virtio_crypto_request *vc_req;
 	unsigned long flags;
 	unsigned int len;
-	struct ablkcipher_request *ablk_req;
-	int error;
 	unsigned int qid = vq->index;
 
 	spin_lock_irqsave(&vcrypto->data_vq[qid].lock, flags);
 	do {
 		virtqueue_disable_cb(vq);
 		while ((vc_req = virtqueue_get_buf(vq, &len)) != NULL) {
-			if (vc_req->type == VIRTIO_CRYPTO_SYM_OP_CIPHER) {
-				switch (vc_req->status) {
-				case VIRTIO_CRYPTO_OK:
-					error = 0;
-					break;
-				case VIRTIO_CRYPTO_INVSESS:
-				case VIRTIO_CRYPTO_ERR:
-					error = -EINVAL;
-					break;
-				case VIRTIO_CRYPTO_BADMSG:
-					error = -EBADMSG;
-					break;
-				default:
-					error = -EIO;
-					break;
-				}
-				ablk_req = vc_req->ablkcipher_req;
-
-				spin_unlock_irqrestore(
-					&vcrypto->data_vq[qid].lock, flags);
-				/* Finish the encrypt or decrypt process */
-				virtio_crypto_ablkcipher_finalize_req(vc_req,
-				    ablk_req, error);
-				spin_lock_irqsave(
-					&vcrypto->data_vq[qid].lock, flags);
-			}
+			spin_unlock_irqrestore(
+				&vcrypto->data_vq[qid].lock, flags);
+			if (vc_req->alg_cb)
+				vc_req->alg_cb(vc_req, len);
+			spin_lock_irqsave(
+				&vcrypto->data_vq[qid].lock, flags);
 		}
 	} while (!virtqueue_enable_cb(vq));
 	spin_unlock_irqrestore(&vcrypto->data_vq[qid].lock, flags);
@@ -271,7 +248,7 @@ static int virtcrypto_update_status(struct virtio_crypto *vcrypto)
 
 			return -EPERM;
 		}
-		dev_info(&vcrypto->vdev->dev, "Accelerator is ready\n");
+		dev_info(&vcrypto->vdev->dev, "Accelerator device is ready\n");
 	} else {
 		virtcrypto_dev_stop(vcrypto);
 		dev_info(&vcrypto->vdev->dev, "Accelerator is not ready\n");
-- 
2.4.11
