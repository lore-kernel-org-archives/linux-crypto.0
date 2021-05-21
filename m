Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CABB2C433ED
	for <linux-crypto@archiver.kernel.org>; Fri, 21 May 2021 09:43:10 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id A59BA613C4
	for <linux-crypto@archiver.kernel.org>; Fri, 21 May 2021 09:43:10 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236912AbhEUJoa (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 21 May 2021 05:44:30 -0400
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:2196 "EHLO
        mx0b-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S236954AbhEUJoM (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 21 May 2021 05:44:12 -0400
Received: from pps.filterd (m0098421.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 14L9gM11040898;
        Fri, 21 May 2021 05:42:42 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=message-id : subject :
 from : to : cc : date : in-reply-to : references : content-type :
 mime-version : content-transfer-encoding; s=pp1;
 bh=tOdk986/BuOlfwtkGw442SOZevdwmQZA5sQ8AP7w6nY=;
 b=OMTtKAWzxiAETMZdQs+2sB5oVMkXKOJwBO5hqy/kJDs0QiycWB8zpZWxTS5QbUdAUJPf
 WqzvEqlo2fRlpTZ6CH8t9MWf9u5w33EDUDzyJ3UvxPLGul1dHaHvABmMNtABhX5GUmA9
 on7s/1VEJL/rvjhBbXRNTJiBzzp3WuRvP5o73Yd/TRctIs0dholBDam3/jNsanaOyweS
 lE9FbJpu65xQ7MTHRr032UJP1Xk05UfY+elEAePGeObyjJJue6XMjaJqVWEdUucP+MVj
 n/i0NJocBt8huEw/KeLa5cJNt96MRxEJwBTR7CjXSfoA5VElXEjrh1+gKlS7aQUsPmfI 4g== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 38p8wvjbny-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 21 May 2021 05:42:42 -0400
Received: from m0098421.ppops.net (m0098421.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 14L9gg2o042267;
        Fri, 21 May 2021 05:42:42 -0400
Received: from ppma03dal.us.ibm.com (b.bd.3ea9.ip4.static.sl-reverse.com [169.62.189.11])
        by mx0a-001b2d01.pphosted.com with ESMTP id 38p8wvjbnt-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 21 May 2021 05:42:42 -0400
Received: from pps.filterd (ppma03dal.us.ibm.com [127.0.0.1])
        by ppma03dal.us.ibm.com (8.16.0.43/8.16.0.43) with SMTP id 14L9YMqd007692;
        Fri, 21 May 2021 09:42:41 GMT
Received: from b01cxnp22035.gho.pok.ibm.com (b01cxnp22035.gho.pok.ibm.com [9.57.198.25])
        by ppma03dal.us.ibm.com with ESMTP id 38j5xaa8m0-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 21 May 2021 09:42:41 +0000
Received: from b01ledav004.gho.pok.ibm.com (b01ledav004.gho.pok.ibm.com [9.57.199.109])
        by b01cxnp22035.gho.pok.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 14L9geiD33751546
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 21 May 2021 09:42:40 GMT
Received: from b01ledav004.gho.pok.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id A405A112062;
        Fri, 21 May 2021 09:42:40 +0000 (GMT)
Received: from b01ledav004.gho.pok.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id A3E3F112061;
        Fri, 21 May 2021 09:42:39 +0000 (GMT)
Received: from sig-9-65-94-165.ibm.com (unknown [9.65.94.165])
        by b01ledav004.gho.pok.ibm.com (Postfix) with ESMTP;
        Fri, 21 May 2021 09:42:39 +0000 (GMT)
Message-ID: <35bca44c5a8af7bdffbe03b22fd82713bced8d0e.camel@linux.ibm.com>
Subject: [PATCH v4 16/16] crypto/nx: Add sysfs interface to export NX
 capabilities
From:   Haren Myneni <haren@linux.ibm.com>
To:     linuxppc-dev@lists.ozlabs.org, linux-crypto@vger.kernel.org,
        mpe@ellerman.id.au, herbert@gondor.apana.org.au, npiggin@gmail.com
Cc:     hbabu@us.ibm.com, haren@us.ibm.com
Date:   Fri, 21 May 2021 02:42:37 -0700
In-Reply-To: <8d219c0816133a8643d650709066cf04c9c77322.camel@linux.ibm.com>
References: <8d219c0816133a8643d650709066cf04c9c77322.camel@linux.ibm.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.36.2 (3.36.2-1.fc32) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: utbOSzOp0QqEut9rGVxhvAQB18XlImms
X-Proofpoint-ORIG-GUID: tN5eMp1jtk6mAYs3WFwwYpFsEUgIzMc5
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.391,18.0.761
 definitions=2021-05-21_03:2021-05-20,2021-05-21 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 spamscore=0 phishscore=0
 malwarescore=0 priorityscore=1501 suspectscore=0 bulkscore=0 mlxscore=0
 adultscore=0 impostorscore=0 mlxlogscore=999 clxscore=1015
 lowpriorityscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2104190000 definitions=main-2105210061
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org


Changes to export the following NXGZIP capabilities through sysfs:

/sys/devices/vio/ibm,compression-v1/NxGzCaps:
min_compress_len  /*Recommended minimum compress length in bytes*/
min_decompress_len /*Recommended minimum decompress length in bytes*/
req_max_processed_len /* Maximum number of bytes processed in one
			request */

NX will return RMA_Reject if the request buffer size is greater
than req_max_processed_len.

Signed-off-by: Haren Myneni <haren@linux.ibm.com>
Acked-by: Herbert Xu <herbert@gondor.apana.org.au>
---
 drivers/crypto/nx/nx-common-pseries.c | 43 +++++++++++++++++++++++++++
 1 file changed, 43 insertions(+)

diff --git a/drivers/crypto/nx/nx-common-pseries.c b/drivers/crypto/nx/nx-common-pseries.c
index 4a7278464156..121718a337fd 100644
--- a/drivers/crypto/nx/nx-common-pseries.c
+++ b/drivers/crypto/nx/nx-common-pseries.c
@@ -968,6 +968,36 @@ static struct attribute_group nx842_attribute_group = {
 	.attrs = nx842_sysfs_entries,
 };
 
+#define	nxct_caps_read(_name)						\
+static ssize_t nxct_##_name##_show(struct device *dev,			\
+			struct device_attribute *attr, char *buf)	\
+{									\
+	return sprintf(buf, "%lld\n", nx_ct_caps._name);		\
+}
+
+#define NXCT_ATTR_RO(_name)						\
+	nxct_caps_read(_name);						\
+	static struct device_attribute dev_attr_##_name = __ATTR(_name,	\
+						0444,			\
+						nxct_##_name##_show,	\
+						NULL);
+
+NXCT_ATTR_RO(req_max_processed_len);
+NXCT_ATTR_RO(min_compress_len);
+NXCT_ATTR_RO(min_decompress_len);
+
+static struct attribute *nxct_caps_sysfs_entries[] = {
+	&dev_attr_req_max_processed_len.attr,
+	&dev_attr_min_compress_len.attr,
+	&dev_attr_min_decompress_len.attr,
+	NULL,
+};
+
+static struct attribute_group nxct_caps_attr_group = {
+	.name	=	nx_ct_caps.name,
+	.attrs	=	nxct_caps_sysfs_entries,
+};
+
 static struct nx842_driver nx842_pseries_driver = {
 	.name =		KBUILD_MODNAME,
 	.owner =	THIS_MODULE,
@@ -1057,6 +1087,16 @@ static int nx842_probe(struct vio_dev *viodev,
 		goto error;
 	}
 
+	if (caps_feat) {
+		if (sysfs_create_group(&viodev->dev.kobj,
+					&nxct_caps_attr_group)) {
+			dev_err(&viodev->dev,
+				"Could not create sysfs NX capability entries\n");
+			ret = -1;
+			goto error;
+		}
+	}
+
 	return 0;
 
 error_unlock:
@@ -1076,6 +1116,9 @@ static void nx842_remove(struct vio_dev *viodev)
 	pr_info("Removing IBM Power 842 compression device\n");
 	sysfs_remove_group(&viodev->dev.kobj, &nx842_attribute_group);
 
+	if (caps_feat)
+		sysfs_remove_group(&viodev->dev.kobj, &nxct_caps_attr_group);
+
 	crypto_unregister_alg(&nx842_pseries_alg);
 
 	spin_lock_irqsave(&devdata_mutex, flags);
-- 
2.18.2


