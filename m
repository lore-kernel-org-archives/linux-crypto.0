Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B3F51C433B4
	for <linux-crypto@archiver.kernel.org>; Sun, 11 Apr 2021 00:32:20 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 88D9C61008
	for <linux-crypto@archiver.kernel.org>; Sun, 11 Apr 2021 00:32:20 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234680AbhDKAcf (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Sat, 10 Apr 2021 20:32:35 -0400
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:41688 "EHLO
        mx0b-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S234548AbhDKAce (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Sat, 10 Apr 2021 20:32:34 -0400
Received: from pps.filterd (m0098421.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 13B045Io172660;
        Sat, 10 Apr 2021 20:32:11 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=message-id : subject :
 from : to : cc : date : in-reply-to : references : content-type :
 mime-version : content-transfer-encoding; s=pp1;
 bh=UtgSHUNeSe3m3TtSnaEuGJ0/PAgJl16y00+VEWMRNMI=;
 b=L4N/SgV8G5HDLal/3OB7ncwVayKWyaeCulwiKjM2uHa51PRk2HC+vDfEUBh73Y+O6Ran
 VZ9+1/sH4ZN8qOin9VU7kHl+hV3srKRhqQQjoIrDaKFEfJEhP9ChW+HDU7dP/98V61Ut
 Tx+Z4evappSPVC9F+xFnR9HSqPy0AF1PiLt64D1wbg0jfsdhJXW1DSvppc3nZmHjdoaa
 BEAuQEKWKql3fQW2TUFWBz1tKtuMg6he2ROQNeHiqSaaAaS4+5+4jDgZdbupdJicHUzt
 nFesr6hqvuhUdb+mUFvDf6Mi4xmhjrGuGn9HqvC2cWAY024ADddhxP5f3ii/we/roHp7 Lg== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 37u80qm30e-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Sat, 10 Apr 2021 20:32:11 -0400
Received: from m0098421.ppops.net (m0098421.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 13B0RWw1040716;
        Sat, 10 Apr 2021 20:32:11 -0400
Received: from ppma04dal.us.ibm.com (7a.29.35a9.ip4.static.sl-reverse.com [169.53.41.122])
        by mx0a-001b2d01.pphosted.com with ESMTP id 37u80qm309-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Sat, 10 Apr 2021 20:32:11 -0400
Received: from pps.filterd (ppma04dal.us.ibm.com [127.0.0.1])
        by ppma04dal.us.ibm.com (8.16.0.43/8.16.0.43) with SMTP id 13B0S1Fn019978;
        Sun, 11 Apr 2021 00:32:10 GMT
Received: from b03cxnp08026.gho.boulder.ibm.com (b03cxnp08026.gho.boulder.ibm.com [9.17.130.18])
        by ppma04dal.us.ibm.com with ESMTP id 37u3n86de2-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Sun, 11 Apr 2021 00:32:10 +0000
Received: from b03ledav005.gho.boulder.ibm.com (b03ledav005.gho.boulder.ibm.com [9.17.130.236])
        by b03cxnp08026.gho.boulder.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 13B0W9M125166170
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sun, 11 Apr 2021 00:32:09 GMT
Received: from b03ledav005.gho.boulder.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 21AB9BE054;
        Sun, 11 Apr 2021 00:32:09 +0000 (GMT)
Received: from b03ledav005.gho.boulder.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id AC6FCBE053;
        Sun, 11 Apr 2021 00:32:07 +0000 (GMT)
Received: from localhost.localdomain (unknown [9.80.232.48])
        by b03ledav005.gho.boulder.ibm.com (Postfix) with ESMTP;
        Sun, 11 Apr 2021 00:32:07 +0000 (GMT)
Message-ID: <8d6df414f0a119175cff2c59125712b2f73e045b.camel@linux.ibm.com>
Subject: [PATCH 03/16] powerpc/vas: Create take/drop task reference functions
From:   Haren Myneni <haren@linux.ibm.com>
To:     linuxppc-dev@lists.ozlabs.org, linux-crypto@vger.kernel.org,
        mpe@ellerman.id.au, herbert@gondor.apana.org.au, npiggin@gmail.com
Cc:     hbabu@us.ibm.com, haren@us.ibm.com
Date:   Sat, 10 Apr 2021 17:32:05 -0700
In-Reply-To: <b4631127bd025d9585246606c350ec88dbe1e99a.camel@linux.ibm.com>
References: <b4631127bd025d9585246606c350ec88dbe1e99a.camel@linux.ibm.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.36.2 (3.36.2-1.fc32) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: 5jC_zHR94ePyF5p1m6COdst6N9_erfgb
X-Proofpoint-GUID: htqiHGpwe2l2PRV8a6xb33V7xOrGQHM2
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.391,18.0.761
 definitions=2021-04-10_07:2021-04-09,2021-04-10 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 clxscore=1015
 priorityscore=1501 bulkscore=0 spamscore=0 lowpriorityscore=0 adultscore=0
 mlxscore=0 phishscore=0 suspectscore=0 malwarescore=0 impostorscore=0
 mlxlogscore=780 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2104060000 definitions=main-2104100182
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org


Take task reference when each window opens and drops during close.
This functionality is needed for powerNV and pseries. So this patch
defines the existing code as functions in powerpc platform
independent vas-api.c

Signed-off-by: Haren Myneni <haren@linux.ibm.com>
---
 arch/powerpc/include/asm/vas.h              | 20 ++++++++
 arch/powerpc/kernel/vas-api.c               | 51 ++++++++++++++++++
 arch/powerpc/platforms/powernv/vas-fault.c  | 10 ++--
 arch/powerpc/platforms/powernv/vas-window.c | 57 ++-------------------
 arch/powerpc/platforms/powernv/vas.h        |  6 +--
 5 files changed, 83 insertions(+), 61 deletions(-)

diff --git a/arch/powerpc/include/asm/vas.h b/arch/powerpc/include/asm/vas.h
index 6bbade60d8f4..2daaa1a2a9a9 100644
--- a/arch/powerpc/include/asm/vas.h
+++ b/arch/powerpc/include/asm/vas.h
@@ -5,6 +5,9 @@
 
 #ifndef _ASM_POWERPC_VAS_H
 #define _ASM_POWERPC_VAS_H
+#include <linux/sched/mm.h>
+#include <linux/mmu_context.h>
+#include <asm/icswx.h>
 #include <uapi/asm/vas-api.h>
 
 
@@ -60,6 +63,22 @@ struct vas_user_win_ops {
 	int (*close_win)(void *);
 };
 
+struct vas_win_task {
+	struct pid *pid;	/* Thread group ID of owner */
+	struct pid *tgid;	/* Linux process mm_struct */
+	struct mm_struct *mm;	/* Linux process mm_struct */
+};
+
+static inline void vas_drop_reference_task(struct vas_win_task *task)
+{
+	/* Drop references to pid and mm */
+	put_pid(task->pid);
+	if (task->mm) {
+		mm_context_remove_vas_window(task->mm);
+		mmdrop(task->mm);
+	}
+}
+
 /*
  * Receive window attributes specified by the (in-kernel) owner of window.
  */
@@ -190,4 +209,5 @@ int vas_register_coproc_api(struct module *mod, enum vas_cop_type cop_type,
 			    struct vas_user_win_ops *vops);
 void vas_unregister_coproc_api(void);
 
+int vas_reference_task(struct vas_win_task *vtask);
 #endif /* __ASM_POWERPC_VAS_H */
diff --git a/arch/powerpc/kernel/vas-api.c b/arch/powerpc/kernel/vas-api.c
index 05d7b99acf41..d98caa734154 100644
--- a/arch/powerpc/kernel/vas-api.c
+++ b/arch/powerpc/kernel/vas-api.c
@@ -60,6 +60,57 @@ static char *coproc_devnode(struct device *dev, umode_t *mode)
 	return kasprintf(GFP_KERNEL, "crypto/%s", dev_name(dev));
 }
 
+/*
+ * Take reference to pid and mm
+ */
+int vas_reference_task(struct vas_win_task *vtask)
+{
+	/*
+	 * Window opened by a child thread may not be closed when
+	 * it exits. So take reference to its pid and release it
+	 * when the window is free by parent thread.
+	 * Acquire a reference to the task's pid to make sure
+	 * pid will not be re-used - needed only for multithread
+	 * applications.
+	 */
+	vtask->pid = get_task_pid(current, PIDTYPE_PID);
+	/*
+	 * Acquire a reference to the task's mm.
+	 */
+	vtask->mm = get_task_mm(current);
+	if (!vtask->mm) {
+		put_pid(vtask->pid);
+		pr_err("VAS: pid(%d): mm_struct is not found\n",
+				current->pid);
+		return -EPERM;
+	}
+
+	mmgrab(vtask->mm);
+	mmput(vtask->mm);
+	mm_context_add_vas_window(vtask->mm);
+	/*
+	 * Process closes window during exit. In the case of
+	 * multithread application, the child thread can open
+	 * window and can exit without closing it. Expects parent
+	 * thread to use and close the window. So do not need
+	 * to take pid reference for parent thread.
+	 */
+	vtask->tgid = find_get_pid(task_tgid_vnr(current));
+	/*
+	 * Even a process that has no foreign real address mapping can
+	 * use an unpaired COPY instruction (to no real effect). Issue
+	 * CP_ABORT to clear any pending COPY and prevent a covert
+	 * channel.
+	 *
+	 * __switch_to() will issue CP_ABORT on future context switches
+	 * if process / thread has any open VAS window (Use
+	 * current->mm->context.vas_windows).
+	 */
+	asm volatile(PPC_CP_ABORT);
+
+	return 0;
+}
+
 static int coproc_open(struct inode *inode, struct file *fp)
 {
 	struct coproc_instance *cp_inst;
diff --git a/arch/powerpc/platforms/powernv/vas-fault.c b/arch/powerpc/platforms/powernv/vas-fault.c
index 3d21fce254b7..a4835cb82c09 100644
--- a/arch/powerpc/platforms/powernv/vas-fault.c
+++ b/arch/powerpc/platforms/powernv/vas-fault.c
@@ -73,7 +73,7 @@ static void update_csb(struct vas_window *window,
 	 * NX user space windows can not be opened for task->mm=NULL
 	 * and faults will not be generated for kernel requests.
 	 */
-	if (WARN_ON_ONCE(!window->mm || !window->user_win))
+	if (WARN_ON_ONCE(!window->task.mm || !window->user_win))
 		return;
 
 	csb_addr = (void __user *)be64_to_cpu(crb->csb_addr);
@@ -92,7 +92,7 @@ static void update_csb(struct vas_window *window,
 	csb.address = crb->stamp.nx.fault_storage_addr;
 	csb.flags = 0;
 
-	pid = window->pid;
+	pid = window->task.pid;
 	tsk = get_pid_task(pid, PIDTYPE_PID);
 	/*
 	 * Process closes send window after all pending NX requests are
@@ -111,7 +111,7 @@ static void update_csb(struct vas_window *window,
 	 * a window and exits without closing it.
 	 */
 	if (!tsk) {
-		pid = window->tgid;
+		pid = window->task.tgid;
 		tsk = get_pid_task(pid, PIDTYPE_PID);
 		/*
 		 * Parent thread (tgid) will be closing window when it
@@ -127,7 +127,7 @@ static void update_csb(struct vas_window *window,
 		return;
 	}
 
-	kthread_use_mm(window->mm);
+	kthread_use_mm(window->task.mm);
 	rc = copy_to_user(csb_addr, &csb, sizeof(csb));
 	/*
 	 * User space polls on csb.flags (first byte). So add barrier
@@ -139,7 +139,7 @@ static void update_csb(struct vas_window *window,
 		smp_mb();
 		rc = copy_to_user(csb_addr, &csb, sizeof(u8));
 	}
-	kthread_unuse_mm(window->mm);
+	kthread_unuse_mm(window->task.mm);
 	put_task_struct(tsk);
 
 	/* Success */
diff --git a/arch/powerpc/platforms/powernv/vas-window.c b/arch/powerpc/platforms/powernv/vas-window.c
index b973dd574b47..58e3d16c316f 100644
--- a/arch/powerpc/platforms/powernv/vas-window.c
+++ b/arch/powerpc/platforms/powernv/vas-window.c
@@ -1066,51 +1066,9 @@ struct vas_window *vas_tx_win_open(int vasid, enum vas_cop_type cop,
 			rc = -ENODEV;
 			goto free_window;
 		}
-
-		/*
-		 * Window opened by a child thread may not be closed when
-		 * it exits. So take reference to its pid and release it
-		 * when the window is free by parent thread.
-		 * Acquire a reference to the task's pid to make sure
-		 * pid will not be re-used - needed only for multithread
-		 * applications.
-		 */
-		txwin->pid = get_task_pid(current, PIDTYPE_PID);
-		/*
-		 * Acquire a reference to the task's mm.
-		 */
-		txwin->mm = get_task_mm(current);
-
-		if (!txwin->mm) {
-			put_pid(txwin->pid);
-			pr_err("VAS: pid(%d): mm_struct is not found\n",
-					current->pid);
-			rc = -EPERM;
+		rc = vas_reference_task(&txwin->task);
+		if (rc)
 			goto free_window;
-		}
-
-		mmgrab(txwin->mm);
-		mmput(txwin->mm);
-		mm_context_add_vas_window(txwin->mm);
-		/*
-		 * Process closes window during exit. In the case of
-		 * multithread application, the child thread can open
-		 * window and can exit without closing it. Expects parent
-		 * thread to use and close the window. So do not need
-		 * to take pid reference for parent thread.
-		 */
-		txwin->tgid = find_get_pid(task_tgid_vnr(current));
-		/*
-		 * Even a process that has no foreign real address mapping can
-		 * use an unpaired COPY instruction (to no real effect). Issue
-		 * CP_ABORT to clear any pending COPY and prevent a covert
-		 * channel.
-		 *
-		 * __switch_to() will issue CP_ABORT on future context switches
-		 * if process / thread has any open VAS window (Use
-		 * current->mm->context.vas_windows).
-		 */
-		asm volatile(PPC_CP_ABORT);
 	}
 
 	set_vinst_win(vinst, txwin);
@@ -1340,14 +1298,9 @@ int vas_win_close(struct vas_window *window)
 
 	/* if send window, drop reference to matching receive window */
 	if (window->tx_win) {
-		if (window->user_win) {
-			/* Drop references to pid and mm */
-			put_pid(window->pid);
-			if (window->mm) {
-				mm_context_remove_vas_window(window->mm);
-				mmdrop(window->mm);
-			}
-		}
+		if (window->user_win)
+			vas_drop_reference_task(&window->task);
+
 		put_rx_win(window->rxwin);
 	}
 
diff --git a/arch/powerpc/platforms/powernv/vas.h b/arch/powerpc/platforms/powernv/vas.h
index c7db3190baca..f7aa2d04cd16 100644
--- a/arch/powerpc/platforms/powernv/vas.h
+++ b/arch/powerpc/platforms/powernv/vas.h
@@ -357,11 +357,9 @@ struct vas_window {
 	bool user_win;		/* True if user space window */
 	void *hvwc_map;		/* HV window context */
 	void *uwc_map;		/* OS/User window context */
-	struct pid *pid;	/* Linux process id of owner */
-	struct pid *tgid;	/* Thread group ID of owner */
-	struct mm_struct *mm;	/* Linux process mm_struct */
 	int wcreds_max;		/* Window credits */
 
+	struct vas_win_task task;
 	char *dbgname;
 	struct dentry *dbgdir;
 
@@ -443,7 +441,7 @@ extern void vas_win_paste_addr(struct vas_window *window, u64 *addr,
 
 static inline int vas_window_pid(struct vas_window *window)
 {
-	return pid_vnr(window->pid);
+	return pid_vnr(window->task.pid);
 }
 
 static inline void vas_log_write(struct vas_window *win, char *name,
-- 
2.18.2


