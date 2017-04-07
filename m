From: "Jason A. Donenfeld" <Jason@zx2c4.com>
Subject: [PATCH] padata: free correct variable
Date: Fri,  7 Apr 2017 02:33:30 +0200
Message-ID: <20170407003330.6552-1-Jason@zx2c4.com>
Cc: "Jason A. Donenfeld" <Jason@zx2c4.com>, stable@vger.kernel.org
To: linux-crypto@vger.kernel.org, steffen.klassert@secunet.com,
        linux-kernel@vger.kernel.org
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from frisell.zx2c4.com ([192.95.5.64]:32921 "EHLO frisell.zx2c4.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752124AbdDGAdq (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 6 Apr 2017 20:33:46 -0400
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

The author meant to free the variable that was just allocated, instead
of the one that failed to be allocated, but made a simple typo. This
patch rectifies that.

Signed-off-by: Jason A. Donenfeld <Jason@zx2c4.com>
Cc: stable@vger.kernel.org
---
 kernel/padata.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/kernel/padata.c b/kernel/padata.c
index 05316c9f32da..1faa7d62d87d 100644
--- a/kernel/padata.c
+++ b/kernel/padata.c
@@ -353,7 +353,7 @@ static int padata_setup_cpumasks(struct parallel_data *pd,
 
 	cpumask_and(pd->cpumask.pcpu, pcpumask, cpu_online_mask);
 	if (!alloc_cpumask_var(&pd->cpumask.cbcpu, GFP_KERNEL)) {
-		free_cpumask_var(pd->cpumask.cbcpu);
+		free_cpumask_var(pd->cpumask.pcpu);
 		return -ENOMEM;
 	}
 
-- 
2.12.2
