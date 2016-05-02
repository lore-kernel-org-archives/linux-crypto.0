From: Theodore Ts'o <tytso@mit.edu>
Subject: [PATCH 3/3] random: add interrupt callback to VMBus IRQ handler
Date: Mon,  2 May 2016 02:26:53 -0400
Message-ID: <1462170413-7164-4-git-send-email-tytso@mit.edu>
References: <1462170413-7164-1-git-send-email-tytso@mit.edu>
Cc: smueller@chronox.de, herbert@gondor.apana.org.au,
	andi@firstfloor.org, sandyinchina@gmail.com,
	cryptography@lakedaemon.net, jsd@av8n.com, hpa@zytor.com,
	linux-crypto@vger.kernel.org,
	Stephan Mueller <stephan.mueller@atsec.com>,
	Theodore Ts'o <tytso@mit.edu>
To: linux-kernel@vger.kernel.org
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from imap.thunk.org ([74.207.234.97]:34738 "EHLO imap.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752840AbcEBG1Q (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Mon, 2 May 2016 02:27:16 -0400
In-Reply-To: <1462170413-7164-1-git-send-email-tytso@mit.edu>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

From: Stephan Mueller <smueller@chronox.de>

The Hyper-V Linux Integration Services use the VMBus implementation for
communication with the Hypervisor. VMBus registers its own interrupt
handler that completely bypasses the common Linux interrupt handling.
This implies that the interrupt entropy collector is not triggered.

This patch adds the interrupt entropy collection callback into the VMBus
interrupt handler function.

Signed-off-by: Stephan Mueller <stephan.mueller@atsec.com>
Signed-off-by: Stephan Mueller <smueller@chronox.de>
Signed-off-by: Theodore Ts'o <tytso@mit.edu>
---
 drivers/char/random.c  | 1 +
 drivers/hv/vmbus_drv.c | 3 +++
 2 files changed, 4 insertions(+)

diff --git a/drivers/char/random.c b/drivers/char/random.c
index d5bb3b3..c3f17c9 100644
--- a/drivers/char/random.c
+++ b/drivers/char/random.c
@@ -1133,6 +1133,7 @@ void add_interrupt_randomness(int irq, int irq_flags)
 	/* award one bit for the contents of the fast pool */
 	credit_entropy_bits(r, credit + 1);
 }
+EXPORT_SYMBOL_GPL(add_interrupt_randomness);
 
 #ifdef CONFIG_BLOCK
 void add_disk_randomness(struct gendisk *disk)
diff --git a/drivers/hv/vmbus_drv.c b/drivers/hv/vmbus_drv.c
index 64713ff..9af61bb 100644
--- a/drivers/hv/vmbus_drv.c
+++ b/drivers/hv/vmbus_drv.c
@@ -41,6 +41,7 @@
 #include <linux/ptrace.h>
 #include <linux/screen_info.h>
 #include <linux/kdebug.h>
+#include <linux/random.h>
 #include "hyperv_vmbus.h"
 
 static struct acpi_device  *hv_acpi_dev;
@@ -801,6 +802,8 @@ static void vmbus_isr(void)
 		else
 			tasklet_schedule(hv_context.msg_dpc[cpu]);
 	}
+
+	add_interrupt_randomness(HYPERVISOR_CALLBACK_VECTOR, 0);
 }
 
 
-- 
2.5.0
