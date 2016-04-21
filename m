From: Stephan Mueller <smueller@chronox.de>
Subject: [PATCH 6/6] hyperv IRQ handler: trigger LRNG
Date: Thu, 21 Apr 2016 11:16:15 +0200
Message-ID: <11692471.NfkVINnMCh@positron.chronox.de>
References: <9192755.iDgo3Omyqe@positron.chronox.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7Bit
Cc: linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
	sandyinchina@gmail.com, "K. Y. Srinivasan" <kys@microsoft.com>,
	Haiyang Zhang <haiyangz@microsoft.com>,
	devel@linuxdriverproject.org
To: Ted Tso <tytso@mit.edu>, herbert@gondor.apana.org.au
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <9192755.iDgo3Omyqe@positron.chronox.de>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

The Hyper-V Linux Integration Services use the VMBus implementation for
communication with the Hypervisor. VMBus registers its own interrupt
handler that completely bypasses the common Linux interrupt handling.

The interrupt handler is now added the invocation of the LRNG IRQ
collection function to also benefit from entropy under Hyper-V.

If the implementation of the VMBus and its subordinate drivers is
changed such that they resemble the Xen implementation where the
received IRQs are forwarded to the standard Linux interrupt handling
logic, this patch should be dropped.

Signed-off-by: Stephan Mueller <smueller@chronox.de>
---
 drivers/hv/vmbus_drv.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/hv/vmbus_drv.c b/drivers/hv/vmbus_drv.c
index 64713ff..afa2de0 100644
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
+	lrng_irq_process();
 }
 
 
-- 
2.5.5
