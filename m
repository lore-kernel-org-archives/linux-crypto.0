Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 91CC7C433ED
	for <linux-crypto@archiver.kernel.org>; Sat, 17 Apr 2021 21:04:12 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 6C15661245
	for <linux-crypto@archiver.kernel.org>; Sat, 17 Apr 2021 21:04:12 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237079AbhDQVEi (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Sat, 17 Apr 2021 17:04:38 -0400
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:8092 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S237014AbhDQVEi (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Sat, 17 Apr 2021 17:04:38 -0400
Received: from pps.filterd (m0187473.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 13HKX0JT108865;
        Sat, 17 Apr 2021 17:04:05 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=message-id : subject :
 from : to : cc : date : in-reply-to : references : content-type :
 mime-version : content-transfer-encoding; s=pp1;
 bh=q2c4soE/uxFCsY2vPguiLKdt1v/d48oe8aTBXscjNLo=;
 b=MFZJIB+MUZCT6BOSjI5u+GJQfvAd4U8DMcWV2eQogQj3AlpUCLEnoxfQEPlvr87N6G62
 jRyYeu0yu1Q+QMVI31IgRFyHE+0DooDElWLm8nK0sInbUmtpsBScLOL9a/9z1HIMvrdn
 bbikCTnfNGH7eY1AbozmSbwr/eQx6aeEJGZYFq2QLwgZIi0xIn0F8JfuhxtEfCBMs8F2
 06/vr4wQ0dIO00QGpvaRXAsswSEBSnOigMWUgXNrcFqLw0z5wEofctpZx3h3bvXJMiUB
 kfBZ9ik9zdMESJ9+bcYovs4i8ftHdd4HyDg1OcsM+K2aXz0XLyAFzA/h6ORoNFratqua nQ== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 37yuaxk867-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Sat, 17 Apr 2021 17:04:05 -0400
Received: from m0187473.ppops.net (m0187473.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 13HKsB9Y159488;
        Sat, 17 Apr 2021 17:04:04 -0400
Received: from ppma01wdc.us.ibm.com (fd.55.37a9.ip4.static.sl-reverse.com [169.55.85.253])
        by mx0a-001b2d01.pphosted.com with ESMTP id 37yuaxk85m-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Sat, 17 Apr 2021 17:04:04 -0400
Received: from pps.filterd (ppma01wdc.us.ibm.com [127.0.0.1])
        by ppma01wdc.us.ibm.com (8.16.0.43/8.16.0.43) with SMTP id 13HKlw5w019619;
        Sat, 17 Apr 2021 21:04:03 GMT
Received: from b01cxnp22036.gho.pok.ibm.com (b01cxnp22036.gho.pok.ibm.com [9.57.198.26])
        by ppma01wdc.us.ibm.com with ESMTP id 37yqa85hbm-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Sat, 17 Apr 2021 21:04:03 +0000
Received: from b01ledav002.gho.pok.ibm.com (b01ledav002.gho.pok.ibm.com [9.57.199.107])
        by b01cxnp22036.gho.pok.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 13HL41ld8258408
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sat, 17 Apr 2021 21:04:01 GMT
Received: from b01ledav002.gho.pok.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id C47AF12405B;
        Sat, 17 Apr 2021 21:04:01 +0000 (GMT)
Received: from b01ledav002.gho.pok.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id AB7CF124053;
        Sat, 17 Apr 2021 21:04:00 +0000 (GMT)
Received: from localhost.localdomain (unknown [9.80.232.48])
        by b01ledav002.gho.pok.ibm.com (Postfix) with ESMTP;
        Sat, 17 Apr 2021 21:04:00 +0000 (GMT)
Message-ID: <f20654f88f746fe1dd26d27a783a04ae036e8833.camel@linux.ibm.com>
Subject: [V3 PATCH 04/16] powerpc/vas: Move update_csb/dump_crb to common
 book3s platform
From:   Haren Myneni <haren@linux.ibm.com>
To:     linuxppc-dev@lists.ozlabs.org, linux-crypto@vger.kernel.org,
        mpe@ellerman.id.au, herbert@gondor.apana.org.au, npiggin@gmail.com
Cc:     hbabu@us.ibm.com, haren@us.ibm.com
Date:   Sat, 17 Apr 2021 14:03:58 -0700
In-Reply-To: <a910e5bd3f3398b4bd430b25a856500735b993c3.camel@linux.ibm.com>
References: <a910e5bd3f3398b4bd430b25a856500735b993c3.camel@linux.ibm.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.36.2 (3.36.2-1.fc32) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: cQ0qJcKk-ZfOfPdsXL1KccOKSwmYotU1
X-Proofpoint-ORIG-GUID: N7H6O3VjHLfncv6dwtoPOg_0ETpBB39l
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.391,18.0.761
 definitions=2021-04-17_12:2021-04-16,2021-04-17 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 malwarescore=0 phishscore=0
 mlxlogscore=999 bulkscore=0 mlxscore=0 lowpriorityscore=0 spamscore=0
 suspectscore=0 priorityscore=1501 impostorscore=0 clxscore=1015
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2104060000 definitions=main-2104170148
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org


NX issues an interrupt when sees fault on user space buffer. The
kernel processes the fault by updating CSB. This functionality is
same for both powerNV and pseries. So this patch moves these
functions to common vas-api.c and the actual functionality is not
changed.

Signed-off-by: Haren Myneni <haren@linux.ibm.com>
---
 arch/powerpc/include/asm/vas.h             |   3 +
 arch/powerpc/platforms/book3s/vas-api.c    | 146 ++++++++++++++++++-
 arch/powerpc/platforms/powernv/vas-fault.c | 155 ++-------------------
 3 files changed, 157 insertions(+), 147 deletions(-)

diff --git a/arch/powerpc/include/asm/vas.h b/arch/powerpc/include/asm/vas.h
index 2daaa1a2a9a9..66bf8fb1a1be 100644
--- a/arch/powerpc/include/asm/vas.h
+++ b/arch/powerpc/include/asm/vas.h
@@ -210,4 +210,7 @@ int vas_register_coproc_api(struct module *mod, enum vas_cop_type cop_type,
 void vas_unregister_coproc_api(void);
 
 int vas_reference_task(struct vas_win_task *vtask);
+void vas_update_csb(struct coprocessor_request_block *crb,
+		    struct vas_win_task *vtask);
+void vas_dump_crb(struct coprocessor_request_block *crb);
 #endif /* __ASM_POWERPC_VAS_H */
diff --git a/arch/powerpc/platforms/book3s/vas-api.c b/arch/powerpc/platforms/book3s/vas-api.c
index d98caa734154..dc131b2e4acd 100644
--- a/arch/powerpc/platforms/book3s/vas-api.c
+++ b/arch/powerpc/platforms/book3s/vas-api.c
@@ -111,6 +111,150 @@ int vas_reference_task(struct vas_win_task *vtask)
 	return 0;
 }
 
+/*
+ * Update the CSB to indicate a translation error.
+ *
+ * User space will be polling on CSB after the request is issued.
+ * If NX can handle the request without any issues, it updates CSB.
+ * Whereas if NX encounters page fault, the kernel will handle the
+ * fault and update CSB with translation error.
+ *
+ * If we are unable to update the CSB means copy_to_user failed due to
+ * invalid csb_addr, send a signal to the process.
+ */
+void vas_update_csb(struct coprocessor_request_block *crb,
+		    struct vas_win_task *vtask)
+{
+	struct coprocessor_status_block csb;
+	struct kernel_siginfo info;
+	struct task_struct *tsk;
+	void __user *csb_addr;
+	struct pid *pid;
+	int rc;
+
+	/*
+	 * NX user space windows can not be opened for task->mm=NULL
+	 * and faults will not be generated for kernel requests.
+	 */
+	if (WARN_ON_ONCE(!vtask->mm))
+		return;
+
+	csb_addr = (void __user *)be64_to_cpu(crb->csb_addr);
+
+	memset(&csb, 0, sizeof(csb));
+	csb.cc = CSB_CC_FAULT_ADDRESS;
+	csb.ce = CSB_CE_TERMINATION;
+	csb.cs = 0;
+	csb.count = 0;
+
+	/*
+	 * NX operates and returns in BE format as defined CRB struct.
+	 * So saves fault_storage_addr in BE as NX pastes in FIFO and
+	 * expects user space to convert to CPU format.
+	 */
+	csb.address = crb->stamp.nx.fault_storage_addr;
+	csb.flags = 0;
+
+	pid = vtask->pid;
+	tsk = get_pid_task(pid, PIDTYPE_PID);
+	/*
+	 * Process closes send window after all pending NX requests are
+	 * completed. In multi-thread applications, a child thread can
+	 * open a window and can exit without closing it. May be some
+	 * requests are pending or this window can be used by other
+	 * threads later. We should handle faults if NX encounters
+	 * pages faults on these requests. Update CSB with translation
+	 * error and fault address. If csb_addr passed by user space is
+	 * invalid, send SEGV signal to pid saved in window. If the
+	 * child thread is not running, send the signal to tgid.
+	 * Parent thread (tgid) will close this window upon its exit.
+	 *
+	 * pid and mm references are taken when window is opened by
+	 * process (pid). So tgid is used only when child thread opens
+	 * a window and exits without closing it.
+	 */
+	if (!tsk) {
+		pid = vtask->tgid;
+		tsk = get_pid_task(pid, PIDTYPE_PID);
+		/*
+		 * Parent thread (tgid) will be closing window when it
+		 * exits. So should not get here.
+		 */
+		if (WARN_ON_ONCE(!tsk))
+			return;
+	}
+
+	/* Return if the task is exiting. */
+	if (tsk->flags & PF_EXITING) {
+		put_task_struct(tsk);
+		return;
+	}
+
+	kthread_use_mm(vtask->mm);
+	rc = copy_to_user(csb_addr, &csb, sizeof(csb));
+	/*
+	 * User space polls on csb.flags (first byte). So add barrier
+	 * then copy first byte with csb flags update.
+	 */
+	if (!rc) {
+		csb.flags = CSB_V;
+		/* Make sure update to csb.flags is visible now */
+		smp_mb();
+		rc = copy_to_user(csb_addr, &csb, sizeof(u8));
+	}
+	kthread_unuse_mm(vtask->mm);
+	put_task_struct(tsk);
+
+	/* Success */
+	if (!rc)
+		return;
+
+
+	pr_debug("Invalid CSB address 0x%p signalling pid(%d)\n",
+			csb_addr, pid_vnr(pid));
+
+	clear_siginfo(&info);
+	info.si_signo = SIGSEGV;
+	info.si_errno = EFAULT;
+	info.si_code = SEGV_MAPERR;
+	info.si_addr = csb_addr;
+	/*
+	 * process will be polling on csb.flags after request is sent to
+	 * NX. So generally CSB update should not fail except when an
+	 * application passes invalid csb_addr. So an error message will
+	 * be displayed and leave it to user space whether to ignore or
+	 * handle this signal.
+	 */
+	rcu_read_lock();
+	rc = kill_pid_info(SIGSEGV, &info, pid);
+	rcu_read_unlock();
+
+	pr_devel("%s(): pid %d kill_proc_info() rc %d\n", __func__,
+			pid_vnr(pid), rc);
+}
+
+void vas_dump_crb(struct coprocessor_request_block *crb)
+{
+	struct data_descriptor_entry *dde;
+	struct nx_fault_stamp *nx;
+
+	dde = &crb->source;
+	pr_devel("SrcDDE: addr 0x%llx, len %d, count %d, idx %d, flags %d\n",
+		be64_to_cpu(dde->address), be32_to_cpu(dde->length),
+		dde->count, dde->index, dde->flags);
+
+	dde = &crb->target;
+	pr_devel("TgtDDE: addr 0x%llx, len %d, count %d, idx %d, flags %d\n",
+		be64_to_cpu(dde->address), be32_to_cpu(dde->length),
+		dde->count, dde->index, dde->flags);
+
+	nx = &crb->stamp.nx;
+	pr_devel("NX Stamp: PSWID 0x%x, FSA 0x%llx, flags 0x%x, FS 0x%x\n",
+		be32_to_cpu(nx->pswid),
+		be64_to_cpu(crb->stamp.nx.fault_storage_addr),
+		nx->flags, nx->fault_status);
+}
+
 static int coproc_open(struct inode *inode, struct file *fp)
 {
 	struct coproc_instance *cp_inst;
@@ -272,7 +416,7 @@ static struct file_operations coproc_fops = {
  * extended to other coprocessor types later.
  */
 int vas_register_coproc_api(struct module *mod, enum vas_cop_type cop_type,
-			const char *name, struct vas_user_win_ops *vops)
+			    const char *name, struct vas_user_win_ops *vops)
 {
 	int rc = -EINVAL;
 	dev_t devno;
diff --git a/arch/powerpc/platforms/powernv/vas-fault.c b/arch/powerpc/platforms/powernv/vas-fault.c
index a4835cb82c09..2e898eac1bb2 100644
--- a/arch/powerpc/platforms/powernv/vas-fault.c
+++ b/arch/powerpc/platforms/powernv/vas-fault.c
@@ -26,150 +26,6 @@
  */
 #define VAS_FAULT_WIN_FIFO_SIZE	(4 << 20)
 
-static void dump_crb(struct coprocessor_request_block *crb)
-{
-	struct data_descriptor_entry *dde;
-	struct nx_fault_stamp *nx;
-
-	dde = &crb->source;
-	pr_devel("SrcDDE: addr 0x%llx, len %d, count %d, idx %d, flags %d\n",
-		be64_to_cpu(dde->address), be32_to_cpu(dde->length),
-		dde->count, dde->index, dde->flags);
-
-	dde = &crb->target;
-	pr_devel("TgtDDE: addr 0x%llx, len %d, count %d, idx %d, flags %d\n",
-		be64_to_cpu(dde->address), be32_to_cpu(dde->length),
-		dde->count, dde->index, dde->flags);
-
-	nx = &crb->stamp.nx;
-	pr_devel("NX Stamp: PSWID 0x%x, FSA 0x%llx, flags 0x%x, FS 0x%x\n",
-		be32_to_cpu(nx->pswid),
-		be64_to_cpu(crb->stamp.nx.fault_storage_addr),
-		nx->flags, nx->fault_status);
-}
-
-/*
- * Update the CSB to indicate a translation error.
- *
- * User space will be polling on CSB after the request is issued.
- * If NX can handle the request without any issues, it updates CSB.
- * Whereas if NX encounters page fault, the kernel will handle the
- * fault and update CSB with translation error.
- *
- * If we are unable to update the CSB means copy_to_user failed due to
- * invalid csb_addr, send a signal to the process.
- */
-static void update_csb(struct vas_window *window,
-			struct coprocessor_request_block *crb)
-{
-	struct coprocessor_status_block csb;
-	struct kernel_siginfo info;
-	struct task_struct *tsk;
-	void __user *csb_addr;
-	struct pid *pid;
-	int rc;
-
-	/*
-	 * NX user space windows can not be opened for task->mm=NULL
-	 * and faults will not be generated for kernel requests.
-	 */
-	if (WARN_ON_ONCE(!window->task.mm || !window->user_win))
-		return;
-
-	csb_addr = (void __user *)be64_to_cpu(crb->csb_addr);
-
-	memset(&csb, 0, sizeof(csb));
-	csb.cc = CSB_CC_FAULT_ADDRESS;
-	csb.ce = CSB_CE_TERMINATION;
-	csb.cs = 0;
-	csb.count = 0;
-
-	/*
-	 * NX operates and returns in BE format as defined CRB struct.
-	 * So saves fault_storage_addr in BE as NX pastes in FIFO and
-	 * expects user space to convert to CPU format.
-	 */
-	csb.address = crb->stamp.nx.fault_storage_addr;
-	csb.flags = 0;
-
-	pid = window->task.pid;
-	tsk = get_pid_task(pid, PIDTYPE_PID);
-	/*
-	 * Process closes send window after all pending NX requests are
-	 * completed. In multi-thread applications, a child thread can
-	 * open a window and can exit without closing it. May be some
-	 * requests are pending or this window can be used by other
-	 * threads later. We should handle faults if NX encounters
-	 * pages faults on these requests. Update CSB with translation
-	 * error and fault address. If csb_addr passed by user space is
-	 * invalid, send SEGV signal to pid saved in window. If the
-	 * child thread is not running, send the signal to tgid.
-	 * Parent thread (tgid) will close this window upon its exit.
-	 *
-	 * pid and mm references are taken when window is opened by
-	 * process (pid). So tgid is used only when child thread opens
-	 * a window and exits without closing it.
-	 */
-	if (!tsk) {
-		pid = window->task.tgid;
-		tsk = get_pid_task(pid, PIDTYPE_PID);
-		/*
-		 * Parent thread (tgid) will be closing window when it
-		 * exits. So should not get here.
-		 */
-		if (WARN_ON_ONCE(!tsk))
-			return;
-	}
-
-	/* Return if the task is exiting. */
-	if (tsk->flags & PF_EXITING) {
-		put_task_struct(tsk);
-		return;
-	}
-
-	kthread_use_mm(window->task.mm);
-	rc = copy_to_user(csb_addr, &csb, sizeof(csb));
-	/*
-	 * User space polls on csb.flags (first byte). So add barrier
-	 * then copy first byte with csb flags update.
-	 */
-	if (!rc) {
-		csb.flags = CSB_V;
-		/* Make sure update to csb.flags is visible now */
-		smp_mb();
-		rc = copy_to_user(csb_addr, &csb, sizeof(u8));
-	}
-	kthread_unuse_mm(window->task.mm);
-	put_task_struct(tsk);
-
-	/* Success */
-	if (!rc)
-		return;
-
-	pr_debug("Invalid CSB address 0x%p signalling pid(%d)\n",
-			csb_addr, pid_vnr(pid));
-
-	clear_siginfo(&info);
-	info.si_signo = SIGSEGV;
-	info.si_errno = EFAULT;
-	info.si_code = SEGV_MAPERR;
-	info.si_addr = csb_addr;
-
-	/*
-	 * process will be polling on csb.flags after request is sent to
-	 * NX. So generally CSB update should not fail except when an
-	 * application passes invalid csb_addr. So an error message will
-	 * be displayed and leave it to user space whether to ignore or
-	 * handle this signal.
-	 */
-	rcu_read_lock();
-	rc = kill_pid_info(SIGSEGV, &info, pid);
-	rcu_read_unlock();
-
-	pr_devel("%s(): pid %d kill_proc_info() rc %d\n", __func__,
-			pid_vnr(pid), rc);
-}
-
 static void dump_fifo(struct vas_instance *vinst, void *entry)
 {
 	unsigned long *end = vinst->fault_fifo + vinst->fault_fifo_size;
@@ -272,7 +128,7 @@ irqreturn_t vas_fault_thread_fn(int irq, void *data)
 				vinst->vas_id, vinst->fault_fifo, fifo,
 				vinst->fault_crbs);
 
-		dump_crb(crb);
+		vas_dump_crb(crb);
 		window = vas_pswid_to_window(vinst,
 				be32_to_cpu(crb->stamp.nx.pswid));
 
@@ -293,7 +149,14 @@ irqreturn_t vas_fault_thread_fn(int irq, void *data)
 
 			WARN_ON_ONCE(1);
 		} else {
-			update_csb(window, crb);
+			/*
+			 * NX sees faults only with user space windows.
+			 */
+			if (window->user_win)
+				vas_update_csb(crb, &window->task);
+			else
+				WARN_ON_ONCE(!window->user_win);
+
 			/*
 			 * Return credit for send window after processing
 			 * fault CRB.
-- 
2.18.2


