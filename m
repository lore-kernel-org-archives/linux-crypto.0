Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 36EF7C433ED
	for <linux-crypto@archiver.kernel.org>; Sun, 11 Apr 2021 00:37:07 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 06B4561028
	for <linux-crypto@archiver.kernel.org>; Sun, 11 Apr 2021 00:37:07 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234680AbhDKAhV (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Sat, 10 Apr 2021 20:37:21 -0400
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:62152 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S234548AbhDKAhV (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Sat, 10 Apr 2021 20:37:21 -0400
Received: from pps.filterd (m0098409.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 13B0XYJ4073183;
        Sat, 10 Apr 2021 20:37:00 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=message-id : subject :
 from : to : cc : date : in-reply-to : references : content-type :
 mime-version : content-transfer-encoding; s=pp1;
 bh=9ETTbJjrjvw9mMBYfehCAwyxedjykqeURiOMtjUAEwo=;
 b=sX7gwgPxu6NLHcX+W5RIVHbkW4tG+okKe5c4ILYlSIRlA/Q7To5HGexkzswe3dOZBM6n
 Uj9YGrEUSmMSPNLRZFdA+k93nFG1NVRSPtdanIKgP25dNE7RAWJCASCs4EbDaA3LLdkR
 H59vlUWeh0B9m2gD+TaiT2hIjo2Qj3wToaqcFmkloladGMwYDioqnQOijnfdi9KohkJp
 RrjuhATEb0Q9upse4yumfc2LxTEpZ6ZPYqPOKwHSxTMAHO3nrIQxhWOZwg4bzW0SbLRJ
 SUe6GfuCux5OtHDMOs9iJS6L3jnEXKGcN3GciuGIDeB7MFuzYNV7lg7Z5cC4ABQ40i44 Vw== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 37u7aqn22e-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Sat, 10 Apr 2021 20:37:00 -0400
Received: from m0098409.ppops.net (m0098409.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 13B0aOWM077881;
        Sat, 10 Apr 2021 20:36:59 -0400
Received: from ppma01dal.us.ibm.com (83.d6.3fa9.ip4.static.sl-reverse.com [169.63.214.131])
        by mx0a-001b2d01.pphosted.com with ESMTP id 37u7aqn229-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Sat, 10 Apr 2021 20:36:59 -0400
Received: from pps.filterd (ppma01dal.us.ibm.com [127.0.0.1])
        by ppma01dal.us.ibm.com (8.16.0.43/8.16.0.43) with SMTP id 13B0RYv2021517;
        Sun, 11 Apr 2021 00:36:58 GMT
Received: from b03cxnp08026.gho.boulder.ibm.com (b03cxnp08026.gho.boulder.ibm.com [9.17.130.18])
        by ppma01dal.us.ibm.com with ESMTP id 37u3n8pdbr-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Sun, 11 Apr 2021 00:36:58 +0000
Received: from b03ledav003.gho.boulder.ibm.com (b03ledav003.gho.boulder.ibm.com [9.17.130.234])
        by b03cxnp08026.gho.boulder.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 13B0avnS26870090
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sun, 11 Apr 2021 00:36:57 GMT
Received: from b03ledav003.gho.boulder.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 5A7506A04F;
        Sun, 11 Apr 2021 00:36:57 +0000 (GMT)
Received: from b03ledav003.gho.boulder.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id F1D456A057;
        Sun, 11 Apr 2021 00:36:55 +0000 (GMT)
Received: from localhost.localdomain (unknown [9.80.232.48])
        by b03ledav003.gho.boulder.ibm.com (Postfix) with ESMTP;
        Sun, 11 Apr 2021 00:36:55 +0000 (GMT)
Message-ID: <49bccf905ce2e70f35ef1f1ba99e16654d364139.camel@linux.ibm.com>
Subject: [PATCH 08/16] powerpc/pseries/VAS: Implement
 allocate/modify/deallocate HCALLS
From:   Haren Myneni <haren@linux.ibm.com>
To:     linuxppc-dev@lists.ozlabs.org, linux-crypto@vger.kernel.org,
        mpe@ellerman.id.au, herbert@gondor.apana.org.au, npiggin@gmail.com
Cc:     hbabu@us.ibm.com, haren@us.ibm.com
Date:   Sat, 10 Apr 2021 17:36:54 -0700
In-Reply-To: <b4631127bd025d9585246606c350ec88dbe1e99a.camel@linux.ibm.com>
References: <b4631127bd025d9585246606c350ec88dbe1e99a.camel@linux.ibm.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.36.2 (3.36.2-1.fc32) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: 6_Kzw71GupgKzI2Z4MwkrpWarTL5kWza
X-Proofpoint-ORIG-GUID: CiCPzORgWH2qEwOKlsTwsWu851_Xf858
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.391,18.0.761
 definitions=2021-04-10_07:2021-04-09,2021-04-10 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 mlxlogscore=999
 suspectscore=0 adultscore=0 priorityscore=1501 lowpriorityscore=0
 spamscore=0 clxscore=1015 impostorscore=0 mlxscore=0 phishscore=0
 bulkscore=0 malwarescore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2104060000 definitions=main-2104110000
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org


This patch adds the following HCALLs which are used to allocate,
modify and deallocate VAS windows.

H_ALLOCATE_VAS_WINDOW: Allocate VAS window
H_DEALLOCATE_VAS_WINDOW: Close VAS window
H_MODIFY_VAS_WINDOW: Setup window before using

Also adds phyp call (H_QUERY_VAS_CAPABILITIES) to get all VAS
capabilities that phyp provides.

Signed-off-by: Haren Myneni <haren@linux.ibm.com>
---
 arch/powerpc/platforms/pseries/vas.c | 217 +++++++++++++++++++++++++++
 1 file changed, 217 insertions(+)
 create mode 100644 arch/powerpc/platforms/pseries/vas.c

diff --git a/arch/powerpc/platforms/pseries/vas.c b/arch/powerpc/platforms/pseries/vas.c
new file mode 100644
index 000000000000..06960151477c
--- /dev/null
+++ b/arch/powerpc/platforms/pseries/vas.c
@@ -0,0 +1,217 @@
+// SPDX-License-Identifier: GPL-2.0-or-later
+/*
+ * Copyright 2020-21 IBM Corp.
+ */
+
+#define pr_fmt(fmt) "vas: " fmt
+
+#include <linux/module.h>
+#include <linux/kernel.h>
+#include <linux/export.h>
+#include <linux/types.h>
+#include <linux/delay.h>
+#include <linux/slab.h>
+#include <linux/irqdomain.h>
+#include <linux/interrupt.h>
+#include <linux/sched/mm.h>
+#include <linux/mmu_context.h>
+#include <asm/hvcall.h>
+#include <asm/hvconsole.h>
+#include <asm/machdep.h>
+#include <asm/plpar_wrappers.h>
+#include <asm/vas.h>
+#include "vas.h"
+
+#define	VAS_INVALID_WIN_ADDRESS	0xFFFFFFFFFFFFFFFFul
+#define	VAS_DEFAULT_DOMAIN_ID	0xFFFFFFFFFFFFFFFFul
+/* Authority Mask Register (AMR) value is not supported in */
+/* linux implementation. So pass '0' to modify window HCALL */
+#define	VAS_AMR_VALUE	0
+/* phyp allows one credit per window right now */
+#define DEF_WIN_CREDS		1
+
+static int64_t hcall_return_busy_check(int64_t rc)
+{
+	/* Check if we are stalled for some time */
+	if (H_IS_LONG_BUSY(rc)) {
+		msleep(get_longbusy_msecs(rc));
+		rc = H_BUSY;
+	} else if (rc == H_BUSY) {
+		cond_resched();
+	}
+
+	return rc;
+}
+
+/*
+ * Allocate VAS window HCALL
+ */
+static int plpar_vas_allocate_window(struct vas_window *win, u64 *domain,
+				     u8 wintype, u16 credits)
+{
+	long retbuf[PLPAR_HCALL9_BUFSIZE] = {0};
+	int64_t rc;
+
+	do {
+		rc = plpar_hcall9(H_ALLOCATE_VAS_WINDOW, retbuf, wintype,
+				  credits, domain[0], domain[1], domain[2],
+				  domain[3], domain[4], domain[5]);
+
+		rc = hcall_return_busy_check(rc);
+	} while (rc == H_BUSY);
+
+	switch (rc) {
+	case H_SUCCESS:
+		win->winid = retbuf[0];
+		win->lpar.win_addr = retbuf[1];
+		win->lpar.complete_irq = retbuf[2];
+		win->lpar.fault_irq = retbuf[3];
+		if (win->lpar.win_addr == VAS_INVALID_WIN_ADDRESS) {
+			pr_err("HCALL(%x): COPY/PASTE is not supported\n",
+				H_ALLOCATE_VAS_WINDOW);
+			return -ENOTSUPP;
+		}
+		return 0;
+	case H_PARAMETER:
+		pr_err("HCALL(%x): Invalid window type (%u)\n",
+			H_ALLOCATE_VAS_WINDOW, wintype);
+		return -EINVAL;
+	case H_P2:
+		pr_err("HCALL(%x): Credits(%u) exceed maximum window credits\n",
+			H_ALLOCATE_VAS_WINDOW, credits);
+		return -EINVAL;
+	case H_COP_HW:
+		pr_err("HCALL(%x): User-mode COPY/PASTE is not supported\n",
+			H_ALLOCATE_VAS_WINDOW);
+		return -ENOTSUPP;
+	case H_RESOURCE:
+		pr_err("HCALL(%x): LPAR credit limit exceeds window limit\n",
+			H_ALLOCATE_VAS_WINDOW);
+		return -EPERM;
+	case H_CONSTRAINED:
+		pr_err("HCALL(%x): Credits (%u) are not available\n",
+			H_ALLOCATE_VAS_WINDOW, credits);
+		return -EPERM;
+	default:
+		pr_err("HCALL(%x): Unexpected error %lld\n",
+			H_ALLOCATE_VAS_WINDOW, rc);
+		return -EIO;
+	}
+}
+
+/*
+ * Deallocate VAS window HCALL.
+ */
+static int plpar_vas_deallocate_window(u64 winid)
+{
+	int64_t rc;
+
+	do {
+		rc = plpar_hcall_norets(H_DEALLOCATE_VAS_WINDOW, winid);
+
+		rc = hcall_return_busy_check(rc);
+	} while (rc == H_BUSY);
+
+	switch (rc) {
+	case H_SUCCESS:
+		return 0;
+	case H_PARAMETER:
+		pr_err("HCALL(%x): Invalid window ID %llu\n",
+			H_DEALLOCATE_VAS_WINDOW, winid);
+		return -EINVAL;
+	case H_STATE:
+		pr_err("HCALL(%x): Window(%llu): Invalid page table entries\n",
+			H_DEALLOCATE_VAS_WINDOW, winid);
+		return -EPERM;
+	default:
+		pr_err("HCALL(%x): Unexpected error %lld for window(%llu)\n",
+			H_DEALLOCATE_VAS_WINDOW, rc, winid);
+		return -EIO;
+	}
+}
+
+/*
+ * Modify VAS window.
+ * After the window is opened with allocate window HCALL, configure it
+ * with flags and LPAR PID before using.
+ */
+static int plpar_vas_modify_window(struct vas_window *win)
+{
+	int64_t rc;
+	u32 lpid = mfspr(SPRN_PID);
+
+	/*
+	 * AMR value is not supported in Linux implementation
+	 * phyp ignores it if 0 is passed.
+	 */
+	do {
+		rc = plpar_hcall_norets(H_MODIFY_VAS_WINDOW, win->winid,
+					lpid, 0, VAS_MOD_WIN_FLAGS,
+					VAS_AMR_VALUE);
+
+		rc = hcall_return_busy_check(rc);
+	} while (rc == H_BUSY);
+
+	switch (rc) {
+	case H_SUCCESS:
+		return 0;
+	case H_PARAMETER:
+		pr_err("HCALL(%x): Invalid window ID %u\n",
+			H_MODIFY_VAS_WINDOW, win->winid);
+		return -EINVAL;
+	case H_P2:
+		pr_err("HCALL(%x): Window(%d): Invalid LPAR Process ID %u\n",
+			H_MODIFY_VAS_WINDOW, lpid, win->winid);
+		return -EINVAL;
+	case H_P3:
+		/* LPAR thread ID is deprecated on P10 */
+		pr_err("HCALL(%x): Invalid LPAR Thread ID for window(%u)\n",
+			H_MODIFY_VAS_WINDOW, win->winid);
+		return -EINVAL;
+	case H_STATE:
+		pr_err("HCALL(%x): Jobs in progress, Can't modify window(%u)\n",
+			H_MODIFY_VAS_WINDOW, win->winid);
+		return -EBUSY;
+	default:
+		pr_err("HCALL(%x): Unexpected error %lld for window(%u)\n",
+			H_MODIFY_VAS_WINDOW, rc, win->winid);
+		return -EIO;
+	}
+}
+
+/*
+ * This HCALL is used to determine the capabilities that pHyp provides.
+ * @hcall: H_QUERY_VAS_CAPABILITIES or H_QUERY_NX_CAPABILITIES
+ * @query_type: If 0 is passed, phyp returns the overall capabilities
+ *		which provides all feature(s) that are available. Then
+ *		query phyp to get the corresponding capabilities for
+ *		the specific feature.
+ *		Example: H_QUERY_VAS_CAPABILITIES provides VAS GZIP QoS
+ *			and VAS GZIP Default capabilities.
+ *			H_QUERY_NX_CAPABILITIES provides NX GZIP
+ *			capabilities.
+ * @result: Return buffer to save capabilities.
+ */
+int plpar_vas_query_capabilities(const u64 hcall, u8 query_type,
+					u64 result)
+{
+	int64_t rc;
+
+	rc = plpar_hcall_norets(hcall, query_type, result);
+
+	switch (rc) {
+	case H_SUCCESS:
+		return 0;
+	case H_PARAMETER:
+		pr_err("HCALL(%llx): Invalid query type %u\n", hcall,
+			query_type);
+		return -EINVAL;
+	case H_PRIVILEGE:
+		pr_err("HCALL(%llx): Invalid result buffer 0x%llx\n",
+			hcall, result);
+		return -EACCES;
+	default:
+		pr_err("HCALL(%llx): Unexpected error %lld\n", hcall, rc);
+		return -EIO;
+	}
+}
-- 
2.18.2


