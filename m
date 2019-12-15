Return-Path: <SRS0=cN8K=2F=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_2 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 60B63C43603
	for <linux-crypto@archiver.kernel.org>; Sun, 15 Dec 2019 13:01:58 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 30D552467F
	for <linux-crypto@archiver.kernel.org>; Sun, 15 Dec 2019 13:01:58 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726112AbfLONB5 (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Sun, 15 Dec 2019 08:01:57 -0500
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:7802 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726103AbfLONB5 (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Sun, 15 Dec 2019 08:01:57 -0500
Received: from pps.filterd (m0098410.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id xBFCusw0098093;
        Sun, 15 Dec 2019 08:01:41 -0500
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 2wvw59t1ry-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Sun, 15 Dec 2019 08:01:41 -0500
Received: from m0098410.ppops.net (m0098410.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.36/8.16.0.36) with SMTP id xBFCvdeY099672;
        Sun, 15 Dec 2019 08:01:41 -0500
Received: from ppma02dal.us.ibm.com (a.bd.3ea9.ip4.static.sl-reverse.com [169.62.189.10])
        by mx0a-001b2d01.pphosted.com with ESMTP id 2wvw59t1re-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Sun, 15 Dec 2019 08:01:41 -0500
Received: from pps.filterd (ppma02dal.us.ibm.com [127.0.0.1])
        by ppma02dal.us.ibm.com (8.16.0.27/8.16.0.27) with SMTP id xBFCxs5K015156;
        Sun, 15 Dec 2019 13:01:40 GMT
Received: from b03cxnp08028.gho.boulder.ibm.com (b03cxnp08028.gho.boulder.ibm.com [9.17.130.20])
        by ppma02dal.us.ibm.com with ESMTP id 2wvqc5x7e4-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Sun, 15 Dec 2019 13:01:40 +0000
Received: from b03ledav006.gho.boulder.ibm.com (b03ledav006.gho.boulder.ibm.com [9.17.130.237])
        by b03cxnp08028.gho.boulder.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id xBFD1cxr26476900
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sun, 15 Dec 2019 13:01:38 GMT
Received: from b03ledav006.gho.boulder.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 972FEC605A;
        Sun, 15 Dec 2019 13:01:38 +0000 (GMT)
Received: from b03ledav006.gho.boulder.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 345D8C6055;
        Sun, 15 Dec 2019 13:01:38 +0000 (GMT)
Received: from [9.70.82.143] (unknown [9.70.82.143])
        by b03ledav006.gho.boulder.ibm.com (Postfix) with ESMTP;
        Sun, 15 Dec 2019 13:01:37 +0000 (GMT)
Subject: [PATCH 01/10] powerpc/vas: Define vas_win_paste_addr()
From:   Haren Myneni <haren@linux.ibm.com>
To:     herbert@gondor.apana.org.au
Cc:     mpe@ellerman.id.au, linux-crypto@vger.kernel.org,
        linuxppc-dev@lists.ozlabs.org, hch@infradead.org,
        npiggin@gmail.com, mikey@neuling.org, sukadev@linux.vnet.ibm.com
In-Reply-To: <1576414240.16318.4066.camel@hbabu-laptop>
References: <1576414240.16318.4066.camel@hbabu-laptop>
Content-Type: text/plain; charset="UTF-8"
Date:   Sun, 15 Dec 2019 04:59:48 -0800
Message-ID: <1576414789.16318.4076.camel@hbabu-laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.95,18.0.572
 definitions=2019-12-15_03:2019-12-13,2019-12-15 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 phishscore=0 suspectscore=1
 mlxlogscore=981 mlxscore=0 bulkscore=0 adultscore=0 malwarescore=0
 lowpriorityscore=0 priorityscore=1501 impostorscore=0 spamscore=0
 clxscore=1015 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-1910280000 definitions=main-1912150124
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org


Define an interface that the NX drivers can use to find the physical
paste address of a send window. This interface is expected to be used
with the mmap() operation of the NX driver's device. i.e the user space
process can use driver's mmap() operation to map the send window's paste
address into their address space and then use copy and paste instructions
to submit the CRBs to the NX engine.

Signed-off-by: Sukadev Bhattiprolu <sukadev@linux.vnet.ibm.com>
Signed-off-by: Haren Myneni <haren@us.ibm.com>
---
 arch/powerpc/include/asm/vas.h              |  5 +++++
 arch/powerpc/platforms/powernv/vas-window.c | 10 ++++++++++
 2 files changed, 15 insertions(+)

diff --git a/arch/powerpc/include/asm/vas.h b/arch/powerpc/include/asm/vas.h
index f93e6b0..6d9e692 100644
--- a/arch/powerpc/include/asm/vas.h
+++ b/arch/powerpc/include/asm/vas.h
@@ -163,4 +163,9 @@ struct vas_window *vas_tx_win_open(int vasid, enum vas_cop_type cop,
  */
 int vas_paste_crb(struct vas_window *win, int offset, bool re);
 
+/*
+ * Return the power bus paste address associated with @win so the caller
+ * can map that address into their address space.
+ */
+extern u64 vas_win_paste_addr(struct vas_window *win);
 #endif /* __ASM_POWERPC_VAS_H */
diff --git a/arch/powerpc/platforms/powernv/vas-window.c b/arch/powerpc/platforms/powernv/vas-window.c
index 5322d1c..b51eac5 100644
--- a/arch/powerpc/platforms/powernv/vas-window.c
+++ b/arch/powerpc/platforms/powernv/vas-window.c
@@ -42,6 +42,16 @@ static void compute_paste_address(struct vas_window *window, u64 *addr, int *len
 	pr_debug("Txwin #%d: Paste addr 0x%llx\n", winid, *addr);
 }
 
+u64 vas_win_paste_addr(struct vas_window *win)
+{
+	u64 addr;
+
+	compute_paste_address(win, &addr, NULL);
+
+	return addr;
+}
+EXPORT_SYMBOL(vas_win_paste_addr);
+
 static inline void get_hvwc_mmio_bar(struct vas_window *window,
 			u64 *start, int *len)
 {
-- 
1.8.3.1



