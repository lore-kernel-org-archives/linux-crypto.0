From: Theodore Ts'o <tytso@mit.edu>
Subject: [PATCH 3/4] random: add interrupt callback to VMBus IRQ handler
Date: Wed,  4 May 2016 15:25:50 -0400
Message-ID: <1462389951-29439-4-git-send-email-tytso@mit.edu>
References: <1462389951-29439-1-git-send-email-tytso@mit.edu>
Cc: smueller@chronox.de, herbert@gondor.apana.org.au,
	andi@firstfloor.org, sandyinchina@gmail.com,
	cryptography@lakedaemon.net, jsd@av8n.com, hpa@zytor.com,
	linux-crypto@vger.kernel.org,
	Stephan Mueller <stephan.mueller@atsec.com>,
	Theodore Ts'o <tytso@mit.edu>
To: Linux Kernel Developers List <linux-kernel@vger.kernel.org>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1462389951-29439-1-git-send-email-tytso@mit.edu>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

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
index b970db6..897c75e 100644
--- a/drivers/char/random.c
+++ b/drivers/char/random.c
@@ -1134,6 +1134,7 @@ void add_interrupt_randomness(int irq, int irq_flags)
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
