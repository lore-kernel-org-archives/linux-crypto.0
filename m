From: Jia-Ju Bai <baijiaju1990@gmail.com>
Subject: [PATCH] crypto: virtio: Replace GFP_ATOMIC with GFP_KERNEL in __virtio_crypto_ablkcipher_do_req()
Date: Mon, 23 Jul 2018 16:43:46 +0800
Message-ID: <20180723084346.16488-1-baijiaju1990@gmail.com>
Cc: virtualization@lists.linux-foundation.org,
        linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
        Jia-Ju Bai <baijiaju1990@gmail.com>
To: mst@redhat.com, jasowang@redhat.com, arei.gonglei@huawei.com,
        herbert@gondor.apana.org.au, davem@davemloft.net
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

__virtio_crypto_ablkcipher_do_req() is never called in atomic context.

__virtio_crypto_ablkcipher_do_req() is only called by 
virtio_crypto_ablkcipher_crypt_req(), which is only called by 
virtcrypto_find_vqs() that is never called in atomic context.

__virtio_crypto_ablkcipher_do_req() calls kzalloc_node() with GFP_ATOMIC,
which is not necessary.
GFP_ATOMIC can be replaced with GFP_KERNEL.

This is found by a static analysis tool named DCNS written by myself.
I also manually check the kernel code before reporting it.

Signed-off-by: Jia-Ju Bai <baijiaju1990@gmail.com>
---
 drivers/crypto/virtio/virtio_crypto_algs.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/crypto/virtio/virtio_crypto_algs.c b/drivers/crypto/virtio/virtio_crypto_algs.c
index ba190cfa7aa1..83bcc83dae43 100644
--- a/drivers/crypto/virtio/virtio_crypto_algs.c
+++ b/drivers/crypto/virtio/virtio_crypto_algs.c
@@ -371,12 +371,12 @@ __virtio_crypto_ablkcipher_do_req(struct virtio_crypto_sym_request *vc_sym_req,
 
 	/* Why 3?  outhdr + iv + inhdr */
 	sg_total = src_nents + dst_nents + 3;
-	sgs = kzalloc_node(sg_total * sizeof(*sgs), GFP_ATOMIC,
+	sgs = kzalloc_node(sg_total * sizeof(*sgs), GFP_KERNEL,
 				dev_to_node(&vcrypto->vdev->dev));
 	if (!sgs)
 		return -ENOMEM;
 
-	req_data = kzalloc_node(sizeof(*req_data), GFP_ATOMIC,
+	req_data = kzalloc_node(sizeof(*req_data), GFP_KERNEL,
 				dev_to_node(&vcrypto->vdev->dev));
 	if (!req_data) {
 		kfree(sgs);
@@ -432,7 +432,7 @@ __virtio_crypto_ablkcipher_do_req(struct virtio_crypto_sym_request *vc_sym_req,
 	 * Avoid to do DMA from the stack, switch to using
 	 * dynamically-allocated for the IV
 	 */
-	iv = kzalloc_node(ivsize, GFP_ATOMIC,
+	iv = kzalloc_node(ivsize, GFP_KERNEL,
 				dev_to_node(&vcrypto->vdev->dev));
 	if (!iv) {
 		err = -ENOMEM;
-- 
2.17.0
