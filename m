From: Theodore Ts'o <tytso@mit.edu>
Subject: [PATCH 3/7] random: add interrupt callback to VMBus IRQ handler
Date: Mon, 13 Jun 2016 11:48:35 -0400
Message-ID: <1465832919-11316-4-git-send-email-tytso@mit.edu>
References: <1465832919-11316-1-git-send-email-tytso@mit.edu>
Cc: linux-crypto@vger.kernel.org, smueller@chronox.de,
	herbert@gondor.apana.org.au, andi@firstfloor.org,
	sandyinchina@gmail.com, jsd@av8n.com, hpa@zytor.com,
	stable@kernel.org, Stephan Mueller <stephan.mueller@atsec.com>,
	Theodore Ts'o <tytso@mit.edu>
To: Linux Kernel Developers List <linux-kernel@vger.kernel.org>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from imap.thunk.org ([74.207.234.97]:45064 "EHLO imap.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1424550AbcFMPt2 (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Mon, 13 Jun 2016 11:49:28 -0400
In-Reply-To: <1465832919-11316-1-git-send-email-tytso@mit.edu>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

From: Stephan Mueller <smueller@chronox.de>

The Hyper-V Linux Integration Services use the VMBus implementation for
communication with the Hypervisor. VMBus registers its own interrupt
handler that completely bypasses the common Linux interrupt handling.
This implies that the interrupt entropy collector is not triggered.

This patch adds the interrupt entropy collection callback into the VMBus
interrupt handler function.

Cc: stable@kernel.org
Signed-off-by: Stephan Mueller <stephan.mueller@atsec.com>
Signed-off-by: Stephan Mueller <smueller@chronox.de>
Signed-off-by: Theodore Ts'o <tytso@mit.edu>
---
 drivers/char/random.c  | 1 +
 drivers/hv/vmbus_drv.c | 3 +++
 2 files changed, 4 insertions(+)

diff --git a/drivers/char/random.c b/drivers/char/random.c
index 74596d3..64e35a4 100644
--- a/drivers/char/random.c
+++ b/drivers/char/random.c
@@ -946,6 +946,7 @@ void add_interrupt_randomness(int irq, int irq_flags)
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
2.5.0
