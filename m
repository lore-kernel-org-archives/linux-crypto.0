From: Dan Streetman <ddstreet@ieee.org>
Subject: [PATCH 3/8] crypto: nx - move kzalloc() out of spinlock
Date: Wed, 22 Jul 2015 14:26:33 -0400
Message-ID: <1437589598-23917-4-git-send-email-ddstreet@ieee.org>
References: <1437589598-23917-1-git-send-email-ddstreet@ieee.org>
Cc: linux-kernel@vger.kernel.org, linux-crypto@vger.kernel.org,
	Dan Streetman <ddstreet@ieee.org>
To: Herbert Xu <herbert@gondor.apana.org.au>,
	"David S. Miller" <davem@davemloft.net>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1437589598-23917-1-git-send-email-ddstreet@ieee.org>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

Move the kzalloc() calls in nx842_probe() and nx842_OF_upd() to the top
of the functions, before taking the devdata spinlock.

Since kzalloc() without GFP_ATOMIC can sleep, it can't be called while
holding a spinlock.  Move the calls to before taking the lock.

Signed-off-by: Dan Streetman <ddstreet@ieee.org>
---
 drivers/crypto/nx/nx-842-pseries.c | 38 ++++++++++++++++----------------------
 1 file changed, 16 insertions(+), 22 deletions(-)

diff --git a/drivers/crypto/nx/nx-842-pseries.c b/drivers/crypto/nx/nx-842-pseries.c
index b375877..74c53a1 100644
--- a/drivers/crypto/nx/nx-842-pseries.c
+++ b/drivers/crypto/nx/nx-842-pseries.c
@@ -724,6 +724,10 @@ static int nx842_OF_upd(struct property *new_prop)
 	int ret = 0;
 	unsigned long flags;
 
+	new_devdata = kzalloc(sizeof(*new_devdata), GFP_NOFS);
+	if (!new_devdata)
+		return -ENOMEM;
+
 	spin_lock_irqsave(&devdata_mutex, flags);
 	old_devdata = rcu_dereference_check(devdata,
 			lockdep_is_held(&devdata_mutex));
@@ -733,16 +737,10 @@ static int nx842_OF_upd(struct property *new_prop)
 	if (!old_devdata || !of_node) {
 		pr_err("%s: device is not available\n", __func__);
 		spin_unlock_irqrestore(&devdata_mutex, flags);
+		kfree(new_devdata);
 		return -ENODEV;
 	}
 
-	new_devdata = kzalloc(sizeof(*new_devdata), GFP_NOFS);
-	if (!new_devdata) {
-		dev_err(old_devdata->dev, "%s: Could not allocate memory for device data\n", __func__);
-		ret = -ENOMEM;
-		goto error_out;
-	}
-
 	memcpy(new_devdata, old_devdata, sizeof(*old_devdata));
 	new_devdata->counters = old_devdata->counters;
 
@@ -966,6 +964,17 @@ static int nx842_probe(struct vio_dev *viodev,
 	unsigned long flags;
 	int ret = 0;
 
+	new_devdata = kzalloc(sizeof(*new_devdata), GFP_NOFS);
+	if (!new_devdata)
+		return -ENOMEM;
+
+	new_devdata->counters = kzalloc(sizeof(*new_devdata->counters),
+			GFP_NOFS);
+	if (!new_devdata->counters) {
+		kfree(new_devdata);
+		return -ENOMEM;
+	}
+
 	spin_lock_irqsave(&devdata_mutex, flags);
 	old_devdata = rcu_dereference_check(devdata,
 			lockdep_is_held(&devdata_mutex));
@@ -978,21 +987,6 @@ static int nx842_probe(struct vio_dev *viodev,
 
 	dev_set_drvdata(&viodev->dev, NULL);
 
-	new_devdata = kzalloc(sizeof(*new_devdata), GFP_NOFS);
-	if (!new_devdata) {
-		dev_err(&viodev->dev, "%s: Could not allocate memory for device data\n", __func__);
-		ret = -ENOMEM;
-		goto error_unlock;
-	}
-
-	new_devdata->counters = kzalloc(sizeof(*new_devdata->counters),
-			GFP_NOFS);
-	if (!new_devdata->counters) {
-		dev_err(&viodev->dev, "%s: Could not allocate memory for performance counters\n", __func__);
-		ret = -ENOMEM;
-		goto error_unlock;
-	}
-
 	new_devdata->vdev = viodev;
 	new_devdata->dev = &viodev->dev;
 	nx842_OF_set_defaults(new_devdata);
-- 
2.1.0
