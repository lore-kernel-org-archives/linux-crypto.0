From: "Jason A. Donenfeld" <Jason@zx2c4.com>
Subject: [PATCH] padata: add helper function for queue length
Date: Sun,  2 Oct 2016 03:46:38 +0200
Message-ID: <20161002014638.8049-1-Jason@zx2c4.com>
Cc: "Jason A. Donenfeld" <Jason@zx2c4.com>
To: Steffen Klassert <steffen.klassert@secunet.com>,
        linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

Since padata has a maximum number of inflight jobs, currently 1000, it's
very useful to know how many jobs are currently queued up. This adds a
simple helper function to expose this information.

Signed-off-by: Jason A. Donenfeld <Jason@zx2c4.com>
---
 include/linux/padata.h |  2 ++
 kernel/padata.c        | 16 ++++++++++++++++
 2 files changed, 18 insertions(+)

diff --git a/include/linux/padata.h b/include/linux/padata.h
index 113ee62..4840ae4 100644
--- a/include/linux/padata.h
+++ b/include/linux/padata.h
@@ -3,6 +3,7 @@
  *
  * Copyright (C) 2008, 2009 secunet Security Networks AG
  * Copyright (C) 2008, 2009 Steffen Klassert <steffen.klassert@secunet.com>
+ * Copyright (C) 2016 Jason A. Donenfeld <Jason@zx2c4.com>
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
index 9932788..17c1e08 100644
--- a/kernel/padata.c
+++ b/kernel/padata.c
@@ -5,6 +5,7 @@
  *
  * Copyright (C) 2008, 2009 secunet Security Networks AG
  * Copyright (C) 2008, 2009 Steffen Klassert <steffen.klassert@secunet.com>
+ * Copyright (C) 2016 Jason A. Donenfeld <Jason@zx2c4.com>
  *
  * This program is free software; you can redistribute it and/or modify it
  * under the terms and conditions of the GNU General Public License,
@@ -1039,3 +1040,18 @@ void padata_free(struct padata_instance *pinst)
 	kobject_put(&pinst->kobj);
 }
 EXPORT_SYMBOL(padata_free);
+
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
-- 
2.10.0
