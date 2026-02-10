Received: from sg-1-106.ptr.blmpb.com (sg-1-106.ptr.blmpb.com [118.26.132.106])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0971F2EC09B
	for <linux-crypto@vger.kernel.org>; Tue, 10 Feb 2026 15:39:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=118.26.132.106
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770738001; cv=none; b=p62kl3f+m478yRbZyTE4v2uDuc5TB0t2I31yCUZn3QN6csCLjZW+LjalXo/OQ8178UqvrqOpns3M4k5ZxAxHqelaNWwB0OaqGAL6nrW/XSXKRAYCnRU/ysK+htfwnPdQc39vI9Bdg+6qs4hWuZ2dozjkAZiPA9U1HxBUhIwALdI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770738001; c=relaxed/simple;
	bh=trve732AgltMeQxAnUf6kkiKtd/zzaxWrHhod0JjZ3Y=;
	h=From:Subject:Message-Id:To:Mime-Version:Cc:Date:Content-Type; b=HlyWgpVUyYbxYMa674W0xMqVLqyRfPN1frOW9ajL9LgFUAXquEuhRvLQ5vzFK6yS+HLQXb6knubAnyN+r821DGkfVWOFx3Jd1snYd1uJ9ryfj5XGSWkChpssUEFm1ClUipEom/ArZFkyh6keeedzU6T1NsoTHBgzqDRkTXcnwRk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=bytedance.com; spf=pass smtp.mailfrom=bytedance.com; dkim=pass (2048-bit key) header.d=bytedance.com header.i=@bytedance.com header.b=Sz1uPfFb; arc=none smtp.client-ip=118.26.132.106
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=bytedance.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=bytedance.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=bytedance.com header.i=@bytedance.com header.b="Sz1uPfFb"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
 s=2212171451; d=bytedance.com; t=1770737980; h=from:subject:
 mime-version:from:date:message-id:subject:to:cc:reply-to:content-type:
 mime-version:in-reply-to:message-id;
 bh=UKhlb2nYYS80HSax6rX6UvTS5mIaY8mJEZbyrVr+z7w=;
 b=Sz1uPfFbka+6tBm3ZDCKg6tOlGmDtxv6jhfyoQiGvcjn/JoWsxMxw79YwqZr7/qAnZrL8H
 Pg8/toMnnwwiCbWr1AuBSTEaDoX108S7wD4SiZQ5HODBpc5s86c0SLz1VeAqpBm97Ily6y
 ZDocJGpMx1BY/UDAusFoWhHQJuPaMiVU0jgBuUxP5rld/SHU20n95fRjgVNAXvQM2hSZYH
 COrCmIkoA55/fmQ4aVtgo46gtBCaTqV4FnOA0bwBcIemk5lcO2vtOH24R8MhP+WYWMwfT8
 ZTrVuQfyTjeoCJtac5Z1+T+QFqXd2Gv3K6vkC3N2dfZiO+Udq7+DxFikSCV6Pw==
From: "Chuyi Zhou" <zhouchuyi@bytedance.com>
Subject: [PATCH] padata: Remove cpu online check from cpu add and removal
Message-Id: <20260210153922.3435735-1-zhouchuyi@bytedance.com>
X-Mailer: git-send-email 2.20.1
X-Lms-Return-Path: <lba+2698b513a+0476b7+vger.kernel.org+zhouchuyi@bytedance.com>
To: <herbert@gondor.apana.org.au>, <steffen.klassert@secunet.com>, 
	<daniel.m.jordan@oracle.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
X-Original-From: Chuyi Zhou <zhouchuyi@bytedance.com>
Content-Transfer-Encoding: 7bit
Cc: <linux-crypto@vger.kernel.org>, "Chuyi Zhou" <zhouchuyi@bytedance.com>
Date: Tue, 10 Feb 2026 23:39:22 +0800
Content-Type: text/plain; charset=UTF-8

During the CPU offline process, the dying CPU is cleared from the
cpu_online_mask in takedown_cpu(). After this step, various CPUHP_*_DEAD
callbacks are executed to perform cleanup jobs for the dead CPU, so this
cpu online check in padata_cpu_dead() is unnecessary.

Similarly, when executing padata_cpu_online() during the
CPUHP_AP_ONLINE_DYN phase, the CPU has already been set in the
cpu_online_mask, the action even occurs earlier than the
CPUHP_AP_ONLINE_IDLE stage.

Remove this unnecessary cpu online check in __padata_add_cpu() and
__padata_remove_cpu().

Signed-off-by: Chuyi Zhou <zhouchuyi@bytedance.com>
---
 kernel/padata.c | 22 ++++++++--------------
 1 file changed, 8 insertions(+), 14 deletions(-)

diff --git a/kernel/padata.c b/kernel/padata.c
index aa66d91e20f9..53ce56053dd3 100644
--- a/kernel/padata.c
+++ b/kernel/padata.c
@@ -732,15 +732,11 @@ EXPORT_SYMBOL(padata_set_cpumask);
 
 static int __padata_add_cpu(struct padata_instance *pinst, int cpu)
 {
-	int err = 0;
-
-	if (cpumask_test_cpu(cpu, cpu_online_mask)) {
-		err = padata_replace(pinst);
+	int err = padata_replace(pinst);
 
-		if (padata_validate_cpumask(pinst, pinst->cpumask.pcpu) &&
-		    padata_validate_cpumask(pinst, pinst->cpumask.cbcpu))
-			__padata_start(pinst);
-	}
+	if (padata_validate_cpumask(pinst, pinst->cpumask.pcpu) &&
+		padata_validate_cpumask(pinst, pinst->cpumask.cbcpu))
+		__padata_start(pinst);
 
 	return err;
 }
@@ -749,13 +745,11 @@ static int __padata_remove_cpu(struct padata_instance *pinst, int cpu)
 {
 	int err = 0;
 
-	if (!cpumask_test_cpu(cpu, cpu_online_mask)) {
-		if (!padata_validate_cpumask(pinst, pinst->cpumask.pcpu) ||
-		    !padata_validate_cpumask(pinst, pinst->cpumask.cbcpu))
-			__padata_stop(pinst);
+	if (!padata_validate_cpumask(pinst, pinst->cpumask.pcpu) ||
+		!padata_validate_cpumask(pinst, pinst->cpumask.cbcpu))
+		__padata_stop(pinst);
 
-		err = padata_replace(pinst);
-	}
+	err = padata_replace(pinst);
 
 	return err;
 }
-- 
2.20.1
