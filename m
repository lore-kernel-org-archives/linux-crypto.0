From: Gonglei <arei.gonglei@huawei.com>
Subject: [PATCH v2] virtio-crypto: adjust priority of algorithm
Date: Fri, 13 Jan 2017 17:34:16 +0800
Message-ID: <1484300056-35284-1-git-send-email-arei.gonglei@huawei.com>
Mime-Version: 1.0
Content-Type: text/plain
Cc: <mst@redhat.com>, <herbert@gondor.apana.org.au>,
        <borntraeger@de.ibm.com>, Gonglei <arei.gonglei@huawei.com>
To: <virtualization@lists.linux-foundation.org>,
        <linux-crypto@vger.kernel.org>, <linux-kernel@vger.kernel.org>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from szxga03-in.huawei.com ([119.145.14.66]:55298 "EHLO
        szxga03-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751345AbdAMJeu (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 13 Jan 2017 04:34:50 -0500
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Some hardware accelerators (like intel aesni or the s390
cpacf functions) have lower priorities than virtio
crypto, and those drivers are faster than the same in
the host via virtio. So let's lower the priority of
virtio-crypto's algorithm, make it's higher than software
implementations but lower than the hardware ones.

Suggested-by: Christian Borntraeger <borntraeger@de.ibm.com>
Signed-off-by: Gonglei <arei.gonglei@huawei.com>
Acked-by: Christian Borntraeger <borntraeger@de.ibm.com>
---
v2:
    fix three typos. [Christian]
---
 drivers/crypto/virtio/virtio_crypto_algs.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/crypto/virtio/virtio_crypto_algs.c b/drivers/crypto/virtio/virtio_crypto_algs.c
index 6f40a42..4de4740 100644
--- a/drivers/crypto/virtio/virtio_crypto_algs.c
+++ b/drivers/crypto/virtio/virtio_crypto_algs.c
@@ -498,7 +498,7 @@ void virtio_crypto_ablkcipher_finalize_req(
 static struct crypto_alg virtio_crypto_algs[] = { {
 	.cra_name = "cbc(aes)",
 	.cra_driver_name = "virtio_crypto_aes_cbc",
-	.cra_priority = 501,
+	.cra_priority = 150,
 	.cra_flags = CRYPTO_ALG_TYPE_ABLKCIPHER | CRYPTO_ALG_ASYNC,
 	.cra_blocksize = AES_BLOCK_SIZE,
 	.cra_ctxsize  = sizeof(struct virtio_crypto_ablkcipher_ctx),
-- 
1.8.3.1
