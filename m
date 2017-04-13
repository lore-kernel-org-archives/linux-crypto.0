From: "Jason A. Donenfeld" <Jason@zx2c4.com>
Subject: [PATCH] padata: allow caller to control queue length
Date: Thu, 13 Apr 2017 11:52:13 +0200
Message-ID: <20170413095213.23513-1-Jason@zx2c4.com>
Cc: "Jason A. Donenfeld" <Jason@zx2c4.com>
To: linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
        steffen.klassert@secunet.com
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from frisell.zx2c4.com ([192.95.5.64]:58901 "EHLO frisell.zx2c4.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1750765AbdDMJwa (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 13 Apr 2017 05:52:30 -0400
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Allow users of padata to determine the queue length themselves, via this
added helper function, so that we can later remove the hard-coded 1000-
job limit. We thus add a helper function, and then move the limiting
functionality to pcrypt-proper, since it was the only current consumer
relying on the 1000-job limit. We do, however, impose a limit on padata
so that the reference count does not have an integer overflow.

Signed-off-by: Jason A. Donenfeld <Jason@zx2c4.com>
---
 Documentation/padata.txt |  8 ++++++++
 crypto/pcrypt.c          |  5 +++++
 include/linux/padata.h   |  2 ++
 kernel/padata.c          | 20 +++++++++++++++++---
 4 files changed, 32 insertions(+), 3 deletions(-)

diff --git a/Documentation/padata.txt b/Documentation/padata.txt
index 7ddfe216a0aa..9347d145bb27 100644
--- a/Documentation/padata.txt
+++ b/Documentation/padata.txt
@@ -158,3 +158,11 @@ when a padata instance is no longer needed:
 This function will busy-wait while any remaining tasks are completed, so it
 might be best not to call it while there is work outstanding.  Shutting
 down the workqueue, if necessary, should be done separately.
+
+While you cannot have more than 2^31-1 taks submitted at the same time, this
+maximum is well above what you might actually want to be submitted. Thus,
+callers are encouraged to determine their maximum latency/memory/throughput
+constraints, and limit calls to padata_do_parallel() based on the current
+queue length, which can be determined with:
+
+    int padata_queue_len(struct padata_instance *pinst);
diff --git a/crypto/pcrypt.c b/crypto/pcrypt.c
index ee9cfb99fe25..ea321154994b 100644
--- a/crypto/pcrypt.c
+++ b/crypto/pcrypt.c
@@ -70,6 +70,8 @@ struct pcrypt_aead_ctx {
 	unsigned int cb_cpu;
 };
 
+#define MAX_OBJ_NUM 1000
+
 static int pcrypt_do_parallel(struct padata_priv *padata, unsigned int *cb_cpu,
 			      struct padata_pcrypt *pcrypt)
 {
@@ -78,6 +80,9 @@ static int pcrypt_do_parallel(struct padata_priv *padata, unsigned int *cb_cpu,
 
 	cpu = *cb_cpu;
 
+	if (padata_queue_len(pcrypt->pinst) >= MAX_OBJ_NUM)
+		return -EBUSY;
+
 	rcu_read_lock_bh();
 	cpumask = rcu_dereference_bh(pcrypt->cb_cpumask);
 	if (cpumask_test_cpu(cpu, cpumask->mask))
diff --git a/include/linux/padata.h b/include/linux/padata.h
index 0f9e567d5e15..2482b442f136 100644
--- a/include/linux/padata.h
+++ b/include/linux/padata.h
@@ -3,6 +3,7 @@
  *
  * Copyright (C) 2008, 2009 secunet Security Networks AG
  * Copyright (C) 2008, 2009 Steffen Klassert <steffen.klassert@secunet.com>
+ * Copyright (C) 2016, 2017 Jason A. Donenfeld <Jason@zx2c4.com>
  *
  * This program is free software; you can redistribute it and/or modify it
  * under the terms and conditions of the GNU General Public License,
@@ -181,4 +182,5 @@ extern int padata_register_cpumask_notifier(struct padata_instance *pinst,
 					    struct notifier_block *nblock);
 extern int padata_unregister_cpumask_notifier(struct padata_instance *pinst,
 					      struct notifier_block *nblock);
+extern int padata_queue_len(struct padata_instance *pinst);
 #endif
diff --git a/kernel/padata.c b/kernel/padata.c
index ac8f1e524836..6ba2db73413f 100644
--- a/kernel/padata.c
+++ b/kernel/padata.c
@@ -5,6 +5,7 @@
  *
  * Copyright (C) 2008, 2009 secunet Security Networks AG
  * Copyright (C) 2008, 2009 Steffen Klassert <steffen.klassert@secunet.com>
+ * Copyright (C) 2016, 2017 Jason A. Donenfeld <Jason@zx2c4.com>
  *
  * This program is free software; you can redistribute it and/or modify it
  * under the terms and conditions of the GNU General Public License,
@@ -32,8 +33,6 @@
 #include <linux/rcupdate.h>
 #include <linux/module.h>
 
-#define MAX_OBJ_NUM 1000
-
 static int padata_index_to_cpu(struct parallel_data *pd, int cpu_index)
 {
 	int cpu, target_cpu;
@@ -122,7 +121,7 @@ int padata_do_parallel(struct padata_instance *pinst,
 	if ((pinst->flags & PADATA_RESET))
 		goto out;
 
-	if (atomic_read(&pd->refcnt) >= MAX_OBJ_NUM)
+	if (unlikely(atomic_read(&pd->refcnt) == INT_MAX))
 		goto out;
 
 	err = 0;
@@ -1021,6 +1020,21 @@ void padata_free(struct padata_instance *pinst)
 }
 EXPORT_SYMBOL(padata_free);
 
+/**
+ * padata_queue_len - retreive the number of in progress jobs
+ *
+ * @padata_inst: padata instance from which to read the queue size
+ */
+int padata_queue_len(struct padata_instance *pinst)
+{
+	int len;
+	rcu_read_lock_bh();
+	len = atomic_read(&rcu_dereference_bh(pinst->pd)->refcnt);
+	rcu_read_unlock_bh();
+	return len;
+}
+EXPORT_SYMBOL(padata_queue_len);
+
 #ifdef CONFIG_HOTPLUG_CPU
 
 static __init int padata_driver_init(void)
-- 
2.12.2
