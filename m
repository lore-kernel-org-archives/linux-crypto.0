From: Haren Myneni <haren@linux.vnet.ibm.com>
Subject: [PATCH V3 5/6] crypto/nx: Add P9 NX specific error codes for 842
 engine
Date: Fri, 21 Jul 2017 22:00:48 -0700
Message-ID: <1500699648.23205.7.camel@hbabu-laptop>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Cc: linux-crypto@vger.kernel.org, linuxppc-dev@lists.ozlabs.org,
        mikey@neuling.org, benh@kernel.crashing.org, suka@us.ibm.com,
        ddstreet@ieee.org, linuxram@us.ibm.com, npiggin@gmail.com,
        hbabu@us.ibm.com
To: mpe@ellerman.id.au, herbert@gondor.apana.org.au
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:60227 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1750797AbdGVFA5 (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Sat, 22 Jul 2017 01:00:57 -0400
Received: from pps.filterd (m0098410.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.21/8.16.0.21) with SMTP id v6M4xa7k135741
        for <linux-crypto@vger.kernel.org>; Sat, 22 Jul 2017 01:00:57 -0400
Received: from e32.co.us.ibm.com (e32.co.us.ibm.com [32.97.110.150])
        by mx0a-001b2d01.pphosted.com with ESMTP id 2buyhq8yqv-1
        (version=TLSv1.2 cipher=AES256-SHA bits=256 verify=NOT)
        for <linux-crypto@vger.kernel.org>; Sat, 22 Jul 2017 01:00:57 -0400
Received: from localhost
        by e32.co.us.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
        for <linux-crypto@vger.kernel.org> from <haren@linux.vnet.ibm.com>;
        Fri, 21 Jul 2017 23:00:56 -0600
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>


This patch adds changes for checking P9 specific 842 engine
error codes. These errros are reported in coprocessor status
block (CSB) for failures.

Signed-off-by: Haren Myneni <haren@us.ibm.com>
---
 arch/powerpc/include/asm/icswx.h   |  3 +++
 drivers/crypto/nx/nx-842-powernv.c | 18 ++++++++++++++++++
 drivers/crypto/nx/nx-842.h         |  8 ++++++++
 3 files changed, 29 insertions(+)

diff --git a/arch/powerpc/include/asm/icswx.h b/arch/powerpc/include/asm/icswx.h
index 27e588f6c72e..6a2c87577541 100644
--- a/arch/powerpc/include/asm/icswx.h
+++ b/arch/powerpc/include/asm/icswx.h
@@ -69,7 +69,10 @@ struct coprocessor_completion_block {
 #define CSB_CC_WR_PROTECTION	(16)
 #define CSB_CC_UNKNOWN_CODE	(17)
 #define CSB_CC_ABORT		(18)
+#define CSB_CC_EXCEED_BYTE_COUNT	(19)	/* P9 or later */
 #define CSB_CC_TRANSPORT	(20)
+#define CSB_CC_INVALID_CRB	(21)	/* P9 or later */
+#define CSB_CC_INVALID_DDE	(30)	/* P9 or later */
 #define CSB_CC_SEGMENTED_DDL	(31)
 #define CSB_CC_PROGRESS_POINT	(32)
 #define CSB_CC_DDE_OVERFLOW	(33)
diff --git a/drivers/crypto/nx/nx-842-powernv.c b/drivers/crypto/nx/nx-842-powernv.c
index 829b5cad0043..c0dd4c7e17d3 100644
--- a/drivers/crypto/nx/nx-842-powernv.c
+++ b/drivers/crypto/nx/nx-842-powernv.c
@@ -243,6 +243,13 @@ static int wait_for_csb(struct nx842_workmem *wmem,
 	case CSB_CC_TEMPL_OVERFLOW:
 		CSB_ERR(csb, "Compressed data template shows data past end");
 		return -EINVAL;
+	case CSB_CC_EXCEED_BYTE_COUNT:	/* P9 or later */
+		/*
+		 * DDE byte count exceeds the limit specified in Maximum
+		 * byte count register.
+		 */
+		CSB_ERR(csb, "DDE byte count exceeds the limit");
+		return -EINVAL;
 
 	/* these should not happen */
 	case CSB_CC_INVALID_ALIGN:
@@ -284,9 +291,17 @@ static int wait_for_csb(struct nx842_workmem *wmem,
 		CSB_ERR(csb, "Too many DDEs in DDL");
 		return -EINVAL;
 	case CSB_CC_TRANSPORT:
+	case CSB_CC_INVALID_CRB:	/* P9 or later */
 		/* shouldn't happen, we setup CRB correctly */
 		CSB_ERR(csb, "Invalid CRB");
 		return -EINVAL;
+	case CSB_CC_INVALID_DDE:	/* P9 or later */
+		/*
+		 * shouldn't happen, setup_direct/indirect_dde creates
+		 * DDE right
+		 */
+		CSB_ERR(csb, "Invalid DDE");
+		return -EINVAL;
 	case CSB_CC_SEGMENTED_DDL:
 		/* shouldn't happen, setup_ddl creates DDL right */
 		CSB_ERR(csb, "Segmented DDL error");
@@ -330,6 +345,9 @@ static int wait_for_csb(struct nx842_workmem *wmem,
 	case CSB_CC_HW:
 		CSB_ERR(csb, "Correctable hardware error");
 		return -EPROTO;
+	case CSB_CC_HW_EXPIRED_TIMER:	/* P9 or later */
+		CSB_ERR(csb, "Job did not finish within allowed time");
+		return -EPROTO;
 
 	default:
 		CSB_ERR(csb, "Invalid CC %d", csb->cc);
diff --git a/drivers/crypto/nx/nx-842.h b/drivers/crypto/nx/nx-842.h
index 30929bd7d1a9..bb2f31792683 100644
--- a/drivers/crypto/nx/nx-842.h
+++ b/drivers/crypto/nx/nx-842.h
@@ -76,9 +76,17 @@
 #define CSB_CC_DECRYPT_OVERFLOW	(64)
 /* asym crypt codes */
 #define CSB_CC_MINV_OVERFLOW	(128)
+/*
+ * HW error - Job did not finish in the maximum time allowed.
+ * Job terminated.
+ */
+#define CSB_CC_HW_EXPIRED_TIMER		(224)
 /* These are reserved for hypervisor use */
 #define CSB_CC_HYP_RESERVE_START	(240)
 #define CSB_CC_HYP_RESERVE_END		(253)
+#define CSB_CC_HYP_RESERVE_P9_END	(251)
+/* No valid interrupt server (P9 or later). */
+#define CSB_CC_HYP_RESERVE_NO_INTR_SERVER	(252)
 #define CSB_CC_HYP_NO_HW		(254)
 #define CSB_CC_HYP_HANG_ABORTED		(255)
 
-- 
2.11.0
