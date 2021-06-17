Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D33C0C2B9F4
	for <linux-crypto@archiver.kernel.org>; Thu, 17 Jun 2021 20:37:20 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id AE29561042
	for <linux-crypto@archiver.kernel.org>; Thu, 17 Jun 2021 20:37:20 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231289AbhFQUj1 (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 17 Jun 2021 16:39:27 -0400
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:8812 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S232185AbhFQUj0 (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 17 Jun 2021 16:39:26 -0400
Received: from pps.filterd (m0098410.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 15HKYChL145356;
        Thu, 17 Jun 2021 16:37:12 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=message-id : subject :
 from : to : cc : date : in-reply-to : references : content-type :
 mime-version : content-transfer-encoding; s=pp1;
 bh=Nokx6NLTnjK37T/mjziekeqqk+ZVBoWW41Hf+YGYKqw=;
 b=eKjhfK1mj2Lz2fVYnJqW44+xbkDKcAEo6vjKSFP2L57+UrJQr3HnzJgtDzZSseNXVOPd
 aq+xWhVYkcnG5jyjD7ENN8WnVH6rcyhAWg0b5h3PSvHiPn9/ouZ3Wy7r6BkY5bL068X3
 9h0OG6dlOEc7jXFhAjXheO4c1PLRVRaw+wJ1hdjtTHYKisSqm94tcsF65Y8t7RVorR7S
 5wzGOQwY142s29dhQkDBSlB2KaqjEjnoQThc5a8CV3MpVOpVSR8FdNeT6I6zgqwSU9CE
 10I5Cyn+ovVieez1HTPxOs5K0Rv45rBl49R8IZ87XA/j7H+9/i+6jEtH4teV8ZIE/Ta8 7g== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 398ck2hm9t-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 17 Jun 2021 16:37:12 -0400
Received: from m0098410.ppops.net (m0098410.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 15HKYRNV146784;
        Thu, 17 Jun 2021 16:37:11 -0400
Received: from ppma02dal.us.ibm.com (a.bd.3ea9.ip4.static.sl-reverse.com [169.62.189.10])
        by mx0a-001b2d01.pphosted.com with ESMTP id 398ck2hm9j-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 17 Jun 2021 16:37:11 -0400
Received: from pps.filterd (ppma02dal.us.ibm.com [127.0.0.1])
        by ppma02dal.us.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 15HKIIYw020726;
        Thu, 17 Jun 2021 20:37:10 GMT
Received: from b01cxnp22035.gho.pok.ibm.com (b01cxnp22035.gho.pok.ibm.com [9.57.198.25])
        by ppma02dal.us.ibm.com with ESMTP id 394mjaeqee-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 17 Jun 2021 20:37:10 +0000
Received: from b01ledav001.gho.pok.ibm.com (b01ledav001.gho.pok.ibm.com [9.57.199.106])
        by b01cxnp22035.gho.pok.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 15HKbA1g32833926
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 17 Jun 2021 20:37:10 GMT
Received: from b01ledav001.gho.pok.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id E8BED2805C;
        Thu, 17 Jun 2021 20:37:09 +0000 (GMT)
Received: from b01ledav001.gho.pok.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id CD6402805A;
        Thu, 17 Jun 2021 20:37:08 +0000 (GMT)
Received: from localhost.localdomain (unknown [9.160.180.39])
        by b01ledav001.gho.pok.ibm.com (Postfix) with ESMTP;
        Thu, 17 Jun 2021 20:37:08 +0000 (GMT)
Message-ID: <b8fc66dcb783d06a099a303e5cfc69087bb3357a.camel@linux.ibm.com>
Subject: [PATCH v6 13/17] powerpc/pseries/vas: Setup IRQ and fault handling
From:   Haren Myneni <haren@linux.ibm.com>
To:     linuxppc-dev@lists.ozlabs.org, linux-crypto@vger.kernel.org,
        mpe@ellerman.id.au, herbert@gondor.apana.org.au, npiggin@gmail.com
Cc:     hbabu@us.ibm.com, haren@us.ibm.com
Date:   Thu, 17 Jun 2021 13:37:06 -0700
In-Reply-To: <827bf56dce09620ebecd8a00a5f97105187a6205.camel@linux.ibm.com>
References: <827bf56dce09620ebecd8a00a5f97105187a6205.camel@linux.ibm.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.36.2 (3.36.2-1.fc32) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: LLm4b_qOCql53TZO-U0ChTueU8nqJ1mJ
X-Proofpoint-ORIG-GUID: I86OKeR5fSyu8_LSbEkB2JGx18XOsKHq
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.391,18.0.790
 definitions=2021-06-17_16:2021-06-15,2021-06-17 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 impostorscore=0 mlxscore=0
 priorityscore=1501 malwarescore=0 phishscore=0 clxscore=1015
 lowpriorityscore=0 adultscore=0 mlxlogscore=999 spamscore=0 bulkscore=0
 suspectscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2104190000 definitions=main-2106170123
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org


NX generates an interrupt when sees a fault on the user space
buffer and the hypervisor forwards that interrupt to OS. Then
the kernel handles the interrupt by issuing H_GET_NX_FAULT hcall
to retrieve the fault CRB information.

This patch also adds changes to setup and free IRQ per each
window and also handles the fault by updating the CSB.

Signed-off-by: Haren Myneni <haren@linux.ibm.com>
---
 arch/powerpc/platforms/pseries/vas.c | 102 +++++++++++++++++++++++++++
 1 file changed, 102 insertions(+)

diff --git a/arch/powerpc/platforms/pseries/vas.c b/arch/powerpc/platforms/pseries/vas.c
index f5a44f2f0e99..3385b5400cc6 100644
--- a/arch/powerpc/platforms/pseries/vas.c
+++ b/arch/powerpc/platforms/pseries/vas.c
@@ -11,6 +11,7 @@
 #include <linux/types.h>
 #include <linux/delay.h>
 #include <linux/slab.h>
+#include <linux/interrupt.h>
 #include <asm/machdep.h>
 #include <asm/hvcall.h>
 #include <asm/plpar_wrappers.h>
@@ -155,6 +156,50 @@ int h_query_vas_capabilities(const u64 hcall, u8 query_type, u64 result)
 }
 EXPORT_SYMBOL_GPL(h_query_vas_capabilities);
 
+/*
+ * hcall to get fault CRB from the hypervisor.
+ */
+static int h_get_nx_fault(u32 winid, u64 buffer)
+{
+	long rc;
+
+	rc = plpar_hcall_norets(H_GET_NX_FAULT, winid, buffer);
+
+	if (rc == H_SUCCESS)
+		return 0;
+
+	pr_err("H_GET_NX_FAULT error: %ld, winid %u, buffer 0x%llx\n",
+		rc, winid, buffer);
+	return -EIO;
+
+}
+
+/*
+ * Handle the fault interrupt.
+ * When the fault interrupt is received for each window, query the
+ * hypervisor to get the fault CRB on the specific fault. Then
+ * process the CRB by updating CSB or send signal if the user space
+ * CSB is invalid.
+ * Note: The hypervisor forwards an interrupt for each fault request.
+ *	So one fault CRB to process for each H_GET_NX_FAULT hcall.
+ */
+irqreturn_t pseries_vas_fault_thread_fn(int irq, void *data)
+{
+	struct pseries_vas_window *txwin = data;
+	struct coprocessor_request_block crb;
+	struct vas_user_win_ref *tsk_ref;
+	int rc;
+
+	rc = h_get_nx_fault(txwin->vas_win.winid, (u64)virt_to_phys(&crb));
+	if (!rc) {
+		tsk_ref = &txwin->vas_win.task_ref;
+		vas_dump_crb(&crb);
+		vas_update_csb(&crb, tsk_ref);
+	}
+
+	return IRQ_HANDLED;
+}
+
 /*
  * Allocate window and setup IRQ mapping.
  */
@@ -166,10 +211,51 @@ static int allocate_setup_window(struct pseries_vas_window *txwin,
 	rc = h_allocate_vas_window(txwin, domain, wintype, DEF_WIN_CREDS);
 	if (rc)
 		return rc;
+	/*
+	 * On PowerVM, the hypervisor setup and forwards the fault
+	 * interrupt per window. So the IRQ setup and fault handling
+	 * will be done for each open window separately.
+	 */
+	txwin->fault_virq = irq_create_mapping(NULL, txwin->fault_irq);
+	if (!txwin->fault_virq) {
+		pr_err("Failed irq mapping %d\n", txwin->fault_irq);
+		rc = -EINVAL;
+		goto out_win;
+	}
+
+	txwin->name = kasprintf(GFP_KERNEL, "vas-win-%d",
+				txwin->vas_win.winid);
+	if (!txwin->name) {
+		rc = -ENOMEM;
+		goto out_irq;
+	}
+
+	rc = request_threaded_irq(txwin->fault_virq, NULL,
+				  pseries_vas_fault_thread_fn, IRQF_ONESHOT,
+				  txwin->name, txwin);
+	if (rc) {
+		pr_err("VAS-Window[%d]: Request IRQ(%u) failed with %d\n",
+		       txwin->vas_win.winid, txwin->fault_virq, rc);
+		goto out_free;
+	}
 
 	txwin->vas_win.wcreds_max = DEF_WIN_CREDS;
 
 	return 0;
+out_free:
+	kfree(txwin->name);
+out_irq:
+	irq_dispose_mapping(txwin->fault_virq);
+out_win:
+	h_deallocate_vas_window(txwin->vas_win.winid);
+	return rc;
+}
+
+static inline void free_irq_setup(struct pseries_vas_window *txwin)
+{
+	free_irq(txwin->fault_virq, txwin);
+	kfree(txwin->name);
+	irq_dispose_mapping(txwin->fault_virq);
 }
 
 static struct vas_window *vas_allocate_window(int vas_id, u64 flags,
@@ -284,6 +370,11 @@ static struct vas_window *vas_allocate_window(int vas_id, u64 flags,
 	return &txwin->vas_win;
 
 out_free:
+	/*
+	 * Window is not operational. Free IRQ before closing
+	 * window so that do not have to hold mutex.
+	 */
+	free_irq_setup(txwin);
 	h_deallocate_vas_window(txwin->vas_win.winid);
 out:
 	atomic_dec(&cop_feat_caps->used_lpar_creds);
@@ -303,7 +394,18 @@ static int deallocate_free_window(struct pseries_vas_window *win)
 {
 	int rc = 0;
 
+	/*
+	 * The hypervisor waits for all requests including faults
+	 * are processed before closing the window - Means all
+	 * credits have to be returned. In the case of fault
+	 * request, a credit is returned after OS issues
+	 * H_GET_NX_FAULT hcall.
+	 * So free IRQ after executing H_DEALLOCATE_VAS_WINDOW
+	 * hcall.
+	 */
 	rc = h_deallocate_vas_window(win->vas_win.winid);
+	if (!rc)
+		free_irq_setup(win);
 
 	return rc;
 }
-- 
2.18.2


