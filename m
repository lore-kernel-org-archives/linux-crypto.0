From: Stephan Mueller <smueller@chronox.de>
Subject: [PATCH v5 4/7] crypto: LRNG - enable compile
Date: Sun, 19 Jun 2016 18:01:14 +0200
Message-ID: <3226111.vfTlE7gR01@positron.chronox.de>
References: <2754489.L1QYabbYUc@positron.chronox.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7Bit
Cc: Theodore Tso <tytso@mit.edu>, Andi Kleen <andi@firstfloor.org>,
	sandyinchina@gmail.com, Jason Cooper <cryptography@lakedaemon.net>,
	John Denker <jsd@av8n.com>,
	"H. Peter Anvin" <hpa@linux.intel.com>,
	Joe Perches <joe@perches.com>, Pavel Machek <pavel@ucw.cz>,
	George Spelvin <linux@horizon.com>,
	linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org
To: herbert@gondor.apana.org.au
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail.eperm.de ([89.247.134.16]:37042 "EHLO mail.eperm.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750907AbcFSQHC (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Sun, 19 Jun 2016 12:07:02 -0400
In-Reply-To: <2754489.L1QYabbYUc@positron.chronox.de>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

The Hyper-V Linux Integration Services use the VMBus implementation for
communication with the Hypervisor. VMBus registers its own interrupt
handler that completely bypasses the common Linux interrupt handling.
This implies that the interrupt entropy collector is not triggered.

This patch adds the interrupt entropy collection callback into the VMBus
interrupt handler function.

Signed-off-by: Stephan Mueller <smueller@chronox.de>
---
 drivers/char/random.c  | 1 +
 drivers/hv/vmbus_drv.c | 3 +++
 2 files changed, 4 insertions(+)

diff --git a/drivers/char/random.c b/drivers/char/random.c
index ef89c0e..ac74716 100644
--- a/drivers/char/random.c
+++ b/drivers/char/random.c
@@ -948,6 +948,7 @@ void add_interrupt_randomness(int irq, int irq_flags)
 	/* award one bit for the contents of the fast pool */
 	credit_entropy_bits(r, credit + 1);
 }
+EXPORT_SYMBOL_GPL(add_interrupt_randomness);
 
 #ifdef CONFIG_BLOCK
 void add_disk_randomness(struct gendisk *disk)
diff --git a/drivers/hv/vmbus_drv.c b/drivers/hv/vmbus_drv.c
index 952f20f..e82f7e1 100644
--- a/drivers/hv/vmbus_drv.c
+++ b/drivers/hv/vmbus_drv.c
@@ -42,6 +42,7 @@
 #include <linux/screen_info.h>
 #include <linux/kdebug.h>
 #include <linux/efi.h>
+#include <linux/random.h>
 #include "hyperv_vmbus.h"
 
 static struct acpi_device  *hv_acpi_dev;
@@ -806,6 +807,8 @@ static void vmbus_isr(void)
 		else
 			tasklet_schedule(hv_context.msg_dpc[cpu]);
 	}
+
+	add_interrupt_randomness(HYPERVISOR_CALLBACK_VECTOR, 0);
 }
 
 
-- 
2.5.5
