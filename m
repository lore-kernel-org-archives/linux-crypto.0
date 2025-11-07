Received: from www262.sakura.ne.jp (www262.sakura.ne.jp [202.181.97.72])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B5C9C2E7F25;
	Fri,  7 Nov 2025 14:50:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=202.181.97.72
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762527009; cv=none; b=qfWLT/oWvn5Gm8ciweZ9HDsVOFNoRhqcNepEIwaEG2g4ORwOIu/NAdQ4WZhNaayeLlrkQvy6UES8ETuGbmDLBWgfG9wPdfFfcMaATKgxu1DHj3pa6lG3UHsWgN3ShGkUc2z0h0y8OLtXGzTHZV00jxW2bNuH4RB8rIIH0IX6FIc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762527009; c=relaxed/simple;
	bh=6ONX6949BCytaNAFqDk4Etn0WNg96GTMWn6wVtkUAiU=;
	h=Message-ID:Date:MIME-Version:Subject:From:To:Cc:References:
	 In-Reply-To:Content-Type; b=HQdcBQzY/1l/qju/Wj5drb9/nRCLWXfSeSPkrxqXFxAazqVNcx45+6InSKO5GZ45GXVciCrqw8KlMGlLCn1GCMloCyQg0CpqmRtmtGDUowfpbHRMSrqp9/Xv/FOgLV3gMK0xbezz40BRgLDcrLyyVix3bZRapBQz++ZceMuaPl0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=I-love.SAKURA.ne.jp; spf=pass smtp.mailfrom=I-love.SAKURA.ne.jp; arc=none smtp.client-ip=202.181.97.72
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=I-love.SAKURA.ne.jp
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=I-love.SAKURA.ne.jp
Received: from www262.sakura.ne.jp (localhost [127.0.0.1])
	by www262.sakura.ne.jp (8.15.2/8.15.2) with ESMTP id 5A7EndCq086059;
	Fri, 7 Nov 2025 23:49:40 +0900 (JST)
	(envelope-from penguin-kernel@I-love.SAKURA.ne.jp)
Received: from [192.168.1.10] (M106072142033.v4.enabler.ne.jp [106.72.142.33])
	(authenticated bits=0)
	by www262.sakura.ne.jp (8.15.2/8.15.2) with ESMTPSA id 5A7EndkR086056
	(version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=NO);
	Fri, 7 Nov 2025 23:49:39 +0900 (JST)
	(envelope-from penguin-kernel@I-love.SAKURA.ne.jp)
Message-ID: <18e8dbfc-41fe-4e2d-b0f3-a86cc3270d84@I-love.SAKURA.ne.jp>
Date: Fri, 7 Nov 2025 23:49:37 +0900
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: [PATCH v2] padata: remove __padata_list_init()
From: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
To: Herbert Xu <herbert@gondor.apana.org.au>
Cc: syzbot <syzbot+bd936ccd4339cea66e6b@syzkaller.appspotmail.com>,
        daniel.m.jordan@oracle.com, linux-kernel@vger.kernel.org,
        steffen.klassert@secunet.com, linux-crypto@vger.kernel.org
References: <6860c5d3.a00a0220.c1739.0009.GAE@google.com>
 <68c34150.050a0220.3c6139.0045.GAE@google.com>
 <5823185b-55c6-416b-a85c-1191a045caf8@I-love.SAKURA.ne.jp>
 <aQxqTiUUrDmF5M_X@gondor.apana.org.au>
 <60778a1e-c29d-4d41-8272-9e635d9ff427@I-love.SAKURA.ne.jp>
 <aQxufVwZWwRfEaHG@gondor.apana.org.au>
 <bd67b517-fde6-4f88-be0a-d8164f3c9a72@I-love.SAKURA.ne.jp>
Content-Language: en-US
In-Reply-To: <bd67b517-fde6-4f88-be0a-d8164f3c9a72@I-love.SAKURA.ne.jp>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Virus-Status: clean
X-Anti-Virus-Server: fsav402.rs.sakura.ne.jp

syzbot is reporting possibility of deadlock due to sharing lock_class_key
between padata_init_squeues() and padata_init_reorder_list(). This is a
false positive, for these callers initialize different object. Unshare
lock_class_key by embedding __padata_list_init() into these callers.

Reported-by: syzbot+bd936ccd4339cea66e6b@syzkaller.appspotmail.com
Closes: https://syzkaller.appspot.com/bug?extid=bd936ccd4339cea66e6b
Signed-off-by: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
---
This version might be easier to understand, for __padata_list_init() is
cheap (which is likely inlined by compiler) and has only two callers.

 kernel/padata.c | 12 ++++--------
 1 file changed, 4 insertions(+), 8 deletions(-)

diff --git a/kernel/padata.c b/kernel/padata.c
index f4def028c48c..aa66d91e20f9 100644
--- a/kernel/padata.c
+++ b/kernel/padata.c
@@ -506,12 +506,6 @@ void __init padata_do_multithreaded(struct padata_mt_job *job)
 	padata_works_free(&works);
 }
 
-static void __padata_list_init(struct padata_list *pd_list)
-{
-	INIT_LIST_HEAD(&pd_list->list);
-	spin_lock_init(&pd_list->lock);
-}
-
 /* Initialize all percpu queues used by serial workers */
 static void padata_init_squeues(struct parallel_data *pd)
 {
@@ -521,7 +515,8 @@ static void padata_init_squeues(struct parallel_data *pd)
 	for_each_cpu(cpu, pd->cpumask.cbcpu) {
 		squeue = per_cpu_ptr(pd->squeue, cpu);
 		squeue->pd = pd;
-		__padata_list_init(&squeue->serial);
+		INIT_LIST_HEAD(&squeue->serial.list);
+		spin_lock_init(&squeue->serial.lock);
 		INIT_WORK(&squeue->work, padata_serial_worker);
 	}
 }
@@ -534,7 +529,8 @@ static void padata_init_reorder_list(struct parallel_data *pd)
 
 	for_each_cpu(cpu, pd->cpumask.pcpu) {
 		list = per_cpu_ptr(pd->reorder_list, cpu);
-		__padata_list_init(list);
+		INIT_LIST_HEAD(&list->list);
+		spin_lock_init(&list->lock);
 	}
 }
 
-- 
2.47.3


