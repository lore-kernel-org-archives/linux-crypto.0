From: Steffen Klassert <steffen.klassert@secunet.com>
Subject: [PATCH 1/4] padata: Fix cpu index counting
Date: Tue, 20 Jul 2010 08:48:34 +0200
Message-ID: <20100720064834.GC11081@secunet.com>
References: <20100714142951.22817d0c@leibniz>
 <20100719060426.GA19696@gondor.apana.org.au>
 <20100719064050.GA11081@secunet.com>
 <20100719073255.GA20403@gondor.apana.org.au>
 <20100720064736.GB11081@secunet.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Dan Kruchinin <dkruchinin@acm.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org
To: Herbert Xu <herbert@gondor.apana.org.au>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from a.mx.secunet.com ([195.81.216.161]:36844 "EHLO a.mx.secunet.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753762Ab0GTGpo (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Tue, 20 Jul 2010 02:45:44 -0400
Content-Disposition: inline
In-Reply-To: <20100720064736.GB11081@secunet.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

The counting of the cpu index got lost with a recent commit.
This patch restores it. This fixes a hang of the parallel worker
threads on cpu hotplug.

Signed-off-by: Steffen Klassert <steffen.klassert@secunet.com>
---
 kernel/padata.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/kernel/padata.c b/kernel/padata.c
index 526f9ea..4287868 100644
--- a/kernel/padata.c
+++ b/kernel/padata.c
@@ -408,6 +408,7 @@ static void padata_init_pqueues(struct parallel_data *pd)
 		pqueue = per_cpu_ptr(pd->pqueue, cpu);
 		pqueue->pd = pd;
 		pqueue->cpu_index = cpu_index;
+		cpu_index++;
 
 		__padata_list_init(&pqueue->reorder);
 		__padata_list_init(&pqueue->parallel);
-- 
1.5.6.5
