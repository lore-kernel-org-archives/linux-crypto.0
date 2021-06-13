Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B7E36C48BCF
	for <linux-crypto@archiver.kernel.org>; Sun, 13 Jun 2021 11:04:16 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 8D3DA6120E
	for <linux-crypto@archiver.kernel.org>; Sun, 13 Jun 2021 11:04:16 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231664AbhFMLGQ (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Sun, 13 Jun 2021 07:06:16 -0400
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:43674 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S231176AbhFMLGQ (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Sun, 13 Jun 2021 07:06:16 -0400
Received: from pps.filterd (m0098419.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 15DB2hCj059538;
        Sun, 13 Jun 2021 07:04:07 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=message-id : subject :
 from : to : cc : date : in-reply-to : references : content-type :
 mime-version : content-transfer-encoding; s=pp1;
 bh=tGRqXvWB9O4qEGmNzBoLel3V1rlOvgKxs3lZJHkuM30=;
 b=hK4OvIXH3p1U09wYyCJYadT5mOGhwUxPUr0x3B+Xeus7r2UsvsltKAE709lrh26CvTDL
 WL5UhnTsqJEnFaZEFSTonwj5rNCA2DznJ1RytfHRI+MOXf7mW7ekao6NfrvAfjoWjrTI
 bfwIXVtASxyF+IUoEfSMo5S2xTfgw6U5Eiv/MjU4s08e63pvoZsiQe9pEXH5Rs9UQGRL
 UztQa9rp/zlHUIuh5/CGQYil2EyGUNIIDsruwQCWyveXhlUOJ+ajFIYkGRR2//J3Orex
 LDrFCmxKbrXDtgx/AFvZtXQE6vFCIKv0F0Afgz/p4iHmn/cH6afueqrzvvDJg3N+sH5z Sg== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0b-001b2d01.pphosted.com with ESMTP id 395gkpg5ux-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Sun, 13 Jun 2021 07:04:07 -0400
Received: from m0098419.ppops.net (m0098419.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 15DB3GtU063404;
        Sun, 13 Jun 2021 07:04:06 -0400
Received: from ppma01wdc.us.ibm.com (fd.55.37a9.ip4.static.sl-reverse.com [169.55.85.253])
        by mx0b-001b2d01.pphosted.com with ESMTP id 395gkpg5up-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Sun, 13 Jun 2021 07:04:06 -0400
Received: from pps.filterd (ppma01wdc.us.ibm.com [127.0.0.1])
        by ppma01wdc.us.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 15DAvERM031968;
        Sun, 13 Jun 2021 11:04:06 GMT
Received: from b03cxnp07029.gho.boulder.ibm.com (b03cxnp07029.gho.boulder.ibm.com [9.17.130.16])
        by ppma01wdc.us.ibm.com with ESMTP id 394mj8ra7p-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Sun, 13 Jun 2021 11:04:06 +0000
Received: from b03ledav001.gho.boulder.ibm.com (b03ledav001.gho.boulder.ibm.com [9.17.130.232])
        by b03cxnp07029.gho.boulder.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 15DB454k31260936
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sun, 13 Jun 2021 11:04:05 GMT
Received: from b03ledav001.gho.boulder.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 360CF6E04C;
        Sun, 13 Jun 2021 11:04:05 +0000 (GMT)
Received: from b03ledav001.gho.boulder.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id C46186E050;
        Sun, 13 Jun 2021 11:04:03 +0000 (GMT)
Received: from localhost.localdomain (unknown [9.160.180.39])
        by b03ledav001.gho.boulder.ibm.com (Postfix) with ESMTP;
        Sun, 13 Jun 2021 11:04:03 +0000 (GMT)
Message-ID: <0fe93c925b9e5517f55121f51074de425feb5236.camel@linux.ibm.com>
Subject: [PATCH v5 15/17] crypto/nx: Register and unregister VAS interface
 on PowerVM
From:   Haren Myneni <haren@linux.ibm.com>
To:     linuxppc-dev@lists.ozlabs.org, linux-crypto@vger.kernel.org,
        mpe@ellerman.id.au, herbert@gondor.apana.org.au, npiggin@gmail.com
Cc:     hbabu@us.ibm.com, haren@us.ibm.com
Date:   Sun, 13 Jun 2021 04:04:01 -0700
In-Reply-To: <ed7a09822cf3a2e463f942e5a37309a2365c9d79.camel@linux.ibm.com>
References: <ed7a09822cf3a2e463f942e5a37309a2365c9d79.camel@linux.ibm.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.36.2 (3.36.2-1.fc32) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: ZLAeaFjKTDuy5pTK3XGahdSqElNE-yjS
X-Proofpoint-ORIG-GUID: _J8DaAFRjCVe5wOzvlwNvmO6fbawwDlO
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.391,18.0.761
 definitions=2021-06-13_04:2021-06-11,2021-06-13 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 mlxlogscore=999
 impostorscore=0 phishscore=0 lowpriorityscore=0 suspectscore=0 bulkscore=0
 mlxscore=0 priorityscore=1501 clxscore=1015 malwarescore=0 spamscore=0
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2104190000 definitions=main-2106130082
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org


The user space uses /dev/crypto/nx-gzip interface to setup VAS
windows, create paste mapping and close windows. This patch adds
changes to create/remove this interface with VAS register/unregister
functions on PowerVM platform.

Signed-off-by: Haren Myneni <haren@linux.ibm.com>
Acked-by: Herbert Xu <herbert@gondor.apana.org.au>
---
 drivers/crypto/nx/Kconfig             | 1 +
 drivers/crypto/nx/nx-common-pseries.c | 9 +++++++++
 2 files changed, 10 insertions(+)

diff --git a/drivers/crypto/nx/Kconfig b/drivers/crypto/nx/Kconfig
index 23e3d0160e67..2a35e0e785bd 100644
--- a/drivers/crypto/nx/Kconfig
+++ b/drivers/crypto/nx/Kconfig
@@ -29,6 +29,7 @@ if CRYPTO_DEV_NX_COMPRESS
 config CRYPTO_DEV_NX_COMPRESS_PSERIES
 	tristate "Compression acceleration support on pSeries platform"
 	depends on PPC_PSERIES && IBMVIO
+	depends on PPC_VAS
 	default y
 	help
 	  Support for PowerPC Nest (NX) compression acceleration. This
diff --git a/drivers/crypto/nx/nx-common-pseries.c b/drivers/crypto/nx/nx-common-pseries.c
index cc8dd3072b8b..9a40fca8a9e6 100644
--- a/drivers/crypto/nx/nx-common-pseries.c
+++ b/drivers/crypto/nx/nx-common-pseries.c
@@ -9,6 +9,7 @@
  */
 
 #include <asm/vio.h>
+#include <asm/vas.h>
 
 #include "nx-842.h"
 #include "nx_csbcpb.h" /* struct nx_csbcpb */
@@ -1101,6 +1102,12 @@ static int __init nx842_pseries_init(void)
 		return ret;
 	}
 
+	ret = vas_register_api_pseries(THIS_MODULE, VAS_COP_TYPE_GZIP,
+				       "nx-gzip");
+
+	if (ret)
+		pr_err("NX-GZIP is not supported. Returned=%d\n", ret);
+
 	return 0;
 }
 
@@ -1111,6 +1118,8 @@ static void __exit nx842_pseries_exit(void)
 	struct nx842_devdata *old_devdata;
 	unsigned long flags;
 
+	vas_unregister_api_pseries();
+
 	crypto_unregister_alg(&nx842_pseries_alg);
 
 	spin_lock_irqsave(&devdata_mutex, flags);
-- 
2.18.2


