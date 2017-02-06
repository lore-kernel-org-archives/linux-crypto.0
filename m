From: David Daney <david.daney@cavium.com>
Subject: [PATCH] hwrng: cavium: Use per device name to allow for multiple devices.
Date: Mon, 6 Feb 2017 14:28:46 -0800
Message-ID: <20170206222846.22493-1-david.daney@cavium.com>
Mime-Version: 1.0
Content-Type: text/plain
Cc: <linux-kernel@vger.kernel.org>,
        Omer Khaliq <okhaliq@caviumnetworks.com>,
        Ananth Jasty <Ananth.Jasty@cavium.com>,
        David Daney <david.daney@cavium.com>
To: <linux-crypto@vger.kernel.org>, Matt Mackall <mpm@selenic.com>,
        Herbert Xu <herbert@gondor.apana.org.au>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-bl2nam02on0060.outbound.protection.outlook.com ([104.47.38.60]:51360
        "EHLO NAM02-BL2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1752411AbdBFW25 (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 6 Feb 2017 17:28:57 -0500
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Systems containing the Cavium HW RNG may have one device per NUMA
node.  A typical configuration is a 2-node NUMA system, which results
in 2 RNG devices.  The hwrng subsystem refuses (and rightly so) to
register more than one device with he same name, so we get failure
messages on these systems.

Make the hwrng name unique by including the underlying device name.
Also remove spaces from the name to make it possible to switch devices
via the sysfs knobs.

Signed-off-by: David Daney <david.daney@cavium.com>
---
 drivers/char/hw_random/cavium-rng-vf.c | 6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/drivers/char/hw_random/cavium-rng-vf.c b/drivers/char/hw_random/cavium-rng-vf.c
index 066ae0e..dd1007a 100644
--- a/drivers/char/hw_random/cavium-rng-vf.c
+++ b/drivers/char/hw_random/cavium-rng-vf.c
@@ -57,7 +57,11 @@ static int cavium_rng_probe_vf(struct	pci_dev		*pdev,
 		return -ENOMEM;
 	}
 
-	rng->ops.name    = "cavium rng";
+	rng->ops.name = devm_kasprintf(&pdev->dev, GFP_KERNEL,
+				       "cavium-rng-%s", dev_name(&pdev->dev));
+	if (!rng->ops.name)
+		return -ENOMEM;
+
 	rng->ops.read    = cavium_rng_read;
 	rng->ops.quality = 1000;
 
-- 
1.8.3.1
