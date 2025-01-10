Received: from dggsgout11.his.huawei.com (dggsgout11.his.huawei.com [45.249.212.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D73F3746E;
	Fri, 10 Jan 2025 06:27:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736490444; cv=none; b=S+ZOVR6DdUpmu4HCPuqfWySz0krZTK6y2GRhh87m5Wkgo4VYojxHxsahstJn2BgOmZV1Z/IVHeD/Amdc3mgGcaHamhfYdkkIF4L8nlwNhENKs46DbsE2QWxHbZrbmNw23MGn57pPaduOciPkVmkZ/ZVLdbdvnpL09EA+I99YiaQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736490444; c=relaxed/simple;
	bh=AanatjAqHa4eIFQjryvuF9jL9E7FlmJUzM4oozzxVr0=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=spvL0EHlPZ0LkI3hJTSK48yEYd4JxXPojtH+52qePR/6Sv+JmR7ukjL24/WywMyKx/sQQZQKInZucbkib2dcZ2G50dfTa5IB1LZEr+xOXb7YWQFgxjKfPx5ss7Q5dn7TmmsjaLtze98jnJvET8vK2xp0L9cbZ3piSRVEMVo4ggI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com; spf=pass smtp.mailfrom=huaweicloud.com; arc=none smtp.client-ip=45.249.212.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huaweicloud.com
Received: from mail.maildlp.com (unknown [172.19.93.142])
	by dggsgout11.his.huawei.com (SkyGuard) with ESMTP id 4YTsBT3sq2z4f3jsv;
	Fri, 10 Jan 2025 14:26:57 +0800 (CST)
Received: from mail02.huawei.com (unknown [10.116.40.75])
	by mail.maildlp.com (Postfix) with ESMTP id 919DA1A0FF6;
	Fri, 10 Jan 2025 14:27:12 +0800 (CST)
Received: from hulk-vt.huawei.com (unknown [10.67.174.121])
	by APP2 (Coremail) with SMTP id Syh0CgCXoGOzvYBnLbQtAg--.33415S3;
	Fri, 10 Jan 2025 14:27:12 +0800 (CST)
From: Chen Ridong <chenridong@huaweicloud.com>
To: steffen.klassert@secunet.com,
	daniel.m.jordan@oracle.com,
	herbert@gondor.apana.org.au,
	nstange@suse.de
Cc: linux-crypto@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	chenridong@huawei.com,
	wangweiyang2@huawei.com
Subject: [PATCH v2 1/3] padata: add pd get/put refcnt helper
Date: Fri, 10 Jan 2025 06:16:37 +0000
Message-Id: <20250110061639.1280907-2-chenridong@huaweicloud.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20250110061639.1280907-1-chenridong@huaweicloud.com>
References: <20250110061639.1280907-1-chenridong@huaweicloud.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:Syh0CgCXoGOzvYBnLbQtAg--.33415S3
X-Coremail-Antispam: 1UD129KBjvJXoW7ZFWfJFW7ur48ZrWrAw1kKrg_yoW8uw4rpF
	y7Gry3XFW8JFWxuw45Jws7Zw1Fgw1kW347ta9xKa4furyayw1rtF1vv34xtryFqryvywn8
	Za1Yg3W2kwsrJFUanT9S1TB71UUUUU7qnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
	9KBjDU0xBIdaVrnRJUUUPIb4IE77IF4wAFF20E14v26ryj6rWUM7CY07I20VC2zVCF04k2
	6cxKx2IYs7xG6rWj6s0DM7CIcVAFz4kK6r1j6r18M28IrcIa0xkI8VA2jI8067AKxVWUGw
	A2048vs2IY020Ec7CjxVAFwI0_JFI_Gr1l8cAvFVAK0II2c7xJM28CjxkF64kEwVA0rcxS
	w2x7M28EF7xvwVC0I7IYx2IY67AKxVW7JVWDJwA2z4x0Y4vE2Ix0cI8IcVCY1x0267AKxV
	WxJVW8Jr1l84ACjcxK6I8E87Iv67AKxVW0oVCq3wA2z4x0Y4vEx4A2jsIEc7CjxVAFwI0_
	GcCE3s1le2I262IYc4CY6c8Ij28IcVAaY2xG8wAqx4xG64xvF2IEw4CE5I8CrVC2j2WlYx
	0E2Ix0cI8IcVAFwI0_Jr0_Jr4lYx0Ex4A2jsIE14v26r1j6r4UMcvjeVCFs4IE7xkEbVWU
	JVW8JwACjcxG0xvY0x0EwIxGrwCY1x0262kKe7AKxVWUAVWUtwCF04k20xvY0x0EwIxGrw
	CF54CYxVCY1x0262kKe7AKxVWUAVWUtwCFx2IqxVCFs4IE7xkEbVWUJVW8JwC20s026c02
	F40E14v26r1j6r18MI8I3I0E7480Y4vE14v26r106r1rMI8E67AF67kF1VAFwI0_Jw0_GF
	ylIxkGc2Ij64vIr41lIxAIcVC0I7IYx2IY67AKxVWUJVWUCwCI42IY6xIIjxv20xvEc7Cj
	xVAFwI0_Gr0_Cr1lIxAIcVCF04k26cxKx2IYs7xG6r1j6r1xMIIF0xvEx4A2jsIE14v26r
	1j6r4UMIIF0xvEx4A2jsIEc7CjxVAFwI0_Gr0_Gr1UYxBIdaVFxhVjvjDU0xZFpf9x07jb
	8n5UUUUU=
X-CM-SenderInfo: hfkh02xlgr0w46kxt4xhlfz01xgou0bp/

From: Chen Ridong <chenridong@huawei.com>

Add helpers for pd to get/put refcnt to make code consice.

Signed-off-by: Chen Ridong <chenridong@huawei.com>
---
 kernel/padata.c | 27 ++++++++++++++++++++-------
 1 file changed, 20 insertions(+), 7 deletions(-)

diff --git a/kernel/padata.c b/kernel/padata.c
index cf63d9bcf482..7d79df1e3b33 100644
--- a/kernel/padata.c
+++ b/kernel/padata.c
@@ -47,6 +47,22 @@ struct padata_mt_job_state {
 static void padata_free_pd(struct parallel_data *pd);
 static void __init padata_mt_helper(struct work_struct *work);
 
+static inline void padata_get_pd(struct parallel_data *pd)
+{
+	refcount_inc(&pd->refcnt);
+}
+
+static inline void padata_put_pd_cnt(struct parallel_data *pd, int cnt)
+{
+	if (refcount_sub_and_test(cnt, &pd->refcnt))
+		padata_free_pd(pd);
+}
+
+static inline void padata_put_pd(struct parallel_data *pd)
+{
+	padata_put_pd_cnt(pd, 1);
+}
+
 static int padata_index_to_cpu(struct parallel_data *pd, int cpu_index)
 {
 	int cpu, target_cpu;
@@ -206,7 +222,7 @@ int padata_do_parallel(struct padata_shell *ps,
 	if ((pinst->flags & PADATA_RESET))
 		goto out;
 
-	refcount_inc(&pd->refcnt);
+	padata_get_pd(pd);
 	padata->pd = pd;
 	padata->cb_cpu = *cb_cpu;
 
@@ -380,8 +396,7 @@ static void padata_serial_worker(struct work_struct *serial_work)
 	}
 	local_bh_enable();
 
-	if (refcount_sub_and_test(cnt, &pd->refcnt))
-		padata_free_pd(pd);
+	padata_put_pd_cnt(pd, cnt);
 }
 
 /**
@@ -681,8 +696,7 @@ static int padata_replace(struct padata_instance *pinst)
 	synchronize_rcu();
 
 	list_for_each_entry_continue_reverse(ps, &pinst->pslist, list)
-		if (refcount_dec_and_test(&ps->opd->refcnt))
-			padata_free_pd(ps->opd);
+		padata_put_pd(ps->opd);
 
 	pinst->flags &= ~PADATA_RESET;
 
@@ -1124,8 +1138,7 @@ void padata_free_shell(struct padata_shell *ps)
 	mutex_lock(&ps->pinst->lock);
 	list_del(&ps->list);
 	pd = rcu_dereference_protected(ps->pd, 1);
-	if (refcount_dec_and_test(&pd->refcnt))
-		padata_free_pd(pd);
+	padata_put_pd(pd);
 	mutex_unlock(&ps->pinst->lock);
 
 	kfree(ps);
-- 
2.34.1

