From: Farhan Ali <alifm@linux.ibm.com>
Subject: [PATCH v3 2/2] crypto/virtio-crypto: Register an algo only if it's supported
Date: Tue, 19 Jun 2018 11:41:34 -0400
Message-ID: <265cd2e92b6241e123041933301bcfb76e554a88.1529422492.git.alifm@linux.ibm.com>
References: <cover.1529422492.git.alifm@linux.ibm.com>
Cc: qemu-devel@nongnu.org, herbert@gondor.apana.org.au,
        borntraeger@de.ibm.com, arei.gonglei@huawei.com,
        longpeng2@huawei.com, pasic@linux.ibm.com, frankja@linux.ibm.com,
        jasowang@redhat.com, mst@redhat.com
To: linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <cover.1529422492.git.alifm@linux.ibm.com>
In-Reply-To: <cover.1529422492.git.alifm@linux.ibm.com>
References: <cover.1529422492.git.alifm@linux.ibm.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

From: Farhan Ali <alifm@linux.vnet.ibm.com>

Register a crypto algo with the Linux crypto layer only if
the algorithm is supported by the backend virtio-crypto
device.

Also route crypto requests to a virtio-crypto
device, only if it can support the requested service and
algorithm.

Signed-off-by: Farhan Ali <alifm@linux.ibm.com>
Acked-by: Gonglei <arei.gonglei@huawei.com>
Acked-by: Christian Borntraeger <borntraeger@de.ibm.com>
---
 drivers/crypto/virtio/virtio_crypto_algs.c   | 112 ++++++++++++++++++---------
 drivers/crypto/virtio/virtio_crypto_common.h |  11 ++-
 drivers/crypto/virtio/virtio_crypto_mgr.c    |  81 +++++++++++++++++--
 3 files changed, 159 insertions(+), 45 deletions(-)

diff --git a/drivers/crypto/virtio/virtio_crypto_algs.c b/drivers/crypto/virtio/virtio_crypto_algs.c
index af6a908..7a104f6 100644
--- a/drivers/crypto/virtio/virtio_crypto_algs.c
+++ b/drivers/crypto/virtio/virtio_crypto_algs.c
@@ -49,12 +49,18 @@ struct virtio_crypto_sym_request {
 	bool encrypt;
 };
 
+struct virtio_crypto_algo {
+	uint32_t algonum;
+	uint32_t service;
+	unsigned int active_devs;
+	struct crypto_alg algo;
+};
+
 /*
  * The algs_lock protects the below global virtio_crypto_active_devs
  * and crypto algorithms registion.
  */
 static DEFINE_MUTEX(algs_lock);
-static unsigned int virtio_crypto_active_devs;
 static void virtio_crypto_ablkcipher_finalize_req(
 	struct virtio_crypto_sym_request *vc_sym_req,
 	struct ablkcipher_request *req,
@@ -312,15 +318,21 @@ static int virtio_crypto_ablkcipher_setkey(struct crypto_ablkcipher *tfm,
 					 unsigned int keylen)
 {
 	struct virtio_crypto_ablkcipher_ctx *ctx = crypto_ablkcipher_ctx(tfm);
+	uint32_t alg;
 	int ret;
 
+	ret = virtio_crypto_alg_validate_key(keylen, &alg);
+	if (ret)
+		return ret;
+
 	if (!ctx->vcrypto) {
 		/* New key */
 		int node = virtio_crypto_get_current_node();
 		struct virtio_crypto *vcrypto =
-				      virtcrypto_get_dev_node(node);
+				      virtcrypto_get_dev_node(node,
+				      VIRTIO_CRYPTO_SERVICE_CIPHER, alg);
 		if (!vcrypto) {
-			pr_err("virtio_crypto: Could not find a virtio device in the system\n");
+			pr_err("virtio_crypto: Could not find a virtio device in the system or unsupported algo\n");
 			return -ENODEV;
 		}
 
@@ -571,57 +583,85 @@ static void virtio_crypto_ablkcipher_finalize_req(
 	virtcrypto_clear_request(&vc_sym_req->base);
 }
 
-static struct crypto_alg virtio_crypto_algs[] = { {
-	.cra_name = "cbc(aes)",
-	.cra_driver_name = "virtio_crypto_aes_cbc",
-	.cra_priority = 150,
-	.cra_flags = CRYPTO_ALG_TYPE_ABLKCIPHER | CRYPTO_ALG_ASYNC,
-	.cra_blocksize = AES_BLOCK_SIZE,
-	.cra_ctxsize  = sizeof(struct virtio_crypto_ablkcipher_ctx),
-	.cra_alignmask = 0,
-	.cra_module = THIS_MODULE,
-	.cra_type = &crypto_ablkcipher_type,
-	.cra_init = virtio_crypto_ablkcipher_init,
-	.cra_exit = virtio_crypto_ablkcipher_exit,
-	.cra_u = {
-	   .ablkcipher = {
-			.setkey = virtio_crypto_ablkcipher_setkey,
-			.decrypt = virtio_crypto_ablkcipher_decrypt,
-			.encrypt = virtio_crypto_ablkcipher_encrypt,
-			.min_keysize = AES_MIN_KEY_SIZE,
-			.max_keysize = AES_MAX_KEY_SIZE,
-			.ivsize = AES_BLOCK_SIZE,
+static struct virtio_crypto_algo virtio_crypto_algs[] = { {
+	.algonum = VIRTIO_CRYPTO_CIPHER_AES_CBC,
+	.service = VIRTIO_CRYPTO_SERVICE_CIPHER,
+	.algo = {
+		.cra_name = "cbc(aes)",
+		.cra_driver_name = "virtio_crypto_aes_cbc",
+		.cra_priority = 150,
+		.cra_flags = CRYPTO_ALG_TYPE_ABLKCIPHER | CRYPTO_ALG_ASYNC,
+		.cra_blocksize = AES_BLOCK_SIZE,
+		.cra_ctxsize  = sizeof(struct virtio_crypto_ablkcipher_ctx),
+		.cra_alignmask = 0,
+		.cra_module = THIS_MODULE,
+		.cra_type = &crypto_ablkcipher_type,
+		.cra_init = virtio_crypto_ablkcipher_init,
+		.cra_exit = virtio_crypto_ablkcipher_exit,
+		.cra_u = {
+			.ablkcipher = {
+				.setkey = virtio_crypto_ablkcipher_setkey,
+				.decrypt = virtio_crypto_ablkcipher_decrypt,
+				.encrypt = virtio_crypto_ablkcipher_encrypt,
+				.min_keysize = AES_MIN_KEY_SIZE,
+				.max_keysize = AES_MAX_KEY_SIZE,
+				.ivsize = AES_BLOCK_SIZE,
+			},
 		},
 	},
 } };
 
-int virtio_crypto_algs_register(void)
+int virtio_crypto_algs_register(struct virtio_crypto *vcrypto)
 {
 	int ret = 0;
+	int i = 0;
 
 	mutex_lock(&algs_lock);
-	if (++virtio_crypto_active_devs != 1)
-		goto unlock;
 
-	ret = crypto_register_algs(virtio_crypto_algs,
-			ARRAY_SIZE(virtio_crypto_algs));
-	if (ret)
-		virtio_crypto_active_devs--;
+	for (i = 0; i < ARRAY_SIZE(virtio_crypto_algs); i++) {
+
+		uint32_t service = virtio_crypto_algs[i].service;
+		uint32_t algonum = virtio_crypto_algs[i].algonum;
+
+		if (!virtcrypto_algo_is_supported(vcrypto, service, algonum))
+			continue;
+
+		if (virtio_crypto_algs[i].active_devs == 0) {
+			ret = crypto_register_alg(&virtio_crypto_algs[i].algo);
+			if (ret)
+				goto unlock;
+		}
+
+		virtio_crypto_algs[i].active_devs++;
+		dev_info(&vcrypto->vdev->dev, "Registered algo %s\n",
+			 virtio_crypto_algs[i].algo.cra_name);
+	}
 
 unlock:
 	mutex_unlock(&algs_lock);
 	return ret;
 }
 
-void virtio_crypto_algs_unregister(void)
+void virtio_crypto_algs_unregister(struct virtio_crypto *vcrypto)
 {
+	int i = 0;
+
 	mutex_lock(&algs_lock);
-	if (--virtio_crypto_active_devs != 0)
-		goto unlock;
 
-	crypto_unregister_algs(virtio_crypto_algs,
-			ARRAY_SIZE(virtio_crypto_algs));
+	for (i = 0; i < ARRAY_SIZE(virtio_crypto_algs); i++) {
+
+		uint32_t service = virtio_crypto_algs[i].service;
+		uint32_t algonum = virtio_crypto_algs[i].algonum;
+
+		if (virtio_crypto_algs[i].active_devs == 0 ||
+		    !virtcrypto_algo_is_supported(vcrypto, service, algonum))
+			continue;
+
+		if (virtio_crypto_algs[i].active_devs == 1)
+			crypto_unregister_alg(&virtio_crypto_algs[i].algo);
+
+		virtio_crypto_algs[i].active_devs--;
+	}
 
-unlock:
 	mutex_unlock(&algs_lock);
 }
diff --git a/drivers/crypto/virtio/virtio_crypto_common.h b/drivers/crypto/virtio/virtio_crypto_common.h
index 931a3bd..63ef7f7 100644
--- a/drivers/crypto/virtio/virtio_crypto_common.h
+++ b/drivers/crypto/virtio/virtio_crypto_common.h
@@ -116,7 +116,12 @@ int virtcrypto_dev_in_use(struct virtio_crypto *vcrypto_dev);
 int virtcrypto_dev_get(struct virtio_crypto *vcrypto_dev);
 void virtcrypto_dev_put(struct virtio_crypto *vcrypto_dev);
 int virtcrypto_dev_started(struct virtio_crypto *vcrypto_dev);
-struct virtio_crypto *virtcrypto_get_dev_node(int node);
+bool virtcrypto_algo_is_supported(struct virtio_crypto *vcrypto_dev,
+				  uint32_t service,
+				  uint32_t algo);
+struct virtio_crypto *virtcrypto_get_dev_node(int node,
+					      uint32_t service,
+					      uint32_t algo);
 int virtcrypto_dev_start(struct virtio_crypto *vcrypto);
 void virtcrypto_dev_stop(struct virtio_crypto *vcrypto);
 int virtio_crypto_ablkcipher_crypt_req(
@@ -136,7 +141,7 @@ static inline int virtio_crypto_get_current_node(void)
 	return node;
 }
 
-int virtio_crypto_algs_register(void);
-void virtio_crypto_algs_unregister(void);
+int virtio_crypto_algs_register(struct virtio_crypto *vcrypto);
+void virtio_crypto_algs_unregister(struct virtio_crypto *vcrypto);
 
 #endif /* _VIRTIO_CRYPTO_COMMON_H */
diff --git a/drivers/crypto/virtio/virtio_crypto_mgr.c b/drivers/crypto/virtio/virtio_crypto_mgr.c
index a69ff71..d70de3a 100644
--- a/drivers/crypto/virtio/virtio_crypto_mgr.c
+++ b/drivers/crypto/virtio/virtio_crypto_mgr.c
@@ -181,14 +181,20 @@ int virtcrypto_dev_started(struct virtio_crypto *vcrypto_dev)
 /*
  * virtcrypto_get_dev_node() - Get vcrypto_dev on the node.
  * @node:  Node id the driver works.
+ * @service: Crypto service that needs to be supported by the
+ *	      dev
+ * @algo: The algorithm number that needs to be supported by the
+ *	  dev
  *
- * Function returns the virtio crypto device used fewest on the node.
+ * Function returns the virtio crypto device used fewest on the node,
+ * and supports the given crypto service and algorithm.
  *
  * To be used by virtio crypto device specific drivers.
  *
  * Return: pointer to vcrypto_dev or NULL if not found.
  */
-struct virtio_crypto *virtcrypto_get_dev_node(int node)
+struct virtio_crypto *virtcrypto_get_dev_node(int node, uint32_t service,
+					      uint32_t algo)
 {
 	struct virtio_crypto *vcrypto_dev = NULL, *tmp_dev;
 	unsigned long best = ~0;
@@ -199,7 +205,8 @@ struct virtio_crypto *virtcrypto_get_dev_node(int node)
 
 		if ((node == dev_to_node(&tmp_dev->vdev->dev) ||
 		     dev_to_node(&tmp_dev->vdev->dev) < 0) &&
-		    virtcrypto_dev_started(tmp_dev)) {
+		    virtcrypto_dev_started(tmp_dev) &&
+		    virtcrypto_algo_is_supported(tmp_dev, service, algo)) {
 			ctr = atomic_read(&tmp_dev->ref_count);
 			if (best > ctr) {
 				vcrypto_dev = tmp_dev;
@@ -214,7 +221,9 @@ struct virtio_crypto *virtcrypto_get_dev_node(int node)
 		/* Get any started device */
 		list_for_each_entry(tmp_dev,
 				virtcrypto_devmgr_get_head(), list) {
-			if (virtcrypto_dev_started(tmp_dev)) {
+			if (virtcrypto_dev_started(tmp_dev) &&
+			    virtcrypto_algo_is_supported(tmp_dev,
+			    service, algo)) {
 				vcrypto_dev = tmp_dev;
 				break;
 			}
@@ -240,7 +249,7 @@ struct virtio_crypto *virtcrypto_get_dev_node(int node)
  */
 int virtcrypto_dev_start(struct virtio_crypto *vcrypto)
 {
-	if (virtio_crypto_algs_register()) {
+	if (virtio_crypto_algs_register(vcrypto)) {
 		pr_err("virtio_crypto: Failed to register crypto algs\n");
 		return -EFAULT;
 	}
@@ -260,5 +269,65 @@ int virtcrypto_dev_start(struct virtio_crypto *vcrypto)
  */
 void virtcrypto_dev_stop(struct virtio_crypto *vcrypto)
 {
-	virtio_crypto_algs_unregister();
+	virtio_crypto_algs_unregister(vcrypto);
+}
+
+/*
+ * vcrypto_algo_is_supported()
+ * @vcrypto: Pointer to virtio crypto device.
+ * @service: The bit number for service validate.
+ *	      See VIRTIO_CRYPTO_SERVICE_*
+ * @algo : The bit number for the algorithm to validate.
+ *
+ *
+ * Validate if the virtio crypto device supports a service and
+ * algo.
+ *
+ * Return true if device supports a service and algo.
+ */
+
+bool virtcrypto_algo_is_supported(struct virtio_crypto *vcrypto,
+				  uint32_t service,
+				  uint32_t algo)
+{
+	uint32_t service_mask = 1u << service;
+	uint32_t algo_mask = 0;
+	bool low = true;
+
+	if (algo > 31) {
+		algo -= 32;
+		low = false;
+	}
+
+	if (!(vcrypto->crypto_services & service_mask))
+		return false;
+
+	switch (service) {
+	case VIRTIO_CRYPTO_SERVICE_CIPHER:
+		if (low)
+			algo_mask = vcrypto->cipher_algo_l;
+		else
+			algo_mask = vcrypto->cipher_algo_h;
+		break;
+
+	case VIRTIO_CRYPTO_SERVICE_HASH:
+		algo_mask = vcrypto->hash_algo;
+		break;
+
+	case VIRTIO_CRYPTO_SERVICE_MAC:
+		if (low)
+			algo_mask = vcrypto->mac_algo_l;
+		else
+			algo_mask = vcrypto->mac_algo_h;
+		break;
+
+	case VIRTIO_CRYPTO_SERVICE_AEAD:
+		algo_mask = vcrypto->aead_algo;
+		break;
+	}
+
+	if (!(algo_mask & (1u << algo)))
+		return false;
+
+	return true;
 }
-- 
2.7.4
