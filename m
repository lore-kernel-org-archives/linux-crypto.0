Return-Path: <SRS0=BVES=6E=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AD211C55181
	for <linux-crypto@archiver.kernel.org>; Mon, 20 Apr 2020 20:56:16 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 8D767206E9
	for <linux-crypto@archiver.kernel.org>; Mon, 20 Apr 2020 20:56:16 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726319AbgDTU4Q (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Mon, 20 Apr 2020 16:56:16 -0400
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:19034 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725774AbgDTU4P (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 20 Apr 2020 16:56:15 -0400
Received: from pps.filterd (m0187473.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 03KKWZuD008755;
        Mon, 20 Apr 2020 16:56:05 -0400
Received: from ppma02wdc.us.ibm.com (aa.5b.37a9.ip4.static.sl-reverse.com [169.55.91.170])
        by mx0a-001b2d01.pphosted.com with ESMTP id 30gcbet6jh-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 20 Apr 2020 16:56:05 -0400
Received: from pps.filterd (ppma02wdc.us.ibm.com [127.0.0.1])
        by ppma02wdc.us.ibm.com (8.16.0.27/8.16.0.27) with SMTP id 03KKtOhd008137;
        Mon, 20 Apr 2020 20:56:04 GMT
Received: from b03cxnp08027.gho.boulder.ibm.com (b03cxnp08027.gho.boulder.ibm.com [9.17.130.19])
        by ppma02wdc.us.ibm.com with ESMTP id 30fs66bsfw-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 20 Apr 2020 20:56:04 +0000
Received: from b03ledav006.gho.boulder.ibm.com (b03ledav006.gho.boulder.ibm.com [9.17.130.237])
        by b03cxnp08027.gho.boulder.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 03KKu31S14025292
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 20 Apr 2020 20:56:03 GMT
Received: from b03ledav006.gho.boulder.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 082BAC6057;
        Mon, 20 Apr 2020 20:56:03 +0000 (GMT)
Received: from b03ledav006.gho.boulder.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 7E943C6059;
        Mon, 20 Apr 2020 20:56:02 +0000 (GMT)
Received: from localhost (unknown [9.85.196.70])
        by b03ledav006.gho.boulder.ibm.com (Postfix) with ESMTP;
        Mon, 20 Apr 2020 20:56:02 +0000 (GMT)
From:   Raphael Moreira Zinsly <rzinsly@linux.ibm.com>
To:     linuxppc-dev@lists.ozlabs.org, linux-crypto@vger.kernel.org,
        dja@axtens.net
Cc:     rzinsly@linux.ibm.com, herbert@gondor.apana.org.au,
        mpe@ellerman.id.au, haren@linux.ibm.com, abali@us.ibm.com
Subject: [PATCH V4 1/5] selftests/powerpc: Add header files for GZIP engine test
Date:   Mon, 20 Apr 2020 17:55:34 -0300
Message-Id: <20200420205538.25181-2-rzinsly@linux.ibm.com>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20200420205538.25181-1-rzinsly@linux.ibm.com>
References: <20200420205538.25181-1-rzinsly@linux.ibm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.138,18.0.676
 definitions=2020-04-20_08:2020-04-20,2020-04-20 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 mlxscore=0 phishscore=0
 lowpriorityscore=0 adultscore=0 priorityscore=1501 mlxlogscore=999
 clxscore=1015 suspectscore=0 malwarescore=0 spamscore=0 impostorscore=0
 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2003020000 definitions=main-2004200162
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Add files to access the powerpc NX-GZIP engine in user space.

Signed-off-by: Bulent Abali <abali@us.ibm.com>
Signed-off-by: Raphael Moreira Zinsly <rzinsly@linux.ibm.com>
---
 .../selftests/powerpc/nx-gzip/include/crb.h   | 155 ++++++++++++++++++
 .../selftests/powerpc/nx-gzip/include/nx.h    |  38 +++++
 .../powerpc/nx-gzip/include/vas-api.h         |   1 +
 3 files changed, 194 insertions(+)
 create mode 100644 tools/testing/selftests/powerpc/nx-gzip/include/crb.h
 create mode 100644 tools/testing/selftests/powerpc/nx-gzip/include/nx.h
 create mode 120000 tools/testing/selftests/powerpc/nx-gzip/include/vas-api.h

diff --git a/tools/testing/selftests/powerpc/nx-gzip/include/crb.h b/tools/testing/selftests/powerpc/nx-gzip/include/crb.h
new file mode 100644
index 000000000000..ab101085fa7e
--- /dev/null
+++ b/tools/testing/selftests/powerpc/nx-gzip/include/crb.h
@@ -0,0 +1,155 @@
+/* SPDX-License-Identifier: GPL-2.0-or-later */
+#ifndef __CRB_H
+#define __CRB_H
+#include <linux/types.h>
+#include "nx.h"
+
+/* CCW 842 CI/FC masks
+ * NX P8 workbook, section 4.3.1, figure 4-6
+ * "CI/FC Boundary by NX CT type"
+ */
+#define CCW_CI_842              (0x00003ff8)
+#define CCW_FC_842              (0x00000007)
+
+/* Chapter 6.5.8 Coprocessor-Completion Block (CCB) */
+
+#define CCB_VALUE		(0x3fffffffffffffff)
+#define CCB_ADDRESS		(0xfffffffffffffff8)
+#define CCB_CM			(0x0000000000000007)
+#define CCB_CM0			(0x0000000000000004)
+#define CCB_CM12		(0x0000000000000003)
+
+#define CCB_CM0_ALL_COMPLETIONS	(0x0)
+#define CCB_CM0_LAST_IN_CHAIN	(0x4)
+#define CCB_CM12_STORE		(0x0)
+#define CCB_CM12_INTERRUPT	(0x1)
+
+#define CCB_SIZE		(0x10)
+#define CCB_ALIGN		CCB_SIZE
+
+struct coprocessor_completion_block {
+	__be64 value;
+	__be64 address;
+} __aligned(CCB_ALIGN);
+
+
+/* Chapter 6.5.7 Coprocessor-Status Block (CSB) */
+
+#define CSB_V			(0x80)
+#define CSB_F			(0x04)
+#define CSB_CH			(0x03)
+#define CSB_CE_INCOMPLETE	(0x80)
+#define CSB_CE_TERMINATION	(0x40)
+#define CSB_CE_TPBC		(0x20)
+
+#define CSB_CC_SUCCESS		(0)
+#define CSB_CC_INVALID_ALIGN	(1)
+#define CSB_CC_OPERAND_OVERLAP	(2)
+#define CSB_CC_DATA_LENGTH	(3)
+#define CSB_CC_TRANSLATION	(5)
+#define CSB_CC_PROTECTION	(6)
+#define CSB_CC_RD_EXTERNAL	(7)
+#define CSB_CC_INVALID_OPERAND	(8)
+#define CSB_CC_PRIVILEGE	(9)
+#define CSB_CC_INTERNAL		(10)
+#define CSB_CC_WR_EXTERNAL	(12)
+#define CSB_CC_NOSPC		(13)
+#define CSB_CC_EXCESSIVE_DDE	(14)
+#define CSB_CC_WR_TRANSLATION	(15)
+#define CSB_CC_WR_PROTECTION	(16)
+#define CSB_CC_UNKNOWN_CODE	(17)
+#define CSB_CC_ABORT		(18)
+#define CSB_CC_TRANSPORT	(20)
+#define CSB_CC_SEGMENTED_DDL	(31)
+#define CSB_CC_PROGRESS_POINT	(32)
+#define CSB_CC_DDE_OVERFLOW	(33)
+#define CSB_CC_SESSION		(34)
+#define CSB_CC_PROVISION	(36)
+#define CSB_CC_CHAIN		(37)
+#define CSB_CC_SEQUENCE		(38)
+#define CSB_CC_HW		(39)
+
+#define CSB_SIZE		(0x10)
+#define CSB_ALIGN		CSB_SIZE
+
+struct coprocessor_status_block {
+	__u8 flags;
+	__u8 cs;
+	__u8 cc;
+	__u8 ce;
+	__be32 count;
+	__be64 address;
+} __aligned(CSB_ALIGN);
+
+
+/* Chapter 6.5.10 Data-Descriptor List (DDL)
+ * each list contains one or more Data-Descriptor Entries (DDE)
+ */
+
+#define DDE_P			(0x8000)
+
+#define DDE_SIZE		(0x10)
+#define DDE_ALIGN		DDE_SIZE
+
+struct data_descriptor_entry {
+	__be16 flags;
+	__u8 count;
+	__u8 index;
+	__be32 length;
+	__be64 address;
+} __aligned(DDE_ALIGN);
+
+
+/* Chapter 6.5.2 Coprocessor-Request Block (CRB) */
+
+#define CRB_SIZE		(0x80)
+#define CRB_ALIGN		(0x100) /* Errata: requires 256 alignment */
+
+
+/* Coprocessor Status Block field
+ *   ADDRESS	address of CSB
+ *   C		CCB is valid
+ *   AT		0 = addrs are virtual, 1 = addrs are phys
+ *   M		enable perf monitor
+ */
+#define CRB_CSB_ADDRESS		(0xfffffffffffffff0)
+#define CRB_CSB_C		(0x0000000000000008)
+#define CRB_CSB_AT		(0x0000000000000002)
+#define CRB_CSB_M		(0x0000000000000001)
+
+struct coprocessor_request_block {
+	__be32 ccw;
+	__be32 flags;
+	__be64 csb_addr;
+
+	struct data_descriptor_entry source;
+	struct data_descriptor_entry target;
+
+	struct coprocessor_completion_block ccb;
+
+	__u8 reserved[48];
+
+	struct coprocessor_status_block csb;
+} __aligned(CRB_ALIGN);
+
+#define crb_csb_addr(c)         __be64_to_cpu(c->csb_addr)
+#define crb_nx_fault_addr(c)    __be64_to_cpu(c->stamp.nx.fault_storage_addr)
+#define crb_nx_flags(c)         c->stamp.nx.flags
+#define crb_nx_fault_status(c)  c->stamp.nx.fault_status
+#define crb_nx_pswid(c)		c->stamp.nx.pswid
+
+
+/* RFC02167 Initiate Coprocessor Instructions document
+ * Chapter 8.2.1.1.1 RS
+ * Chapter 8.2.3 Coprocessor Directive
+ * Chapter 8.2.4 Execution
+ *
+ * The CCW must be converted to BE before passing to icswx()
+ */
+
+#define CCW_PS                  (0xff000000)
+#define CCW_CT                  (0x00ff0000)
+#define CCW_CD                  (0x0000ffff)
+#define CCW_CL                  (0x0000c000)
+
+#endif
diff --git a/tools/testing/selftests/powerpc/nx-gzip/include/nx.h b/tools/testing/selftests/powerpc/nx-gzip/include/nx.h
new file mode 100644
index 000000000000..78171b43464d
--- /dev/null
+++ b/tools/testing/selftests/powerpc/nx-gzip/include/nx.h
@@ -0,0 +1,38 @@
+/* SPDX-License-Identifier: GPL-2.0-or-later
+ *
+ * Copyright 2020 IBM Corp.
+ *
+ */
+#ifndef _NX_H
+#define _NX_H
+
+#include <stdbool.h>
+
+#define	NX_FUNC_COMP_842	1
+#define NX_FUNC_COMP_GZIP	2
+
+#ifndef __aligned
+#define __aligned(x)	__attribute__((aligned(x)))
+#endif
+
+struct nx842_func_args {
+	bool use_crc;
+	bool decompress;		/* true decompress; false compress */
+	bool move_data;
+	int timeout;			/* seconds */
+};
+
+struct nxbuf_t {
+	int len;
+	char *buf;
+};
+
+/* @function should be EFT (aka 842), GZIP etc */
+void *nx_function_begin(int function, int pri);
+
+int nx_function(void *handle, struct nxbuf_t *in, struct nxbuf_t *out,
+		void *arg);
+
+int nx_function_end(void *handle);
+
+#endif	/* _NX_H */
diff --git a/tools/testing/selftests/powerpc/nx-gzip/include/vas-api.h b/tools/testing/selftests/powerpc/nx-gzip/include/vas-api.h
new file mode 120000
index 000000000000..77fb4c7236d0
--- /dev/null
+++ b/tools/testing/selftests/powerpc/nx-gzip/include/vas-api.h
@@ -0,0 +1 @@
+../../../../../../arch/powerpc/include/uapi/asm/vas-api.h
\ No newline at end of file
-- 
2.21.0

