Received: from szxga02-in.huawei.com (szxga02-in.huawei.com [45.249.212.188])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 60A49172A;
	Wed,  6 Dec 2023 03:52:53 -0800 (PST)
Received: from dggpemm500008.china.huawei.com (unknown [172.30.72.54])
	by szxga02-in.huawei.com (SkyGuard) with ESMTP id 4SlbNX5kmdzWj91;
	Wed,  6 Dec 2023 19:51:56 +0800 (CST)
Received: from dggpemm500006.china.huawei.com (7.185.36.236) by
 dggpemm500008.china.huawei.com (7.185.36.136) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.35; Wed, 6 Dec 2023 19:52:51 +0800
Received: from dggpemm500006.china.huawei.com ([7.185.36.236]) by
 dggpemm500006.china.huawei.com ([7.185.36.236]) with mapi id 15.01.2507.035;
 Wed, 6 Dec 2023 19:52:51 +0800
From: "Gonglei (Arei)" <arei.gonglei@huawei.com>
To: Herbert Xu <herbert@gondor.apana.org.au>, "linux-crypto@vger.kernel.org"
	<linux-crypto@vger.kernel.org>
CC: "Michael S. Tsirkin" <mst@redhat.com>, Jason Wang <jasowang@redhat.com>,
	"virtualization@lists.linux-foundation.org"
	<virtualization@lists.linux-foundation.org>, "linux-kernel@vger.kernel.org"
	<linux-kernel@vger.kernel.org>, wangyangxin <wangyangxin1@huawei.com>,
	"Gonglei (Arei)" <arei.gonglei@huawei.com>, Halil Pasic <pasic@linux.ibm.com>
Subject: [PATCH v2] crypto: virtio-crypto: Handle dataq logic  with tasklet
Thread-Topic: [PATCH v2] crypto: virtio-crypto: Handle dataq logic  with
 tasklet
Thread-Index: AdooOneOWI65hKIST2yjTeZdqptiyQ==
Date: Wed, 6 Dec 2023 11:52:51 +0000
Message-ID: <ad8c946eb2294a7bb9eef26066c06b72@huawei.com>
Accept-Language: zh-CN, en-US
Content-Language: zh-CN
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
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

Fixes: dbaf0624ffa5 ("crypto: add virtio-crypto driver")
Reported-by: Halil Pasic <pasic@linux.ibm.com>
Signed-off-by: wangyangxin <wangyangxin1@huawei.com>
Signed-off-by: Gonglei <arei.gonglei@huawei.com>
---
 v2: calling tasklet_kill() in virtcrypto_remove(), thanks for MST.

 drivers/crypto/virtio/virtio_crypto_common.h |  2 ++
 drivers/crypto/virtio/virtio_crypto_core.c   | 26 ++++++++++++++++--------=
--
 2 files changed, 18 insertions(+), 10 deletions(-)

diff --git a/drivers/crypto/virtio/virtio_crypto_common.h b/drivers/crypto/=
virtio/virtio_crypto_common.h
index 154590e..7059bbe 100644
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
index 43a0838..b909c6a 100644
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
@@ -497,12 +500,15 @@ static void virtcrypto_free_unused_reqs(struct virtio=
_crypto *vcrypto)
 static void virtcrypto_remove(struct virtio_device *vdev)
 {
 	struct virtio_crypto *vcrypto =3D vdev->priv;
+	int i;
=20
 	dev_info(&vdev->dev, "Start virtcrypto_remove.\n");
=20
 	flush_work(&vcrypto->config_work);
 	if (virtcrypto_dev_started(vcrypto))
 		virtcrypto_dev_stop(vcrypto);
+	for (i =3D 0; i < vcrypto->max_data_queues; i++)
+		tasklet_kill(&vcrypto->data_vq[i].done_task);
 	virtio_reset_device(vdev);
 	virtcrypto_free_unused_reqs(vcrypto);
 	virtcrypto_clear_crypto_engines(vcrypto);
--=20
1.8.3.1
