Authentication-Results: smtp.subspace.kernel.org; dkim=none
Received: from szxga01-in.huawei.com (szxga01-in.huawei.com [45.249.212.187])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 250A69D;
	Mon, 20 Nov 2023 03:49:48 -0800 (PST)
Received: from dggpemm100005.china.huawei.com (unknown [172.30.72.55])
	by szxga01-in.huawei.com (SkyGuard) with ESMTP id 4SYm4z6HnFzvQth;
	Mon, 20 Nov 2023 19:49:23 +0800 (CST)
Received: from dggpemm500006.china.huawei.com (7.185.36.236) by
 dggpemm100005.china.huawei.com (7.185.36.231) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.35; Mon, 20 Nov 2023 19:49:45 +0800
Received: from dggpemm500006.china.huawei.com ([7.185.36.236]) by
 dggpemm500006.china.huawei.com ([7.185.36.236]) with mapi id 15.01.2507.035;
 Mon, 20 Nov 2023 19:49:45 +0800
From: "Gonglei (Arei)" <arei.gonglei@huawei.com>
To: Herbert Xu <herbert@gondor.apana.org.au>, "linux-crypto@vger.kernel.org"
	<linux-crypto@vger.kernel.org>, Halil Pasic <pasic@linux.ibm.com>
CC: "Michael S. Tsirkin" <mst@redhat.com>, Jason Wang <jasowang@redhat.com>,
	"virtualization@lists.linux-foundation.org"
	<virtualization@lists.linux-foundation.org>, "linux-kernel@vger.kernel.org"
	<linux-kernel@vger.kernel.org>, wangyangxin <wangyangxin1@huawei.com>,
	"Gonglei (Arei)" <arei.gonglei@huawei.com>
Subject: [PATCH] crypto: virtio-crypto: Handle dataq logic  with tasklet
Thread-Topic: [PATCH] crypto: virtio-crypto: Handle dataq logic  with tasklet
Thread-Index: Adobp2Ma20NfNCVRS52WT53esc9NTA==
Date: Mon, 20 Nov 2023 11:49:45 +0000
Message-ID: <b2fe5c6a60984a9e91bd9dea419c5154@huawei.com>
Accept-Language: zh-CN, en-US
Content-Language: zh-CN
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
x-originating-ip: [10.174.149.11]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-CFilter-Loop: Reflected

Doing ipsec produces a spinlock recursion warning.
This is due to crypto_finalize_request() being called in the upper half.
Move virtual data queue processing of virtio-crypto driver to tasklet.

Fixes: dbaf0624ffa57 ("crypto: add virtio-crypto driver")
Reported-by: Halil Pasic <pasic@linux.ibm.com>
Signed-off-by: wangyangxin <wangyangxin1@huawei.com>
Signed-off-by: Gonglei <arei.gonglei@huawei.com>
---
 drivers/crypto/virtio/virtio_crypto_common.h |  2 ++
 drivers/crypto/virtio/virtio_crypto_core.c   | 23 +++++++++++++----------
 2 files changed, 15 insertions(+), 10 deletions(-)

diff --git a/drivers/crypto/virtio/virtio_crypto_common.h b/drivers/crypto/=
virtio/virtio_crypto_common.h
index 59a4c02..5c17c6e 100644
--- a/drivers/crypto/virtio/virtio_crypto_common.h
+++ b/drivers/crypto/virtio/virtio_crypto_common.h
@@ -10,6 +10,7 @@
 #include <linux/virtio.h>
 #include <linux/crypto.h>
 #include <linux/spinlock.h>
+#include <linux/interrupt.h>
 #include <crypto/aead.h>
 #include <crypto/aes.h>
 #include <crypto/engine.h>
@@ -28,6 +29,7 @@ struct data_queue {
 	char name[32];
=20
 	struct crypto_engine *engine;
+	struct tasklet_struct done_task;
 };
=20
 struct virtio_crypto {
diff --git a/drivers/crypto/virtio/virtio_crypto_core.c b/drivers/crypto/vi=
rtio/virtio_crypto_core.c
index 1198bd3..e747f4f 100644
--- a/drivers/crypto/virtio/virtio_crypto_core.c
+++ b/drivers/crypto/virtio/virtio_crypto_core.c
@@ -72,27 +72,28 @@ int virtio_crypto_ctrl_vq_request(struct virtio_crypto =
*vcrypto, struct scatterl
 	return 0;
 }
=20
-static void virtcrypto_dataq_callback(struct virtqueue *vq)
+static void virtcrypto_done_task(unsigned long data)
 {
-	struct virtio_crypto *vcrypto =3D vq->vdev->priv;
+	struct data_queue *data_vq =3D (struct data_queue *)data;
+	struct virtqueue *vq =3D data_vq->vq;
 	struct virtio_crypto_request *vc_req;
-	unsigned long flags;
 	unsigned int len;
-	unsigned int qid =3D vq->index;
=20
-	spin_lock_irqsave(&vcrypto->data_vq[qid].lock, flags);
 	do {
 		virtqueue_disable_cb(vq);
 		while ((vc_req =3D virtqueue_get_buf(vq, &len)) !=3D NULL) {
-			spin_unlock_irqrestore(
-				&vcrypto->data_vq[qid].lock, flags);
 			if (vc_req->alg_cb)
 				vc_req->alg_cb(vc_req, len);
-			spin_lock_irqsave(
-				&vcrypto->data_vq[qid].lock, flags);
 		}
 	} while (!virtqueue_enable_cb(vq));
-	spin_unlock_irqrestore(&vcrypto->data_vq[qid].lock, flags);
+}
+
+static void virtcrypto_dataq_callback(struct virtqueue *vq)
+{
+	struct virtio_crypto *vcrypto =3D vq->vdev->priv;
+	struct data_queue *dq =3D &vcrypto->data_vq[vq->index];
+
+	tasklet_schedule(&dq->done_task);
 }
=20
 static int virtcrypto_find_vqs(struct virtio_crypto *vi)
@@ -150,6 +151,8 @@ static int virtcrypto_find_vqs(struct virtio_crypto *vi=
)
 			ret =3D -ENOMEM;
 			goto err_engine;
 		}
+		tasklet_init(&vi->data_vq[i].done_task, virtcrypto_done_task,
+				(unsigned long)&vi->data_vq[i]);
 	}
=20
 	kfree(names);
--=20
1.8.3.1



