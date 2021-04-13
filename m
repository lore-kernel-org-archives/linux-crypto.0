Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D73E1C433B4
	for <linux-crypto@archiver.kernel.org>; Tue, 13 Apr 2021 08:31:01 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id A925B613D8
	for <linux-crypto@archiver.kernel.org>; Tue, 13 Apr 2021 08:31:01 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229961AbhDMIbU (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Tue, 13 Apr 2021 04:31:20 -0400
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:19434 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229898AbhDMIbT (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 13 Apr 2021 04:31:19 -0400
Received: from pps.filterd (m0098393.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 13D83AKm084469;
        Tue, 13 Apr 2021 04:30:53 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=message-id : subject :
 from : to : cc : date : in-reply-to : references : content-type :
 mime-version : content-transfer-encoding; s=pp1;
 bh=QtHIP9dLzxxRRuIHGRlAtB+wH86pg3rz8isJQCt4K5Q=;
 b=ARdzRvsMBnj7+sD1BVmP8ZVgbhgPKENk6yTPzYborhRByfE2SGHNt1KWRrv8rQqzGz1M
 Y20jX2Xye9WpEyr6N0JtuClWDAl/ZHEZO5qHcR1x2ioX5uTVEVODfbBPC0nR2S90mIij
 KKCrswNA3GzOOxg+1cxQsPIGWgw3LyCGtbuueZ0y9C9VccDtaJsWYTWaR8MA0itSYlWj
 3mn3mLUh3yJf/f4czLbBQXGtf0NDBB9Os67/cMSp5F1jURgzhsmPgBVUBRhVKgJayyXW
 +3cPlOKxbQLzFHSCXxD/qphM2GHAgavZT5I+eH1Q7NELYJ1cm4XABhrVRzx6e+tR2/mD lA== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 37vkpjj36y-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 13 Apr 2021 04:30:53 -0400
Received: from m0098393.ppops.net (m0098393.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 13D8H1n7133579;
        Tue, 13 Apr 2021 04:30:53 -0400
Received: from ppma01wdc.us.ibm.com (fd.55.37a9.ip4.static.sl-reverse.com [169.55.85.253])
        by mx0a-001b2d01.pphosted.com with ESMTP id 37vkpjj360-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 13 Apr 2021 04:30:52 -0400
Received: from pps.filterd (ppma01wdc.us.ibm.com [127.0.0.1])
        by ppma01wdc.us.ibm.com (8.16.0.43/8.16.0.43) with SMTP id 13D8SNmG010830;
        Tue, 13 Apr 2021 08:30:51 GMT
Received: from b03cxnp08028.gho.boulder.ibm.com (b03cxnp08028.gho.boulder.ibm.com [9.17.130.20])
        by ppma01wdc.us.ibm.com with ESMTP id 37u3n974t1-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 13 Apr 2021 08:30:51 +0000
Received: from b03ledav005.gho.boulder.ibm.com (b03ledav005.gho.boulder.ibm.com [9.17.130.236])
        by b03cxnp08028.gho.boulder.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 13D8UoHI34079094
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 13 Apr 2021 08:30:50 GMT
Received: from b03ledav005.gho.boulder.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 98846BE056;
        Tue, 13 Apr 2021 08:30:50 +0000 (GMT)
Received: from b03ledav005.gho.boulder.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 5F25ABE04F;
        Tue, 13 Apr 2021 08:30:49 +0000 (GMT)
Received: from localhost.localdomain (unknown [9.80.232.48])
        by b03ledav005.gho.boulder.ibm.com (Postfix) with ESMTP;
        Tue, 13 Apr 2021 08:30:49 +0000 (GMT)
Message-ID: <7f37374884abdab3e6079b1cc0ad0736c0db97ae.camel@linux.ibm.com>
Subject: [V2 PATCH 16/16] crypto/nx: Add sysfs interface to export NX
 capabilities
From:   Haren Myneni <haren@linux.ibm.com>
To:     linuxppc-dev@lists.ozlabs.org, linux-crypto@vger.kernel.org,
        mpe@ellerman.id.au, herbert@gondor.apana.org.au, npiggin@gmail.com
Cc:     hbabu@us.ibm.com
Date:   Tue, 13 Apr 2021 01:30:47 -0700
In-Reply-To: <68aa9f2860f9acffa41469d3858883c938634722.camel@linux.ibm.com>
References: <68aa9f2860f9acffa41469d3858883c938634722.camel@linux.ibm.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.36.2 (3.36.2-1.fc32) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: p67PIFjSLEV-Qxg1TaHiJg8E2ZZ3Rqzq
X-Proofpoint-ORIG-GUID: q4SNMbDdDu36MxJKY6giBEOxsTEgPVmh
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.391,18.0.761
 definitions=2021-04-13_03:2021-04-13,2021-04-13 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 suspectscore=0 spamscore=0
 impostorscore=0 malwarescore=0 mlxlogscore=999 mlxscore=0
 lowpriorityscore=0 clxscore=1015 adultscore=0 phishscore=0
 priorityscore=1501 bulkscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-2104060000 definitions=main-2104130055
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org


Changes to export the following NXGZIP capabilities through sysfs:

/sys/devices/vio/ibm,compression-v1/NxGzCaps:
min_compress_len  /*Recommended minimum compress length in bytes*/
min_decompress_len /*Recommended minimum decompress length in bytes*/
req_max_processed_len /* Maximum number of bytes processed in one
			request */

Signed-off-by: Haren Myneni <haren@linux.ibm.com>
---
 drivers/crypto/nx/nx-common-pseries.c | 43 +++++++++++++++++++++++++++
 1 file changed, 43 insertions(+)

diff --git a/drivers/crypto/nx/nx-common-pseries.c b/drivers/crypto/nx/nx-common-pseries.c
index 49224870d05e..cc258d2c6475 100644
--- a/drivers/crypto/nx/nx-common-pseries.c
+++ b/drivers/crypto/nx/nx-common-pseries.c
@@ -962,6 +962,36 @@ static struct attribute_group nx842_attribute_group = {
 	.attrs = nx842_sysfs_entries,
 };
 
+#define	nxct_capab_read(_name)						\
+static ssize_t nxct_##_name##_show(struct device *dev,			\
+			struct device_attribute *attr, char *buf)	\
+{									\
+	return sprintf(buf, "%lld\n", nx_ct_capab._name);		\
+}
+
+#define NXCT_ATTR_RO(_name)						\
+	nxct_capab_read(_name);						\
+	static struct device_attribute dev_attr_##_name = __ATTR(_name,	\
+						0444,			\
+						nxct_##_name##_show,	\
+						NULL);
+
+NXCT_ATTR_RO(req_max_processed_len);
+NXCT_ATTR_RO(min_compress_len);
+NXCT_ATTR_RO(min_decompress_len);
+
+static struct attribute *nxct_capab_sysfs_entries[] = {
+	&dev_attr_req_max_processed_len.attr,
+	&dev_attr_min_compress_len.attr,
+	&dev_attr_min_decompress_len.attr,
+	NULL,
+};
+
+static struct attribute_group nxct_capab_attr_group = {
+	.name	=	nx_ct_capab.name,
+	.attrs	=	nxct_capab_sysfs_entries,
+};
+
 static struct nx842_driver nx842_pseries_driver = {
 	.name =		KBUILD_MODNAME,
 	.owner =	THIS_MODULE,
@@ -1051,6 +1081,16 @@ static int nx842_probe(struct vio_dev *viodev,
 		goto error;
 	}
 
+	if (capab_feat) {
+		if (sysfs_create_group(&viodev->dev.kobj,
+					&nxct_capab_attr_group)) {
+			dev_err(&viodev->dev,
+				"Could not create sysfs NX capability entries\n");
+			ret = -1;
+			goto error;
+		}
+	}
+
 	return 0;
 
 error_unlock:
@@ -1070,6 +1110,9 @@ static void nx842_remove(struct vio_dev *viodev)
 	pr_info("Removing IBM Power 842 compression device\n");
 	sysfs_remove_group(&viodev->dev.kobj, &nx842_attribute_group);
 
+	if (capab_feat)
+		sysfs_remove_group(&viodev->dev.kobj, &nxct_capab_attr_group);
+
 	crypto_unregister_alg(&nx842_pseries_alg);
 
 	spin_lock_irqsave(&devdata_mutex, flags);
-- 
2.18.2


