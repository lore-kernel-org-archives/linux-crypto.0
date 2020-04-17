Return-Path: <SRS0=6qCq=6B=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_2 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BDBEAC352BE
	for <linux-crypto@archiver.kernel.org>; Fri, 17 Apr 2020 09:11:11 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id A24B1221E9
	for <linux-crypto@archiver.kernel.org>; Fri, 17 Apr 2020 09:11:11 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730105AbgDQJLL (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 17 Apr 2020 05:11:11 -0400
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:59980 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1730113AbgDQJLL (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 17 Apr 2020 05:11:11 -0400
Received: from pps.filterd (m0098409.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 03H93kPH029445;
        Fri, 17 Apr 2020 05:10:54 -0400
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 30f8hnj10a-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 17 Apr 2020 05:10:53 -0400
Received: from m0098409.ppops.net (m0098409.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.36/8.16.0.36) with SMTP id 03H95cKc035616;
        Fri, 17 Apr 2020 05:10:53 -0400
Received: from ppma02dal.us.ibm.com (a.bd.3ea9.ip4.static.sl-reverse.com [169.62.189.10])
        by mx0a-001b2d01.pphosted.com with ESMTP id 30f8hnj0yx-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 17 Apr 2020 05:10:53 -0400
Received: from pps.filterd (ppma02dal.us.ibm.com [127.0.0.1])
        by ppma02dal.us.ibm.com (8.16.0.27/8.16.0.27) with SMTP id 03H9A0Se002741;
        Fri, 17 Apr 2020 09:10:52 GMT
Received: from b03cxnp08027.gho.boulder.ibm.com (b03cxnp08027.gho.boulder.ibm.com [9.17.130.19])
        by ppma02dal.us.ibm.com with ESMTP id 30b5h7njwt-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 17 Apr 2020 09:10:52 +0000
Received: from b03ledav001.gho.boulder.ibm.com (b03ledav001.gho.boulder.ibm.com [9.17.130.232])
        by b03cxnp08027.gho.boulder.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 03H9Ap8A59441460
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 17 Apr 2020 09:10:51 GMT
Received: from b03ledav001.gho.boulder.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 789006E04E;
        Fri, 17 Apr 2020 09:10:51 +0000 (GMT)
Received: from b03ledav001.gho.boulder.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id EA9F96E04C;
        Fri, 17 Apr 2020 09:10:50 +0000 (GMT)
Received: from [9.70.82.143] (unknown [9.70.82.143])
        by b03ledav001.gho.boulder.ibm.com (Postfix) with ESMTP;
        Fri, 17 Apr 2020 09:10:50 +0000 (GMT)
Subject: [PATCH v6 7/9] crypto/nx: Enable and setup GZIP compression type
From:   Haren Myneni <haren@linux.ibm.com>
To:     mpe@ellerman.id.au
Cc:     herbert@gondor.apana.org.au, mikey@neuling.org, npiggin@gmail.com,
        linux-crypto@vger.kernel.org, sukadev@linux.vnet.ibm.com,
        linuxppc-dev@lists.ozlabs.org, dja@axtens.net
In-Reply-To: <1587113732.2275.1096.camel@hbabu-laptop>
References: <1587113732.2275.1096.camel@hbabu-laptop>
Content-Type: text/plain; charset="UTF-8"
Date:   Fri, 17 Apr 2020 02:10:24 -0700
Message-ID: <1587114624.2275.1129.camel@hbabu-laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.138,18.0.676
 definitions=2020-04-17_03:2020-04-14,2020-04-17 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 priorityscore=1501
 lowpriorityscore=0 impostorscore=0 adultscore=0 malwarescore=0
 clxscore=1015 spamscore=0 mlxscore=0 bulkscore=0 mlxlogscore=999
 phishscore=0 suspectscore=1 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-2003020000 definitions=main-2004170067
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org


Changes to probe GZIP device-tree nodes, open RX windows and setup
GZIP compression type. No plans to provide GZIP usage in kernel right
now, but this patch enables GZIP for user space usage.

Signed-off-by: Haren Myneni <haren@linux.ibm.com>
Acked-by: Herbert Xu <herbert@gondor.apana.org.au>
---
 drivers/crypto/nx/nx-common-powernv.c | 46 ++++++++++++++++++++++++++++++-----
 1 file changed, 40 insertions(+), 6 deletions(-)

diff --git a/drivers/crypto/nx/nx-common-powernv.c b/drivers/crypto/nx/nx-common-powernv.c
index 82dfa60..651d286 100644
--- a/drivers/crypto/nx/nx-common-powernv.c
+++ b/drivers/crypto/nx/nx-common-powernv.c
@@ -65,6 +65,7 @@ struct nx_coproc {
  * Using same values as in skiboot or coprocessor type representing
  * in NX workbook.
  */
+#define NX_CT_GZIP	(2)	/* on P9 and later */
 #define NX_CT_842	(3)
 
 static int (*nx842_powernv_exec)(const unsigned char *in,
@@ -819,6 +820,9 @@ static int __init vas_cfg_coproc_info(struct device_node *dn, int chip_id,
 	if (type == NX_CT_842)
 		ret = nx_set_ct(coproc, priority, VAS_COP_TYPE_842_HIPRI,
 			VAS_COP_TYPE_842);
+	else if (type == NX_CT_GZIP)
+		ret = nx_set_ct(coproc, priority, VAS_COP_TYPE_GZIP_HIPRI,
+				VAS_COP_TYPE_GZIP);
 
 	if (ret)
 		goto err_out;
@@ -867,12 +871,16 @@ static int __init vas_cfg_coproc_info(struct device_node *dn, int chip_id,
 	return ret;
 }
 
-static int __init nx_coproc_init(int chip_id, int ct_842)
+static int __init nx_coproc_init(int chip_id, int ct_842, int ct_gzip)
 {
 	int ret = 0;
 
 	if (opal_check_token(OPAL_NX_COPROC_INIT)) {
 		ret = opal_nx_coproc_init(chip_id, ct_842);
+
+		if (!ret)
+			ret = opal_nx_coproc_init(chip_id, ct_gzip);
+
 		if (ret) {
 			ret = opal_error_code(ret);
 			pr_err("Failed to initialize NX for chip(%d): %d\n",
@@ -902,8 +910,8 @@ static int __init find_nx_device_tree(struct device_node *dn, int chip_id,
 static int __init nx_powernv_probe_vas(struct device_node *pn)
 {
 	int chip_id, vasid, ret = 0;
+	int ct_842 = 0, ct_gzip = 0;
 	struct device_node *dn;
-	int ct_842 = 0;
 
 	chip_id = of_get_ibm_chip_id(pn);
 	if (chip_id < 0) {
@@ -920,19 +928,24 @@ static int __init nx_powernv_probe_vas(struct device_node *pn)
 	for_each_child_of_node(pn, dn) {
 		ret = find_nx_device_tree(dn, chip_id, vasid, NX_CT_842,
 					"ibm,p9-nx-842", &ct_842);
+
+		if (!ret)
+			ret = find_nx_device_tree(dn, chip_id, vasid,
+				NX_CT_GZIP, "ibm,p9-nx-gzip", &ct_gzip);
+
 		if (ret)
 			return ret;
 	}
 
-	if (!ct_842) {
-		pr_err("NX842 FIFO nodes are missing\n");
+	if (!ct_842 || !ct_gzip) {
+		pr_err("NX FIFO nodes are missing\n");
 		return -EINVAL;
 	}
 
 	/*
 	 * Initialize NX instance for both high and normal priority FIFOs.
 	 */
-	ret = nx_coproc_init(chip_id, ct_842);
+	ret = nx_coproc_init(chip_id, ct_842, ct_gzip);
 
 	return ret;
 }
@@ -1072,10 +1085,22 @@ static __init int nx_compress_powernv_init(void)
 		nx842_powernv_exec = nx842_exec_icswx;
 	} else {
 		/*
+		 * Register VAS user space API for NX GZIP so
+		 * that user space can use GZIP engine.
+		 * Using high FIFO priority for kernel requests and
+		 * normal FIFO priority is assigned for userspace.
+		 * 842 compression is supported only in kernel.
+		 */
+		ret = vas_register_coproc_api(THIS_MODULE, VAS_COP_TYPE_GZIP,
+						"nx-gzip");
+
+		/*
 		 * GZIP is not supported in kernel right now.
 		 * So open tx windows only for 842.
 		 */
-		ret = nx_open_percpu_txwins();
+		if (!ret)
+			ret = nx_open_percpu_txwins();
+
 		if (ret) {
 			nx_delete_coprocs();
 			return ret;
@@ -1096,6 +1121,15 @@ static __init int nx_compress_powernv_init(void)
 
 static void __exit nx_compress_powernv_exit(void)
 {
+	/*
+	 * GZIP engine is supported only in power9 or later and nx842_ct
+	 * is used on power8 (icswx).
+	 * VAS API for NX GZIP is registered during init for user space
+	 * use. So delete this API use for GZIP engine.
+	 */
+	if (!nx842_ct)
+		vas_unregister_coproc_api();
+
 	crypto_unregister_alg(&nx842_powernv_alg);
 
 	nx_delete_coprocs();
-- 
1.8.3.1



