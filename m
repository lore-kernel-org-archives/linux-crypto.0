Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 290B5C2B9F4
	for <linux-crypto@archiver.kernel.org>; Thu, 17 Jun 2021 20:29:21 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id F2AC4613D8
	for <linux-crypto@archiver.kernel.org>; Thu, 17 Jun 2021 20:29:20 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231559AbhFQUb1 (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 17 Jun 2021 16:31:27 -0400
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:26226 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S231282AbhFQUb1 (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 17 Jun 2021 16:31:27 -0400
Received: from pps.filterd (m0098420.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 15HKDWpf073982;
        Thu, 17 Jun 2021 16:29:11 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=message-id : subject :
 from : to : cc : date : in-reply-to : references : content-type :
 mime-version : content-transfer-encoding; s=pp1;
 bh=yCWnr1/OA67OHJd0ZHN3WZrSDVbSg83rE0LmbwAlozw=;
 b=DTOBJeLomsa6yrdSxGNoqBM7mMCJIHqRACB8pSYtYrIafQEcWxx1kM2qaqXlvGcX3mXZ
 ehnUVlS79Sx996Hh9AH3ol5bgbyEbH13Dhcw7yqjHgumJ4Jvd7UttJd60IoUVeAewepz
 TguyTCrTqQwB0EL50jeIQnkoCIS8kSWzZ8LEHYCn/vMsO5trYtYHye3p5gyeALquUEwM
 o6Wu2jw3HKri4QT2Pq2CxoqQyNyc8VZPmE54IWlgob/DyvltKM7lNy54jUHCzGq66eTh
 k7t6AXTakDJQOzLD7BTIeUTqZTk/y9OEwV50Tnl3JOVmRx1+0BjWiHKopXbAauUgzSod ug== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0b-001b2d01.pphosted.com with ESMTP id 398d850bdq-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 17 Jun 2021 16:29:11 -0400
Received: from m0098420.ppops.net (m0098420.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 15HKIRjX092256;
        Thu, 17 Jun 2021 16:29:10 -0400
Received: from ppma01wdc.us.ibm.com (fd.55.37a9.ip4.static.sl-reverse.com [169.55.85.253])
        by mx0b-001b2d01.pphosted.com with ESMTP id 398d850bdh-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 17 Jun 2021 16:29:10 -0400
Received: from pps.filterd (ppma01wdc.us.ibm.com [127.0.0.1])
        by ppma01wdc.us.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 15HKHifX015330;
        Thu, 17 Jun 2021 20:29:10 GMT
Received: from b03cxnp08027.gho.boulder.ibm.com (b03cxnp08027.gho.boulder.ibm.com [9.17.130.19])
        by ppma01wdc.us.ibm.com with ESMTP id 394mj9uwhj-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 17 Jun 2021 20:29:10 +0000
Received: from b03ledav005.gho.boulder.ibm.com (b03ledav005.gho.boulder.ibm.com [9.17.130.236])
        by b03cxnp08027.gho.boulder.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 15HKT9E313435616
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 17 Jun 2021 20:29:09 GMT
Received: from b03ledav005.gho.boulder.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 46509BE053;
        Thu, 17 Jun 2021 20:29:09 +0000 (GMT)
Received: from b03ledav005.gho.boulder.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id E2958BE051;
        Thu, 17 Jun 2021 20:29:07 +0000 (GMT)
Received: from localhost.localdomain (unknown [9.160.180.39])
        by b03ledav005.gho.boulder.ibm.com (Postfix) with ESMTP;
        Thu, 17 Jun 2021 20:29:07 +0000 (GMT)
Message-ID: <6020fc4d444864fe20f7dcdc5edfe53e67480a1c.camel@linux.ibm.com>
Subject: [PATCH v6 01/17] powerpc/powernv/vas: Release reference to tgid
 during window close
From:   Haren Myneni <haren@linux.ibm.com>
To:     linuxppc-dev@lists.ozlabs.org, linux-crypto@vger.kernel.org,
        mpe@ellerman.id.au, herbert@gondor.apana.org.au, npiggin@gmail.com
Cc:     hbabu@us.ibm.com, haren@us.ibm.com
Date:   Thu, 17 Jun 2021 13:29:05 -0700
In-Reply-To: <827bf56dce09620ebecd8a00a5f97105187a6205.camel@linux.ibm.com>
References: <827bf56dce09620ebecd8a00a5f97105187a6205.camel@linux.ibm.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.36.2 (3.36.2-1.fc32) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: V-t1qSyzdcLSQ60MHEjirwy7tj5hWDrw
X-Proofpoint-GUID: qOYFvFszJbAFypBv0FUxDHcYqX1moY61
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.391,18.0.790
 definitions=2021-06-17_16:2021-06-15,2021-06-17 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 clxscore=1015 suspectscore=0
 priorityscore=1501 lowpriorityscore=0 mlxlogscore=999 spamscore=0
 bulkscore=0 impostorscore=0 mlxscore=0 phishscore=0 adultscore=0
 malwarescore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2104190000 definitions=main-2106170122
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org


The kernel handles the NX fault by updating CSB or sending
signal to process. In multithread applications, children can
open VAS windows and can exit without closing them. But the
parent can continue to send NX requests with these windows. To
prevent pid reuse, reference will be taken on pid and tgid
when the window is opened and release them during window close.

The current code is not releasing the tgid reference which can
cause pid leak and this patch fixes the issue.

Fixes: db1c08a740635 ("powerpc/vas: Take reference to PID and mm for user space windows")
Cc: stable@vger.kernel.org # 5.8+
Signed-off-by: Haren Myneni <haren@linux.ibm.com>
Reported-by: Nicholas Piggin <npiggin@gmail.com>
Reviewed-by: Nicholas Piggin <npiggin@gmail.com>
---
 arch/powerpc/platforms/powernv/vas-window.c | 9 +++++----
 1 file changed, 5 insertions(+), 4 deletions(-)

diff --git a/arch/powerpc/platforms/powernv/vas-window.c b/arch/powerpc/platforms/powernv/vas-window.c
index 5f5fe63a3d1c..7ba0840fc3b5 100644
--- a/arch/powerpc/platforms/powernv/vas-window.c
+++ b/arch/powerpc/platforms/powernv/vas-window.c
@@ -1093,9 +1093,9 @@ struct vas_window *vas_tx_win_open(int vasid, enum vas_cop_type cop,
 		/*
 		 * Process closes window during exit. In the case of
 		 * multithread application, the child thread can open
-		 * window and can exit without closing it. Expects parent
-		 * thread to use and close the window. So do not need
-		 * to take pid reference for parent thread.
+		 * window and can exit without closing it. so takes tgid
+		 * reference until window closed to make sure tgid is not
+		 * reused.
 		 */
 		txwin->tgid = find_get_pid(task_tgid_vnr(current));
 		/*
@@ -1339,8 +1339,9 @@ int vas_win_close(struct vas_window *window)
 	/* if send window, drop reference to matching receive window */
 	if (window->tx_win) {
 		if (window->user_win) {
-			/* Drop references to pid and mm */
+			/* Drop references to pid. tgid and mm */
 			put_pid(window->pid);
+			put_pid(window->tgid);
 			if (window->mm) {
 				mm_context_remove_vas_window(window->mm);
 				mmdrop(window->mm);
-- 
2.18.2


