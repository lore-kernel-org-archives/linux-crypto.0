From: Richard Cochran <rcochran@linutronix.de>
Subject: [PATCH RFC] padata: Removed unused code.
Date: Thu, 31 Mar 2016 15:51:33 +0200
Message-ID: <9dcee9f23e7477d793f3520d39287b54599e5f69.1459432020.git.rcochran@linutronix.de>
References: <4265b49bed713fbe3faaf8c05da0e1792f09c0b3.1459432020.git.rcochran@linutronix.de>
Cc: Richard Cochran <rcochran@linutronix.de>,
	Steffen Klassert <steffen.klassert@secunet.com>,
	linux-crypto@vger.kernel.org
To: <linux-kernel@vger.kernel.org>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from www.linutronix.de ([62.245.132.108]:48335 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752675AbcCaNwh (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Thu, 31 Mar 2016 09:52:37 -0400
In-Reply-To: <4265b49bed713fbe3faaf8c05da0e1792f09c0b3.1459432020.git.rcochran@linutronix.de>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

By accident I stumbled across code that has never been used.  This
driver has EXPORT_SYMBOL functions, and the only user of the code is
pcrypt.c, but this only uses a subset of the exported symbols.

According to 'git log -G', the functions, padata_set_cpumasks,
padata_add_cpu, and padata_remove_cpu have never been used since they
were first introduced.  This patch removes the unused code.

On one 64 bit build, with CRYPTO_PCRYPT built in, the text is more
than 4k smaller.

  kbuild_hp> size $KBUILD_OUTPUT/vmlinux
      text    data     bss      dec hex    filename
  10566658 4678360 1122304 16367322 f9beda vmlinux
  10561984 4678360 1122304 16362648 f9ac98 vmlinux

On another config, 32 bit, the saving is about 0.5k bytes.

  kbuild_hp-x86> size $KBUILD_OUTPUT/vmlinux
  6012005 2409513 2785280 11206798 ab008e vmlinux
  6011491 2409513 2785280 11206284 aafe8c vmlinux

Cc: Steffen Klassert <steffen.klassert@secunet.com>
Cc: linux-crypto@vger.kernel.org
Signed-off-by: Richard Cochran <rcochran@linutronix.de>
---
 include/linux/padata.h |  5 ---
 kernel/padata.c        | 99 --------------------------------------------------
 2 files changed, 104 deletions(-)

diff --git a/include/linux/padata.h b/include/linux/padata.h
index 4386946..113ee62 100644
--- a/include/linux/padata.h
+++ b/include/linux/padata.h
@@ -175,11 +175,6 @@ extern int padata_do_parallel(struct padata_instance *pinst,
 extern void padata_do_serial(struct padata_priv *padata);
 extern int padata_set_cpumask(struct padata_instance *pinst, int cpumask_type,
 			      cpumask_var_t cpumask);
-extern int padata_set_cpumasks(struct padata_instance *pinst,
-			       cpumask_var_t pcpumask,
-			       cpumask_var_t cbcpumask);
-extern int padata_add_cpu(struct padata_instance *pinst, int cpu, int mask);
-extern int padata_remove_cpu(struct padata_instance *pinst, int cpu, int mask);
 extern int padata_start(struct padata_instance *pinst);
 extern void padata_stop(struct padata_instance *pinst);
 extern int padata_register_cpumask_notifier(struct padata_instance *pinst,
diff --git a/kernel/padata.c b/kernel/padata.c
index b38bea9..7436dd6 100644
--- a/kernel/padata.c
+++ b/kernel/padata.c
@@ -607,33 +607,6 @@ out_replace:
 }
 
 /**
- * padata_set_cpumasks - Set both parallel and serial cpumasks. The first
- *                       one is used by parallel workers and the second one
- *                       by the wokers doing serialization.
- *
- * @pinst: padata instance
- * @pcpumask: the cpumask to use for parallel workers
- * @cbcpumask: the cpumsak to use for serial workers
- */
-int padata_set_cpumasks(struct padata_instance *pinst, cpumask_var_t pcpumask,
-			cpumask_var_t cbcpumask)
-{
-	int err;
-
-	mutex_lock(&pinst->lock);
-	get_online_cpus();
-
-	err = __padata_set_cpumasks(pinst, pcpumask, cbcpumask);
-
-	put_online_cpus();
-	mutex_unlock(&pinst->lock);
-
-	return err;
-
-}
-EXPORT_SYMBOL(padata_set_cpumasks);
-
-/**
  * padata_set_cpumask: Sets specified by @cpumask_type cpumask to the value
  *                     equivalent to @cpumask.
  *
@@ -694,42 +667,6 @@ static int __padata_add_cpu(struct padata_instance *pinst, int cpu)
 	return 0;
 }
 
- /**
- * padata_add_cpu - add a cpu to one or both(parallel and serial)
- *                  padata cpumasks.
- *
- * @pinst: padata instance
- * @cpu: cpu to add
- * @mask: bitmask of flags specifying to which cpumask @cpu shuld be added.
- *        The @mask may be any combination of the following flags:
- *          PADATA_CPU_SERIAL   - serial cpumask
- *          PADATA_CPU_PARALLEL - parallel cpumask
- */
-
-int padata_add_cpu(struct padata_instance *pinst, int cpu, int mask)
-{
-	int err;
-
-	if (!(mask & (PADATA_CPU_SERIAL | PADATA_CPU_PARALLEL)))
-		return -EINVAL;
-
-	mutex_lock(&pinst->lock);
-
-	get_online_cpus();
-	if (mask & PADATA_CPU_SERIAL)
-		cpumask_set_cpu(cpu, pinst->cpumask.cbcpu);
-	if (mask & PADATA_CPU_PARALLEL)
-		cpumask_set_cpu(cpu, pinst->cpumask.pcpu);
-
-	err = __padata_add_cpu(pinst, cpu);
-	put_online_cpus();
-
-	mutex_unlock(&pinst->lock);
-
-	return err;
-}
-EXPORT_SYMBOL(padata_add_cpu);
-
 static int __padata_remove_cpu(struct padata_instance *pinst, int cpu)
 {
 	struct parallel_data *pd = NULL;
@@ -754,41 +691,6 @@ static int __padata_remove_cpu(struct padata_instance *pinst, int cpu)
 	return 0;
 }
 
- /**
- * padata_remove_cpu - remove a cpu from the one or both(serial and parallel)
- *                     padata cpumasks.
- *
- * @pinst: padata instance
- * @cpu: cpu to remove
- * @mask: bitmask specifying from which cpumask @cpu should be removed
- *        The @mask may be any combination of the following flags:
- *          PADATA_CPU_SERIAL   - serial cpumask
- *          PADATA_CPU_PARALLEL - parallel cpumask
- */
-int padata_remove_cpu(struct padata_instance *pinst, int cpu, int mask)
-{
-	int err;
-
-	if (!(mask & (PADATA_CPU_SERIAL | PADATA_CPU_PARALLEL)))
-		return -EINVAL;
-
-	mutex_lock(&pinst->lock);
-
-	get_online_cpus();
-	if (mask & PADATA_CPU_SERIAL)
-		cpumask_clear_cpu(cpu, pinst->cpumask.cbcpu);
-	if (mask & PADATA_CPU_PARALLEL)
-		cpumask_clear_cpu(cpu, pinst->cpumask.pcpu);
-
-	err = __padata_remove_cpu(pinst, cpu);
-	put_online_cpus();
-
-	mutex_unlock(&pinst->lock);
-
-	return err;
-}
-EXPORT_SYMBOL(padata_remove_cpu);
-
 /**
  * padata_start - start the parallel processing
  *
@@ -1091,7 +993,6 @@ err_free_inst:
 err:
 	return NULL;
 }
-EXPORT_SYMBOL(padata_alloc);
 
 /**
  * padata_free - free a padata instance
-- 
2.1.4
