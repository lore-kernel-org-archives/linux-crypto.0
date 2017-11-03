From: Jim Quigley <Jim.Quigley@oracle.com>
Subject: virtio:rng: Virtio RNG devices need to be re-registered after suspend/resume
Date: Fri,  3 Nov 2017 09:57:21 +0000
Message-ID: <1509703041-6281-1-git-send-email-Jim.Quigley@oracle.com>
Cc: linux-crypto@vger.kernel.org
To: mpm@selenic.com, herbert@gondor.apana.org.au
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:17185 "EHLO
        userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750883AbdKCJ6B (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 3 Nov 2017 05:58:01 -0400
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

The patch for

commit: 5c06273401f2eb7b290cadbae18ee00f8f65e893
Author: Amit Shah <amit.shah@redhat.com>
Date:   Sun Jul 27 07:34:01 2014 +0930

    virtio: rng: delay hwrng_register() till driver is ready

moved the call to hwrng_register() out of the probe routine into the scan
routine. We need to call hwrng_register() after a suspend/restore cycle
to re-register the device, but the scan function is not invoked for the
restore. Add the call to hwrng_register() to virtio_restore().

Reviewed-by: Liam Merwick <Liam.Merwick@oracle.com>
Signed-off-by: Jim Quigley <Jim.Quigley@oracle.com>
---
 drivers/char/hw_random/virtio-rng.c | 21 ++++++++++++++++++++-
 1 file changed, 20 insertions(+), 1 deletion(-)

diff --git a/drivers/char/hw_random/virtio-rng.c b/drivers/char/hw_random/virtio-rng.c
index 3fa2f8a..b89df66 100644
--- a/drivers/char/hw_random/virtio-rng.c
+++ b/drivers/char/hw_random/virtio-rng.c
@@ -184,7 +184,26 @@ static int virtrng_freeze(struct virtio_device *vdev)
 
 static int virtrng_restore(struct virtio_device *vdev)
 {
-	return probe_common(vdev);
+	int err;
+
+	err = probe_common(vdev);
+	if (!err) {
+		struct virtrng_info *vi = vdev->priv;
+
+		/*
+		 * Set hwrng_removed to ensure that virtio_read()
+		 * does not block waiting for data before the
+		 * registration is complete.
+		 */
+		vi->hwrng_removed = true;
+		err = hwrng_register(&vi->hwrng);
+		if (!err) {
+			vi->hwrng_register_done = true;
+			vi->hwrng_removed = false;
+		}
+	}
+
+	return err;
 }
 #endif
 
-- 
1.8.3.1
