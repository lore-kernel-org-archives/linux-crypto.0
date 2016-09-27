From: Paul Gortmaker <paul.gortmaker@windriver.com>
Subject: [PATCH] padata: remove recently added module usage from bool code
Date: Mon, 26 Sep 2016 21:18:21 -0400
Message-ID: <20160927011821.6635-1-paul.gortmaker@windriver.com>
Mime-Version: 1.0
Content-Type: text/plain
Cc: Paul Gortmaker <paul.gortmaker@windriver.com>,
        Steffen Klassert <steffen.klassert@secunet.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
        <linux-crypto@vger.kernel.org>
To: <linux-kernel@vger.kernel.org>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail1.windriver.com ([147.11.146.13]:35871 "EHLO
        mail1.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1756070AbcI0BTo (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 26 Sep 2016 21:19:44 -0400
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

In commit 30e92153b4e6 ("padata: Convert to hotplug state machine")
this file started using module.h and got module_init and module_exit
added to it.

However the Kconfig for it is:

   init/Kconfig:config PADATA
   init/Kconfig:   depends on SMP
   init/Kconfig:   bool

...and so it currently is not being built as a module by anyone.

Lets remove the modular code that is essentially orphaned, so that
when reading the driver there is no doubt it is builtin-only.

Since module_init translates to device_initcall in the non-modular
case, the init ordering remains unchanged with this commit.

Cc: Steffen Klassert <steffen.klassert@secunet.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Cc: linux-crypto@vger.kernel.org
Signed-off-by: Paul Gortmaker <paul.gortmaker@windriver.com>
---
 kernel/padata.c | 9 ++-------
 1 file changed, 2 insertions(+), 7 deletions(-)

diff --git a/kernel/padata.c b/kernel/padata.c
index 7848f0566403..355807e52b1e 100644
--- a/kernel/padata.c
+++ b/kernel/padata.c
@@ -30,7 +30,7 @@
 #include <linux/slab.h>
 #include <linux/sysfs.h>
 #include <linux/rcupdate.h>
-#include <linux/module.h>
+#include <linux/init.h>
 
 #define MAX_OBJ_NUM 1000
 
@@ -1043,11 +1043,6 @@ static __init int padata_driver_init(void)
 	hp_online = ret;
 	return 0;
 }
-module_init(padata_driver_init);
+device_initcall(padata_driver_init);
 
-static __exit void padata_driver_exit(void)
-{
-	cpuhp_remove_multi_state(hp_online);
-}
-module_exit(padata_driver_exit);
 #endif
-- 
2.10.0
