Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 99BAAC433ED
	for <linux-crypto@archiver.kernel.org>; Tue, 13 Apr 2021 08:25:48 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 7E0F361369
	for <linux-crypto@archiver.kernel.org>; Tue, 13 Apr 2021 08:25:48 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229590AbhDMI0H (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Tue, 13 Apr 2021 04:26:07 -0400
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:50052 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S229379AbhDMI0G (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 13 Apr 2021 04:26:06 -0400
Received: from pps.filterd (m0098413.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 13D83Kuc125641;
        Tue, 13 Apr 2021 04:25:39 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=message-id : subject :
 from : to : cc : date : in-reply-to : references : content-type :
 mime-version : content-transfer-encoding; s=pp1;
 bh=aJ6vjjC786MTHJjzsddAsFQowBXH0hlUgF+uJXi8Epo=;
 b=Ce/oQH9Ac0OvAMjazStzjczTFNXb9fCiQASfaVHuwsBUrYuMs2JNp9QewaWs54Ta60bN
 poPBRfzMq5I5sQORT9SQiU7WB8XfcdibcQ7/UAY4fbf03MbPNS3he86ulWdjYNy7Voml
 i8pZsUVoQ4Fgb8zpe1UIVVcWhMBxK+MwsGD8RDEob/uts4xgNjIOvtki187OTR58AW/u
 XpcwmNGlYwEwSmBC2pPL0J7K6Bzlq7f6QGQk+EH3SffmCzkCqCuH+hjUYydnf14J+eFA
 OZwTJMQCOqjqtS49gAlr7j1AdudOZmsMxkN17ekey6NBdumcwGGBZv+M/C5eOz3RTeei PQ== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0b-001b2d01.pphosted.com with ESMTP id 37vk4ja1uy-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 13 Apr 2021 04:25:39 -0400
Received: from m0098413.ppops.net (m0098413.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 13D84dtD130502;
        Tue, 13 Apr 2021 04:25:39 -0400
Received: from ppma03dal.us.ibm.com (b.bd.3ea9.ip4.static.sl-reverse.com [169.62.189.11])
        by mx0b-001b2d01.pphosted.com with ESMTP id 37vk4ja1un-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 13 Apr 2021 04:25:38 -0400
Received: from pps.filterd (ppma03dal.us.ibm.com [127.0.0.1])
        by ppma03dal.us.ibm.com (8.16.0.43/8.16.0.43) with SMTP id 13D8Mxg2012907;
        Tue, 13 Apr 2021 08:25:38 GMT
Received: from b03cxnp08027.gho.boulder.ibm.com (b03cxnp08027.gho.boulder.ibm.com [9.17.130.19])
        by ppma03dal.us.ibm.com with ESMTP id 37u3n94vu2-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 13 Apr 2021 08:25:38 +0000
Received: from b03ledav002.gho.boulder.ibm.com (b03ledav002.gho.boulder.ibm.com [9.17.130.233])
        by b03cxnp08027.gho.boulder.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 13D8PbFZ62783818
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 13 Apr 2021 08:25:37 GMT
Received: from b03ledav002.gho.boulder.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id ED80F136055;
        Tue, 13 Apr 2021 08:25:36 +0000 (GMT)
Received: from b03ledav002.gho.boulder.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id B49D0136053;
        Tue, 13 Apr 2021 08:25:35 +0000 (GMT)
Received: from localhost.localdomain (unknown [9.80.232.48])
        by b03ledav002.gho.boulder.ibm.com (Postfix) with ESMTP;
        Tue, 13 Apr 2021 08:25:35 +0000 (GMT)
Message-ID: <942d6399b4f5eda9c8a3b7b277fd9f33be39c7f7.camel@linux.ibm.com>
Subject: [V2 PATCH 09/16] powerpc/pseries/vas: Implement to get all
 capabilities
From:   Haren Myneni <haren@linux.ibm.com>
To:     linuxppc-dev@lists.ozlabs.org, linux-crypto@vger.kernel.org,
        mpe@ellerman.id.au, herbert@gondor.apana.org.au, npiggin@gmail.com
Cc:     hbabu@us.ibm.com
Date:   Tue, 13 Apr 2021 01:25:33 -0700
In-Reply-To: <68aa9f2860f9acffa41469d3858883c938634722.camel@linux.ibm.com>
References: <68aa9f2860f9acffa41469d3858883c938634722.camel@linux.ibm.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.36.2 (3.36.2-1.fc32) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: Lt6qhSuOe6Iri5zUxmo9qZ8xnaq5WIJ4
X-Proofpoint-GUID: NvW3s52ZkZJ0shoawpM72T6ToCXgj0By
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.391,18.0.761
 definitions=2021-04-13_03:2021-04-13,2021-04-13 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 adultscore=0 mlxscore=0
 lowpriorityscore=0 priorityscore=1501 spamscore=0 suspectscore=0
 bulkscore=0 mlxlogscore=999 impostorscore=0 phishscore=0 clxscore=1015
 malwarescore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2104060000 definitions=main-2104130055
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org


pHyp provides various VAS capabilities such as GZIP default and QoS
capabilities which are used to determine total number of credits
available in LPAR, maximum window credits, maximum LPAR credits,
whether usermode copy/paste is supported, and etc.

So first retrieve overall vas capabilities using
H_QUERY_VAS_CAPABILITIES HCALL which tells the specific features that
are available. Then retrieve the specific capabilities by using the
feature type in H_QUERY_VAS_CAPABILITIES HCALL.

pHyp supports only GZIP default and GZIP QoS capabilities right now.

Signed-off-by: Haren Myneni <haren@linux.ibm.com>
---
 arch/powerpc/platforms/pseries/vas.c | 130 +++++++++++++++++++++++++++
 1 file changed, 130 insertions(+)

diff --git a/arch/powerpc/platforms/pseries/vas.c b/arch/powerpc/platforms/pseries/vas.c
index 06960151477c..35946fb02995 100644
--- a/arch/powerpc/platforms/pseries/vas.c
+++ b/arch/powerpc/platforms/pseries/vas.c
@@ -30,6 +30,13 @@
 /* phyp allows one credit per window right now */
 #define DEF_WIN_CREDS		1
 
+static struct vas_all_capabs capabs_all;
+static int copypaste_feat;
+
+struct vas_capabs vcapabs[VAS_MAX_FEAT_TYPE];
+
+DEFINE_MUTEX(vas_pseries_mutex);
+
 static int64_t hcall_return_busy_check(int64_t rc)
 {
 	/* Check if we are stalled for some time */
@@ -215,3 +222,126 @@ int plpar_vas_query_capabilities(const u64 hcall, u8 query_type,
 		return -EIO;
 	}
 }
+
+/*
+ * Get the specific capabilities based on the feature type.
+ * Right now supports GZIP default and GZIP QoS capabilities.
+ */
+static int get_vas_capabilities(u8 feat, enum vas_cop_feat_type type,
+				struct vas_ct_capabs_be *capab_be)
+{
+	struct vas_ct_capabs *capab;
+	struct vas_capabs *vcapab;
+	int rc = 0;
+
+	vcapab = &vcapabs[type];
+	memset(vcapab, 0, sizeof(*vcapab));
+	INIT_LIST_HEAD(&vcapab->list);
+
+	capab = &vcapab->capab;
+
+	rc = plpar_vas_query_capabilities(H_QUERY_VAS_CAPABILITIES, feat,
+					  (u64)virt_to_phys(capab_be));
+	if (rc)
+		return rc;
+
+	capab->user_mode = capab_be->user_mode;
+	if (!(capab->user_mode & VAS_COPY_PASTE_USER_MODE)) {
+		pr_err("User space COPY/PASTE is not supported\n");
+		return -ENOTSUPP;
+	}
+
+	snprintf(capab->name, VAS_DESCR_LEN + 1, "%.8s",
+		 (char *)&capab_be->descriptor);
+	capab->descriptor = be64_to_cpu(capab_be->descriptor);
+	capab->win_type = capab_be->win_type;
+	if (capab->win_type >= VAS_MAX_FEAT_TYPE) {
+		pr_err("Unsupported window type %u\n", capab->win_type);
+		return -EINVAL;
+	}
+	capab->max_lpar_creds = be16_to_cpu(capab_be->max_lpar_creds);
+	capab->max_win_creds = be16_to_cpu(capab_be->max_win_creds);
+	atomic_set(&capab->target_lpar_creds,
+		   be16_to_cpu(capab_be->target_lpar_creds));
+	if (feat == VAS_GZIP_DEF_FEAT) {
+		capab->def_lpar_creds = be16_to_cpu(capab_be->def_lpar_creds);
+
+		if (capab->max_win_creds < DEF_WIN_CREDS) {
+			pr_err("Window creds(%u) > max allowed window creds(%u)\n",
+			       DEF_WIN_CREDS, capab->max_win_creds);
+			return -EINVAL;
+		}
+	}
+
+	copypaste_feat = 1;
+
+	return 0;
+}
+
+static int __init pseries_vas_init(void)
+{
+	struct vas_ct_capabs_be *ct_capabs_be;
+	struct vas_all_capabs_be *capabs_be;
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
+	capabs_be = kmalloc(sizeof(*capabs_be), GFP_KERNEL);
+	if (!capabs_be)
+		return -ENOMEM;
+	/*
+	 * Get VAS overall capabilities by passing 0 to feature type.
+	 */
+	rc = plpar_vas_query_capabilities(H_QUERY_VAS_CAPABILITIES, 0,
+					  (u64)virt_to_phys(capabs_be));
+	if (rc)
+		goto out;
+
+	snprintf(capabs_all.name, VAS_DESCR_LEN, "%.7s",
+		 (char *)&capabs_be->descriptor);
+	capabs_all.descriptor = be64_to_cpu(capabs_be->descriptor);
+	capabs_all.feat_type = be64_to_cpu(capabs_be->feat_type);
+
+	ct_capabs_be = kmalloc(sizeof(*ct_capabs_be), GFP_KERNEL);
+	if (!ct_capabs_be) {
+		rc = -ENOMEM;
+		goto out;
+	}
+	/*
+	 * QOS capabilities available
+	 */
+	if (capabs_all.feat_type & VAS_GZIP_QOS_FEAT_BIT) {
+		rc = get_vas_capabilities(VAS_GZIP_QOS_FEAT,
+					  VAS_GZIP_QOS_FEAT_TYPE, ct_capabs_be);
+
+		if (rc)
+			goto out_ct;
+	}
+	/*
+	 * Default capabilities available
+	 */
+	if (capabs_all.feat_type & VAS_GZIP_DEF_FEAT_BIT) {
+		rc = get_vas_capabilities(VAS_GZIP_DEF_FEAT,
+					  VAS_GZIP_DEF_FEAT_TYPE, ct_capabs_be);
+		if (rc)
+			goto out_ct;
+	}
+
+	if (!copypaste_feat)
+		pr_err("GZIP feature is not supported\n");
+
+	pr_info("GZIP feature is available\n");
+
+out_ct:
+	kfree(ct_capabs_be);
+out:
+	kfree(capabs_be);
+	return rc;
+}
+machine_device_initcall(pseries, pseries_vas_init);
-- 
2.18.2


