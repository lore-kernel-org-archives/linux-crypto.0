Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5E074C2B9F4
	for <linux-crypto@archiver.kernel.org>; Thu, 17 Jun 2021 20:38:48 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 3C761613E7
	for <linux-crypto@archiver.kernel.org>; Thu, 17 Jun 2021 20:38:48 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232127AbhFQUkz (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 17 Jun 2021 16:40:55 -0400
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:2796 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231656AbhFQUkz (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 17 Jun 2021 16:40:55 -0400
Received: from pps.filterd (m0098396.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 15HKXHtk132752;
        Thu, 17 Jun 2021 16:38:41 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=message-id : subject :
 from : to : cc : date : in-reply-to : references : content-type :
 mime-version : content-transfer-encoding; s=pp1;
 bh=4zSyzVmBc0Z6PpS/InzRmjJ2Hht6AsIEGv6CY2BJFf8=;
 b=UJ7aPV+aatMnGuEOI05vXCFBic0QUq5qCrJpyZQrKTPGre8C2MxiqCCDK6/bY9BRthMf
 SbVNUBeUSrIYgvawP0pIURV+Tf59YFta8v0y/5VvZA5KFl2LweCK14Ni9eId6xq2pERl
 kRWkcgaRJk1TWKyhcjtgEIJG/3wfBhyllzVs3QyXr+WDMsbcOqzh0Q/Q7uh4j2Nrg3GD
 1HbeUAIWs2Gk4MgF07hvaTxZj8F8d086kiq/yqF+RBFL4SB0fN1IE4bw+5RzJgWMtfk6
 6W6OyzMEic0xiJ8n163DJmx1CMIA9rmXDH1G3lhSqQxB2S8xGEZtgE08uFnP8nvI7ur3 Lw== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 398cem9vj5-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 17 Jun 2021 16:38:41 -0400
Received: from m0098396.ppops.net (m0098396.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 15HKXGK4132407;
        Thu, 17 Jun 2021 16:38:41 -0400
Received: from ppma01dal.us.ibm.com (83.d6.3fa9.ip4.static.sl-reverse.com [169.63.214.131])
        by mx0a-001b2d01.pphosted.com with ESMTP id 398cem9vhr-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 17 Jun 2021 16:38:40 -0400
Received: from pps.filterd (ppma01dal.us.ibm.com [127.0.0.1])
        by ppma01dal.us.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 15HKc6t6006008;
        Thu, 17 Jun 2021 20:38:40 GMT
Received: from b01cxnp22034.gho.pok.ibm.com (b01cxnp22034.gho.pok.ibm.com [9.57.198.24])
        by ppma01dal.us.ibm.com with ESMTP id 394mjaxser-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 17 Jun 2021 20:38:40 +0000
Received: from b01ledav002.gho.pok.ibm.com (b01ledav002.gho.pok.ibm.com [9.57.199.107])
        by b01cxnp22034.gho.pok.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 15HKcd7b30474684
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 17 Jun 2021 20:38:39 GMT
Received: from b01ledav002.gho.pok.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 46784124052;
        Thu, 17 Jun 2021 20:38:39 +0000 (GMT)
Received: from b01ledav002.gho.pok.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 443F2124054;
        Thu, 17 Jun 2021 20:38:38 +0000 (GMT)
Received: from localhost.localdomain (unknown [9.160.180.39])
        by b01ledav002.gho.pok.ibm.com (Postfix) with ESMTP;
        Thu, 17 Jun 2021 20:38:38 +0000 (GMT)
Message-ID: <f2b6a1fb8b6112595a73d81c67a35af4e7f5d0a3.camel@linux.ibm.com>
Subject: [PATCH v6 15/17] crypto/nx: Get NX capabilities for GZIP
 coprocessor type
From:   Haren Myneni <haren@linux.ibm.com>
To:     linuxppc-dev@lists.ozlabs.org, linux-crypto@vger.kernel.org,
        mpe@ellerman.id.au, herbert@gondor.apana.org.au, npiggin@gmail.com
Cc:     hbabu@us.ibm.com, haren@us.ibm.com
Date:   Thu, 17 Jun 2021 13:38:36 -0700
In-Reply-To: <827bf56dce09620ebecd8a00a5f97105187a6205.camel@linux.ibm.com>
References: <827bf56dce09620ebecd8a00a5f97105187a6205.camel@linux.ibm.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.36.2 (3.36.2-1.fc32) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: swikMMLZN9xDJOXKnoegRCQIB5qsGfvp
X-Proofpoint-ORIG-GUID: YakIuBOUjXK4GTGVzf8rEkvS1YNUixKg
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.391,18.0.790
 definitions=2021-06-17_15:2021-06-15,2021-06-17 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 priorityscore=1501
 bulkscore=0 spamscore=0 phishscore=0 mlxlogscore=999 lowpriorityscore=0
 clxscore=1015 adultscore=0 suspectscore=0 impostorscore=0 mlxscore=0
 malwarescore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2104190000 definitions=main-2106170123
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org


The hypervisor provides different NX capabilities that it
supports. These capabilities such as recommended minimum
compression / decompression lengths and the maximum request
buffer size in bytes are used to define the user space NX
request.

NX will reject the request if the buffer size is more than
the maximum buffer size. Whereas compression / decompression
lengths are recommended values for better performance.

Changes to get NX overall capabilities which points to the
specific features that the hypervisor supports. Then retrieve
the capabilities for the specific feature (available only
for NXGZIP).

Signed-off-by: Haren Myneni <haren@linux.ibm.com>
Acked-by: Herbert Xu <herbert@gondor.apana.org.au>
---
 drivers/crypto/nx/nx-common-pseries.c | 87 +++++++++++++++++++++++++++
 1 file changed, 87 insertions(+)

diff --git a/drivers/crypto/nx/nx-common-pseries.c b/drivers/crypto/nx/nx-common-pseries.c
index cc8dd3072b8b..9fc2abb56019 100644
--- a/drivers/crypto/nx/nx-common-pseries.c
+++ b/drivers/crypto/nx/nx-common-pseries.c
@@ -9,6 +9,8 @@
  */
 
 #include <asm/vio.h>
+#include <asm/hvcall.h>
+#include <asm/vas.h>
 
 #include "nx-842.h"
 #include "nx_csbcpb.h" /* struct nx_csbcpb */
@@ -19,6 +21,29 @@ MODULE_DESCRIPTION("842 H/W Compression driver for IBM Power processors");
 MODULE_ALIAS_CRYPTO("842");
 MODULE_ALIAS_CRYPTO("842-nx");
 
+/*
+ * Coprocessor type specific capabilities from the hypervisor.
+ */
+struct hv_nx_cop_caps {
+	__be64	descriptor;
+	__be64	req_max_processed_len;	/* Max bytes in one GZIP request */
+	__be64	min_compress_len;	/* Min compression size in bytes */
+	__be64	min_decompress_len;	/* Min decompression size in bytes */
+} __packed __aligned(0x1000);
+
+/*
+ * Coprocessor type specific capabilities.
+ */
+struct nx_cop_caps {
+	u64	descriptor;
+	u64	req_max_processed_len;	/* Max bytes in one GZIP request */
+	u64	min_compress_len;	/* Min compression in bytes */
+	u64	min_decompress_len;	/* Min decompression in bytes */
+};
+
+static u64 caps_feat;
+static struct nx_cop_caps nx_cop_caps;
+
 static struct nx842_constraints nx842_pseries_constraints = {
 	.alignment =	DDE_BUFFER_ALIGN,
 	.multiple =	DDE_BUFFER_LAST_MULT,
@@ -1065,6 +1090,64 @@ static void nx842_remove(struct vio_dev *viodev)
 	kfree(old_devdata);
 }
 
+/*
+ * Get NX capabilities from the hypervisor.
+ * Only NXGZIP capabilities are provided by the hypersvisor right
+ * now and these values are available to user space with sysfs.
+ */
+static void __init nxcop_get_capabilities(void)
+{
+	struct hv_vas_all_caps *hv_caps;
+	struct hv_nx_cop_caps *hv_nxc;
+	int rc;
+
+	hv_caps = kmalloc(sizeof(*hv_caps), GFP_KERNEL);
+	if (!hv_caps)
+		return;
+	/*
+	 * Get NX overall capabilities with feature type=0
+	 */
+	rc = h_query_vas_capabilities(H_QUERY_NX_CAPABILITIES, 0,
+					  (u64)virt_to_phys(hv_caps));
+	if (rc)
+		goto out;
+
+	caps_feat = be64_to_cpu(hv_caps->feat_type);
+	/*
+	 * NX-GZIP feature available
+	 */
+	if (caps_feat & VAS_NX_GZIP_FEAT_BIT) {
+		hv_nxc = kmalloc(sizeof(*hv_nxc), GFP_KERNEL);
+		if (!hv_nxc)
+			goto out;
+		/*
+		 * Get capabilities for NX-GZIP feature
+		 */
+		rc = h_query_vas_capabilities(H_QUERY_NX_CAPABILITIES,
+						  VAS_NX_GZIP_FEAT,
+						  (u64)virt_to_phys(hv_nxc));
+	} else {
+		pr_err("NX-GZIP feature is not available\n");
+		rc = -EINVAL;
+	}
+
+	if (!rc) {
+		nx_cop_caps.descriptor = be64_to_cpu(hv_nxc->descriptor);
+		nx_cop_caps.req_max_processed_len =
+				be64_to_cpu(hv_nxc->req_max_processed_len);
+		nx_cop_caps.min_compress_len =
+				be64_to_cpu(hv_nxc->min_compress_len);
+		nx_cop_caps.min_decompress_len =
+				be64_to_cpu(hv_nxc->min_decompress_len);
+	} else {
+		caps_feat = 0;
+	}
+
+	kfree(hv_nxc);
+out:
+	kfree(hv_caps);
+}
+
 static const struct vio_device_id nx842_vio_driver_ids[] = {
 	{"ibm,compression-v1", "ibm,compression"},
 	{"", ""},
@@ -1092,6 +1175,10 @@ static int __init nx842_pseries_init(void)
 		return -ENOMEM;
 
 	RCU_INIT_POINTER(devdata, new_devdata);
+	/*
+	 * Get NX capabilities from the hypervisor.
+	 */
+	nxcop_get_capabilities();
 
 	ret = vio_register_driver(&nx842_vio_driver);
 	if (ret) {
-- 
2.18.2


