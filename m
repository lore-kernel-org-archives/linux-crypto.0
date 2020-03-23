Return-Path: <SRS0=HSjb=5I=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.3 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_2 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E286CC3F2CD
	for <linux-crypto@archiver.kernel.org>; Mon, 23 Mar 2020 04:02:26 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id BAB0020658
	for <linux-crypto@archiver.kernel.org>; Mon, 23 Mar 2020 04:02:26 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725810AbgCWEC0 (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Mon, 23 Mar 2020 00:02:26 -0400
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:17514 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725807AbgCWEC0 (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 23 Mar 2020 00:02:26 -0400
Received: from pps.filterd (m0098404.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 02N3WU9i057478;
        Mon, 23 Mar 2020 00:02:11 -0400
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 2ywf0knd5t-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 23 Mar 2020 00:02:11 -0400
Received: from m0098404.ppops.net (m0098404.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.36/8.16.0.36) with SMTP id 02N3rpVE035070;
        Mon, 23 Mar 2020 00:02:10 -0400
Received: from ppma01wdc.us.ibm.com (fd.55.37a9.ip4.static.sl-reverse.com [169.55.85.253])
        by mx0a-001b2d01.pphosted.com with ESMTP id 2ywf0knd5c-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 23 Mar 2020 00:02:10 -0400
Received: from pps.filterd (ppma01wdc.us.ibm.com [127.0.0.1])
        by ppma01wdc.us.ibm.com (8.16.0.27/8.16.0.27) with SMTP id 02N3xZYe026882;
        Mon, 23 Mar 2020 04:02:09 GMT
Received: from b01cxnp23034.gho.pok.ibm.com (b01cxnp23034.gho.pok.ibm.com [9.57.198.29])
        by ppma01wdc.us.ibm.com with ESMTP id 2ywawm5nag-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 23 Mar 2020 04:02:09 +0000
Received: from b01ledav002.gho.pok.ibm.com (b01ledav002.gho.pok.ibm.com [9.57.199.107])
        by b01cxnp23034.gho.pok.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 02N428mU47579512
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 23 Mar 2020 04:02:08 GMT
Received: from b01ledav002.gho.pok.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id D4DDF124054;
        Mon, 23 Mar 2020 04:02:08 +0000 (GMT)
Received: from b01ledav002.gho.pok.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 23F5D124058;
        Mon, 23 Mar 2020 04:02:08 +0000 (GMT)
Received: from [9.70.82.143] (unknown [9.70.82.143])
        by b01ledav002.gho.pok.ibm.com (Postfix) with ESMTP;
        Mon, 23 Mar 2020 04:02:08 +0000 (GMT)
Subject: [PATCH v4 2/9] powerpc/vas: Define VAS_TX_WIN_OPEN ioctl API
From:   Haren Myneni <haren@linux.ibm.com>
To:     herbert@gondor.apana.org.au
Cc:     mpe@ellerman.id.au, dja@axtens.net, mikey@neuling.org,
        sukadev@linux.vnet.ibm.com, linuxppc-dev@lists.ozlabs.org,
        linux-crypto@vger.kernel.org, npiggin@gmail.com
In-Reply-To: <1584934879.9256.15321.camel@hbabu-laptop>
References: <1584934879.9256.15321.camel@hbabu-laptop>
Content-Type: text/plain; charset="UTF-8"
Date:   Sun, 22 Mar 2020 21:01:38 -0700
Message-ID: <1584936098.9256.15324.camel@hbabu-laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.138,18.0.645
 definitions=2020-03-22_08:2020-03-21,2020-03-22 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 priorityscore=1501
 phishscore=0 impostorscore=0 malwarescore=0 mlxlogscore=659 spamscore=0
 clxscore=1015 lowpriorityscore=0 adultscore=0 suspectscore=1 bulkscore=0
 mlxscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2003020000 definitions=main-2003230017
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
index 2e91370..deabc73 100644
--- a/Documentation/userspace-api/ioctl/ioctl-number.rst
+++ b/Documentation/userspace-api/ioctl/ioctl-number.rst
@@ -287,6 +287,7 @@ Code  Seq#    Include File                                           Comments
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



