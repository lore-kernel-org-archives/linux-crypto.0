From: Steffen Klassert <steffen.klassert@secunet.com>
Subject: [PATCH 4/4] padata: Use get_online_cpus/put_online_cpus in
 padata_free
Date: Fri, 14 May 2010 13:46:46 +0200
Message-ID: <20100514114646.GE2184@secunet.com>
References: <20100514114336.GB2184@secunet.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-kernel@vger.kernel.org, linux-crypto@vger.kernel.org
To: Herbert Xu <herbert@gondor.apana.org.au>,
	Andrew Morton <akpm@linux-foundation.org>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from a.mx.secunet.com ([195.81.216.161]:56875 "EHLO a.mx.secunet.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752671Ab0ENLs7 (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Fri, 14 May 2010 07:48:59 -0400
Content-Disposition: inline
In-Reply-To: <20100514114336.GB2184@secunet.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Add get_online_cpus/put_online_cpus to ensure that no cpu goes
offline during the flushing of the padata percpu queues.

Signed-off-by: Steffen Klassert <steffen.klassert@secunet.com>
---
 kernel/padata.c |    3 +++
 1 files changed, 3 insertions(+), 0 deletions(-)

diff --git a/kernel/padata.c b/kernel/padata.c
index 629bef3..1f40560 100644
--- a/kernel/padata.c
+++ b/kernel/padata.c
@@ -763,7 +763,10 @@ void padata_free(struct padata_instance *pinst)
 #ifdef CONFIG_HOTPLUG_CPU
 	unregister_hotcpu_notifier(&pinst->cpu_notifier);
 #endif
+	get_online_cpus();
 	padata_flush_queues(pinst->pd);
+	put_online_cpus();
+
 	padata_free_pd(pinst->pd);
 	free_cpumask_var(pinst->cpumask);
 	kfree(pinst);
-- 
1.5.6.5
