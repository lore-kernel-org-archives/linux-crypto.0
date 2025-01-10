Received: from dggsgout11.his.huawei.com (dggsgout11.his.huawei.com [45.249.212.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9B8472063FC;
	Fri, 10 Jan 2025 06:27:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736490444; cv=none; b=oWxCGMeh6cFwEOPoprxZeFBHb+MrIBVeGQg/SeXUJzoA61NjOl0Jn3LhsBxNA1ksc3K0ZmPyp2Tormn7SFmtYiiSIoTQ/Moh7l2j2c8GtMFlcayy/7zEwz+2DhoaHS8tdwlTfYebJu3i0M6LiNlNPBkZsAIDnouo7CyZqhApxgc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736490444; c=relaxed/simple;
	bh=TuItg2cVex87EoCUMvkN0Ds3IPBNJUsMwiP15esgejQ=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=XN8sc3N2DdPLwPRKqU/3kUpxgglLJAdY/Vgh/NDbVcvDmoQRcVLubK5awIO/xT8hgZSXVzJ6SE7b1+yg0gCgqTYrLQRjzVg6c15m77HpQdcSxNHu21DXFnU3v1mb4V0TSfFNfru+TW3SMrKlpxv7JVy2b1KDjW1mjlCSAJrYlYQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com; spf=pass smtp.mailfrom=huaweicloud.com; arc=none smtp.client-ip=45.249.212.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huaweicloud.com
Received: from mail.maildlp.com (unknown [172.19.163.235])
	by dggsgout11.his.huawei.com (SkyGuard) with ESMTP id 4YTsBW1BQfz4f3jqw;
	Fri, 10 Jan 2025 14:26:59 +0800 (CST)
Received: from mail02.huawei.com (unknown [10.116.40.75])
	by mail.maildlp.com (Postfix) with ESMTP id 3BA2D1A0CCD;
	Fri, 10 Jan 2025 14:27:14 +0800 (CST)
Received: from hulk-vt.huawei.com (unknown [10.67.174.121])
	by APP2 (Coremail) with SMTP id Syh0CgCXoGOzvYBnLbQtAg--.33415S5;
	Fri, 10 Jan 2025 14:27:14 +0800 (CST)
From: Chen Ridong <chenridong@huaweicloud.com>
To: steffen.klassert@secunet.com,
	daniel.m.jordan@oracle.com,
	herbert@gondor.apana.org.au,
	nstange@suse.de
Cc: linux-crypto@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	chenridong@huawei.com,
	wangweiyang2@huawei.com
Subject: [PATCH v2 3/3] padata: avoid UAF for reorder_work
Date: Fri, 10 Jan 2025 06:16:39 +0000
Message-Id: <20250110061639.1280907-4-chenridong@huaweicloud.com>
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
X-CM-TRANSID:Syh0CgCXoGOzvYBnLbQtAg--.33415S5
X-Coremail-Antispam: 1UD129KBjvJXoW7AFWkAr13ur1ruF18WF4DJwb_yoW8trWDpF
	4YkFW3JrW8JFW8K3s7ZF43Zr18W3WjgFy3ta95Gw1Yk3y5Jr1rCrnrtw1S9a409ryktw1D
	Zr4qqFn2qwsFgFUanT9S1TB71UUUUU7qnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
	9KBjDU0xBIdaVrnRJUUUPab4IE77IF4wAFF20E14v26rWj6s0DM7CY07I20VC2zVCF04k2
	6cxKx2IYs7xG6rWj6s0DM7CIcVAFz4kK6r1j6r18M28IrcIa0xkI8VA2jI8067AKxVWUWw
	A2048vs2IY020Ec7CjxVAFwI0_Xr0E3s1l8cAvFVAK0II2c7xJM28CjxkF64kEwVA0rcxS
	w2x7M28EF7xvwVC0I7IYx2IY67AKxVW7JVWDJwA2z4x0Y4vE2Ix0cI8IcVCY1x0267AKxV
	W8Jr0_Cr1UM28EF7xvwVC2z280aVAFwI0_GcCE3s1l84ACjcxK6I8E87Iv6xkF7I0E14v2
	6rxl6s0DM2AIxVAIcxkEcVAq07x20xvEncxIr21l5I8CrVACY4xI64kE6c02F40Ex7xfMc
	Ij6xIIjxv20xvE14v26r1j6r18McIj6I8E87Iv67AKxVWUJVW8JwAm72CE4IkC6x0Yz7v_
	Jr0_Gr1lF7xvr2IYc2Ij64vIr41lc7CjxVAaw2AFwI0_JF0_Jw1l42xK82IYc2Ij64vIr4
	1l4c8EcI0Ec7CjxVAaw2AFwI0_JF0_Jw1l4I8I3I0E4IkC6x0Yz7v_Jr0_Gr1lx2IqxVAq
	x4xG67AKxVWUJVWUGwC20s026x8GjcxK67AKxVWUGVWUWwC2zVAF1VAY17CE14v26r1q6r
	43MIIYrxkI7VAKI48JMIIF0xvE2Ix0cI8IcVAFwI0_Jr0_JF4lIxAIcVC0I7IYx2IY6xkF
	7I0E14v26r4j6F4UMIIF0xvE42xK8VAvwI8IcIk0rVWUJVWUCwCI42IY6I8E87Iv67AKxV
	WUJVW8JwCI42IY6I8E87Iv6xkF7I0E14v26r4j6r4UJbIYCTnIWIevJa73UjIFyTuYvjxU
	whFxUUUUU
X-CM-SenderInfo: hfkh02xlgr0w46kxt4xhlfz01xgou0bp/

From: Chen Ridong <chenridong@huawei.com>

Although the previous patch can avoid ps and ps UAF for _do_serial, it
can not avoid potential UAF issue for reorder_work. This issue can
happen just as below:

crypto_request			crypto_request		crypto_del_alg
padata_do_serial
  ...
  padata_reorder
    // processes all remaining
    // requests then breaks
    while (1) {
      if (!padata)
        break;
      ...
    }

				padata_do_serial
				  // new request added
				  list_add
    // sees the new request
    queue_work(reorder_work)
				  padata_reorder
				    queue_work_on(squeue->work)
...

				<kworker context>
				padata_serial_worker
				// completes new request,
				// no more outstanding
				// requests

							crypto_del_alg
							  // free pd

<kworker context>
invoke_padata_reorder
  // UAF of pd

To avoid UAF for 'reorder_work', get 'pd' ref before put 'reorder_work'
into the 'serial_wq' and put 'pd' ref until the 'serial_wq' finish.

Fixes: bbefa1dd6a6d ("crypto: pcrypt - Avoid deadlock by using per-instance padata queues")
Signed-off-by: Chen Ridong <chenridong@huawei.com>
---
 kernel/padata.c | 10 +++++++++-
 1 file changed, 9 insertions(+), 1 deletion(-)

diff --git a/kernel/padata.c b/kernel/padata.c
index de2c02a81469..418987056340 100644
--- a/kernel/padata.c
+++ b/kernel/padata.c
@@ -352,8 +352,14 @@ static void padata_reorder(struct parallel_data *pd)
 	smp_mb();
 
 	reorder = per_cpu_ptr(pd->reorder_list, pd->cpu);
-	if (!list_empty(&reorder->list) && padata_find_next(pd, false))
+	if (!list_empty(&reorder->list) && padata_find_next(pd, false)) {
+		/*
+		 * Other context(eg. the padata_serial_worker) can finish the request.
+		 * To avoid UAF issue, add pd ref here, and put pd ref after reorder_work finish.
+		 */
+		padata_get_pd(pd);
 		queue_work(pinst->serial_wq, &pd->reorder_work);
+	}
 }
 
 static void invoke_padata_reorder(struct work_struct *work)
@@ -364,6 +370,8 @@ static void invoke_padata_reorder(struct work_struct *work)
 	pd = container_of(work, struct parallel_data, reorder_work);
 	padata_reorder(pd);
 	local_bh_enable();
+	/* Pairs with putting the reorder_work in the serial_wq */
+	padata_put_pd(pd);
 }
 
 static void padata_serial_worker(struct work_struct *serial_work)
-- 
2.34.1

