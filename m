Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 621BFC48BCF
	for <linux-crypto@archiver.kernel.org>; Sun, 13 Jun 2021 11:01:50 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 3E4A661153
	for <linux-crypto@archiver.kernel.org>; Sun, 13 Jun 2021 11:01:50 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231658AbhFMLDu (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Sun, 13 Jun 2021 07:03:50 -0400
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:48094 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231176AbhFMLDt (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Sun, 13 Jun 2021 07:03:49 -0400
Received: from pps.filterd (m0098404.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 15DAXnXZ020074;
        Sun, 13 Jun 2021 07:01:42 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=message-id : subject :
 from : to : cc : date : in-reply-to : references : content-type :
 mime-version : content-transfer-encoding; s=pp1;
 bh=Da3Dom5EKeLHebbV4z0tUuNtWALZPRTZ6EVuAjbEkKU=;
 b=p3Kc1X4STs4wkWUVfQJmhRUiMyfu0lKTPuK4MrvkpRGzA1GyW+DdUcNa8VcqqYvpwZDp
 H1t5CwZI16FIrBhZhQjVzVC53eOQGdg1EVGJCFzI9wMnJnZcABBob1fZjTWVJQUOtQyR
 hXg85Pr2Lk8Ui4Dq+GUmqJ/8I5kjTWPdFwIy+wCedQ5pjWZN/pCgJ7PLAOFwIWyaK6+v
 kOLBgMJJZWICKKf1HLSeLpaI5ReP2fVH9lx+jZxkLbmLyk6fvndfJe/E8VQLGR8Zrcf7
 eBSmKnl0O6FxJkHINpErPRGPS3wkaxn4MdOT+FN/uGOQgCe2STfCXtwMKvYYF8Z11+Z5 qw== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 395fn8s2mt-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Sun, 13 Jun 2021 07:01:41 -0400
Received: from m0098404.ppops.net (m0098404.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 15DAqWrS134740;
        Sun, 13 Jun 2021 07:01:41 -0400
Received: from ppma02dal.us.ibm.com (a.bd.3ea9.ip4.static.sl-reverse.com [169.62.189.10])
        by mx0a-001b2d01.pphosted.com with ESMTP id 395fn8s2mj-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Sun, 13 Jun 2021 07:01:41 -0400
Received: from pps.filterd (ppma02dal.us.ibm.com [127.0.0.1])
        by ppma02dal.us.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 15DAvvsH003974;
        Sun, 13 Jun 2021 11:01:40 GMT
Received: from b01cxnp22035.gho.pok.ibm.com (b01cxnp22035.gho.pok.ibm.com [9.57.198.25])
        by ppma02dal.us.ibm.com with ESMTP id 394mj92b46-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Sun, 13 Jun 2021 11:01:40 +0000
Received: from b01ledav001.gho.pok.ibm.com (b01ledav001.gho.pok.ibm.com [9.57.199.106])
        by b01cxnp22035.gho.pok.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 15DB1dRr38797734
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sun, 13 Jun 2021 11:01:39 GMT
Received: from b01ledav001.gho.pok.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id DC78C2805C;
        Sun, 13 Jun 2021 11:01:39 +0000 (GMT)
Received: from b01ledav001.gho.pok.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id F0D652805E;
        Sun, 13 Jun 2021 11:01:38 +0000 (GMT)
Received: from localhost.localdomain (unknown [9.160.180.39])
        by b01ledav001.gho.pok.ibm.com (Postfix) with ESMTP;
        Sun, 13 Jun 2021 11:01:38 +0000 (GMT)
Message-ID: <4ca037732838675bd8e12de702687971e0ab2b3d.camel@linux.ibm.com>
Subject: [PATCH v5 11/17] powerpc/pseries/vas: Implement getting
 capabilities from hypervisor
From:   Haren Myneni <haren@linux.ibm.com>
To:     linuxppc-dev@lists.ozlabs.org, linux-crypto@vger.kernel.org,
        mpe@ellerman.id.au, herbert@gondor.apana.org.au, npiggin@gmail.com
Cc:     hbabu@us.ibm.com, haren@us.ibm.com
Date:   Sun, 13 Jun 2021 04:01:37 -0700
In-Reply-To: <ed7a09822cf3a2e463f942e5a37309a2365c9d79.camel@linux.ibm.com>
References: <ed7a09822cf3a2e463f942e5a37309a2365c9d79.camel@linux.ibm.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.36.2 (3.36.2-1.fc32) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: TzossS4HPyPm4Gyp40pRpOkIyJi1K8Q1
X-Proofpoint-GUID: 6PFcT0ENj20kzk6V-eDlKwZxoTB_A2Sp
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.391,18.0.761
 definitions=2021-06-13_04:2021-06-11,2021-06-13 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 adultscore=0 malwarescore=0
 suspectscore=0 phishscore=0 impostorscore=0 mlxlogscore=999 clxscore=1015
 mlxscore=0 priorityscore=1501 spamscore=0 bulkscore=0 lowpriorityscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2104190000
 definitions=main-2106130078
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org


The hypervisor provides VAS capabilities for GZIP default and QoS
features. These capabilities gives information for the specific
features such as total number of credits available in LPAR,
maximum credits allowed per window, maximum credits allowed in
LPAR, whether usermode copy/paste is supported, and etc.

This patch adds the following:
- Retrieve all features that are provided by hypervisor using
  H_QUERY_VAS_CAPABILITIES hcall with 0 as feature type.
- Retrieve capabilities for the specific feature using the same
  hcall and the feature type (1 for QoS and 2 for default type).

Signed-off-by: Haren Myneni <haren@linux.ibm.com>
---
 arch/powerpc/platforms/pseries/vas.c | 124 +++++++++++++++++++++++++++
 1 file changed, 124 insertions(+)

diff --git a/arch/powerpc/platforms/pseries/vas.c b/arch/powerpc/platforms/pseries/vas.c
index fec280979d50..98109a13f1c2 100644
--- a/arch/powerpc/platforms/pseries/vas.c
+++ b/arch/powerpc/platforms/pseries/vas.c
@@ -10,6 +10,7 @@
 #include <linux/export.h>
 #include <linux/types.h>
 #include <linux/delay.h>
+#include <asm/machdep.h>
 #include <asm/hvcall.h>
 #include <asm/plpar_wrappers.h>
 #include <asm/vas.h>
@@ -20,6 +21,13 @@
 /* phyp allows one credit per window right now */
 #define DEF_WIN_CREDS		1
 
+static struct vas_all_caps caps_all;
+static bool copypaste_feat;
+
+static struct vas_caps vascaps[VAS_MAX_FEAT_TYPE];
+
+static DEFINE_MUTEX(vas_pseries_mutex);
+
 static long hcall_return_busy_check(long rc)
 {
 	/* Check if we are stalled for some time */
@@ -179,3 +187,119 @@ int h_query_vas_capabilities(const u64 hcall, u8 query_type, u64 result)
 		return -EIO;
 	}
 }
+
+/*
+ * Get the specific capabilities based on the feature type.
+ * Right now supports GZIP default and GZIP QoS capabilities.
+ */
+static int get_vas_capabilities(u8 feat, enum vas_cop_feat_type type,
+				struct hv_vas_ct_caps *hv_caps)
+{
+	struct vas_ct_caps *caps;
+	struct vas_caps *vcaps;
+	int rc = 0;
+
+	vcaps = &vascaps[type];
+	memset(vcaps, 0, sizeof(*vcaps));
+	INIT_LIST_HEAD(&vcaps->list);
+
+	caps = &vcaps->caps;
+
+	rc = h_query_vas_capabilities(H_QUERY_VAS_CAPABILITIES, feat,
+					  (u64)virt_to_phys(hv_caps));
+	if (rc)
+		return rc;
+
+	caps->user_mode = hv_caps->user_mode;
+	if (!(caps->user_mode & VAS_COPY_PASTE_USER_MODE)) {
+		pr_err("User space COPY/PASTE is not supported\n");
+		return -ENOTSUPP;
+	}
+
+	caps->descriptor = be64_to_cpu(hv_caps->descriptor);
+	caps->win_type = hv_caps->win_type;
+	if (caps->win_type >= VAS_MAX_FEAT_TYPE) {
+		pr_err("Unsupported window type %u\n", caps->win_type);
+		return -EINVAL;
+	}
+	caps->max_lpar_creds = be16_to_cpu(hv_caps->max_lpar_creds);
+	caps->max_win_creds = be16_to_cpu(hv_caps->max_win_creds);
+	atomic_set(&caps->target_lpar_creds,
+		   be16_to_cpu(hv_caps->target_lpar_creds));
+	if (feat == VAS_GZIP_DEF_FEAT) {
+		caps->def_lpar_creds = be16_to_cpu(hv_caps->def_lpar_creds);
+
+		if (caps->max_win_creds < DEF_WIN_CREDS) {
+			pr_err("Window creds(%u) > max allowed window creds(%u)\n",
+			       DEF_WIN_CREDS, caps->max_win_creds);
+			return -EINVAL;
+		}
+	}
+
+	copypaste_feat = true;
+
+	return 0;
+}
+
+static int __init pseries_vas_init(void)
+{
+	struct hv_vas_ct_caps *hv_ct_caps;
+	struct hv_vas_all_caps *hv_caps;
+	int rc;
+
+	/*
+	 * Linux supports user space COPY/PASTE only with Radix
+	 */
+	if (!radix_enabled()) {
+		pr_err("API is supported only with radix page tables\n");
+		return -ENOTSUPP;
+	}
+
+	hv_caps = kmalloc(sizeof(*hv_caps), GFP_KERNEL);
+	if (!hv_caps)
+		return -ENOMEM;
+	/*
+	 * Get VAS overall capabilities by passing 0 to feature type.
+	 */
+	rc = h_query_vas_capabilities(H_QUERY_VAS_CAPABILITIES, 0,
+					  (u64)virt_to_phys(hv_caps));
+	if (rc)
+		goto out;
+
+	caps_all.descriptor = be64_to_cpu(hv_caps->descriptor);
+	caps_all.feat_type = be64_to_cpu(hv_caps->feat_type);
+
+	hv_ct_caps = kmalloc(sizeof(*hv_ct_caps), GFP_KERNEL);
+	if (!hv_ct_caps) {
+		rc = -ENOMEM;
+		goto out;
+	}
+	/*
+	 * QOS capabilities available
+	 */
+	if (caps_all.feat_type & VAS_GZIP_QOS_FEAT_BIT) {
+		rc = get_vas_capabilities(VAS_GZIP_QOS_FEAT,
+					  VAS_GZIP_QOS_FEAT_TYPE, hv_ct_caps);
+
+		if (rc)
+			goto out_ct;
+	}
+	/*
+	 * Default capabilities available
+	 */
+	if (caps_all.feat_type & VAS_GZIP_DEF_FEAT_BIT) {
+		rc = get_vas_capabilities(VAS_GZIP_DEF_FEAT,
+					  VAS_GZIP_DEF_FEAT_TYPE, hv_ct_caps);
+		if (rc)
+			goto out_ct;
+	}
+
+	pr_info("GZIP feature is available\n");
+
+out_ct:
+	kfree(hv_ct_caps);
+out:
+	kfree(hv_caps);
+	return rc;
+}
+machine_device_initcall(pseries, pseries_vas_init);
-- 
2.18.2


