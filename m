From: Steffen Klassert <steffen.klassert@secunet.com>
Subject: [PATCH 2/3] padata: Use the online cpumask as the default
Date: Wed, 28 Mar 2012 08:43:21 +0200
Message-ID: <20120328064321.GF16191@secunet.com>
References: <20120328064157.GD16191@secunet.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Peter Zijlstra <peterz@infradead.org>,
	linux-kernel@vger.kernel.org, linux-crypto@vger.kernel.org
To: Herbert Xu <herbert@gondor.apana.org.au>
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20120328064157.GD16191@secunet.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

We use the active cpumask to determine the superset of cpus
to use for parallelization. However, the active cpumask is
for internal usage of the scheduler and therefore not the
appropriate cpumask for these purposes. So use the online
cpumask instead.

Reported-by: Peter Zijlstra <peterz@infradead.org>
Signed-off-by: Steffen Klassert <steffen.klassert@secunet.com>
---
 kernel/padata.c |    8 ++++----
 1 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/kernel/padata.c b/kernel/padata.c
index 7875088..de3d0d9 100644
--- a/kernel/padata.c
+++ b/kernel/padata.c
@@ -356,13 +356,13 @@ static int padata_setup_cpumasks(struct parallel_data *pd,
 	if (!alloc_cpumask_var(&pd->cpumask.pcpu, GFP_KERNEL))
 		return -ENOMEM;
 
-	cpumask_and(pd->cpumask.pcpu, pcpumask, cpu_active_mask);
+	cpumask_and(pd->cpumask.pcpu, pcpumask, cpu_online_mask);
 	if (!alloc_cpumask_var(&pd->cpumask.cbcpu, GFP_KERNEL)) {
 		free_cpumask_var(pd->cpumask.cbcpu);
 		return -ENOMEM;
 	}
 
-	cpumask_and(pd->cpumask.cbcpu, cbcpumask, cpu_active_mask);
+	cpumask_and(pd->cpumask.cbcpu, cbcpumask, cpu_online_mask);
 	return 0;
 }
 
@@ -566,7 +566,7 @@ EXPORT_SYMBOL(padata_unregister_cpumask_notifier);
 static bool padata_validate_cpumask(struct padata_instance *pinst,
 				    const struct cpumask *cpumask)
 {
-	if (!cpumask_intersects(cpumask, cpu_active_mask)) {
+	if (!cpumask_intersects(cpumask, cpu_online_mask)) {
 		pinst->flags |= PADATA_INVALID;
 		return false;
 	}
@@ -680,7 +680,7 @@ static int __padata_add_cpu(struct padata_instance *pinst, int cpu)
 {
 	struct parallel_data *pd;
 
-	if (cpumask_test_cpu(cpu, cpu_active_mask)) {
+	if (cpumask_test_cpu(cpu, cpu_online_mask)) {
 		pd = padata_alloc_pd(pinst, pinst->cpumask.pcpu,
 				     pinst->cpumask.cbcpu);
 		if (!pd)
-- 
1.7.0.4
