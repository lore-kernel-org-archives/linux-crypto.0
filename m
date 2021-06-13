Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 025D2C48BCF
	for <linux-crypto@archiver.kernel.org>; Sun, 13 Jun 2021 10:57:53 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id D608861042
	for <linux-crypto@archiver.kernel.org>; Sun, 13 Jun 2021 10:57:52 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231636AbhFMK7w (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Sun, 13 Jun 2021 06:59:52 -0400
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:8634 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231176AbhFMK7w (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Sun, 13 Jun 2021 06:59:52 -0400
Received: from pps.filterd (m0187473.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 15DAfRaa171469;
        Sun, 13 Jun 2021 06:57:45 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=message-id : subject :
 from : to : cc : date : in-reply-to : references : content-type :
 mime-version : content-transfer-encoding; s=pp1;
 bh=JS+wteDNzBhZTZ/QMBZ62nCU/dxtCtIKgsOJKXyISto=;
 b=ahui8IklnqUzMOGvx3UalbY1YwEbhlBbGKPpY8wFbUgkFnv7uolrQp1A0xSa7pbYDtns
 XJvoy+68+ya1dQkphN8ohJVt+r0VLj+nSZT07zyIZih7Jn2X+3FAJPStNl+JdNmnHE5W
 zCo/uA4d8ur1sF5KEd4pXN0ES2oV+9CqMwTSXXBPcOLHMFnQvUKG9qLXxctb2yBqrxJ1
 BRnYaWzNCuOWf/Q+csDb7KcTztXxzEvNLGaaFNhxppxX/gkVelSr4Db1l3RRcHEnsXIf
 b4ixz2tXUxN5VU1q73IvZGWAsUbGAttRY+Gw3GkYQ399jWy4KKN2IXg4fyuxtv8kvQ0+ lg== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 395fwn8kj9-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Sun, 13 Jun 2021 06:57:45 -0400
Received: from m0187473.ppops.net (m0187473.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 15DArliC004319;
        Sun, 13 Jun 2021 06:57:44 -0400
Received: from ppma03wdc.us.ibm.com (ba.79.3fa9.ip4.static.sl-reverse.com [169.63.121.186])
        by mx0a-001b2d01.pphosted.com with ESMTP id 395fwn8kht-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Sun, 13 Jun 2021 06:57:44 -0400
Received: from pps.filterd (ppma03wdc.us.ibm.com [127.0.0.1])
        by ppma03wdc.us.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 15DApn2M030700;
        Sun, 13 Jun 2021 10:57:43 GMT
Received: from b03cxnp07029.gho.boulder.ibm.com (b03cxnp07029.gho.boulder.ibm.com [9.17.130.16])
        by ppma03wdc.us.ibm.com with ESMTP id 394mj908p2-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Sun, 13 Jun 2021 10:57:43 +0000
Received: from b03ledav004.gho.boulder.ibm.com (b03ledav004.gho.boulder.ibm.com [9.17.130.235])
        by b03cxnp07029.gho.boulder.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 15DAvgKd34734438
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sun, 13 Jun 2021 10:57:42 GMT
Received: from b03ledav004.gho.boulder.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id CA9487805C;
        Sun, 13 Jun 2021 10:57:42 +0000 (GMT)
Received: from b03ledav004.gho.boulder.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 592677805E;
        Sun, 13 Jun 2021 10:57:41 +0000 (GMT)
Received: from localhost.localdomain (unknown [9.160.180.39])
        by b03ledav004.gho.boulder.ibm.com (Postfix) with ESMTP;
        Sun, 13 Jun 2021 10:57:41 +0000 (GMT)
Message-ID: <3d5873e775ae3c3a5dc9a62298a42d3f190f8d21.camel@linux.ibm.com>
Subject: [PATCH v5 05/17] powerpc/vas: Create take/drop pid and mm reference
 functions
From:   Haren Myneni <haren@linux.ibm.com>
To:     linuxppc-dev@lists.ozlabs.org, linux-crypto@vger.kernel.org,
        mpe@ellerman.id.au, herbert@gondor.apana.org.au, npiggin@gmail.com
Cc:     hbabu@us.ibm.com, haren@us.ibm.com
Date:   Sun, 13 Jun 2021 03:57:38 -0700
In-Reply-To: <ed7a09822cf3a2e463f942e5a37309a2365c9d79.camel@linux.ibm.com>
References: <ed7a09822cf3a2e463f942e5a37309a2365c9d79.camel@linux.ibm.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.36.2 (3.36.2-1.fc32) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: VYqiZh6yiliIJV1uTKKNfAGGr7yGUxde
X-Proofpoint-GUID: rW2vhDhw8AKb2eiTCTH-sSmsnm-h4kwx
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.391,18.0.761
 definitions=2021-06-13_04:2021-06-11,2021-06-13 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 malwarescore=0 adultscore=0
 mlxscore=0 clxscore=1015 lowpriorityscore=0 impostorscore=0 phishscore=0
 spamscore=0 suspectscore=0 priorityscore=1501 bulkscore=0 mlxlogscore=634
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2104190000
 definitions=main-2106130078
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org


Take pid and mm references when each window opens and drops during
close. This functionality is needed for powerNV and pseries. So
this patch defines the existing code as functions in common book3s
platform vas-api.c

Signed-off-by: Haren Myneni <haren@linux.ibm.com>
---
 arch/powerpc/include/asm/vas.h              | 40 +++++++++++++++
 arch/powerpc/platforms/book3s/vas-api.c     | 39 +++++++++++++++
 arch/powerpc/platforms/powernv/vas-fault.c  | 10 ++--
 arch/powerpc/platforms/powernv/vas-window.c | 55 ++-------------------
 arch/powerpc/platforms/powernv/vas.h        |  6 +--
 5 files changed, 91 insertions(+), 59 deletions(-)

diff --git a/arch/powerpc/include/asm/vas.h b/arch/powerpc/include/asm/vas.h
index 85318d7446c7..163460cff59b 100644
--- a/arch/powerpc/include/asm/vas.h
+++ b/arch/powerpc/include/asm/vas.h
@@ -5,6 +5,9 @@
 
 #ifndef _ASM_POWERPC_VAS_H
 #define _ASM_POWERPC_VAS_H
+#include <linux/sched/mm.h>
+#include <linux/mmu_context.h>
+#include <asm/icswx.h>
 #include <uapi/asm/vas-api.h>
 
 struct vas_window;
@@ -49,6 +52,17 @@ enum vas_cop_type {
 	VAS_COP_TYPE_MAX,
 };
 
+/*
+ * User space VAS windows are opened by tasks and take references
+ * to pid and mm until windows are closed.
+ * Stores pid, mm, and tgid for each window.
+ */
+struct vas_user_win_ref {
+	struct pid *pid;	/* PID of owner */
+	struct pid *tgid;	/* Thread group ID of owner */
+	struct mm_struct *mm;	/* Linux process mm_struct */
+};
+
 /*
  * User space window operations used for powernv and powerVM
  */
@@ -59,6 +73,31 @@ struct vas_user_win_ops {
 	int (*close_win)(struct vas_window *);
 };
 
+static inline void put_vas_user_win_ref(struct vas_user_win_ref *ref)
+{
+	/* Drop references to pid, tgid, and mm */
+	put_pid(ref->pid);
+	put_pid(ref->tgid);
+	if (ref->mm)
+		mmdrop(ref->mm);
+}
+
+static inline void vas_user_win_add_mm_context(struct vas_user_win_ref *ref)
+{
+	mm_context_add_vas_window(ref->mm);
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
+}
+
 /*
  * Receive window attributes specified by the (in-kernel) owner of window.
  */
@@ -190,4 +229,5 @@ int vas_register_coproc_api(struct module *mod, enum vas_cop_type cop_type,
 			    const struct vas_user_win_ops *vops);
 void vas_unregister_coproc_api(void);
 
+int get_vas_user_win_ref(struct vas_user_win_ref *task_ref);
 #endif /* __ASM_POWERPC_VAS_H */
diff --git a/arch/powerpc/platforms/book3s/vas-api.c b/arch/powerpc/platforms/book3s/vas-api.c
index 7cfc4b435ae8..1d7d3273d34b 100644
--- a/arch/powerpc/platforms/book3s/vas-api.c
+++ b/arch/powerpc/platforms/book3s/vas-api.c
@@ -55,6 +55,45 @@ static char *coproc_devnode(struct device *dev, umode_t *mode)
 	return kasprintf(GFP_KERNEL, "crypto/%s", dev_name(dev));
 }
 
+/*
+ * Take reference to pid and mm
+ */
+int get_vas_user_win_ref(struct vas_user_win_ref *task_ref)
+{
+	/*
+	 * Window opened by a child thread may not be closed when
+	 * it exits. So take reference to its pid and release it
+	 * when the window is free by parent thread.
+	 * Acquire a reference to the task's pid to make sure
+	 * pid will not be re-used - needed only for multithread
+	 * applications.
+	 */
+	task_ref->pid = get_task_pid(current, PIDTYPE_PID);
+	/*
+	 * Acquire a reference to the task's mm.
+	 */
+	task_ref->mm = get_task_mm(current);
+	if (!task_ref->mm) {
+		put_pid(task_ref->pid);
+		pr_err("VAS: pid(%d): mm_struct is not found\n",
+				current->pid);
+		return -EPERM;
+	}
+
+	mmgrab(task_ref->mm);
+	mmput(task_ref->mm);
+	/*
+	 * Process closes window during exit. In the case of
+	 * multithread application, the child thread can open
+	 * window and can exit without closing it. So takes tgid
+	 * reference until window closed to make sure tgid is not
+	 * reused.
+	 */
+	task_ref->tgid = find_get_pid(task_tgid_vnr(current));
+
+	return 0;
+}
+
 static int coproc_open(struct inode *inode, struct file *fp)
 {
 	struct coproc_instance *cp_inst;
diff --git a/arch/powerpc/platforms/powernv/vas-fault.c b/arch/powerpc/platforms/powernv/vas-fault.c
index 3d21fce254b7..ac3a71ec3bd5 100644
--- a/arch/powerpc/platforms/powernv/vas-fault.c
+++ b/arch/powerpc/platforms/powernv/vas-fault.c
@@ -73,7 +73,7 @@ static void update_csb(struct vas_window *window,
 	 * NX user space windows can not be opened for task->mm=NULL
 	 * and faults will not be generated for kernel requests.
 	 */
-	if (WARN_ON_ONCE(!window->mm || !window->user_win))
+	if (WARN_ON_ONCE(!window->task_ref.mm || !window->user_win))
 		return;
 
 	csb_addr = (void __user *)be64_to_cpu(crb->csb_addr);
@@ -92,7 +92,7 @@ static void update_csb(struct vas_window *window,
 	csb.address = crb->stamp.nx.fault_storage_addr;
 	csb.flags = 0;
 
-	pid = window->pid;
+	pid = window->task_ref.pid;
 	tsk = get_pid_task(pid, PIDTYPE_PID);
 	/*
 	 * Process closes send window after all pending NX requests are
@@ -111,7 +111,7 @@ static void update_csb(struct vas_window *window,
 	 * a window and exits without closing it.
 	 */
 	if (!tsk) {
-		pid = window->tgid;
+		pid = window->task_ref.tgid;
 		tsk = get_pid_task(pid, PIDTYPE_PID);
 		/*
 		 * Parent thread (tgid) will be closing window when it
@@ -127,7 +127,7 @@ static void update_csb(struct vas_window *window,
 		return;
 	}
 
-	kthread_use_mm(window->mm);
+	kthread_use_mm(window->task_ref.mm);
 	rc = copy_to_user(csb_addr, &csb, sizeof(csb));
 	/*
 	 * User space polls on csb.flags (first byte). So add barrier
@@ -139,7 +139,7 @@ static void update_csb(struct vas_window *window,
 		smp_mb();
 		rc = copy_to_user(csb_addr, &csb, sizeof(u8));
 	}
-	kthread_unuse_mm(window->mm);
+	kthread_unuse_mm(window->task_ref.mm);
 	put_task_struct(tsk);
 
 	/* Success */
diff --git a/arch/powerpc/platforms/powernv/vas-window.c b/arch/powerpc/platforms/powernv/vas-window.c
index 5162e95c4090..4222c9bdb8fe 100644
--- a/arch/powerpc/platforms/powernv/vas-window.c
+++ b/arch/powerpc/platforms/powernv/vas-window.c
@@ -1065,51 +1065,11 @@ struct vas_window *vas_tx_win_open(int vasid, enum vas_cop_type cop,
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
+		rc = get_vas_user_win_ref(&txwin->task_ref);
+		if (rc)
 			goto free_window;
-		}
 
-		mmgrab(txwin->mm);
-		mmput(txwin->mm);
-		mm_context_add_vas_window(txwin->mm);
-		/*
-		 * Process closes window during exit. In the case of
-		 * multithread application, the child thread can open
-		 * window and can exit without closing it. so takes tgid
-		 * reference until window closed to make sure tgid is not
-		 * reused.
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
+		vas_user_win_add_mm_context(&txwin->task_ref);
 	}
 
 	set_vinst_win(vinst, txwin);
@@ -1340,13 +1300,8 @@ int vas_win_close(struct vas_window *window)
 	/* if send window, drop reference to matching receive window */
 	if (window->tx_win) {
 		if (window->user_win) {
-			/* Drop references to pid. tgid and mm */
-			put_pid(window->pid);
-			put_pid(window->tgid);
-			if (window->mm) {
-				mm_context_remove_vas_window(window->mm);
-				mmdrop(window->mm);
-			}
+			put_vas_user_win_ref(&window->task_ref);
+			mm_context_remove_vas_window(window->task_ref.mm);
 		}
 		put_rx_win(window->rxwin);
 	}
diff --git a/arch/powerpc/platforms/powernv/vas.h b/arch/powerpc/platforms/powernv/vas.h
index c7db3190baca..f354dd5c51bd 100644
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
 
+	struct vas_user_win_ref task_ref;
 	char *dbgname;
 	struct dentry *dbgdir;
 
@@ -443,7 +441,7 @@ extern void vas_win_paste_addr(struct vas_window *window, u64 *addr,
 
 static inline int vas_window_pid(struct vas_window *window)
 {
-	return pid_vnr(window->pid);
+	return pid_vnr(window->task_ref.pid);
 }
 
 static inline void vas_log_write(struct vas_window *win, char *name,
-- 
2.18.2


