From: Thomas Gleixner <tglx@linutronix.de>
Subject: [patch 13/13] crypto: n2 - Replace racy task affinity logic
Date: Wed, 12 Apr 2017 22:07:39 +0200
Message-ID: <20170412201043.231299672@linutronix.de>
References: <20170412200726.941336635@linutronix.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Cc: Peter Zijlstra <peterz@infradead.org>,
        Ingo Molnar <mingo@kernel.org>,
        Sebastian Siewior <bigeasy@linutronix.de>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        "David S. Miller" <davem@davemloft.net>,
        Fenghua Yu <fenghua.yu@intel.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Lai Jiangshan <jiangshanlai@gmail.com>,
        Len Brown <lenb@kernel.org>,
        Michael Ellerman <mpe@ellerman.id.au>,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>, Tejun Heo <tj@kernel.org>,
        Tony Luck <tony.luck@intel.com>,
        Viresh Kumar <viresh.kumar@linaro.org>,
        linux-crypto@vger.kernel.org
To: LKML <linux-kernel@vger.kernel.org>
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline;
 filename=crypto--n2---Use-work_on_cpu---instead-of-affinity-games.patch
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

spu_queue_register() needs to invoke setup functions on a particular
CPU. This is achieved by temporarily setting the affinity of the
calling user space thread to the requested CPU and reset it to the original
affinity afterwards.

That's racy vs. CPU hotplug and concurrent affinity settings for that
thread resulting in code executing on the wrong CPU and overwriting the
new affinity setting.

Replace it by using work_on_cpu_safe() which guarantees to run the code on
the requested CPU or to fail in case the CPU is offline.

Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Cc: Herbert Xu <herbert@gondor.apana.org.au>
Cc: "David S. Miller" <davem@davemloft.net>
Cc: linux-crypto@vger.kernel.org
---
 drivers/crypto/n2_core.c |   31 ++++++++++++++++---------------
 1 file changed, 16 insertions(+), 15 deletions(-)

--- a/drivers/crypto/n2_core.c
+++ b/drivers/crypto/n2_core.c
@@ -65,6 +65,11 @@ struct spu_queue {
 	struct list_head	list;
 };
 
+struct spu_qreg {
+	struct spu_queue	*queue;
+	unsigned long		type;
+};
+
 static struct spu_queue **cpu_to_cwq;
 static struct spu_queue **cpu_to_mau;
 
@@ -1631,31 +1636,27 @@ static void queue_cache_destroy(void)
 	kmem_cache_destroy(queue_cache[HV_NCS_QTYPE_CWQ - 1]);
 }
 
-static int spu_queue_register(struct spu_queue *p, unsigned long q_type)
+static long spu_queue_register_workfn(void *arg)
 {
-	cpumask_var_t old_allowed;
+	struct spu_qreg *qr = arg;
+	struct spu_queue *p = qr->queue;
+	unsigned long q_type = qr->type;
 	unsigned long hv_ret;
 
-	if (cpumask_empty(&p->sharing))
-		return -EINVAL;
-
-	if (!alloc_cpumask_var(&old_allowed, GFP_KERNEL))
-		return -ENOMEM;
-
-	cpumask_copy(old_allowed, &current->cpus_allowed);
-
-	set_cpus_allowed_ptr(current, &p->sharing);
-
 	hv_ret = sun4v_ncs_qconf(q_type, __pa(p->q),
 				 CWQ_NUM_ENTRIES, &p->qhandle);
 	if (!hv_ret)
 		sun4v_ncs_sethead_marker(p->qhandle, 0);
 
-	set_cpus_allowed_ptr(current, old_allowed);
+	return hv_ret ? -EINVAL : 0;
+}
 
-	free_cpumask_var(old_allowed);
+static int spu_queue_register(struct spu_queue *p, unsigned long q_type)
+{
+	int cpu = cpumask_any_and(&p->sharing, cpu_online_mask);
+	struct spu_qreg qr = { .queue = p, .type = q_type };
 
-	return (hv_ret ? -EINVAL : 0);
+	return work_on_cpu_safe(cpu, &qr);
 }
 
 static int spu_queue_setup(struct spu_queue *p)
