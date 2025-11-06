Received: from www262.sakura.ne.jp (www262.sakura.ne.jp [202.181.97.72])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B03262E0916;
	Thu,  6 Nov 2025 11:20:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=202.181.97.72
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762428044; cv=none; b=txEFShJmubvWGDQ2s5X+V9gTR14SPRoINmSl8kSItG9lU297ludXBbyecI7d/xkn8JjcEQZYqR4KbTD8whhj+diz9HW69yTEGLqWC9LGKEt13iIK/5lcGGNSZ6Tw3pCZB1ibh5VUerspwIPhQmJdYo4cIZC0tuU8IwNOXLA0Xuo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762428044; c=relaxed/simple;
	bh=WiqShaaYOzXuSzUIhdMstXRb84zZxZUFhLhi/kXZ6jg=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=RO5bdgCbAsKD4EhRK2B4+Sn5/aj96/8OGkzY6JRJPoCDJEzuGtKASWQ3ZPz27almey1SOuTdRqabYf4o4G1z2VsERiwu+/0EQYRh+QH+LICS4c941Y72LbYUoAOv0Dwns3k0nf/Jgw/6Xeujwx8IupMWBkl6CtZGZISpnzp/jmc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=I-love.SAKURA.ne.jp; spf=pass smtp.mailfrom=I-love.SAKURA.ne.jp; arc=none smtp.client-ip=202.181.97.72
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=I-love.SAKURA.ne.jp
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=I-love.SAKURA.ne.jp
Received: from www262.sakura.ne.jp (localhost [127.0.0.1])
	by www262.sakura.ne.jp (8.15.2/8.15.2) with ESMTP id 5A6BKPPq045333;
	Thu, 6 Nov 2025 20:20:25 +0900 (JST)
	(envelope-from penguin-kernel@I-love.SAKURA.ne.jp)
Received: from [192.168.1.10] (M106072142033.v4.enabler.ne.jp [106.72.142.33])
	(authenticated bits=0)
	by www262.sakura.ne.jp (8.15.2/8.15.2) with ESMTPSA id 5A6BKOvk045326
	(version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=NO);
	Thu, 6 Nov 2025 20:20:24 +0900 (JST)
	(envelope-from penguin-kernel@I-love.SAKURA.ne.jp)
Message-ID: <bd67b517-fde6-4f88-be0a-d8164f3c9a72@I-love.SAKURA.ne.jp>
Date: Thu, 6 Nov 2025 20:20:23 +0900
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: [PATCH] padata: use different lock_class_key for padata_list lock
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
Content-Language: en-US
From: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
In-Reply-To: <aQxufVwZWwRfEaHG@gondor.apana.org.au>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Virus-Status: clean
X-Anti-Virus-Server: fsav401.rs.sakura.ne.jp

syzbot is reporting possibility of deadlock due to calling spin_lock_init()
in __padata_list_init() from both padata_init_reorder_list() and
padata_init_squeues(). This is a false positive, for reorder->lock is never
the same as squeue->serial.lock.

Reported-by: syzbot+bd936ccd4339cea66e6b@syzkaller.appspotmail.com
Closes: https://syzkaller.appspot.com/bug?extid=bd936ccd4339cea66e6b
Suggested-by: Herbert Xu <herbert@gondor.apana.org.au>
Signed-off-by: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
---
 kernel/padata.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/kernel/padata.c b/kernel/padata.c
index f4def028c48c..465d25020e1e 100644
--- a/kernel/padata.c
+++ b/kernel/padata.c
@@ -529,12 +529,14 @@ static void padata_init_squeues(struct parallel_data *pd)
 /* Initialize per-CPU reorder lists */
 static void padata_init_reorder_list(struct parallel_data *pd)
 {
+	static struct lock_class_key padata_list_key;
 	int cpu;
 	struct padata_list *list;
 
 	for_each_cpu(cpu, pd->cpumask.pcpu) {
 		list = per_cpu_ptr(pd->reorder_list, cpu);
 		__padata_list_init(list);
+		lockdep_set_class(&list->lock, &padata_list_key);
 	}
 }
 
-- 
2.47.3


