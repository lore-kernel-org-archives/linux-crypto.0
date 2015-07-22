From: Dan Streetman <ddstreet@ieee.org>
Subject: [PATCH 1/8] crypto: nx - remove __init/__exit from VIO functions
Date: Wed, 22 Jul 2015 14:26:31 -0400
Message-ID: <1437589598-23917-2-git-send-email-ddstreet@ieee.org>
References: <1437589598-23917-1-git-send-email-ddstreet@ieee.org>
Cc: linux-kernel@vger.kernel.org, linux-crypto@vger.kernel.org,
	Dan Streetman <ddstreet@ieee.org>
To: Herbert Xu <herbert@gondor.apana.org.au>,
	"David S. Miller" <davem@davemloft.net>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1437589598-23917-1-git-send-email-ddstreet@ieee.org>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

Remove the __init and __exit modifiers from the VIO driver probe and
remove functions.

The driver functions should not be marked __init/__exit because they
can/will be called during runtime, not only at module init and exit.

Signed-off-by: Dan Streetman <ddstreet@ieee.org>
---
 drivers/crypto/nx/nx-842-pseries.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/crypto/nx/nx-842-pseries.c b/drivers/crypto/nx/nx-842-pseries.c
index d44524d..fc59520 100644
--- a/drivers/crypto/nx/nx-842-pseries.c
+++ b/drivers/crypto/nx/nx-842-pseries.c
@@ -977,8 +977,8 @@ static struct nx842_driver nx842_pseries_driver = {
 	.decompress =	nx842_pseries_decompress,
 };
 
-static int __init nx842_probe(struct vio_dev *viodev,
-				  const struct vio_device_id *id)
+static int nx842_probe(struct vio_dev *viodev,
+		       const struct vio_device_id *id)
 {
 	struct nx842_devdata *old_devdata, *new_devdata = NULL;
 	unsigned long flags;
@@ -1050,7 +1050,7 @@ error:
 	return ret;
 }
 
-static int __exit nx842_remove(struct vio_dev *viodev)
+static int nx842_remove(struct vio_dev *viodev)
 {
 	struct nx842_devdata *old_devdata;
 	unsigned long flags;
@@ -1081,7 +1081,7 @@ static struct vio_device_id nx842_vio_driver_ids[] = {
 static struct vio_driver nx842_vio_driver = {
 	.name = KBUILD_MODNAME,
 	.probe = nx842_probe,
-	.remove = __exit_p(nx842_remove),
+	.remove = nx842_remove,
 	.get_desired_dma = nx842_get_desired_dma,
 	.id_table = nx842_vio_driver_ids,
 };
-- 
2.1.0
