From: Dan Streetman <ddstreet@ieee.org>
Subject: [PATCH 4/8] crypto: nx - don't register pSeries driver if ENODEV
Date: Wed, 22 Jul 2015 14:26:34 -0400
Message-ID: <1437589598-23917-5-git-send-email-ddstreet@ieee.org>
References: <1437589598-23917-1-git-send-email-ddstreet@ieee.org>
Cc: linux-kernel@vger.kernel.org, linux-crypto@vger.kernel.org,
	Dan Streetman <ddstreet@ieee.org>
To: Herbert Xu <herbert@gondor.apana.org.au>,
	"David S. Miller" <davem@davemloft.net>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1437589598-23917-1-git-send-email-ddstreet@ieee.org>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

Don't register the pSeries driver when parsing the device tree returns
ENODEV.

The nx842_probe() function in the pSeries driver returns error instead
of registering as a crypto compression driver, when it receives an
error return value from the nx842_OF_upd() function that probes the
device tree nodes, except when ENODEV is returned.  However ENODEV
should not be a special case and the driver should not register when
there is no hw device, or the hw device is disabled.

Signed-off-by: Dan Streetman <ddstreet@ieee.org>
---
 drivers/crypto/nx/nx-842-pseries.c | 5 +----
 1 file changed, 1 insertion(+), 4 deletions(-)

diff --git a/drivers/crypto/nx/nx-842-pseries.c b/drivers/crypto/nx/nx-842-pseries.c
index 74c53a1..4b7bd8f 100644
--- a/drivers/crypto/nx/nx-842-pseries.c
+++ b/drivers/crypto/nx/nx-842-pseries.c
@@ -999,11 +999,8 @@ static int nx842_probe(struct vio_dev *viodev,
 	of_reconfig_notifier_register(&nx842_of_nb);
 
 	ret = nx842_OF_upd(NULL);
-	if (ret && ret != -ENODEV) {
-		dev_err(&viodev->dev, "could not parse device tree. %d\n", ret);
-		ret = -1;
+	if (ret)
 		goto error;
-	}
 
 	rcu_read_lock();
 	dev_set_drvdata(&viodev->dev, rcu_dereference(devdata));
-- 
2.1.0
