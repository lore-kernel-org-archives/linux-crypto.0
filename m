From: Arvind Yadav <arvind.yadav.cs@gmail.com>
Subject: [PATCH] hwrng: pseries: constify vio_device_id
Date: Thu, 17 Aug 2017 23:06:23 +0530
Message-ID: <ba527ef090617a90e6909bab75b09e1c1ac8be68.1502990171.git.arvind.yadav.cs@gmail.com>
Cc: linux-kernel@vger.kernel.org, linuxppc-dev@lists.ozlabs.org,
        linux-crypto@vger.kernel.org
To: herbert@gondor.apana.org.au, mpm@selenic.com, mpe@ellerman.id.au
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-pg0-f66.google.com ([74.125.83.66]:35490 "EHLO
        mail-pg0-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752270AbdHQRgd (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 17 Aug 2017 13:36:33 -0400
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

vio_device_id are not supposed to change at runtime. All functions
working with vio_device_id provided by <asm/vio.h> work with
const vio_device_id. So mark the non-const structs as const.

Signed-off-by: Arvind Yadav <arvind.yadav.cs@gmail.com>
---
 drivers/char/hw_random/pseries-rng.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/char/hw_random/pseries-rng.c b/drivers/char/hw_random/pseries-rng.c
index d9f46b4..4e2a3f6 100644
--- a/drivers/char/hw_random/pseries-rng.c
+++ b/drivers/char/hw_random/pseries-rng.c
@@ -72,7 +72,7 @@ static int pseries_rng_remove(struct vio_dev *dev)
 	return 0;
 }
 
-static struct vio_device_id pseries_rng_driver_ids[] = {
+static const struct vio_device_id pseries_rng_driver_ids[] = {
 	{ "ibm,random-v1", "ibm,random"},
 	{ "", "" }
 };
-- 
2.7.4
