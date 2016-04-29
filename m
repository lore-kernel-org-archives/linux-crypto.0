From: Stephan Mueller <smueller@chronox.de>
Subject: [PATCH v3 5/5] random: add interrupt callback to VMBus IRQ handler
Date: Fri, 29 Apr 2016 08:24:43 +0200
Message-ID: <2028519.e7rxLlMInB@positron.chronox.de>
References: <2346517.m8UHYeMDSf@positron.chronox.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7Bit
Cc: Ted Tso <tytso@mit.edu>, Andi Kleen <andi@firstfloor.org>,
	sandyinchina@gmail.com, Jason Cooper <cryptography@lakedaemon.net>,
	John Denker <jsd@av8n.com>, "H. Peter Anvin" <hpa@zytor.com>,
	joe@perches.com, Pavel Machek <pavel@ucw.cz>,
	linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org
To: herbert@gondor.apana.org.au
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <2346517.m8UHYeMDSf@positron.chronox.de>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

The Hyper-V Linux Integration Services use the VMBus implementation for
communication with the Hypervisor. VMBus registers its own interrupt
handler that completely bypasses the common Linux interrupt handling.
This implies that the interrupt entropy collector is not triggered.

This patch adds the interrupt entropy collection callback into the VMBus
interrupt handler function.

Signed-off-by: Stephan Mueller <stephan.mueller@atsec.com>
Signed-off-by: Stephan Mueller <smueller@chronox.de>
---
 drivers/char/random.c  | 1 +
 drivers/hv/vmbus_drv.c | 3 +++
 2 files changed, 4 insertions(+)

diff --git a/drivers/char/random.c b/drivers/char/random.c
index 92c2174..9632976 100644
--- a/drivers/char/random.c
+++ b/drivers/char/random.c
@@ -947,6 +947,7 @@ void add_interrupt_randomness(int irq, int irq_flags)
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
2.5.5
