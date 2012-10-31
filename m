From: Shan Wei <shanwei88@gmail.com>
Subject: [PATCH 6/9] kernel: padata : use this_cpu_ptr per-cpu helper
Date: Wed, 31 Oct 2012 19:22:56 +0800
Message-ID: <50910A10.3090004@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
To: steffen.klassert@secunet.com,
	Kernel-Maillist <linux-kernel@vger.kernel.org>,
	linux-crypto@vger.kernel.org, cl@linux-foundation.org
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-da0-f46.google.com ([209.85.210.46]:63014 "EHLO
	mail-da0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965450Ab2JaLXC (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Wed, 31 Oct 2012 07:23:02 -0400
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

From: Shan Wei <davidshan@tencent.com>


Signed-off-by: Shan Wei <davidshan@tencent.com>
---
 kernel/padata.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/kernel/padata.c b/kernel/padata.c
index 89fe3d1..70dffe8 100644
--- a/kernel/padata.c
+++ b/kernel/padata.c
@@ -204,7 +204,7 @@ static struct padata_priv *padata_get_next(struct parallel_data *pd)
 		goto out;
 	}
 
-	queue = per_cpu_ptr(pd->pqueue, smp_processor_id());
+	queue = this_cpu_ptr(pd->pqueue);
 	if (queue->cpu_index == next_queue->cpu_index) {
 		padata = ERR_PTR(-ENODATA);
 		goto out;
-- 
1.7.1
