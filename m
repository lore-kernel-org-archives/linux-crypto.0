Received: from mail-pl1-f193.google.com (mail-pl1-f193.google.com [209.85.214.193])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C6DCE1F9EAC;
	Tue,  3 Dec 2024 15:34:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.193
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733240093; cv=none; b=fVsd3scDucZUhBa0AKKGjggMzce3ljPrWXPQ3R8SCfiH+tEUU7ABhKr2Mx1crpJwIW0d0lCnSC17QIlFdfRm0QMjhM4ilr7hjRkz0GdbM41iEy06rTTZwOQYhQ9GtwjfQOpExSM5JixFq9//d+rjQausf5a73YXcXLB/2lJ6HrA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733240093; c=relaxed/simple;
	bh=7RdZ/c6LtqIwtQidEPgp/g2EsiXbW+42XlXhJHw90ZM=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=TLkZACpvdgGBy5ZmzIYyn4hVR2uqS5seQ099nvB1kAl+4DcuSjsvlzqfjcghU6aN9KU8S4E9dRPHUQzinyThi7qaBEhu82h/a57tERLt06qf6BlZL6rXspsdXTpHf5lQ0T6SJNf7al75LtC4TiHjM6BT1hpFEy8XSNa54KaffSM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=IBKHnfVG; arc=none smtp.client-ip=209.85.214.193
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="IBKHnfVG"
Received: by mail-pl1-f193.google.com with SMTP id d9443c01a7336-21577f65bdeso20414385ad.0;
        Tue, 03 Dec 2024 07:34:51 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1733240091; x=1733844891; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=6n8xLa3bFG6KMlrCFd/orG3iRc5rITWuVB3hCMj+sL0=;
        b=IBKHnfVGw2zwvQ1N+WRtaAUiccee4zOTzWJpsPMsfOOjNRAw6zWUkj4yMt5M+BHKlE
         jnfSQeFBurikTVTHUL92LTHDb5PrpOpbtqyvSUzTpl4GYTfj69y10WBvrGLxEEaoWkzM
         V7fExhMJFIsFGsu91fbiOZIZEzpSxdbZf6pnfQKwiyJk1kjd+0V9n5rVTdfEzcun5O5S
         Ks3vpf8jco03oTap/75uSVSmI1T99s/3S5W8HjfjNNCMY7Bm1yh3fWsw8aTrhF8cOKZT
         ufM9vWx4HzdCOzKDz+FCblIRH5iEhr1A3kJ5qguq2bRAMHHTJ4gWgVSdeCe0lFFIa4E9
         t9Tg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1733240091; x=1733844891;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=6n8xLa3bFG6KMlrCFd/orG3iRc5rITWuVB3hCMj+sL0=;
        b=I+mQcvtM1wOGnnlmaY0uniLD99Ele5voVXdWDSNw/UT7k0pUWlxtequpi+PT+vslbY
         nGwiQsiNf9qmOUuz7zN17Yr6Gwg8ukC3yUiRj8jMgLoXlCsab6YP7DBBIz72i7Rtctje
         IIvNYY7QVHLxv20ZKsp9LhyFVMJSdm5aOaYztq8KVSg2MDOXiTsfR+7FcZhlajjI5t7+
         pY74mIHDgnveENGPvvahEa+p4GvYKVn5UJPezneZX6ErQtfzvPZBe675IWXVFj3uuqOj
         wK/MOMGXBaoTpHofQ7iQOIZZ+pSPrpCzN2ygaywXvhvLdLtBB9HYJze2D/npZm6URH+x
         H6Ew==
X-Forwarded-Encrypted: i=1; AJvYcCUdlDNrHNSfjQXqZ0E5ew8xRLYKwtZKx/x0JPNT3FRr8khrr+rOZ4ScOugjw3A4x42tpN4R/stH@vger.kernel.org, AJvYcCWdL6AiCOCyUkR0FMepe28cAHWFGY6V48jcp6BWIk9BJGOVMBNzAS1zIGFv0aUHImrDEAjgrPxs9s88aWI=@vger.kernel.org
X-Gm-Message-State: AOJu0Yxam7KW8vChMPSidrKcnlcNB0FeUfTQ92E78L4LrhjqKfkPXMz3
	YLLk5W/Z0oTqlYmQeNKB9K+6B+nkNIV9JdbS3qhnmi6sd6/c5aMX
X-Gm-Gg: ASbGncv/QZ5+m2EJKxHVLR6TuBgHY8/g/22138vPTRIHEOrL9iIh/5cGaShSjUYmzzi
	+JvBEa8bHOPNmIkdVRoqW5MfOeGbJSjHvemqhow/vHZl4iXnTbwMFqNDnUD1XSIW2PZ9lbwPWJl
	nTChSthtmiD1JBpaYqIFBjLJV7FysFXi7YzWhCztJMZOdn189KkQtokqSpYSmHCZrdTHAilXdJy
	EQmyOA7AHmaMEXKUxzVxUbNru4GgUtb5kuaVSqG6rWENfT3lMq3Ci5kMn+vxJT6pun+kWQgWhs9
	2CWkH+kfJdhW3qN93A5dexi9jyiIlW/00uXcmvtDkjCXVaC7Ys8X1aNh5n3Kq2fwQUFhus96Ssh
	s
X-Google-Smtp-Source: AGHT+IH/KICx3rlwNY8aT9zlD4cMbpz9OhF6d9fOSNbxAJHun6FjDj1GaQo4A0Lx1jE3TYiafp4s6w==
X-Received: by 2002:a17:902:e743:b0:215:6c5f:d142 with SMTP id d9443c01a7336-215be5fd2f8mr39362705ad.20.1733240090824;
        Tue, 03 Dec 2024 07:34:50 -0800 (PST)
Received: from localhost.localdomain.localdomain (n220246094186.netvigator.com. [220.246.94.186])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-215c1322696sm12625335ad.155.2024.12.03.07.34.48
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 03 Dec 2024 07:34:50 -0800 (PST)
From: Zach Wade <zachwade.k@gmail.com>
To: steffen.klassert@secunet.com,
	daniel.m.jordan@oracle.com,
	herbert@gondor.apana.org.au
Cc: linux-crypto@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	stable@vger.kernel.org,
	Zach Wade <zachwade.k@gmail.com>,
	Ding Hui <dinghui@sangfor.com.cn>
Subject: [PATCH] padata: Fix refcnt handling in padata_free_shell() again
Date: Tue,  3 Dec 2024 23:34:26 +0800
Message-ID: <20241203153426.62794-1-zachwade.k@gmail.com>
X-Mailer: git-send-email 2.46.0
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

testcases/kernel/crypto/pcrypt_aead01.c of LTP project has UAF.

Steps to reproduce:
1. /sys/module/cryptomgr/parameters/notests is N
2. run LTP ./testcases/bin/pcrypt_aead01

There is a race condition when padata_free_shell is released, which
causes it to be accessed after being released. We should use the rcu
mechanism to protect it.
            cpu0                |               cpu1
================================================================
padata_do_parallel              |   padata_free_shell
    rcu_read_lock_bh            |       refcount_dec_and_test
    # run to here <- 1          |       # run to here <- 2
    refcount_inc(&pd->refcnt);  |           padata_free_pd <- 3
    padata_work_alloc		|	...
    rcu_read_unlock_bh          |
				|
There is a possibility of UAF after refcount_inc(&pd->refcnt).

kasan report:
[158753.658839] ==================================================================
[158753.658851] BUG: KASAN: slab-use-after-free in padata_find_next+0x2d6/0x3f0
[158753.658868] Read of size 4 at addr ffff88812f8b8524 by task kworker/u158:0/988818
[158753.658878]
[158753.658885] CPU: 23 UID: 0 PID: 988818 Comm: kworker/u158:0 Kdump: loaded Tainted: G        W   E      6.12.0-dirty #33
[158753.658902] Tainted: [W]=WARN, [E]=UNSIGNED_MODULE
[158753.658907] Hardware name: VMware, Inc. VMware20,1/440BX Desktop Reference Platform, BIOS VMW201.00V.20192059.B64.2207280713 07/28/2022
[158753.658914] Workqueue: pdecrypt_parallel padata_parallel_worker
[158753.658927] Call Trace:
[158753.658932]  <TASK>
[158753.658938]  dump_stack_lvl+0x5d/0x80
[158753.658960]  print_report+0x174/0x505
[158753.658992]  kasan_report+0xe0/0x160
[158753.659013]  padata_find_next+0x2d6/0x3f0
[158753.659035]  padata_reorder+0x1cc/0x400
[158753.659043]  padata_parallel_worker+0x70/0x160
[158753.659051]  process_one_work+0x646/0xeb0
[158753.659061]  worker_thread+0x619/0x10e0
[158753.659092]  kthread+0x28d/0x350
[158753.659102]  ret_from_fork+0x31/0x70
[158753.659111]  ret_from_fork_asm+0x1a/0x30
[158753.659117]  </TASK>
[158753.659119]
[158753.659120] Allocated by task 1027931:
[158753.659123]  kasan_save_stack+0x30/0x50
[158753.659126]  kasan_save_track+0x14/0x30
[158753.659128]  __kasan_kmalloc+0xaa/0xb0
[158753.659130]  padata_alloc_pd+0x69/0x9f0
[158753.659132]  padata_alloc_shell+0x82/0x210
[158753.659134]  pcrypt_create+0x13b/0x7a0 [pcrypt]
[158753.659139]  cryptomgr_probe+0x8d/0x230
[158753.659144]  kthread+0x28d/0x350
[158753.659147]  ret_from_fork+0x31/0x70
[158753.659150]  ret_from_fork_asm+0x1a/0x30
[158753.659152]
[158753.659153] Freed by task 1024357:
[158753.659155]  kasan_save_stack+0x30/0x50
[158753.659158]  kasan_save_track+0x14/0x30
[158753.659160]  kasan_save_free_info+0x3b/0x70
[158753.659164]  __kasan_slab_free+0x4f/0x70
[158753.659167]  kfree+0x119/0x440
[158753.659172]  padata_free_shell+0x262/0x320
[158753.659174]  pcrypt_free+0x43/0x90 [pcrypt]
[158753.659177]  crypto_destroy_instance_workfn+0x79/0xc0
[158753.659182]  process_one_work+0x646/0xeb0
[158753.659184]  worker_thread+0x619/0x10e0
[158753.659186]  kthread+0x28d/0x350
[158753.659188]  ret_from_fork+0x31/0x70
[158753.659191]  ret_from_fork_asm+0x1a/0x30
[158753.659194]
[158753.659195] The buggy address belongs to the object at ffff88812f8b8500
 which belongs to the cache kmalloc-192 of size 192
[158753.659198] The buggy address is located 36 bytes inside of
 freed 192-byte region [ffff88812f8b8500, ffff88812f8b85c0)
[158753.659202]
[158753.659203] The buggy address belongs to the physical page:
[158753.659205] page: refcount:1 mapcount:0 mapping:0000000000000000 index:0x0 pfn:0x12f8b8
[158753.659209] head: order:1 mapcount:0 entire_mapcount:0 nr_pages_mapped:0 pincount:0
[158753.659212] anon flags: 0x10000000000040(head|node=0|zone=2)
[158753.659216] page_type: f5(slab)
[158753.659220] raw: 0010000000000040 ffff88810004c3c0 0000000000000000 dead000000000001
[158753.659223] raw: 0000000000000000 0000000080200020 00000001f5000000 0000000000000000
[158753.659225] head: 0010000000000040 ffff88810004c3c0 0000000000000000 dead000000000001
[158753.659228] head: 0000000000000000 0000000080200020 00000001f5000000 0000000000000000
[158753.659230] head: 0010000000000001 ffffea0004be2e01 ffffffffffffffff 0000000000000000
[158753.659232] head: ffff888100000002 0000000000000000 00000000ffffffff 0000000000000000
[158753.659234] page dumped because: kasan: bad access detected
[158753.659235]
[158753.659236] Memory state around the buggy address:
[158753.659238]  ffff88812f8b8400: fa fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
[158753.659240]  ffff88812f8b8480: fb fb fb fb fb fb fb fb fc fc fc fc fc fc fc fc
[158753.659242] >ffff88812f8b8500: fa fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
[158753.659243]                                ^
[158753.659245]  ffff88812f8b8580: fb fb fb fb fb fb fb fb fc fc fc fc fc fc fc fc
[158753.659247]  ffff88812f8b8600: fa fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
[158753.659248] ==================================================================

Fixes: 07928d9bfc81 ("padata: Remove broken queue flushing")

Co-developed-by: Ding Hui <dinghui@sangfor.com.cn>
Signed-off-by: Ding Hui <dinghui@sangfor.com.cn>
Signed-off-by: Zach Wade <zachwade.k@gmail.com>
---
 include/linux/padata.h |  1 +
 kernel/padata.c        | 11 +++++++++--
 2 files changed, 10 insertions(+), 2 deletions(-)

diff --git a/include/linux/padata.h b/include/linux/padata.h
index 0146daf34430..ee6155689e47 100644
--- a/include/linux/padata.h
+++ b/include/linux/padata.h
@@ -103,6 +103,7 @@ struct parallel_data {
 	int				cpu;
 	struct padata_cpumask		cpumask;
 	struct work_struct		reorder_work;
+	struct rcu_head			rcu;
 	spinlock_t                      ____cacheline_aligned lock;
 };
 
diff --git a/kernel/padata.c b/kernel/padata.c
index d51bbc76b227..3afdccc7e20e 100644
--- a/kernel/padata.c
+++ b/kernel/padata.c
@@ -1109,6 +1109,14 @@ struct padata_shell *padata_alloc_shell(struct padata_instance *pinst)
 }
 EXPORT_SYMBOL(padata_alloc_shell);
 
+static void __padata_put_pd(struct rcu_head *head)
+{
+	struct parallel_data *pd = container_of(head, struct parallel_data, rcu);
+
+	if (refcount_dec_and_test(&pd->refcnt))
+		padata_free_pd(pd);
+}
+
 /**
  * padata_free_shell - free a padata shell
  *
@@ -1124,9 +1132,8 @@ void padata_free_shell(struct padata_shell *ps)
 	mutex_lock(&ps->pinst->lock);
 	list_del(&ps->list);
 	pd = rcu_dereference_protected(ps->pd, 1);
-	if (refcount_dec_and_test(&pd->refcnt))
-		padata_free_pd(pd);
 	mutex_unlock(&ps->pinst->lock);
+	call_rcu(&pd->rcu, __padata_put_pd);
 
 	kfree(ps);
 }
-- 
2.46.0

