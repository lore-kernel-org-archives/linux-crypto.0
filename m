Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 417BC14AB8
	for <linux-crypto@vger.kernel.org>; Sun, 12 Nov 2023 16:52:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dkim=none
Received: from viti.kaiser.cx (viti.kaiser.cx [IPv6:2a01:238:43fe:e600:cd0c:bd4a:7a3:8e9f])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 64C071BEF;
	Sun, 12 Nov 2023 08:52:53 -0800 (PST)
Received: from dslb-188-097-210-154.188.097.pools.vodafone-ip.de ([188.97.210.154] helo=martin-debian-2.paytec.ch)
	by viti.kaiser.cx with esmtpsa (TLS1.2:ECDHE_RSA_AES_256_GCM_SHA384:256)
	(Exim 4.89)
	(envelope-from <martin@kaiser.cx>)
	id 1r2DhZ-0001WT-K8; Sun, 12 Nov 2023 17:52:49 +0100
From: Martin Kaiser <martin@kaiser.cx>
To: Herbert Xu <herbert@gondor.apana.org.au>
Cc: linux-crypto@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Martin Kaiser <martin@kaiser.cx>
Subject: [PATCH] hwrng: virtio - remove #ifdef guards for PM functions
Date: Sun, 12 Nov 2023 17:52:41 +0100
Message-Id: <20231112165241.176095-1-martin@kaiser.cx>
X-Mailer: git-send-email 2.39.2
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Use pm_sleep_ptr for the freeze and restore functions instead of putting
them under #ifdef CONFIG_PM_SLEEP. The resulting code is slightly simpler.

pm_sleep_ptr lets the compiler see the functions but also allows removing
them as unused code if !CONFIG_PM_SLEEP.

Signed-off-by: Martin Kaiser <martin@kaiser.cx>
---
compile-tested only, I do not have this hardware

 drivers/char/hw_random/virtio-rng.c | 8 ++------
 1 file changed, 2 insertions(+), 6 deletions(-)

diff --git a/drivers/char/hw_random/virtio-rng.c b/drivers/char/hw_random/virtio-rng.c
index e41a84e6b4b5..58d92d62ddfe 100644
--- a/drivers/char/hw_random/virtio-rng.c
+++ b/drivers/char/hw_random/virtio-rng.c
@@ -208,7 +208,6 @@ static void virtrng_scan(struct virtio_device *vdev)
 		vi->hwrng_register_done = true;
 }
 
-#ifdef CONFIG_PM_SLEEP
 static int virtrng_freeze(struct virtio_device *vdev)
 {
 	remove_common(vdev);
@@ -238,7 +237,6 @@ static int virtrng_restore(struct virtio_device *vdev)
 
 	return err;
 }
-#endif
 
 static const struct virtio_device_id id_table[] = {
 	{ VIRTIO_ID_RNG, VIRTIO_DEV_ANY_ID },
@@ -252,10 +250,8 @@ static struct virtio_driver virtio_rng_driver = {
 	.probe =	virtrng_probe,
 	.remove =	virtrng_remove,
 	.scan =		virtrng_scan,
-#ifdef CONFIG_PM_SLEEP
-	.freeze =	virtrng_freeze,
-	.restore =	virtrng_restore,
-#endif
+	.freeze =	pm_sleep_ptr(virtrng_freeze),
+	.restore =	pm_sleep_ptr(virtrng_restore),
 };
 
 module_virtio_driver(virtio_rng_driver);
-- 
2.39.2

