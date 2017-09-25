From: Arvind Yadav <arvind.yadav.cs@gmail.com>
Subject: [PATCH 2/5] crypto: virtio: pr_err() strings should end with newlines
Date: Mon, 25 Sep 2017 16:06:13 +0530
Message-ID: <1506335776-1887-3-git-send-email-arvind.yadav.cs@gmail.com>
References: <1506335776-1887-1-git-send-email-arvind.yadav.cs@gmail.com>
Cc: linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org
To: herbert@gondor.apana.org.au, davem@davemloft.net, mst@redhat.com,
        jasowang@redhat.com, arei.gonglei@huawei.com, harsh@chelsio.com,
        giovanni.cabiddu@intel.com, salvatore.benedetto@intel.com
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1506335776-1887-1-git-send-email-arvind.yadav.cs@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

pr_err() messages should terminated with a new-line to avoid
other messages being concatenated onto the end.

Signed-off-by: Arvind Yadav <arvind.yadav.cs@gmail.com>
---
 drivers/crypto/virtio/virtio_crypto_algs.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/crypto/virtio/virtio_crypto_algs.c b/drivers/crypto/virtio/virtio_crypto_algs.c
index 5035b0d..abe8c15 100644
--- a/drivers/crypto/virtio/virtio_crypto_algs.c
+++ b/drivers/crypto/virtio/virtio_crypto_algs.c
@@ -319,7 +319,7 @@ static int virtio_crypto_ablkcipher_setkey(struct crypto_ablkcipher *tfm,
 		struct virtio_crypto *vcrypto =
 				      virtcrypto_get_dev_node(node);
 		if (!vcrypto) {
-			pr_err("virtio_crypto: Could not find a virtio device in the system");
+			pr_err("virtio_crypto: Could not find a virtio device in the system\n");
 			return -ENODEV;
 		}
 
-- 
1.9.1
