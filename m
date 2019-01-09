Return-Path: <SRS0=1Gsi=PR=vger.kernel.org=linux-crypto-owner@kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:42068 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731169AbfAIP7p (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 9 Jan 2019 10:59:45 -0500
From: Daniel Bristot de Oliveira <bristot@redhat.com>
To: linux-rt-users@vger.kernel.org
Cc: Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
        Thomas Gleixner <tglx@linutronix.de>,
        Clark Williams <williams@redhat.com>,
        linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH RT] padata: Make padata_do_serial() use get_cpu_light()
Date: Wed,  9 Jan 2019 16:59:26 +0100
Message-Id: <5894faebe7c816c6b210ab2616a49330f067a492.1547039140.git.bristot@redhat.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

We hit the following BUG:

  BUG: scheduling while atomic: kworker/1:1/24117/0x00000002
  Preemption disabled at:
  [<ffffffffb61fd824>] padata_do_serial+0x24/0x110
  CPU: 1 PID: 24117 Comm: kworker/1:1 Not tainted 4.18.0-56.rt9.107.el8.x86_64 #1
  Hardware name: HPE ProLiant DL380 Gen10/ProLiant DL380 Gen10, BIOS U30 11/14/2017
  Workqueue: pencrypt padata_parallel_worker
  Call Trace:
    dump_stack+0x5c/0x80
    ? padata_do_serial+0x24/0x110
    __schedule_bug.cold.83+0x8e/0x9b
    __schedule+0x5a0/0x680
    schedule+0x39/0xd0
    rt_spin_lock_slowlock_locked+0x10e/0x2b0
    rt_spin_lock_slowlock+0x50/0x80
    padata_do_serial+0x4d/0x110
    padata_parallel_worker+0xaf/0xe0
    process_one_work+0x183/0x3b0
    ? process_one_work+0x3b0/0x3b0
    worker_thread+0x30/0x3d0
    ? process_one_work+0x3b0/0x3b0
    kthread+0x112/0x130
    ? kthread_create_worker_on_cpu+0x70/0x70
    ret_from_fork+0x35/0x40

and the cause is a spin_lock() taken inside a get_cpu() section.

Convert the get/put_cpu to get/put_cpu_light to fix the BUG while reducing the
preempt_disable section.

Signed-off-by: Daniel Bristot de Oliveira <bristot@redhat.com>
Reviewed-by: Clark Williams <williams@redhat.com>
Cc: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Clark Williams <williams@redhat.com>
Cc: linux-rt-users@vger.kernel.org
Cc: linux-crypto@vger.kernel.org
Cc: linux-kernel@vger.kernel.org

diff --git a/kernel/padata.c b/kernel/padata.c
index d568cc56405f..bfcbdeb20ba5 100644
--- a/kernel/padata.c
+++ b/kernel/padata.c
@@ -295,7 +295,7 @@ static void padata_reorder_timer(struct timer_list *t)
 	unsigned int weight;
 	int target_cpu, cpu;
 
-	cpu = get_cpu();
+	cpu = get_cpu_light();
 
 	/* We don't lock pd here to not interfere with parallel processing
 	 * padata_reorder() calls on other CPUs. We just need any CPU out of
@@ -321,7 +321,7 @@ static void padata_reorder_timer(struct timer_list *t)
 		padata_reorder(pd);
 	}
 
-	put_cpu();
+	put_cpu_light();
 }
 
 static void padata_serial_worker(struct work_struct *serial_work)
@@ -369,7 +369,7 @@ void padata_do_serial(struct padata_priv *padata)
 
 	pd = padata->pd;
 
-	cpu = get_cpu();
+	cpu = get_cpu_light();
 
 	/* We need to run on the same CPU padata_do_parallel(.., padata, ..)
 	 * was called on -- or, at least, enqueue the padata object into the
@@ -387,7 +387,7 @@ void padata_do_serial(struct padata_priv *padata)
 	list_add_tail(&padata->list, &pqueue->reorder.list);
 	spin_unlock(&pqueue->reorder.lock);
 
-	put_cpu();
+	put_cpu_light();
 
 	/* If we're running on the wrong CPU, call padata_reorder() via a
 	 * kernel worker.
-- 
2.17.2
