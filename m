Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F103233469C;
	Mon, 13 Jul 2026 22:33:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783981987; cv=none; b=T00DLJ6pGHES0cnsMXOAlNuVGGxc8tFTnFGYTmhdIyZRJkvLGp59uje1OB9tTy1SbeQDny+cGKoWU6+wIxMzrQFNQK5cmXIAkYRn6HLCLaz8R8O4OPa6jtUOSS9v50xbSMKg9gbHHRJiUQ9HF1enRGEY1jcUMChaTTjv5Vk1aks=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783981987; c=relaxed/simple;
	bh=4bn5Jx/9uPg3tZjT0JcCU9E3LET33i4PzoMmTs+HVO0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=H8KdjpDotmnFHUdjIYYodqAz5JECeWh6rIEMwJFA9nKJhTEIM558tiuXryJeMyCDKRVVSWu7W4t67jOMkKfjrleiSYdsyjksOoKf/dfr12kkSHTSsp6gZQUe4+r7Tw2lzKW50CuI2NlxgPko+7Fl+M85LKN/SXvqKjUPJun7bdY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=FaTMl/E6; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="FaTMl/E6"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 476C81F00A3A;
	Mon, 13 Jul 2026 22:33:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1783981984;
	bh=gTyG441U6DBwV1S4W3Of+q7rzn2iOjMuvmmLmlxlnCc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=FaTMl/E6MPwyP7Gt7sMitlLxqVJPI7lFucKKl+io8Pfw9F0IG3ut0iSdlz3non0Uz
	 1C5tEBEOj543bxTzuF2Dr6fzmfvAaP0R+Hdu9z+gfE3BMhSpFPcVA/rZSYujp6H3hF
	 kO6oek2370tLbgebwCeIOHE1gHjAfikTXOigvIg4rAjzQ0Hr6zywRd6x8/BulYVvYO
	 M8SJn0GV72MjQ9IVPy5C2WtiUnv1GoqyIC2UtNKqJndA26/cvsxOFRZQ8WhQZOxRE9
	 j+kkHwADiiRv6cab6Upe6mbE6YJpvbiyW7RtHagtYWU1EpfpXbdewXkXITKRP5Ba0n
	 JgbUzFzCmhOBg==
From: Eric Biggers <ebiggers@kernel.org>
To: linux-crypto@vger.kernel.org,
	Herbert Xu <herbert@gondor.apana.org.au>
Cc: netdev@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Steffen Klassert <steffen.klassert@secunet.com>,
	Thomas Huth <thuth@redhat.com>,
	Eric Biggers <ebiggers@kernel.org>
Subject: [PATCH 2/2] padata: Remove serialized job support
Date: Mon, 13 Jul 2026 18:32:34 -0400
Message-ID: <20260713223234.24812-3-ebiggers@kernel.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260713223234.24812-1-ebiggers@kernel.org>
References: <20260713223234.24812-1-ebiggers@kernel.org>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Now that pcrypt has been removed, also remove all the code in padata
whose only user was pcrypt.

Cc: Steffen Klassert <steffen.klassert@secunet.com>
Signed-off-by: Eric Biggers <ebiggers@kernel.org>
---
 Documentation/core-api/padata.rst | 145 +----
 include/linux/padata.h            | 145 +----
 kernel/padata.c                   | 902 +-----------------------------
 3 files changed, 16 insertions(+), 1176 deletions(-)

diff --git a/Documentation/core-api/padata.rst b/Documentation/core-api/padata.rst
index 05b73c6c105f..d7dc7e33054d 100644
--- a/Documentation/core-api/padata.rst
+++ b/Documentation/core-api/padata.rst
@@ -7,152 +7,11 @@ The padata parallel execution mechanism
 :Date: May 2020
 
 Padata is a mechanism by which the kernel can farm jobs out to be done in
-parallel on multiple CPUs while optionally retaining their ordering.
+parallel on multiple CPUs while coordinating between threads.
 
-It was originally developed for IPsec, which needs to perform encryption and
-decryption on large numbers of packets without reordering those packets.  This
-is currently the sole consumer of padata's serialized job support.
-
-Padata also supports multithreaded jobs, splitting up the job evenly while load
+Padata supports multithreaded jobs, splitting up the job evenly while load
 balancing and coordinating between threads.
 
-Running Serialized Jobs
-=======================
-
-Initializing
-------------
-
-The first step in using padata to run serialized jobs is to set up a
-padata_instance structure for overall control of how jobs are to be run::
-
-    #include <linux/padata.h>
-
-    struct padata_instance *padata_alloc(const char *name);
-
-'name' simply identifies the instance.
-
-Then, complete padata initialization by allocating a padata_shell::
-
-   struct padata_shell *padata_alloc_shell(struct padata_instance *pinst);
-
-A padata_shell is used to submit a job to padata and allows a series of such
-jobs to be serialized independently.  A padata_instance may have one or more
-padata_shells associated with it, each allowing a separate series of jobs.
-
-Modifying cpumasks
-------------------
-
-The CPUs used to run jobs can be changed in two ways, programmatically with
-padata_set_cpumask() or via sysfs.  The former is defined::
-
-    int padata_set_cpumask(struct padata_instance *pinst, int cpumask_type,
-			   cpumask_var_t cpumask);
-
-Here cpumask_type is one of PADATA_CPU_PARALLEL or PADATA_CPU_SERIAL, where a
-parallel cpumask describes which processors will be used to execute jobs
-submitted to this instance in parallel and a serial cpumask defines which
-processors are allowed to be used as the serialization callback processor.
-cpumask specifies the new cpumask to use.
-
-There may be sysfs files for an instance's cpumasks.  For example, pcrypt's
-live in /sys/kernel/pcrypt/<instance-name>.  Within an instance's directory
-there are two files, parallel_cpumask and serial_cpumask, and either cpumask
-may be changed by echoing a bitmask into the file, for example::
-
-    echo f > /sys/kernel/pcrypt/pencrypt/parallel_cpumask
-
-Reading one of these files shows the user-supplied cpumask, which may be
-different from the 'usable' cpumask.
-
-Padata maintains two pairs of cpumasks internally, the user-supplied cpumasks
-and the 'usable' cpumasks.  (Each pair consists of a parallel and a serial
-cpumask.)  The user-supplied cpumasks default to all possible CPUs on instance
-allocation and may be changed as above.  The usable cpumasks are always a
-subset of the user-supplied cpumasks and contain only the online CPUs in the
-user-supplied masks; these are the cpumasks padata actually uses.  So it is
-legal to supply a cpumask to padata that contains offline CPUs.  Once an
-offline CPU in the user-supplied cpumask comes online, padata is going to use
-it.
-
-Changing the CPU masks are expensive operations, so it should not be done with
-great frequency.
-
-Running A Job
--------------
-
-Actually submitting work to the padata instance requires the creation of a
-padata_priv structure, which represents one job::
-
-    struct padata_priv {
-        /* Other stuff here... */
-	void                    (*parallel)(struct padata_priv *padata);
-	void                    (*serial)(struct padata_priv *padata);
-    };
-
-This structure will almost certainly be embedded within some larger
-structure specific to the work to be done.  Most of its fields are private to
-padata, but the structure should be zeroed at initialisation time, and the
-parallel() and serial() functions should be provided.  Those functions will
-be called in the process of getting the work done as we will see
-momentarily.
-
-The submission of the job is done with::
-
-    int padata_do_parallel(struct padata_shell *ps,
-		           struct padata_priv *padata, int *cb_cpu);
-
-The ps and padata structures must be set up as described above; cb_cpu
-points to the preferred CPU to be used for the final callback when the job is
-done; it must be in the current instance's CPU mask (if not the cb_cpu pointer
-is updated to point to the CPU actually chosen).  The return value from
-padata_do_parallel() is zero on success, indicating that the job is in
-progress. -EBUSY means that somebody, somewhere else is messing with the
-instance's CPU mask, while -EINVAL is a complaint about cb_cpu not being in the
-serial cpumask, no online CPUs in the parallel or serial cpumasks, or a stopped
-instance.
-
-Each job submitted to padata_do_parallel() will, in turn, be passed to
-exactly one call to the above-mentioned parallel() function, on one CPU, so
-true parallelism is achieved by submitting multiple jobs.  parallel() runs with
-software interrupts disabled and thus cannot sleep.  The parallel()
-function gets the padata_priv structure pointer as its lone parameter;
-information about the actual work to be done is probably obtained by using
-container_of() to find the enclosing structure.
-
-Note that parallel() has no return value; the padata subsystem assumes that
-parallel() will take responsibility for the job from this point.  The job
-need not be completed during this call, but, if parallel() leaves work
-outstanding, it should be prepared to be called again with a new job before
-the previous one completes.
-
-Serializing Jobs
-----------------
-
-When a job does complete, parallel() (or whatever function actually finishes
-the work) should inform padata of the fact with a call to::
-
-    void padata_do_serial(struct padata_priv *padata);
-
-At some point in the future, padata_do_serial() will trigger a call to the
-serial() function in the padata_priv structure.  That call will happen on
-the CPU requested in the initial call to padata_do_parallel(); it, too, is
-run with local software interrupts disabled.
-Note that this call may be deferred for a while since the padata code takes
-pains to ensure that jobs are completed in the order in which they were
-submitted.
-
-Destroying
-----------
-
-Cleaning up a padata instance predictably involves calling the two free
-functions that correspond to the allocation in reverse::
-
-    void padata_free_shell(struct padata_shell *ps);
-    void padata_free(struct padata_instance *pinst);
-
-It is the user's responsibility to ensure all outstanding jobs are complete
-before any of the above are called.
-
 Running Multithreaded Jobs
 ==========================
 
diff --git a/include/linux/padata.h b/include/linux/padata.h
index b6232bea6edf..ea45ea680cb7 100644
--- a/include/linux/padata.h
+++ b/include/linux/padata.h
@@ -12,112 +12,8 @@
 #ifndef PADATA_H
 #define PADATA_H
 
-#include <linux/refcount.h>
-#include <linux/compiler_types.h>
-#include <linux/workqueue.h>
-#include <linux/spinlock.h>
-#include <linux/list.h>
-#include <linux/kobject.h>
-
-#define PADATA_CPU_SERIAL   0x01
-#define PADATA_CPU_PARALLEL 0x02
-
-/**
- * struct padata_priv - Represents one job
- *
- * @list: List entry, to attach to the padata lists.
- * @pd: Pointer to the internal control structure.
- * @cb_cpu: Callback cpu for serializatioon.
- * @seq_nr: Sequence number of the parallelized data object.
- * @info: Used to pass information from the parallel to the serial function.
- * @parallel: Parallel execution function.
- * @serial: Serial complete function.
- */
-struct padata_priv {
-	struct list_head	list;
-	struct parallel_data	*pd;
-	int			cb_cpu;
-	unsigned int		seq_nr;
-	int			info;
-	void                    (*parallel)(struct padata_priv *padata);
-	void                    (*serial)(struct padata_priv *padata);
-};
-
-/**
- * struct padata_list - one per work type per CPU
- *
- * @list: List head.
- * @lock: List lock.
- */
-struct padata_list {
-	struct list_head        list;
-	spinlock_t              lock;
-};
-
-/**
-* struct padata_serial_queue - The percpu padata serial queue
-*
-* @serial: List to wait for serialization after reordering.
-* @work: work struct for serialization.
-* @pd: Backpointer to the internal control structure.
-*/
-struct padata_serial_queue {
-       struct padata_list    serial;
-       struct work_struct    work;
-       struct parallel_data *pd;
-};
-
-/**
- * struct padata_cpumask - The cpumasks for the parallel/serial workers
- *
- * @pcpu: cpumask for the parallel workers.
- * @cbcpu: cpumask for the serial (callback) workers.
- */
-struct padata_cpumask {
-	cpumask_var_t	pcpu;
-	cpumask_var_t	cbcpu;
-};
-
-/**
- * struct parallel_data - Internal control structure, covers everything
- * that depends on the cpumask in use.
- *
- * @ps: padata_shell object.
- * @reorder_list: percpu reorder lists
- * @squeue: percpu padata queues used for serialuzation.
- * @refcnt: Number of objects holding a reference on this parallel_data.
- * @seq_nr: Sequence number of the parallelized data object.
- * @processed: Number of already processed objects.
- * @cpu: Next CPU to be processed.
- * @cpumask: The cpumasks in use for parallel and serial workers.
- */
-struct parallel_data {
-	struct padata_shell		*ps;
-	struct padata_list		__percpu *reorder_list;
-	struct padata_serial_queue	__percpu *squeue;
-	refcount_t			refcnt;
-	unsigned int			seq_nr;
-	unsigned int			processed;
-	int				cpu;
-	struct padata_cpumask		cpumask;
-};
-
-/**
- * struct padata_shell - Wrapper around struct parallel_data, its
- * purpose is to allow the underlying control structure to be replaced
- * on the fly using RCU.
- *
- * @pinst: padat instance.
- * @pd: Actual parallel_data structure which may be substituted on the fly.
- * @opd: Pointer to old pd to be freed by padata_replace.
- * @list: List entry in padata_instance list.
- */
-struct padata_shell {
-	struct padata_instance		*pinst;
-	struct parallel_data __rcu	*pd;
-	struct parallel_data		*opd;
-	struct list_head		list;
-};
+#include <linux/init.h>
+#include <linux/types.h>
 
 /**
  * struct padata_mt_job - represents one multithreaded job
@@ -146,46 +42,9 @@ struct padata_mt_job {
 	bool			numa_aware;
 };
 
-/**
- * struct padata_instance - The overall control structure.
- *
- * @cpuhp_node: Linkage for CPU hotplug callbacks.
- * @parallel_wq: The workqueue used for parallel work.
- * @serial_wq: The workqueue used for serial work.
- * @pslist: List of padata_shell objects attached to this instance.
- * @cpumask: User supplied cpumasks for parallel and serial works.
- * @validate_cpumask: Internal cpumask used to validate @cpumask during hotplug.
- * @kobj: padata instance kernel object.
- * @lock: padata instance lock.
- * @flags: padata flags.
- */
-struct padata_instance {
-	struct hlist_node		cpuhp_node;
-	struct workqueue_struct		*parallel_wq;
-	struct workqueue_struct		*serial_wq;
-	struct list_head		pslist;
-	struct padata_cpumask		cpumask;
-	cpumask_var_t			validate_cpumask;
-	struct kobject                   kobj;
-	struct mutex			 lock;
-	u8				 flags;
-#define	PADATA_INIT	1
-#define	PADATA_RESET	2
-#define	PADATA_INVALID	4
-};
-
 #ifdef CONFIG_PADATA
 extern void __init padata_init(void);
-extern struct padata_instance *padata_alloc(const char *name);
-extern void padata_free(struct padata_instance *pinst);
-extern struct padata_shell *padata_alloc_shell(struct padata_instance *pinst);
-extern void padata_free_shell(struct padata_shell *ps);
-extern int padata_do_parallel(struct padata_shell *ps,
-			      struct padata_priv *padata, int *cb_cpu);
-extern void padata_do_serial(struct padata_priv *padata);
 extern void __init padata_do_multithreaded(struct padata_mt_job *job);
-extern int padata_set_cpumask(struct padata_instance *pinst, int cpumask_type,
-			      cpumask_var_t cpumask);
 #else
 static inline void __init padata_init(void) {}
 static inline void __init padata_do_multithreaded(struct padata_mt_job *job)
diff --git a/kernel/padata.c b/kernel/padata.c
index 0d3ea1b68b1f..6eb130d31024 100644
--- a/kernel/padata.c
+++ b/kernel/padata.c
@@ -1,6 +1,6 @@
 // SPDX-License-Identifier: GPL-2.0
 /*
- * padata.c - generic interface to process data streams in parallel
+ * padata.c - generic interface to run multithreaded jobs
  *
  * See Documentation/core-api/padata.rst for more information.
  *
@@ -11,17 +11,17 @@
  * Author: Daniel Jordan <daniel.m.jordan@oracle.com>
  */
 
+#include <linux/atomic.h>
 #include <linux/completion.h>
-#include <linux/export.h>
 #include <linux/cpumask.h>
-#include <linux/err.h>
-#include <linux/cpu.h>
+#include <linux/init.h>
+#include <linux/kernel.h>
+#include <linux/list.h>
+#include <linux/nodemask.h>
 #include <linux/padata.h>
-#include <linux/mutex.h>
-#include <linux/sched.h>
 #include <linux/slab.h>
-#include <linux/sysfs.h>
-#include <linux/rcupdate.h>
+#include <linux/spinlock.h>
+#include <linux/workqueue.h>
 
 #define	PADATA_WORK_ONSTACK	1	/* Work's memory is on stack */
 
@@ -44,36 +44,8 @@ struct padata_mt_job_state {
 	unsigned long		chunk_size;
 };
 
-static void padata_free_pd(struct parallel_data *pd);
 static void __init padata_mt_helper(struct work_struct *work);
 
-static inline void padata_get_pd(struct parallel_data *pd)
-{
-	refcount_inc(&pd->refcnt);
-}
-
-static inline void padata_put_pd_cnt(struct parallel_data *pd, int cnt)
-{
-	if (refcount_sub_and_test(cnt, &pd->refcnt))
-		padata_free_pd(pd);
-}
-
-static inline void padata_put_pd(struct parallel_data *pd)
-{
-	padata_put_pd_cnt(pd, 1);
-}
-
-static int padata_cpu_hash(struct parallel_data *pd, unsigned int seq_nr)
-{
-	/*
-	 * Hash the sequence numbers to the cpus by taking
-	 * seq_nr mod. number of cpus in use.
-	 */
-	int cpu_index = seq_nr % cpumask_weight(pd->cpumask.pcpu);
-
-	return cpumask_nth(cpu_index, pd->cpumask.pcpu);
-}
-
 static struct padata_work *padata_work_alloc(void)
 {
 	struct padata_work *pw;
@@ -147,260 +119,6 @@ static void __init padata_works_free(struct list_head *works)
 	spin_unlock_bh(&padata_works_lock);
 }
 
-static void padata_parallel_worker(struct work_struct *parallel_work)
-{
-	struct padata_work *pw = container_of(parallel_work, struct padata_work,
-					      pw_work);
-	struct padata_priv *padata = pw->pw_data;
-
-	local_bh_disable();
-	padata->parallel(padata);
-	spin_lock(&padata_works_lock);
-	padata_work_free(pw);
-	spin_unlock(&padata_works_lock);
-	local_bh_enable();
-}
-
-/**
- * padata_do_parallel - padata parallelization function
- *
- * @ps: padatashell
- * @padata: object to be parallelized
- * @cb_cpu: pointer to the CPU that the serialization callback function should
- *          run on.  If it's not in the serial cpumask of @pinst
- *          (i.e. cpumask.cbcpu), this function selects a fallback CPU and if
- *          none found, returns -EINVAL.
- *
- * The parallelization callback function will run with BHs off.
- * Note: Every object which is parallelized by padata_do_parallel
- * must be seen by padata_do_serial.
- *
- * Return: 0 on success or else negative error code.
- */
-int padata_do_parallel(struct padata_shell *ps,
-		       struct padata_priv *padata, int *cb_cpu)
-{
-	struct padata_instance *pinst = ps->pinst;
-	struct parallel_data *pd;
-	struct padata_work *pw;
-	int cpu_index, err;
-
-	rcu_read_lock_bh();
-
-	pd = rcu_dereference_bh(ps->pd);
-
-	err = -EINVAL;
-	if (!(pinst->flags & PADATA_INIT) || pinst->flags & PADATA_INVALID)
-		goto out;
-
-	if (!cpumask_test_cpu(*cb_cpu, pd->cpumask.cbcpu)) {
-		if (cpumask_empty(pd->cpumask.cbcpu))
-			goto out;
-
-		/* Select an alternate fallback CPU and notify the caller. */
-		cpu_index = *cb_cpu % cpumask_weight(pd->cpumask.cbcpu);
-		*cb_cpu = cpumask_nth(cpu_index, pd->cpumask.cbcpu);
-	}
-
-	err = -EBUSY;
-	if ((pinst->flags & PADATA_RESET))
-		goto out;
-
-	padata_get_pd(pd);
-	padata->pd = pd;
-	padata->cb_cpu = *cb_cpu;
-
-	spin_lock(&padata_works_lock);
-	padata->seq_nr = ++pd->seq_nr;
-	pw = padata_work_alloc();
-	spin_unlock(&padata_works_lock);
-
-	if (!pw) {
-		/* Maximum works limit exceeded, run in the current task. */
-		padata->parallel(padata);
-	}
-
-	rcu_read_unlock_bh();
-
-	if (pw) {
-		padata_work_init(pw, padata_parallel_worker, padata, 0);
-		queue_work(pinst->parallel_wq, &pw->pw_work);
-	}
-
-	return 0;
-out:
-	rcu_read_unlock_bh();
-
-	return err;
-}
-EXPORT_SYMBOL(padata_do_parallel);
-
-/*
- * padata_find_next - Find the next object that needs serialization.
- *
- * Return:
- * * A pointer to the control struct of the next object that needs
- *   serialization, if present in one of the percpu reorder queues.
- * * NULL, if the next object that needs serialization will
- *   be parallel processed by another cpu and is not yet present in
- *   the cpu's reorder queue.
- */
-static struct padata_priv *padata_find_next(struct parallel_data *pd, int cpu,
-					    unsigned int processed)
-{
-	struct padata_priv *padata;
-	struct padata_list *reorder;
-
-	reorder = per_cpu_ptr(pd->reorder_list, cpu);
-
-	spin_lock(&reorder->lock);
-	if (list_empty(&reorder->list))
-		goto notfound;
-
-	padata = list_entry(reorder->list.next, struct padata_priv, list);
-
-	/*
-	 * Checks the rare case where two or more parallel jobs have hashed to
-	 * the same CPU and one of the later ones finishes first.
-	 */
-	if (padata->seq_nr != processed)
-		goto notfound;
-
-	list_del_init(&padata->list);
-	spin_unlock(&reorder->lock);
-	return padata;
-
-notfound:
-	pd->processed = processed;
-	pd->cpu = cpu;
-	spin_unlock(&reorder->lock);
-	return NULL;
-}
-
-static void padata_reorder(struct padata_priv *padata)
-{
-	struct parallel_data *pd = padata->pd;
-	struct padata_instance *pinst = pd->ps->pinst;
-	unsigned int processed;
-	int cpu;
-
-	processed = pd->processed;
-	cpu = pd->cpu;
-
-	do {
-		struct padata_serial_queue *squeue;
-		int cb_cpu;
-
-		processed++;
-		/* When sequence wraps around, reset to the first CPU. */
-		if (unlikely(processed == 0))
-			cpu = cpumask_first(pd->cpumask.pcpu);
-		else
-			cpu = cpumask_next_wrap(cpu, pd->cpumask.pcpu);
-
-		cb_cpu = padata->cb_cpu;
-		squeue = per_cpu_ptr(pd->squeue, cb_cpu);
-
-		spin_lock(&squeue->serial.lock);
-		list_add_tail(&padata->list, &squeue->serial.list);
-		queue_work_on(cb_cpu, pinst->serial_wq, &squeue->work);
-
-		/*
-		 * If the next object that needs serialization is parallel
-		 * processed by another cpu and is still on it's way to the
-		 * cpu's reorder queue, end the loop.
-		 */
-		padata = padata_find_next(pd, cpu, processed);
-		spin_unlock(&squeue->serial.lock);
-	} while (padata);
-}
-
-static void padata_serial_worker(struct work_struct *serial_work)
-{
-	struct padata_serial_queue *squeue;
-	struct parallel_data *pd;
-	LIST_HEAD(local_list);
-	int cnt;
-
-	local_bh_disable();
-	squeue = container_of(serial_work, struct padata_serial_queue, work);
-	pd = squeue->pd;
-
-	spin_lock(&squeue->serial.lock);
-	list_replace_init(&squeue->serial.list, &local_list);
-	spin_unlock(&squeue->serial.lock);
-
-	cnt = 0;
-
-	while (!list_empty(&local_list)) {
-		struct padata_priv *padata;
-
-		padata = list_entry(local_list.next,
-				    struct padata_priv, list);
-
-		list_del_init(&padata->list);
-
-		padata->serial(padata);
-		cnt++;
-	}
-	local_bh_enable();
-
-	padata_put_pd_cnt(pd, cnt);
-}
-
-/**
- * padata_do_serial - padata serialization function
- *
- * @padata: object to be serialized.
- *
- * padata_do_serial must be called for every parallelized object.
- * The serialization callback function will run with BHs off.
- */
-void padata_do_serial(struct padata_priv *padata)
-{
-	struct parallel_data *pd = padata->pd;
-	int hashed_cpu = padata_cpu_hash(pd, padata->seq_nr);
-	struct padata_list *reorder = per_cpu_ptr(pd->reorder_list, hashed_cpu);
-	struct padata_priv *cur;
-	struct list_head *pos;
-	bool gotit = true;
-
-	spin_lock(&reorder->lock);
-	/* Sort in ascending order of sequence number. */
-	list_for_each_prev(pos, &reorder->list) {
-		cur = list_entry(pos, struct padata_priv, list);
-		/* Compare by difference to consider integer wrap around */
-		if ((signed int)(cur->seq_nr - padata->seq_nr) < 0)
-			break;
-	}
-	if (padata->seq_nr != pd->processed) {
-		gotit = false;
-		list_add(&padata->list, pos);
-	}
-	spin_unlock(&reorder->lock);
-
-	if (gotit)
-		padata_reorder(padata);
-}
-EXPORT_SYMBOL(padata_do_serial);
-
-static int padata_setup_cpumasks(struct padata_instance *pinst)
-{
-	struct workqueue_attrs *attrs;
-	int err;
-
-	attrs = alloc_workqueue_attrs();
-	if (!attrs)
-		return -ENOMEM;
-
-	/* Restrict parallel_wq workers to pd->cpumask.pcpu. */
-	cpumask_copy(attrs->cpumask, pinst->cpumask.pcpu);
-	err = apply_workqueue_attrs(pinst->parallel_wq, attrs);
-	free_workqueue_attrs(attrs);
-
-	return err;
-}
-
 static void __init padata_mt_helper(struct work_struct *w)
 {
 	struct padata_work *pw = container_of(w, struct padata_work, pw_work);
@@ -506,613 +224,17 @@ void __init padata_do_multithreaded(struct padata_mt_job *job)
 	padata_works_free(&works);
 }
 
-/* Initialize all percpu queues used by serial workers */
-static void padata_init_squeues(struct parallel_data *pd)
-{
-	int cpu;
-	struct padata_serial_queue *squeue;
-
-	for_each_cpu(cpu, pd->cpumask.cbcpu) {
-		squeue = per_cpu_ptr(pd->squeue, cpu);
-		squeue->pd = pd;
-		INIT_LIST_HEAD(&squeue->serial.list);
-		spin_lock_init(&squeue->serial.lock);
-		INIT_WORK(&squeue->work, padata_serial_worker);
-	}
-}
-
-/* Initialize per-CPU reorder lists */
-static void padata_init_reorder_list(struct parallel_data *pd)
-{
-	int cpu;
-	struct padata_list *list;
-
-	for_each_cpu(cpu, pd->cpumask.pcpu) {
-		list = per_cpu_ptr(pd->reorder_list, cpu);
-		INIT_LIST_HEAD(&list->list);
-		spin_lock_init(&list->lock);
-	}
-}
-
-/* Allocate and initialize the internal cpumask dependend resources. */
-static struct parallel_data *padata_alloc_pd(struct padata_shell *ps,
-					     int offlining_cpu)
-{
-	struct padata_instance *pinst = ps->pinst;
-	struct parallel_data *pd;
-
-	pd = kzalloc_obj(struct parallel_data);
-	if (!pd)
-		goto err;
-
-	pd->reorder_list = alloc_percpu(struct padata_list);
-	if (!pd->reorder_list)
-		goto err_free_pd;
-
-	pd->squeue = alloc_percpu(struct padata_serial_queue);
-	if (!pd->squeue)
-		goto err_free_reorder_list;
-
-	pd->ps = ps;
-
-	if (!alloc_cpumask_var(&pd->cpumask.pcpu, GFP_KERNEL))
-		goto err_free_squeue;
-	if (!alloc_cpumask_var(&pd->cpumask.cbcpu, GFP_KERNEL))
-		goto err_free_pcpu;
-
-	cpumask_and(pd->cpumask.pcpu, pinst->cpumask.pcpu, cpu_online_mask);
-	cpumask_and(pd->cpumask.cbcpu, pinst->cpumask.cbcpu, cpu_online_mask);
-	if (offlining_cpu >= 0) {
-		__cpumask_clear_cpu(offlining_cpu, pd->cpumask.pcpu);
-		__cpumask_clear_cpu(offlining_cpu, pd->cpumask.cbcpu);
-	}
-
-	padata_init_reorder_list(pd);
-	padata_init_squeues(pd);
-	pd->seq_nr = -1;
-	refcount_set(&pd->refcnt, 1);
-	pd->cpu = cpumask_first(pd->cpumask.pcpu);
-
-	return pd;
-
-err_free_pcpu:
-	free_cpumask_var(pd->cpumask.pcpu);
-err_free_squeue:
-	free_percpu(pd->squeue);
-err_free_reorder_list:
-	free_percpu(pd->reorder_list);
-err_free_pd:
-	kfree(pd);
-err:
-	return NULL;
-}
-
-static void padata_free_pd(struct parallel_data *pd)
-{
-	free_cpumask_var(pd->cpumask.pcpu);
-	free_cpumask_var(pd->cpumask.cbcpu);
-	free_percpu(pd->reorder_list);
-	free_percpu(pd->squeue);
-	kfree(pd);
-}
-
-static void __padata_start(struct padata_instance *pinst)
-{
-	pinst->flags |= PADATA_INIT;
-}
-
-static void __padata_stop(struct padata_instance *pinst)
-{
-	if (!(pinst->flags & PADATA_INIT))
-		return;
-
-	pinst->flags &= ~PADATA_INIT;
-
-	synchronize_rcu();
-}
-
-/* Replace the internal control structure with a new one. */
-static int padata_replace_one(struct padata_shell *ps, int offlining_cpu)
-{
-	struct parallel_data *pd_new;
-
-	pd_new = padata_alloc_pd(ps, offlining_cpu);
-	if (!pd_new)
-		return -ENOMEM;
-
-	ps->opd = rcu_dereference_protected(ps->pd, 1);
-	rcu_assign_pointer(ps->pd, pd_new);
-
-	return 0;
-}
-
-static int padata_replace(struct padata_instance *pinst, int offlining_cpu)
-{
-	struct padata_shell *ps;
-	int err = 0;
-
-	pinst->flags |= PADATA_RESET;
-
-	list_for_each_entry(ps, &pinst->pslist, list) {
-		err = padata_replace_one(ps, offlining_cpu);
-		if (err)
-			break;
-	}
-
-	synchronize_rcu();
-
-	list_for_each_entry_continue_reverse(ps, &pinst->pslist, list)
-		padata_put_pd(ps->opd);
-
-	pinst->flags &= ~PADATA_RESET;
-
-	return err;
-}
-
-/* If cpumask contains no active cpu, we mark the instance as invalid. */
-static bool padata_validate_cpumask(struct padata_instance *pinst,
-				    const struct cpumask *cpumask,
-				    int offlining_cpu)
-{
-	cpumask_copy(pinst->validate_cpumask, cpu_online_mask);
-
-	/*
-	 * @offlining_cpu is still in cpu_online_mask, so remove it here for
-	 * validation.  Using a sub-CPUHP_TEARDOWN_CPU hotplug state where
-	 * @offlining_cpu wouldn't be in the online mask doesn't work because
-	 * padata_cpu_offline() can fail but such a state doesn't allow failure.
-	 */
-	if (offlining_cpu >= 0)
-		__cpumask_clear_cpu(offlining_cpu, pinst->validate_cpumask);
-
-	if (!cpumask_intersects(cpumask, pinst->validate_cpumask)) {
-		pinst->flags |= PADATA_INVALID;
-		return false;
-	}
-
-	pinst->flags &= ~PADATA_INVALID;
-	return true;
-}
-
-static int __padata_set_cpumasks(struct padata_instance *pinst,
-				 cpumask_var_t pcpumask,
-				 cpumask_var_t cbcpumask)
-{
-	int valid;
-	int err;
-
-	valid = padata_validate_cpumask(pinst, pcpumask, -1);
-	if (!valid) {
-		__padata_stop(pinst);
-		goto out_replace;
-	}
-
-	valid = padata_validate_cpumask(pinst, cbcpumask, -1);
-	if (!valid)
-		__padata_stop(pinst);
-
-out_replace:
-	cpumask_copy(pinst->cpumask.pcpu, pcpumask);
-	cpumask_copy(pinst->cpumask.cbcpu, cbcpumask);
-
-	err = padata_setup_cpumasks(pinst) ?: padata_replace(pinst, -1);
-
-	if (valid)
-		__padata_start(pinst);
-
-	return err;
-}
-
-/**
- * padata_set_cpumask - Sets specified by @cpumask_type cpumask to the value
- *                      equivalent to @cpumask.
- * @pinst: padata instance
- * @cpumask_type: PADATA_CPU_SERIAL or PADATA_CPU_PARALLEL corresponding
- *                to parallel and serial cpumasks respectively.
- * @cpumask: the cpumask to use
- *
- * Return: 0 on success or negative error code
- */
-int padata_set_cpumask(struct padata_instance *pinst, int cpumask_type,
-		       cpumask_var_t cpumask)
-{
-	struct cpumask *serial_mask, *parallel_mask;
-	int err = -EINVAL;
-
-	cpus_read_lock();
-	mutex_lock(&pinst->lock);
-
-	switch (cpumask_type) {
-	case PADATA_CPU_PARALLEL:
-		serial_mask = pinst->cpumask.cbcpu;
-		parallel_mask = cpumask;
-		break;
-	case PADATA_CPU_SERIAL:
-		parallel_mask = pinst->cpumask.pcpu;
-		serial_mask = cpumask;
-		break;
-	default:
-		 goto out;
-	}
-
-	err =  __padata_set_cpumasks(pinst, parallel_mask, serial_mask);
-
-out:
-	mutex_unlock(&pinst->lock);
-	cpus_read_unlock();
-
-	return err;
-}
-EXPORT_SYMBOL(padata_set_cpumask);
-
-#ifdef CONFIG_HOTPLUG_CPU
-
-static inline int pinst_has_cpu(struct padata_instance *pinst, int cpu)
-{
-	return cpumask_test_cpu(cpu, pinst->cpumask.pcpu) ||
-		cpumask_test_cpu(cpu, pinst->cpumask.cbcpu);
-}
-
-static int padata_cpu_online(unsigned int cpu, struct hlist_node *node)
-{
-	struct padata_instance *pinst;
-	int ret;
-
-	pinst = hlist_entry_safe(node, struct padata_instance, cpuhp_node);
-	if (!pinst_has_cpu(pinst, cpu))
-		return 0;
-
-	mutex_lock(&pinst->lock);
-
-	ret = padata_replace(pinst, -1);
-
-	if (padata_validate_cpumask(pinst, pinst->cpumask.pcpu, -1) &&
-	    padata_validate_cpumask(pinst, pinst->cpumask.cbcpu, -1))
-		__padata_start(pinst);
-
-	mutex_unlock(&pinst->lock);
-	return ret;
-}
-
-static int padata_cpu_offline(unsigned int cpu, struct hlist_node *node)
-{
-	struct padata_instance *pinst;
-	int ret;
-
-	pinst = hlist_entry_safe(node, struct padata_instance, cpuhp_node);
-	if (!pinst_has_cpu(pinst, cpu))
-		return 0;
-
-	mutex_lock(&pinst->lock);
-
-	if (!padata_validate_cpumask(pinst, pinst->cpumask.pcpu, cpu) ||
-	    !padata_validate_cpumask(pinst, pinst->cpumask.cbcpu, cpu))
-		__padata_stop(pinst);
-
-	ret = padata_replace(pinst, cpu);
-
-	mutex_unlock(&pinst->lock);
-	return ret;
-}
-
-static enum cpuhp_state hp_online;
-#endif
-
-static void __padata_free(struct padata_instance *pinst)
-{
-#ifdef CONFIG_HOTPLUG_CPU
-	cpuhp_state_remove_instance_nocalls(hp_online, &pinst->cpuhp_node);
-#endif
-
-	WARN_ON(!list_empty(&pinst->pslist));
-
-	free_cpumask_var(pinst->cpumask.pcpu);
-	free_cpumask_var(pinst->cpumask.cbcpu);
-	free_cpumask_var(pinst->validate_cpumask);
-	destroy_workqueue(pinst->serial_wq);
-	destroy_workqueue(pinst->parallel_wq);
-	kfree(pinst);
-}
-
-#define kobj2pinst(_kobj)					\
-	container_of(_kobj, struct padata_instance, kobj)
-#define attr2pentry(_attr)					\
-	container_of_const(_attr, struct padata_sysfs_entry, attr)
-
-static void padata_sysfs_release(struct kobject *kobj)
-{
-	struct padata_instance *pinst = kobj2pinst(kobj);
-	__padata_free(pinst);
-}
-
-struct padata_sysfs_entry {
-	struct attribute attr;
-	ssize_t (*show)(struct padata_instance *, const struct attribute *, char *);
-	ssize_t (*store)(struct padata_instance *, const struct attribute *,
-			 const char *, size_t);
-};
-
-static ssize_t show_cpumask(struct padata_instance *pinst,
-			    const struct attribute *attr,  char *buf)
-{
-	struct cpumask *cpumask;
-	ssize_t len;
-
-	mutex_lock(&pinst->lock);
-	if (!strcmp(attr->name, "serial_cpumask"))
-		cpumask = pinst->cpumask.cbcpu;
-	else
-		cpumask = pinst->cpumask.pcpu;
-
-	len = snprintf(buf, PAGE_SIZE, "%*pb\n",
-		       nr_cpu_ids, cpumask_bits(cpumask));
-	mutex_unlock(&pinst->lock);
-	return len < PAGE_SIZE ? len : -EINVAL;
-}
-
-static ssize_t store_cpumask(struct padata_instance *pinst,
-			     const struct attribute *attr,
-			     const char *buf, size_t count)
-{
-	cpumask_var_t new_cpumask;
-	ssize_t ret;
-	int mask_type;
-
-	if (!alloc_cpumask_var(&new_cpumask, GFP_KERNEL))
-		return -ENOMEM;
-
-	ret = bitmap_parse(buf, count, cpumask_bits(new_cpumask),
-			   nr_cpumask_bits);
-	if (ret < 0)
-		goto out;
-
-	mask_type = !strcmp(attr->name, "serial_cpumask") ?
-		PADATA_CPU_SERIAL : PADATA_CPU_PARALLEL;
-	ret = padata_set_cpumask(pinst, mask_type, new_cpumask);
-	if (!ret)
-		ret = count;
-
-out:
-	free_cpumask_var(new_cpumask);
-	return ret;
-}
-
-#define PADATA_ATTR_RW(_name, _show_name, _store_name)		\
-	static const struct padata_sysfs_entry _name##_attr =	\
-		__ATTR(_name, 0644, _show_name, _store_name)
-#define PADATA_ATTR_RO(_name, _show_name)			\
-	static const struct padata_sysfs_entry _name##_attr =	\
-		__ATTR(_name, 0400, _show_name, NULL)
-
-PADATA_ATTR_RW(serial_cpumask, show_cpumask, store_cpumask);
-PADATA_ATTR_RW(parallel_cpumask, show_cpumask, store_cpumask);
-
-/*
- * Padata sysfs provides the following objects:
- * serial_cpumask   [RW] - cpumask for serial workers
- * parallel_cpumask [RW] - cpumask for parallel workers
- */
-static const struct attribute *const padata_default_attrs[] = {
-	&serial_cpumask_attr.attr,
-	&parallel_cpumask_attr.attr,
-	NULL,
-};
-ATTRIBUTE_GROUPS(padata_default);
-
-static ssize_t padata_sysfs_show(struct kobject *kobj,
-				 struct attribute *attr, char *buf)
-{
-	const struct padata_sysfs_entry *pentry;
-	struct padata_instance *pinst;
-	ssize_t ret = -EIO;
-
-	pinst = kobj2pinst(kobj);
-	pentry = attr2pentry(attr);
-	if (pentry->show)
-		ret = pentry->show(pinst, attr, buf);
-
-	return ret;
-}
-
-static ssize_t padata_sysfs_store(struct kobject *kobj, struct attribute *attr,
-				  const char *buf, size_t count)
-{
-	const struct padata_sysfs_entry *pentry;
-	struct padata_instance *pinst;
-	ssize_t ret = -EIO;
-
-	pinst = kobj2pinst(kobj);
-	pentry = attr2pentry(attr);
-	if (pentry->store)
-		ret = pentry->store(pinst, attr, buf, count);
-
-	return ret;
-}
-
-static const struct sysfs_ops padata_sysfs_ops = {
-	.show = padata_sysfs_show,
-	.store = padata_sysfs_store,
-};
-
-static const struct kobj_type padata_attr_type = {
-	.sysfs_ops = &padata_sysfs_ops,
-	.default_groups = padata_default_groups,
-	.release = padata_sysfs_release,
-};
-
-/**
- * padata_alloc - allocate and initialize a padata instance
- * @name: used to identify the instance
- *
- * Return: new instance on success, NULL on error
- */
-struct padata_instance *padata_alloc(const char *name)
-{
-	struct padata_instance *pinst;
-
-	pinst = kzalloc_obj(struct padata_instance);
-	if (!pinst)
-		goto err;
-
-	pinst->parallel_wq = alloc_workqueue("%s_parallel", WQ_UNBOUND, 0,
-					     name);
-	if (!pinst->parallel_wq)
-		goto err_free_inst;
-
-	cpus_read_lock();
-
-	pinst->serial_wq = alloc_workqueue("%s_serial",
-					   WQ_MEM_RECLAIM | WQ_CPU_INTENSIVE | WQ_PERCPU,
-					   1, name);
-	if (!pinst->serial_wq)
-		goto err_put_cpus;
-
-	if (!alloc_cpumask_var(&pinst->cpumask.pcpu, GFP_KERNEL))
-		goto err_free_serial_wq;
-	if (!alloc_cpumask_var(&pinst->cpumask.cbcpu, GFP_KERNEL))
-		goto err_free_p_mask;
-	if (!alloc_cpumask_var(&pinst->validate_cpumask, GFP_KERNEL))
-		goto err_free_cb_mask;
-
-	INIT_LIST_HEAD(&pinst->pslist);
-
-	cpumask_copy(pinst->cpumask.pcpu, cpu_possible_mask);
-	cpumask_copy(pinst->cpumask.cbcpu, cpu_possible_mask);
-
-	if (padata_setup_cpumasks(pinst))
-		goto err_free_v_mask;
-
-	__padata_start(pinst);
-
-	kobject_init(&pinst->kobj, &padata_attr_type);
-	mutex_init(&pinst->lock);
-
-#ifdef CONFIG_HOTPLUG_CPU
-	cpuhp_state_add_instance_nocalls_cpuslocked(hp_online,
-						    &pinst->cpuhp_node);
-#endif
-
-	cpus_read_unlock();
-
-	return pinst;
-
-err_free_v_mask:
-	free_cpumask_var(pinst->validate_cpumask);
-err_free_cb_mask:
-	free_cpumask_var(pinst->cpumask.cbcpu);
-err_free_p_mask:
-	free_cpumask_var(pinst->cpumask.pcpu);
-err_free_serial_wq:
-	destroy_workqueue(pinst->serial_wq);
-err_put_cpus:
-	cpus_read_unlock();
-	destroy_workqueue(pinst->parallel_wq);
-err_free_inst:
-	kfree(pinst);
-err:
-	return NULL;
-}
-EXPORT_SYMBOL(padata_alloc);
-
-/**
- * padata_free - free a padata instance
- *
- * @pinst: padata instance to free
- */
-void padata_free(struct padata_instance *pinst)
-{
-	kobject_put(&pinst->kobj);
-}
-EXPORT_SYMBOL(padata_free);
-
-/**
- * padata_alloc_shell - Allocate and initialize padata shell.
- *
- * @pinst: Parent padata_instance object.
- *
- * Return: new shell on success, NULL on error
- */
-struct padata_shell *padata_alloc_shell(struct padata_instance *pinst)
-{
-	struct parallel_data *pd;
-	struct padata_shell *ps;
-
-	ps = kzalloc_obj(*ps);
-	if (!ps)
-		goto out;
-
-	ps->pinst = pinst;
-
-	cpus_read_lock();
-	pd = padata_alloc_pd(ps, -1);
-	cpus_read_unlock();
-
-	if (!pd)
-		goto out_free_ps;
-
-	mutex_lock(&pinst->lock);
-	RCU_INIT_POINTER(ps->pd, pd);
-	list_add(&ps->list, &pinst->pslist);
-	mutex_unlock(&pinst->lock);
-
-	return ps;
-
-out_free_ps:
-	kfree(ps);
-out:
-	return NULL;
-}
-EXPORT_SYMBOL(padata_alloc_shell);
-
-/**
- * padata_free_shell - free a padata shell
- *
- * @ps: padata shell to free
- */
-void padata_free_shell(struct padata_shell *ps)
-{
-	struct parallel_data *pd;
-
-	if (!ps)
-		return;
-
-	mutex_lock(&ps->pinst->lock);
-	list_del(&ps->list);
-	pd = rcu_dereference_protected(ps->pd, 1);
-	padata_put_pd(pd);
-	mutex_unlock(&ps->pinst->lock);
-
-	kfree(ps);
-}
-EXPORT_SYMBOL(padata_free_shell);
-
 void __init padata_init(void)
 {
 	unsigned int i, possible_cpus;
-#ifdef CONFIG_HOTPLUG_CPU
-	int ret;
-
-	ret = cpuhp_setup_state_multi(CPUHP_AP_ONLINE_DYN, "padata:online",
-				      padata_cpu_online, padata_cpu_offline);
-	if (ret < 0)
-		goto err;
-	hp_online = ret;
-#endif
 
 	possible_cpus = num_possible_cpus();
 	padata_works = kmalloc_objs(struct padata_work, possible_cpus);
-	if (!padata_works)
-		goto remove_online_state;
+	if (!padata_works) {
+		pr_warn("padata: initialization failed\n");
+		return;
+	}
 
 	for (i = 0; i < possible_cpus; ++i)
 		list_add(&padata_works[i].pw_list, &padata_free_works);
-
-	return;
-
-remove_online_state:
-#ifdef CONFIG_HOTPLUG_CPU
-	cpuhp_remove_multi_state(hp_online);
-err:
-#endif
-	pr_warn("padata: initialization failed\n");
 }
-- 
2.55.0

