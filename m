Return-Path: <SRS0=6qCq=6B=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_2 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 60EC3C2BB55
	for <linux-crypto@archiver.kernel.org>; Fri, 17 Apr 2020 09:01:51 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 3FAA4207FC
	for <linux-crypto@archiver.kernel.org>; Fri, 17 Apr 2020 09:01:51 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729950AbgDQJBu (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 17 Apr 2020 05:01:50 -0400
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:32506 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1729867AbgDQJBu (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 17 Apr 2020 05:01:50 -0400
Received: from pps.filterd (m0098419.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 03H8XP8m058888;
        Fri, 17 Apr 2020 05:01:34 -0400
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0b-001b2d01.pphosted.com with ESMTP id 30f3xrrahs-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 17 Apr 2020 05:01:34 -0400
Received: from m0098419.ppops.net (m0098419.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.36/8.16.0.36) with SMTP id 03H8YFpR063578;
        Fri, 17 Apr 2020 05:01:34 -0400
Received: from ppma05wdc.us.ibm.com (1b.90.2fa9.ip4.static.sl-reverse.com [169.47.144.27])
        by mx0b-001b2d01.pphosted.com with ESMTP id 30f3xrrahd-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 17 Apr 2020 05:01:34 -0400
Received: from pps.filterd (ppma05wdc.us.ibm.com [127.0.0.1])
        by ppma05wdc.us.ibm.com (8.16.0.27/8.16.0.27) with SMTP id 03H90Udi020652;
        Fri, 17 Apr 2020 09:01:33 GMT
Received: from b03cxnp07029.gho.boulder.ibm.com (b03cxnp07029.gho.boulder.ibm.com [9.17.130.16])
        by ppma05wdc.us.ibm.com with ESMTP id 30b5h7h4jd-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 17 Apr 2020 09:01:33 +0000
Received: from b03ledav002.gho.boulder.ibm.com (b03ledav002.gho.boulder.ibm.com [9.17.130.233])
        by b03cxnp07029.gho.boulder.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 03H91WAj57672116
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 17 Apr 2020 09:01:32 GMT
Received: from b03ledav002.gho.boulder.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 87A5E136051;
        Fri, 17 Apr 2020 09:01:32 +0000 (GMT)
Received: from b03ledav002.gho.boulder.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 06B9B136059;
        Fri, 17 Apr 2020 09:01:31 +0000 (GMT)
Received: from [9.70.82.143] (unknown [9.70.82.143])
        by b03ledav002.gho.boulder.ibm.com (Postfix) with ESMTP;
        Fri, 17 Apr 2020 09:01:31 +0000 (GMT)
Subject: [PATCH v6 2/9] powerpc/vas: Define VAS_TX_WIN_OPEN ioctl API
From:   Haren Myneni <haren@linux.ibm.com>
To:     mpe@ellerman.id.au
Cc:     herbert@gondor.apana.org.au, mikey@neuling.org, npiggin@gmail.com,
        linux-crypto@vger.kernel.org, sukadev@linux.vnet.ibm.com,
        linuxppc-dev@lists.ozlabs.org, dja@axtens.net
In-Reply-To: <1587113732.2275.1096.camel@hbabu-laptop>
References: <1587113732.2275.1096.camel@hbabu-laptop>
Content-Type: text/plain; charset="UTF-8"
Date:   Fri, 17 Apr 2020 02:01:05 -0700
Message-ID: <1587114065.2275.1106.camel@hbabu-laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.138,18.0.676
 definitions=2020-04-17_02:2020-04-14,2020-04-17 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 clxscore=1015 suspectscore=1
 bulkscore=0 adultscore=0 mlxlogscore=696 impostorscore=0 phishscore=0
 spamscore=0 lowpriorityscore=0 priorityscore=1501 mlxscore=0
 malwarescore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2003020000 definitions=main-2004170063
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org


Define the VAS_TX_WIN_OPEN ioctl interface for NX GZIP access
from user space. This interface is used to open GZIP send window and
mmap region which can be used by userspace to send requests to NX
directly with copy/paste instructions.

Signed-off-by: Haren Myneni <haren@linux.ibm.com>
---
 Documentation/userspace-api/ioctl/ioctl-number.rst |  1 +
 arch/powerpc/include/uapi/asm/vas-api.h            | 22 ++++++++++++++++++++++
 2 files changed, 23 insertions(+)
 create mode 100644 arch/powerpc/include/uapi/asm/vas-api.h

diff --git a/Documentation/userspace-api/ioctl/ioctl-number.rst b/Documentation/userspace-api/ioctl/ioctl-number.rst
index f759eda..f18accb 100644
--- a/Documentation/userspace-api/ioctl/ioctl-number.rst
+++ b/Documentation/userspace-api/ioctl/ioctl-number.rst
@@ -286,6 +286,7 @@ Code  Seq#    Include File                                           Comments
 'v'   00-1F  linux/fs.h                                              conflict!
 'v'   00-0F  linux/sonypi.h                                          conflict!
 'v'   00-0F  media/v4l2-subdev.h                                     conflict!
+'v'   20-27  arch/powerpc/include/uapi/asm/vas-api.h		     VAS API
 'v'   C0-FF  linux/meye.h                                            conflict!
 'w'   all                                                            CERN SCI driver
 'y'   00-1F                                                          packet based user level communications
diff --git a/arch/powerpc/include/uapi/asm/vas-api.h b/arch/powerpc/include/uapi/asm/vas-api.h
new file mode 100644
index 0000000..fe95d67
--- /dev/null
+++ b/arch/powerpc/include/uapi/asm/vas-api.h
@@ -0,0 +1,22 @@
+/* SPDX-License-Identifier: GPL-2.0+ WITH Linux-syscall-note */
+/*
+ * Copyright 2019 IBM Corp.
+ */
+
+#ifndef _UAPI_MISC_VAS_H
+#define _UAPI_MISC_VAS_H
+
+#include <asm/ioctl.h>
+
+#define VAS_MAGIC	'v'
+#define VAS_TX_WIN_OPEN	_IOW(VAS_MAGIC, 0x20, struct vas_tx_win_open_attr)
+
+struct vas_tx_win_open_attr {
+	__u32	version;
+	__s16	vas_id;	/* specific instance of vas or -1 for default */
+	__u16	reserved1;
+	__u64	flags;	/* Future use */
+	__u64	reserved2[6];
+};
+
+#endif /* _UAPI_MISC_VAS_H */
-- 
1.8.3.1



