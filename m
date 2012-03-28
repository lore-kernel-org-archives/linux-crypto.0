From: Steffen Klassert <steffen.klassert@secunet.com>
Subject: [PATCH 3/3] padata: Fix cpu hotplug
Date: Wed, 28 Mar 2012 08:44:07 +0200
Message-ID: <20120328064407.GG16191@secunet.com>
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

We don't remove the cpu that went offline from our cpumasks
on cpu hotplug. This got lost somewhere along the line, so
restore it. This fixes a hang of the padata instance on cpu
hotplug.

Signed-off-by: Steffen Klassert <steffen.klassert@secunet.com>
---
 kernel/padata.c |    3 +++
 1 files changed, 3 insertions(+), 0 deletions(-)

diff --git a/kernel/padata.c b/kernel/padata.c
index de3d0d9..89fe3d1 100644
--- a/kernel/padata.c
+++ b/kernel/padata.c
@@ -748,6 +748,9 @@ static int __padata_remove_cpu(struct padata_instance *pinst, int cpu)
 			return -ENOMEM;
 
 		padata_replace(pinst, pd);
+
+		cpumask_clear_cpu(cpu, pd->cpumask.cbcpu);
+		cpumask_clear_cpu(cpu, pd->cpumask.pcpu);
 	}
 
 	return 0;
-- 
1.7.0.4
