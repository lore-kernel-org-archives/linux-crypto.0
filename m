From: "Michael S. Tsirkin" <mst@redhat.com>
Subject: [PATCH repost] virtio_rng: drop extra empty line
Date: Tue, 20 Jan 2015 14:35:15 +0200
Message-ID: <20150120123515.GA28318@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Matt Mackall <mpm@selenic.com>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	Rusty Russell <rusty@rustcorp.com.au>,
	Amit Shah <amit.shah@redhat.com>, Amos Kong <akong@redhat.com>,
	Sasha Levin <sasha.levin@oracle.com>,
	linux-crypto@vger.kernel.org
To: linux-kernel@vger.kernel.org
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

makes code look a bit prettier.

Cc: linux-crypto@vger.kernel.org.
Signed-off-by: Michael S. Tsirkin <mst@redhat.com>
---
 drivers/char/hw_random/virtio-rng.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/drivers/char/hw_random/virtio-rng.c b/drivers/char/hw_random/virtio-rng.c
index 72295ea..3fa2f8a 100644
--- a/drivers/char/hw_random/virtio-rng.c
+++ b/drivers/char/hw_random/virtio-rng.c
@@ -39,7 +39,6 @@ struct virtrng_info {
 	bool hwrng_removed;
 };
 
-
 static void random_recv_done(struct virtqueue *vq)
 {
 	struct virtrng_info *vi = vq->vdev->priv;
-- 
MST
