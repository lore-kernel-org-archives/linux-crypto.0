From: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Subject: [PATCH 13/21] padata: Convert to hotplug state machine
Date: Tue,  6 Sep 2016 19:04:49 +0200
Message-ID: <20160906170457.32393-14-bigeasy@linutronix.de>
References: <20160906170457.32393-1-bigeasy@linutronix.de>
Mime-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Cc: Peter Zijlstra <peterz@infradead.org>,
        Ingo Molnar <mingo@redhat.com>, rt@linutronix.de,
        tglx@linutronix.de,
        Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
        Steffen Klassert <steffen.klassert@secunet.com>,
        linux-crypto@vger.kernel.org
To: linux-kernel@vger.kernel.org
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from Galois.linutronix.de ([146.0.238.70]:36912 "EHLO
        Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S964946AbcIFRGc (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 6 Sep 2016 13:06:32 -0400
In-Reply-To: <20160906170457.32393-1-bigeasy@linutronix.de>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Install the callbacks via the state machine. CPU-hotplug multinstance suppo=
rt
is used with the nocalls() version. Maybe parts of padata_alloc() could be
moved into the online callback so that we could invoke ->startup callback f=
or
instance and drop get_online_cpus().

Cc: Steffen Klassert <steffen.klassert@secunet.com>
Cc: linux-crypto@vger.kernel.org
Signed-off-by: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
---
 include/linux/padata.h |  2 +-
 kernel/padata.c        | 92 ++++++++++++++++++++++++++++------------------=
----
 2 files changed, 53 insertions(+), 41 deletions(-)

diff --git a/include/linux/padata.h b/include/linux/padata.h
index 113ee626a4dc..0f9e567d5e15 100644
--- a/include/linux/padata.h
+++ b/include/linux/padata.h
@@ -151,7 +151,7 @@ struct parallel_data {
  * @flags: padata flags.
  */
 struct padata_instance {
-	struct notifier_block		 cpu_notifier;
+	struct hlist_node		 node;
 	struct workqueue_struct		*wq;
 	struct parallel_data		*pd;
 	struct padata_cpumask		cpumask;
diff --git a/kernel/padata.c b/kernel/padata.c
index 993278895ccc..7848f0566403 100644
--- a/kernel/padata.c
+++ b/kernel/padata.c
@@ -30,6 +30,7 @@
 #include <linux/slab.h>
 #include <linux/sysfs.h>
 #include <linux/rcupdate.h>
+#include <linux/module.h>
=20
 #define MAX_OBJ_NUM 1000
=20
@@ -769,52 +770,43 @@ static inline int pinst_has_cpu(struct padata_instanc=
e *pinst, int cpu)
 		cpumask_test_cpu(cpu, pinst->cpumask.cbcpu);
 }
=20
-
-static int padata_cpu_callback(struct notifier_block *nfb,
-			       unsigned long action, void *hcpu)
+static int padata_cpu_online(unsigned int cpu, struct hlist_node *node)
 {
-	int err;
 	struct padata_instance *pinst;
-	int cpu =3D (unsigned long)hcpu;
+	int ret;
=20
-	pinst =3D container_of(nfb, struct padata_instance, cpu_notifier);
+	pinst =3D hlist_entry_safe(node, struct padata_instance, node);
+	if (!pinst_has_cpu(pinst, cpu))
+		return 0;
=20
-	switch (action) {
-	case CPU_ONLINE:
-	case CPU_ONLINE_FROZEN:
-	case CPU_DOWN_FAILED:
-	case CPU_DOWN_FAILED_FROZEN:
-		if (!pinst_has_cpu(pinst, cpu))
-			break;
-		mutex_lock(&pinst->lock);
-		err =3D __padata_add_cpu(pinst, cpu);
-		mutex_unlock(&pinst->lock);
-		if (err)
-			return notifier_from_errno(err);
-		break;
-
-	case CPU_DOWN_PREPARE:
-	case CPU_DOWN_PREPARE_FROZEN:
-	case CPU_UP_CANCELED:
-	case CPU_UP_CANCELED_FROZEN:
-		if (!pinst_has_cpu(pinst, cpu))
-			break;
-		mutex_lock(&pinst->lock);
-		err =3D __padata_remove_cpu(pinst, cpu);
-		mutex_unlock(&pinst->lock);
-		if (err)
-			return notifier_from_errno(err);
-		break;
-	}
-
-	return NOTIFY_OK;
+	mutex_lock(&pinst->lock);
+	ret =3D __padata_add_cpu(pinst, cpu);
+	mutex_unlock(&pinst->lock);
+	return ret;
 }
+
+static int padata_cpu_prep_down(unsigned int cpu, struct hlist_node *node)
+{
+	struct padata_instance *pinst;
+	int ret;
+
+	pinst =3D hlist_entry_safe(node, struct padata_instance, node);
+	if (!pinst_has_cpu(pinst, cpu))
+		return 0;
+
+	mutex_lock(&pinst->lock);
+	ret =3D __padata_remove_cpu(pinst, cpu);
+	mutex_unlock(&pinst->lock);
+	return ret;
+}
+
+static enum cpuhp_state hp_online;
 #endif
=20
 static void __padata_free(struct padata_instance *pinst)
 {
 #ifdef CONFIG_HOTPLUG_CPU
-	unregister_hotcpu_notifier(&pinst->cpu_notifier);
+	cpuhp_state_remove_instance_nocalls(hp_online, &pinst->node);
 #endif
=20
 	padata_stop(pinst);
@@ -1012,11 +1004,8 @@ struct padata_instance *padata_alloc(struct workqueu=
e_struct *wq,
 	mutex_init(&pinst->lock);
=20
 #ifdef CONFIG_HOTPLUG_CPU
-	pinst->cpu_notifier.notifier_call =3D padata_cpu_callback;
-	pinst->cpu_notifier.priority =3D 0;
-	register_hotcpu_notifier(&pinst->cpu_notifier);
+	cpuhp_state_add_instance_nocalls(hp_online, &pinst->node);
 #endif
-
 	return pinst;
=20
 err_free_masks:
@@ -1039,3 +1028,26 @@ void padata_free(struct padata_instance *pinst)
 	kobject_put(&pinst->kobj);
 }
 EXPORT_SYMBOL(padata_free);
+
+#ifdef CONFIG_HOTPLUG_CPU
+
+static __init int padata_driver_init(void)
+{
+	int ret;
+
+	ret =3D cpuhp_setup_state_multi(CPUHP_AP_ONLINE_DYN, "padata:online",
+				      padata_cpu_online,
+				      padata_cpu_prep_down);
+	if (ret < 0)
+		return ret;
+	hp_online =3D ret;
+	return 0;
+}
+module_init(padata_driver_init);
+
+static __exit void padata_driver_exit(void)
+{
+	cpuhp_remove_multi_state(hp_online);
+}
+module_exit(padata_driver_exit);
+#endif
--=20
2.9.3
